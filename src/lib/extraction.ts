import "server-only";
import { emailEnabled, sendBatch, siteUrl, type OutgoingEmail } from "@/lib/email";
import { escapeHtml } from "@/lib/fiches";
import { createAdminClient } from "@/lib/supabase/admin";

// Protection contre l'extraction (cahier des charges §11) : la base suspend
// la lecture d'un compte qui ouvre trop de fiches différentes trop vite
// (migration 20260930110000_anti_extraction.sql). Ce module prévient les
// administrateurs, une seule fois par suspension (access_blocks.notified_at).

export const RAISONS: Record<string, string> = {
  rythme_10min: "plus de 20 fiches différentes en 10 minutes",
  volume_24h: "plus de 60 fiches différentes en 24 heures",
};

function email(to: string, compte: string, raison: string, jusqua: string, site: string): OutgoingEmail {
  const subject = "Accès anormal : lecture suspendue pour un compte";
  const t = `Le compte ${compte} a ouvert ${raison}. Sa lecture est suspendue jusqu'au ${jusqua}.`;
  const lien = `${site}/bibliotheque/acces`;
  const html =
    `<!doctype html><html lang="fr"><head><meta charset="utf-8"><title>${escapeHtml(subject)}</title></head>` +
    `<body style="margin:0;padding:24px 16px;background-color:#ffffff">` +
    `<div style="font-family:Arial,Helvetica,sans-serif;max-width:620px;margin:0 auto;color:#0F172A">` +
    `<p style="font-size:15px;line-height:1.55">${escapeHtml(t)}</p>` +
    `<p style="font-size:15px;line-height:1.55">Si c'est un usage normal, vous pouvez lever la suspension.</p>` +
    `<p style="margin:22px 0"><a href="${lien}" style="background:#0E3A78;color:#ffffff;padding:12px 20px;border-radius:8px;font-weight:700;font-size:15px;text-decoration:none;display:inline-block">Voir les accès anormaux</a></p>` +
    `</div></body></html>`;
  return { to, subject, html, text: `${t}\nSi c'est un usage normal, vous pouvez lever la suspension : ${lien}\n` };
}

// Envoie aux administrateurs les suspensions pas encore signalées. Ne lève
// jamais d'erreur : l'alerte ne doit pas empêcher d'afficher la page.
export async function signalerSuspensions() {
  if (!emailEnabled()) return;
  try {
    const admin = createAdminClient();
    const { data: blocs } = await admin
      .from("access_blocks")
      .select("id, user_id, reason, blocked_until")
      .is("notified_at", null)
      .limit(20);
    if (!blocs?.length) return;
    const { data: admins } = await admin.from("profiles").select("id").eq("editorial_role", "admin");
    const destinataires: string[] = [];
    for (const a of admins ?? []) {
      const { data } = await admin.auth.admin.getUserById(a.id as string);
      if (data?.user?.email) destinataires.push(data.user.email);
    }
    for (const b of blocs) {
      const { data: u } = await admin.auth.admin.getUserById(b.user_id as string);
      const compte = u?.user?.email ?? (b.user_id as string);
      const jusqua = new Date(b.blocked_until as string).toLocaleString("fr-FR", { timeZone: "Europe/Paris" });
      const raison = RAISONS[b.reason as string] ?? (b.reason as string);
      if (destinataires.length) {
        const sent = await sendBatch(
          destinataires.map((to) => email(to, compte, raison, jusqua, siteUrl())),
          `blocage-${b.id}`,
        );
        if (!sent.ok) {
          console.error("Anti-extraction : alerte", sent.error);
          continue;
        }
      }
      await admin.from("access_blocks").update({ notified_at: new Date().toISOString() }).eq("id", b.id);
    }
  } catch (e) {
    console.error("Anti-extraction : alerte", e);
  }
}
