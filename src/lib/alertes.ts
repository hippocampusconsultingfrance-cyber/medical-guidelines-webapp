import "server-only";
import { escapeHtml, formatDate, type Card } from "@/lib/fiches";
import type { OutgoingEmail } from "@/lib/email";

// Composition de l'e-mail d'alerte quotidien : un seul e-mail par membre,
// regroupant les nouvelles fiches des sociétés suivies et les mises à jour
// de ses fiches (cahier des charges §8 : titre, société, date, court résumé,
// lien vers la fiche, lien vers la source officielle, lien de désinscription).

export type PendingAlert = {
  user_id: string;
  email: string;
  prenom: string | null;
  alerts_token: string;
  document_id: string;
  motif: "societe" | "mise_a_jour";
  event_at: string;
};

export type AlertDocument = {
  id: string;
  title: string;
  card_json: Card | null;
  publication_date: string | null;
  source_url: string | null;
  societies: string[];
  version: { version_label: string; diff_summary: string | null } | null;
};

export type Digest = {
  userId: string;
  email: OutgoingEmail;
  items: { documentId: string; motif: PendingAlert["motif"] }[];
};

export function buildDigests(rows: PendingAlert[], docs: Map<string, AlertDocument>, site: string): Digest[] {
  const byUser = new Map<string, PendingAlert[]>();
  for (const r of rows) if (docs.has(r.document_id)) byUser.set(r.user_id, [...(byUser.get(r.user_id) ?? []), r]);

  return [...byUser.values()].map((alerts) => {
    const first = alerts[0];
    const news = alerts.filter((a) => a.motif === "societe").map((a) => docs.get(a.document_id)!);
    const updates = alerts.filter((a) => a.motif === "mise_a_jour").map((a) => docs.get(a.document_id)!);
    const unsubscribe = `${site}/alertes/desinscription?t=${first.alerts_token}`;
    const subject = subjectFor(news, updates);
    const hello = first.prenom ? `Bonjour ${first.prenom},` : "Bonjour,";

    const section = (title: string, list: AlertDocument[], detail: (d: AlertDocument) => string) =>
      list.length
        ? `<h2 style="font-size:17px;color:#0E3A78;margin:28px 0 8px">${escapeHtml(title)}</h2>` +
          list
            .map(
              (d) =>
                `<div style="border:1px solid #E2E8F0;border-radius:10px;padding:14px 16px;margin:10px 0">` +
                `<a href="${site}/bibliotheque/${d.id}" style="font-weight:700;color:#0F172A;font-size:15px;text-decoration:none">${escapeHtml(titleOf(d))}</a>` +
                `<div style="font-size:12px;color:#1C7FB6;margin-top:4px">${escapeHtml(metaOf(d))}</div>` +
                `<div style="font-size:14px;color:#475569;margin-top:6px">${escapeHtml(detail(d))}</div>` +
                `<div style="font-size:13px;margin-top:8px"><a href="${site}/bibliotheque/${d.id}" style="color:#1C7FB6">Lire la fiche</a>` +
                (d.source_url ? ` · <a href="${escapeHtml(d.source_url)}" style="color:#1C7FB6">Document source officiel</a>` : "") +
                `</div></div>`,
            )
            .join("")
        : "";

    // Document HTML complet (langue, encodage, titre) : un fragment sans
    // <html> ni <head> est mal noté par certains filtres anti-spam.
    const html =
      `<!doctype html><html lang="fr"><head><meta charset="utf-8">` +
      `<meta name="viewport" content="width=device-width, initial-scale=1">` +
      `<title>${escapeHtml(subject)}</title></head>` +
      `<body style="margin:0;padding:24px 16px;background-color:#ffffff">` +
      `<div style="font-family:Arial,Helvetica,sans-serif;max-width:620px;margin:0 auto;color:#0F172A">` +
      `<p style="font-size:18px;font-weight:700;color:#0E3A78">medical-guidelines<span style="color:#3AA8E0">.net</span></p>` +
      `<p style="font-size:15px">${escapeHtml(hello)}</p>` +
      section("Nouvelles recommandations de vos sociétés suivies", news, shortOf) +
      section("Vos fiches ont été mises à jour", updates, updateDetail) +
      `<p style="font-size:12px;color:#64748B;margin-top:28px">Synthèses indépendantes, non officielles : elles ne remplacent pas le texte intégral des recommandations.</p>` +
      `<p style="font-size:12px;color:#64748B">Vous recevez cet e-mail car les alertes sont activées sur votre compte. ` +
      `<a href="${site}/compte#alertes" style="color:#64748B">Gérer mes alertes</a> · ` +
      `<a href="${unsubscribe}" style="color:#64748B">Se désinscrire</a></p></div></body></html>`;

    const textSection = (title: string, list: AlertDocument[], detail: (d: AlertDocument) => string) =>
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
      hello +
      textSection("Nouvelles recommandations de vos sociétés suivies", news, shortOf) +
      textSection("Vos fiches ont été mises à jour", updates, updateDetail) +
      `\n\nSynthèses indépendantes, non officielles : elles ne remplacent pas le texte intégral des recommandations.` +
      `\nGérer mes alertes : ${site}/compte#alertes\nSe désinscrire : ${unsubscribe}\n`;

    return {
      userId: first.user_id,
      email: {
        to: first.email,
        subject,
        html,
        text,
        headers: {
          "List-Unsubscribe": `<${site}/api/alertes/desinscription?t=${first.alerts_token}>`,
          "List-Unsubscribe-Post": "List-Unsubscribe=One-Click",
        },
      },
      items: alerts.map((a) => ({ documentId: a.document_id, motif: a.motif })),
    };
  });
}

export function titleOf(d: AlertDocument) {
  return d.card_json?.title ?? d.title;
}

// Résumé de la carte, coupé à la fin d'un mot : certains résumés de
// l'atelier sont longs, l'e-mail n'en garde que le début.
export function shortOf(d: AlertDocument) {
  const s = (d.card_json?.short ?? "").trim();
  if (s.length <= 220) return s;
  return `${s.slice(0, 220).replace(/\s+\S*$/, "").replace(/[\s.,;:—–-]+$/, "")}…`;
}

export function metaOf(d: AlertDocument) {
  return [d.societies.join(" · ") || d.card_json?.society, formatDate(d.publication_date)].filter(Boolean).join(" — ");
}

export function updateDetail(d: AlertDocument) {
  if (!d.version) return "Nouvelle version publiée.";
  return `Version ${d.version.version_label}${d.version.diff_summary ? ` : ${d.version.diff_summary}` : ""}`;
}

function subjectFor(news: AlertDocument[], updates: AlertDocument[]) {
  if (news.length && updates.length) {
    return `${news.length + updates.length} nouveautés pour vous sur medical-guidelines.net`;
  }
  if (news.length === 1) return `Nouvelle recommandation : ${titleOf(news[0])}`;
  if (news.length > 1) return `${news.length} nouvelles recommandations de vos sociétés savantes`;
  if (updates.length === 1) return `Fiche mise à jour : ${titleOf(updates[0])}`;
  return `${updates.length} de vos fiches ont été mises à jour`;
}
