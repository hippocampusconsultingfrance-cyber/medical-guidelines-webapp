import "server-only";
import type { OutgoingEmail } from "@/lib/email";
import { cadreEmail } from "@/lib/email-gabarit";
import { escapeHtml, FREE_QUOTA } from "@/lib/fiches";

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
};

export function composerBienvenue(b: Bienvenue, site: string): OutgoingEmail {
  const hello = b.prenom ? `Bonjour ${b.prenom},` : "Bonjour,";
  const subject = "Bienvenue sur medical-guidelines.net";
  const catalogue =
    b.fiches > 0
      ? `${b.fiches} fiche${b.fiches > 1 ? "s" : ""} de synthèse${b.specialite ? ` en ${b.specialite}` : ""} vous attendent`
      : `Les fiches${b.specialite ? ` de ${b.specialite}` : ""} arrivent au fil de leur validation`;
  const premium = b.premiumOuvert
    ? `Pour tout ouvrir, l'abonnement PREMIUM donne accès à toutes les fiches de votre spécialité et aux alertes de mise à jour, pour 50 € TTC par an (−30 % la première année avec le code FONDATEURS, pour les 100 premiers abonnés).`
    : `L'abonnement PREMIUM, qui ouvrira toutes les fiches de votre spécialité et les alertes de mise à jour, sera bientôt disponible : nous vous préviendrons.`;

  const p = (t: string) => `<p style="font-size:15px;line-height:1.55;margin:0 0 14px">${t}</p>`;
  const button = (href: string, label: string) =>
    `<p style="margin:22px 0"><a href="${href}" style="background:#0E3A78;color:#ffffff;padding:12px 20px;border-radius:8px;font-weight:700;font-size:15px;text-decoration:none;display:inline-block">${escapeHtml(label)}</a></p>`;

  const corps =
    p(escapeHtml(hello)) +
    p(`Votre compte est prêt. ${escapeHtml(catalogue)} : des synthèses fidèles des recommandations des sociétés savantes, grades conservés et source officielle toujours indiquée.`) +
    `<h2 style="font-size:17px;color:#0E3A78;margin:24px 0 8px">Vos ${FREE_QUOTA} crédits gratuits</h2>` +
    p(`Toutes les fiches sont visibles dans la bibliothèque. Choisissez-en une et cliquez sur « Débloquer » : un crédit ouvre la fiche <b>définitivement</b>. Vous disposez de ${FREE_QUOTA} crédits, sans limite de durée.`) +
    button(`${site}/bibliotheque`, "Ouvrir la bibliothèque") +
    p(`Astuce : la recherche trouve aussi les mots à l'intérieur des fiches (un médicament, une situation clinique), et l'étoile ☆ garde vos fiches favorites à portée de main.`) +
    `<h2 style="font-size:17px;color:#0E3A78;margin:24px 0 8px">Tout ouvrir</h2>` +
    p(escapeHtml(premium)) +
    (b.premiumOuvert ? button(`${site}/abonnement`, "Découvrir PREMIUM") : "") +
    p(`Une question, une erreur repérée dans une fiche ? Répondez simplement à cet e-mail, ou utilisez « Signaler une erreur » en bas de chaque fiche.`);
  const html = cadreEmail(
    subject,
    corps,
    `Synthèses indépendantes, non officielles : elles ne remplacent pas le texte intégral des recommandations ni le jugement clinique.<br><br>` +
      `Vous recevez cet e-mail car vous venez de créer votre compte sur medical-guidelines.net. ` +
      `<a href="${site}/compte" style="color:#64748B">Mon compte</a>`,
  );

  const text =
    `${hello}\n\nVotre compte est prêt. ${catalogue} : des synthèses fidèles des recommandations des sociétés savantes, grades conservés et source officielle toujours indiquée.\n\n` +
    `VOS ${FREE_QUOTA} CRÉDITS GRATUITS\nToutes les fiches sont visibles dans la bibliothèque. Choisissez-en une et cliquez sur « Débloquer » : un crédit ouvre la fiche définitivement. Vous disposez de ${FREE_QUOTA} crédits, sans limite de durée.\nBibliothèque : ${site}/bibliotheque\n\n` +
    `Astuce : la recherche trouve aussi les mots à l'intérieur des fiches, et l'étoile garde vos fiches favorites à portée de main.\n\n` +
    `TOUT OUVRIR\n${premium}${b.premiumOuvert ? `\n${site}/abonnement` : ""}\n\n` +
    `Une question, une erreur repérée dans une fiche ? Répondez simplement à cet e-mail.\n\n` +
    `Synthèses indépendantes, non officielles : elles ne remplacent pas le texte intégral des recommandations ni le jugement clinique.\nMon compte : ${site}/compte\n`;

  return { to: b.email, subject, html, text };
}
