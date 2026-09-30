"use server";

import { headers } from "next/headers";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { emailEnabled, sendBatch, siteUrl } from "@/lib/email";
import { anneeUniversitaire, emailNouveauJustificatif, JUSTIFICATIF_MAX, JUSTIFICATIF_TYPES, signatureValide, STATUTS } from "@/lib/etudiants";
import { isEditorialAccount } from "@/lib/roles";
import { APP, CGV_VERSION, checkoutOpen, getStripe, promotionCodeFor, stripeEnabled } from "@/lib/stripe";

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
  if (!checkoutOpen(await isEditorialAccount(supabase, user.id))) redirect("/abonnement");

  const { data: existing } = await supabase
    .from("subscriptions")
    .select("stripe_customer_id")
    .eq("user_id", user.id)
    .maybeSingle();

  // Code promotionnel saisi sur le site (FONDATEURS, codes étudiants) :
  // seuls les codes créés pour ce site sont acceptés, jamais ceux des
  // autres activités du même compte Stripe.
  const code = String(formData.get("code") ?? "");
  const promotionCode = code.trim() ? await promotionCodeFor(code, user.id) : null;
  if (code.trim() && !promotionCode) redirect("/abonnement?r=code");

  const customer = await knownCustomer(existing?.stripe_customer_id);
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
  const session = await getStripe().checkout.sessions.create({
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
    ...(customer
      ? { customer, customer_update: { address: "auto", name: "auto" } }
      : { customer_email: user.email }),
    subscription_data: { metadata },
    metadata,
    ...(promotionCode ? { discounts: [{ promotion_code: promotionCode }] } : {}),
    billing_address_collection: "required",
    tax_id_collection: { enabled: true },
    automatic_tax: { enabled: autoTax },
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

// Demande de tarif médecin en formation : dépôt du justificatif (PDF, JPEG
// ou PNG, 3 Mo au plus) dans le bucket privé « justificatifs », avec la clé
// service_role après contrôle du compte. Une seule demande en attente à la
// fois.
export async function demanderTarifEtudiant(formData: FormData) {
  const back = (r: string) => redirect(`/abonnement?r=${r}#etudiant`);
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");

  const statut = String(formData.get("statut") ?? "");
  const file = formData.get("justificatif");
  if (!(statut in STATUTS)) back("etudiant_statut");
  if (formData.get("atteste") !== "1") back("etudiant_atteste");
  if (!(file instanceof File) || file.size === 0) back("etudiant_fichier");
  const f = file as File;
  const ext = JUSTIFICATIF_TYPES[f.type];
  if (!ext) back("etudiant_format");
  if (f.size > JUSTIFICATIF_MAX) back("etudiant_taille");
  const bytes = new Uint8Array(await f.arrayBuffer());
  if (!signatureValide(bytes, f.type)) back("etudiant_format");

  const admin = createAdminClient();
  const { count } = await admin
    .from("student_discount_requests")
    .select("id", { count: "exact", head: true })
    .eq("user_id", user.id)
    .eq("status", "en_attente");
  if ((count ?? 0) > 0) back("etudiant_deja");

  const path = `${user.id}/${crypto.randomUUID()}.${ext}`;
  const { error: upError } = await admin.storage.from("justificatifs").upload(path, bytes, { contentType: f.type });
  if (upError) {
    console.error("Justificatif : dépôt", upError);
    back("etudiant_erreur");
  }
  const { data: created, error } = await admin
    .from("student_discount_requests")
    .insert({
      user_id: user.id,
      statut,
      annee_universitaire: anneeUniversitaire(new Date()),
      file_path: path,
      file_name: f.name.slice(0, 200),
    })
    .select("id")
    .single();
  if (error || !created) {
    console.error("Justificatif : demande", error);
    await admin.storage.from("justificatifs").remove([path]);
    back("etudiant_erreur");
  }
  await prevenirAdmins(admin, statut, created!.id as string);
  back("etudiant_envoye");
}

// Avertit les administrateurs d'un nouveau justificatif, sans bloquer le
// membre si l'envoi échoue (la tâche reste visible au tableau de bord).
async function prevenirAdmins(admin: ReturnType<typeof createAdminClient>, statut: string, id: string) {
  if (!emailEnabled()) return;
  try {
    const { data: admins } = await admin.from("profiles").select("id").eq("editorial_role", "admin");
    const emails: string[] = [];
    for (const a of admins ?? []) {
      const { data } = await admin.auth.admin.getUserById(a.id as string);
      if (data?.user?.email) emails.push(data.user.email);
    }
    if (!emails.length) return;
    const sent = await sendBatch(
      emails.map((to) => emailNouveauJustificatif(to, statut, siteUrl())),
      `justificatif-${id}`,
    );
    if (!sent.ok) console.error("Justificatif : alerte admin", sent.error);
  } catch (e) {
    console.error("Justificatif : alerte admin", e);
  }
}
