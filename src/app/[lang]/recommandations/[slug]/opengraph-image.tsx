import { formatDate } from "@/lib/fiches";
import { imagePartage, TAILLE_PARTAGE } from "@/lib/image-partage";
import { LOCALES, estOuverte } from "@/lib/langues";
import { ficheKey } from "@/lib/seo";
import { loadPublicFiches } from "../data";
import { RECOMMANDATIONS } from "../textes";

export const alt = RECOMMANDATIONS.fr.image.alt;
export const size = TAILLE_PARTAGE;
export const contentType = "image/png";

// Image de partage d'une fiche : sociétés, titre et date (métadonnées
// publiques seulement, jamais le contenu), légende dans la langue de la page.
export default async function Image({ params }: { params: Promise<{ slug: string; lang: string }> }) {
  const { slug, lang } = await params;
  const langue = estOuverte(lang) ? lang : "fr";
  const t = RECOMMANDATIONS[langue].image;
  const fiche = /^[a-z0-9-]{2,120}$/.test(slug) ? (await loadPublicFiches(ficheKey(slug)))[0] : undefined;
  if (!fiche) {
    return imagePartage({
      surtitre: t.surtitre,
      titre: t.titre,
      pied: "medical-guidelines.net",
    });
  }
  const date = formatDate(fiche.publication_date, LOCALES[langue]);
  return imagePartage({
    surtitre: fiche.card_json?.society ?? fiche.societies.slice(0, 4).join(" / "),
    titre: fiche.card_json?.title ?? fiche.title,
    pied: [t.pied, date].filter(Boolean).join(" · "),
  });
}
