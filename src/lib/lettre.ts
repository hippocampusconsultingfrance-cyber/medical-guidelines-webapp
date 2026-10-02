import "server-only";
import type { SupabaseClient } from "@supabase/supabase-js";
import { metaOf, shortOf, titleOf, updateDetail, type AlertDocument } from "@/lib/alertes";
import type { OutgoingEmail } from "@/lib/email";
import { escapeHtml } from "@/lib/fiches";

// Lettre mensuelle de veille (cahier des charges §8, routine « veille
// mensuelle ») : nouvelles fiches publiées et fiches mises à jour pendant le
// mois, envoyées aux membres PREMIUM de chaque spécialité après relecture et
// validation par un administrateur (/bibliotheque/veille). Chaque envoi est
// inscrit dans notifications_log (body « lettre:AAAA-MM ») : un membre ne
// reçoit jamais deux fois la lettre d'un même mois.

export type LettreDoc = AlertDocument & { specialties: string[] };

export type Lettre = {
  mois: string;
  news: LettreDoc[];
  updates: LettreDoc[];
};

export type Destinataire = {
  userId: string;
  email: string;
  prenom: string | null;
  alertsToken: string;
  specialtyId: string | null;
};

const MOIS = ["janvier", "février", "mars", "avril", "mai", "juin", "juillet", "août", "septembre", "octobre", "novembre", "décembre"];

export function moisValide(value: unknown): value is string {
  return typeof value === "string" && /^\d{4}-(0[1-9]|1[0-2])$/.test(value);
}

export function libelleMois(mois: string) {
  const [y, m] = mois.split("-").map(Number);
  return `${MOIS[m - 1]} ${y}`;
}

export function logBody(mois: string) {
  return `lettre:${mois}`;
}

function bornes(mois: string) {
  const [y, m] = mois.split("-").map(Number);
  return { debut: new Date(Date.UTC(y, m - 1, 1)).toISOString(), fin: new Date(Date.UTC(y, m, 1)).toISOString() };
}

type Row = {
  id: string;
  title: string;
  card_json: AlertDocument["card_json"];
  publication_date: string | null;
  source_url: string | null;
  freshness_status: string | null;
  published_at: string | null;
  document_societies: { societies: { acronym: string } | { acronym: string }[] | null }[] | null;
  document_specialties: { specialty_id: string }[] | null;
};

const SELECT =
  "id, title, card_json, publication_date, source_url, freshness_status, published_at, document_societies(societies(acronym)), document_specialties(specialty_id)";

function toDoc(r: Row, version: AlertDocument["version"]): LettreDoc {
  return {
    id: r.id,
    title: r.title,
    card_json: r.card_json,
    publication_date: r.publication_date,
    source_url: r.source_url,
    societies: (r.document_societies ?? [])
      .flatMap((l) => (Array.isArray(l.societies) ? l.societies : l.societies ? [l.societies] : []))
      .map((s) => s.acronym),
    specialties: (r.document_specialties ?? []).map((s) => s.specialty_id),
    version,
  };
}

// Fiches du mois (clé service_role : lecture de toutes les fiches publiées).
export async function chargerLettre(admin: SupabaseClient, mois: string): Promise<Lettre> {
  const { debut, fin } = bornes(mois);
  const [{ data: nouvelles, error: e1 }, { data: versions, error: e2 }] = await Promise.all([
    admin.from("documents").select(SELECT).gte("published_at", debut).lt("published_at", fin).order("published_at"),
    admin
      .from("document_versions")
      .select("document_id, version_label, diff_summary, published_at")
      .gte("published_at", debut)
      .lt("published_at", fin)
      .order("published_at", { ascending: false }),
  ]);
  if (e1 || e2) throw new Error(`Lecture des fiches du mois impossible : ${(e1 ?? e2)?.message}`);

  const news = ((nouvelles ?? []) as unknown as Row[])
    .filter((r) => r.freshness_status !== "retiree")
    .map((r) => toDoc(r, null));

  // Mises à jour : dernière version publiée du mois, pour une fiche en ligne
  // qui n'est pas déjà annoncée comme nouvelle.
  type Version = { document_id: string; version_label: string; diff_summary: string | null };
  const latest = new Map<string, Version>();
  for (const v of (versions ?? []) as Version[]) if (!latest.has(v.document_id)) latest.set(v.document_id, v);
  const newIds = new Set(news.map((d) => d.id));
  const ids = [...latest.keys()].filter((id) => !newIds.has(id));
  let updates: LettreDoc[] = [];
  if (ids.length) {
    const { data, error } = await admin.from("documents").select(SELECT).in("id", ids);
    if (error) throw new Error(`Lecture des fiches mises à jour impossible : ${error.message}`);
    updates = ((data ?? []) as unknown as Row[])
      .filter((r) => r.published_at && r.freshness_status !== "retiree")
      .map((r) => toDoc(r, latest.get(r.id) ?? null));
  }
  return { mois, news, updates };
}

