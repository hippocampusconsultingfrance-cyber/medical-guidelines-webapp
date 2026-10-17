import type { MetadataRoute } from "next";
import { createClient } from "@supabase/supabase-js";
import { LANGUES_OUVERTES, chemin, type LangueOuverte } from "@/lib/langues";
import { SITE_URL, alternatives, ficheSlug, sectionSlug } from "@/lib/seo";

// Plan du site : accueil, catalogue public, une page par spécialité et une
// page par fiche en ligne. Pages entièrement traduites (accueil, démarche…) :
// aussi dans chaque autre langue ouverte, avec leurs équivalents (hreflang).
// Catalogue : en français seulement (src/lib/seo.ts, LANGUES_CONTENU) ;
// fiches : en français, et dans chaque langue où leur traduction est publiée.
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
  const [{ data }, { data: traduites }] = await Promise.all([
    supabase
      .from("documents")
      .select("id, fiche_key, updated_at, card_json")
      .not("fiche_key", "is", null)
      .not("published_at", "is", null),
    // Sans la migration 20261018110000 : aucune traduction, fiches en français.
    supabase.rpc("traductions_publiees"),
  ]);
  const languesDe = new Map<string, LangueOuverte[]>();
  for (const t of (traduites ?? []) as { document_id: string; lang: LangueOuverte }[]) {
    if (LANGUES_OUVERTES.includes(t.lang)) languesDe.set(t.document_id, [...(languesDe.get(t.document_id) ?? []), t.lang]);
  }
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
    ...(data ?? []).flatMap((d) => {
      const p = `/recommandations/${ficheSlug(d.fiche_key as string)}`;
      const langues: LangueOuverte[] = ["fr", ...(languesDe.get(d.id as string) ?? [])];
      const { languages } = alternatives("fr", p, langues);
      return langues.map((l) => ({
        url: `${SITE_URL}${chemin(l, p)}`,
        lastModified: d.updated_at as string,
        changeFrequency: "monthly" as const,
        priority: l === "fr" ? 0.7 : 0.5,
        ...(langues.length > 1 ? { alternates: { languages } } : {}),
      }));
    }),
  ];
}
