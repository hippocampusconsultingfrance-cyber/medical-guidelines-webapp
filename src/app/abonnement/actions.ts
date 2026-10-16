"use server";

import { headers } from "next/headers";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { deposerJustificatif } from "@/lib/etudiants-depot";
import { isEditorialAccount } from "@/lib/roles";
import { APP, CGV_VERSION, checkoutOpen, getStripe, isOwnSubscription, promotionCodeFor, stripeEnabled } from "@/lib/stripe";

// Client Stripe déjà connu, s'il existe dans le mode courant : un client
// créé en mode test n'existe pas en mode réel (et inversement).
async function knownCustomer(id: string | null | undefined) {
  if (!id) return null;
  try {
    const c = await getStripe().customers.retrieve(id);
    return c.deleted ? null : c.id;
  } catch {
    return null;
  }
}

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
// (FONDATEURS, codes étudiants personnels) saisis sur le site et vérifiés
// (promotionCodeFor) : un seul code par paiement, donc pas de cumul.
// Jamais deux abonnements : un abonné est renvoyé vers sa page, une seule
// ouverture de paiement à la fois (reserver_paiement), les sessions de
// paiement encore ouvertes du membre sont fermées avant d'en créer une, et
// la création porte une clé d'idempotence.
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
  const editeur = await isEditorialAccount(supabase, user.id);
  if (!checkoutOpen(editeur)) redirect("/abonnement");

  const [{ data: dejaPremium, error: errPremium }, { data: ouvert }] = await Promise.all([
    supabase.rpc("has_premium"),
    supabase.rpc("catalogue_ouvert"),
  ]);
  if (errPremium) redirect("/abonnement?r=erreur");
  if (dejaPremium) redirect("/abonnement?r=deja_abonne");
  // Spécialité encore peu couverte : abonnement non proposé (@/lib/catalogue).
  if (ouvert && !editeur) redirect("/abonnement?r=specialite");

  const { data: reservation, error: errReservation } = await supabase.rpc("reserver_paiement");
  if (errReservation) redirect("/abonnement?r=erreur");
  if (!reservation) redirect("/abonnement?r=paiement_en_cours");

  const { data: existing } = await supabase
    .from("subscriptions")
    .select("stripe_customer_id")
    .eq("user_id", user.id)
    .maybeSingle();

  // Code promotionnel saisi sur le site (FONDATEURS, codes étudiants) :
  // seuls les codes créés pour ce site sont acceptés, jamais ceux des
  // autres activités du même compte Stripe.
  // Professionnel en formation : pas de paiement pendant l'examen du justificatif ;
  // une fois validé, sa remise personnelle (−30 %, usage unique) s'applique
  // d'office et remplace tout code saisi : jamais de cumul.
  const { data: demande } = await supabase
    .from("student_discount_requests")
    .select("status, promotion_code")
    .eq("user_id", user.id)
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();
  if (demande?.status === "en_attente") redirect("/abonnement?r=etudiant_attente#etudiant");
  const remiseEtudiant =
    demande?.status === "valide" && demande.promotion_code
      ? await promotionCodeFor(demande.promotion_code as string, user.id)
      : null;
  const code = remiseEtudiant ? "" : String(formData.get("code") ?? "");
  const promotionCode = remiseEtudiant ?? (code.trim() ? await promotionCodeFor(code, user.id) : null);
  if (code.trim() && !promotionCode) redirect("/abonnement?r=code");

  // Client Stripe propre au membre : factures affichées TTC (prix TVA
  // incluse, comme pour un particulier : 50,00 € − remise = total, dont TVA).
  const stripe = getStripe();
  const rendering = { rendering_options: { amount_tax_display: "include_inclusive_tax" as const } };
  // Client déjà créé lors d'un paiement abandonné : réutilisé (pas de
  // doublon dans Stripe), retrouvé par ses métadonnées.
  let known = await knownCustomer(existing?.stripe_customer_id);
  if (!known) {
    const found = await stripe.customers
      .search({ query: `metadata['app']:'${APP}' AND metadata['user_id']:'${user.id}'`, limit: 1 })
      .catch(() => null);
    known = found?.data[0]?.id ?? null;
  }
  if (known) {
    // Abonnement déjà souscrit (notification Stripe pas encore reçue) ou
    // paiement en cours de confirmation : pas de second abonnement.
    const subs = await stripe.subscriptions.list({ customer: known, status: "all", limit: 20 });
    const actif = subs.data.find(
      (s) => isOwnSubscription(s) && ["active", "trialing", "past_due", "unpaid", "incomplete"].includes(s.status),
    );
    if (actif) redirect(actif.status === "incomplete" ? "/abonnement?r=paiement_en_cours" : "/abonnement?r=deja_abonne");
    // Sessions de paiement encore ouvertes (autre onglet, essai abandonné) :
    // fermées, pour qu'un seul paiement reste possible.
    const ouvertes = await stripe.checkout.sessions.list({ customer: known, status: "open", limit: 20 });
    for (const s of ouvertes.data) {
      if (s.metadata?.app === APP) await stripe.checkout.sessions.expire(s.id).catch(() => null);
    }
  }
  const customer = known
    ? (await stripe.customers.update(known, { invoice_settings: rendering })).id
    : (
        await stripe.customers.create({
          email: user.email,
          metadata: { app: APP, user_id: user.id },
          invoice_settings: rendering,
        })
      ).id;
  const now = new Date().toISOString();
  const metadata = {
    app: APP,
    user_id: user.id,
    cgv_version: CGV_VERSION,
    cgv_accepted_at: now,
    withdrawal_waiver_at: now,
  };
  const base = await origin();
  const autoTax = process.env.STRIPE_TAX === "1";
  const taxRate = process.env.STRIPE_TAX_RATE_ID;
  const session = await stripe.checkout.sessions.create(
    {
      mode: "subscription",
      // Carte bancaire seulement (Apple Pay et Google Pay inclus) : fiable pour
      // le renouvellement automatique annuel, indépendamment des moyens de
      // paiement activés pour les autres activités du compte Stripe.
      payment_method_types: ["card"],
      line_items: [
        {
          price: process.env.STRIPE_PRICE_ID!,
          quantity: 1,
          // TVA 20 % incluse (taux fixe), sauf si Stripe Tax la calcule.
          ...(autoTax || !taxRate ? {} : { tax_rates: [taxRate] }),
        },
      ],
      client_reference_id: user.id,
      customer,
      customer_update: { address: "auto", name: "auto" },
      subscription_data: { metadata },
      metadata,
      ...(promotionCode ? { discounts: [{ promotion_code: promotionCode }] } : {}),
      billing_address_collection: "required",
      tax_id_collection: { enabled: true },
      automatic_tax: { enabled: autoTax },
      locale: "fr",
      success_url: `${base}/abonnement?r=merci`,
      cancel_url: `${base}/abonnement?r=annule`,
    },
    // Une tentative (réservation) = une session, même si l'appel est rejoué.
    { idempotencyKey: `checkout-${user.id}-${reservation}` },
  );
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
  const customer = await knownCustomer(data?.stripe_customer_id);
  if (!customer) redirect("/abonnement?r=portail");

  const configuration = process.env.STRIPE_PORTAL_CONFIG_ID;
  const portal = await getStripe().billingPortal.sessions.create({
    customer,
    ...(configuration ? { configuration } : {}),
    return_url: `${await origin()}/abonnement`,
    locale: "fr",
  });
  redirect(portal.url);
}

