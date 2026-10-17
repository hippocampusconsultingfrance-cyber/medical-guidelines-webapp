"use client";

import { useParams } from "next/navigation";
import { LANGUE_DEFAUT, chemin, estOuverte, type LangueOuverte } from "@/lib/langues";

// Langue de la page dans un composant client (segment [lang]). Les textes
// eux-mêmes viennent du composant serveur parent (props), pour ne pas
// envoyer toutes les langues au navigateur.
export function useLangue(): LangueOuverte {
  const params = useParams<{ lang?: string }>();
  return estOuverte(params?.lang) ? params.lang : LANGUE_DEFAUT;
}

// Adresse d'un lien interne dans la langue de la page.
export function useLien() {
  const l = useLangue();
  return (p: string) => chemin(l, p);
}
