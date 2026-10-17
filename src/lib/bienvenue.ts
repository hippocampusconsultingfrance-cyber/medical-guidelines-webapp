import "server-only";
import type { OutgoingEmail } from "@/lib/email";
import { cadreEmail } from "@/lib/email-gabarit";
import { fmt, plur } from "@/i18n/format";
import { EMAILS } from "@/lib/emails-textes";
import { escapeHtml, FREE_QUOTA } from "@/lib/fiches";
import { LOCALES, chemin, type LangueOuverte } from "@/lib/langues";

// E-mail de bienvenue, envoyé une fois, quand le membre finalise son compte
// (identifiant et mot de passe choisis) : ses crédits, comment débloquer une
// fiche, l'offre PREMIUM. E-mail de service lié au compte (pas de
// prospection) : il ne dépend pas de la préférence d'alertes.

export type Bienvenue = {
  email: string;
  prenom: string | null;
  specialite: string | null;
  fiches: number;
  premiumOuvert: boolean;
  // Spécialité encore peu couverte : fiches gratuites au choix dans tout le
  // catalogue, abonnement non proposé (@/lib/catalogue).
  catalogueOuvert: boolean;
};

export function composerBienvenue(b: Bienvenue, site: string, langue: LangueOuverte = "fr"): OutgoingEmail {
  const t = EMAILS[langue];
  const tb = t.bienvenue;
  const lien = (p: string) => `${site}${chemin(langue, p)}`;
  const hello = b.prenom ? fmt(t.bonjourPrenom, { prenom: b.prenom }) : t.bonjour;
  const subject = tb.sujet;
  const catalogue = b.catalogueOuvert
    ? fmt(tb.catalogueOuvert, { quota: FREE_QUOTA })
    : b.fiches > 0
      ? plur(LOCALES[langue], b.fiches, tb.fiches, { specialite: b.specialite ? fmt(tb.enSpecialite, { specialite: b.specialite }) : "" })
      : b.specialite
        ? fmt(tb.arriventSpecialite, { specialite: b.specialite })
        : tb.arrivent;
  const premium = b.catalogueOuvert ? tb.premiumCatalogue : b.premiumOuvert ? tb.premiumOuvert : tb.premiumBientot;

  const p = (x: string) => `<p style="font-size:15px;line-height:1.55;margin:0 0 14px">${x}</p>`;
  const button = (href: string, label: string) =>
    `<p style="margin:22px 0"><a href="${href}" style="background:#0E3A78;color:#ffffff;padding:12px 20px;border-radius:8px;font-weight:700;font-size:15px;text-decoration:none;display:inline-block">${escapeHtml(label)}</a></p>`;
  const pret = fmt(tb.pret, { catalogue });
  const creditsTitre = fmt(tb.creditsTitre, { quota: FREE_QUOTA });
  const creditsTexte = fmt(tb.creditsTexte, { quota: FREE_QUOTA });

  const corps =
    p(escapeHtml(hello)) +
    p(escapeHtml(pret)) +
    `<h2 style="font-size:17px;color:#0E3A78;margin:24px 0 8px">${escapeHtml(creditsTitre)}</h2>` +
    p(escapeHtml(creditsTexte)) +
    button(lien("/bibliotheque"), tb.ouvrirBibliotheque) +
    p(escapeHtml(tb.astuce)) +
    `<h2 style="font-size:17px;color:#0E3A78;margin:24px 0 8px">${escapeHtml(tb.toutOuvrir)}</h2>` +
    p(escapeHtml(premium)) +
    (b.premiumOuvert && !b.catalogueOuvert ? button(lien("/abonnement"), tb.decouvrirPremium) : "") +
    p(escapeHtml(tb.question));
  const html = cadreEmail(
    subject,
    corps,
    `${escapeHtml(t.avertissement)}<br><br>` +
      `${escapeHtml(tb.raison)} ` +
      `<a href="${lien("/compte")}" style="color:#64748B">${escapeHtml(tb.monCompte)}</a>`,
    langue,
  );

  const text =
    `${hello}\n\n${pret}\n\n` +
    `${creditsTitre.toLocaleUpperCase(LOCALES[langue])}\n${creditsTexte}\n${lien("/bibliotheque")}\n\n` +
    `${tb.astuce}\n\n` +
    `${tb.toutOuvrir.toLocaleUpperCase(LOCALES[langue])}\n${premium}${b.premiumOuvert && !b.catalogueOuvert ? `\n${lien("/abonnement")}` : ""}\n\n` +
    `${tb.question}\n\n` +
    `${t.avertissement}\n${tb.monCompte}${t.dp}${lien("/compte")}\n`;

  return { to: b.email, subject, html, text };
}
