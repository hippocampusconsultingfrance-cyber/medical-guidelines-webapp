import { imagePartage, TAILLE_PARTAGE } from "@/lib/image-partage";

export const alt = "medical-guidelines.net — les recommandations professionnelles en fiches claires et sourcées";
export const size = TAILLE_PARTAGE;
export const contentType = "image/png";

// Image de partage du site (accueil et pages sans image propre).
export default function Image() {
  return imagePartage({
    surtitre: "Médecins et paramédicaux",
    titre: "Les recommandations professionnelles, en fiches claires et sourcées",
    pied: "Grades conservés · Source officielle à portée de clic · 5 fiches gratuites",
  });
}
