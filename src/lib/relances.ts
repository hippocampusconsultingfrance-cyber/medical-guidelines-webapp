import "server-only";
import type { SupabaseClient } from "@supabase/supabase-js";
import type { OutgoingEmail } from "@/lib/email";
import { cadreEmail } from "@/lib/email-gabarit";
import { escapeHtml, FREE_QUOTA } from "@/lib/fiches";

// Relances par e-mail (une seule fois par membre, notifications_log) :
//   - « finaliser » : inscription commencée il y a 1 à 7 jours sans
//     identifiant ni mot de passe ; lien de connexion à usage unique ;
//   - « quota » : les 5 crédits gratuits sont utilisés depuis 1 à 7 jours,
//     sans abonnement ; présentation de PREMIUM (pas pour une spécialité
//     encore peu couverte, à qui l'abonnement n'est pas proposé) ;
//   - « première fiche » : compte finalisé depuis 2 à 14 jours sans aucune
//     fiche ouverte ; 3 fiches récentes de sa spécialité proposées (de tout
//     le catalogue si elle est encore peu couverte).
// Chaque e-mail porte un lien de désinscription (préférence email_alerts,
// respectée par les deux relances).

const DAY = 24 * 3600 * 1000;
export const LOG_FINALISER = "relance:finaliser";
export const LOG_QUOTA = "relance:quota";
export const LOG_PREMIERE = "relance:premiere-fiche";

export type Cible = { userId: string; email: string; prenom: string | null; token: string };

async function dejaRelances(admin: SupabaseClient, body: string) {
  const { data } = await admin.from("notifications_log").select("user_id").eq("body", body);
  return new Set((data ?? []).map((d) => d.user_id as string));
}

// Spécialité couverte par le catalogue (fonction SQL specialite_couverte).
async function couverte(admin: SupabaseClient, specialtyId: string | null) {
  if (!specialtyId) return false;
  const { data, error } = await admin.rpc("specialite_couverte", { spec: specialtyId });
  if (error) throw new Error(`Couverture de la spécialité : ${error.message}`);
  return Boolean(data);
}

async function adresse(admin: SupabaseClient, id: string) {
  const { data } = await admin.auth.admin.getUserById(id);
  return data?.user?.email ?? null;
}

export async function ciblesFinaliser(admin: SupabaseClient, now: number): Promise<Cible[]> {
  const { data } = await admin
    .from("profiles")
    .select("id, prenom, alerts_token, email_alerts")
    .is("editorial_role", null)
    .eq("setup_completed", false)
    .lte("created_at", new Date(now - DAY).toISOString())
    .gte("created_at", new Date(now - 7 * DAY).toISOString());
  const deja = await dejaRelances(admin, LOG_FINALISER);
  const out: Cible[] = [];
  for (const p of data ?? []) {
    if (deja.has(p.id as string) || p.email_alerts === false) continue;
    const email = await adresse(admin, p.id as string);
    if (email) out.push({ userId: p.id as string, email, prenom: (p.prenom as string | null) || null, token: p.alerts_token as string });
  }
  return out;
}

export async function ciblesQuota(admin: SupabaseClient, now: number): Promise<Cible[]> {
  const { data: unlocks } = await admin.from("document_unlocks").select("user_id, unlocked_at");
  const parMembre = new Map<string, { n: number; dernier: number }>();
  for (const u of unlocks ?? []) {
    const m = parMembre.get(u.user_id as string) ?? { n: 0, dernier: 0 };
    m.n++;
    m.dernier = Math.max(m.dernier, new Date(u.unlocked_at as string).getTime());
    parMembre.set(u.user_id as string, m);
  }
  const candidats = [...parMembre.entries()]
    .filter(([, m]) => m.n >= FREE_QUOTA && m.dernier <= now - DAY && m.dernier >= now - 7 * DAY)
    .map(([id]) => id);
  if (!candidats.length) return [];
  const [{ data: subs }, { data: profils }, deja] = await Promise.all([
    admin.from("subscriptions").select("user_id").eq("status", "actif").in("user_id", candidats),
    admin.from("profiles").select("id, prenom, alerts_token, email_alerts, editorial_role, specialty_id").in("id", candidats),
    dejaRelances(admin, LOG_QUOTA),
  ]);
  const abonnes = new Set((subs ?? []).map((s) => s.user_id as string));
  const couvertes = new Map<string, boolean>();
  const out: Cible[] = [];
  for (const p of profils ?? []) {
    if (abonnes.has(p.id as string) || deja.has(p.id as string) || p.email_alerts === false || p.editorial_role) continue;
    const spec = (p.specialty_id as string | null) ?? "";
    if (!couvertes.has(spec)) couvertes.set(spec, await couverte(admin, spec || null));
    if (!couvertes.get(spec)) continue;
    const email = await adresse(admin, p.id as string);
    if (email) out.push({ userId: p.id as string, email, prenom: (p.prenom as string | null) || null, token: p.alerts_token as string });
  }
  return out;
}

