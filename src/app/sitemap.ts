import type { MetadataRoute } from "next";
import { createClient } from "@supabase/supabase-js";
import { SITE_URL, ficheSlug, sectionSlug } from "@/lib/seo";

// Plan du site : accueil, catalogue public, une page par spécialité et une
// page par fiche en ligne.
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
    { url: SITE_URL, changeFrequency: "weekly", priority: 1 },
    { url: `${SITE_URL}/recommandations`, changeFrequency: "weekly", priority: 0.9 },
    ...[...new Set((data ?? []).map((d) => (d.card_json as { section?: string } | null)?.section).filter(Boolean))].map(
      (section) => ({
        url: `${SITE_URL}/recommandations/specialite/${sectionSlug(section as string)}`,
        changeFrequency: "weekly" as const,
        priority: 0.8,
      }),
    ),
    { url: `${SITE_URL}/corrections`, changeFrequency: "weekly", priority: 0.3 },
    { url: `${SITE_URL}/demarche`, changeFrequency: "yearly", priority: 0.4 },
    { url: `${SITE_URL}/partenaires`, changeFrequency: "yearly", priority: 0.4 },
    { url: `${SITE_URL}/relecteurs`, changeFrequency: "yearly", priority: 0.4 },
    ...(data ?? []).map((d) => ({
      url: `${SITE_URL}/recommandations/${ficheSlug(d.fiche_key as string)}`,
      lastModified: d.updated_at as string,
      changeFrequency: "monthly" as const,
      priority: 0.7,
    })),
  ];
}
