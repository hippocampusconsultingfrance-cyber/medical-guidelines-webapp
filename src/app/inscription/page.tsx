import type { Metadata } from "next";
import { createClient } from "@/lib/supabase/server";
import InscriptionForm, { type Specialty } from "./formulaire";

export const metadata: Metadata = {
  title: "Créer un compte — medical-guidelines.net",
  description: "Compte gratuit pour les professionnels de santé : 5 fiches de synthèse au choix, sans carte bancaire.",
};

type SpecialtyRow = {
  slug: string;
  category: string;
  is_other: boolean;
  name_i18n: { fr?: string } | null;
};

// Spécialités proposées à l'inscription. L'anesthésie-réanimation est la
// spécialité pilote : toutes les fiches publiées y sont rattachées. Les
// autres spécialités seront ajoutées ici à leur ouverture.
const SPECIALITES_OUVERTES = ["anesthesie_reanimation"];

// Spécialités (table publique specialties) lues côté serveur, puis
// formulaire d'inscription (client).
export default async function InscriptionPage() {
  const supabase = await createClient();
  const { data } = await supabase
    .from("specialties")
    .select("slug, category, is_other, name_i18n")
    .in("slug", SPECIALITES_OUVERTES);
  const specialties: Specialty[] = ((data ?? []) as SpecialtyRow[]).map((s) => ({
    slug: s.slug,
    category: s.category,
    isOther: s.is_other,
    name: s.name_i18n?.fr ?? s.slug,
  }));
  specialties.sort((a, b) => Number(a.isOther) - Number(b.isOther) || a.name.localeCompare(b.name, "fr"));
  return <InscriptionForm specialties={specialties} />;
}