// Résiliation en un clic (loi du 16 août 2022, art. L215-1-1 du code de la
// consommation) : ouvre directement l'écran de résiliation du portail
// Stripe pour l'abonnement payé du membre ; l'accès reste ouvert jusqu'à la
// fin de la période payée (le webhook enregistre la résiliation).
export async function resilier() {
  if (!stripeEnabled()) redirect("/abonnement");
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data } = await supabase
    .from("subscriptions")
    .select("stripe_customer_id, stripe_subscription_id")
    .eq("user_id", user.id)
    .maybeSingle();
  const customer = await knownCustomer(data?.stripe_customer_id);
  if (!customer || !data?.stripe_subscription_id) redirect("/abonnement?r=portail");

  const retour = `${await origin()}/abonnement`;
  const configuration = process.env.STRIPE_PORTAL_CONFIG_ID;
  const portal = await getStripe().billingPortal.sessions.create({
    customer: customer!,
    ...(configuration ? { configuration } : {}),
    return_url: retour,
    locale: "fr",
    flow_data: {
      type: "subscription_cancel",
      subscription_cancel: { subscription: data!.stripe_subscription_id as string },
      after_completion: { type: "redirect", redirect: { return_url: `${retour}?r=resiliation` } },
    },
  });
  redirect(portal.url);
}

// Demande de tarif professionnel en formation depuis la page Abonnement.
export async function demanderTarifEtudiant(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const r = await deposerJustificatif(user.id, formData);
  redirect(`/abonnement?r=${r}#etudiant`);
}
