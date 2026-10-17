import "server-only";
import type { OutgoingEmail } from "@/lib/email";
import { cadreEmail } from "@/lib/email-gabarit";
import { fmt } from "@/i18n/format";
import { EMAILS } from "@/lib/emails-textes";
import { escapeHtml } from "@/lib/fiches";
import { LOCALES, chemin, type LangueOuverte } from "@/lib/langues";

// E-mails contractuels de l'abonnement (CGV §5 et §7), envoyés quelle que
// soit la préférence d'alertes :
//   - confirmation de commande, sur support durable : prix payé, durée,
//     version des CGV acceptée, demande d'accès immédiat et renonciation au
//     droit de rétractation (art. L221-13 et L221-28 13° du Code de la
//     consommation) ;
//   - avis de renouvellement, 35 à 45 jours avant l'échéance : montant
//     de la prochaine année et moyen de résilier (art. L215-1).

export const LOG_COMMANDE = "commande";
export const logRenouvellement = (finPeriode: string) => `renouvellement:${finPeriode.slice(0, 10)}`;

const euros = (cents: number, locale: string) =>
  (cents / 100).toLocaleString(locale, { style: "currency", currency: "EUR", minimumFractionDigits: cents % 100 ? 2 : 0 });
const jour = (iso: string, locale: string) =>
  new Date(iso).toLocaleDateString(locale, { day: "numeric", month: "long", year: "numeric", timeZone: "Europe/Paris" });

const p = (t: string) => `<p style="font-size:15px;line-height:1.55;margin:0 0 14px">${t}</p>`;
const bouton = (href: string, label: string) =>
  `<p style="margin:22px 0"><a href="${href}" style="background:#0E3A78;color:#ffffff;padding:12px 20px;border-radius:8px;font-weight:700;font-size:15px;text-decoration:none;display:inline-block">${escapeHtml(label)}</a></p>`;

function enveloppe(
  to: string,
  prenom: string | null,
  subject: string,
  paragraphes: string[],
  lien: [string, string],
  site: string,
  langue: LangueOuverte,
): OutgoingEmail {
  const t = EMAILS[langue];
  const hello = prenom ? fmt(t.bonjourPrenom, { prenom }) : t.bonjour;
  const pied = t.commande.pied;
  const cgv = `${site}${chemin(langue, "/cgv")}`;
  const html = cadreEmail(
    subject,
    p(escapeHtml(hello)) +
      paragraphes.map((x) => p(escapeHtml(x))).join("") +
      bouton(lien[1], lien[0]) +
      p(`${escapeHtml(t.commande.cgv)}${t.dp}<a href="${cgv}" style="color:#0E3A78">${cgv}</a>. ${escapeHtml(t.commande.question)}`),
    escapeHtml(pied),
    langue,
  );
  const text =
    `${hello}\n\n${paragraphes.join("\n\n")}\n\n${lien[0]}${t.dp}${lien[1]}\n\n` +
    `${t.commande.cgv}${t.dp}${cgv}. ${t.commande.question}\n\n${pied}\n`;
  return { to, subject, html, text };
}

export type Commande = {
  email: string;
  prenom: string | null;
  montantCents: number;
  debut: string;
  fin: string | null;
  cgvVersion: string | null;
  renonciation: string | null;
};

// Langue du membre (profiles.langue_preferee) : le texte français des CGV
// fait seul foi, l'e-mail reprend leurs termes dans la langue du membre.
export function composerConfirmation(c: Commande, site: string, langue: LangueOuverte = "fr"): OutgoingEmail {
  const t = EMAILS[langue].commande;
  const locale = LOCALES[langue];
  const lignes = [
    fmt(t.merci, { date: jour(c.debut, locale) }),
    fmt(t.montant, { montant: euros(c.montantCents, locale), fin: c.fin ? fmt(t.jusquau, { date: jour(c.fin, locale) }) : "" }),
    t.renouvellement,
    c.renonciation ? fmt(t.retractationRenonciation, { date: jour(c.renonciation, locale) }) : t.retractation,
    ...(c.cgvVersion ? [fmt(t.cgvVersion, { version: c.cgvVersion.split("-").reverse().join("/") })] : []),
  ];
  return enveloppe(c.email, c.prenom, t.confirmationSujet, lignes, [t.gerer, `${site}${chemin(langue, "/abonnement")}`], site, langue);
}

export type Renouvellement = { email: string; prenom: string | null; fin: string; montantCents: number; langue?: LangueOuverte };

export function composerAvisRenouvellement(r: Renouvellement, site: string): OutgoingEmail {
  const langue = r.langue ?? "fr";
  const t = EMAILS[langue].commande;
  const locale = LOCALES[langue];
  const fin = jour(r.fin, locale);
  const lignes = [fmt(t.echeance, { date: fin }), fmt(t.renouvele, { montant: euros(r.montantCents, locale) }), fmt(t.resilier, { date: fin })];
  return enveloppe(r.email, r.prenom, fmt(t.avisSujet, { date: fin }), lignes, [t.gererResilier, `${site}${chemin(langue, "/abonnement")}`], site, langue);
}
