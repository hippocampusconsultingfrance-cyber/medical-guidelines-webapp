import { composerAvisRenouvellement, logRenouvellement } from "@/lib/commande";
import { emailEnabled, sendBatch, siteUrl, type OutgoingEmail } from "@/lib/email";
import {
  ciblesFinaliser,
  ciblesPremiereFiche,
  ciblesQuota,
  emailFinaliser,
  emailPremiereFiche,
  emailQuota,
  fichesSuggerees,
  LOG_FINALISER,
  LOG_PREMIERE,
  LOG_QUOTA,
} from "@/lib/relances";
import { checkoutOpen, getStripe, stripeEnabled } from "@/lib/stripe";
import { createAdminClient } from "@/lib/supabase/admin";

// Relances quotidiennes (tâche planifiée Vercel, vercel.json) : inscription
// non finalisée, aucune fiche ouverte après la finalisation, crédits
// gratuits épuisés, avis de renouvellement de
// l'abonnement (35 à 45 jours avant l'échéance, CGV §5). Authentifiée par
// CRON_SECRET ; une relance de chaque sorte au plus par membre, et un avis
// par échéance (notifications_log).
// ?apercu=1 renvoie le nombre de destinataires sans rien envoyer.
export async function GET(request: Request) {
  const secret = process.env.CRON_SECRET;
  if (!secret || request.headers.get("authorization") !== `Bearer ${secret}`) {
    return Response.json({ error: "Non autorisé" }, { status: 401 });
  }
  const admin = createAdminClient();
  const now = Date.now();
  const [finaliser, premiere, quota, echeances] = await Promise.all([
    ciblesFinaliser(admin, now),
    ciblesPremiereFiche(admin, now),
    ciblesQuota(admin, now),
    echeancesProches(admin, now),
  ]);
  if (new URL(request.url).searchParams.get("apercu") === "1") {
    return Response.json({
      finaliser: finaliser.length,
      premiere_fiche: premiere.length,
      quota: quota.length,
      renouvellement: echeances.length,
    });
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
  const suggestions = new Map<string, Awaited<ReturnType<typeof fichesSuggerees>>>();
  for (const c of premiere) {
    const cle = c.specialtyId ?? "";
    if (!suggestions.has(cle)) suggestions.set(cle, await fichesSuggerees(admin, c.specialtyId, site));
    const fiches = suggestions.get(cle) ?? [];
    if (fiches.length) lots.push({ userId: c.userId, body: LOG_PREMIERE, email: emailPremiereFiche(c, fiches, site) });
  }
  const vente = checkoutOpen(false);
  for (const c of quota) lots.push({ userId: c.userId, body: LOG_QUOTA, email: emailQuota(c, vente, site) });
  const avis = await avisRenouvellement(admin, echeances);
  for (const e of avis) {
    lots.push({ userId: e.userId, body: logRenouvellement(e.fin), email: composerAvisRenouvellement(e, site) });
  }
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
  return Response.json({
    finaliser: finaliser.length,
    premiere_fiche: premiere.length,
    quota: quota.length,
    renouvellement: avis.length,
  });
}

type Echeance = { userId: string; subscriptionId: string; fin: string };

// Abonnements actifs dont l'échéance tombe dans 35 à 45 jours (au moins un
// mois avant, article L215-1 du code de la consommation), sans avis
// déjà envoyé pour cette échéance.
async function echeancesProches(admin: ReturnType<typeof createAdminClient>, now: number): Promise<Echeance[]> {
  if (!stripeEnabled()) return [];
  const DAY = 24 * 3600 * 1000;
  const { data } = await admin
    .from("subscriptions")
    .select("user_id, stripe_subscription_id, current_period_end")
    .eq("status", "actif")
    .is("canceled_at", null)
    .not("stripe_subscription_id", "is", null)
    .gte("current_period_end", new Date(now + 35 * DAY).toISOString())
    .lte("current_period_end", new Date(now + 45 * DAY).toISOString());
  const out: Echeance[] = [];
  for (const s of data ?? []) {
    const fin = s.current_period_end as string;
    const { count } = await admin
      .from("notifications_log")
      .select("id", { count: "exact", head: true })
      .eq("user_id", s.user_id)
      .eq("body", logRenouvellement(fin));
    if (!count) out.push({ userId: s.user_id as string, subscriptionId: s.stripe_subscription_id as string, fin });
  }
  return out;
}

// Montant exact de la prochaine facture (remise éventuelle comprise), lu
// chez Stripe ; abonnement déjà résilié pour la fin de période : pas d'avis.
async function avisRenouvellement(admin: ReturnType<typeof createAdminClient>, echeances: Echeance[]) {
  const stripe = getStripe();
  const out: { userId: string; email: string; prenom: string | null; fin: string; montantCents: number }[] = [];
  for (const e of echeances) {
    try {
      const sub = await stripe.subscriptions.retrieve(e.subscriptionId);
      if (sub.cancel_at_period_end || sub.cancel_at || sub.status !== "active") continue;
      const facture = await stripe.invoices.createPreview({ subscription: e.subscriptionId });
      const [{ data: profil }, { data: compte }] = await Promise.all([
        admin.from("profiles").select("prenom").eq("id", e.userId).maybeSingle(),
        admin.auth.admin.getUserById(e.userId),
      ]);
      if (!compte?.user?.email) continue;
      out.push({ userId: e.userId, email: compte.user.email, prenom: (profil?.prenom as string | null) || null, fin: e.fin, montantCents: facture.total });
    } catch (err) {
      console.error("Avis de renouvellement", e.subscriptionId, err);
    }
  }
  return out;
}