// Membres PREMIUM (abonnement actif), adresse confirmée, alertes activées,
// qui n'ont pas encore reçu la lettre de ce mois.
export async function chargerDestinataires(admin: SupabaseClient, mois: string): Promise<Destinataire[]> {
  const now = Date.now();
  const [{ data: subs, error: e1 }, { data: sent, error: e2 }] = await Promise.all([
    admin.from("subscriptions").select("user_id, status, current_period_end").eq("status", "actif"),
    admin.from("notifications_log").select("user_id").eq("body", logBody(mois)),
  ]);
  if (e1 || e2) throw new Error(`Lecture des abonnés impossible : ${(e1 ?? e2)?.message}`);
  const dejaRecue = new Set((sent ?? []).map((s) => s.user_id as string));
  const premium = new Set(
    (subs ?? [])
      .filter((s) => !s.current_period_end || new Date(s.current_period_end as string).getTime() > now)
      .map((s) => s.user_id as string)
      .filter((id) => !dejaRecue.has(id)),
  );
  if (!premium.size) return [];

  const { data: profiles, error: e3 } = await admin
    .from("profiles")
    .select("id, prenom, alerts_token, specialty_id, email_alerts")
    .in("id", [...premium]);
  if (e3) throw new Error(`Lecture des profils impossible : ${e3.message}`);

  const out: Destinataire[] = [];
  for (const p of profiles ?? []) {
    if (!p.email_alerts || !p.alerts_token) continue;
    const { data } = await admin.auth.admin.getUserById(p.id as string);
    const u = data?.user;
    if (!u?.email || !u.email_confirmed_at) continue;
    out.push({
      userId: p.id as string,
      email: u.email,
      prenom: (p.prenom as string | null) || null,
      alertsToken: p.alerts_token as string,
      specialtyId: (p.specialty_id as string | null) ?? null,
    });
  }
  return out;
}

// Fiches de la lettre qui concernent une spécialité (toutes si non précisée).
export function pourSpecialite(lettre: Lettre, specialtyId: string | null) {
  const keep = (d: LettreDoc) => !specialtyId || d.specialties.includes(specialtyId);
  return { news: lettre.news.filter(keep), updates: lettre.updates.filter(keep) };
}

