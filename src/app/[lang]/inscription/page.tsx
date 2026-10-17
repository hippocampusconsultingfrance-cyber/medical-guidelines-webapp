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

// Spécialités (table publique specialties) lues côté serveur, puis
// formulaire d'inscription (client).
export default async function InscriptionPage() {
  const supabase = await createClient();
  const [{ data }, { data: couvertes }] = await Promise.all([
    supabase.from("specialties").select("slug, category, is_other, name_i18n"),
    // Spécialités assez couvertes par le catalogue ; les autres : fiches
    // gratuites au choix dans tout le catalogue (@/lib/catalogue).
    supabase.rpc("specialites_couvertes"),
  ]);
  const couverte = new Set((couvertes ?? []) as string[]);
  const specialties: Specialty[] = ((data ?? []) as SpecialtyRow[]).map((s) => ({
    slug: s.slug,
    category: s.category,
    isOther: s.is_other,
    name: s.name_i18n?.fr ?? s.slug,
    // Liste indisponible : aucune mention, plutôt qu'une mention fausse.
    couverte: couvertes ? couverte.has(s.slug) : true,
  }));
  specialties.sort((a, b) => Number(a.isOther) - Number(b.isOther) || a.name.localeCompare(b.name, "fr"));
  return <InscriptionForm specialties={specialties} />;
}
