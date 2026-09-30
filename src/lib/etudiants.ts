import "server-only";
import type { OutgoingEmail } from "@/lib/email";
import { escapeHtml } from "@/lib/fiches";

// Tarif médecin en formation (CGV §4) : −30 % la première année sur
// justificatif de l'année universitaire en cours, validé par un
// administrateur. Coupon Stripe : STRIPE_STUDENT_COUPON_ID (marqué
// metadata.app = medical-guidelines, metadata.kind = etudiant).

export const STATUTS: Record<string, string> = {
  externe: "Externe (étudiant hospitalier)",
  interne: "Interne",
  resident: "Résident",
  docteur_junior: "Docteur junior",
  autre: "Autre étudiant en santé",
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

function layout(subject: string, body: string, site: string) {
  return (
    `<!doctype html><html lang="fr"><head><meta charset="utf-8">` +
    `<meta name="viewport" content="width=device-width, initial-scale=1">` +
    `<title>${escapeHtml(subject)}</title></head>` +
    `<body style="margin:0;padding:24px 16px;background-color:#ffffff">` +
    `<div style="font-family:Arial,Helvetica,sans-serif;max-width:620px;margin:0 auto;color:#0F172A">` +
    `<p style="font-size:18px;font-weight:700;color:#0E3A78">medical-guidelines<span style="color:#3AA8E0">.net</span></p>` +
    body +
    `<p style="font-size:12px;color:#64748B;margin-top:28px">Votre justificatif a été supprimé après examen. ` +
    `<a href="${site}/abonnement" style="color:#64748B">Mon abonnement</a></p></div></body></html>`
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
): OutgoingEmail {
  const hello = d.prenom ? `Bonjour ${d.prenom},` : "Bonjour,";
  const subject = d.valide ? "Votre tarif médecin en formation est validé" : "Votre demande de tarif médecin en formation";
  let body = p(escapeHtml(hello));
  let text = `${hello}\n\n`;
  if (d.valide && d.surAbonnement) {
    const t = "Votre justificatif est validé : la réduction de 30 % s'appliquera automatiquement à votre prochain renouvellement.";
    body += p(t);
    text += `${t}\n`;
  } else if (d.valide) {
    const t = "Votre justificatif est validé. Voici votre code personnel, valable une fois, pour 30 % de réduction sur votre première année PREMIUM :";
    body +=
      p(t) +
      `<p style="font-size:22px;font-weight:800;letter-spacing:2px;color:#0E3A78;margin:8px 0 18px">${escapeHtml(d.code ?? "")}</p>` +
      p(`Il est déjà prérempli sur votre page d'abonnement.`) +
      `<p style="margin:22px 0"><a href="${site}/abonnement" style="background:#0E3A78;color:#ffffff;padding:12px 20px;border-radius:8px;font-weight:700;font-size:15px;text-decoration:none;display:inline-block">Activer PREMIUM</a></p>`;
    text += `${t}\n\n${d.code}\n\nIl est déjà prérempli sur votre page d'abonnement : ${site}/abonnement\n`;
  } else {
    const t = "Nous n'avons pas pu valider votre justificatif.";
    body += p(t) + (d.note ? p(`<b>Motif :</b> ${escapeHtml(d.note)}`) : "") + p("Vous pouvez déposer un nouveau justificatif depuis votre page d'abonnement.");
    text += `${t}\n${d.note ? `Motif : ${d.note}\n` : ""}Vous pouvez déposer un nouveau justificatif : ${site}/abonnement\n`;
  }
  if (d.valide && d.note) {
    body += p(escapeHtml(d.note));
    text += `\n${d.note}\n`;
  }
  text += `\nVotre justificatif a été supprimé après examen.\n`;
  return { to: d.email, subject, html: layout(subject, body, site), text };
}
