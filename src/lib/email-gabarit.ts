import { escapeHtml } from "@/lib/fiches";
import { direction, type Langue } from "@/lib/langues";

// Gabarit commun des e-mails envoyés aux membres : fond gris clair, carte
// blanche, bandeau bleu marine avec le nom du site, pied de page discret.
// Mise en page en tableaux et styles en ligne (lus par toutes les
// messageries, y compris Outlook).
export function cadreEmail(subject: string, corps: string, pied: string, langue: Langue = "fr") {
  return (
    `<!doctype html><html lang="${langue}" dir="${direction(langue)}"><head><meta charset="utf-8">` +
    `<meta name="viewport" content="width=device-width, initial-scale=1">` +
    `<title>${escapeHtml(subject)}</title></head>` +
    `<body style="margin:0;padding:0;background-color:#F1F5F9">` +
    `<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background-color:#F1F5F9">` +
    `<tr><td align="center" style="padding:24px 12px">` +
    `<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="max-width:600px;background-color:#ffffff;border-radius:12px;overflow:hidden;font-family:Arial,Helvetica,sans-serif;color:#0F172A">` +
    `<tr><td style="background-color:#0E3A78;padding:18px 28px">` +
    `<span style="font-size:19px;font-weight:700;color:#ffffff">medical-guidelines<span style="color:#7CC8F0">.net</span></span>` +
    `</td></tr>` +
    `<tr><td style="padding:28px 28px 8px">${corps}</td></tr>` +
    `<tr><td style="padding:0 28px 24px;border-top:1px solid #E2E8F0">` +
    `<div style="font-size:12px;line-height:1.5;color:#64748B;padding-top:16px">${pied}</div>` +
    `</td></tr></table></td></tr></table></body></html>`
  );
}
