// Langues du site (cahier des charges §7 et spécification §10). Le français,
// langue de publication, garde les adresses sans préfixe (/recommandations) ;
// les autres langues sont servies sous /en, /es, /de, /ar, /zh. Toutes les
// pages vivent sous src/app/[lang] : src/proxy.ts y envoie les adresses
// françaises (/x → /fr/x) et redirige /fr/x vers /x.

export const LANGUES = ["fr", "en", "es", "de", "ar", "zh"] as const;
export type Langue = (typeof LANGUES)[number];
export const LANGUE_DEFAUT = "fr" satisfies Langue;

// Langues proposées aux visiteurs : une langue n'est ouverte qu'une fois
// toute l'interface traduite (textes.ts de chaque page : TypeScript exige
// une version pour chaque langue ouverte). Une adresse d'une langue fermée
// affiche la page 404.
export const LANGUES_OUVERTES = ["fr", "en", "es", "de", "ar", "zh"] as const satisfies readonly Langue[];
export type LangueOuverte = (typeof LANGUES_OUVERTES)[number];

export const NOMS_LANGUES: Record<Langue, string> = {
  fr: "Français",
  en: "English",
  es: "Español",
  de: "Deutsch",
  ar: "العربية",
  zh: "中文",
};

// Formats de date et de nombre (Intl).
export const LOCALES: Record<Langue, string> = {
  fr: "fr-FR",
  en: "en-GB",
  es: "es-ES",
  de: "de-DE",
  ar: "ar",
  zh: "zh-CN",
};

// Cookie du choix de langue (sélecteur de langue) : une adresse française
// ouverte par un visiteur qui a choisi une autre langue l'y renvoie.
export const COOKIE_LANGUE = "langue";

export function estLangue(x: unknown): x is Langue {
  return typeof x === "string" && (LANGUES as readonly string[]).includes(x);
}

export function estOuverte(x: unknown): x is LangueOuverte {
  return typeof x === "string" && (LANGUES_OUVERTES as readonly string[]).includes(x);
}

export function direction(langue: Langue): "ltr" | "rtl" {
  return langue === "ar" ? "rtl" : "ltr";
}

// Attributs d'un texte resté en français (contenu des fiches) dans une page
// d'une autre langue : prononciation des lecteurs d'écran, et sens de lecture
// gauche-droite dans une page en arabe.
export function texteFrancais(langue: Langue) {
  return langue === LANGUE_DEFAUT ? {} : ({ lang: LANGUE_DEFAUT, dir: "ltr" } as const);
}

// Adresse d'une page dans une langue : chemin("en", "/cgu") = "/en/cgu",
// chemin("fr", "/cgu") = "/cgu", chemin("en", "/") = "/en".
export function chemin(langue: Langue, p: string): string {
  if (langue === LANGUE_DEFAUT || !p.startsWith("/") || p.startsWith("//")) return p;
  if (p === "/") return `/${langue}`;
  if (p.startsWith("/?") || p.startsWith("/#")) return `/${langue}${p.slice(1)}`;
  return `/${langue}${p}`;
}

// Langue en tête d'une adresse, et le reste : decouper("/en/cgu") =
// { langue: "en", reste: "/cgu" } ; decouper("/cgu") = { langue: null, reste: "/cgu" }.
export function decouper(pathname: string): { langue: Langue | null; reste: string } {
  const m = /^\/([a-z]{2})(?=\/|$)(.*)$/.exec(pathname);
  if (m && estLangue(m[1])) return { langue: m[1], reste: m[2] || "/" };
  return { langue: null, reste: pathname };
}
