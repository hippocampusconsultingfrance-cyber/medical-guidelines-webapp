import Stripe from "stripe";
import { mediateurRenseigne } from "./legal";

// Paiement de l'abonnement PREMIUM (cahier des charges V4.5, §10).
// Variables d'environnement (Vercel) :
//   STRIPE_SECRET_KEY      clé secrète Stripe (sk_live_… ou sk_test_…)
//   STRIPE_PRICE_ID        prix annuel PREMIUM (price_…), 50 € TTC / an
//   STRIPE_WEBHOOK_SECRET  secret de signature du webhook (whsec_…)
//   STRIPE_TAX_RATE_ID     taux de TVA fixe (txr_…) : TVA française 20 %,
//                          incluse dans le prix (régime retenu avec
//                          l'expert-comptable) ; figure sur les factures
//   STRIPE_STUDENT_COUPON_ID coupon « professionnel en formation » (−30 %, 1re année)
//   STRIPE_PORTAL_CONFIG_ID configuration du portail client (bpc_…) propre
//                          au site ; sinon, celle par défaut du compte
//   STRIPE_TAX             « 1 » pour laisser Stripe Tax calculer la TVA à la
//                          place du taux fixe (service payant de Stripe)
// Tant que la clé ou le prix manquent, les abonnements sont affichés
// « bientôt ouverts » et aucun appel à Stripe n'est fait.
//
// Garde-fous (docs/PASSAGE_PAIEMENT_REEL.md) :
//   - clé de test (sk_test_…) : paiement ouvert à l'équipe éditoriale
//     seulement, pour les essais ; sinon n'importe quel membre obtiendrait
//     PREMIUM avec une carte de test publique ;
//   - clé réelle (sk_live_…) : paiement ouvert à tous, une fois le
//     médiateur de la consommation renseigné (lib/legal.ts).

export const CGV_VERSION = "2026-10-03-2";

let client: Stripe | null = null;

export function stripeEnabled() {
  return Boolean(process.env.STRIPE_SECRET_KEY && process.env.STRIPE_PRICE_ID);
}

export function stripeMode(): "live" | "test" | null {
  const key = process.env.STRIPE_SECRET_KEY ?? "";
  if (key.startsWith("sk_live_") || key.startsWith("rk_live_")) return "live";
  if (key.startsWith("sk_test_") || key.startsWith("rk_test_")) return "test";
  return null;
}

// Le paiement est-il proposé à ce compte ? (voir les garde-fous ci-dessus)
export function checkoutOpen(isEditor: boolean) {
  if (!stripeEnabled()) return false;
  const mode = stripeMode();
  if (mode === "test") return isEditor;
  return mode === "live" && mediateurRenseigne();
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

// Le compte Stripe (Hippocampus Consulting) sert aussi à d'autres activités :
// seuls les objets marqués metadata.app = APP concernent ce site (codes
// promotionnels acceptés, abonnements enregistrés par le webhook).
export const APP = "medical-guidelines";

// Code promotionnel saisi par le membre : accepté seulement s'il existe,
// est actif et que son coupon est marqué pour ce site. Renvoie son id.
export async function promotionCodeFor(code: string, userId: string): Promise<string | null> {
  const clean = code.trim().toUpperCase().replace(/[^A-Z0-9_-]/g, "").slice(0, 40);
  if (!clean) return null;
  const list = await getStripe().promotionCodes.list({
    code: clean,
    active: true,
    limit: 1,
    expand: ["data.promotion.coupon"],
  });
  const pc = list.data[0];
  const coupon = pc?.promotion?.coupon;
  if (!pc || !coupon || typeof coupon === "string") return null;
  if (!coupon.valid || coupon.metadata?.app !== APP) return null;
  // Code étudiant : personnel, utilisable seulement par le membre à qui il a
  // été attribué après validation de son justificatif.
  if (coupon.metadata?.kind === "etudiant" && pc.metadata?.user_id !== userId) return null;
  return pc.id;
}

// L'abonnement Stripe a-t-il été souscrit sur ce site ? (métadonnées posées
// par startCheckout, ou prix PREMIUM du site)
export function isOwnSubscription(sub: Stripe.Subscription) {
  if (sub.metadata?.app === APP || sub.metadata?.cgv_version) return true;
  const price = process.env.STRIPE_PRICE_ID;
  return Boolean(price && sub.items?.data?.some((i) => i.price?.id === price));
}

// Notification d'un abonnement pour un membre qui en a déjà un enregistré :
// faut-il le remplacer ? Un abonnement non actif ne remplace jamais un autre
// abonnement actif (notification ancienne ou en retard). Deux abonnements
// actifs signalent un double paiement (« double », gardé tel quel, ou
// « double_remplacer » si le nouveau finit plus tard).
export type Enregistre = { stripe_subscription_id: string | null; status: string; current_period_end: string | null };
export function choisirAbonnement(
  existant: Enregistre | null,
  entrant: { id: string; status: string; fin: string | null },
  maintenant = new Date(),
): "remplacer" | "garder" | "double" | "double_remplacer" {
  if (!existant?.stripe_subscription_id || existant.stripe_subscription_id === entrant.id) return "remplacer";
  const autreActif =
    existant.status === "actif" && (!existant.current_period_end || new Date(existant.current_period_end) > maintenant);
  if (!autreActif) return "remplacer";
  if (entrant.status !== "actif") return "garder";
  const plusTard =
    Boolean(entrant.fin) && (!existant.current_period_end || new Date(entrant.fin!) > new Date(existant.current_period_end));
  return plusTard ? "double_remplacer" : "double";
}
