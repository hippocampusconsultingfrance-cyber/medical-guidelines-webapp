"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { journaliser } from "@/lib/journal";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

const UUID = /^[0-9a-f-]{36}$/i;
const ROLES = ["relecteur", "validateur", "admin"];
const VERIFICATIONS = ["non_demandee", "en_cours", "verifiee", "refusee"];
const LANGUES = ["fr", "en"];

// Administrateur connecté (double authentification comprise, via is_admin).
async function administrateur() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");
  return user;
}

function membreDe(formData: FormData) {
  const id = String(formData.get("id") ?? "");
  if (!UUID.test(id)) redirect("/bibliotheque/membres");
  return id;
}

const retour = (id: string, r: string): never => redirect(`/bibliotheque/membres/${id}?r=${r}`);
const texte = (formData: FormData, nom: string, max = 200) => String(formData.get(nom) ?? "").trim().slice(0, max);
const coche = (formData: FormData, nom: string) => formData.get(nom) === "on";

// Modification de la fiche d'un membre : identité, profession, spécialité,
// préférences, vérification professionnelle, rôle éditorial et e-mail de
// connexion. Les valeurs avant / après sont tracées au journal.
export async function modifierMembre(formData: FormData) {
  const moi = await administrateur();
  const id = membreDe(formData);
  const admin = createAdminClient();

  const { data: avant } = await admin.from("profiles").select("*").eq("id", id).single();
  if (!avant) retour(id, "introuvable");

  const nom = texte(formData, "nom");
  const prenom = texte(formData, "prenom");
  const profession = texte(formData, "profession");
  if (!nom || !prenom || !profession) retour(id, "champs_requis");

  const specialite = texte(formData, "specialty_id");
  if (specialite && !UUID.test(specialite)) retour(id, "erreur");
  const role = texte(formData, "editorial_role") || null;
  if (role && !ROLES.includes(role)) retour(id, "erreur");
  // Son propre rôle ne se change pas ici : un administrateur ne peut pas se
  // retirer l'accès par erreur.
  if (id === moi.id && role !== avant!.editorial_role) retour(id, "propre_role");
  const verification = texte(formData, "professional_verification_status");
  if (!VERIFICATIONS.includes(verification)) retour(id, "erreur");
  const langue = texte(formData, "langue_preferee");

  const apres = {
    nom,
    prenom,
    telephone: texte(formData, "telephone", 40),
    profession,
    profession_autre: profession === "Autre" ? texte(formData, "profession_autre") || null : null,
    specialty_id: specialite || null,
    pays_exercice: texte(formData, "pays_exercice", 80) || null,
    langue_preferee: LANGUES.includes(langue) ? langue : avant!.langue_preferee,
    setup_completed: coche(formData, "setup_completed"),
    email_alerts: coche(formData, "email_alerts"),
    consent_partners: coche(formData, "consent_partners"),
    specialty_visibility_public: coche(formData, "specialty_visibility_public"),
    professional_verification_status: verification,
    member_comite_consultatif: coche(formData, "member_comite_consultatif"),
    editorial_role: role,
  };
  const { error } = await admin.from("profiles").update(apres).eq("id", id);
  if (error) {
    console.error("Membre : modification", error);
    retour(id, "erreur");
  }

  // E-mail de connexion : changé directement (confirmé par l'administrateur).
  const email = texte(formData, "email", 254).toLowerCase();
  const { data: compte } = await admin.auth.admin.getUserById(id);
  const ancienEmail = compte?.user?.email ?? "";
  if (email && email !== ancienEmail) {
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) retour(id, "email_invalide");
    const { error: e } = await admin.auth.admin.updateUserById(id, { email, email_confirm: true });
    if (e) {
      console.error("Membre : e-mail", e);
      retour(id, "email_erreur");
    }
  }

  const modifies = Object.fromEntries(
    Object.entries(apres).filter(([k, v]) => (avant as Record<string, unknown>)[k] !== v),
  );
  if (email && email !== ancienEmail) modifies.email = email;
  await journaliser(moi.id, "membre_modifie", "profiles", id, modifies);
  revalidatePath("/[lang]/bibliotheque/membres", "page");
  retour(id, "enregistre");
}

// PREMIUM offert par l'administrateur, sans paiement : abonnement « actif »
// sans souscription Stripe, jusqu'à la date choisie (vide = sans fin). Un
// abonnement payé en cours n'est jamais remplacé : il se gère dans Stripe.
export async function activerPremium(formData: FormData) {
  const moi = await administrateur();
  const id = membreDe(formData);
  const admin = createAdminClient();

  const fin = texte(formData, "fin", 10);
  if (fin && (!/^\d{4}-\d{2}-\d{2}$/.test(fin) || new Date(`${fin}T23:59:59Z`).getTime() <= Date.now()))
    retour(id, "date_invalide");
  const finIso = fin ? new Date(`${fin}T23:59:59Z`).toISOString() : null;

  const { data: sub } = await admin
    .from("subscriptions")
    .select("status, stripe_subscription_id")
    .eq("user_id", id)
    .maybeSingle();
  if (sub?.stripe_subscription_id && (sub.status === "actif" || sub.status === "en_retard")) retour(id, "abonnement_stripe");

  // Le client Stripe éventuel (ancien abonnement) est conservé : factures.
  const ligne = {
    user_id: id,
    plan: "premium",
    status: "actif",
    stripe_subscription_id: null,
    current_period_end: finIso,
    canceled_at: null,
    updated_at: new Date().toISOString(),
  };
  const { error } = await admin.from("subscriptions").upsert(ligne, { onConflict: "user_id" });
  if (error) {
    console.error("Membre : PREMIUM offert", error);
    retour(id, "erreur");
  }
  await journaliser(moi.id, "premium_offert", "subscriptions", id, { fin: finIso });
  revalidatePath("/[lang]/bibliotheque/membres", "page");
  retour(id, "premium_active");
}

// Fin immédiate d'un PREMIUM offert. Un abonnement payé se résilie dans
// Stripe (remboursement, facture), jamais ici.
export async function desactiverPremium(formData: FormData) {
  const moi = await administrateur();
  const id = membreDe(formData);
  const admin = createAdminClient();

  const { data: sub } = await admin
    .from("subscriptions")
    .select("status, stripe_subscription_id")
    .eq("user_id", id)
    .maybeSingle();
  if (!sub || sub.status !== "actif") retour(id, "deja_inactif");
  if (sub!.stripe_subscription_id) retour(id, "abonnement_stripe");

  const maintenant = new Date().toISOString();
  const { error } = await admin
    .from("subscriptions")
    .update({ status: "annule", canceled_at: maintenant, current_period_end: maintenant, updated_at: maintenant })
    .eq("user_id", id);
  if (error) {
    console.error("Membre : fin du PREMIUM offert", error);
    retour(id, "erreur");
  }
  await journaliser(moi.id, "premium_retire", "subscriptions", id, {});
  revalidatePath("/[lang]/bibliotheque/membres", "page");
  retour(id, "premium_desactive");
}
