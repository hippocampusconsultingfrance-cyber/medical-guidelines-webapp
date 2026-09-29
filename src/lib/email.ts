import "server-only";

// Envoi des e-mails d'alerte par Resend, déjà utilisé pour les e-mails de
// service (voir la politique de confidentialité). Appel direct de l'API
// HTTP : aucune dépendance supplémentaire.
// Variables d'environnement (Vercel) :
//   RESEND_API_KEY  clé d'API Resend (re_…), domaine d'envoi vérifié
//   ALERTS_FROM     expéditeur, par défaut « medical-guidelines.net
//                   <alertes@medical-guidelines.net> »
//   SITE_URL        adresse du site dans les liens, par défaut
//                   https://www.medical-guidelines.net (le domaine nu y redirige)
// Sans clé, aucun e-mail n'est envoyé.

export type OutgoingEmail = {
  to: string;
  subject: string;
  html: string;
  text: string;
  headers?: Record<string, string>;
};

export function emailEnabled() {
  return Boolean(process.env.RESEND_API_KEY);
}

export function siteUrl() {
  return (process.env.SITE_URL ?? "https://www.medical-guidelines.net").replace(/\/+$/, "");
}

// Envoi groupé (100 e-mails au plus par appel, limite de Resend). La clé
// d'idempotence évite un double envoi si l'appel est rejoué dans les 24 h.
export async function sendBatch(emails: OutgoingEmail[], idempotencyKey: string) {
  const key = process.env.RESEND_API_KEY;
  if (!key) return { ok: false as const, error: "RESEND_API_KEY manquant" };
  const from = process.env.ALERTS_FROM ?? "medical-guidelines.net <alertes@medical-guidelines.net>";
  const res = await fetch("https://api.resend.com/emails/batch", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${key}`,
      "Content-Type": "application/json",
      "Idempotency-Key": idempotencyKey,
    },
    body: JSON.stringify(emails.map((e) => ({ from, to: [e.to], subject: e.subject, html: e.html, text: e.text, headers: e.headers }))),
  });
  if (!res.ok) return { ok: false as const, error: `Resend ${res.status} : ${(await res.text()).slice(0, 300)}` };
  return { ok: true as const };
}
