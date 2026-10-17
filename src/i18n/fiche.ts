import type { Pluriel } from "./format";
import type { Traductions } from "./serveur";

// Textes communs aux pages des fiches (page publique /recommandations/… et
// fiche de la bibliothèque) : états de la source, mentions, contenu encore
// en français dans les autres langues.
export const FICHE: Traductions<{
  remplacee: string;
  revision: string;
  ancienneTitre: string;
  ancienneTexte: string;
  sourceOfficielle: string;
  synthese: string;
  enFrancais: string;
  fiches: Pluriel;
}> = {
  fr: {
    remplacee: "Remplacée",
    revision: "Révision en cours",
    ancienneTitre: "Source ancienne.",
    ancienneTexte:
      "Recommandation publiée en {annee}, il y a plus de {max} ans : vérifiez auprès de la société savante qu'aucune actualisation n'a été publiée depuis.",
    sourceOfficielle: "Document source officiel ↗",
    synthese: "fiche de synthèse",
    enFrancais: "",
    fiches: { one: "{n} fiche", other: "{n} fiches" },
  },
  en: {
    remplacee: "Superseded",
    revision: "Update in progress",
    ancienneTitre: "Older source.",
    ancienneTexte:
      "Guideline published in {annee}, more than {max} years ago: check with the society that no update has been published since.",
    sourceOfficielle: "Official source document ↗",
    synthese: "summary",
    enFrancais:
      "This summary is currently available in French only (titles, summaries and recommendations): the English version is in preparation.",
    fiches: { one: "{n} summary", other: "{n} summaries" },
  },
};