export type CiblePremiere = Cible & { specialtyId: string | null };
export type FicheSuggeree = { titre: string; url: string };

export async function ciblesPremiereFiche(admin: SupabaseClient, now: number): Promise<CiblePremiere[]> {
  const { data } = await admin
    .from("profiles")
    .select("id, prenom, alerts_token, email_alerts, specialty_id")
    .is("editorial_role", null)
    .eq("setup_completed", true)
    .lte("created_at", new Date(now - 2 * DAY).toISOString())
    .gte("created_at", new Date(now - 14 * DAY).toISOString());
  if (!data?.length) return [];
  const ids = data.map((p) => p.id as string);
  const [{ data: unlocks }, { data: subs }, deja] = await Promise.all([
    admin.from("document_unlocks").select("user_id").in("user_id", ids),
    admin.from("subscriptions").select("user_id").eq("status", "actif").in("user_id", ids),
    dejaRelances(admin, LOG_PREMIERE),
  ]);
  const actifs = new Set([...(unlocks ?? []), ...(subs ?? [])].map((u) => u.user_id as string));
  const out: CiblePremiere[] = [];
  for (const p of data) {
    if (actifs.has(p.id as string) || deja.has(p.id as string) || p.email_alerts === false) continue;
    const email = await adresse(admin, p.id as string);
    if (email)
      out.push({
        userId: p.id as string,
        email,
        prenom: (p.prenom as string | null) || null,
        token: p.alerts_token as string,
        specialtyId: (p.specialty_id as string | null) ?? null,
      });
  }
  return out;
}

// 3 fiches en ligne, à jour, les plus récentes de la spécialité (toutes
// spécialités confondues si elle est encore peu couverte).
export async function fichesSuggerees(
  admin: SupabaseClient,
  specialtyId: string | null,
  site: string,
): Promise<{ fiches: FicheSuggeree[]; specialite: boolean }> {
  let ids: string[] | null = null;
  const specialite = await couverte(admin, specialtyId);
  if (specialite && specialtyId) {
    const { data } = await admin.from("document_specialties").select("document_id").eq("specialty_id", specialtyId);
    ids = (data ?? []).map((d) => d.document_id as string);
  }
  let q = admin
    .from("documents")
    .select("fiche_key, title, card_json")
    .not("published_at", "is", null)
    .not("fiche_key", "is", null)
    .eq("freshness_status", "a_jour")
    .order("publication_date", { ascending: false, nullsFirst: false })
    .limit(3);
  if (ids?.length) q = q.in("id", ids);
  const { data } = await q;
  const fiches = (data ?? []).map((d) => ({
    titre: ((d.card_json as { title?: string } | null)?.title ?? (d.title as string)) || "",
    url: `${site}/recommandations/${String(d.fiche_key).replace(/_/g, "-")}`,
  }));
  return { fiches, specialite: specialite && Boolean(ids?.length) };
}

function enveloppe(c: Cible, subject: string, corps: string, texte: string, site: string): OutgoingEmail {
  const stop = `${site}/alertes/desinscription?t=${c.token}`;
  const html = cadreEmail(
    subject,
    `<p style="font-size:15px;line-height:1.55;margin:0 0 14px">${escapeHtml(c.prenom ? `Bonjour ${c.prenom},` : "Bonjour,")}</p>` + corps,
    `<a href="${stop}" style="color:#64748B">Ne plus recevoir ces e-mails</a>`,
  );
  return {
    to: c.email,
    subject,
    html,
    text: `${c.prenom ? `Bonjour ${c.prenom},` : "Bonjour,"}\n\n${texte}\n\nNe plus recevoir ces e-mails : ${stop}\n`,
    headers: {
      "List-Unsubscribe": `<${site}/api/alertes/desinscription?t=${c.token}>`,
      "List-Unsubscribe-Post": "List-Unsubscribe=One-Click",
    },
  };
}

