import "server-only";
import type { OutgoingEmail } from "@/lib/email";
import { cadreEmail } from "@/lib/email-gabarit";
import { fmt } from "@/i18n/format";
import { EMAILS } from "@/lib/emails-textes";
import { escapeHtml } from "@/lib/fiches";
import { chemin, type LangueOuverte } from "@/lib/langues";

// Tarif professionnel en formation (CGV §4) : −30 % la première année sur
// justificatif de l'année universitaire en cours, validé par un
// administrateur. Coupon Stripe : STRIPE_STUDENT_COUPON_ID (marqué
// metadata.app = medical-guidelines, metadata.kind = etudiant).

export const STATUTS: Record<string, string> = {
  externe: "Externe (étudiant hospitalier)",
  interne: "Interne",
  resident: "Résident",
  docteur_junior: "Docteur junior",
  autre: "Étudiant paramédical ou autre étudiant en santé",
};

export const JUSTIFICATIF_MAX = 3 * 1024 * 1024;
export const JUSTIFICATIF_TYPES: Record<string, string> = {
  "application/pdf": "pdf",
  "image/jpeg": "jpg",
  "image/png": "png",
};

// Année universitaire en cours : à partir de septembre, l'année qui commence.
export function anneeUniversitaire(date: Date) {
  const y = date.getUTCFullYear();
  return date.getUTCMonth() >= 8 ? `${y}-${y + 1}` : `${y - 1}-${y}`;
}

// Le contenu correspond-il au type annoncé ? (signature du fichier)
export function signatureValide(bytes: Uint8Array, type: string) {
  const b = (i: number) => bytes[i];
  if (type === "application/pdf") return b(0) === 0x25 && b(1) === 0x50 && b(2) === 0x44 && b(3) === 0x46;
  if (type === "image/png") return b(0) === 0x89 && b(1) === 0x50 && b(2) === 0x4e && b(3) === 0x47;
  if (type === "image/jpeg") return b(0) === 0xff && b(1) === 0xd8 && b(2) === 0xff;
  return false;
}

export function codeEtudiant() {
  const alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
  const bytes = crypto.getRandomValues(new Uint8Array(8));
  return `ETU-${[...bytes].map((x) => alphabet[x % alphabet.length]).join("")}`;
}

function layout(subject: string, body: string, site: string, langue: LangueOuverte) {
  const t = EMAILS[langue].etudiant;
  return cadreEmail(
    subject,
    body,
    `${escapeHtml(t.supprime)} <a href="${site}${chemin(langue, "/abonnement")}" style="color:#64748B">${escapeHtml(t.monAbonnement)}</a>`,
    langue,
  );
}

const p = (t: string) => `<p style="font-size:15px;line-height:1.55;margin:0 0 14px">${t}</p>`;

export function emailDecision(
  d: {
    email: string;
    prenom: string | null;
    valide: boolean;
    code: string | null;
    surAbonnement: boolean;
    note: string | null;
  },
  site: string,
  langue: LangueOuverte = "fr",
): OutgoingEmail {
  const te = EMAILS[langue];
  const t = te.etudiant;
  const abonnement = `${site}${chemin(langue, "/abonnement")}`;
  const hello = d.prenom ? fmt(te.bonjourPrenom, { prenom: d.prenom }) : te.bonjour;
  const subject = d.valide ? t.sujetValide : t.sujet;
  let body = p(escapeHtml(hello));
  let text = `${hello}\n\n`;
  if (d.valide && d.surAbonnement) {
    body += p(escapeHtml(t.valideRenouvellement));
    text += `${t.valideRenouvellement}\n`;
  } else if (d.valide) {
    body +=
      p(escapeHtml(t.valide)) +
      `<p style="margin:22px 0"><a href="${abonnement}" style="background:#0E3A78;color:#ffffff;padding:12px 20px;border-radius:8px;font-weight:700;font-size:15px;text-decoration:none;display:inline-block">${escapeHtml(t.activer)}</a></p>`;
    text += `${t.valide}\n\n${t.activerTexte}${te.dp}${abonnement}\n`;
  } else {
    body +=
      p(escapeHtml(t.refuse)) +
      (d.note ? p(`<b>${escapeHtml(t.motif)}</b> ${escapeHtml(d.note)}`) : "") +
      p(escapeHtml(t.nouveau));
    text += `${t.refuse}\n${d.note ? `${t.motif} ${d.note}\n` : ""}${t.nouveauTexte}${te.dp}${abonnement}\n`;
  }
  if (d.valide && d.note) {
    body += p(escapeHtml(d.note));
    text += `\n${d.note}\n`;
  }
  text += `\n${t.supprime}\n`;
  return { to: d.email, subject, html: layout(subject, body, site, langue), text };
}

// Nouveau justificatif : avertit les administrateurs (sans pièce jointe : le
// justificatif ne se consulte que sur le site, par un lien signé).
export function emailNouveauJustificatif(to: string, statut: string, site: string): OutgoingEmail {
  const subject = "Nouveau justificatif professionnel en formation à valider";
  const t = `Un membre (${STATUTS[statut] ?? statut}) a déposé un justificatif pour le tarif −30 %.`;
  const lien = `${site}/bibliotheque/etudiants`;
  const html = cadreEmail(
    subject,
    p(escapeHtml(t)) +
    `<p style="margin:22px 0"><a href="${lien}" style="background:#0E3A78;color:#ffffff;padding:12px 20px;border-radius:8px;font-weight:700;font-size:15px;text-decoration:none;display:inline-block">Examiner le justificatif</a></p>`,
    "E-mail de service destiné à l'équipe de medical-guidelines.net.",
  );
  return { to, subject, html, text: `${t}\n\nExaminer : ${lien}\n` };
}
