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
  es: {
    entete: {
      accueilAria: "medical-guidelines.net, inicio",
      compte: "Cuenta",
      bibliotheque: "Mi biblioteca",
      seConnecter: "Iniciar sesión",
      creerCompte: "Crear una cuenta",
    },
    ouvrirBibliotheque: "Abrir mi biblioteca",
    creerCompteOffert: "Crear una cuenta gratuita: 5 resúmenes gratuitos",
    accueil: "Inicio",
    recommandations: "Guías",
    catalogue: {
      titreMeta: "Resúmenes independientes de guías de práctica clínica | medical-guidelines.net",
      descriptionMeta:
        "Resúmenes independientes de las guías de las sociedades científicas francesas (SFAR, SRLF, SFMU, HAS…), referenciados, con los grados originales y un enlace a cada texto oficial: anestesiología, medicina intensiva, urgencias, pediatría y otras especialidades.",
      titreOg: "Resúmenes independientes de guías de práctica clínica",
      descriptionOg:
        "Resúmenes referenciados con los grados originales y un enlace a cada texto oficial: anestesiología, medicina intensiva, urgencias, pediatría y otras especialidades.",
      ogLocale: "es_ES",
      surtitre: "Todas las especialidades",
      titre: { one: "{n} guía resumida", other: "{n} guías resumidas" },
      texte:
        "Resúmenes independientes de las guías de las sociedades científicas francesas, de la más reciente a la más antigua. Cada resumen conserva los grados de la fuente y enlaza con el documento oficial, de libre acceso en la web de sus autores; no está editado ni avalado por las sociedades.",
      specialites: "Especialidades",
    },
    recherche: {
      libelle: "Buscar una guía",
      placeholder: "Buscar: sepsis, anestesia locorregional, SRLF, intubación…",
      trouvees: { one: "{n} resumen encontrado", other: "{n} resúmenes encontrados" },
      aucune: "Ningún resumen coincide con esta búsqueda.",
    },
    specialite: {
      introuvable: "Especialidad no encontrada — medical-guidelines.net",
      titreMeta: "Guías de {libelle}: {fiches} | medical-guidelines.net",
      descriptionMeta:
        "Las guías de {libelle} de las sociedades científicas francesas ({societes}…) en resúmenes independientes, referenciados, con los grados originales, de la más reciente a la más antigua.",
      retour: "← Todas las especialidades",
      titre: "Guías de {libelle}",
      texte: {
        one: "{n} guía de las sociedades científicas francesas en resumen independiente",
        other: "{n} guías de las sociedades científicas francesas en resúmenes independientes",
      },
      dontRecentes: { one: ", de ellas {n} publicada desde 2020", other: ", de ellas {n} publicadas desde 2020" },
      texteFin:
        ". Cada resumen conserva los grados de la fuente y enlaza con el documento oficial; no está editado ni avalado por las sociedades.",
    },
    fiche: {
      introuvable: "Resumen no encontrado — medical-guidelines.net",
      retour: "← Todas las guías",
      independante: "Resumen independiente, no editado ni avalado por las sociedades citadas.",
      remplaceeTitre: "Guía sustituida.",
      remplaceeTexte: "La sociedad ha publicado un texto más reciente sobre este tema.",
      remplaceeVoir: "Ver el resumen",
      remplaceeHistorique: "Este resumen sigue disponible por su interés histórico.",
      revisionTitre: "Actualización en curso.",
      revisionTexte:
        "La sociedad ha anunciado una nueva versión de esta guía; el resumen se actualizará en cuanto se publique.",
      champ: "Ámbito de la guía",
      resume: "Resumen",
      pointsCles: "Puntos clave",
      lireTitre: "Leer el resumen completo",
      lireTexte:
        "Recomendaciones detalladas por tema, con sus grados tal como figuran en la fuente. Cuenta gratuita: {quota} resúmenes a su elección, sin tarjeta bancaria.",
      ouvrir: "Abrir el resumen en mi biblioteca",
      creerCompte: "Crear mi cuenta gratuita",
      dejaCompte: "Ya tengo una cuenta",
      sommaire: "Índice del resumen completo",
      autresChapitres: { one: "Y {n} capítulo más.", other: "Y {n} capítulos más." },
      societes: "Sociedades",
      document: "Documento",
      methodologie: "Metodología",
      validation: "Aval",
      accesLibre: "— de libre acceso en la web de la sociedad",
      lienControle: " (enlace comprobado el {date})",
      autres: "Otros resúmenes — {rubrique}",
      voirToutes: "Ver todas las guías",
      avertissement:
        "Resumen independiente: no sustituye al texto completo de la guía oficial ni al juicio clínico, y no está editado ni avalado por las sociedades citadas.",
      demarche: "Nuestro enfoque",
    },
    image: {
      alt: "Resumen de guía — medical-guidelines.net",
      surtitre: "Resumen de guía",
      titre: "Las guías de práctica clínica, en resúmenes claros y referenciados",
      pied: "Resumen de guía, grados conservados",
    },
  },
  de: {
    entete: {
      accueilAria: "medical-guidelines.net, Startseite",
      compte: "Konto",
      bibliotheque: "Meine Bibliothek",
      seConnecter: "Anmelden",
      creerCompte: "Konto erstellen",
    },
    ouvrirBibliotheque: "Meine Bibliothek öffnen",
    creerCompteOffert: "Kostenloses Konto erstellen: 5 kostenlose Zusammenfassungen",
    accueil: "Startseite",
    recommandations: "Leitlinien",
    catalogue: {
      titreMeta: "Unabhängige Zusammenfassungen klinischer Leitlinien | medical-guidelines.net",
      descriptionMeta:
        "Unabhängige Zusammenfassungen der Leitlinien französischer Fachgesellschaften (SFAR, SRLF, SFMU, HAS…), belegt, mit den ursprünglichen Empfehlungsgraden und einem Link zu jedem offiziellen Text: Anästhesiologie, Intensivmedizin, Notfallmedizin, Pädiatrie und weitere Fachgebiete.",
      titreOg: "Unabhängige Zusammenfassungen klinischer Leitlinien",
      descriptionOg:
        "Belegte Zusammenfassungen mit den ursprünglichen Empfehlungsgraden und einem Link zu jedem offiziellen Text: Anästhesiologie, Intensivmedizin, Notfallmedizin, Pädiatrie und weitere Fachgebiete.",
      ogLocale: "de_DE",
      surtitre: "Alle Fachgebiete",
      titre: { one: "{n} zusammengefasste Leitlinie", other: "{n} zusammengefasste Leitlinien" },
      texte:
        "Unabhängige Zusammenfassungen der Leitlinien französischer Fachgesellschaften, von der neuesten bis zur ältesten. Jede Zusammenfassung übernimmt die Empfehlungsgrade der Quelle und verlinkt auf das offizielle Dokument, das bei seinen Autoren frei zugänglich ist; sie wird von den Fachgesellschaften weder herausgegeben noch gebilligt.",
      specialites: "Fachgebiete",
    },
    recherche: {
      libelle: "Leitlinie suchen",
      placeholder: "Suche: Sepsis, Regionalanästhesie, SRLF, Intubation…",
      trouvees: { one: "{n} Zusammenfassung gefunden", other: "{n} Zusammenfassungen gefunden" },
      aucune: "Keine Zusammenfassung entspricht dieser Suche.",
    },
    specialite: {
      introuvable: "Fachgebiet nicht gefunden — medical-guidelines.net",
      titreMeta: "Leitlinien – {libelle}: {fiches} | medical-guidelines.net",
      descriptionMeta:
        "Leitlinien französischer Fachgesellschaften ({societes}…) zum Fachgebiet {libelle} als unabhängige, belegte Zusammenfassungen mit den ursprünglichen Empfehlungsgraden, von der neuesten bis zur ältesten.",
      retour: "← Alle Fachgebiete",
      titre: "Leitlinien – {libelle}",
      texte: {
        one: "{n} Leitlinie französischer Fachgesellschaften als unabhängige Zusammenfassung",
        other: "{n} Leitlinien französischer Fachgesellschaften als unabhängige Zusammenfassungen",
      },
      dontRecentes: { one: ", davon {n} seit 2020 veröffentlicht", other: ", davon {n} seit 2020 veröffentlicht" },
      texteFin:
        ". Jede Zusammenfassung übernimmt die Empfehlungsgrade der Quelle und verlinkt auf das offizielle Dokument; sie wird von den Fachgesellschaften weder herausgegeben noch gebilligt.",
    },
    fiche: {
      introuvable: "Zusammenfassung nicht gefunden — medical-guidelines.net",
      retour: "← Alle Leitlinien",
      independante: "Unabhängige Zusammenfassung, von den genannten Fachgesellschaften weder herausgegeben noch gebilligt.",
      remplaceeTitre: "Ersetzte Leitlinie.",
      remplaceeTexte: "Die Fachgesellschaft hat zu diesem Thema einen neueren Text veröffentlicht.",
      remplaceeVoir: "Zur Zusammenfassung",
      remplaceeHistorique: "Diese Zusammenfassung bleibt aus historischem Interesse verfügbar.",
      revisionTitre: "Aktualisierung in Arbeit.",
      revisionTexte:
        "Die Fachgesellschaft hat eine neue Fassung dieser Leitlinie angekündigt; die Zusammenfassung wird aktualisiert, sobald sie erscheint.",
      champ: "Geltungsbereich der Leitlinie",
      resume: "Zusammenfassung",
      pointsCles: "Kernaussagen",
      lireTitre: "Vollständige Zusammenfassung lesen",
      lireTexte:
        "Detaillierte Empfehlungen nach Themen, mit ihren Empfehlungsgraden wie in der Quelle. Kostenloses Konto: {quota} Zusammenfassungen Ihrer Wahl, ohne Kreditkarte.",
      ouvrir: "Zusammenfassung in meiner Bibliothek öffnen",
      creerCompte: "Mein kostenloses Konto erstellen",
      dejaCompte: "Ich habe bereits ein Konto",
      sommaire: "Inhalt der vollständigen Zusammenfassung",
      autresChapitres: { one: "Und {n} weiteres Kapitel.", other: "Und {n} weitere Kapitel." },
      societes: "Fachgesellschaften",
      document: "Dokument",
      methodologie: "Methodik",
      validation: "Billigung",
      accesLibre: "— frei zugänglich auf der Website der Fachgesellschaft",
      lienControle: " (Link geprüft am {date})",
      autres: "Weitere Zusammenfassungen — {rubrique}",
      voirToutes: "Alle Leitlinien ansehen",
      avertissement:
        "Unabhängige Zusammenfassung: Sie ersetzt weder den vollständigen Text der offiziellen Leitlinie noch das klinische Urteil und wird von den genannten Fachgesellschaften weder herausgegeben noch gebilligt.",
      demarche: "Unser Ansatz",
    },
    image: {
      alt: "Leitlinien-Zusammenfassung — medical-guidelines.net",
      surtitre: "Leitlinien-Zusammenfassung",
      titre: "Klinische Leitlinien in klaren, belegten Zusammenfassungen",
      pied: "Leitlinien-Zusammenfassung, Empfehlungsgrade erhalten",
    },
  },
  ar: {
    entete: {
      accueilAria: "medical-guidelines.net، الصفحة الرئيسية",
      compte: "الحساب",
      bibliotheque: "مكتبتي",
      seConnecter: "تسجيل الدخول",
      creerCompte: "إنشاء حساب",
    },
    ouvrirBibliotheque: "فتح مكتبتي",
    creerCompteOffert: "أنشئ حسابًا مجانيًا: 5 ملخصات مجانية",
    accueil: "الصفحة الرئيسية",
    recommandations: "التوصيات",
    catalogue: {
      titreMeta: "ملخصات مستقلة للتوصيات المهنية | medical-guidelines.net",
      descriptionMeta:
        "ملخصات مستقلة لتوصيات الجمعيات العلمية الفرنسية (SFAR وSRLF وSFMU وHAS…)، موثّقة، مع درجات التوصية الأصلية ورابط إلى كل نص رسمي: التخدير والإنعاش، والعناية المركزة، وطب الطوارئ، وطب الأطفال، وتخصصات أخرى.",
      titreOg: "ملخصات مستقلة للتوصيات المهنية",
      descriptionOg:
        "ملخصات موثّقة مع درجات التوصية الأصلية ورابط إلى كل نص رسمي: التخدير والإنعاش، والعناية المركزة، وطب الطوارئ، وطب الأطفال، وتخصصات أخرى.",
      ogLocale: "ar_AR",
      surtitre: "جميع التخصصات",
      titre: {
        zero: "لا توجد توصيات ملخّصة",
        one: "توصية واحدة ملخّصة",
        two: "توصيتان ملخّصتان",
        few: "{n} توصيات ملخّصة",
        many: "{n} توصيةً ملخّصة",
        other: "{n} توصية ملخّصة",
      },
      texte:
        "ملخصات مستقلة لتوصيات الجمعيات العلمية الفرنسية، من الأحدث إلى الأقدم. يحتفظ كل ملخص بدرجات التوصية الواردة في المصدر ويحيل إلى الوثيقة الرسمية المتاحة مجانًا لدى مؤلفيها؛ وهو ليس من إصدار الجمعيات ولا معتمدًا منها.",
      specialites: "التخصصات",
    },
    recherche: {
      libelle: "البحث عن توصية",
      placeholder: "ابحث: الإنتان، التخدير الموضعي الناحي، SRLF، التنبيب…",
      trouvees: {
        zero: "لم يُعثر على أي ملخص",
        one: "عُثر على ملخص واحد",
        two: "عُثر على ملخصين",
        few: "عُثر على {n} ملخصات",
        many: "عُثر على {n} ملخصًا",
        other: "عُثر على {n} ملخص",
      },
      aucune: "لا يوجد ملخص يطابق هذا البحث.",
    },
    specialite: {
      introuvable: "التخصص غير موجود — medical-guidelines.net",
      titreMeta: "توصيات {libelle}: {fiches} | medical-guidelines.net",
      descriptionMeta:
        "توصيات الجمعيات العلمية الفرنسية ({societes}…) في {libelle} على شكل ملخصات مستقلة وموثّقة مع درجات التوصية الأصلية، من الأحدث إلى الأقدم.",
      retour: "→ جميع التخصصات",
      titre: "توصيات {libelle}",
      texte: {
        zero: "لا توجد توصيات من الجمعيات العلمية الفرنسية في ملخصات مستقلة",
        one: "توصية واحدة من الجمعيات العلمية الفرنسية في ملخص مستقل",
        two: "توصيتان من الجمعيات العلمية الفرنسية في ملخصين مستقلين",
        few: "{n} توصيات من الجمعيات العلمية الفرنسية في ملخصات مستقلة",
        many: "{n} توصيةً من الجمعيات العلمية الفرنسية في ملخصات مستقلة",
        other: "{n} توصية من الجمعيات العلمية الفرنسية في ملخصات مستقلة",
      },
      dontRecentes: { other: "، منها {n} منشورة منذ 2020" },
      texteFin:
        ". يحتفظ كل ملخص بدرجات التوصية الواردة في المصدر ويحيل إلى الوثيقة الرسمية؛ وهو ليس من إصدار الجمعيات ولا معتمدًا منها.",
    },
    fiche: {
      introuvable: "الملخص غير موجود — medical-guidelines.net",
      retour: "→ جميع التوصيات",
      independante: "ملخص مستقل، ليس من إصدار الجمعيات المذكورة ولا معتمدًا منها.",
      remplaceeTitre: "توصية مستبدلة.",
      remplaceeTexte: "نشرت الجمعية نصًا أحدث حول هذا الموضوع.",
      remplaceeVoir: "عرض الملخص",
      remplaceeHistorique: "يبقى هذا الملخص متاحًا لقيمته التاريخية.",
      revisionTitre: "قيد التحديث.",
      revisionTexte: "أعلنت الجمعية عن نسخة جديدة من هذه التوصية؛ وسيُحدَّث الملخص فور نشرها.",
      champ: "نطاق التوصية",
      resume: "الملخص",
      pointsCles: "النقاط الرئيسية",
      lireTitre: "قراءة الملخص الكامل",
      lireTexte:
        "توصيات مفصّلة حسب الموضوع، مع درجاتها كما وردت في المصدر. حساب مجاني: {quota} ملخصات من اختيارك، دون بطاقة مصرفية.",
      ouvrir: "فتح الملخص في مكتبتي",
      creerCompte: "إنشاء حسابي المجاني",
      dejaCompte: "لديّ حساب بالفعل",
      sommaire: "محتويات الملخص الكامل",
      autresChapitres: {
        one: "وفصل آخر.",
        two: "وفصلان آخران.",
        few: "و{n} فصول أخرى.",
        many: "و{n} فصلًا آخر.",
        other: "و{n} فصل آخر.",
      },
      societes: "الجمعيات",
      document: "الوثيقة",
      methodologie: "المنهجية",
      validation: "الاعتماد",
      accesLibre: "— متاحة مجانًا على موقع الجمعية",
      lienControle: " (تم التحقق من الرابط في {date})",
      autres: "ملخصات أخرى — {rubrique}",
      voirToutes: "عرض جميع التوصيات",
      avertissement:
        "ملخص مستقل: لا يغني عن النص الكامل للتوصية الرسمية ولا عن التقدير السريري، وليس من إصدار الجمعيات المذكورة ولا معتمدًا منها.",
      demarche: "نهجنا",
    },
    image: {
      alt: "ملخص توصية — medical-guidelines.net",
      surtitre: "ملخص توصية",
      titre: "التوصيات المهنية في ملخصات واضحة وموثّقة",
      pied: "ملخص توصية، الدرجات محفوظة",
    },
  },
  zh: {
    entete: {
      accueilAria: "medical-guidelines.net，首页",
      compte: "账户",
      bibliotheque: "我的资料库",
      seConnecter: "登录",
      creerCompte: "创建账户",
    },
    ouvrirBibliotheque: "打开我的资料库",
    creerCompteOffert: "创建免费账户：5 篇免费摘要",
    accueil: "首页",
    recommandations: "指南",
    catalogue: {
      titreMeta: "临床指南独立摘要 | medical-guidelines.net",
      descriptionMeta:
        "法国各医学学会（SFAR、SRLF、SFMU、HAS……）指南的独立摘要，有据可查，保留原始推荐等级，并链接到每份官方文本：麻醉与重症、重症医学、急诊医学、儿科及其他专科。",
      titreOg: "临床指南独立摘要",
      descriptionOg: "有据可查的摘要，保留原始推荐等级，并链接到每份官方文本：麻醉与重症、重症医学、急诊医学、儿科及其他专科。",
      ogLocale: "zh_CN",
      surtitre: "所有专科",
      titre: { other: "已摘要 {n} 份指南" },
      texte:
        "法国各医学学会指南的独立摘要，按从新到旧排列。每篇摘要保留来源中的推荐等级，并链接到其作者免费公开的官方文件；摘要并非由各学会编辑或认可。",
      specialites: "专科",
    },
    recherche: {
      libelle: "搜索指南",
      placeholder: "搜索：脓毒症、区域麻醉、SRLF、气管插管……",
      trouvees: { other: "找到 {n} 篇摘要" },
      aucune: "没有与此搜索匹配的摘要。",
    },
    specialite: {
      introuvable: "未找到该专科 — medical-guidelines.net",
      titreMeta: "{libelle}指南：{fiches} | medical-guidelines.net",
      descriptionMeta: "法国各医学学会（{societes}……）的{libelle}指南独立摘要，有据可查，保留原始推荐等级，按从新到旧排列。",
      retour: "← 所有专科",
      titre: "{libelle}指南",
      texte: { other: "法国各医学学会的 {n} 份指南，以独立摘要呈现" },
      dontRecentes: { other: "，其中 {n} 份发布于 2020 年以后" },
      texteFin: "。每篇摘要保留来源中的推荐等级，并链接到官方文件；摘要并非由各学会编辑或认可。",
    },
    fiche: {
      introuvable: "未找到摘要 — medical-guidelines.net",
      retour: "← 所有指南",
      independante: "独立摘要，并非由所引学会编辑或认可。",
      remplaceeTitre: "该指南已被取代。",
      remplaceeTexte: "该学会已就此主题发布了更新的文本。",
      remplaceeVoir: "查看摘要",
      remplaceeHistorique: "本摘要因其历史参考价值而继续保留。",
      revisionTitre: "更新中。",
      revisionTexte: "该学会已宣布将发布本指南的新版本；新版本一经发布，摘要即会更新。",
      champ: "指南范围",
      resume: "摘要",
      pointsCles: "要点",
      lireTitre: "阅读完整摘要",
      lireTexte: "按主题详细列出的推荐意见，推荐等级与来源一致。免费账户：可自选 {quota} 篇摘要，无需银行卡。",
      ouvrir: "在我的资料库中打开摘要",
      creerCompte: "创建我的免费账户",
      dejaCompte: "我已有账户",
      sommaire: "完整摘要目录",
      autresChapitres: { other: "另有 {n} 章。" },
      societes: "学会",
      document: "文件",
      methodologie: "方法学",
      validation: "认可",
      accesLibre: "— 可在学会网站免费获取",
      lienControle: "（链接核实于 {date}）",
      autres: "其他摘要 — {rubrique}",
      voirToutes: "查看所有指南",
      avertissement: "独立摘要：不能替代官方指南全文或临床判断，并非由所引学会编辑或认可。",
      demarche: "我们的理念",
    },
    image: {
      alt: "指南摘要 — medical-guidelines.net",
      surtitre: "指南摘要",
      titre: "专业指南，以清晰、有出处的摘要呈现",
      pied: "指南摘要，保留推荐等级",
    },
  },
};
