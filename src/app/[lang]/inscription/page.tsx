import type { Metadata } from "next";
import { textes } from "@/i18n/serveur";
import { nomGroupeProfessions, nomProfession, nomSpecialite } from "@/i18n/specialites";
import { PROFESSION_GROUPS } from "@/lib/professions";
import { createClient } from "@/lib/supabase/server";
import { AUTH } from "../textes-auth";
import InscriptionForm, { type GroupeProfessions, type Specialty } from "./formulaire";

export async function generateMetadata(): Promise<Metadata> {
  const { t } = await textes(AUTH);
  return { title: t.inscription.titreMeta, description: t.inscription.descriptionMeta };
}

type SpecialtyRow = {
  slug: string;
  category: string;
  is_other: boolean;
  name_i18n: { fr?: string } | null;
};

// Spécialités (table publique specialties) lues côté serveur, puis
// formulaire d'inscription (client), dans la langue de la page.
export default async function InscriptionPage() {
  const { t, langue, locale } = await textes(AUTH);
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
    name: nomSpecialite(s.slug, s.name_i18n?.fr ?? s.slug, langue),
    // Liste indisponible : aucune mention, plutôt qu'une mention fausse.
    couverte: couvertes ? couverte.has(s.slug) : true,
  }));
  specialties.sort((a, b) => Number(a.isOther) - Number(b.isOther) || a.name.localeCompare(b.name, locale));
  // Professions : libellé dans la langue de la page, valeur enregistrée en français.
  const professions: GroupeProfessions[] = PROFESSION_GROUPS.map((g) => ({
    label: nomGroupeProfessions(g.label, langue),
    options: g.options.map((o) => ({ value: o, label: nomProfession(o, langue) })),
  }));
  return <InscriptionForm specialties={specialties} professions={professions} t={t.inscription} langue={langue} />;
}
