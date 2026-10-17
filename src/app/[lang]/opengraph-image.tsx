import { COMMUN } from "@/i18n/commun";
import { imagePartage, TAILLE_PARTAGE } from "@/lib/image-partage";
import { estOuverte } from "@/lib/langues";

export const alt = COMMUN.fr.image.alt;
export const size = TAILLE_PARTAGE;
export const contentType = "image/png";

// Image de partage du site (accueil et pages sans image propre), dans la
// langue de la page.
export default async function Image({ params }: { params: Promise<{ lang: string }> }) {
  const { lang } = await params;
  const t = COMMUN[estOuverte(lang) ? lang : "fr"].image;
  return imagePartage({ surtitre: t.surtitre, titre: t.titre, pied: t.pied });
}
