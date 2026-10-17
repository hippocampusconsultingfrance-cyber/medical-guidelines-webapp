import type { Traductions } from "@/i18n/serveur";

// Appel aux médecins relecteurs et formulaire de candidature.
export const RELECTEURS: Traductions<{
  titreMeta: string;
  descriptionMeta: string;
  messages: Record<string, string>;
  surtitre: string;
  titre: string;
  intro: string;
  offreTitre: string;
  offre: string[];
  offreTexte: string;
  formulaireTitre: string;
  nom: string;
  prenom: string;
  telephone: string;
  email: string;
  profession: string;
  choisirProfession: string;
  specialite: string;
  choisirSpecialite: string;
  listeIndisponible: string;
  message: string;
  siteWeb: string;
  consentement: string;
  envoyer: string;
}> = {
  fr: {
    titreMeta: "Médecins relecteurs — medical-guidelines.net",
    descriptionMeta:
      "Vous êtes médecin ? Participez à la correction des fiches, déjà relues deux fois par des outils d'intelligence artificielle : accès gratuit et illimité au site, plus 5 accès gratuits illimités pour les personnes de votre choix.",
    messages: {
      merci: "Merci ! Votre candidature a bien été envoyée : nous vous recontactons rapidement.",
      nom: "Indiquez votre nom et votre prénom.",
      telephone: "Le numéro de téléphone n'est pas valide.",
      email: "L'adresse e-mail n'est pas valide.",
      profession: "Choisissez votre profession dans la liste.",
      specialite: "Choisissez la spécialité dont vous souhaitez corriger les fiches.",
      consentement: "Cochez la case d'accord pour que nous puissions vous recontacter.",
      limite: "Vous avez déjà envoyé plusieurs candidatures aujourd'hui : nous les avons bien reçues.",
      erreur: "L'envoi n'a pas abouti. Réessayez dans un instant.",
    },
    surtitre: "Médecins relecteurs",
    titre: "Vous êtes médecin et vous souhaitez participer à la correction des fiches ?",
    intro:
      "Chaque fiche a déjà été relue deux fois par des outils d'intelligence artificielle, qui la comparent au texte de la recommandation source. Votre regard de praticien permet d'aller plus loin.",
    offreTitre: "Ce que nous vous offrons",
    offre: [
      "un <b>accès gratuit et illimité</b> au site ;",
      "ainsi que <b>5 accès gratuits illimités</b> pour les personnes que vous désignez.",
    ],
    offreTexte:
      "Laissez-nous vos coordonnées et la spécialité dont vous souhaitez corriger les fiches : nous vous recontactons pour convenir des modalités.",
    formulaireTitre: "Je souhaite participer",
    nom: "Nom",
    prenom: "Prénom",
    telephone: "Numéro de téléphone",
    email: "Adresse e-mail",
    profession: "Profession",
    choisirProfession: "Sélectionnez votre profession",
    specialite: "Spécialité dont vous souhaitez corriger les fiches",
    choisirSpecialite: "Sélectionnez une spécialité",
    listeIndisponible: "Liste indisponible : rechargez la page",
    message: "Message (facultatif)",
    siteWeb: "Site web",
    consentement:
      "J'accepte que ces informations soient utilisées pour me recontacter au sujet de cette proposition (voir la <confidentialite>politique de confidentialité</confidentialite>).",
    envoyer: "Envoyer ma candidature",
  },
  en: {
    titreMeta: "Physician reviewers — medical-guidelines.net",
    descriptionMeta:
      "Are you a doctor? Help correct the summaries, already checked twice by artificial intelligence tools: free unlimited access to the site, plus 5 free unlimited accounts for people of your choice.",
    messages: {
      merci: "Thank you! Your application has been sent: we will get back to you shortly.",
      nom: "Enter your last name and first name.",
      telephone: "The phone number is not valid.",
      email: "The email address is not valid.",
      profession: "Choose your profession from the list.",
      specialite: "Choose the specialty whose summaries you would like to correct.",
      consentement: "Tick the consent box so that we can contact you.",
      limite: "You have already sent several applications today: we have received them.",
      erreur: "Sending failed. Please try again in a moment.",
    },
    surtitre: "Physician reviewers",
    titre: "Are you a doctor who would like to help correct the summaries?",
    intro:
      "Every summary has already been checked twice by artificial intelligence tools, which compare it with the text of the source guideline. Your eye as a practitioner takes it further.",
    offreTitre: "What we offer you",
    offre: ["<b>free, unlimited access</b> to the site;", "plus <b>5 free unlimited accounts</b> for the people you choose."],
    offreTexte:
      "Leave us your contact details and the specialty whose summaries you would like to correct: we will contact you to agree on the arrangements.",
    formulaireTitre: "I would like to take part",
    nom: "Last name",
    prenom: "First name",
    telephone: "Phone number",
    email: "Email address",
    profession: "Profession",
    choisirProfession: "Select your profession",
    specialite: "Specialty whose summaries you would like to correct",
    choisirSpecialite: "Select a specialty",
    listeIndisponible: "List unavailable: reload the page",
    message: "Message (optional)",
    siteWeb: "Website",
    consentement:
      "I agree that this information may be used to contact me about this proposal (see the <confidentialite>privacy policy</confidentialite>).",
    envoyer: "Send my application",
  },
};
