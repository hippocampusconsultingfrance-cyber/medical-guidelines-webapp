import type Stripe from "stripe";
import { createAdminClient } from "@/lib/supabase/admin";
import { getStripe, periodEnd, toDbStatus } from "@/lib/stripe";

// Notifications Stripe (paiement, renouvellement, résiliation). Seule source
// d'écriture des abonnements : la signature Stripe authentifie l'appel, puis
// la ligne du membre est créée ou mise à jour avec la clé service_role.
export async function POST(request: Request) {
  const secret = process.env.STRIPE_WEBHOOK_SECRET;
  const signature = request.headers.get("stripe-signature");
  if (!secret || !signature) {
    return Response.json({ error: "Webhook non configuré" }, { status: 400 });
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
      if (session.mode === "subscription" && typeof session.subscription === "string") {
        const sub = await stripe.subscriptions.retrieve(session.subscription);
        await saveSubscription(sub, session.client_reference_id);
      }
    } else if (
      event.type === "customer.subscription.created" ||
      event.type === "customer.subscription.updated" ||
      event.type === "customer.subscription.deleted"
    ) {
      await saveSubscription(event.data.object, null);
    }
  } catch (e) {
    console.error("Webhook Stripe", event.type, e);
    // 500 : Stripe renverra la notification plus tard.
    return Response.json({ error: "Enregistrement impossible" }, { status: 500 });
  }

  return Response.json({ received: true });
}

async function saveSubscription(sub: Stripe.Subscription, clientReference: string | null) {
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

  const price = sub.items?.data?.[0]?.price?.unit_amount ?? null;
  const row = {
    user_id: userId,
    plan: "premium",
    status: toDbStatus(sub.status),
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
}
