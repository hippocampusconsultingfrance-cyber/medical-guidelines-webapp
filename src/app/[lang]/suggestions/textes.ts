import type { Traductions } from "@/i18n/serveur";

// Suggestions des membres (bouton « Une idée ? »).
export const SUGGESTIONS: Traductions<{
  titreMeta: string;
  messages: Record<string, string>;
  statuts: Record<string, string>;
  categories: Record<string, string>;
  retour: string;
  titre: string;
  intro: string;
  type: string;
  choisir: string;
  message: string;
  placeholder: string;
  page: string;
  patient: string;
  envoyer: string;
  derniers: string;
}> = {
  fr: {
    titreMeta: "Améliorer le site — medical-guidelines.net",
    messages: {
      merci: "Merci ! Votre message a bien été envoyé : il sera lu et traité.",
      vide: "Décrivez votre suggestion en quelques mots (5 caractères au moins).",
      invalide: "Choisissez le type de message.",
      limite: "Vous avez déjà envoyé 10 messages en 24 heures : merci de réessayer demain.",
      erreur: "L'envoi n'a pas abouti. Réessayez dans un instant.",
    },
    statuts: { nouveau: "Reçu", traite: "Traité", rejete: "Non retenu" },
    categories: {
      probleme: "Problème sur le site",
      amelioration: "Idée d'amélioration",
      contenu: "Contenu d'une fiche",
      autre: "Autre",
    },
    retour: "← Retour",
    titre: "Améliorer le site",
    intro:
      "Un problème, une idée, une remarque ? Chaque message est lu par l'équipe. Pour une erreur dans le contenu d'une fiche, vous pouvez aussi utiliser « Signaler une erreur » en bas de la fiche.",
    type: "Type de message",
    choisir: "Choisir…",
    message: "Votre message",
    placeholder: "Décrivez ce que vous avez constaté ou ce que vous proposez…",
    page: "Page concernée : {page}",
    patient: "N'indiquez aucune donnée concernant un patient.",
    envoyer: "Envoyer",
    derniers: "Vos derniers messages",
  },
  en: {
    titreMeta: "Improve the site — medical-guidelines.net",
    messages: {
      merci: "Thank you! Your message has been sent: it will be read and handled.",
      vide: "Describe your suggestion in a few words (at least 5 characters).",
      invalide: "Choose the type of message.",
      limite: "You have already sent 10 messages in 24 hours: please try again tomorrow.",
      erreur: "Sending failed. Please try again in a moment.",
    },
    statuts: { nouveau: "Received", traite: "Handled", rejete: "Not adopted" },
    categories: {
      probleme: "Problem on the site",
      amelioration: "Idea for improvement",
      contenu: "Content of a summary",
      autre: "Other",
    },
    retour: "← Back",
    titre: "Improve the site",
    intro:
      "A problem, an idea, a comment? The team reads every message. For an error in the content of a summary, you can also use “Report an error” at the bottom of the summary.",
    type: "Type of message",
    choisir: "Choose…",
    message: "Your message",
    placeholder: "Describe what you noticed or what you suggest…",
    page: "Page concerned: {page}",
    patient: "Do not include any data about a patient.",
    envoyer: "Send",
    derniers: "Your latest messages",
  },
};
