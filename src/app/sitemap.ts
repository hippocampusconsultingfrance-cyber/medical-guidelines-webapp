import type { MetadataRoute } from "next";
import { createClient } from "@supabase/supabase-js";
import { LANGUES_OUVERTES } from "@/lib/langues";
import { SITE_URL, alternatives, ficheSlug, sectionSlug } from "@/lib/seo";

// Plan du site : accueil, catalogue public, une page par spécialité et une
// page par fiche en ligne. Pages entièrement traduites (accueil, démarche…) :
// aussi dans chaque autre langue ouverte, avec leurs équivalents (hreflang).
// Catalogue et fiches : en français seulement tant que le contenu des fiches
// n'est pas traduit (src/lib/seo.ts, LANGUES_CONTENU).
const PAGES_TRADUITES: { p: string; changeFrequency: "weekly" | "yearly"; priority: number }[] = [
  { p: "/", changeFrequency: "weekly", priority: 1 },
  { p: "/corrections", changeFrequency: "weekly", priority: 0.3 },
  { p: "/demarche", changeFrequency: "yearly", priority: 0.4 },
  { p: "/partenaires", changeFrequency: "yearly", priority: 0.4 },
  { p: "/relecteurs", changeFrequency: "yearly", priority: 0.4 },
];
export const revalidate = 3600;

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!,
    { auth: { persistSession: false } },
  );
  const { data } = await supabase
    .from("documents")
    .select("fiche_key, updated_at, card_json")
    .not("fiche_key", "is", null)
    .not("published_at", "is", null);
  return [
    ...PAGES_TRADUITES.flatMap(({ p, changeFrequency, priority }) =>
      LANGUES_OUVERTES.map((l) => {
        const { canonical, languages } = alternatives(l, p);
        return { url: canonical, changeFrequency, priority: l === "fr" ? priority : priority * 0.8, alternates: { languages } };
      }),
    ),
    { url: `${SITE_URL}/recommandations`, changeFrequency: "weekly", priority: 0.9 },
    ...[...new Set((data ?? []).map((d) => (d.card_json as { section?: string } | null)?.section).filter(Boolean))].map(
      (section) => ({
        url: `${SITE_URL}/recommandations/specialite/${sectionSlug(section as string)}`,
        changeFrequency: "weekly" as const,
        priority: 0.8,
      }),
    ),
    ...(data ?? []).map((d) => ({
      url: `${SITE_URL}/recommandations/${ficheSlug(d.fiche_key as string)}`,
      lastModified: d.updated_at as string,
      changeFrequency: "monthly" as const,
      priority: 0.7,
    })),
  ];
}
