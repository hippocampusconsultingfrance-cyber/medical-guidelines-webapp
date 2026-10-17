import type { Traductions } from "./serveur";

// Textes communs à toutes les pages : métadonnées par défaut, pied de page,
// en-têtes, pages 404 et d'erreur.
export const COMMUN: Traductions<{
  meta: { description: string; ogLocale: string };
  pied: {
    societe: string;
    societeLien: string;
    medecin: string;
    medecinLien: string;
    mentions: string;
    cgu: string;
    cgv: string;
    confidentialite: string;
    corrections: string;
    langues: string;
  };
  entete: { accueilAria: string; accueil: string };
  introuvable: { titreMeta: string; surtitre: string; titre: string; texte: string; recommandations: string; accueil: string };
  erreur: { surtitre: string; titre: string; texte: string; reference: string; reessayer: string; accueil: string };
  deconnexion: string;
  image: { alt: string; surtitre: string; titre: string; pied: string };
}> = {
  fr: {
    meta: {
      description: "Fiches de synthèse des recommandations professionnelles, pour le personnel médical et paramédical.",
      ogLocale: "fr_FR",
    },
    pied: {
      societe:
        "<b>Société savante ?</b> Devenez notre partenaire : accès PREMIUM offert, statistiques anonymes de lecture et signalements d'erreurs sur vos fiches.",
      societeLien: "En savoir plus",
      medecin:
        "<b>Médecin ?</b> Participez à la correction des fiches : accès gratuit au site et 5 accès offerts aux personnes de votre choix.",
      medecinLien: "Devenir relecteur",
      mentions: "Mentions légales",
      cgu: "CGU",
      cgv: "CGV",
      confidentialite: "Confidentialité",
      corrections: "Journal des corrections",
      langues: "Langue du site",
    },
    entete: { accueilAria: "medical-guidelines.net, accueil", accueil: "← Accueil" },
    introuvable: {
      titreMeta: "Page introuvable — medical-guidelines.net",
      surtitre: "Erreur 404",
      titre: "Page introuvable",
      texte:
        "Cette adresse ne correspond à aucune page. La fiche a peut-être changé de nom : retrouvez-la dans la liste des recommandations.",
      recommandations: "Voir les recommandations",
      accueil: "Retour à l'accueil",
    },
    erreur: {
      surtitre: "Erreur",
      titre: "Un problème est survenu",
      texte:
        "La page n'a pas pu s'afficher. Réessayez dans un instant ; si le problème continue, écrivez-nous à <mail>contact@medical-guidelines.net</mail>",
      reference: " (référence {ref})",
      reessayer: "Réessayer",
      accueil: "Retour à l'accueil",
    },
    deconnexion: "Se déconnecter",
    image: {
      alt: "medical-guidelines.net — les recommandations professionnelles en fiches claires et sourcées",
      surtitre: "Médecins et paramédicaux",
      titre: "Les recommandations professionnelles, en fiches claires et sourcées",
      pied: "Grades conservés · Source officielle à portée de clic · 5 fiches gratuites",
    },
  },
  en: {
    meta: {
      description: "Summaries of professional clinical guidelines, for doctors, nurses and allied health professionals.",
      ogLocale: "en_GB",
    },
    pied: {
      societe:
        "<b>A medical society?</b> Become our partner: free PREMIUM access, anonymous readership statistics and error reports on your summaries.",
      societeLien: "Learn more",
      medecin:
        "<b>A doctor?</b> Help correct our summaries: free access to the site, plus 5 free accounts for people of your choice.",
      medecinLien: "Become a reviewer",
      mentions: "Legal notice",
      cgu: "Terms of use",
      cgv: "Terms of sale",
      confidentialite: "Privacy",
      corrections: "Corrections log",
      langues: "Site language",
    },
    entete: { accueilAria: "medical-guidelines.net, home", accueil: "← Home" },
    introuvable: {
      titreMeta: "Page not found — medical-guidelines.net",
      surtitre: "Error 404",
      titre: "Page not found",
      texte:
        "This address does not match any page. The summary may have been renamed: find it in the list of guidelines.",
      recommandations: "Browse the guidelines",
      accueil: "Back to home",
    },
    erreur: {
      surtitre: "Error",
      titre: "Something went wrong",
      texte:
        "The page could not be displayed. Please try again in a moment; if the problem persists, write to us at <mail>contact@medical-guidelines.net</mail>",
      reference: " (reference {ref})",
      reessayer: "Try again",
      accueil: "Back to home",
    },
    deconnexion: "Sign out",
    image: {
      alt: "medical-guidelines.net — professional guidelines in clear, referenced summaries",
      surtitre: "Doctors and allied health professionals",
      titre: "Professional guidelines, in clear and referenced summaries",
      pied: "Original grades kept · Official source one click away · 5 free summaries",
    },
  },
};
