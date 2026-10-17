import type { Traductions } from "@/i18n/serveur";

// Accueil public (page.tsx, accueil-public.tsx).
export const ACCUEIL: Traductions<{
  titreMeta: string;
  descriptionMeta: string;
  ogLocale: string;
  allerContenu: string;
  navCompte: string;
  seConnecter: string;
  creerCompte: string;
  surtitre: string;
  titre: string;
  accroche: string;
  creerCompteGratuit: string;
  dejaCompte: string;
  rechercheLibelle: string;
  recherchePlaceholder: string;
  chercher: string;
  voirListe: string;
  atouts: string[];
  apercu: {
    surtitre: string;
    titre: string;
    methodologie: string;
    version: string;
    versionDate: string;
    section: string;
    ref: string;
    recommandation: string;
    grade: string;
    lignes: [string, string, string][];
    source: string;
    legende: string;
  };
  sourcesAria: string;
  sourcesTexte: string;
  sourcesAutres: string;
  recentes: string;
  toutes: string;
  principesTitre: string;
  principes: { titre: string; texte: string }[];
  etapesTitre: string;
  etapes: [string, string][];
  offreTitre: string;
  gratuit: string;
  gratuitPrix: string;
  gratuitPoints: string[];
  commencer: string;
  premium: string;
  premiumPrix: string;
  premiumPeriode: string;
  premiumPoints: string[];
  sabonner: string;
  premiumNote: string;
  demarche: string;
  partenairesTitre: string;
  partenairesTexte: string;
  partenairesBouton: string;
  relecteursTitre: string;
  relecteursTexte: string;
  relecteursBouton: string;
  faqTitre: string;
  faq: [string, string][];
  appelTitre: string;
  appelTexte: string;
  aProposAria: string;
  tagline: string;
  avertissement: string;
  corrections: string;
  contact: string;
}> = {
  fr: {
    titreMeta: "medical-guidelines.net — Recommandations médicales et paramédicales en fiches",
    descriptionMeta:
      "Les recommandations des sociétés savantes en fiches claires et sourcées, grades conservés, pour les médecins et les professionnels paramédicaux. 5 fiches gratuites.",
    ogLocale: "fr_FR",
    allerContenu: "Aller au contenu",
    navCompte: "Compte",
    seConnecter: "Se connecter",
    creerCompte: "Créer un compte",
    surtitre: "Médecins et paramédicaux",
    titre: "Les recommandations professionnelles, en fiches claires et sourcées",
    accroche:
      "Trouvez, comprenez et vérifiez une recommandation en quelques instants, sans relire un document de 100 pages. Grades conservés, source officielle toujours à portée de clic.",
    creerCompteGratuit: "Créer mon compte gratuit",
    dejaCompte: "J'ai déjà un compte",
    rechercheLibelle: "Rechercher une recommandation",
    recherchePlaceholder: "Ex. : sepsis, ALR…",
    chercher: "Chercher",
    voirListe: "Voir la liste des recommandations disponibles →",
    atouts: ["5 fiches gratuites", "Sans carte bancaire", "Ordinateur et mobile"],
    apercu: {
      surtitre: "SFAR / GIHP — RFE 2026",
      titre: "Anticoagulants & procédure invasive",
      methodologie: "Méthodologie",
      version: "Version",
      versionDate: "20 avril 2026",
      section: "Procédure à risque hémorragique faible — pas d'arrêt",
      ref: "Réf.",
      recommandation: "Recommandation",
      grade: "Grade",
      lignes: [
        ["2.1", "AVK : poursuivre le traitement ; contrôler l'INR dans la semaine précédant la procédure (absence de surdosage).", "2+"],
        [
          "2.2",
          "AOD (apixaban, dabigatran, édoxaban, rivaroxaban) : sauter la prise de la veille au soir ET celle du matin de la procédure (quel que soit le schéma), reprise aux doses habituelles ≥ 6h après le geste.",
          "2+",
        ],
      ],
      source: "Document source officiel ↗",
      legende: "Extrait d'une fiche : chaque recommandation garde son grade et sa source.",
    },
    sourcesAria: "Sources",
    sourcesTexte: "Synthèses indépendantes des recommandations publiées par",
    sourcesAutres: "et d'autres sociétés savantes",
    recentes: "Les recommandations les plus récentes",
    toutes: "Toutes les recommandations →",
    principesTitre: "Ce que vous trouvez dans chaque fiche",
    principes: [
      {
        titre: "Clair et structuré",
        texte:
          "Les recommandations sont présentées par thème, dans des tableaux clairs, chacune avec son grade tel qu'il figure dans la source.",
      },
      {
        titre: "Toujours relié à la source",
        texte:
          "Société savante, titre, date et lien vers le document officiel : la fiche ne remplace jamais le texte de référence.",
      },
      {
        titre: "Grades sans altération",
        texte:
          "Les grades et niveaux de preuve sont reproduits comme dans la source, ou signalés « non indiqué ». Aucun n'est inventé ni fusionné.",
      },
      {
        titre: "Transparence",
        texte:
          "Les divergences entre sociétés savantes sont affichées sans arbitrage ; toute erreur peut être signalée depuis la fiche.",
      },
    ],
    etapesTitre: "Comment ça marche",
    etapes: [
      ["Créez un compte gratuit", "Nom, e-mail, profession et spécialité à consulter ; confirmation de l'adresse par un lien envoyé par e-mail."],
      ["Débloquez 5 fiches", "Choisissez 5 fiches complètes, consultables à vie, sans carte bancaire."],
      ["Consultez partout", "Sur ordinateur, tablette ou téléphone, au moment où vous en avez besoin."],
    ],
    offreTitre: "Une offre simple",
    gratuit: "Gratuit",
    gratuitPrix: "0 €",
    gratuitPoints: ["5 fiches complètes au choix, consultables à vie", "Aucune carte bancaire", "Consultation sur ordinateur et mobile"],
    commencer: "Commencer gratuitement",
    premium: "Premium",
    premiumPrix: "50 €",
    premiumPeriode: "TTC / an",
    premiumPoints: [
      "Toutes les fiches de votre spécialité",
      "Paiement annuel, résiliable à tout moment",
      "−30 % la première année pour les 100 premiers abonnés (offre membres fondateurs, 35 €)",
      "−30 % pour les internes et étudiants sur justificatif (non cumulable)",
    ],
    sabonner: "S'abonner",
    premiumNote:
      "Votre abonnement ne paie pas les recommandations, qui restent en accès libre sur les sites des sociétés savantes : il couvre l'hébergement, les développeurs et les outils d'IA du site.",
    demarche: "Notre démarche",
    partenairesTitre: "Vous êtes une société savante ? Devenez notre partenaire",
    partenairesTexte:
      "Accès PREMIUM offert, statistiques anonymes de lecture de vos recommandations et signalements d'erreurs des lecteurs sur vos fiches.",
    partenairesBouton: "Devenir partenaire",
    relecteursTitre: "Vous êtes médecin et vous souhaitez participer à la correction des fiches ?",
    relecteursTexte:
      "Les fiches ont déjà été relues deux fois par des outils d'intelligence artificielle. Bénéficiez d'un accès gratuit et illimité au site, ainsi que de 5 accès gratuits illimités pour les personnes de votre choix.",
    relecteursBouton: "Devenir relecteur",
    faqTitre: "Questions fréquentes",
    faq: [
      [
        "Pour qui ?",
        "Pour les médecins, internes et étudiants, ainsi que pour les professionnels paramédicaux. Les fiches couvrent déjà l'anesthésie-réanimation, la réanimation, la médecine d'urgence, la pédiatrie et d'autres spécialités, et s'étendent progressivement ; vous choisissez à l'inscription la spécialité que vous souhaitez consulter.",
      ],
      [
        "Ces fiches remplacent-elles les recommandations officielles ?",
        "Non. Ce sont des synthèses indépendantes, écrites comme aide-mémoire. Elles ne sont ni éditées ni validées par les sociétés savantes citées et ne remplacent ni le document source ni le jugement clinique.",
      ],
      [
        "Vendez-vous les recommandations des sociétés savantes ?",
        "Non. Les recommandations restent en accès libre sur les sites des sociétés savantes, et chaque fiche renvoie au texte officiel. L'abonnement ne sert pas à tirer profit des recommandations : il couvre ce que coûte le site, c'est-à-dire l'hébergement, les développeurs et les outils d'intelligence artificielle qui aident à préparer les fiches. Ce site a été construit grâce à des personnes volontaires.",
      ],
      [
        "Que contient l'offre payante ?",
        "L'abonnement PREMIUM ouvre toutes les fiches de votre spécialité, avec des alertes e-mail à chaque mise à jour, pour 50 € TTC par an, résiliable à tout moment. La première année : −30 % pour les 100 premiers abonnés (code FONDATEURS, soit 35 €) ou −30 % pour les professionnels de santé en formation sur justificatif ; ces réductions ne se cumulent pas.",
      ],
      ["Puis-je télécharger ou imprimer une fiche ?", "Non : la consultation se fait uniquement en ligne, sur ordinateur et sur mobile."],
      ["Y a-t-il des données de patients ?", "Non. Le site ne traite aucune donnée de santé de patient."],
    ],
    appelTitre: "Essayez avec 5 fiches gratuites",
    appelTexte: "Création du compte en une minute, sans carte bancaire.",
    aProposAria: "À propos du site",
    tagline: "Recommandations médicales et paramédicales",
    avertissement:
      "Aide à la pratique : ces fiches ne remplacent ni le jugement clinique ni le document source officiel, et ne sont ni éditées ni validées par les sociétés savantes citées.",
    corrections: "Journal des corrections",
    contact: "Contact :",
  },
  en: {
    titreMeta: "medical-guidelines.net — Medical and allied health guidelines, summarised",
    descriptionMeta:
      "Guidelines from medical societies in clear, referenced summaries with the original grades, for doctors and allied health professionals. 5 free summaries.",
    ogLocale: "en_GB",
    allerContenu: "Skip to content",
    navCompte: "Account",
    seConnecter: "Sign in",
    creerCompte: "Create an account",
    surtitre: "Doctors and allied health professionals",
    titre: "Professional guidelines, in clear and referenced summaries",
    accroche:
      "Find, understand and check a recommendation in moments, without rereading a 100-page document. Original grades kept, the official source always one click away.",
    creerCompteGratuit: "Create my free account",
    dejaCompte: "I already have an account",
    rechercheLibelle: "Search for a guideline",
    recherchePlaceholder: "e.g. sepsis, regional anaesthesia…",
    chercher: "Search",
    voirListe: "See the list of available guidelines →",
    atouts: ["5 free summaries", "No credit card", "Computer and mobile"],
    apercu: {
      surtitre: "SFAR / GIHP — 2026 guidelines",
      titre: "Anticoagulants & invasive procedures",
      methodologie: "Methodology",
      version: "Version",
      versionDate: "20 April 2026",
      section: "Procedure with low bleeding risk — no interruption",
      ref: "Ref.",
      recommandation: "Recommendation",
      grade: "Grade",
      lignes: [
        ["2.1", "VKA: continue treatment; check the INR in the week before the procedure (no overdose).", "2+"],
        [
          "2.2",
          "DOAC (apixaban, dabigatran, edoxaban, rivaroxaban): skip the evening dose the day before AND the morning dose on the day of the procedure (whatever the regimen); resume usual doses ≥ 6 h after the procedure.",
          "2+",
        ],
      ],
      source: "Official source document ↗",
      legende: "Extract from a summary (translated from French): each recommendation keeps its grade and its source.",
    },
    sourcesAria: "Sources",
    sourcesTexte: "Independent summaries of guidelines published by",
    sourcesAutres: "and other medical societies",
    recentes: "The most recent guidelines",
    toutes: "All guidelines →",
    principesTitre: "What you find in every summary",
    principes: [
      {
        titre: "Clear and structured",
        texte: "Recommendations are presented by topic, in clear tables, each with its grade exactly as it appears in the source.",
      },
      {
        titre: "Always linked to the source",
        texte: "Society, title, date and a link to the official document: a summary never replaces the reference text.",
      },
      {
        titre: "Grades left unaltered",
        texte:
          "Grades and levels of evidence are reproduced as in the source, or marked “not stated”. None is invented or merged.",
      },
      {
        titre: "Transparency",
        texte: "Disagreements between societies are shown without arbitration; any error can be reported from the summary.",
      },
    ],
    etapesTitre: "How it works",
    etapes: [
      ["Create a free account", "Name, email, profession and the specialty you want to read; confirm your address with a link sent by email."],
      ["Unlock 5 summaries", "Choose 5 full summaries, yours to read for life, no credit card needed."],
      ["Read anywhere", "On a computer, tablet or phone, whenever you need it."],
    ],
    offreTitre: "A simple offer",
    gratuit: "Free",
    gratuitPrix: "€0",
    gratuitPoints: ["5 full summaries of your choice, yours for life", "No credit card", "Read on computer and mobile"],
    commencer: "Start for free",
    premium: "Premium",
    premiumPrix: "€50",
    premiumPeriode: "incl. VAT / year",
    premiumPoints: [
      "Every summary in your specialty",
      "Annual payment, cancel at any time",
      "−30% in the first year for the first 100 subscribers (founding members offer, €35)",
      "−30% for residents and students with proof of status (not combinable)",
    ],
    sabonner: "Subscribe",
    premiumNote:
      "Your subscription does not pay for the guidelines, which remain freely available on the societies' websites: it covers the site's hosting, developers and AI tools.",
    demarche: "Our approach",
    partenairesTitre: "Are you a medical society? Become our partner",
    partenairesTexte:
      "Free PREMIUM access, anonymous readership statistics for your guidelines and readers' error reports on your summaries.",
    partenairesBouton: "Become a partner",
    relecteursTitre: "Are you a doctor who would like to help correct the summaries?",
    relecteursTexte:
      "The summaries have already been checked twice by artificial intelligence tools. Get free, unlimited access to the site, plus 5 free unlimited accounts for people of your choice.",
    relecteursBouton: "Become a reviewer",
    faqTitre: "Frequently asked questions",
    faq: [
      [
        "Who is it for?",
        "For doctors, residents and students, and for allied health professionals. The summaries already cover anaesthesiology and critical care, intensive care, emergency medicine, paediatrics and other specialties, and are expanding steadily; you choose the specialty you want to read when you sign up.",
      ],
      [
        "Do these summaries replace the official guidelines?",
        "No. They are independent summaries, written as memory aids. They are neither edited nor endorsed by the societies cited, and replace neither the source document nor clinical judgement.",
      ],
      [
        "Do you sell the societies' guidelines?",
        "No. The guidelines remain freely available on the societies' websites, and every summary links to the official text. The subscription is not about profiting from the guidelines: it covers what the site costs, namely hosting, developers and the artificial intelligence tools that help prepare the summaries. This site was built thanks to volunteers.",
      ],
      [
        "What does the paid offer include?",
        "The PREMIUM subscription unlocks every summary in your specialty, with email alerts at each update, for €50 incl. VAT per year, cancel at any time. In the first year: −30% for the first 100 subscribers (code FONDATEURS, i.e. €35) or −30% for health professionals in training with proof of status; these discounts cannot be combined.",
      ],
      ["Can I download or print a summary?", "No: summaries can only be read online, on computer and mobile."],
      ["Is there any patient data?", "No. The site processes no patient health data."],
    ],
    appelTitre: "Try it with 5 free summaries",
    appelTexte: "Create your account in one minute, no credit card needed.",
    aProposAria: "About the site",
    tagline: "Medical and allied health guidelines",
    avertissement:
      "A practice aid: these summaries replace neither clinical judgement nor the official source document, and are neither edited nor endorsed by the societies cited.",
    corrections: "Corrections log",
    contact: "Contact:",
  },
};
