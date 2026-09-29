// Référencement des pages publiques (cahier des charges V4.5, §10.5).
// INDEXABLE reste à false tant que le porteur de projet n'a pas décidé
// d'ouvrir le site aux moteurs de recherche : les pages publiques sont
// alors visibles des visiteurs mais marquées « noindex », et robots.txt
// interdit l'exploration.
export const INDEXABLE = false;

export const SITE_URL = "https://www.medical-guidelines.net";

// Adresse stable et lisible d'une fiche : identifiant de l'atelier.
export function ficheSlug(key: string) {
  return key.replace(/_/g, "-");
}
export function ficheKey(slug: string) {
  return slug.replace(/-/g, "_");
}
