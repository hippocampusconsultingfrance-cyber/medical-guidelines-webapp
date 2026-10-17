import type { Traductions } from "@/i18n/serveur";

// Assistant de recherche (bêta) : page, formulaire et messages rédigés par
// le site (codes renvoyés par @/lib/assistant).
export type TextesFormulaireAssistant = (typeof ASSISTANT)["fr"]["formulaire"];

const fr = {
  titreMeta: "Assistant de recherche — medical-guidelines.net",
  retour: "← Retour aux fiches",
  titre: "Assistant de recherche",
  beta: "(bêta)",
  iaTitre: "Réponses produites par une intelligence artificielle",
  ia: [
    "Elles peuvent contenir des erreurs ou des oublis.",
    "Elles ne remplacent pas votre jugement clinique.",
    "Vérifiez toujours le passage dans la fiche et la source officielle citée avant toute décision.",
  ],
  intro:
    "Posez une question en langage courant : l'assistant retrouve dans vos fiches les passages exacts qui y répondent, avec le lien vers la fiche et la source officielle. Il ne rédige pas de réponse et ne donne aucun avis sur un patient : la décision relève de votre jugement clinique.",
  enFrancais: "",
  details:
    "Outil d'aide à la recherche utilisant une intelligence artificielle ; chaque extrait est revérifié mot pour mot dans la fiche. Ne saisissez aucune donnée permettant d'identifier un patient : une question contenant une adresse e-mail, un numéro de téléphone ou de sécurité sociale, une date de naissance ou un identifiant patient est bloquée avant tout envoi. {quota} questions par 24 heures ; vos questions ne sont pas conservées.",
  phaseTest: "Phase de test : réservé à l'équipe éditoriale tant qu'ASSISTANT_PUBLIC n'est pas activé.",
  reservePremium: "L'assistant est réservé aux abonnés PREMIUM.",
  decouvrir: "Découvrir l'abonnement",
  bientot: "L'assistant de recherche sera bientôt disponible pour les abonnés PREMIUM.",
  formulaire: {
    question: "Votre question",
    placeholder: "Ex. : délai d'arrêt du rivaroxaban avant une chirurgie à haut risque hémorragique",
    enCours: "Recherche en cours…",
    rechercher: "Rechercher dans les fiches",
    vide: "Aucun passage des fiches ne répond précisément à cette question. Essayez d'autres mots, ou utilisez la recherche de la bibliothèque.",
    introduction: { one: "{n} extrait retrouvé dans {fiches} : {titres}.", other: "{n} extraits retrouvés dans {fiches} : {titres}." },
    laFiche: "la fiche",
    fiches: "{n} fiches",
    titre: "« {titre} »",
    sourceOfficielle: "source officielle ↗",
    identifiantes:
      "Votre question semble contenir une donnée permettant d'identifier une personne ({donnees}) : elle n'a pas été envoyée. Retirez cette donnée et posez la question de façon générale.",
    donnees: {
      email: "adresse e-mail",
      telephone: "numéro de téléphone",
      secu: "numéro de sécurité sociale",
      naissance: "date de naissance",
      identifiant: "identifiant patient",
    } as Record<string, string>,
    refus: {
      patient:
        "L'assistant ne donne pas d'avis sur un cas individuel : la décision relève de votre jugement clinique. Reformulez la question de façon générale, sans décrire un patient précis.",
      hors_champ: "Cette question sort du champ de l'assistant, qui retrouve seulement des passages des fiches de recommandations.",
      refus_ia: "Cette question ne peut pas être traitée par l'assistant.",
    } as Record<string, string>,
    erreurs: {
      courte: "Posez une question de quelques mots.",
      configuration: "L'assistant n'est pas encore configuré.",
      connexion: "Connectez-vous pour utiliser l'assistant.",
      premium: "L'assistant de recherche est réservé aux abonnés PREMIUM.",
      indisponible: "L'assistant est momentanément indisponible : réessayez dans un instant.",
      limite: "Limite de {quota} questions par 24 heures atteinte : réessayez demain.",
      sollicite: "L'assistant est très sollicité : réessayez dans une minute.",
      illisible: "Réponse illisible : reformulez votre question.",
    } as Record<string, string>,
  },
};

export const ASSISTANT: Traductions<typeof fr> = {
  fr,
  en: {
    titreMeta: "Research assistant — medical-guidelines.net",
    retour: "← Back to the summaries",
    titre: "Research assistant",
    beta: "(beta)",
    iaTitre: "Answers produced by artificial intelligence",
    ia: [
      "They may contain errors or omissions.",
      "They do not replace your clinical judgement.",
      "Always check the passage in the summary and the official source cited before any decision.",
    ],
    intro:
      "Ask a question in plain language: the assistant finds the exact passages in your summaries that answer it, with the link to the summary and the official source. It does not write an answer and gives no opinion about a patient: the decision is a matter for your clinical judgement.",
    enFrancais: "The summaries are in French: questions asked in French give the best results.",
    details:
      "A search aid using artificial intelligence; every extract is re-checked word for word in the summary. Do not enter any data that could identify a patient: a question containing an email address, a phone or social security number, a date of birth or a patient identifier is blocked before being sent. {quota} questions per 24 hours; your questions are not kept.",
    phaseTest: "Test phase: reserved for the editorial team until ASSISTANT_PUBLIC is turned on.",
    reservePremium: "The assistant is reserved for PREMIUM subscribers.",
    decouvrir: "Discover the subscription",
    bientot: "The research assistant will soon be available to PREMIUM subscribers.",
    formulaire: {
      question: "Your question",
      placeholder: "e.g. rivaroxaban stopping time before surgery with high bleeding risk",
      enCours: "Searching…",
      rechercher: "Search the summaries",
      vide: "No passage in the summaries precisely answers this question. Try other words, or use the library search.",
      introduction: { one: "{n} extract found in {fiches}: {titres}.", other: "{n} extracts found in {fiches}: {titres}." },
      laFiche: "the summary",
      fiches: "{n} summaries",
      titre: "“{titre}”",
      sourceOfficielle: "official source ↗",
      identifiantes:
        "Your question seems to contain data that could identify a person ({donnees}): it was not sent. Remove this data and ask the question in general terms.",
      donnees: {
        email: "email address",
        telephone: "phone number",
        secu: "social security number",
        naissance: "date of birth",
        identifiant: "patient identifier",
      },
      refus: {
        patient:
          "The assistant gives no opinion on an individual case: the decision is a matter for your clinical judgement. Rephrase the question in general terms, without describing a specific patient.",
        hors_champ: "This question is outside the assistant's scope, which only finds passages from the guideline summaries.",
        refus_ia: "This question cannot be handled by the assistant.",
      },
      erreurs: {
        courte: "Ask a question of a few words.",
        configuration: "The assistant is not configured yet.",
        connexion: "Sign in to use the assistant.",
        premium: "The research assistant is reserved for PREMIUM subscribers.",
        indisponible: "The assistant is temporarily unavailable: please try again in a moment.",
        limite: "Limit of {quota} questions per 24 hours reached: please try again tomorrow.",
        sollicite: "The assistant is very busy: please try again in a minute.",
        illisible: "Unreadable answer: rephrase your question.",
      },
    },
  },
};
