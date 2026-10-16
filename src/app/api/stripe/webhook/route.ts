import { captureMessage } from "@sentry/nextjs";
import type Stripe from "stripe";
import { composerConfirmation, LOG_COMMANDE } from "@/lib/commande";
import { emailEnabled, sendBatch, siteUrl } from "@/lib/email";
import { createAdminClient } from "@/lib/supabase/admin";
import { APP, choisirAbonnement, getStripe, isOwnSubscription, periodEnd, toDbStatus } from "@/lib/stripe";

// Notifications Stripe (paiement, renouvellement, résiliation). Seule source
// d'écriture des abonnements : la signature Stripe authentifie l'appel, puis
// la ligne du membre est créée ou mise à jour avec la clé service_role.
// Le compte Stripe sert aussi à d'autres activités : leurs paiements et
// abonnements sont ignorés (réponse 200, rien n'est écrit).
// Stripe peut livrer les notifications en retard, en double ou dans le
// désordre : l'abonnement est toujours relu chez Stripe (état courant) avant
// d'être enregistré, et un ancien abonnement ne remplace jamais un abonnement
// actif plus récent du même membre (saveSubscription).
export async function POST(request: Request) {
  const secret = process.env.STRIPE_WEBHOOK_SECRET;
  const signature = request.headers.get("stripe-signature");
  if (!secret || !signature) {
    // Réponse identique dans les deux cas : rien n'indique à un tiers si le
    // webhook est configuré.
    if (!secret) console.error("Webhook Stripe : STRIPE_WEBHOOK_SECRET absent");
    return Response.json({ error: "Requête invalide" }, { status: 400 });
  }

  const stripe = getStripe();
  let event: Stripe.Event;
  try {
    event = stripe.webhooks.constructEvent(await request.text(), signature, secret);
  } catch {
    return Response.json({ error: "Signature invalide" }, { status: 400 });
  }

  try {
    if (event.type === "checkout.session.completed") {
      const session = event.data.object;
      const ours = session.metadata?.app === APP || Boolean(session.metadata?.cgv_version);
      if (ours && session.mode === "subscription" && typeof session.subscription === "string") {
        const { sub, userId } = await saveSubscription(session.subscription, session.client_reference_id);
        await confirmerCommande(session, sub, userId);
      }
    } else if (
      event.type === "customer.subscription.created" ||
      event.type === "customer.subscription.updated" ||
      event.type === "customer.subscription.deleted"
    ) {
      if (isOwnSubscription(event.data.object)) await saveSubscription(event.data.object.id, null);
    }
  } catch (e) {
    console.error("Webhook Stripe", event.type, e);
    // 500 : Stripe renverra la notification plus tard.
    return Response.json({ error: "Enregistrement impossible" }, { status: 500 });
  }

  return Response.json({ received: true });
}

async function saveSubscription(subscriptionId: string, clientReference: string | null) {
  // État courant chez Stripe, quel que soit l'ordre d'arrivée des notifications.
  const sub = await getStripe().subscriptions.retrieve(subscriptionId);
  const meta = sub.metadata ?? {};
  const customer = typeof sub.customer === "string" ? sub.customer : sub.customer.id;
  const admin = createAdminClient();

  // Membre : identifiant transmis à la création du paiement, sinon ligne
  // existante rattachée au même client Stripe.
  let userId = meta.user_id || clientReference || null;
  if (!userId) {
    const { data } = await admin
      .from("subscriptions")
      .select("user_id")
      .eq("stripe_customer_id", customer)
      .maybeSingle();
    userId = data?.user_id ?? null;
  }
  if (!userId) throw new Error(`Abonnement ${sub.id} sans membre associé`);

  // Un seul abonnement enregistré par membre : un ancien abonnement (résilié,
  // expiré) ne remplace pas un autre abonnement actif ; de deux abonnements
  // actifs (double paiement, à rembourser), celui qui finit le plus tard est
  // gardé.
  const status = toDbStatus(sub.status);
  const { data: existant, error: errExistant } = await admin
    .from("subscriptions")
    .select("stripe_subscription_id, status, current_period_end")
    .eq("user_id", userId)
    .maybeSingle();
  if (errExistant) throw errExistant;
  const decision = choisirAbonnement(existant, { id: sub.id, status, fin: periodEnd(sub) });
  if (decision === "double" || decision === "double_remplacer") {
    const detail = `deux abonnements actifs pour le membre ${userId} : ${existant?.stripe_subscription_id} et ${sub.id}`;
    console.error("Webhook Stripe :", detail);
    captureMessage(`Abonnement en double (${detail}) : rembourser l'un des deux`, "error");
  }
  if (decision === "garder" || decision === "double") return { sub, userId };

  const price = sub.items?.data?.[0]?.price?.unit_amount ?? null;
  const row = {
    user_id: userId,
    plan: "premium",
    status,
    stripe_customer_id: customer,
    stripe_subscription_id: sub.id,
    current_period_end: periodEnd(sub),
    canceled_at: sub.canceled_at ? new Date(sub.canceled_at * 1000).toISOString() : null,
    reference_price_cents: price,
    cgv_version: meta.cgv_version || null,
    cgv_accepted_at: meta.cgv_accepted_at || null,
    withdrawal_waiver_at: meta.withdrawal_waiver_at || null,
    updated_at: new Date().toISOString(),
  };
  const { error } = await admin.from("subscriptions").upsert(row, { onConflict: "user_id" });
  if (error) throw error;
  return { sub, userId };
}

// Confirmation de commande sur support durable (CGV §7), une fois par
// abonnement (notifications_log, clé d'idempotence Resend). Un échec d'envoi
// n'empêche pas l'enregistrement de l'abonnement : il est seulement journalisé.
async function confirmerCommande(session: Stripe.Checkout.Session, sub: Stripe.Subscription, userId: string) {
  if (!emailEnabled()) return;
  try {
    const admin = createAdminClient();
    const body = `${LOG_COMMANDE}:${sub.id}`;
    const { count } = await admin
      .from("notifications_log")
      .select("id", { count: "exact", head: true })
      .eq("user_id", userId)
      .eq("body", body);
    if (count) return;
    const [{ data: profil }, { data: compte }] = await Promise.all([
      admin.from("profiles").select("prenom").eq("id", userId).maybeSingle(),
      admin.auth.admin.getUserById(userId),
    ]);
    const to = compte?.user?.email ?? session.customer_details?.email;
    if (!to) return;
    const meta = sub.metadata ?? {};
    const email = composerConfirmation(
      {
        email: to,
        prenom: (profil?.prenom as string | null) || null,
        montantCents: session.amount_total ?? sub.items?.data?.[0]?.price?.unit_amount ?? 0,
        debut: new Date(sub.created * 1000).toISOString(),
        fin: periodEnd(sub),
        cgvVersion: meta.cgv_version || null,
        renonciation: meta.withdrawal_waiver_at || null,
      },
      siteUrl(),
    );
    const sent = await sendBatch([email], body);
    if (!sent.ok) {
      console.error("Confirmation de commande : envoi", sent.error);
      captureMessage(`Confirmation de commande non envoyée (abonnement ${sub.id}) : à renvoyer`, "error");
      return;
    }
    const { error } = await admin.from("notifications_log").insert({ user_id: userId, subject: email.subject, body, channel: "email" });
    if (error) console.error("Confirmation de commande : journal", error);
  } catch (e) {
    console.error("Confirmation de commande", e);
    captureMessage(`Confirmation de commande en échec (abonnement ${sub.id}) : à vérifier`, "error");
  }
}
