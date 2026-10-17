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
  es: {
    titreMeta: "medical-guidelines.net — Guías médicas y paramédicas, resumidas",
    messages: {
      suivi: "Sociedad seguida: recibirá un correo por cada nueva guía que publique en su especialidad.",
      suivi_retire: "Ya no sigue a esta sociedad.",
      suivi_erreur: "No se ha podido guardar el seguimiento. Vuelva a intentarlo en un momento.",
    },
    navCompte: "Cuenta",
    bibliotheque: "Biblioteca",
    monCompte: "Mi cuenta",
    bienvenue: "Bienvenido/a",
    specialiteConsultee: "especialidad: {specialite}",
    rechercheLibelle: "Buscar un resumen",
    recherchePlaceholder: "Buscar una guía (sepsis, ACOD, intubación…)",
    rechercher: "Buscar",
    statFiches: { one: "resumen disponible", other: "resúmenes disponibles" },
    statNouveautes: { one: "novedad de {annee}", other: "novedades de {annee}" },
    statSocietes: { one: "sociedad científica", other: "sociedades científicas" },
    relecteur: "Cuenta de revisor: la biblioteca y esta página muestran también los borradores, con el botón de publicación.",
    nouveautes: "Novedades de {annee}",
    dernieres: "Últimas guías",
    nouveautesTexte: "Guías publicadas en {annee} por las sociedades científicas de su especialidad.",
    dernieresTexte: "Todavía no hay ninguna guía publicada en {annee} para su especialidad: estas son las más recientes.",
    toute: "Toda la biblioteca →",
    filtrer: "Filtrar las novedades de {annee} por sociedad",
    toutes: "Todas",
    autresSocietes: { one: "+ {n} sociedad más", other: "+ {n} sociedades más" },
    moinsSocietes: "Menos sociedades",
    aucuneFiche:
      "Todavía no se ha publicado ningún resumen para su especialidad. Aparecerán aquí a medida que nuestro equipo médico los valide.",
    voirNouveautes: "Ver las {n} novedades de {annee}{societe} en la biblioteca →",
    populaires: "Lo más leído en su especialidad",
    populairesPremium: "Los resúmenes más leídos por los miembros en los últimos tres meses.",
    populairesCredits:
      "Los resúmenes más leídos por los miembros en los últimos tres meses: para ayudarle a elegir cuáles desbloquear con sus créditos.",
    favoris: "★ Mis favoritos",
    ficheBloquee: "Resumen bloqueado",
    favorisVide:
      "Añada un resumen a sus favoritos con el botón «☆ Añadir a favoritos» de su página: aparecerá aquí y en la biblioteca.",
    tousFavoris: "Todos mis favoritos en la biblioteca →",
    reprendre: "Seguir leyendo",
    reprendreVide: "Los resúmenes que abra aparecerán aquí para volver a ellos con un clic.",
    societesTitre: "Sociedades científicas de su especialidad",
    societesTexte: "Número de resúmenes cofirmados en la biblioteca.",
    societeSuivie: " 🔔: sociedad seguida.",
    suivie: "seguida",
    autresDansBibliotheque: { one: "Y {n} más en la biblioteca →", other: "Y {n} más en la biblioteca →" },
    alertesTitre: "Alertas por correo",
    alertesTexte:
      "Como máximo un correo al día, cuando una sociedad que sigue publica una guía en su especialidad o cuando se actualiza uno de sus resúmenes.",
    alertesDesactivees: "Sus alertas por correo están desactivadas: <compte>vuelva a activarlas en Mi cuenta</compte>.",
    suiviesAria: "Sociedades seguidas",
    nePlusSuivre: "Dejar de seguir a {societe}",
    nePlusSuivreCourt: "dejar de seguir",
    societeASuivre: "Sociedad que seguir",
    suivreUne: "Seguir una sociedad…",
    suivre: "Seguir",
    alertesPremium:
      "Siga las sociedades que elija y reciba un correo por cada nueva guía y por cada actualización de sus resúmenes: incluido en <abonnement>la suscripción PREMIUM</abonnement>.",
    majTitre: "Sus resúmenes se han actualizado",
    majTexte: "Resúmenes que ha desbloqueado, añadido a favoritos o leído.",
    majRetiree: "Guía retirada por la sociedad: el resumen ya no se puede consultar.",
    majRemplacee: "Guía sustituida por un texto más reciente.",
    majRevision: "Nueva versión de la fuente detectada: resumen en revisión.",
    majVersion: "Versión {version}",
    majModification: "Cambio {type}",
    majPubliee: "publicada el {date}",
    majDefaut: "Actualización",
    nouvelleFiche: "Nuevo resumen: {titre} →",
    premiumTitre: "Suscripción PREMIUM activa",
    premiumTexte: "Todos los resúmenes de su especialidad están desbloqueados",
    premiumJusquau: ", hasta el {date}.",
    premiumRenouvellement: "; se renueva el {date}.",
    gerer: "Gestionar mi suscripción →",
    assistantTitre: "Asistente de búsqueda (beta)",
    assistantTexte:
      "Haga una pregunta con sus propias palabras: el asistente encuentra los pasajes exactos de los resúmenes que la responden, sin dar consejo médico.",
    assistantLien: "Hacer una pregunta →",
    creditsTitre: "Mis créditos",
    creditsRestants: { one: "Le queda {n} crédito", other: "Le quedan {n} créditos" },
    creditsSur: "de {quota}. Un crédito desbloquea un resumen para siempre.",
    debloquees: "Mis resúmenes desbloqueados",
    passerPremium: "Pasar a PREMIUM · 50 € / año",
    aujourdhui: "hoy",
    hier: "ayer",
    ilYa: "hace {n} d",
  },
  de: {
    titreMeta: "medical-guidelines.net — Ärztliche und gesundheitsfachliche Leitlinien, zusammengefasst",
    messages: {
      suivi: "Fachgesellschaft abonniert: Sie erhalten eine E-Mail zu jeder neuen Leitlinie, die sie in Ihrem Fachgebiet veröffentlicht.",
      suivi_retire: "Sie folgen dieser Fachgesellschaft nicht mehr.",
      suivi_erreur: "Das Folgen konnte nicht gespeichert werden. Bitte versuchen Sie es gleich noch einmal.",
    },
    navCompte: "Konto",
    bibliotheque: "Bibliothek",
    monCompte: "Mein Konto",
    bienvenue: "Willkommen",
    specialiteConsultee: "Fachgebiet: {specialite}",
    rechercheLibelle: "Zusammenfassung suchen",
    recherchePlaceholder: "Leitlinie suchen (Sepsis, DOAK, Intubation…)",
    rechercher: "Suchen",
    statFiches: { one: "verfügbare Zusammenfassung", other: "verfügbare Zusammenfassungen" },
    statNouveautes: { one: "Neuerscheinung {annee}", other: "Neuerscheinungen {annee}" },
    statSocietes: { one: "Fachgesellschaft", other: "Fachgesellschaften" },
    relecteur: "Gutachterkonto: Die Bibliothek und diese Seite zeigen auch Entwürfe, mit der Schaltfläche zum Veröffentlichen.",
    nouveautes: "Neuerscheinungen {annee}",
    dernieres: "Neueste Leitlinien",
    nouveautesTexte: "Leitlinien, die {annee} von den Fachgesellschaften Ihres Fachgebiets veröffentlicht wurden.",
    dernieresTexte: "Für Ihr Fachgebiet wurde {annee} noch keine Leitlinie veröffentlicht: Hier sind die neuesten.",
    toute: "Gesamte Bibliothek →",
    filtrer: "Neuerscheinungen {annee} nach Fachgesellschaft filtern",
    toutes: "Alle",
    autresSocietes: { one: "+ {n} weitere Fachgesellschaft", other: "+ {n} weitere Fachgesellschaften" },
    moinsSocietes: "Weniger Fachgesellschaften",
    aucuneFiche:
      "Für Ihr Fachgebiet wurde noch keine Zusammenfassung veröffentlicht. Sie erscheinen hier, sobald unser ärztliches Team sie freigibt.",
    voirNouveautes: "Die {n} Neuerscheinungen {annee}{societe} in der Bibliothek ansehen →",
    populaires: "Meistgelesen in Ihrem Fachgebiet",
    populairesPremium: "Die von Mitgliedern in den letzten drei Monaten meistgelesenen Zusammenfassungen.",
    populairesCredits:
      "Die von Mitgliedern in den letzten drei Monaten meistgelesenen Zusammenfassungen: als Hilfe bei der Wahl, welche Sie mit Ihren Guthaben freischalten.",
    favoris: "★ Meine Favoriten",
    ficheBloquee: "Gesperrte Zusammenfassung",
    favorisVide:
      "Fügen Sie eine Zusammenfassung mit der Schaltfläche „☆ Zu Favoriten hinzufügen“ auf ihrer Seite zu Ihren Favoriten hinzu: Sie erscheint dann hier und in der Bibliothek.",
    tousFavoris: "Alle meine Favoriten in der Bibliothek →",
    reprendre: "Weiterlesen",
    reprendreVide: "Die Zusammenfassungen, die Sie öffnen, erscheinen hier, damit Sie mit einem Klick zu ihnen zurückkehren können.",
    societesTitre: "Fachgesellschaften Ihres Fachgebiets",
    societesTexte: "Anzahl der mitunterzeichneten Zusammenfassungen in der Bibliothek.",
    societeSuivie: " 🔔: Fachgesellschaft abonniert.",
    suivie: "abonniert",
    autresDansBibliotheque: { one: "Und {n} weitere in der Bibliothek →", other: "Und {n} weitere in der Bibliothek →" },
    alertesTitre: "E-Mail-Benachrichtigungen",
    alertesTexte:
      "Höchstens eine E-Mail pro Tag, wenn eine Fachgesellschaft, der Sie folgen, eine Leitlinie in Ihrem Fachgebiet veröffentlicht oder eine Ihrer Zusammenfassungen aktualisiert wird.",
    alertesDesactivees: "Ihre E-Mail-Benachrichtigungen sind deaktiviert: <compte>unter Mein Konto wieder aktivieren</compte>.",
    suiviesAria: "Abonnierte Fachgesellschaften",
    nePlusSuivre: "{societe} nicht mehr folgen",
    nePlusSuivreCourt: "nicht mehr folgen",
    societeASuivre: "Fachgesellschaft zum Folgen",
    suivreUne: "Einer Fachgesellschaft folgen…",
    suivre: "Folgen",
    alertesPremium:
      "Folgen Sie den Fachgesellschaften Ihrer Wahl und erhalten Sie eine E-Mail zu jeder neuen Leitlinie und zu jeder Aktualisierung Ihrer Zusammenfassungen: enthalten im <abonnement>PREMIUM-Abonnement</abonnement>.",
    majTitre: "Ihre Zusammenfassungen wurden aktualisiert",
    majTexte: "Zusammenfassungen, die Sie freigeschaltet, zu Favoriten hinzugefügt oder gelesen haben.",
    majRetiree: "Leitlinie von der Fachgesellschaft zurückgezogen: Die Zusammenfassung kann nicht mehr gelesen werden.",
    majRemplacee: "Leitlinie durch einen neueren Text ersetzt.",
    majRevision: "Neue Version der Quelle erkannt: Zusammenfassung wird überarbeitet.",
    majVersion: "Version {version}",
    majModification: "Änderung ({type})",
    majPubliee: "veröffentlicht am {date}",
    majDefaut: "Aktualisierung",
    nouvelleFiche: "Neue Zusammenfassung: {titre} →",
    premiumTitre: "PREMIUM-Abonnement aktiv",
    premiumTexte: "Alle Zusammenfassungen Ihres Fachgebiets sind freigeschaltet",
    premiumJusquau: ", bis zum {date}.",
    premiumRenouvellement: "; Verlängerung am {date}.",
    gerer: "Mein Abonnement verwalten →",
    assistantTitre: "Suchassistent (Beta)",
    assistantTexte:
      "Stellen Sie eine Frage in Ihren eigenen Worten: Der Assistent findet die genauen Passagen der Zusammenfassungen, die sie beantworten, ohne ärztlichen Rat.",
    assistantLien: "Eine Frage stellen →",
    creditsTitre: "Mein Guthaben",
    creditsRestants: { one: "Noch {n} Guthaben", other: "Noch {n} Guthaben" },
    creditsSur: "von {quota}. Ein Guthaben schaltet eine Zusammenfassung dauerhaft frei.",
    debloquees: "Meine freigeschalteten Zusammenfassungen",
    passerPremium: "Zu PREMIUM wechseln · 50 € / Jahr",
    aujourdhui: "heute",
    hier: "gestern",
    ilYa: "vor {n} T.",
  },
  ar: {
    titreMeta: "medical-guidelines.net — التوصيات الطبية وتوصيات المهن الصحية، ملخّصة",
    messages: {
      suivi: "أصبحت تتابع هذه الجمعية: ستتلقى رسالة بالبريد الإلكتروني عن كل توصية جديدة تنشرها في تخصصك.",
      suivi_retire: "لم تعد تتابع هذه الجمعية.",
      suivi_erreur: "تعذّر حفظ المتابعة. أعد المحاولة بعد قليل.",
    },
    navCompte: "الحساب",
    bibliotheque: "المكتبة",
    monCompte: "حسابي",
    bienvenue: "مرحبًا",
    specialiteConsultee: "التخصص: {specialite}",
    rechercheLibelle: "البحث عن ملخص",
    recherchePlaceholder: "ابحث عن توصية (الإنتان، مضادات التخثر الفموية المباشرة، التنبيب…)",
    rechercher: "بحث",
    statFiches: {
      zero: "ملخص متاح",
      one: "ملخص متاح",
      two: "ملخصان متاحان",
      few: "ملخصات متاحة",
      many: "ملخصًا متاحًا",
      other: "ملخص متاح",
    },
    statNouveautes: { one: "جديد {annee}", other: "جديد {annee}" },
    statSocietes: {
      zero: "جمعية علمية",
      one: "جمعية علمية",
      two: "جمعيتان علميتان",
      few: "جمعيات علمية",
      many: "جمعيةً علمية",
      other: "جمعية علمية",
    },
    relecteur: "حساب مراجع: تعرض المكتبة وهذه الصفحة أيضًا المسودات، مع زر النشر.",
    nouveautes: "جديد {annee}",
    dernieres: "أحدث التوصيات",
    nouveautesTexte: "التوصيات التي نشرتها الجمعيات العلمية في تخصصك عام {annee}.",
    dernieresTexte: "لم تُنشر بعد أي توصية عام {annee} في تخصصك: إليك أحدث التوصيات.",
    toute: "المكتبة كاملة ←",
    filtrer: "تصفية جديد {annee} حسب الجمعية",
    toutes: "الكل",
    autresSocietes: {
      one: "+ جمعية أخرى",
      two: "+ جمعيتان أخريان",
      few: "+ {n} جمعيات أخرى",
      many: "+ {n} جمعيةً أخرى",
      other: "+ {n} جمعية أخرى",
    },
    moinsSocietes: "جمعيات أقل",
    aucuneFiche: "لم يُنشر بعد أي ملخص في تخصصك. ستظهر الملخصات هنا تباعًا كلما اعتمدها فريقنا الطبي.",
    voirNouveautes: "عرض جديد {annee}{societe} ({n}) في المكتبة ←",
    populaires: "الأكثر قراءة في تخصصك",
    populairesPremium: "الملخصات الأكثر قراءة لدى الأعضاء خلال الأشهر الثلاثة الأخيرة.",
    populairesCredits:
      "الملخصات الأكثر قراءة لدى الأعضاء خلال الأشهر الثلاثة الأخيرة: لمساعدتك على اختيار ما تفتحه بأرصدتك.",
    favoris: "★ مفضلتي",
    ficheBloquee: "ملخص مقفل",
    favorisVide: "أضف ملخصًا إلى مفضلتك بزر «☆ إضافة إلى المفضلة» في صفحته: سيظهر هنا وفي المكتبة.",
    tousFavoris: "كل مفضلتي في المكتبة ←",
    reprendre: "متابعة القراءة",
    reprendreVide: "ستظهر هنا الملخصات التي تفتحها، لتعود إليها بنقرة واحدة.",
    societesTitre: "الجمعيات العلمية في تخصصك",
    societesTexte: "عدد الملخصات المشتركة التوقيع في المكتبة.",
    societeSuivie: " 🔔: جمعية متابَعة.",
    suivie: "متابَعة",
    autresDansBibliotheque: { other: "و{n} غيرها في المكتبة ←" },
    alertesTitre: "التنبيهات بالبريد الإلكتروني",
    alertesTexte:
      "رسالة واحدة يوميًا على الأكثر، عندما تنشر جمعية تتابعها توصية في تخصصك أو عند تحديث أحد ملخصاتك.",
    alertesDesactivees: "تنبيهاتك بالبريد الإلكتروني معطّلة: <compte>أعد تفعيلها من صفحة حسابي</compte>.",
    suiviesAria: "الجمعيات المتابَعة",
    nePlusSuivre: "إلغاء متابعة {societe}",
    nePlusSuivreCourt: "إلغاء المتابعة",
    societeASuivre: "جمعية للمتابعة",
    suivreUne: "متابعة جمعية…",
    suivre: "متابعة",
    alertesPremium:
      "تابع الجمعيات التي تختارها واحصل على رسالة بالبريد الإلكتروني عن كل توصية جديدة وعن كل تحديث لملخصاتك: ميزة مشمولة في <abonnement>اشتراك PREMIUM</abonnement>.",
    majTitre: "تم تحديث ملخصاتك",
    majTexte: "الملخصات التي فتحتها أو أضفتها إلى المفضلة أو قرأتها.",
    majRetiree: "سحبت الجمعية التوصية: لم يعد بالإمكان قراءة الملخص.",
    majRemplacee: "استُبدلت التوصية بنص أحدث.",
    majRevision: "رُصدت نسخة جديدة من المصدر: الملخص قيد المراجعة.",
    majVersion: "الإصدار {version}",
    majModification: "تعديل {type}",
    majPubliee: "نُشر في {date}",
    majDefaut: "تحديث",
    nouvelleFiche: "ملخص جديد: {titre} ←",
    premiumTitre: "اشتراك PREMIUM مفعّل",
    premiumTexte: "جميع ملخصات تخصصك مفتوحة",
    premiumJusquau: "، حتى {date}.",
    premiumRenouvellement: "؛ يتجدد في {date}.",
    gerer: "إدارة اشتراكي ←",
    assistantTitre: "مساعد البحث (تجريبي)",
    assistantTexte: "اطرح سؤالًا بكلماتك: يعثر المساعد على المقاطع الدقيقة من الملخصات التي تجيب عنه، دون تقديم نصيحة طبية.",
    assistantLien: "اطرح سؤالًا ←",
    creditsTitre: "أرصدتي",
    creditsRestants: {
      zero: "لم يتبقَّ لك أي رصيد",
      one: "يتبقى لك رصيد واحد",
      two: "يتبقى لك رصيدان",
      few: "يتبقى لك {n} أرصدة",
      many: "يتبقى لك {n} رصيدًا",
      other: "يتبقى لك {n} رصيد",
    },
    creditsSur: "من أصل {quota}. يفتح كل رصيد ملخصًا واحدًا بصفة دائمة.",
    debloquees: "ملخصاتي المفتوحة",
    passerPremium: "الانتقال إلى PREMIUM · 50 € / سنة",
    aujourdhui: "اليوم",
    hier: "أمس",
    ilYa: "منذ {n} أيام",
  },
  zh: {
    titreMeta: "medical-guidelines.net — 医学及医疗专业指南摘要",
    messages: {
      suivi: "已关注该学会：该学会在您的专科每发布一份新指南，您都会收到一封电子邮件。",
      suivi_retire: "您已不再关注该学会。",
      suivi_erreur: "关注未能保存。请稍后重试。",
    },
    navCompte: "账户",
    bibliotheque: "资料库",
    monCompte: "我的账户",
    bienvenue: "欢迎",
    specialiteConsultee: "专科：{specialite}",
    rechercheLibelle: "搜索摘要",
    recherchePlaceholder: "搜索指南（脓毒症、DOAC、气管插管……）",
    rechercher: "搜索",
    statFiches: { other: "篇可用摘要" },
    statNouveautes: { other: "{annee} 年新指南" },
    statSocietes: { other: "个医学学会" },
    relecteur: "审校者账户：资料库和本页面也会显示草稿，并附有发布按钮。",
    nouveautes: "{annee} 年新指南",
    dernieres: "最新指南",
    nouveautesTexte: "您所在专科的医学学会于 {annee} 年发布的指南。",
    dernieresTexte: "{annee} 年您的专科尚未发布任何指南：以下是最新的指南。",
    toute: "全部资料库 →",
    filtrer: "按学会筛选 {annee} 年新指南",
    toutes: "全部",
    autresSocietes: { other: "+ 另外 {n} 个学会" },
    moinsSocietes: "收起学会",
    aucuneFiche: "您的专科尚未发布任何摘要。我们的医疗团队审核通过后，摘要将陆续显示在这里。",
    voirNouveautes: "在资料库中查看 {n} 份 {annee} 年{societe}新指南 →",
    populaires: "您所在专科阅读最多的摘要",
    populairesPremium: "过去三个月会员阅读最多的摘要。",
    populairesCredits: "过去三个月会员阅读最多的摘要：帮助您选择用点数解锁哪些摘要。",
    favoris: "★ 我的收藏",
    ficheBloquee: "未解锁的摘要",
    favorisVide: "在摘要页面点击“☆ 加入收藏”按钮即可收藏：它将显示在这里和资料库中。",
    tousFavoris: "资料库中的全部收藏 →",
    reprendre: "继续阅读",
    reprendreVide: "您打开过的摘要将显示在这里，一键即可返回。",
    societesTitre: "您所在专科的医学学会",
    societesTexte: "资料库中联合署名的摘要数量。",
    societeSuivie: " 🔔：已关注的学会。",
    suivie: "已关注",
    autresDansBibliotheque: { other: "资料库中另有 {n} 篇 →" },
    alertesTitre: "电子邮件提醒",
    alertesTexte: "每天最多一封邮件：当您关注的学会在您的专科发布指南，或您的某篇摘要有更新时发送。",
    alertesDesactivees: "您的电子邮件提醒已关闭：<compte>在“我的账户”中重新开启</compte>。",
    suiviesAria: "已关注的学会",
    nePlusSuivre: "取消关注 {societe}",
    nePlusSuivreCourt: "取消关注",
    societeASuivre: "要关注的学会",
    suivreUne: "关注一个学会……",
    suivre: "关注",
    alertesPremium: "关注您选择的学会，每有新指南发布或您的摘要有更新时都会收到电子邮件：包含在<abonnement>PREMIUM 订阅</abonnement>中。",
    majTitre: "您的摘要已更新",
    majTexte: "您已解锁、收藏或阅读过的摘要。",
    majRetiree: "该指南已被学会撤回：摘要已无法阅读。",
    majRemplacee: "该指南已被更新的文本取代。",
    majRevision: "检测到来源的新版本：摘要正在修订中。",
    majVersion: "版本 {version}",
    majModification: "{type}修改",
    majPubliee: "发布于 {date}",
    majDefaut: "更新",
    nouvelleFiche: "新摘要：{titre} →",
    premiumTitre: "PREMIUM 订阅已生效",
    premiumTexte: "您所在专科的全部摘要均已解锁",
    premiumJusquau: "，有效期至 {date}。",
    premiumRenouvellement: "；将于 {date} 续订。",
    gerer: "管理我的订阅 →",
    assistantTitre: "检索助手（测试版）",
    assistantTexte: "用日常语言提问：助手会找出摘要中回答该问题的确切段落，不提供医疗建议。",
    assistantLien: "提问 →",
    creditsTitre: "我的点数",
    creditsRestants: { other: "剩余 {n} 个点数" },
    creditsSur: "共 {quota} 个。每个点数可永久解锁一篇摘要。",
    debloquees: "我已解锁的摘要",
    passerPremium: "升级 PREMIUM · 50 € / 年",
    aujourdhui: "今天",
    hier: "昨天",
    ilYa: "{n} 天前",
  },
};
