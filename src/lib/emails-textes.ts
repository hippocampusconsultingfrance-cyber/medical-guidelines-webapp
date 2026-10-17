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
  es: {
    dp: ": ",
    bonjour: "Hola:",
    bonjourPrenom: "Hola, {prenom}:",
    avertissement:
      "Resúmenes independientes y no oficiales: no sustituyen ni al texto completo de las guías ni al juicio clínico.",
    stop: "Dejar de recibir estos correos",
    bienvenue: {
      sujet: "Bienvenido/a a medical-guidelines.net",
      catalogueOuvert:
        "Su especialidad todavía está poco cubierta: puede elegir sus {quota} resúmenes gratuitos en todo el catálogo (anestesiología y reanimación, medicina intensiva, urgencias, pediatría…)",
      fiches: { one: "Le espera {n} resumen{specialite}", other: "Le esperan {n} resúmenes{specialite}" },
      enSpecialite: " de {specialite}",
      arrivent: "Los resúmenes se van añadiendo a medida que se validan",
      arriventSpecialite: "Los resúmenes de {specialite} se van añadiendo a medida que se validan",
      premiumCatalogue:
        "La suscripción PREMIUM, que desbloquea todos los resúmenes de una especialidad, se le propondrá cuando la suya esté cubierta: le escribiremos en ese momento.",
      premiumOuvert:
        "Para desbloquearlo todo, la suscripción PREMIUM da acceso a todos los resúmenes de su especialidad y a las alertas de actualización, por 50 € IVA incluido al año (−30 % el primer año con el código FONDATEURS, para los 100 primeros suscriptores).",
      premiumBientot:
        "La suscripción PREMIUM, que desbloqueará todos los resúmenes de su especialidad y las alertas de actualización, estará disponible pronto: se lo comunicaremos.",
      pret: "Su cuenta está lista. {catalogue}: resúmenes fieles de las guías de las sociedades científicas, con los grados originales y la fuente oficial siempre indicada.",
      creditsTitre: "Sus {quota} créditos gratuitos",
      creditsTexte:
        "Todos los resúmenes son visibles en la biblioteca. Elija uno y pulse «Desbloquear»: un crédito abre el resumen para siempre. Dispone de {quota} créditos, sin límite de tiempo.",
      ouvrirBibliotheque: "Abrir la biblioteca",
      astuce:
        "Consejo: la búsqueda también encuentra palabras dentro de los resúmenes (un fármaco, una situación clínica), y la estrella ☆ mantiene a mano sus resúmenes favoritos.",
      toutOuvrir: "Desbloquearlo todo",
      decouvrirPremium: "Descubrir PREMIUM",
      question: "¿Una pregunta, un error detectado en un resumen? Responda simplemente a este correo o use «Notificar un error» al final de cada resumen.",
      raison: "Recibe este correo porque acaba de crear su cuenta en medical-guidelines.net.",
      monCompte: "Mi cuenta",
    },
    alertes: {
      nouvelles: "Nuevas guías de las sociedades que sigue",
      misesAJour: "Sus resúmenes se han actualizado",
      lire: "Leer el resumen",
      source: "Documento fuente oficial",
      sourceTexte: "Fuente oficial",
      fiche: "Resumen",
      raison: "Recibe este correo porque las alertas están activadas en su cuenta.",
      gerer: "Gestionar mis alertas",
      desinscrire: "Darme de baja",
      nouvelleVersion: "Nueva versión publicada.",
      version: "Versión {version}",
      sujetMixte: "{n} novedades para usted en medical-guidelines.net",
      sujetUneNouvelle: "Nueva guía: {titre}",
      sujetNouvelles: "{n} nuevas guías de sus sociedades",
      sujetUneMaj: "Resumen actualizado: {titre}",
      sujetMajs: "{n} de sus resúmenes se han actualizado",
    },
    relances: {
      finaliserSujet: "Complete su cuenta de medical-guidelines.net",
      finaliser1:
        "Su registro en medical-guidelines.net está casi terminado: solo le queda elegir su nombre de usuario y su contraseña.",
      finaliser2: "Después dispondrá de {quota} resúmenes para desbloquear gratis.",
      finaliserBouton: "Completar mi cuenta",
      finaliserValidite: "Este enlace personal es válido durante 24 horas.",
      finaliserValiditeTexte: "(enlace personal válido durante 24 horas)",
      quotaSujetOuvert: "Ha utilizado sus 5 resúmenes gratuitos: pase a PREMIUM",
      quotaSujet: "Ha utilizado sus 5 resúmenes gratuitos",
      quota1: "Ha utilizado sus {quota} créditos gratuitos: los resúmenes desbloqueados siguen disponibles para siempre.",
      quotaOuvert:
        "Para desbloquear todos los resúmenes de su especialidad y recibir las alertas de actualización, la suscripción PREMIUM cuesta 50 € IVA incluido al año. Los 100 primeros suscriptores obtienen −30 % el primer año con el código FONDATEURS. ¿Profesional sanitario en formación? −30 % con justificante.",
      quotaBientot: "La suscripción PREMIUM, que desbloqueará todos los resúmenes de su especialidad, estará disponible pronto: se lo comunicaremos.",
      decouvrirPremium: "Descubrir PREMIUM",
      premiereSujet: "Le esperan sus 5 resúmenes gratuitos",
      premiere1: "Su cuenta está lista: le ofrecemos {quota} resúmenes, a elegir libremente. Cada resumen que abra sigue disponible para siempre.",
      premiereSpecialite: "Para empezar, estas son las guías más recientes de su especialidad:",
      premiereCatalogue:
        "Su especialidad todavía está poco cubierta: puede elegir sus resúmenes gratuitos en todo el catálogo. Para empezar, estas son las guías más recientes:",
      voirToutes: "Ver todas las guías",
    },
    commande: {
      pied: "Hippocampus Consulting, SARL con un capital de 1000 € — 6 rue d'Armaillé, 75017 París, Francia — SIREN 999 259 252.",
      cgv: "Condiciones de venta",
      question: "¿Una pregunta? Responda simplemente a este correo.",
      gerer: "Gestionar mi suscripción",
      gererResilier: "Gestionar o cancelar mi suscripción",
      confirmationSujet: "Confirmación de su suscripción PREMIUM",
      merci:
        "Gracias por su suscripción PREMIUM a medical-guidelines.net, contratada el {date}. Desbloquea todos los resúmenes de su especialidad y las alertas de actualización.",
      montant: "Importe pagado: {montant} IVA incluido por un año{fin}. Nuestro proveedor de pagos, Stripe, le envía la factura por separado.",
      jusquau: ", hasta el {date}",
      renouvellement:
        "La suscripción se renueva automáticamente cada año al precio vigente en ese momento (hoy, 50 € IVA incluido al año). Le escribiremos entre uno y tres meses antes de cada renovación. Puede cancelarla en cualquier momento desde la página «Suscripción» (botón «Cancelar mi suscripción»): el acceso sigue abierto hasta el final del año pagado.",
      retractationRenonciation:
        "Derecho de desistimiento: el {date} solicitó el acceso inmediato al servicio y renunció expresamente a su derecho de desistimiento de 14 días desde el inicio del acceso (artículo L221-28 13° del Código de Consumo francés).",
      retractation:
        "Derecho de desistimiento: al ser inmediato el acceso al servicio, deja de aplicarse desde el inicio del acceso (artículo L221-28 13° del Código de Consumo francés).",
      cgvVersion: "Condiciones de venta aceptadas: versión del {version} (la versión francesa es la única jurídicamente vinculante).",
      avisSujet: "Su suscripción PREMIUM se renovará el {date}",
      echeance: "Su suscripción PREMIUM a medical-guidelines.net vence el {date}.",
      renouvele: "Salvo que haga algo, se renovará automáticamente ese día por un año, por un precio de {montant} IVA incluido.",
      resilier:
        "Si no desea renovarla, puede cancelarla ahora desde la página «Suscripción»: el acceso sigue abierto hasta el {date}; después su cuenta vuelve a ser gratuita, sin perder los resúmenes desbloqueados con sus créditos gratuitos.",
      ttc: "IVA incl.",
    },
    etudiant: {
      sujetValide: "Su tarifa para profesionales sanitarios en formación está validada",
      sujet: "Su solicitud de tarifa para profesionales sanitarios en formación",
      valideRenouvellement: "Su justificante está validado: el descuento del 30 % se aplicará automáticamente en su próxima renovación.",
      valide:
        "Su justificante está validado: el descuento del 30 % se aplica automáticamente a su primer año PREMIUM, es decir, 35 € IVA incluido en lugar de 50 €. No hay que introducir ningún código.",
      activer: "Activar PREMIUM por 35 €",
      activerTexte: "Activar PREMIUM",
      refuse: "No hemos podido validar su justificante.",
      motif: "Motivo:",
      nouveau: "Puede subir un nuevo justificante desde su página de suscripción.",
      nouveauTexte: "Puede subir un nuevo justificante",
      supprime: "Su justificante se ha eliminado tras su examen.",
      monAbonnement: "Mi suscripción",
    },
  },
  de: {
    dp: ": ",
    bonjour: "Guten Tag,",
    bonjourPrenom: "Guten Tag {prenom},",
    avertissement:
      "Unabhängige, nicht offizielle Zusammenfassungen: Sie ersetzen weder den vollständigen Text der Leitlinien noch das klinische Urteil.",
    stop: "Diese E-Mails nicht mehr erhalten",
    bienvenue: {
      sujet: "Willkommen bei medical-guidelines.net",
      catalogueOuvert:
        "Ihr Fachgebiet ist noch wenig abgedeckt: Ihre {quota} kostenlosen Zusammenfassungen können Sie aus dem gesamten Katalog wählen (Anästhesiologie und Intensivmedizin, Notfallmedizin, Pädiatrie…)",
      fiches: { one: "{n} Zusammenfassung{specialite} wartet auf Sie", other: "{n} Zusammenfassungen{specialite} warten auf Sie" },
      enSpecialite: " im Fachgebiet {specialite}",
      arrivent: "Die Zusammenfassungen kommen nach und nach hinzu, sobald sie freigegeben sind",
      arriventSpecialite: "Die Zusammenfassungen im Fachgebiet {specialite} kommen nach und nach hinzu, sobald sie freigegeben sind",
      premiumCatalogue:
        "Das PREMIUM-Abonnement, das alle Zusammenfassungen eines Fachgebiets freischaltet, wird Ihnen angeboten, sobald Ihres abgedeckt ist: Wir schreiben Ihnen dann.",
      premiumOuvert:
        "Um alles freizuschalten, gibt Ihnen das PREMIUM-Abonnement Zugang zu allen Zusammenfassungen Ihres Fachgebiets und zu Aktualisierungsbenachrichtigungen, für 50 € inkl. MwSt. pro Jahr (−30 % im ersten Jahr mit dem Code FONDATEURS für die ersten 100 Abonnenten).",
      premiumBientot:
        "Das PREMIUM-Abonnement, das alle Zusammenfassungen Ihres Fachgebiets und die Aktualisierungsbenachrichtigungen freischalten wird, ist bald verfügbar: Wir informieren Sie.",
      pret: "Ihr Konto ist bereit. {catalogue}: getreue Zusammenfassungen der Leitlinien der Fachgesellschaften, mit den ursprünglichen Empfehlungsgraden und stets angegebener offizieller Quelle.",
      creditsTitre: "Ihre {quota} kostenlosen Guthaben",
      creditsTexte:
        "Alle Zusammenfassungen sind in der Bibliothek sichtbar. Wählen Sie eine aus und klicken Sie auf „Freischalten“: Ein Guthaben öffnet die Zusammenfassung dauerhaft. Sie haben {quota} Guthaben, ohne zeitliche Begrenzung.",
      ouvrirBibliotheque: "Bibliothek öffnen",
      astuce:
        "Tipp: Die Suche findet auch Wörter innerhalb der Zusammenfassungen (einen Wirkstoff, eine klinische Situation), und der Stern ☆ hält Ihre Lieblingszusammenfassungen griffbereit.",
      toutOuvrir: "Alles freischalten",
      decouvrirPremium: "PREMIUM entdecken",
      question: "Eine Frage, ein Fehler in einer Zusammenfassung? Antworten Sie einfach auf diese E-Mail oder nutzen Sie „Fehler melden“ unten in jeder Zusammenfassung.",
      raison: "Sie erhalten diese E-Mail, weil Sie soeben Ihr Konto auf medical-guidelines.net erstellt haben.",
      monCompte: "Mein Konto",
    },
    alertes: {
      nouvelles: "Neue Leitlinien der Fachgesellschaften, denen Sie folgen",
      misesAJour: "Ihre Zusammenfassungen wurden aktualisiert",
      lire: "Zusammenfassung lesen",
      source: "Offizielles Quelldokument",
      sourceTexte: "Offizielle Quelle",
      fiche: "Zusammenfassung",
      raison: "Sie erhalten diese E-Mail, weil die Benachrichtigungen für Ihr Konto aktiviert sind.",
      gerer: "Meine Benachrichtigungen verwalten",
      desinscrire: "Abmelden",
      nouvelleVersion: "Neue Version veröffentlicht.",
      version: "Version {version}",
      sujetMixte: "{n} Neuigkeiten für Sie auf medical-guidelines.net",
      sujetUneNouvelle: "Neue Leitlinie: {titre}",
      sujetNouvelles: "{n} neue Leitlinien Ihrer Fachgesellschaften",
      sujetUneMaj: "Zusammenfassung aktualisiert: {titre}",
      sujetMajs: "{n} Ihrer Zusammenfassungen wurden aktualisiert",
    },
    relances: {
      finaliserSujet: "Vervollständigen Sie Ihr Konto bei medical-guidelines.net",
      finaliser1:
        "Ihre Registrierung bei medical-guidelines.net ist fast abgeschlossen: Sie müssen nur noch Ihren Benutzernamen und Ihr Passwort wählen.",
      finaliser2: "Danach können Sie {quota} Zusammenfassungen kostenlos freischalten.",
      finaliserBouton: "Mein Konto vervollständigen",
      finaliserValidite: "Dieser persönliche Link ist 24 Stunden gültig.",
      finaliserValiditeTexte: "(persönlicher Link, 24 Stunden gültig)",
      quotaSujetOuvert: "Ihre 5 kostenlosen Zusammenfassungen sind verbraucht: Wechseln Sie zu PREMIUM",
      quotaSujet: "Ihre 5 kostenlosen Zusammenfassungen sind verbraucht",
      quota1: "Sie haben Ihre {quota} kostenlosen Guthaben verbraucht: Die freigeschalteten Zusammenfassungen bleiben dauerhaft verfügbar.",
      quotaOuvert:
        "Um alle Zusammenfassungen Ihres Fachgebiets freizuschalten und Aktualisierungsbenachrichtigungen zu erhalten, kostet das PREMIUM-Abonnement 50 € inkl. MwSt. pro Jahr. Die ersten 100 Abonnenten erhalten −30 % im ersten Jahr mit dem Code FONDATEURS. Gesundheitsfachperson in Ausbildung? −30 % mit Nachweis.",
      quotaBientot: "Das PREMIUM-Abonnement, das alle Zusammenfassungen Ihres Fachgebiets freischalten wird, ist bald verfügbar: Wir informieren Sie.",
      decouvrirPremium: "PREMIUM entdecken",
      premiereSujet: "Ihre 5 kostenlosen Zusammenfassungen warten auf Sie",
      premiere1: "Ihr Konto ist bereit: {quota} Zusammenfassungen stehen Ihnen frei zur Wahl. Jede Zusammenfassung, die Sie öffnen, bleibt dauerhaft verfügbar.",
      premiereSpecialite: "Zum Einstieg die neuesten Leitlinien Ihres Fachgebiets:",
      premiereCatalogue:
        "Ihr Fachgebiet ist noch wenig abgedeckt: Ihre kostenlosen Zusammenfassungen können Sie aus dem gesamten Katalog wählen. Zum Einstieg die neuesten Leitlinien:",
      voirToutes: "Alle Leitlinien ansehen",
    },
    commande: {
      pied: "Hippocampus Consulting, SARL mit einem Stammkapital von 1.000 € — 6 rue d'Armaillé, 75017 Paris, Frankreich — SIREN 999 259 252.",
      cgv: "Verkaufsbedingungen",
      question: "Eine Frage? Antworten Sie einfach auf diese E-Mail.",
      gerer: "Mein Abonnement verwalten",
      gererResilier: "Mein Abonnement verwalten oder kündigen",
      confirmationSujet: "Bestätigung Ihres PREMIUM-Abonnements",
      merci:
        "Vielen Dank für Ihr PREMIUM-Abonnement bei medical-guidelines.net, abgeschlossen am {date}. Es schaltet alle Zusammenfassungen Ihres Fachgebiets und die Aktualisierungsbenachrichtigungen frei.",
      montant: "Gezahlter Betrag: {montant} inkl. MwSt. für ein Jahr{fin}. Die Rechnung erhalten Sie gesondert von unserem Zahlungsdienstleister Stripe.",
      jusquau: ", bis zum {date}",
      renouvellement:
        "Das Abonnement verlängert sich automatisch jedes Jahr zum dann geltenden Preis (derzeit 50 € inkl. MwSt. pro Jahr). Wir schreiben Ihnen ein bis drei Monate vor jeder Verlängerung. Sie können es jederzeit auf der Seite „Abonnement“ kündigen (Schaltfläche „Mein Abonnement kündigen“): Der Zugang bleibt bis zum Ende des bezahlten Jahres bestehen.",
      retractationRenonciation:
        "Widerrufsrecht: Am {date} haben Sie den sofortigen Zugang zum Dienst verlangt und ausdrücklich auf Ihr 14-tägiges Widerrufsrecht ab Beginn des Zugangs verzichtet (Artikel L221-28 13° des französischen Verbrauchergesetzbuchs).",
      retractation:
        "Widerrufsrecht: Da der Zugang zum Dienst sofort erfolgt, gilt es ab Beginn des Zugangs nicht mehr (Artikel L221-28 13° des französischen Verbrauchergesetzbuchs).",
      cgvVersion: "Akzeptierte Verkaufsbedingungen: Fassung vom {version} (rechtsverbindlich ist allein die französische Fassung).",
      avisSujet: "Ihr PREMIUM-Abonnement wird am {date} verlängert",
      echeance: "Ihr PREMIUM-Abonnement bei medical-guidelines.net läuft am {date} ab.",
      renouvele: "Wenn Sie nichts unternehmen, verlängert es sich an diesem Tag automatisch um ein Jahr zum Preis von {montant} inkl. MwSt.",
      resilier:
        "Wenn Sie es nicht verlängern möchten, können Sie es jetzt auf der Seite „Abonnement“ kündigen: Der Zugang bleibt bis zum {date} bestehen; danach ist Ihr Konto wieder kostenlos, ohne die mit Ihren kostenlosen Guthaben freigeschalteten Zusammenfassungen zu verlieren.",
      ttc: "inkl. MwSt.",
    },
    etudiant: {
      sujetValide: "Ihr Tarif für Gesundheitsfachpersonen in Ausbildung ist bestätigt",
      sujet: "Ihre Anfrage zum Tarif für Gesundheitsfachpersonen in Ausbildung",
      valideRenouvellement: "Ihr Nachweis ist bestätigt: Der Rabatt von 30 % wird automatisch auf Ihre nächste Verlängerung angewendet.",
      valide:
        "Ihr Nachweis ist bestätigt: Der Rabatt von 30 % gilt automatisch für Ihr erstes PREMIUM-Jahr, also 35 € inkl. MwSt. statt 50 €. Kein Code erforderlich.",
      activer: "PREMIUM für 35 € aktivieren",
      activerTexte: "PREMIUM aktivieren",
      refuse: "Wir konnten Ihren Nachweis nicht bestätigen.",
      motif: "Grund:",
      nouveau: "Sie können auf Ihrer Abonnementseite einen neuen Nachweis hochladen.",
      nouveauTexte: "Sie können einen neuen Nachweis hochladen",
      supprime: "Ihr Nachweis wurde nach der Prüfung gelöscht.",
      monAbonnement: "Mein Abonnement",
    },
  },
  ar: {
    dp: ": ",
    bonjour: "مرحبًا،",
    bonjourPrenom: "مرحبًا {prenom}،",
    avertissement: "ملخصات مستقلة وغير رسمية: لا تغني عن النص الكامل للتوصيات ولا عن التقدير السريري.",
    stop: "التوقف عن تلقي هذه الرسائل",
    bienvenue: {
      sujet: "مرحبًا بك في medical-guidelines.net",
      catalogueOuvert:
        "تخصصك ما زال قليل التغطية: يمكنك اختيار ملخصاتك المجانية الـ{quota} من الفهرس بأكمله (التخدير والإنعاش، العناية المركزة، طب الطوارئ، طب الأطفال…)",
      fiches: {
        zero: "لا توجد ملخصات{specialite} بعد",
        one: "ملخص واحد{specialite} بانتظارك",
        two: "ملخصان{specialite} بانتظارك",
        few: "{n} ملخصات{specialite} بانتظارك",
        many: "{n} ملخصًا{specialite} بانتظارك",
        other: "{n} ملخص{specialite} بانتظارك",
      },
      enSpecialite: " في {specialite}",
      arrivent: "تُضاف الملخصات تباعًا كلما اعتُمدت",
      arriventSpecialite: "تُضاف ملخصات {specialite} تباعًا كلما اعتُمدت",
      premiumCatalogue: "سيُعرض عليك اشتراك PREMIUM، الذي يفتح جميع ملخصات التخصص، عندما يصبح تخصصك مغطًّى: وسنراسلك حينها.",
      premiumOuvert:
        "لفتح كل شيء، يتيح لك اشتراك PREMIUM الوصول إلى جميع ملخصات تخصصك وإلى تنبيهات التحديث، مقابل 50 € شاملة الضريبة سنويًا (خصم 30% في السنة الأولى بالرمز FONDATEURS، لأول 100 مشترك).",
      premiumBientot: "سيتاح قريبًا اشتراك PREMIUM الذي سيفتح جميع ملخصات تخصصك وتنبيهات التحديث: وسنُعلمك بذلك.",
      pret: "حسابك جاهز. {catalogue}: ملخصات أمينة لتوصيات الجمعيات العلمية، مع درجات التوصية الأصلية والمصدر الرسمي مذكورًا دائمًا.",
      creditsTitre: "أرصدتك المجانية الـ{quota}",
      creditsTexte:
        "جميع الملخصات ظاهرة في المكتبة. اختر واحدًا وانقر على «فتح»: يفتح الرصيد الواحد الملخص بصفة دائمة. لديك {quota} أرصدة، دون حد زمني.",
      ouvrirBibliotheque: "فتح المكتبة",
      astuce: "نصيحة: يعثر البحث أيضًا على الكلمات داخل الملخصات (دواء، حالة سريرية)، والنجمة ☆ تُبقي ملخصاتك المفضلة في متناولك.",
      toutOuvrir: "فتح كل شيء",
      decouvrirPremium: "اكتشف PREMIUM",
      question: "سؤال، أو خطأ لاحظته في ملخص؟ ردّ ببساطة على هذه الرسالة، أو استخدم «الإبلاغ عن خطأ» أسفل كل ملخص.",
      raison: "تتلقى هذه الرسالة لأنك أنشأت للتو حسابك على medical-guidelines.net.",
      monCompte: "حسابي",
    },
    alertes: {
      nouvelles: "توصيات جديدة من الجمعيات التي تتابعها",
      misesAJour: "تم تحديث ملخصاتك",
      lire: "قراءة الملخص",
      source: "الوثيقة المصدر الرسمية",
      sourceTexte: "المصدر الرسمي",
      fiche: "الملخص",
      raison: "تتلقى هذه الرسالة لأن التنبيهات مفعّلة في حسابك.",
      gerer: "إدارة تنبيهاتي",
      desinscrire: "إلغاء الاشتراك",
      nouvelleVersion: "نُشرت نسخة جديدة.",
      version: "الإصدار {version}",
      sujetMixte: "جديد لك على medical-guidelines.net ({n})",
      sujetUneNouvelle: "توصية جديدة: {titre}",
      sujetNouvelles: "توصيات جديدة من جمعياتك ({n})",
      sujetUneMaj: "تحديث ملخص: {titre}",
      sujetMajs: "تم تحديث ملخصات لديك ({n})",
    },
    relances: {
      finaliserSujet: "أكمل حسابك على medical-guidelines.net",
      finaliser1: "تسجيلك على medical-guidelines.net أوشك على الاكتمال: لم يتبقَّ سوى اختيار اسم المستخدم وكلمة المرور.",
      finaliser2: "بعد ذلك ستكون لديك {quota} ملخصات لفتحها مجانًا.",
      finaliserBouton: "إكمال حسابي",
      finaliserValidite: "هذا الرابط الشخصي صالح لمدة 24 ساعة.",
      finaliserValiditeTexte: "(رابط شخصي صالح لمدة 24 ساعة)",
      quotaSujetOuvert: "استُخدمت ملخصاتك المجانية الخمسة: انتقل إلى PREMIUM",
      quotaSujet: "استُخدمت ملخصاتك المجانية الخمسة",
      quota1: "لقد استخدمت أرصدتك المجانية الـ{quota}: تبقى الملخصات المفتوحة متاحة بصفة دائمة.",
      quotaOuvert:
        "لفتح جميع ملخصات تخصصك وتلقي تنبيهات التحديث، يبلغ سعر اشتراك PREMIUM ‏50 € شاملة الضريبة سنويًا. يحصل أول 100 مشترك على خصم 30% في السنة الأولى بالرمز FONDATEURS. عامل في المهن الصحية قيد التكوين؟ خصم 30% عند تقديم ما يثبت ذلك.",
      quotaBientot: "سيتاح قريبًا اشتراك PREMIUM الذي سيفتح جميع ملخصات تخصصك: وسنُعلمك بذلك.",
      decouvrirPremium: "اكتشف PREMIUM",
      premiereSujet: "ملخصاتك المجانية الخمسة بانتظارك",
      premiere1: "حسابك جاهز: نقدّم لك {quota} ملخصات تختارها بحرية. يبقى كل ملخص تفتحه متاحًا بصفة دائمة.",
      premiereSpecialite: "للبدء، إليك أحدث التوصيات في تخصصك:",
      premiereCatalogue: "تخصصك ما زال قليل التغطية: يمكنك اختيار ملخصاتك المجانية من الفهرس بأكمله. للبدء، إليك أحدث التوصيات:",
      voirToutes: "عرض جميع التوصيات",
    },
    commande: {
      pied: "Hippocampus Consulting، شركة ذات مسؤولية محدودة (SARL) برأسمال 1000 € — 6 rue d'Armaillé, 75017 Paris، فرنسا — SIREN 999 259 252.",
      cgv: "شروط البيع",
      question: "لأي سؤال: ردّ ببساطة على هذه الرسالة.",
      gerer: "إدارة اشتراكي",
      gererResilier: "إدارة اشتراكي أو إلغاؤه",
      confirmationSujet: "تأكيد اشتراكك في PREMIUM",
      merci:
        "شكرًا لاشتراكك في PREMIUM على medical-guidelines.net، المُبرم في {date}. يفتح الاشتراك جميع ملخصات تخصصك وتنبيهات التحديث.",
      montant: "المبلغ المدفوع: {montant} شاملة الضريبة لسنة واحدة{fin}. تُرسل إليك الفاتورة بشكل منفصل من مزوّد الدفع لدينا، Stripe.",
      jusquau: "، حتى {date}",
      renouvellement:
        "يتجدد الاشتراك تلقائيًا كل سنة بالسعر المعمول به حينها (50 € شاملة الضريبة سنويًا حاليًا). سنراسلك قبل كل تجديد بمدة تتراوح بين شهر وثلاثة أشهر. يمكنك إلغاؤه في أي وقت من صفحة «الاشتراك» (زر «إلغاء اشتراكي»): ويبقى الوصول مفتوحًا حتى نهاية السنة المدفوعة.",
      retractationRenonciation:
        "حق العدول: في {date}، طلبت الوصول الفوري إلى الخدمة وتنازلت صراحةً عن حقك في العدول خلال 14 يومًا اعتبارًا من بدء الوصول (المادة L221-28 الفقرة 13 من قانون الاستهلاك الفرنسي).",
      retractation:
        "حق العدول: بما أن الوصول إلى الخدمة فوري، فإن هذا الحق لا يعود ساريًا اعتبارًا من بدء الوصول (المادة L221-28 الفقرة 13 من قانون الاستهلاك الفرنسي).",
      cgvVersion: "شروط البيع المقبولة: نسخة {version} (النسخة الفرنسية وحدها هي الملزمة قانونًا).",
      avisSujet: "سيتجدد اشتراكك في PREMIUM في {date}",
      echeance: "ينتهي اشتراكك في PREMIUM على medical-guidelines.net في {date}.",
      renouvele: "ما لم تتخذ أي إجراء، سيتجدد تلقائيًا في ذلك اليوم لمدة سنة، بسعر {montant} شاملة الضريبة.",
      resilier:
        "إذا كنت لا ترغب في تجديده، يمكنك إلغاؤه الآن من صفحة «الاشتراك»: يبقى الوصول مفتوحًا حتى {date}، ثم يعود حسابك مجانيًا، دون أن تفقد الملخصات التي فتحتها بأرصدتك المجانية.",
      ttc: "شاملة الضريبة",
    },
    etudiant: {
      sujetValide: "اعتُمد سعرك الخاص بالعاملين في المهن الصحية قيد التكوين",
      sujet: "طلبك للسعر الخاص بالعاملين في المهن الصحية قيد التكوين",
      valideRenouvellement: "اعتُمد إثباتك: سيُطبَّق خصم 30% تلقائيًا على تجديدك القادم.",
      valide:
        "اعتُمد إثباتك: يُطبَّق خصم 30% تلقائيًا على سنتك الأولى في PREMIUM، أي 35 € شاملة الضريبة بدلًا من 50 €. لا حاجة لإدخال أي رمز.",
      activer: "تفعيل PREMIUM مقابل 35 €",
      activerTexte: "تفعيل PREMIUM",
      refuse: "لم نتمكن من اعتماد إثباتك.",
      motif: "السبب:",
      nouveau: "يمكنك تحميل إثبات جديد من صفحة اشتراكك.",
      nouveauTexte: "يمكنك تحميل إثبات جديد",
      supprime: "حُذف إثباتك بعد دراسته.",
      monAbonnement: "اشتراكي",
    },
  },
  zh: {
    dp: "：",
    bonjour: "您好，",
    bonjourPrenom: "{prenom}，您好：",
    avertissement: "独立、非官方的摘要：不能替代指南全文或临床判断。",
    stop: "不再接收此类邮件",
    bienvenue: {
      sujet: "欢迎使用 medical-guidelines.net",
      catalogueOuvert: "您的专科目前覆盖尚少：您可以在整个目录中选择 {quota} 篇免费摘要（麻醉与重症、重症医学、急诊医学、儿科……）",
      fiches: { other: "{n} 篇{specialite}摘要正等待您阅读" },
      enSpecialite: "{specialite}",
      arrivent: "摘要将在审核通过后陆续添加",
      arriventSpecialite: "{specialite}摘要将在审核通过后陆续添加",
      premiumCatalogue: "PREMIUM 订阅可解锁某一专科的全部摘要，待您的专科有所覆盖时将向您提供：届时我们会写信通知您。",
      premiumOuvert:
        "如需解锁全部内容，PREMIUM 订阅可让您访问所在专科的全部摘要并接收更新提醒，价格为每年 50 €（含税）（前 100 名订阅者使用优惠码 FONDATEURS 首年优惠 30%）。",
      premiumBientot: "PREMIUM 订阅即将推出，届时可解锁您所在专科的全部摘要及更新提醒：我们会通知您。",
      pret: "您的账户已就绪。{catalogue}：忠实于原文的医学学会指南摘要，保留原始推荐等级，并始终注明官方来源。",
      creditsTitre: "您的 {quota} 个免费点数",
      creditsTexte: "所有摘要都显示在资料库中。选择一篇并点击“解锁”：一个点数可永久打开一篇摘要。您有 {quota} 个点数，无使用期限。",
      ouvrirBibliotheque: "打开资料库",
      astuce: "提示：搜索也能找到摘要正文中的词语（药物、临床情境），☆ 星标可让您常用的摘要触手可及。",
      toutOuvrir: "解锁全部",
      decouvrirPremium: "了解 PREMIUM",
      question: "有疑问，或在摘要中发现错误？直接回复此邮件，或使用每篇摘要底部的“报告错误”。",
      raison: "您收到此邮件，是因为您刚刚在 medical-guidelines.net 创建了账户。",
      monCompte: "我的账户",
    },
    alertes: {
      nouvelles: "您关注的学会发布的新指南",
      misesAJour: "您的摘要已更新",
      lire: "阅读摘要",
      source: "官方原始文件",
      sourceTexte: "官方来源",
      fiche: "摘要",
      raison: "您收到此邮件，是因为您的账户已开启提醒。",
      gerer: "管理我的提醒",
      desinscrire: "退订",
      nouvelleVersion: "新版本已发布。",
      version: "版本 {version}",
      sujetMixte: "medical-guidelines.net 为您带来 {n} 条新内容",
      sujetUneNouvelle: "新指南：{titre}",
      sujetNouvelles: "您关注的学会发布了 {n} 份新指南",
      sujetUneMaj: "摘要已更新：{titre}",
      sujetMajs: "您的 {n} 篇摘要已更新",
    },
    relances: {
      finaliserSujet: "完善您的 medical-guidelines.net 账户",
      finaliser1: "您在 medical-guidelines.net 的注册即将完成：只需设置用户名和密码。",
      finaliser2: "之后您可以免费解锁 {quota} 篇摘要。",
      finaliserBouton: "完善我的账户",
      finaliserValidite: "此个人链接 24 小时内有效。",
      finaliserValiditeTexte: "（个人链接，24 小时内有效）",
      quotaSujetOuvert: "您的 5 篇免费摘要已用完：升级 PREMIUM",
      quotaSujet: "您的 5 篇免费摘要已用完",
      quota1: "您已用完 {quota} 个免费点数：已解锁的摘要将永久可用。",
      quotaOuvert:
        "如需解锁您所在专科的全部摘要并接收更新提醒，PREMIUM 订阅价格为每年 50 €（含税）。前 100 名订阅者使用优惠码 FONDATEURS 首年优惠 30%。在读/培训中的医疗卫生专业人员？凭证明优惠 30%。",
      quotaBientot: "PREMIUM 订阅即将推出，届时可解锁您所在专科的全部摘要：我们会通知您。",
      decouvrirPremium: "了解 PREMIUM",
      premiereSujet: "您的 5 篇免费摘要正等待您",
      premiere1: "您的账户已就绪：我们为您提供 {quota} 篇可自由选择的摘要。您打开的每篇摘要都将永久可用。",
      premiereSpecialite: "首先，以下是您所在专科的最新指南：",
      premiereCatalogue: "您的专科目前覆盖尚少：您可以在整个目录中选择免费摘要。首先，以下是最新的指南：",
      voirToutes: "查看所有指南",
    },
    commande: {
      pied: "Hippocampus Consulting，注册资本 1000 € 的有限责任公司（SARL）— 6 rue d'Armaillé, 75017 Paris, 法国 — SIREN 999 259 252。",
      cgv: "销售条款",
      question: "如有疑问，直接回复此邮件即可。",
      gerer: "管理我的订阅",
      gererResilier: "管理或取消我的订阅",
      confirmationSujet: "您的 PREMIUM 订阅确认",
      merci: "感谢您于 {date} 订阅 medical-guidelines.net 的 PREMIUM 服务。该订阅可解锁您所在专科的全部摘要及更新提醒。",
      montant: "已付金额：{montant}（含税），期限一年{fin}。发票将由我们的支付服务商 Stripe 另行发送给您。",
      jusquau: "，至 {date}",
      renouvellement:
        "订阅每年按届时有效的价格自动续订（目前为每年 50 €，含税）。每次续订前一至三个月，我们会写信通知您。您可以随时在“订阅”页面取消（“取消我的订阅”按钮）：访问权限保留至已付费年度结束。",
      retractationRenonciation:
        "撤回权：您于 {date} 要求立即使用本服务，并明确放弃自访问开始之日起 14 天的撤回权（《法国消费法典》第 L221-28 条第 13 项）。",
      retractation: "撤回权：由于本服务即时开通，自访问开始之日起不再适用撤回权（《法国消费法典》第 L221-28 条第 13 项）。",
      cgvVersion: "已接受的销售条款：{version} 版（仅法文版本具有法律约束力）。",
      avisSujet: "您的 PREMIUM 订阅将于 {date} 续订",
      echeance: "您在 medical-guidelines.net 的 PREMIUM 订阅将于 {date} 到期。",
      renouvele: "如您不作任何操作，订阅将于当日自动续订一年，价格为 {montant}（含税）。",
      resilier:
        "如您不希望续订，现在即可在“订阅”页面取消：访问权限保留至 {date}，之后您的账户将恢复为免费账户，用免费点数解锁的摘要不会丢失。",
      ttc: "含税",
    },
    etudiant: {
      sujetValide: "您的在读/培训医疗卫生专业人员优惠价已通过",
      sujet: "关于您的在读/培训医疗卫生专业人员优惠价申请",
      valideRenouvellement: "您的证明已通过：下次续订时将自动享受 30% 折扣。",
      valide: "您的证明已通过：首年 PREMIUM 自动享受 30% 折扣，即 35 €（含税），而非 50 €。无需输入任何优惠码。",
      activer: "以 35 € 激活 PREMIUM",
      activerTexte: "激活 PREMIUM",
      refuse: "我们未能通过您的证明。",
      motif: "原因：",
      nouveau: "您可以在订阅页面重新上传证明。",
      nouveauTexte: "您可以重新上传证明",
      supprime: "您的证明在审核后已被删除。",
      monAbonnement: "我的订阅",
    },
  },
};