export function composerLettre(
  lettre: Lettre,
  dest: Pick<Destinataire, "email" | "prenom" | "alertsToken" | "specialtyId">,
  intro: string,
  site: string,
): OutgoingEmail | null {
  const { news, updates } = pourSpecialite(lettre, dest.specialtyId);
  if (!news.length && !updates.length) return null;

  const mois = libelleMois(lettre.mois);
  const subject = `Veille de ${mois} : ${news.length + updates.length} fiche${news.length + updates.length > 1 ? "s" : ""} pour vous`;
  const hello = dest.prenom ? `Bonjour ${dest.prenom},` : "Bonjour,";
  const unsubscribe = `${site}/alertes/desinscription?t=${dest.alertsToken}`;
  const introHtml = intro.trim()
    ? intro
        .trim()
        .split(/\n{2,}/)
        .map((p) => `<p style="font-size:15px;line-height:1.5">${escapeHtml(p).replace(/\n/g, "<br>")}</p>`)
        .join("")
    : `<p style="font-size:15px;line-height:1.5">Voici les recommandations publiées ou mises à jour sur medical-guidelines.net en ${escapeHtml(mois)}.</p>`;

  const card = (d: LettreDoc, detail: string) =>
    `<div style="border:1px solid #E2E8F0;border-radius:10px;padding:14px 16px;margin:10px 0">` +
    `<a href="${site}/bibliotheque/${d.id}" style="font-weight:700;color:#0F172A;font-size:15px;text-decoration:none">${escapeHtml(titleOf(d))}</a>` +
    `<div style="font-size:12px;color:#1A74A6;margin-top:4px">${escapeHtml(metaOf(d))}</div>` +
    `<div style="font-size:14px;color:#475569;margin-top:6px">${escapeHtml(detail)}</div>` +
    `<div style="font-size:13px;margin-top:8px"><a href="${site}/bibliotheque/${d.id}" style="color:#1A74A6">Lire la fiche</a>` +
    (d.source_url ? ` · <a href="${escapeHtml(d.source_url)}" style="color:#1A74A6">Document source officiel</a>` : "") +
    `</div></div>`;
  const section = (title: string, list: LettreDoc[], detail: (d: LettreDoc) => string) =>
    list.length
      ? `<h2 style="font-size:17px;color:#0E3A78;margin:28px 0 8px">${escapeHtml(title)}</h2>` +
        list.map((d) => card(d, detail(d))).join("")
      : "";

  const html =
    `<!doctype html><html lang="fr"><head><meta charset="utf-8">` +
    `<meta name="viewport" content="width=device-width, initial-scale=1">` +
    `<title>${escapeHtml(subject)}</title></head>` +
    `<body style="margin:0;padding:24px 16px;background-color:#ffffff">` +
    `<div style="font-family:Arial,Helvetica,sans-serif;max-width:620px;margin:0 auto;color:#0F172A">` +
    `<p style="font-size:18px;font-weight:700;color:#0E3A78">medical-guidelines<span style="color:#3AA8E0">.net</span></p>` +
    `<p style="font-size:15px">${escapeHtml(hello)}</p>` +
    introHtml +
    section("Nouvelles fiches", news, shortOf) +
    section("Fiches mises à jour", updates, updateDetail) +
    `<p style="font-size:12px;color:#64748B;margin-top:28px">Synthèses indépendantes, non officielles : elles ne remplacent pas le texte intégral des recommandations.</p>` +
    `<p style="font-size:12px;color:#64748B">Vous recevez cette lettre mensuelle en tant qu'abonné PREMIUM. ` +
    `<a href="${site}/compte#alertes" style="color:#64748B">Gérer mes alertes</a> · ` +
    `<a href="${unsubscribe}" style="color:#64748B">Se désinscrire</a></p></div></body></html>`;

  const textSection = (title: string, list: LettreDoc[], detail: (d: LettreDoc) => string) =>
    list.length
      ? `\n\n${title} :\n` +
        list
          .map(
            (d) =>
              `\n- ${titleOf(d)}\n  ${metaOf(d)}\n  ${detail(d)}\n  Fiche : ${site}/bibliotheque/${d.id}` +
              (d.source_url ? `\n  Source officielle : ${d.source_url}` : ""),
          )
          .join("\n")
      : "";
  const text =
    `${hello}\n\n${intro.trim() || `Voici les recommandations publiées ou mises à jour sur medical-guidelines.net en ${mois}.`}` +
    textSection("Nouvelles fiches", news, shortOf) +
    textSection("Fiches mises à jour", updates, updateDetail) +
    `\n\nSynthèses indépendantes, non officielles : elles ne remplacent pas le texte intégral des recommandations.` +
    `\nGérer mes alertes : ${site}/compte#alertes\nSe désinscrire : ${unsubscribe}\n`;

  return {
    to: dest.email,
    subject,
    html,
    text,
    headers: {
      "List-Unsubscribe": `<${site}/api/alertes/desinscription?t=${dest.alertsToken}>`,
      "List-Unsubscribe-Post": "List-Unsubscribe=One-Click",
    },
  };
}
