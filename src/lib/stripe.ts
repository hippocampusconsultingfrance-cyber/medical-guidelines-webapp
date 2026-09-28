import Stripe from "stripe";

// Paiement de l'abonnement PREMIUM (cahier des charges V4.5, §10).
// Variables d'environnement (Vercel) :
//   STRIPE_SECRET_KEY      clé secrète Stripe (sk_live_… ou sk_test_…)
//   STRIPE_PRICE_ID        prix annuel PREMIUM (price_…), 50 € TTC / an
//   STRIPE_WEBHOOK_SECRET  secret de signature du webhook (whsec_…)
//   STRIPE_TAX             « 1 » pour activer le calcul de TVA par Stripe Tax
// Tant que la clé ou le prix manquent, les abonnements sont affichés
// « bientôt ouverts » et aucun appel à Stripe n'est fait.

export const CGV_VERSION = "2026-09-29";

let client: Stripe | null = null;

export function stripeEnabled() {
  return Boolean(process.env.STRIPE_SECRET_KEY && process.env.STRIPE_PRICE_ID);
}

export function getStripe(): Stripe {
  const key = process.env.STRIPE_SECRET_KEY;
  if (!key) throw new Error("STRIPE_SECRET_KEY manquant");
  client ??= new Stripe(key);
  return client;
}

// Statut Stripe → statut de la base (seul « actif » ouvre l'accès PREMIUM).
export function toDbStatus(status: Stripe.Subscription.Status) {
  switch (status) {
    case "active":
    case "trialing":
      return "actif";
    case "canceled":
      return "annule";
    case "incomplete_expired":
      return "expire";
    default:
      return "en_retard"; // past_due, unpaid, incomplete, paused
  }
}

// Fin de la période payée : portée par l'élément d'abonnement dans les
// versions récentes de l'API Stripe, par l'abonnement dans les anciennes.
export function periodEnd(sub: Stripe.Subscription): string | null {
  const item = sub.items?.data?.[0] as { current_period_end?: number } | undefined;
  const legacy = (sub as unknown as { current_period_end?: number }).current_period_end;
  const ts = item?.current_period_end ?? legacy;
  return ts ? new Date(ts * 1000).toISOString() : null;
}
