import { formatDate } from "@/lib/fiches";
import { imagePartage, TAILLE_PARTAGE } from "@/lib/image-partage";
import { ficheKey } from "@/lib/seo";
import { loadPublicFiches } from "../data";

export const alt = "Fiche de synthèse — medical-guidelines.net";
export const size = TAILLE_PARTAGE;
export const contentType = "image/png";

// Image de partage d'une fiche : sociétés, titre et date (métadonnées
// publiques seulement, jamais le contenu).
export default async function Image({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  const fiche = /^[a-z0-9-]{2,120}$/.test(slug) ? (await loadPublicFiches(ficheKey(slug)))[0] : undefined;
  if (!fiche) {
    return imagePartage({
      surtitre: "Fiche de synthèse",
      titre: "Les recommandations professionnelles, en fiches claires et sourcées",
      pied: "medical-guidelines.net",
    });
  }
  const date = formatDate(fiche.publication_date);
  return imagePartage({
    surtitre: fiche.card_json?.society ?? fiche.societies.slice(0, 4).join(" / "),
    titre: fiche.card_json?.title ?? fiche.title,
    pied: ["Fiche de synthèse, grades conservés", date].filter(Boolean).join(" · "),
  });
}
