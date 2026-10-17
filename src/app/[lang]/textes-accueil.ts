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
  es: {
    titreMeta: "medical-guidelines.net — Guías médicas y paramédicas, resumidas",
    descriptionMeta:
      "Las guías de las sociedades científicas en resúmenes claros y referenciados, con los grados originales, para médicos y profesionales sanitarios. 5 resúmenes gratuitos.",
    ogLocale: "es_ES",
    allerContenu: "Ir al contenido",
    navCompte: "Cuenta",
    seConnecter: "Iniciar sesión",
    creerCompte: "Crear una cuenta",
    surtitre: "Médicos y profesionales sanitarios",
    titre: "Las guías de práctica clínica, en resúmenes claros y referenciados",
    accroche:
      "Encuentre, comprenda y compruebe una recomendación en unos instantes, sin releer un documento de 100 páginas. Grados conservados y la fuente oficial siempre a un clic.",
    creerCompteGratuit: "Crear mi cuenta gratuita",
    dejaCompte: "Ya tengo una cuenta",
    rechercheLibelle: "Buscar una guía",
    recherchePlaceholder: "p. ej.: sepsis, anestesia locorregional…",
    chercher: "Buscar",
    voirListe: "Ver la lista de guías disponibles →",
    atouts: ["5 resúmenes gratuitos", "Sin tarjeta bancaria", "Ordenador y móvil"],
    apercu: {
      surtitre: "SFAR / GIHP — Guías 2026",
      titre: "Anticoagulantes y procedimientos invasivos",
      methodologie: "Metodología",
      version: "Versión",
      versionDate: "20 de abril de 2026",
      section: "Procedimiento con bajo riesgo hemorrágico — sin interrupción",
      ref: "Ref.",
      recommandation: "Recomendación",
      grade: "Grado",
      lignes: [
        ["2.1", "AVK: continuar el tratamiento; controlar el INR en la semana previa al procedimiento (sin sobredosificación).", "2+"],
        [
          "2.2",
          "ACOD (apixabán, dabigatrán, edoxabán, rivaroxabán): omitir la dosis de la noche anterior Y la de la mañana del procedimiento (sea cual sea la pauta); reanudar las dosis habituales ≥ 6 h después del procedimiento.",
          "2+",
        ],
      ],
      source: "Documento fuente oficial ↗",
      legende: "Extracto de un resumen (traducido del francés): cada recomendación conserva su grado y su fuente.",
    },
    sourcesAria: "Fuentes",
    sourcesTexte: "Resúmenes independientes de las guías publicadas por",
    sourcesAutres: "y otras sociedades científicas",
    recentes: "Las guías más recientes",
    toutes: "Todas las guías →",
    principesTitre: "Lo que encontrará en cada resumen",
    principes: [
      {
        titre: "Claro y estructurado",
        texte: "Las recomendaciones se presentan por tema, en tablas claras, cada una con su grado tal como figura en la fuente.",
      },
      {
        titre: "Siempre vinculado a la fuente",
        texte: "Sociedad, título, fecha y enlace al documento oficial: un resumen nunca sustituye al texto de referencia.",
      },
      {
        titre: "Grados sin modificar",
        texte:
          "Los grados y niveles de evidencia se reproducen como en la fuente, o se indican como «no precisado». Ninguno se inventa ni se fusiona.",
      },
      {
        titre: "Transparencia",
        texte: "Los desacuerdos entre sociedades se muestran sin arbitraje; cualquier error puede notificarse desde el resumen.",
      },
    ],
    etapesTitre: "Cómo funciona",
    etapes: [
      ["Cree una cuenta gratuita", "Nombre, correo electrónico, profesión y especialidad que desea leer; confirme su dirección con el enlace recibido por correo."],
      ["Desbloquee 5 resúmenes", "Elija 5 resúmenes completos, suyos para siempre, sin tarjeta bancaria."],
      ["Lea donde quiera", "En ordenador, tableta o móvil, cuando lo necesite."],
    ],
    offreTitre: "Una oferta sencilla",
    gratuit: "Gratuito",
    gratuitPrix: "0 €",
    gratuitPoints: ["5 resúmenes completos a su elección, suyos para siempre", "Sin tarjeta bancaria", "Lectura en ordenador y móvil"],
    commencer: "Empezar gratis",
    premium: "Premium",
    premiumPrix: "50 €",
    premiumPeriode: "IVA incl. / año",
    premiumPoints: [
      "Todos los resúmenes de su especialidad",
      "Pago anual, cancelable en cualquier momento",
      "−30 % el primer año para los 100 primeros suscriptores (oferta miembros fundadores, 35 €)",
      "−30 % para residentes y estudiantes con justificante (no acumulable)",
    ],
    sabonner: "Suscribirse",
    premiumNote:
      "Su suscripción no paga las guías, que siguen siendo de libre acceso en las webs de las sociedades: cubre el alojamiento, los desarrolladores y las herramientas de IA del sitio.",
    demarche: "Nuestro enfoque",
    partenairesTitre: "¿Una sociedad científica? Hágase socia",
    partenairesTexte:
      "Acceso PREMIUM gratuito, estadísticas anónimas de lectura de sus guías y notificaciones de errores de los lectores en sus resúmenes.",
    partenairesBouton: "Ser socio",
    relecteursTitre: "¿Es usted médico y quiere ayudar a corregir los resúmenes?",
    relecteursTexte:
      "Los resúmenes ya han sido revisados dos veces por herramientas de inteligencia artificial. Obtenga acceso gratuito e ilimitado al sitio y 5 cuentas gratuitas ilimitadas para las personas que usted elija.",
    relecteursBouton: "Ser revisor",
    faqTitre: "Preguntas frecuentes",
    faq: [
      [
        "¿A quién va dirigido?",
        "A médicos, residentes y estudiantes, y a los profesionales sanitarios no médicos. Los resúmenes ya abarcan anestesiología y reanimación, medicina intensiva, urgencias, pediatría y otras especialidades, y se amplían continuamente; usted elige al registrarse la especialidad que desea leer.",
      ],
      [
        "¿Sustituyen estos resúmenes a las guías oficiales?",
        "No. Son resúmenes independientes, redactados como ayuda para la memoria. No están editados ni avalados por las sociedades citadas, y no sustituyen ni al documento fuente ni al juicio clínico.",
      ],
      [
        "¿Venden ustedes las guías de las sociedades?",
        "No. Las guías siguen siendo de libre acceso en las webs de las sociedades, y cada resumen enlaza con el texto oficial. La suscripción no busca obtener beneficio de las guías: cubre lo que cuesta el sitio, es decir, el alojamiento, los desarrolladores y las herramientas de inteligencia artificial que ayudan a preparar los resúmenes. Este sitio se ha construido gracias a personas voluntarias.",
      ],
      [
        "¿Qué incluye la oferta de pago?",
        "La suscripción PREMIUM desbloquea todos los resúmenes de su especialidad, con alertas por correo en cada actualización, por 50 € IVA incluido al año, cancelable en cualquier momento. El primer año: −30 % para los 100 primeros suscriptores (código FONDATEURS, es decir, 35 €) o −30 % para profesionales sanitarios en formación con justificante; estos descuentos no son acumulables.",
      ],
      ["¿Puedo descargar o imprimir un resumen?", "No: los resúmenes solo pueden leerse en línea, en ordenador y móvil."],
      ["¿Hay datos de pacientes?", "No. El sitio no trata ningún dato de salud de pacientes."],
    ],
    appelTitre: "Pruébelo con 5 resúmenes gratuitos",
    appelTexte: "Cree su cuenta en un minuto, sin tarjeta bancaria.",
    aProposAria: "Acerca del sitio",
    tagline: "Guías médicas y paramédicas",
    avertissement:
      "Una ayuda para la práctica: estos resúmenes no sustituyen ni al juicio clínico ni al documento fuente oficial, y no están editados ni avalados por las sociedades citadas.",
    corrections: "Registro de correcciones",
    contact: "Contacto:",
  },
  de: {
    titreMeta: "medical-guidelines.net — Ärztliche und gesundheitsfachliche Leitlinien, zusammengefasst",
    descriptionMeta:
      "Die Leitlinien der Fachgesellschaften in klaren, belegten Zusammenfassungen mit den ursprünglichen Empfehlungsgraden, für Ärztinnen und Ärzte sowie Gesundheitsfachberufe. 5 kostenlose Zusammenfassungen.",
    ogLocale: "de_DE",
    allerContenu: "Zum Inhalt springen",
    navCompte: "Konto",
    seConnecter: "Anmelden",
    creerCompte: "Konto erstellen",
    surtitre: "Ärztinnen, Ärzte und Gesundheitsfachberufe",
    titre: "Klinische Leitlinien in klaren, belegten Zusammenfassungen",
    accroche:
      "Finden, verstehen und prüfen Sie eine Empfehlung in wenigen Augenblicken, ohne ein 100-seitiges Dokument erneut zu lesen. Empfehlungsgrade erhalten, die offizielle Quelle immer nur einen Klick entfernt.",
    creerCompteGratuit: "Mein kostenloses Konto erstellen",
    dejaCompte: "Ich habe bereits ein Konto",
    rechercheLibelle: "Leitlinie suchen",
    recherchePlaceholder: "z. B. Sepsis, Regionalanästhesie…",
    chercher: "Suchen",
    voirListe: "Liste der verfügbaren Leitlinien ansehen →",
    atouts: ["5 kostenlose Zusammenfassungen", "Ohne Kreditkarte", "Computer und Smartphone"],
    apercu: {
      surtitre: "SFAR / GIHP — Leitlinien 2026",
      titre: "Antikoagulanzien & invasive Eingriffe",
      methodologie: "Methodik",
      version: "Version",
      versionDate: "20. April 2026",
      section: "Eingriff mit niedrigem Blutungsrisiko — keine Unterbrechung",
      ref: "Nr.",
      recommandation: "Empfehlung",
      grade: "Grad",
      lignes: [
        ["2.1", "VKA: Behandlung fortsetzen; INR in der Woche vor dem Eingriff kontrollieren (keine Überdosierung).", "2+"],
        [
          "2.2",
          "DOAK (Apixaban, Dabigatran, Edoxaban, Rivaroxaban): Abenddosis am Vortag UND Morgendosis am Tag des Eingriffs auslassen (unabhängig vom Schema); übliche Dosen ≥ 6 h nach dem Eingriff wieder aufnehmen.",
          "2+",
        ],
      ],
      source: "Offizielles Quelldokument ↗",
      legende: "Auszug aus einer Zusammenfassung (aus dem Französischen übersetzt): Jede Empfehlung behält ihren Grad und ihre Quelle.",
    },
    sourcesAria: "Quellen",
    sourcesTexte: "Unabhängige Zusammenfassungen der Leitlinien von",
    sourcesAutres: "und weiteren Fachgesellschaften",
    recentes: "Die neuesten Leitlinien",
    toutes: "Alle Leitlinien →",
    principesTitre: "Was Sie in jeder Zusammenfassung finden",
    principes: [
      {
        titre: "Klar und strukturiert",
        texte: "Die Empfehlungen sind nach Themen in übersichtlichen Tabellen dargestellt, jede mit ihrem Grad genau wie in der Quelle.",
      },
      {
        titre: "Immer mit der Quelle verknüpft",
        texte: "Fachgesellschaft, Titel, Datum und Link zum offiziellen Dokument: Eine Zusammenfassung ersetzt nie den Referenztext.",
      },
      {
        titre: "Unveränderte Empfehlungsgrade",
        texte:
          "Empfehlungsgrade und Evidenzniveaus werden wie in der Quelle wiedergegeben oder als „nicht angegeben“ gekennzeichnet. Keiner wird erfunden oder zusammengeführt.",
      },
      {
        titre: "Transparenz",
        texte: "Abweichungen zwischen Fachgesellschaften werden ohne Wertung gezeigt; jeder Fehler kann direkt aus der Zusammenfassung gemeldet werden.",
      },
    ],
    etapesTitre: "So funktioniert es",
    etapes: [
      ["Kostenloses Konto erstellen", "Name, E-Mail, Beruf und gewünschtes Fachgebiet; bestätigen Sie Ihre Adresse über den per E-Mail gesendeten Link."],
      ["5 Zusammenfassungen freischalten", "Wählen Sie 5 vollständige Zusammenfassungen, dauerhaft Ihre, ohne Kreditkarte."],
      ["Überall lesen", "Am Computer, Tablet oder Smartphone, wann immer Sie sie brauchen."],
    ],
    offreTitre: "Ein einfaches Angebot",
    gratuit: "Kostenlos",
    gratuitPrix: "0 €",
    gratuitPoints: ["5 vollständige Zusammenfassungen Ihrer Wahl, dauerhaft Ihre", "Ohne Kreditkarte", "Lesen am Computer und Smartphone"],
    commencer: "Kostenlos starten",
    premium: "Premium",
    premiumPrix: "50 €",
    premiumPeriode: "inkl. MwSt. / Jahr",
    premiumPoints: [
      "Alle Zusammenfassungen Ihres Fachgebiets",
      "Jährliche Zahlung, jederzeit kündbar",
      "−30 % im ersten Jahr für die ersten 100 Abonnenten (Angebot für Gründungsmitglieder, 35 €)",
      "−30 % für Ärztinnen und Ärzte in Weiterbildung sowie Studierende mit Nachweis (nicht kombinierbar)",
    ],
    sabonner: "Abonnieren",
    premiumNote:
      "Ihr Abonnement bezahlt nicht die Leitlinien, die auf den Websites der Fachgesellschaften frei zugänglich bleiben: Es deckt Hosting, Entwickler und KI-Werkzeuge der Website.",
    demarche: "Unser Ansatz",
    partenairesTitre: "Eine Fachgesellschaft? Werden Sie unser Partner",
    partenairesTexte:
      "Kostenloser PREMIUM-Zugang, anonyme Lesestatistiken zu Ihren Leitlinien und Fehlermeldungen der Leser zu Ihren Zusammenfassungen.",
    partenairesBouton: "Partner werden",
    relecteursTitre: "Sind Sie Ärztin oder Arzt und möchten bei der Korrektur der Zusammenfassungen helfen?",
    relecteursTexte:
      "Die Zusammenfassungen wurden bereits zweimal von Werkzeugen der künstlichen Intelligenz geprüft. Erhalten Sie kostenlosen, unbegrenzten Zugang zur Website sowie 5 kostenlose, unbegrenzte Konten für Personen Ihrer Wahl.",
    relecteursBouton: "Gutachter werden",
    faqTitre: "Häufige Fragen",
    faq: [
      [
        "Für wen ist das Angebot?",
        "Für Ärztinnen und Ärzte, Ärztinnen und Ärzte in Weiterbildung und Studierende sowie für Gesundheitsfachberufe. Die Zusammenfassungen umfassen bereits Anästhesiologie und Intensivmedizin, Notfallmedizin, Pädiatrie und weitere Fachgebiete und werden laufend erweitert; Sie wählen bei der Registrierung das Fachgebiet, das Sie lesen möchten.",
      ],
      [
        "Ersetzen diese Zusammenfassungen die offiziellen Leitlinien?",
        "Nein. Es sind unabhängige Zusammenfassungen, verfasst als Gedächtnisstütze. Sie werden von den genannten Fachgesellschaften weder herausgegeben noch gebilligt und ersetzen weder das Quelldokument noch das klinische Urteil.",
      ],
      [
        "Verkaufen Sie die Leitlinien der Fachgesellschaften?",
        "Nein. Die Leitlinien bleiben auf den Websites der Fachgesellschaften frei zugänglich, und jede Zusammenfassung verlinkt auf den offiziellen Text. Mit dem Abonnement soll kein Gewinn aus den Leitlinien erzielt werden: Es deckt die Kosten der Website, also Hosting, Entwickler und die Werkzeuge der künstlichen Intelligenz, die bei der Erstellung der Zusammenfassungen helfen. Diese Website wurde dank Freiwilliger aufgebaut.",
      ],
      [
        "Was umfasst das kostenpflichtige Angebot?",
        "Das PREMIUM-Abonnement schaltet alle Zusammenfassungen Ihres Fachgebiets frei, mit E-Mail-Benachrichtigung bei jeder Aktualisierung, für 50 € inkl. MwSt. pro Jahr, jederzeit kündbar. Im ersten Jahr: −30 % für die ersten 100 Abonnenten (Code FONDATEURS, also 35 €) oder −30 % für Gesundheitsfachpersonen in Ausbildung mit Nachweis; diese Rabatte sind nicht kombinierbar.",
      ],
      ["Kann ich eine Zusammenfassung herunterladen oder drucken?", "Nein: Die Zusammenfassungen können nur online gelesen werden, am Computer und am Smartphone."],
      ["Gibt es Patientendaten?", "Nein. Die Website verarbeitet keine Gesundheitsdaten von Patienten."],
    ],
    appelTitre: "Testen Sie es mit 5 kostenlosen Zusammenfassungen",
    appelTexte: "Erstellen Sie Ihr Konto in einer Minute, ohne Kreditkarte.",
    aProposAria: "Über die Website",
    tagline: "Ärztliche und gesundheitsfachliche Leitlinien",
    avertissement:
      "Eine Hilfe für die Praxis: Diese Zusammenfassungen ersetzen weder das klinische Urteil noch das offizielle Quelldokument und werden von den genannten Fachgesellschaften weder herausgegeben noch gebilligt.",
    corrections: "Korrekturprotokoll",
    contact: "Kontakt:",
  },
  ar: {
    titreMeta: "medical-guidelines.net — التوصيات الطبية وتوصيات المهن الصحية، ملخّصة",
    descriptionMeta:
      "توصيات الجمعيات العلمية في ملخصات واضحة وموثّقة مع درجات التوصية الأصلية، للأطباء والعاملين في المهن الصحية. 5 ملخصات مجانية.",
    ogLocale: "ar_AR",
    allerContenu: "الانتقال إلى المحتوى",
    navCompte: "الحساب",
    seConnecter: "تسجيل الدخول",
    creerCompte: "إنشاء حساب",
    surtitre: "الأطباء والعاملون في المهن الصحية",
    titre: "التوصيات المهنية في ملخصات واضحة وموثّقة",
    accroche:
      "اعثر على توصية وافهمها وتحقّق منها في لحظات، دون إعادة قراءة وثيقة من 100 صفحة. درجات التوصية محفوظة، والمصدر الرسمي دائمًا على بُعد نقرة واحدة.",
    creerCompteGratuit: "إنشاء حسابي المجاني",
    dejaCompte: "لديّ حساب بالفعل",
    rechercheLibelle: "البحث عن توصية",
    recherchePlaceholder: "مثال: الإنتان، التخدير الموضعي الناحي…",
    chercher: "بحث",
    voirListe: "عرض قائمة التوصيات المتاحة ←",
    atouts: ["5 ملخصات مجانية", "دون بطاقة مصرفية", "الحاسوب والهاتف"],
    apercu: {
      surtitre: "SFAR / GIHP — توصيات 2026",
      titre: "مضادات التخثر والإجراءات الباضعة",
      methodologie: "المنهجية",
      version: "الإصدار",
      versionDate: "20 أبريل 2026",
      section: "إجراء منخفض خطر النزف — دون إيقاف",
      ref: "رقم",
      recommandation: "التوصية",
      grade: "الدرجة",
      lignes: [
        ["2.1", "مضادات فيتامين K: يُستمر في العلاج؛ ويُراقب INR في الأسبوع السابق للإجراء (عدم وجود جرعة زائدة).", "2+"],
        [
          "2.2",
          "مضادات التخثر الفموية المباشرة (أبيكسابان، دابيغاتران، إدوكسابان، ريفاروكسابان): تُحذف جرعة مساء اليوم السابق وجرعة صباح يوم الإجراء (أيًّا كان نظام الجرعات)؛ وتُستأنف الجرعات المعتادة بعد ≥ 6 ساعات من الإجراء.",
          "2+",
        ],
      ],
      source: "الوثيقة المصدر الرسمية ↗",
      legende: "مقتطف من ملخص (مترجم عن الفرنسية): تحتفظ كل توصية بدرجتها ومصدرها.",
    },
    sourcesAria: "المصادر",
    sourcesTexte: "ملخصات مستقلة للتوصيات الصادرة عن",
    sourcesAutres: "وجمعيات علمية أخرى",
    recentes: "أحدث التوصيات",
    toutes: "جميع التوصيات ←",
    principesTitre: "ما تجده في كل ملخص",
    principes: [
      {
        titre: "واضح ومنظّم",
        texte: "تُعرض التوصيات حسب الموضوع في جداول واضحة، ولكل منها درجتها كما وردت في المصدر تمامًا.",
      },
      {
        titre: "مرتبط دائمًا بالمصدر",
        texte: "الجمعية والعنوان والتاريخ ورابط إلى الوثيقة الرسمية: لا يحلّ الملخص أبدًا محلّ النص المرجعي.",
      },
      {
        titre: "درجات دون تعديل",
        texte: "تُنقل درجات التوصية ومستويات الدليل كما وردت في المصدر، أو يُشار إليها بعبارة «غير محدّدة». لا يُختلق أيٌّ منها ولا يُدمج.",
      },
      {
        titre: "الشفافية",
        texte: "تُعرض الاختلافات بين الجمعيات دون ترجيح؛ ويمكن الإبلاغ عن أي خطأ من الملخص نفسه.",
      },
    ],
    etapesTitre: "كيف يعمل الموقع",
    etapes: [
      ["أنشئ حسابًا مجانيًا", "الاسم والبريد الإلكتروني والمهنة والتخصص الذي تريد قراءته؛ ثم أكّد عنوانك عبر الرابط المرسل بالبريد الإلكتروني."],
      ["افتح 5 ملخصات", "اختر 5 ملخصات كاملة تبقى لك مدى الحياة، دون بطاقة مصرفية."],
      ["اقرأ أينما كنت", "على الحاسوب أو الجهاز اللوحي أو الهاتف، متى احتجت إليها."],
    ],
    offreTitre: "عرض بسيط",
    gratuit: "مجاني",
    gratuitPrix: "0 €",
    gratuitPoints: ["5 ملخصات كاملة من اختيارك، تبقى لك مدى الحياة", "دون بطاقة مصرفية", "القراءة على الحاسوب والهاتف"],
    commencer: "ابدأ مجانًا",
    premium: "Premium",
    premiumPrix: "50 €",
    premiumPeriode: "شاملة الضريبة / سنة",
    premiumPoints: [
      "جميع ملخصات تخصصك",
      "دفع سنوي، مع إمكانية الإلغاء في أي وقت",
      "خصم 30% في السنة الأولى لأول 100 مشترك (عرض الأعضاء المؤسسين، 35 €)",
      "خصم 30% للأطباء المقيمين والطلاب عند تقديم ما يثبت ذلك (غير قابل للجمع)",
    ],
    sabonner: "اشترك",
    premiumNote:
      "اشتراكك لا يدفع ثمن التوصيات، فهي تبقى متاحة مجانًا على مواقع الجمعيات: بل يغطي الاستضافة والمطوّرين وأدوات الذكاء الاصطناعي الخاصة بالموقع.",
    demarche: "نهجنا",
    partenairesTitre: "هل تمثلون جمعية علمية؟ كونوا شركاءنا",
    partenairesTexte:
      "وصول PREMIUM مجاني، وإحصاءات قراءة مجهولة الهوية لتوصياتكم، وبلاغات القرّاء عن الأخطاء في ملخصاتكم.",
    partenairesBouton: "كونوا شركاء",
    relecteursTitre: "هل أنت طبيب وترغب في المساعدة على تصحيح الملخصات؟",
    relecteursTexte:
      "خضعت الملخصات بالفعل لمراجعتين بأدوات الذكاء الاصطناعي. احصل على وصول مجاني وغير محدود إلى الموقع، و5 حسابات مجانية غير محدودة لأشخاص من اختيارك.",
    relecteursBouton: "كن مراجعًا",
    faqTitre: "الأسئلة الشائعة",
    faq: [
      [
        "لمن هذا الموقع؟",
        "للأطباء والأطباء المقيمين والطلاب، وللعاملين في المهن الصحية. تغطي الملخصات حاليًا التخدير والإنعاش، والعناية المركزة، وطب الطوارئ، وطب الأطفال، وتخصصات أخرى، وهي تتوسع باستمرار؛ وتختار عند التسجيل التخصص الذي تريد قراءته.",
      ],
      [
        "هل تحلّ هذه الملخصات محلّ التوصيات الرسمية؟",
        "لا. إنها ملخصات مستقلة كُتبت للمساعدة على التذكّر. ليست من إصدار الجمعيات المذكورة ولا معتمدة منها، ولا تغني عن الوثيقة المصدر ولا عن التقدير السريري.",
      ],
      [
        "هل تبيعون توصيات الجمعيات؟",
        "لا. تبقى التوصيات متاحة مجانًا على مواقع الجمعيات، وكل ملخص يحيل إلى النص الرسمي. لا يهدف الاشتراك إلى التربّح من التوصيات: بل يغطي تكاليف الموقع، أي الاستضافة والمطوّرين وأدوات الذكاء الاصطناعي التي تساعد في إعداد الملخصات. بُني هذا الموقع بفضل متطوعين.",
      ],
      [
        "ماذا يشمل العرض المدفوع؟",
        "يفتح اشتراك PREMIUM جميع ملخصات تخصصك، مع تنبيهات بالبريد الإلكتروني عند كل تحديث، مقابل 50 € شاملة الضريبة سنويًا، مع إمكانية الإلغاء في أي وقت. في السنة الأولى: خصم 30% لأول 100 مشترك (الرمز FONDATEURS، أي 35 €) أو خصم 30% للعاملين في المهن الصحية قيد التكوين عند تقديم ما يثبت ذلك؛ ولا يمكن الجمع بين هذين الخصمين.",
      ],
      ["هل يمكنني تنزيل ملخص أو طباعته؟", "لا: لا يمكن قراءة الملخصات إلا عبر الإنترنت، على الحاسوب والهاتف."],
      ["هل توجد بيانات مرضى؟", "لا. لا يعالج الموقع أي بيانات صحية خاصة بالمرضى."],
    ],
    appelTitre: "جرّبه مع 5 ملخصات مجانية",
    appelTexte: "أنشئ حسابك في دقيقة واحدة، دون بطاقة مصرفية.",
    aProposAria: "حول الموقع",
    tagline: "التوصيات الطبية وتوصيات المهن الصحية",
    avertissement:
      "أداة مساعدة في الممارسة: لا تغني هذه الملخصات عن التقدير السريري ولا عن الوثيقة المصدر الرسمية، وليست من إصدار الجمعيات المذكورة ولا معتمدة منها.",
    corrections: "سجل التصحيحات",
    contact: "للتواصل:",
  },
  zh: {
    titreMeta: "medical-guidelines.net — 医学及医疗专业指南摘要",
    descriptionMeta: "各医学学会的指南，以清晰、有出处的摘要呈现，保留原始推荐等级，面向医生及医疗卫生专业人员。5 篇免费摘要。",
    ogLocale: "zh_CN",
    allerContenu: "跳至内容",
    navCompte: "账户",
    seConnecter: "登录",
    creerCompte: "创建账户",
    surtitre: "医生及医疗卫生专业人员",
    titre: "专业指南，以清晰、有出处的摘要呈现",
    accroche: "无需重读 100 页的文件，即可在片刻之间查找、理解并核实一条推荐意见。保留推荐等级，官方来源始终一键可达。",
    creerCompteGratuit: "创建我的免费账户",
    dejaCompte: "我已有账户",
    rechercheLibelle: "搜索指南",
    recherchePlaceholder: "例如：脓毒症、区域麻醉……",
    chercher: "搜索",
    voirListe: "查看可用指南列表 →",
    atouts: ["5 篇免费摘要", "无需银行卡", "电脑和手机均可阅读"],
    apercu: {
      surtitre: "SFAR / GIHP — 2026 年指南",
      titre: "抗凝药与侵入性操作",
      methodologie: "方法学",
      version: "版本",
      versionDate: "2026 年 4 月 20 日",
      section: "低出血风险操作 — 无需停药",
      ref: "编号",
      recommandation: "推荐意见",
      grade: "等级",
      lignes: [
        ["2.1", "维生素 K 拮抗剂（VKA）：继续治疗；在操作前一周内检测 INR（确认无过量）。", "2+"],
        [
          "2.2",
          "直接口服抗凝药（DOAC：阿哌沙班、达比加群、依度沙班、利伐沙班）：停用操作前一日晚间剂量及操作当日早晨剂量（无论给药方案如何）；操作后 ≥ 6 小时恢复常规剂量。",
          "2+",
        ],
      ],
      source: "官方原始文件 ↗",
      legende: "摘要节选（译自法文）：每条推荐意见均保留其等级和来源。",
    },
    sourcesAria: "来源",
    sourcesTexte: "以下学会所发布指南的独立摘要：",
    sourcesAutres: "以及其他医学学会",
    recentes: "最新指南",
    toutes: "所有指南 →",
    principesTitre: "每篇摘要包含的内容",
    principes: [
      { titre: "清晰、有条理", texte: "推荐意见按主题以清晰的表格呈现，每条均附有与来源完全一致的推荐等级。" },
      { titre: "始终关联来源", texte: "学会、标题、日期及官方文件链接：摘要绝不替代参考文本。" },
      { titre: "推荐等级不作改动", texte: "推荐等级和证据级别按来源原样转载，或标注为“未注明”。不编造，也不合并。" },
      { titre: "透明", texte: "各学会之间的分歧如实呈现，不作裁定；任何错误均可直接在摘要中报告。" },
    ],
    etapesTitre: "使用方法",
    etapes: [
      ["创建免费账户", "填写姓名、电子邮箱、职业及希望阅读的专科；通过邮件中的链接确认您的地址。"],
      ["解锁 5 篇摘要", "选择 5 篇完整摘要，永久归您所有，无需银行卡。"],
      ["随处阅读", "在电脑、平板或手机上，随时按需阅读。"],
    ],
    offreTitre: "简单的方案",
    gratuit: "免费",
    gratuitPrix: "0 €",
    gratuitPoints: ["自选 5 篇完整摘要，永久归您所有", "无需银行卡", "电脑和手机均可阅读"],
    commencer: "免费开始",
    premium: "Premium",
    premiumPrix: "50 €",
    premiumPeriode: "含税 / 年",
    premiumPoints: [
      "您所在专科的全部摘要",
      "按年付费，可随时取消",
      "前 100 名订阅者首年优惠 30%（创始会员优惠，35 €）",
      "住院医师和学生凭证明优惠 30%（不可叠加）",
    ],
    sabonner: "订阅",
    premiumNote: "您的订阅费用并非用于购买指南，指南仍可在各学会网站免费获取：订阅费用于支付本站的托管、开发人员和人工智能工具。",
    demarche: "我们的理念",
    partenairesTitre: "您代表学会吗？成为我们的合作伙伴",
    partenairesTexte: "免费 PREMIUM 访问、您指南的匿名阅读统计，以及读者对您摘要的错误报告。",
    partenairesBouton: "成为合作伙伴",
    relecteursTitre: "您是医生并愿意帮助校对摘要吗？",
    relecteursTexte: "这些摘要已经过人工智能工具的两轮核查。您可获得本站免费、无限制的访问权限，另有 5 个免费无限制账户供您指定的人使用。",
    relecteursBouton: "成为审校者",
    faqTitre: "常见问题",
    faq: [
      [
        "本站面向哪些人？",
        "面向医生、住院医师和医学生，以及其他医疗卫生专业人员。摘要已涵盖麻醉与重症、重症医学、急诊医学、儿科及其他专科，并在持续扩充；您可在注册时选择希望阅读的专科。",
      ],
      [
        "这些摘要能否替代官方指南？",
        "不能。这些是为便于记忆而撰写的独立摘要，并非由所引学会编辑或认可，不能替代原始文件或临床判断。",
      ],
      [
        "你们出售学会的指南吗？",
        "不。指南仍可在各学会网站免费获取，每篇摘要均链接到官方文本。订阅并非为了从指南中获利：它用于支付本站的运营成本，即托管、开发人员以及协助编写摘要的人工智能工具。本站由志愿者共同建成。",
      ],
      [
        "付费方案包括哪些内容？",
        "PREMIUM 订阅可解锁您所在专科的全部摘要，并在每次更新时发送电子邮件提醒，价格为每年 50 €（含税），可随时取消。首年：前 100 名订阅者优惠 30%（优惠码 FONDATEURS，即 35 €），或在读医疗卫生专业人员凭证明优惠 30%；两种优惠不可叠加。",
      ],
      ["我可以下载或打印摘要吗？", "不可以：摘要只能在电脑和手机上在线阅读。"],
      ["是否涉及患者数据？", "不涉及。本站不处理任何患者健康数据。"],
    ],
    appelTitre: "免费试读 5 篇摘要",
    appelTexte: "一分钟即可创建账户，无需银行卡。",
    aProposAria: "关于本站",
    tagline: "医学及医疗专业指南",
    avertissement: "临床实践辅助工具：这些摘要不能替代临床判断或官方原始文件，并非由所引学会编辑或认可。",
    corrections: "更正记录",
    contact: "联系方式：",
  },
};
