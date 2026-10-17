import type { Traductions } from "@/i18n/serveur";

// Journal public des corrections.
export const CORRECTIONS: Traductions<{
  titreMeta: string;
  descriptionMeta: string;
  titre: string;
  intro: string;
  enFrancais: string;
  aucune: string;
  fiche: string;
}> = {
  fr: {
    titreMeta: "Journal des corrections — medical-guidelines.net",
    descriptionMeta: "Corrections apportées aux fiches de synthèse : date, fiche, criticité et résumé de la modification.",
    titre: "Journal des corrections",
    intro:
      "Chaque erreur confirmée dans une fiche est corrigée puis consignée ici : date, fiche, criticité et résumé de la modification. Une erreur repérée ? Signalez-la depuis la fiche concernée.",
    enFrancais: "",
    aucune: "Aucune correction publiée à ce jour.",
    fiche: "Fiche",
  },
  en: {
    titreMeta: "Corrections log — medical-guidelines.net",
    descriptionMeta: "Corrections made to the summaries: date, summary, severity and an outline of the change.",
    titre: "Corrections log",
    intro:
      "Every confirmed error in a summary is corrected and then recorded here: date, summary, severity and an outline of the change. Spotted an error? Report it from the summary concerned.",
    enFrancais: "Summary titles and correction notes are written in French.",
    aucune: "No corrections published to date.",
    fiche: "Summary",
  },
};
