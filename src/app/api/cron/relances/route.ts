import { emailEnabled, sendBatch, siteUrl, type OutgoingEmail } from "@/lib/email";
import { ciblesFinaliser, ciblesQuota, emailFinaliser, emailQuota, LOG_FINALISER, LOG_QUOTA } from "@/lib/relances";
import { checkoutOpen } from "@/lib/stripe";
import { createAdminClient } from "@/lib/supabase/admin";

// Relances quotidiennes (tâche planifiée Vercel, vercel.json) : inscription
// non finalisée, crédits gratuits épuisés. Authentifiée par CRON_SECRET ;
// une relance de chaque sorte au plus par membre (notifications_log).
// ?apercu=1 renvoie le nombre de destinataires sans rien envoyer.
export async function GET(request: Request) {
  const secret = process.env.CRON_SECRET;
  if (!secret || request.headers.get("authorization") !== `Bearer ${secret}`) {
    return Response.json({ error: "Non autorisé" }, { status: 401 });
  }
  const admin = createAdminClient();
  const now = Date.now();
  const [finaliser, quota] = await Promise.all([ciblesFinaliser(admin, now), ciblesQuota(admin, now)]);
  if (new URL(request.url).searchParams.get("apercu") === "1") {
    return Response.json({ finaliser: finaliser.length, quota: quota.length });
  }
  if (!emailEnabled()) return Response.json({ envoyes: 0, info: "RESEND_API_KEY manquant : aucun envoi" });

  const site = siteUrl();
  const lots: { userId: string; body: string; email: OutgoingEmail }[] = [];
  for (const c of finaliser) {
    // Lien de connexion à usage unique vers la finalisation du compte.
    const { data, error } = await admin.auth.admin.generateLink({ type: "magiclink", email: c.email });
    const hash = data?.properties?.hashed_token;
    if (error || !hash) continue;
    lots.push({ userId: c.userId, body: LOG_FINALISER, email: emailFinaliser(c, `${site}/auth/callback?token_hash=${hash}&type=email`, site) });
  }
  const vente = checkoutOpen(false);
  for (const c of quota) lots.push({ userId: c.userId, body: LOG_QUOTA, email: emailQuota(c, vente, site) });
  if (!lots.length) return Response.json({ envoyes: 0 });

  const jour = new Date(now).toISOString().slice(0, 10);
  const sent = await sendBatch(
    lots.map((l) => l.email),
    `relances-${jour}-${lots.map((l) => l.userId.slice(0, 8)).join("")}`.slice(0, 250),
  );
  if (!sent.ok) {
    console.error("Relances", sent.error);
    return Response.json({ error: "Envoi impossible" }, { status: 502 });
  }
  await admin
    .from("notifications_log")
    .insert(lots.map((l) => ({ user_id: l.userId, subject: l.email.subject, body: l.body, channel: "email" })));
  return Response.json({ finaliser: finaliser.length, quota: quota.length });
}
