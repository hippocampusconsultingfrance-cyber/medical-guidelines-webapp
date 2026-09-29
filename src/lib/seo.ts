// Référencement des pages publiques (cahier des charges V4.5, §10.5).
// Ouvert aux moteurs de recherche sur décision du porteur de projet
// (29/09/2026). Seules l'accueil et les pages /recommandations sont
// indexables ; l'espace membre reste exclu (robots.ts) et les autres pages
// gardent le « noindex » de la mise en page.
export const INDEXABLE = true;

export const SITE_URL = "https://www.medical-guidelines.net";

// Adresse stable et lisible d'une fiche : identifiant de l'atelier.
export function ficheSlug(key: string) {
  return key.replace(/_/g, "-");
}
export function ficheKey(slug: string) {
  return slug.replace(/-/g, "_");
}
