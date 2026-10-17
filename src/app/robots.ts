import type { MetadataRoute } from "next";
import { LANGUES_OUVERTES, chemin } from "@/lib/langues";
import { INDEXABLE, SITE_URL } from "@/lib/seo";

const PRIVEES = ["/bibliotheque", "/compte", "/abonnement", "/auth", "/finaliser-compte", "/nouveau-mot-de-passe"];

// Tant que INDEXABLE est faux, les moteurs n'explorent rien. Ensuite, seules
// les pages publiques sont ouvertes ; l'espace membre reste exclu.
export default function robots(): MetadataRoute.Robots {
  if (!INDEXABLE) return { rules: { userAgent: "*", disallow: "/" } };
  return {
    rules: {
      userAgent: "*",
      allow: ["/", "/recommandations"],
      // Espace membre, dans chaque langue (/en/bibliotheque…).
      disallow: ["/api", ...PRIVEES.flatMap((p) => LANGUES_OUVERTES.map((l) => chemin(l, p)))],
    },
    sitemap: `${SITE_URL}/sitemap.xml`,
  };
}
