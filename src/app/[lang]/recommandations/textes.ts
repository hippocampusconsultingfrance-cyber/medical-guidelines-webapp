import type { Pluriel } from "@/i18n/format";
import type { Traductions } from "@/i18n/serveur";

// Pages publiques des recommandations : catalogue, spécialité, fiche,
// en-tête, recherche et image de partage.
export const RECOMMANDATIONS: Traductions<{
  entete: { accueilAria: string; compte: string; bibliotheque: string; seConnecter: string; creerCompte: string };
  ouvrirBibliotheque: string;
  creerCompteOffert: string;
  accueil: string;
  recommandations: string;
  catalogue: {
    titreMeta: string;
    descriptionMeta: string;
    titreOg: string;
    descriptionOg: string;
    ogLocale: string;
    surtitre: string;
    titre: Pluriel;
    texte: string;
    specialites: string;
  };
  recherche: { libelle: string; placeholder: string; trouvees: Pluriel; aucune: string };
  specialite: {
    introuvable: string;
    titreMeta: string;
    descriptionMeta: string;
    retour: string;
    titre: string;
    texte: Pluriel;
    dontRecentes: Pluriel;
    texteFin: string;
  };
  fiche: {
    introuvable: string;
    retour: string;
    independante: string;
    remplaceeTitre: string;
    remplaceeTexte: string;
    remplaceeVoir: string;
    remplaceeHistorique: string;
    revisionTitre: string;
    revisionTexte: string;
    champ: string;
    resume: string;
    pointsCles: string;
    lireTitre: string;
    lireTexte: string;
    ouvrir: string;
    creerCompte: string;
    dejaCompte: string;
    sommaire: string;
    autresChapitres: Pluriel;
    societes: string;
    document: string;
    methodologie: string;
    validation: string;
    accesLibre: string;
    lienControle: string;
    autres: string;
    voirToutes: string;
    avertissement: string;
    demarche: string;
  };
  image: { alt: string; surtitre: string; titre: string; pied: string };
}> = {
  fr: {
    entete: {
      accueilAria: "medical-guidelines.net, accueil",
      compte: "Compte",
      bibliotheque: "Ma bibliothèque",
      seConnecter: "Se connecter",
      creerCompte: "Créer un compte",
    },
    ouvrirBibliotheque: "Ouvrir ma bibliothèque",
    creerCompteOffert: "Créer un compte gratuit : 5 fiches offertes",
    accueil: "Accueil",
    recommandations: "Recommandations",
    catalogue: {
      titreMeta: "Fiches de synthèse indépendantes des recommandations médicales | medical-guidelines.net",
      descriptionMeta:
        "Synthèses indépendantes des recommandations des sociétés savantes françaises (SFAR, SRLF, SFMU, HAS…), sourcées, grades conservés, avec le lien vers chaque texte officiel : anesthésie-réanimation, réanimation, urgences, pédiatrie et d'autres spécialités.",
      titreOg: "Fiches de synthèse indépendantes des recommandations médicales",
      descriptionOg:
        "Synthèses sourcées, grades conservés, avec le lien vers chaque texte officiel : anesthésie-réanimation, réanimation, urgences, pédiatrie et d'autres spécialités.",
      ogLocale: "fr_FR",
      surtitre: "Toutes spécialités",
      titre: { one: "{n} recommandation en fiche de synthèse", other: "{n} recommandations en fiches de synthèse" },
      texte:
        "Synthèses indépendantes des recommandations des sociétés savantes françaises, de la plus récente à la plus ancienne. Chaque fiche garde les grades de la source et renvoie au document officiel, en accès libre chez ses auteurs ; elle n'est ni éditée ni validée par les sociétés savantes.",
      specialites: "Spécialités",
    },
    recherche: {
      libelle: "Rechercher une recommandation",
      placeholder: "Rechercher : sepsis, ALR, SRLF, intubation…",
      trouvees: { one: "{n} fiche trouvée", other: "{n} fiches trouvées" },
      aucune: "Aucune fiche ne correspond à cette recherche.",
    },
    specialite: {
      introuvable: "Spécialité introuvable — medical-guidelines.net",
      titreMeta: "Recommandations en {libelle} : {fiches} de synthèse | medical-guidelines.net",
      descriptionMeta:
        "Les recommandations en {libelle} des sociétés savantes françaises ({societes}…) en fiches de synthèse indépendantes, sourcées, grades conservés, de la plus récente à la plus ancienne.",
      retour: "← Toutes les spécialités",
      titre: "Recommandations en {libelle}",
      texte: {
        one: "{n} recommandation des sociétés savantes françaises en fiche de synthèse indépendante",
        other: "{n} recommandations des sociétés savantes françaises en fiches de synthèse indépendantes",
      },
      dontRecentes: { one: ", dont {n} publiée depuis 2020", other: ", dont {n} publiées depuis 2020" },
      texteFin:
        ". Chaque fiche garde les grades de la source et renvoie au document officiel ; elle n'est ni éditée ni validée par les sociétés savantes.",
    },
    fiche: {
      introuvable: "Fiche introuvable — medical-guidelines.net",
      retour: "← Toutes les recommandations",
      independante: "Synthèse indépendante, ni éditée ni validée par les sociétés savantes citées.",
      remplaceeTitre: "Recommandation remplacée.",
      remplaceeTexte: "La société savante a publié un texte plus récent sur ce sujet.",
      remplaceeVoir: "Consultez plutôt la fiche",
      remplaceeHistorique: "Cette fiche reste disponible pour son intérêt historique.",
      revisionTitre: "Révision en cours.",
      revisionTexte:
        "Une nouvelle version de cette recommandation a été annoncée par la société savante ; la fiche sera actualisée dès sa publication.",
      champ: "Champ de la recommandation",
      resume: "Résumé",
      pointsCles: "Points clés",
      lireTitre: "Lire la fiche complète",
      lireTexte:
        "Recommandations détaillées par thème, avec leurs grades tels qu'ils figurent dans la source. Compte gratuit : {quota} fiches au choix, sans carte bancaire.",
      ouvrir: "Ouvrir la fiche dans ma bibliothèque",
      creerCompte: "Créer mon compte gratuit",
      dejaCompte: "J'ai déjà un compte",
      sommaire: "Sommaire de la fiche complète",
      autresChapitres: { one: "Et {n} autre chapitre.", other: "Et {n} autres chapitres." },
      societes: "Sociétés savantes",
      document: "Document",
      methodologie: "Méthodologie",
      validation: "Validation",
      accesLibre: "— en accès libre sur le site de la société savante",
      lienControle: " (lien contrôlé le {date})",
      autres: "Autres fiches — {rubrique}",
      voirToutes: "Voir toutes les recommandations",
      avertissement:
        "Synthèse indépendante : elle ne remplace ni le texte intégral de la recommandation officielle ni le jugement clinique, et n'est ni éditée ni validée par les sociétés savantes citées.",
      demarche: "Notre démarche",
    },
    image: {
      alt: "Fiche de synthèse — medical-guidelines.net",
      surtitre: "Fiche de synthèse",
      titre: "Les recommandations professionnelles, en fiches claires et sourcées",
      pied: "Fiche de synthèse, grades conservés",
    },
  },
  en: {
    entete: {
      accueilAria: "medical-guidelines.net, home",
      compte: "Account",
      bibliotheque: "My library",
      seConnecter: "Sign in",
      creerCompte: "Create an account",
    },
    ouvrirBibliotheque: "Open my library",
    creerCompteOffert: "Create a free account: 5 free summaries",
    accueil: "Home",
    recommandations: "Guidelines",
    catalogue: {
      titreMeta: "Independent summaries of clinical guidelines | medical-guidelines.net",
      descriptionMeta:
        "Independent summaries of guidelines from French medical societies (SFAR, SRLF, SFMU, HAS…), referenced, with the original grades and a link to each official text: anaesthesiology, intensive care, emergency medicine, paediatrics and other specialties.",
      titreOg: "Independent summaries of clinical guidelines",
      descriptionOg:
        "Referenced summaries with the original grades and a link to each official text: anaesthesiology, intensive care, emergency medicine, paediatrics and other specialties.",
      ogLocale: "en_GB",
      surtitre: "All specialties",
      titre: { one: "{n} guideline summarised", other: "{n} guidelines summarised" },
      texte:
        "Independent summaries of guidelines from French medical societies, from the most recent to the oldest. Each summary keeps the grades of the source and links to the official document, freely available from its authors; it is neither edited nor endorsed by the societies.",
      specialites: "Specialties",
    },
    recherche: {
      libelle: "Search for a guideline",
      placeholder: "Search: sepsis, regional anaesthesia, SRLF, intubation…",
      trouvees: { one: "{n} summary found", other: "{n} summaries found" },
      aucune: "No summary matches this search.",
    },
    specialite: {
      introuvable: "Specialty not found — medical-guidelines.net",
      titreMeta: "Guidelines in {libelle}: {fiches} | medical-guidelines.net",
      descriptionMeta:
        "Guidelines in {libelle} from French medical societies ({societes}…) as independent, referenced summaries with the original grades, from the most recent to the oldest.",
      retour: "← All specialties",
      titre: "Guidelines in {libelle}",
      texte: {
        one: "{n} guideline from French medical societies as an independent summary",
        other: "{n} guidelines from French medical societies as independent summaries",
      },
      dontRecentes: { one: ", {n} of them published since 2020", other: ", {n} of them published since 2020" },
      texteFin:
        ". Each summary keeps the grades of the source and links to the official document; it is neither edited nor endorsed by the societies.",
    },
    fiche: {
      introuvable: "Summary not found — medical-guidelines.net",
      retour: "← All guidelines",
      independante: "Independent summary, neither edited nor endorsed by the societies cited.",
      remplaceeTitre: "Superseded guideline.",
      remplaceeTexte: "The society has published a more recent text on this topic.",
      remplaceeVoir: "See the summary",
      remplaceeHistorique: "This summary remains available for historical interest.",
      revisionTitre: "Update in progress.",
      revisionTexte:
        "The society has announced a new version of this guideline; the summary will be updated as soon as it is published.",
      champ: "Scope of the guideline",
      resume: "Summary",
      pointsCles: "Key points",
      lireTitre: "Read the full summary",
      lireTexte:
        "Detailed recommendations by topic, with their grades as they appear in the source. Free account: {quota} summaries of your choice, no credit card needed.",
      ouvrir: "Open the summary in my library",
      creerCompte: "Create my free account",
      dejaCompte: "I already have an account",
      sommaire: "Contents of the full summary",
      autresChapitres: { one: "And {n} more chapter.", other: "And {n} more chapters." },
      societes: "Societies",
      document: "Document",
      methodologie: "Methodology",
      validation: "Endorsement",
      accesLibre: "— freely available on the society's website",
      lienControle: " (link checked on {date})",
      autres: "Other summaries — {rubrique}",
      voirToutes: "See all guidelines",
      avertissement:
        "Independent summary: it replaces neither the full text of the official guideline nor clinical judgement, and is neither edited nor endorsed by the societies cited.",
      demarche: "Our approach",
    },
    image: {
      alt: "Guideline summary — medical-guidelines.net",
      surtitre: "Guideline summary",
      titre: "Professional guidelines, in clear and referenced summaries",
      pied: "Guideline summary, original grades kept",
    },
  },
};
