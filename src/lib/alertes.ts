import "server-only";
import { fmt } from "@/i18n/format";
import { cadreEmail } from "@/lib/email-gabarit";
import { EMAILS } from "@/lib/emails-textes";
import { escapeHtml, formatDate, type Card } from "@/lib/fiches";
import type { OutgoingEmail } from "@/lib/email";
import { LOCALES, chemin, type LangueOuverte } from "@/lib/langues";

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

// langues : langue de chaque membre (à défaut le français).
export function buildDigests(
  rows: PendingAlert[],
  docs: Map<string, AlertDocument>,
  site: string,
  langues: Map<string, LangueOuverte> = new Map(),
): Digest[] {
  const byUser = new Map<string, PendingAlert[]>();
  for (const r of rows) if (docs.has(r.document_id)) byUser.set(r.user_id, [...(byUser.get(r.user_id) ?? []), r]);

  return [...byUser.values()].map((alerts) => {
    const first = alerts[0];
    const langue = langues.get(first.user_id) ?? "fr";
    const t = EMAILS[langue];
    const ta = t.alertes;
    const lien = (p: string) => `${site}${chemin(langue, p)}`;
    const meta = (d: AlertDocument) => metaOf(d, LOCALES[langue]);
    const detailMaj = (d: AlertDocument) => updateDetail(d, langue);
    const news = alerts.filter((a) => a.motif === "societe").map((a) => docs.get(a.document_id)!);
    const updates = alerts.filter((a) => a.motif === "mise_a_jour").map((a) => docs.get(a.document_id)!);
    const unsubscribe = `${lien("/alertes/desinscription")}?t=${first.alerts_token}`;
    const subject = subjectFor(news, updates, langue);
    const hello = first.prenom ? fmt(t.bonjourPrenom, { prenom: first.prenom }) : t.bonjour;

    const section = (title: string, list: AlertDocument[], detail: (d: AlertDocument) => string) =>
      list.length
        ? `<h2 style="font-size:17px;color:#0E3A78;margin:28px 0 8px">${escapeHtml(title)}</h2>` +
          list
            .map(
              (d) =>
                `<div style="border:1px solid #E2E8F0;border-radius:10px;padding:14px 16px;margin:10px 0">` +
                `<a href="${lien(`/bibliotheque/${d.id}`)}" style="font-weight:700;color:#0F172A;font-size:15px;text-decoration:none">${escapeHtml(titleOf(d))}</a>` +
                `<div style="font-size:12px;color:#1A74A6;margin-top:4px">${escapeHtml(meta(d))}</div>` +
                `<div style="font-size:14px;color:#475569;margin-top:6px">${escapeHtml(detail(d))}</div>` +
                `<div style="font-size:13px;margin-top:8px"><a href="${lien(`/bibliotheque/${d.id}`)}" style="color:#1A74A6">${escapeHtml(ta.lire)}</a>` +
                (d.source_url ? ` · <a href="${escapeHtml(d.source_url)}" style="color:#1A74A6">${escapeHtml(ta.source)}</a>` : "") +
                `</div></div>`,
            )
            .join("")
        : "";

    // Document HTML complet (langue, encodage, titre) : un fragment sans
    // <html> ni <head> est mal noté par certains filtres anti-spam.
    const html = cadreEmail(
      subject,
      `<p style="font-size:15px;margin:0 0 14px">${escapeHtml(hello)}</p>` +
        section(ta.nouvelles, news, shortOf) +
        section(ta.misesAJour, updates, detailMaj),
      `${escapeHtml(t.avertissement)}<br><br>` +
        `${escapeHtml(ta.raison)} ` +
        `<a href="${lien("/compte#alertes")}" style="color:#64748B">${escapeHtml(ta.gerer)}</a> · ` +
        `<a href="${unsubscribe}" style="color:#64748B">${escapeHtml(ta.desinscrire)}</a>`,
      langue,
    );

    const textSection = (title: string, list: AlertDocument[], detail: (d: AlertDocument) => string) =>
      list.length
        ? `\n\n${title}${t.dp.trimEnd()}\n` +
          list
            .map(
              (d) =>
                `\n- ${titleOf(d)}\n  ${meta(d)}\n  ${detail(d)}\n  ${ta.fiche}${t.dp}${lien(`/bibliotheque/${d.id}`)}` +
                (d.source_url ? `\n  ${ta.sourceTexte}${t.dp}${d.source_url}` : ""),
            )
            .join("\n")
        : "";
    const text =
      hello +
      textSection(ta.nouvelles, news, shortOf) +
      textSection(ta.misesAJour, updates, detailMaj) +
      `\n\n${t.avertissement}` +
      `\n${ta.gerer}${t.dp}${lien("/compte#alertes")}\n${ta.desinscrire}${t.dp}${unsubscribe}\n`;

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

export function metaOf(d: AlertDocument, locale = "fr-FR") {
  return [d.societies.join(" · ") || d.card_json?.society, formatDate(d.publication_date, locale)].filter(Boolean).join(" — ");
}

export function updateDetail(d: AlertDocument, langue: LangueOuverte = "fr") {
  const ta = EMAILS[langue].alertes;
  if (!d.version) return ta.nouvelleVersion;
  return `${fmt(ta.version, { version: d.version.version_label })}${d.version.diff_summary ? ` : ${d.version.diff_summary}` : ""}`;
}

function subjectFor(news: AlertDocument[], updates: AlertDocument[], langue: LangueOuverte) {
  const ta = EMAILS[langue].alertes;
  if (news.length && updates.length) return fmt(ta.sujetMixte, { n: news.length + updates.length });
  if (news.length === 1) return fmt(ta.sujetUneNouvelle, { titre: titleOf(news[0]) });
  if (news.length > 1) return fmt(ta.sujetNouvelles, { n: news.length });
  if (updates.length === 1) return fmt(ta.sujetUneMaj, { titre: titleOf(updates[0]) });
  return fmt(ta.sujetMajs, { n: updates.length });
}
