import { LANGUES_OUVERTES, chemin, type LangueOuverte } from "@/lib/langues";

// Référencement des pages publiques (cahier des charges V4.5, §10.5).
// Ouvert aux moteurs de recherche sur décision du porteur de projet
// (29/09/2026). Seules l'accueil et les pages /recommandations sont
// indexables ; l'espace membre reste exclu (robots.ts) et les autres pages
// gardent le « noindex » de la mise en page.
export const INDEXABLE = true;

export const SITE_URL = "https://www.medical-guidelines.net";

// Langues dans lesquelles le contenu des fiches (titres, résumés) est
// publié : dans les autres, catalogue et fiches affichent l'interface
// traduite mais le contenu en français, et ne sont pas proposés aux moteurs.
export const LANGUES_CONTENU: readonly LangueOuverte[] = ["fr"];
export const contenuIndexable = (langue: LangueOuverte) => INDEXABLE && LANGUES_CONTENU.includes(langue);

// Adresse absolue d'une page dans sa langue (canonique) et dans chaque langue
// ouverte (balises hreflang ; « x-default » : le français).
export function alternatives(langue: LangueOuverte, p: string, langues: readonly LangueOuverte[] = LANGUES_OUVERTES) {
  const url = (l: LangueOuverte) => (p === "/" && l === "fr" ? SITE_URL : `${SITE_URL}${chemin(l, p)}`);
  return {
    canonical: url(langue),
    languages: { ...Object.fromEntries(langues.map((l) => [l, url(l)])), "x-default": url("fr") },
  };
}

// Adresse stable et lisible d'une fiche : identifiant de l'atelier.
export function ficheSlug(key: string) {
  return key.replace(/_/g, "-");
}
export function ficheKey(slug: string) {
  return slug.replace(/-/g, "_");
}

// Pages d'entrée par spécialité (/recommandations/specialite/…), une par
// rubrique du catalogue (card_json.section) ; libellés : src/i18n/rubriques.ts.
export function sectionSlug(section: string) {
  return section
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "");
}