const p = (t: string) => `<p style="font-size:15px;line-height:1.55;margin:0 0 14px">${t}</p>`;
const bouton = (href: string, label: string) =>
  `<p style="margin:22px 0"><a href="${href}" style="background:#0E3A78;color:#ffffff;padding:12px 20px;border-radius:8px;font-weight:700;font-size:15px;text-decoration:none;display:inline-block">${escapeHtml(label)}</a></p>`;

export function emailFinaliser(c: Cible, lien: string, site: string): OutgoingEmail {
  const t1 = "Votre inscription sur medical-guidelines.net est presque terminée : il ne reste qu'à choisir votre identifiant et votre mot de passe.";
  const t2 = `Vous aurez ensuite ${FREE_QUOTA} fiches de synthèse à débloquer gratuitement.`;
  return enveloppe(
    c,
    "Finalisez votre compte medical-guidelines.net",
    p(escapeHtml(t1)) + p(escapeHtml(t2)) + bouton(lien, "Finaliser mon compte") + p(`<span style="font-size:13px;color:#64748B">Ce lien personnel est valable 24 heures.</span>`),
    `${t1}\n${t2}\n\nFinaliser mon compte : ${lien}\n(lien personnel valable 24 heures)`,
    site,
  );
}

export function emailQuota(c: Cible, venteOuverte: boolean, site: string): OutgoingEmail {
  const t1 = `Vous avez utilisé vos ${FREE_QUOTA} crédits gratuits : les fiches débloquées restent accessibles définitivement.`;
  const t2 = venteOuverte
    ? "Pour ouvrir toutes les fiches de votre spécialité et recevoir les alertes de mise à jour, l'abonnement PREMIUM coûte 50 € TTC par an. Les 100 premiers abonnés bénéficient de −30 % la première année avec le code FONDATEURS. Professionnel de santé en formation ? −30 % sur justificatif."
    : "L'abonnement PREMIUM, qui ouvrira toutes les fiches de votre spécialité, sera bientôt disponible : nous vous préviendrons.";
  return enveloppe(
    c,
    venteOuverte ? "Vos 5 fiches gratuites sont utilisées : passez à PREMIUM" : "Vos 5 fiches gratuites sont utilisées",
    p(escapeHtml(t1)) + p(escapeHtml(t2)) + (venteOuverte ? bouton(`${site}/abonnement`, "Découvrir PREMIUM") : ""),
    `${t1}\n${t2}${venteOuverte ? `\n\nDécouvrir PREMIUM : ${site}/abonnement` : ""}`,
    site,
  );
}

export function emailPremiereFiche(c: Cible, fiches: FicheSuggeree[], deLaSpecialite: boolean, site: string): OutgoingEmail {
  const t1 = `Votre compte est prêt : ${FREE_QUOTA} fiches de synthèse vous sont offertes, à choisir librement. Chaque fiche ouverte reste accessible définitivement.`;
  const t2 = deLaSpecialite
    ? "Pour commencer, voici les recommandations les plus récentes de votre spécialité :"
    : "Votre spécialité est encore peu couverte : vos fiches gratuites sont au choix dans tout le catalogue. Pour commencer, voici les recommandations les plus récentes :";
  const liste = fiches
    .map((f) => `<li style="margin:0 0 8px"><a href="${f.url}" style="color:#1A74A6;font-weight:600">${escapeHtml(f.titre)}</a></li>`)
    .join("");
  return enveloppe(
    c,
    "Vos 5 fiches gratuites vous attendent",
    p(escapeHtml(t1)) +
      p(escapeHtml(t2)) +
      `<ul style="font-size:15px;line-height:1.5;margin:0 0 14px;padding-left:20px">${liste}</ul>` +
      bouton(`${site}/recommandations`, "Voir toutes les recommandations"),
    `${t1}\n${t2}\n${fiches.map((f) => `- ${f.titre} : ${f.url}`).join("\n")}\n\nToutes les recommandations : ${site}/recommandations`,
    site,
  );
}
