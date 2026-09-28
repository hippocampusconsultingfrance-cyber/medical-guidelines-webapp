"use server";

import { headers } from "next/headers";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { CGV_VERSION, getStripe, stripeEnabled } from "@/lib/stripe";

async function origin() {
  const h = await headers();
  const host = h.get("x-forwarded-host") ?? h.get("host");
  const proto = h.get("x-forwarded-proto") ?? "https";
  return `${proto}://${host}`;
}

// Démarre le paiement Stripe de l'abonnement PREMIUM. Les deux cases
// (CGV ; exécution immédiate et renonciation au droit de rétractation) sont
// obligatoires ; leur date et la version des CGV suivent l'abonnement
// (métadonnées Stripe → base, via le webhook). Codes promotionnels
// (FONDATEURS, codes étudiants personnels) saisis sur la page Stripe : un
// seul code par paiement, donc pas de cumul.
export async function startCheckout(formData: FormData) {
  if (!stripeEnabled()) redirect("/abonnement");
  if (formData.get("cgv") !== "1" || formData.get("retractation") !== "1") {
    redirect("/abonnement?r=cases");
  }

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");

  const { data: existing } = await supabase
    .from("subscriptions")
    .select("stripe_customer_id")
    .eq("user_id", user.id)
    .maybeSingle();

  const now = new Date().toISOString();
  const metadata = {
    user_id: user.id,
    cgv_version: CGV_VERSION,
    cgv_accepted_at: now,
    withdrawal_waiver_at: now,
  };
  const base = await origin();
  const session = await getStripe().checkout.sessions.create({
    mode: "subscription",
    line_items: [{ price: process.env.STRIPE_PRICE_ID!, quantity: 1 }],
    client_reference_id: user.id,
    ...(existing?.stripe_customer_id
      ? { customer: existing.stripe_customer_id, customer_update: { address: "auto", name: "auto" } }
      : { customer_email: user.email }),
    subscription_data: { metadata },
    metadata,
    allow_promotion_codes: true,
    billing_address_collection: "required",
    tax_id_collection: { enabled: true },
    automatic_tax: { enabled: process.env.STRIPE_TAX === "1" },
    locale: "fr",
    success_url: `${base}/abonnement?r=merci`,
    cancel_url: `${base}/abonnement?r=annule`,
  });
  redirect(session.url!);
}

// Espace client Stripe : factures, moyen de paiement, résiliation.
export async function openPortal() {
  if (!stripeEnabled()) redirect("/abonnement");
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data } = await supabase
    .from("subscriptions")
    .select("stripe_customer_id")
    .eq("user_id", user.id)
    .maybeSingle();
  if (!data?.stripe_customer_id) redirect("/abonnement");

  const portal = await getStripe().billingPortal.sessions.create({
    customer: data.stripe_customer_id,
    return_url: `${await origin()}/abonnement`,
    locale: "fr",
  });
  redirect(portal.url);
}
