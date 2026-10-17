import { lang } from "next/root-params";
import { LANGUE_DEFAUT, LOCALES, chemin, estOuverte, type LangueOuverte } from "@/lib/langues";

// Textes de l'interface (spécification §10 : « textes de l'interface dans des
// fichiers de traduction ») : chaque page ou composant a son textes.ts, avec
// une version par langue ouverte ; TypeScript refuse une langue manquante ou
// une clé oubliée. Les textes contiennent des repères {n} (fmt) et des
// balises <lien>…</lien> (riche), jamais de code.
export type Traductions<T> = Record<LangueOuverte, T>;

// Langue de la page en cours (segment [lang], cf. src/lib/langues.ts).
export async function langue(): Promise<LangueOuverte> {
  const l = await lang();
  return estOuverte(l) ? l : LANGUE_DEFAUT;
}

// Textes d'une page dans sa langue, avec l'adresse des liens internes dans
// cette langue (lien("/cgu") = "/en/cgu" en anglais) et le format des dates.
export async function textes<T>(dico: Traductions<T>) {
  const l = await langue();
  return { t: dico[l], langue: l, lien: (p: string) => chemin(l, p), locale: LOCALES[l] };
}

// Langue d'un formulaire envoyé à une action serveur (champ caché
// « langue » ; root-params n'y est pas disponible) : adresse de retour dans
// la langue de la page.
export function langueDuFormulaire(formData: FormData): LangueOuverte {
  const l = formData.get("langue");
  return estOuverte(l) ? l : LANGUE_DEFAUT;
}
