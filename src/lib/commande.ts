import "server-only";
import type { OutgoingEmail } from "@/lib/email";
import { escapeHtml } from "@/lib/fiches";

// E-mails contractuels de l'abonnement (CGV §5 et §7), envoyés quelle que
// soit la préférence d'alertes :
//   - confirmation de commande, sur support durable : prix payé, durée,
//     version des CGV acceptée, demande d'accès immédiat et renonciation au
//     droit de rétractation (art. L221-13 et L221-28 13° du Code de la
//     consommation) ;
//   - avis de renouvellement, environ 30 jours avant l'échéance : montant
//     de la prochaine année et moyen de résilier (art. L215-1).

export const LOG_COMMANDE = "commande";
export const logRenouvellement = (finPeriode: string) => `renouvellement:${finPeriode.slice(0, 10)}`;

const euros = (cents: number) =>
  (cents / 100).toLocaleString("fr-FR", { style: "currency", currency: "EUR", minimumFractionDigits: cents % 100 ? 2 : 0 });
const jour = (iso: string) =>
  new Date(iso).toLocaleDateString("fr-FR", { day: "numeric", month: "long", year: "numeric", timeZone: "Europe/Paris" });

const p = (t: string) => `<p style="font-size:15px;line-height:1.55;margin:0 0 14px">${t}</p>`;
const bouton = (href: string, label: string) =>
  `<p style="margin:22px 0"><a href="${href}" style="background:#0E3A78;color:#ffffff;padding:12px 20px;border-radius:8px;font-weight:700;font-size:15px;text-decoration:none;display:inline-block">${escapeHtml(label)}</a></p>`;

function enveloppe(to: string, prenom: string | null, subject: string, paragraphes: string[], lien: [string, string], site: string): OutgoingEmail {
  const hello = prenom ? `Bonjour ${prenom},` : "Bonjour,";
  const pied = "Hippocampus Consulting, SARL au capital de 1 000 € — 6 rue d'Armaillé, 75017 Paris — SIREN 999 259 252.";
  const html =
    `<!doctype html><html lang="fr"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">` +
    `<title>${escapeHtml(subject)}</title></head><body style="margin:0;padding:24px 16px;background-color:#ffffff">` +
    `<div style="font-family:Arial,Helvetica,sans-serif;max-width:620px;margin:0 auto;color:#0F172A">` +
    `<p style="font-size:18px;font-weight:700;color:#0E3A78">medical-guidelines<span style="color:#3AA8E0">.net</span></p>` +
    p(escapeHtml(hello)) +
    paragraphes.map((t) => p(escapeHtml(t))).join("") +
    bouton(lien[1], lien[0]) +
    p(`Conditions générales de vente : <a href="${site}/cgv" style="color:#0E3A78">${site}/cgv</a>. Une question : répondez simplement à cet e-mail.`) +
    `<p style="font-size:12px;color:#64748B;margin-top:28px">${escapeHtml(pied)}</p>` +
    `</div></body></html>`;
  const text =
    `${hello}\n\n${paragraphes.join("\n\n")}\n\n${lien[0]} : ${lien[1]}\n\n` +
    `Conditions générales de vente : ${site}/cgv. Une question : répondez simplement à cet e-mail.\n\n${pied}\n`;
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

export function composerConfirmation(c: Commande, site: string): OutgoingEmail {
  const lignes = [
    `Merci pour votre abonnement PREMIUM à medical-guidelines.net, souscrit le ${jour(c.debut)}. Il ouvre toutes les fiches de votre spécialité et les alertes de mise à jour.`,
    `Montant payé : ${euros(c.montantCents)} TTC pour un an${c.fin ? `, jusqu'au ${jour(c.fin)}` : ""}. La facture vous est envoyée séparément par notre prestataire de paiement, Stripe.`,
    `L'abonnement se renouvelle automatiquement chaque année au tarif alors en vigueur (50 € TTC par an aujourd'hui). Nous vous écrirons environ 30 jours avant chaque renouvellement. Vous pouvez le résilier à tout moment depuis la page « Abonnement » : l'accès reste ouvert jusqu'à la fin de l'année payée.`,
    c.renonciation
      ? `Droit de rétractation : le ${jour(c.renonciation)}, vous avez demandé l'accès immédiat au service et renoncé expressément à votre droit de rétractation de 14 jours dès le début de l'accès (article L221-28 13° du Code de la consommation).`
      : `Droit de rétractation : l'accès au service étant immédiat, il ne s'applique plus dès le début de l'accès (article L221-28 13° du Code de la consommation).`,
    ...(c.cgvVersion ? [`Conditions générales de vente acceptées : version du ${c.cgvVersion.split("-").reverse().join("/")}.`] : []),
  ];
  return enveloppe(c.email, c.prenom, "Confirmation de votre abonnement PREMIUM", lignes, ["Gérer mon abonnement", `${site}/abonnement`], site);
}

export type Renouvellement = { email: string; prenom: string | null; fin: string; montantCents: number };

export function composerAvisRenouvellement(r: Renouvellement, site: string): OutgoingEmail {
  const lignes = [
    `Votre abonnement PREMIUM à medical-guidelines.net arrive à échéance le ${jour(r.fin)}.`,
    `Sans action de votre part, il sera renouvelé automatiquement ce jour-là pour un an, au prix de ${euros(r.montantCents)} TTC.`,
    `Si vous ne souhaitez pas le renouveler, vous pouvez le résilier dès maintenant depuis la page « Abonnement » : l'accès reste ouvert jusqu'au ${jour(r.fin)}, puis votre compte redevient gratuit, sans perte des fiches débloquées avec vos crédits gratuits.`,
  ];
  return enveloppe(r.email, r.prenom, `Votre abonnement PREMIUM sera renouvelé le ${jour(r.fin)}`, lignes, ["Gérer ou résilier mon abonnement", `${site}/abonnement`], site);
}
