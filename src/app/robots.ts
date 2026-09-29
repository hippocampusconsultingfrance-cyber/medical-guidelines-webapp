import type { MetadataRoute } from "next";
import { INDEXABLE, SITE_URL } from "@/lib/seo";

// Tant que INDEXABLE est faux, les moteurs n'explorent rien. Ensuite, seules
// les pages publiques sont ouvertes ; l'espace membre reste exclu.
export default function robots(): MetadataRoute.Robots {
  if (!INDEXABLE) return { rules: { userAgent: "*", disallow: "/" } };
  return {
    rules: {
      userAgent: "*",
      allow: ["/", "/recommandations"],
      disallow: ["/bibliotheque", "/compte", "/abonnement", "/api", "/auth", "/finaliser-compte", "/nouveau-mot-de-passe"],
    },
    sitemap: `${SITE_URL}/sitemap.xml`,
  };
}
