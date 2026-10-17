import type { Pluriel } from "@/i18n/format";
import type { Traductions } from "@/i18n/serveur";

// Espace membre (accueil d'un compte connecté, espace-membre.tsx).
export const ESPACE: Traductions<{
  titreMeta: string;
  messages: Record<string, string>;
  navCompte: string;
  bibliotheque: string;
  monCompte: string;
  bienvenue: string;
  specialiteConsultee: string;
  rechercheLibelle: string;
  recherchePlaceholder: string;
  rechercher: string;
  statFiches: Pluriel;
  statNouveautes: Pluriel;
  statSocietes: Pluriel;
  relecteur: string;
  nouveautes: string;
  dernieres: string;
  nouveautesTexte: string;
  dernieresTexte: string;
  toute: string;
  filtrer: string;
  toutes: string;
  autresSocietes: Pluriel;
  moinsSocietes: string;
  aucuneFiche: string;
  voirNouveautes: string;
  populaires: string;
  populairesPremium: string;
  populairesCredits: string;
  favoris: string;
  ficheBloquee: string;
  favorisVide: string;
  tousFavoris: string;
  reprendre: string;
  reprendreVide: string;
  societesTitre: string;
  societesTexte: string;
  societeSuivie: string;
  suivie: string;
  autresDansBibliotheque: Pluriel;
  alertesTitre: string;
  alertesTexte: string;
  alertesDesactivees: string;
  suiviesAria: string;
  nePlusSuivre: string;
  nePlusSuivreCourt: string;
  societeASuivre: string;
  suivreUne: string;
  suivre: string;
  alertesPremium: string;
  majTitre: string;
  majTexte: string;
  majRetiree: string;
  majRemplacee: string;
  majRevision: string;
  majVersion: string;
  majModification: string;
  majPubliee: string;
  majDefaut: string;
  nouvelleFiche: string;
  premiumTitre: string;
  premiumTexte: string;
  premiumJusquau: string;
  premiumRenouvellement: string;
  gerer: string;
  assistantTitre: string;
  assistantTexte: string;
  assistantLien: string;
  creditsTitre: string;
  creditsRestants: Pluriel;
  creditsSur: string;
  debloquees: string;
  passerPremium: string;
  aujourdhui: string;
  hier: string;
  ilYa: string;
}> = {
  fr: {
    titreMeta: "medical-guidelines.net — Recommandations médicales et paramédicales en fiches",
    messages: {
      suivi: "Société suivie : vous recevrez un e-mail à chaque nouvelle recommandation qu'elle publie dans votre spécialité.",
      suivi_retire: "Vous ne suivez plus cette société.",
      suivi_erreur: "Le suivi n'a pas pu être enregistré. Réessayez dans un instant.",
    },
    navCompte: "Compte",
    bibliotheque: "Bibliothèque",
    monCompte: "Mon compte",
    bienvenue: "Bienvenue",
    specialiteConsultee: "spécialité consultée : {specialite}",
    rechercheLibelle: "Rechercher une fiche",
    recherchePlaceholder: "Rechercher une recommandation (sepsis, AOD, intubation…)",
    rechercher: "Rechercher",
    statFiches: { one: "fiche disponible", other: "fiches disponibles" },
    statNouveautes: { one: "nouveauté {annee}", other: "nouveautés {annee}" },
    statSocietes: { one: "société savante", other: "sociétés savantes" },
    relecteur: "Compte relecteur : la bibliothèque et cette page affichent aussi les brouillons, avec le bouton de publication.",
    nouveautes: "Nouveautés {annee}",
    dernieres: "Dernières recommandations",
    nouveautesTexte: "Recommandations publiées en {annee} par les sociétés savantes de votre spécialité.",
    dernieresTexte: "Aucune recommandation publiée en {annee} pour votre spécialité à ce jour : voici les plus récentes.",
    toute: "Toute la bibliothèque →",
    filtrer: "Filtrer les nouveautés {annee} par société savante",
    toutes: "Toutes",
    autresSocietes: { one: "+ {n} autre société", other: "+ {n} autres sociétés" },
    moinsSocietes: "Moins de sociétés",
    aucuneFiche:
      "Aucune fiche n'est encore publiée pour votre spécialité. Elles apparaîtront ici au fil de leur validation par notre équipe médicale.",
    voirNouveautes: "Voir les {n} nouveautés {annee}{societe} dans la bibliothèque →",
    populaires: "Les plus consultées de votre spécialité",
    populairesPremium: "Les fiches les plus lues par les membres ces trois derniers mois.",
    populairesCredits:
      "Les fiches les plus lues par les membres ces trois derniers mois : de quoi vous aider à choisir celles à débloquer avec vos crédits.",
    favoris: "★ Mes favoris",
    ficheBloquee: "Fiche bloquée",
    favorisVide:
      "Ajoutez une fiche à vos favoris avec le bouton « ☆ Ajouter aux favoris » de sa page : elle apparaîtra ici et dans la bibliothèque.",
    tousFavoris: "Tous mes favoris dans la bibliothèque →",
    reprendre: "Reprendre la lecture",
    reprendreVide: "Les fiches que vous ouvrez apparaîtront ici, pour y revenir en un clic.",
    societesTitre: "Sociétés savantes de votre spécialité",
    societesTexte: "Nombre de fiches co-signées, dans la bibliothèque.",
    societeSuivie: " 🔔 : société suivie.",
    suivie: "suivie",
    autresDansBibliotheque: { one: "Et {n} autre dans la bibliothèque →", other: "Et {n} autres dans la bibliothèque →" },
    alertesTitre: "Alertes e-mail",
    alertesTexte:
      "Un e-mail par jour au plus, quand une société suivie publie une recommandation dans votre spécialité ou qu'une de vos fiches est mise à jour.",
    alertesDesactivees: "Vos alertes e-mail sont désactivées : <compte>les réactiver dans Mon compte</compte>.",
    suiviesAria: "Sociétés suivies",
    nePlusSuivre: "Ne plus suivre {societe}",
    nePlusSuivreCourt: "ne plus suivre",
    societeASuivre: "Société à suivre",
    suivreUne: "Suivre une société…",
    suivre: "Suivre",
    alertesPremium:
      "Suivez les sociétés de votre choix et recevez un e-mail à chaque nouvelle recommandation, ainsi qu'à chaque mise à jour de vos fiches : inclus dans <abonnement>l'abonnement PREMIUM</abonnement>.",
    majTitre: "Vos fiches ont été mises à jour",
    majTexte: "Fiches que vous avez débloquées, mises en favori ou consultées.",
    majRetiree: "Recommandation retirée par la société savante : la fiche n'est plus consultable.",
    majRemplacee: "Recommandation remplacée par un texte plus récent.",
    majRevision: "Nouvelle version de la source détectée : fiche en cours de révision.",
    majVersion: "Version {version}",
    majModification: "modification {type}",
    majPubliee: "publiée le {date}",
    majDefaut: "Mise à jour",
    nouvelleFiche: "Nouvelle fiche : {titre} →",
    premiumTitre: "Abonnement PREMIUM actif",
    premiumTexte: "Toutes les fiches de votre spécialité sont ouvertes",
    premiumJusquau: ", jusqu'au {date}.",
    premiumRenouvellement: " ; renouvellement le {date}.",
    gerer: "Gérer mon abonnement →",
    assistantTitre: "Assistant de recherche (bêta)",
    assistantTexte:
      "Posez une question en langage courant : l'assistant retrouve les passages exacts des fiches qui y répondent, sans conseil médical.",
    assistantLien: "Poser une question →",
    creditsTitre: "Mes crédits",
    creditsRestants: { one: "{n} crédit restant", other: "{n} crédits restants" },
    creditsSur: "sur {quota}. Un crédit débloque une fiche, définitivement.",
    debloquees: "Mes fiches débloquées",
    passerPremium: "Passer à PREMIUM · 50 € / an",
    aujourdhui: "aujourd'hui",
    hier: "hier",
    ilYa: "il y a {n} j",
  },
  en: {
    titreMeta: "medical-guidelines.net — Medical and allied health guidelines, summarised",
    messages: {
      suivi: "Society followed: you will receive an email for every new guideline it publishes in your specialty.",
      suivi_retire: "You no longer follow this society.",
      suivi_erreur: "Following could not be saved. Please try again in a moment.",
    },
    navCompte: "Account",
    bibliotheque: "Library",
    monCompte: "My account",
    bienvenue: "Welcome",
    specialiteConsultee: "specialty: {specialite}",
    rechercheLibelle: "Search for a summary",
    recherchePlaceholder: "Search for a guideline (sepsis, DOAC, intubation…)",
    rechercher: "Search",
    statFiches: { one: "summary available", other: "summaries available" },
    statNouveautes: { one: "new in {annee}", other: "new in {annee}" },
    statSocietes: { one: "medical society", other: "medical societies" },
    relecteur: "Reviewer account: the library and this page also show drafts, with the publish button.",
    nouveautes: "New in {annee}",
    dernieres: "Latest guidelines",
    nouveautesTexte: "Guidelines published in {annee} by the medical societies of your specialty.",
    dernieresTexte: "No guideline published in {annee} for your specialty so far: here are the most recent ones.",
    toute: "Whole library →",
    filtrer: "Filter {annee} new guidelines by society",
    toutes: "All",
    autresSocietes: { one: "+ {n} more society", other: "+ {n} more societies" },
    moinsSocietes: "Fewer societies",
    aucuneFiche:
      "No summary has been published for your specialty yet. They will appear here as our medical team validates them.",
    voirNouveautes: "See the {n} {annee} new guidelines{societe} in the library →",
    populaires: "Most read in your specialty",
    populairesPremium: "The summaries most read by members over the last three months.",
    populairesCredits:
      "The summaries most read by members over the last three months: to help you choose which ones to unlock with your credits.",
    favoris: "★ My favourites",
    ficheBloquee: "Locked summary",
    favorisVide:
      "Add a summary to your favourites with the “☆ Add to favourites” button on its page: it will appear here and in the library.",
    tousFavoris: "All my favourites in the library →",
    reprendre: "Continue reading",
    reprendreVide: "The summaries you open will appear here, so you can return to them in one click.",
    societesTitre: "Medical societies in your specialty",
    societesTexte: "Number of co-signed summaries in the library.",
    societeSuivie: " 🔔: society followed.",
    suivie: "followed",
    autresDansBibliotheque: { one: "And {n} more in the library →", other: "And {n} more in the library →" },
    alertesTitre: "Email alerts",
    alertesTexte:
      "At most one email per day, when a society you follow publishes a guideline in your specialty or one of your summaries is updated.",
    alertesDesactivees: "Your email alerts are turned off: <compte>turn them back on in My account</compte>.",
    suiviesAria: "Societies followed",
    nePlusSuivre: "Stop following {societe}",
    nePlusSuivreCourt: "stop following",
    societeASuivre: "Society to follow",
    suivreUne: "Follow a society…",
    suivre: "Follow",
    alertesPremium:
      "Follow the societies of your choice and receive an email for every new guideline, and for every update to your summaries: included in <abonnement>the PREMIUM subscription</abonnement>.",
    majTitre: "Your summaries have been updated",
    majTexte: "Summaries you have unlocked, added to favourites or read.",
    majRetiree: "Guideline withdrawn by the society: the summary can no longer be read.",
    majRemplacee: "Guideline superseded by a more recent text.",
    majRevision: "New version of the source detected: summary being revised.",
    majVersion: "Version {version}",
    majModification: "{type} change",
    majPubliee: "published on {date}",
    majDefaut: "Update",
    nouvelleFiche: "New summary: {titre} →",
    premiumTitre: "PREMIUM subscription active",
    premiumTexte: "Every summary in your specialty is unlocked",
    premiumJusquau: ", until {date}.",
    premiumRenouvellement: "; renews on {date}.",
    gerer: "Manage my subscription →",
    assistantTitre: "Research assistant (beta)",
    assistantTexte:
      "Ask a question in plain language: the assistant finds the exact passages of the summaries that answer it, without medical advice.",
    assistantLien: "Ask a question →",
    creditsTitre: "My credits",
    creditsRestants: { one: "{n} credit left", other: "{n} credits left" },
    creditsSur: "out of {quota}. One credit unlocks one summary, for good.",
    debloquees: "My unlocked summaries",
    passerPremium: "Go PREMIUM · €50 / year",
    aujourdhui: "today",
    hier: "yesterday",
    ilYa: "{n} d ago",
  },
};
