import "server-only";
import type { Pluriel } from "@/i18n/format";
import type { Traductions } from "@/i18n/serveur";
import { LANGUE_DEFAUT, estOuverte, type LangueOuverte } from "@/lib/langues";

// Textes des e-mails envoyés aux membres, dans leur langue
// (profiles.langue_preferee ; à défaut le français). Les e-mails à l'équipe
// restent en français. Repères {x} (fmt) ; « <b> » et « <a> » ajoutés par
// le code, jamais dans les textes.
export function langueMembre(valeur: unknown): LangueOuverte {
  return estOuverte(valeur) ? valeur : LANGUE_DEFAUT;
}

export const EMAILS: Traductions<{
  // Deux-points des textes bruts (« Fiche : https://… »).
  dp: string;
  bonjour: string;
  bonjourPrenom: string;
  avertissement: string;
  stop: string;
  bienvenue: {
    sujet: string;
    catalogueOuvert: string;
    fiches: Pluriel;
    enSpecialite: string;
    arrivent: string;
    arriventSpecialite: string;
    premiumCatalogue: string;
    premiumOuvert: string;
    premiumBientot: string;
    pret: string;
    creditsTitre: string;
    creditsTexte: string;
    ouvrirBibliotheque: string;
    astuce: string;
    toutOuvrir: string;
    decouvrirPremium: string;
    question: string;
    raison: string;
    monCompte: string;
  };
  alertes: {
    nouvelles: string;
    misesAJour: string;
    lire: string;
    source: string;
    sourceTexte: string;
    fiche: string;
    raison: string;
    gerer: string;
    desinscrire: string;
    nouvelleVersion: string;
    version: string;
    sujetMixte: string;
    sujetUneNouvelle: string;
    sujetNouvelles: string;
    sujetUneMaj: string;
    sujetMajs: string;
  };
  relances: {
    finaliserSujet: string;
    finaliser1: string;
    finaliser2: string;
    finaliserBouton: string;
    finaliserValidite: string;
    finaliserValiditeTexte: string;
    quotaSujetOuvert: string;
    quotaSujet: string;
    quota1: string;
    quotaOuvert: string;
    quotaBientot: string;
    decouvrirPremium: string;
    premiereSujet: string;
    premiere1: string;
    premiereSpecialite: string;
    premiereCatalogue: string;
    voirToutes: string;
  };
  commande: {
    pied: string;
    cgv: string;
    question: string;
    gerer: string;
    gererResilier: string;
    confirmationSujet: string;
    merci: string;
    montant: string;
    jusquau: string;
    renouvellement: string;
    retractationRenonciation: string;
    retractation: string;
    cgvVersion: string;
    avisSujet: string;
    echeance: string;
    renouvele: string;
    resilier: string;
    ttc: string;
  };
  etudiant: {
    sujetValide: string;
    sujet: string;
    valideRenouvellement: string;
    valide: string;
    activer: string;
    activerTexte: string;
    refuse: string;
    motif: string;
    nouveau: string;
    nouveauTexte: string;
    supprime: string;
    monAbonnement: string;
  };
}> = {
  fr: {
    dp: " : ",
    bonjour: "Bonjour,",
    bonjourPrenom: "Bonjour {prenom},",
    avertissement:
      "Synthèses indépendantes, non officielles : elles ne remplacent pas le texte intégral des recommandations ni le jugement clinique.",
    stop: "Ne plus recevoir ces e-mails",
    bienvenue: {
      sujet: "Bienvenue sur medical-guidelines.net",
      catalogueOuvert:
        "Votre spécialité est encore peu couverte : vos {quota} fiches gratuites sont au choix dans tout le catalogue (anesthésie-réanimation, réanimation, médecine d'urgence, pédiatrie…)",
      fiches: { one: "{n} fiche de synthèse{specialite} vous attend", other: "{n} fiches de synthèse{specialite} vous attendent" },
      enSpecialite: " en {specialite}",
      arrivent: "Les fiches arrivent au fil de leur validation",
      arriventSpecialite: "Les fiches de {specialite} arrivent au fil de leur validation",
      premiumCatalogue:
        "L'abonnement PREMIUM, qui ouvre toutes les fiches d'une spécialité, vous sera proposé quand la vôtre sera couverte : nous vous écrirons à ce moment-là.",
      premiumOuvert:
        "Pour tout ouvrir, l'abonnement PREMIUM donne accès à toutes les fiches de votre spécialité et aux alertes de mise à jour, pour 50 € TTC par an (−30 % la première année avec le code FONDATEURS, pour les 100 premiers abonnés).",
      premiumBientot:
        "L'abonnement PREMIUM, qui ouvrira toutes les fiches de votre spécialité et les alertes de mise à jour, sera bientôt disponible : nous vous préviendrons.",
      pret: "Votre compte est prêt. {catalogue} : des synthèses fidèles des recommandations des sociétés savantes, grades conservés et source officielle toujours indiquée.",
      creditsTitre: "Vos {quota} crédits gratuits",
      creditsTexte:
        "Toutes les fiches sont visibles dans la bibliothèque. Choisissez-en une et cliquez sur « Débloquer » : un crédit ouvre la fiche définitivement. Vous disposez de {quota} crédits, sans limite de durée.",
      ouvrirBibliotheque: "Ouvrir la bibliothèque",
      astuce:
        "Astuce : la recherche trouve aussi les mots à l'intérieur des fiches (un médicament, une situation clinique), et l'étoile ☆ garde vos fiches favorites à portée de main.",
      toutOuvrir: "Tout ouvrir",
      decouvrirPremium: "Découvrir PREMIUM",
      question:
        "Une question, une erreur repérée dans une fiche ? Répondez simplement à cet e-mail, ou utilisez « Signaler une erreur » en bas de chaque fiche.",
      raison: "Vous recevez cet e-mail car vous venez de créer votre compte sur medical-guidelines.net.",
      monCompte: "Mon compte",
    },
    alertes: {
      nouvelles: "Nouvelles recommandations de vos sociétés suivies",
      misesAJour: "Vos fiches ont été mises à jour",
      lire: "Lire la fiche",
      source: "Document source officiel",
      sourceTexte: "Source officielle",
      fiche: "Fiche",
      raison: "Vous recevez cet e-mail car les alertes sont activées sur votre compte.",
      gerer: "Gérer mes alertes",
      desinscrire: "Se désinscrire",
      nouvelleVersion: "Nouvelle version publiée.",
      version: "Version {version}",
      sujetMixte: "{n} nouveautés pour vous sur medical-guidelines.net",
      sujetUneNouvelle: "Nouvelle recommandation : {titre}",
      sujetNouvelles: "{n} nouvelles recommandations de vos sociétés savantes",
      sujetUneMaj: "Fiche mise à jour : {titre}",
      sujetMajs: "{n} de vos fiches ont été mises à jour",
    },
    relances: {
      finaliserSujet: "Finalisez votre compte medical-guidelines.net",
      finaliser1:
        "Votre inscription sur medical-guidelines.net est presque terminée : il ne reste qu'à choisir votre identifiant et votre mot de passe.",
      finaliser2: "Vous aurez ensuite {quota} fiches de synthèse à débloquer gratuitement.",
      finaliserBouton: "Finaliser mon compte",
      finaliserValidite: "Ce lien personnel est valable 24 heures.",
      finaliserValiditeTexte: "(lien personnel valable 24 heures)",
      quotaSujetOuvert: "Vos 5 fiches gratuites sont utilisées : passez à PREMIUM",
      quotaSujet: "Vos 5 fiches gratuites sont utilisées",
      quota1: "Vous avez utilisé vos {quota} crédits gratuits : les fiches débloquées restent accessibles définitivement.",
      quotaOuvert:
        "Pour ouvrir toutes les fiches de votre spécialité et recevoir les alertes de mise à jour, l'abonnement PREMIUM coûte 50 € TTC par an. Les 100 premiers abonnés bénéficient de −30 % la première année avec le code FONDATEURS. Professionnel de santé en formation ? −30 % sur justificatif.",
      quotaBientot:
        "L'abonnement PREMIUM, qui ouvrira toutes les fiches de votre spécialité, sera bientôt disponible : nous vous préviendrons.",
      decouvrirPremium: "Découvrir PREMIUM",
      premiereSujet: "Vos 5 fiches gratuites vous attendent",
      premiere1:
        "Votre compte est prêt : {quota} fiches de synthèse vous sont offertes, à choisir librement. Chaque fiche ouverte reste accessible définitivement.",
      premiereSpecialite: "Pour commencer, voici les recommandations les plus récentes de votre spécialité :",
      premiereCatalogue:
        "Votre spécialité est encore peu couverte : vos fiches gratuites sont au choix dans tout le catalogue. Pour commencer, voici les recommandations les plus récentes :",
      voirToutes: "Voir toutes les recommandations",
    },
    commande: {
      pied: "Hippocampus Consulting, SARL au capital de 1 000 € — 6 rue d'Armaillé, 75017 Paris — SIREN 999 259 252.",
      cgv: "Conditions générales de vente",
      question: "Une question : répondez simplement à cet e-mail.",
      gerer: "Gérer mon abonnement",
      gererResilier: "Gérer ou résilier mon abonnement",
      confirmationSujet: "Confirmation de votre abonnement PREMIUM",
      merci:
        "Merci pour votre abonnement PREMIUM à medical-guidelines.net, souscrit le {date}. Il ouvre toutes les fiches de votre spécialité et les alertes de mise à jour.",
      montant:
        "Montant payé : {montant} TTC pour un an{fin}. La facture vous est envoyée séparément par notre prestataire de paiement, Stripe.",
      jusquau: ", jusqu'au {date}",
      renouvellement:
        "L'abonnement se renouvelle automatiquement chaque année au tarif alors en vigueur (50 € TTC par an aujourd'hui). Nous vous écrirons un à trois mois avant chaque renouvellement. Vous pouvez le résilier à tout moment depuis la page « Abonnement » (bouton « Résilier mon abonnement ») : l'accès reste ouvert jusqu'à la fin de l'année payée.",
      retractationRenonciation:
        "Droit de rétractation : le {date}, vous avez demandé l'accès immédiat au service et renoncé expressément à votre droit de rétractation de 14 jours dès le début de l'accès (article L221-28 13° du Code de la consommation).",
      retractation:
        "Droit de rétractation : l'accès au service étant immédiat, il ne s'applique plus dès le début de l'accès (article L221-28 13° du Code de la consommation).",
      cgvVersion: "Conditions générales de vente acceptées : version du {version}.",
      avisSujet: "Votre abonnement PREMIUM sera renouvelé le {date}",
      echeance: "Votre abonnement PREMIUM à medical-guidelines.net arrive à échéance le {date}.",
      renouvele: "Sans action de votre part, il sera renouvelé automatiquement ce jour-là pour un an, au prix de {montant} TTC.",
      resilier:
        "Si vous ne souhaitez pas le renouveler, vous pouvez le résilier dès maintenant depuis la page « Abonnement » : l'accès reste ouvert jusqu'au {date}, puis votre compte redevient gratuit, sans perte des fiches débloquées avec vos crédits gratuits.",
      ttc: "TTC",
    },
    etudiant: {
      sujetValide: "Votre tarif professionnel en formation est validé",
      sujet: "Votre demande de tarif professionnel en formation",
      valideRenouvellement:
        "Votre justificatif est validé : la réduction de 30 % s'appliquera automatiquement à votre prochain renouvellement.",
      valide:
        "Votre justificatif est validé : la réduction de 30 % s'applique automatiquement à votre première année PREMIUM, soit 35 € TTC au lieu de 50 €. Aucun code à saisir.",
      activer: "Activer PREMIUM à 35 €",
      activerTexte: "Activer PREMIUM",
      refuse: "Nous n'avons pas pu valider votre justificatif.",
      motif: "Motif :",
      nouveau: "Vous pouvez déposer un nouveau justificatif depuis votre page d'abonnement.",
      nouveauTexte: "Vous pouvez déposer un nouveau justificatif",
      supprime: "Votre justificatif a été supprimé après examen.",
      monAbonnement: "Mon abonnement",
    },
  },
  en: {
    dp: ": ",
    bonjour: "Hello,",
    bonjourPrenom: "Hello {prenom},",
    avertissement:
      "Independent, unofficial summaries: they replace neither the full text of the guidelines nor clinical judgement.",
    stop: "Stop receiving these emails",
    bienvenue: {
      sujet: "Welcome to medical-guidelines.net",
      catalogueOuvert:
        "Your specialty is not yet well covered: your {quota} free summaries can be chosen from the whole catalogue (anaesthesiology and critical care, intensive care, emergency medicine, paediatrics…)",
      fiches: { one: "{n} summary{specialite} is waiting for you", other: "{n} summaries{specialite} are waiting for you" },
      enSpecialite: " in {specialite}",
      arrivent: "Summaries are being added as they are validated",
      arriventSpecialite: "Summaries in {specialite} are being added as they are validated",
      premiumCatalogue:
        "The PREMIUM subscription, which unlocks every summary in a specialty, will be offered once yours is covered: we will write to you then.",
      premiumOuvert:
        "To unlock everything, the PREMIUM subscription gives access to every summary in your specialty and to update alerts, for €50 incl. VAT per year (−30% in the first year with the code FONDATEURS, for the first 100 subscribers).",
      premiumBientot:
        "The PREMIUM subscription, which will unlock every summary in your specialty and update alerts, will be available soon: we will let you know.",
      pret: "Your account is ready. {catalogue}: faithful summaries of the medical societies' guidelines, with the original grades and the official source always given.",
      creditsTitre: "Your {quota} free credits",
      creditsTexte:
        "Every summary is visible in the library. Choose one and click “Unlock”: one credit opens the summary for good. You have {quota} credits, with no time limit.",
      ouvrirBibliotheque: "Open the library",
      astuce:
        "Tip: the search also finds words inside the summaries (a drug, a clinical situation), and the ☆ star keeps your favourite summaries at hand.",
      toutOuvrir: "Unlock everything",
      decouvrirPremium: "Discover PREMIUM",
      question: "A question, an error spotted in a summary? Simply reply to this email, or use “Report an error” at the bottom of each summary.",
      raison: "You are receiving this email because you have just created your account on medical-guidelines.net.",
      monCompte: "My account",
    },
    alertes: {
      nouvelles: "New guidelines from the societies you follow",
      misesAJour: "Your summaries have been updated",
      lire: "Read the summary",
      source: "Official source document",
      sourceTexte: "Official source",
      fiche: "Summary",
      raison: "You are receiving this email because alerts are turned on for your account.",
      gerer: "Manage my alerts",
      desinscrire: "Unsubscribe",
      nouvelleVersion: "New version published.",
      version: "Version {version}",
      sujetMixte: "{n} new items for you on medical-guidelines.net",
      sujetUneNouvelle: "New guideline: {titre}",
      sujetNouvelles: "{n} new guidelines from your societies",
      sujetUneMaj: "Summary updated: {titre}",
      sujetMajs: "{n} of your summaries have been updated",
    },
    relances: {
      finaliserSujet: "Complete your medical-guidelines.net account",
      finaliser1:
        "Your registration on medical-guidelines.net is almost complete: all that is left is to choose your username and password.",
      finaliser2: "You will then have {quota} summaries to unlock for free.",
      finaliserBouton: "Complete my account",
      finaliserValidite: "This personal link is valid for 24 hours.",
      finaliserValiditeTexte: "(personal link valid for 24 hours)",
      quotaSujetOuvert: "Your 5 free summaries are used: go PREMIUM",
      quotaSujet: "Your 5 free summaries are used",
      quota1: "You have used your {quota} free credits: the unlocked summaries remain available for good.",
      quotaOuvert:
        "To unlock every summary in your specialty and receive update alerts, the PREMIUM subscription costs €50 incl. VAT per year. The first 100 subscribers get −30% in the first year with the code FONDATEURS. A health professional in training? −30% with proof of status.",
      quotaBientot: "The PREMIUM subscription, which will unlock every summary in your specialty, will be available soon: we will let you know.",
      decouvrirPremium: "Discover PREMIUM",
      premiereSujet: "Your 5 free summaries are waiting for you",
      premiere1: "Your account is ready: {quota} summaries are offered to you, to be chosen freely. Each summary you open remains available for good.",
      premiereSpecialite: "To start, here are the most recent guidelines in your specialty:",
      premiereCatalogue:
        "Your specialty is not yet well covered: your free summaries can be chosen from the whole catalogue. To start, here are the most recent guidelines:",
      voirToutes: "See all guidelines",
    },
    commande: {
      pied: "Hippocampus Consulting, SARL with a share capital of €1,000 — 6 rue d'Armaillé, 75017 Paris, France — SIREN 999 259 252.",
      cgv: "Terms of sale",
      question: "A question: simply reply to this email.",
      gerer: "Manage my subscription",
      gererResilier: "Manage or cancel my subscription",
      confirmationSujet: "Confirmation of your PREMIUM subscription",
      merci:
        "Thank you for your PREMIUM subscription to medical-guidelines.net, taken out on {date}. It unlocks every summary in your specialty and update alerts.",
      montant: "Amount paid: {montant} incl. VAT for one year{fin}. The invoice is sent to you separately by our payment provider, Stripe.",
      jusquau: ", until {date}",
      renouvellement:
        "The subscription renews automatically each year at the price then in force (€50 incl. VAT per year today). We will write to you one to three months before each renewal. You can cancel it at any time from the “Subscription” page (“Cancel my subscription” button): access remains open until the end of the paid year.",
      retractationRenonciation:
        "Right of withdrawal: on {date}, you requested immediate access to the service and expressly waived your 14-day right of withdrawal from the start of access (article L221-28 13° of the French Consumer Code).",
      retractation:
        "Right of withdrawal: as access to the service is immediate, it no longer applies from the start of access (article L221-28 13° of the French Consumer Code).",
      cgvVersion: "Terms of sale accepted: version of {version} (the French version is legally binding).",
      avisSujet: "Your PREMIUM subscription will be renewed on {date}",
      echeance: "Your PREMIUM subscription to medical-guidelines.net expires on {date}.",
      renouvele: "Unless you take action, it will be renewed automatically on that day for one year, at a price of {montant} incl. VAT.",
      resilier:
        "If you do not wish to renew it, you can cancel it now from the “Subscription” page: access remains open until {date}, after which your account becomes free again, without losing the summaries unlocked with your free credits.",
      ttc: "incl. VAT",
    },
    etudiant: {
      sujetValide: "Your rate for health professionals in training is validated",
      sujet: "Your request for the rate for health professionals in training",
      valideRenouvellement: "Your proof is validated: the 30% discount will be applied automatically to your next renewal.",
      valide:
        "Your proof is validated: the 30% discount applies automatically to your first PREMIUM year, i.e. €35 incl. VAT instead of €50. No code to enter.",
      activer: "Activate PREMIUM for €35",
      activerTexte: "Activate PREMIUM",
      refuse: "We could not validate your proof.",
      motif: "Reason:",
      nouveau: "You can upload new proof from your subscription page.",
      nouveauTexte: "You can upload new proof",
      supprime: "Your proof was deleted after examination.",
      monAbonnement: "My subscription",
    },
  },
};
