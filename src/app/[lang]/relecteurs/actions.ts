"use server";

import { redirect as rediriger } from "next/navigation";
import { langueDuFormulaire } from "@/i18n/serveur";
import { chemin } from "@/lib/langues";
import { EMAIL, PROFESSIONS_MEDECIN, TELEPHONE } from "@/lib/relecteurs";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

const champ = (formData: FormData, nom: string, max: number) => String(formData.get(nom) ?? "").trim().slice(0, max);

// Candidature d'un médecin relecteur (formulaire public, sans compte). Les
// champs sont contrôlés ici, puis la candidature est enregistrée par le
// serveur : la table n'est ni lisible ni modifiable depuis le navigateur.
// La limite par adresse e-mail est imposée par la base.
export async function envoyerCandidature(formData: FormData) {
  // Retour à la page dans sa langue.
  const redirect: (p: string) => never = (p) => rediriger(chemin(langueDuFormulaire(formData), p));
  // Champ invisible pour un humain : rempli, c'est un robot.
  if (champ(formData, "site_web", 200)) redirect("/relecteurs?r=merci#candidature");

  const candidature = {
    nom: champ(formData, "nom", 100),
    prenom: champ(formData, "prenom", 100),
    telephone: champ(formData, "telephone", 30),
    email: champ(formData, "email", 254).toLowerCase(),
    profession: champ(formData, "profession", 120),
    specialite: champ(formData, "specialite", 120),
    message: champ(formData, "message", 2000) || null,
  };
  if (!candidature.nom || !candidature.prenom) redirect("/relecteurs?r=nom#candidature");
  if (!TELEPHONE.test(candidature.telephone)) redirect("/relecteurs?r=telephone#candidature");
  if (!EMAIL.test(candidature.email)) redirect("/relecteurs?r=email#candidature");
  if (!PROFESSIONS_MEDECIN.includes(candidature.profession)) redirect("/relecteurs?r=profession#candidature");
  if (formData.get("consentement") !== "oui") redirect("/relecteurs?r=consentement#candidature");

  // Spécialité choisie dans la liste publique des spécialités médicales.
  const supabase = await createClient();
  const { data: specialite } = await supabase
    .from("specialties")
    .select("slug, name_i18n")
    .eq("slug", candidature.specialite)
    .eq("category", "medicale")
    .maybeSingle();
  if (!specialite) redirect("/relecteurs?r=specialite#candidature");
  candidature.specialite = (specialite.name_i18n as { fr?: string } | null)?.fr ?? specialite.slug;

  const { error } = await createAdminClient().from("candidatures_relecteurs").insert(candidature);
  redirect(`/relecteurs?r=${error ? (error.code === "54000" ? "limite" : "erreur") : "merci"}#candidature`);
}
