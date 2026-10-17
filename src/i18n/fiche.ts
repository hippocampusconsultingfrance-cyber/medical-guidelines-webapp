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
  criticites: Record<string, string>;
  fraicheur: Record<string, string>;
  etats: { lock: string; open: string; draft: string };
  recommandation: string;
  catalogueOuvert: string;
  catalogueOuvertQuota: string;
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
    criticites: { mineure: "Mineure", majeure: "Majeure", critique: "Critique" },
    fraicheur: { revision_detectee: "Révision détectée", remplacee: "Remplacée", retiree: "Retirée" },
    etats: { lock: "🔒 Bloquée", open: "Débloquée", draft: "Brouillon" },
    recommandation: "Recommandation",
    catalogueOuvert:
      "Votre spécialité est encore peu couverte : le catalogue porte aujourd'hui surtout sur l'anesthésie-réanimation, la réanimation, la médecine d'urgence et la pédiatrie. Vos {quota} fiches gratuites sont donc au choix dans tout le catalogue. L'abonnement PREMIUM vous sera proposé quand votre spécialité sera couverte : nous vous écrirons à ce moment-là.",
    catalogueOuvertQuota:
      "Vous avez utilisé vos {quota} crédits. Votre spécialité est encore peu couverte : l'abonnement PREMIUM vous sera proposé quand elle le sera, et nous vous écrirons à ce moment-là.",
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
    criticites: { mineure: "Minor", majeure: "Major", critique: "Critical" },
    fraicheur: { revision_detectee: "Update detected", remplacee: "Superseded", retiree: "Withdrawn" },
    etats: { lock: "🔒 Locked", open: "Unlocked", draft: "Draft" },
    recommandation: "Guideline",
    catalogueOuvert:
      "Your specialty is not yet well covered: the catalogue currently focuses on anaesthesiology and critical care, intensive care, emergency medicine and paediatrics. Your {quota} free summaries can therefore be chosen from the whole catalogue. The PREMIUM subscription will be offered once your specialty is covered: we will write to you then.",
    catalogueOuvertQuota:
      "You have used your {quota} credits. Your specialty is not yet well covered: the PREMIUM subscription will be offered once it is, and we will write to you then.",
  },
};
