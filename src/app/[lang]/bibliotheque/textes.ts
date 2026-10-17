import type { Pluriel } from "@/i18n/format";
import type { Traductions } from "@/i18n/serveur";

// Bibliothèque des membres : barre latérale, catalogue, lecture d'une fiche.
// Les pages et blocs réservés à l'équipe (publication, veille, tableau de
// bord…) restent en français.
export const BIBLIOTHEQUE: Traductions<{
  shell: {
    accueilAria: string;
    sommaire: string;
    fichesAria: string;
    toutes: string;
    favoris: string;
    ficheBloquee: string;
    accueil: string;
    monCompte: string;
    assistant: string;
    avertissement: string;
    idee: string;
    toutDeplier: string;
    toutReplier: string;
  };
  catalogue: {
    titreMeta: string;
    recommandations: string;
    titre: string;
    accroche: string;
    vueRelecteur: string;
    tableauDeBord: string;
    premium: string;
    creditsRestants: Pluriel;
    creditsSur: string;
    passerPremium: string;
    rechercheIndisponible: string;
    rechercheLibelle: string;
    recherchePlaceholder: string;
    societe: string;
    toutes: string;
    autresSocietes: string;
    compte: Pluriel;
    publiees: Pluriel;
    cosignees: Pluriel;
    pour: string;
    effacer: string;
    aucuneRecherche: string;
    aucunePubliee: string;
    dansContenu: string;
    pages: string;
  };
  fiche: {
    titreMeta: string;
    messages: Record<string, string>;
    quotaAtteint: string;
    revisionDetectee: string;
    remplaceeNotice: string;
    methodologie: string;
    version: string;
    nonIndiquee: string;
    validation: string;
    revision: string;
    relueParLe: string;
    reluePar: string;
    sourceVerifiee: string;
    sourceVerifieeTexte: string;
    societes: Pluriel;
    favoriOn: string;
    favoriOff: string;
    voirNouvelle: string;
    suspendueTitre: string;
    suspendueTexte: string;
    suspendueContact: string;
    bloqueeTitre: string;
    debloquerTexte: string;
    debloquer: string;
    passerPremium: string;
    pointsCles: string;
    divergentesTitre: string;
    divergentesTexte: string;
    societe: string;
    population: string;
    grade: string;
    niveau: string;
    nonIndique: string;
    voirFiche: string;
    citees: string;
    leursAuteurs: string;
    proprietes: string;
    texteIntegral: string;
    documentSource: string;
    independante: string;
    correctionsTitre: string;
    aucuneCorrection: string;
    toutesCorrections: string;
    signalerTitre: string;
    signalerSection: string;
    signalerDescription: string;
    signalerEnvoyer: string;
    referenceTitre: string;
    referenceIntegral: string;
    documentOfficiel: string;
    referenceFin: string;
    toutesFiches: string;
    recommandationsGroupe: string;
    gradeNonIndique: string;
    niveauPreuve: string;
  };
}> = {
  fr: {
    shell: {
      accueilAria: "medical-guidelines.net, accueil",
      sommaire: "Sommaire de la fiche",
      fichesAria: "Fiches",
      toutes: "Toutes les fiches",
      favoris: "★ Mes favoris",
      ficheBloquee: "Fiche bloquée",
      accueil: "Accueil",
      monCompte: "Mon compte",
      assistant: "Assistant de recherche (bêta)",
      avertissement: "Synthèses indépendantes, non officielles. Se référer aux textes intégraux en cas de doute.",
      idee: "💡 Une idée ? Un problème ?",
      toutDeplier: "Tout déplier",
      toutReplier: "Tout replier",
    },
    catalogue: {
      titreMeta: "Bibliothèque — Medical Guidelines",
      recommandations: "Recommandations",
      titre: "Les recommandations, enfin lisibles.",
      accroche:
        "Synthèses fidèles des recommandations des sociétés savantes — grades conservés, sources tracées, pensées pour être lues en quelques minutes au moment de la décision clinique.",
      vueRelecteur: "<b>Vue relecteur</b> : toutes les fiches sont lisibles, brouillons compris.",
      tableauDeBord: "Tableau de bord →",
      premium: "<b>PREMIUM</b> : toutes les fiches de votre spécialité sont ouvertes.",
      creditsRestants: { one: "{n} crédit restant", other: "{n} crédits restants" },
      creditsSur: "sur {quota}. Un crédit débloque une fiche, définitivement.",
      passerPremium: "Passer à PREMIUM →",
      rechercheIndisponible:
        "La recherche dans le texte des fiches est momentanément indisponible : seuls les titres ont été cherchés. Réessayez dans un instant.",
      rechercheLibelle: "Rechercher une fiche",
      recherchePlaceholder: "Rechercher un titre, un médicament, une situation… (ex. rivaroxaban)",
      societe: "Société savante",
      toutes: "Toutes",
      autresSocietes: "Autres sociétés ({n})",
      compte: { one: "{n} fiche", other: "{n} fiches" },
      publiees: { one: " publiée en {annee}", other: " publiées en {annee}" },
      cosignees: { one: " co-signée par {societe}", other: " co-signées par {societe}" },
      pour: " pour « {q} »",
      effacer: "Effacer les filtres",
      aucuneRecherche: "Aucune fiche ne correspond à cette recherche.",
      aucunePubliee:
        "Aucune fiche n'est encore publiée pour votre spécialité. Elles apparaîtront ici au fil de leur validation par notre équipe médicale.",
      dansContenu: "« {q} » dans le contenu",
      pages: "{n} p.",
    },
    fiche: {
      titreMeta: "Fiche — Medical Guidelines",
      messages: {
        indisponible: "Cette fiche n'est pas disponible pour votre compte.",
        erreur: "Le déblocage n'a pas abouti. Réessayez dans un instant.",
        suspendu: "Consultation suspendue temporairement : aucun crédit n'a été utilisé.",
        publiee: "Fiche publiée : elle est maintenant visible par les membres de sa spécialité.",
        depubliee: "Fiche dépubliée : elle n'est plus visible par les membres.",
        confirmation_requise: "Cochez la case de relecture avant de valider.",
        relue: "Relecture enregistrée : la mention « Relue par … » est à jour sur la fiche.",
        relue_nom: "Renseignez votre prénom et votre nom dans Mon compte : ils figurent dans la mention de relecture.",
        relue_erreur: "La relecture n'a pas pu être enregistrée.",
        publication_erreur: "La publication n'a pas abouti (droits de validateur requis).",
        publication_juridique:
          "Publication refusée : le statut juridique de la source n'est pas « Validé » (Registre juridique, depuis le tableau de bord).",
        publication_date: "Publication refusée : la date de publication de la source manque.",
        publication_source: "Publication refusée : l'URL de la source officielle manque.",
        signalement_envoye: "Merci : votre signalement a été envoyé. Il sera examiné avant toute correction.",
        signalement_vide: "Décrivez l'erreur en quelques mots avant d'envoyer.",
        signalement_erreur: "Le signalement n'a pas pu être envoyé. Réessayez dans un instant.",
        veille_ok: "Statut de la fiche enregistré.",
        veille_version: "Nouvelle version enregistrée, statut de la fiche mis à jour.",
        veille_invalide: "Formulaire incomplet : vérifiez le statut et le type de version.",
        veille_remplacement: "Choisissez la fiche qui remplace celle-ci.",
        veille_retrait: "Cochez la case de confirmation pour retirer la fiche.",
        veille_version_existe: "Cette version est déjà enregistrée pour cette fiche.",
        veille_erreur: "L'enregistrement n'a pas abouti (droits de validateur requis).",
        correction_publiee: "Correction publiée au journal public.",
        correction_incomplete: "Choisissez la criticité et résumez la correction (5 caractères au moins).",
        correction_erreur: "La correction n'a pas pu être publiée.",
      },
      quotaAtteint: "Vous avez utilisé vos {quota} crédits. L'abonnement PREMIUM ouvre toutes les fiches de votre spécialité.",
      revisionDetectee:
        "Une nouvelle version de la recommandation source a été détectée : cette fiche est en cours de révision par notre équipe.",
      remplaceeNotice: "La recommandation source a été remplacée par un texte plus récent.",
      methodologie: "Méthodologie",
      version: "Version",
      nonIndiquee: "non indiquée",
      validation: "Validation",
      revision: "Révision",
      reluePar: "Relue par",
      relueParLe: "{nom}, le {date}",
      sourceVerifiee: "Source vérifiée le",
      sourceVerifieeTexte: "{derniere} · prochaine vérification prévue le {prochaine}",
      societes: { one: "Société", other: "Sociétés" },
      favoriOn: "★ Dans mes favoris",
      favoriOff: "☆ Ajouter aux favoris",
      voirNouvelle: "Voir la nouvelle fiche : {titre} →",
      suspendueTitre: "Consultation momentanément suspendue",
      suspendueTexte:
        "Un nombre inhabituel de fiches a été ouvert depuis votre compte en peu de temps. Pour protéger le contenu, la lecture est suspendue pendant quelques heures ; elle reprendra automatiquement.",
      suspendueContact:
        "S'il s'agit d'un usage normal, écrivez-nous à contact@medical-guidelines.net : nous rétablirons l'accès.",
      bloqueeTitre: "🔒 Fiche bloquée",
      debloquerTexte:
        "Débloquer cette fiche utilise <b>1 crédit</b>. Il vous en reste <b>{n}</b> sur {quota}. Une fiche débloquée le reste définitivement.",
      debloquer: "Utiliser 1 crédit pour débloquer",
      passerPremium: "Passer à PREMIUM",
      pointsCles: "Points clés",
      divergentesTitre: "Recommandations divergentes : {question}",
      divergentesTexte:
        "Les sociétés savantes ne formulent pas la même recommandation. Leurs positions sont présentées séparément, sans que l'une soit présentée comme meilleure.",
      societe: "Société",
      population: "Population",
      grade: "Grade",
      niveau: "Niveau de preuve",
      nonIndique: "non indiqué",
      voirFiche: "Voir la fiche : {titre} →",
      citees: "Recommandations citées d'après",
      leursAuteurs: "leurs auteurs",
      proprietes: ". Elles restent l'œuvre et la propriété de leurs auteurs",
      texteIntegral: " ; texte intégral en accès libre :",
      documentSource: "document source officiel",
      independante: ". Synthèse indépendante, ni éditée ni validée par les sociétés savantes citées.",
      correctionsTitre: "Journal des corrections de cette fiche",
      aucuneCorrection: "Aucune correction publiée pour cette fiche.",
      toutesCorrections: "Journal de toutes les corrections →",
      signalerTitre: "⚠ Signaler une erreur dans cette fiche",
      signalerSection: "Section ou tableau concerné (facultatif)",
      signalerDescription: "Description de l'erreur",
      signalerEnvoyer: "Envoyer le signalement",
      referenceTitre: "Référence de la source :",
      referenceIntegral: "Texte intégral en accès libre :",
      documentOfficiel: "document officiel ↗",
      referenceFin:
        "Les recommandations citées restent l'œuvre et la propriété de leurs auteurs ; cette fiche est une synthèse indépendante qui ne remplace pas le texte intégral. Correction ou retrait :",
      toutesFiches: "← Toutes les fiches",
      recommandationsGroupe: "Recommandations",
      gradeNonIndique: "Grade non indiqué",
      niveauPreuve: "Niveau de preuve : {niveau}",
    },
  },
  en: {
    shell: {
      accueilAria: "medical-guidelines.net, home",
      sommaire: "Summary contents",
      fichesAria: "Summaries",
      toutes: "All summaries",
      favoris: "★ My favourites",
      ficheBloquee: "Locked summary",
      accueil: "Home",
      monCompte: "My account",
      assistant: "Research assistant (beta)",
      avertissement: "Independent, unofficial summaries. Refer to the full texts in case of doubt.",
      idee: "💡 An idea? A problem?",
      toutDeplier: "Expand all",
      toutReplier: "Collapse all",
    },
    catalogue: {
      titreMeta: "Library — Medical Guidelines",
      recommandations: "Guidelines",
      titre: "Guidelines, readable at last.",
      accroche:
        "Faithful summaries of the medical societies' guidelines — grades kept, sources traced, designed to be read in a few minutes at the moment of clinical decision.",
      vueRelecteur: "<b>Reviewer view</b>: every summary can be read, drafts included.",
      tableauDeBord: "Dashboard →",
      premium: "<b>PREMIUM</b>: every summary in your specialty is unlocked.",
      creditsRestants: { one: "{n} credit left", other: "{n} credits left" },
      creditsSur: "out of {quota}. One credit unlocks one summary, for good.",
      passerPremium: "Go PREMIUM →",
      rechercheIndisponible:
        "Searching the text of the summaries is temporarily unavailable: only titles were searched. Please try again in a moment.",
      rechercheLibelle: "Search for a summary",
      recherchePlaceholder: "Search a title, a drug, a situation… (e.g. rivaroxaban)",
      societe: "Society",
      toutes: "All",
      autresSocietes: "Other societies ({n})",
      compte: { one: "{n} summary", other: "{n} summaries" },
      publiees: { one: " published in {annee}", other: " published in {annee}" },
      cosignees: { one: " co-signed by {societe}", other: " co-signed by {societe}" },
      pour: " for “{q}”",
      effacer: "Clear filters",
      aucuneRecherche: "No summary matches this search.",
      aucunePubliee:
        "No summary has been published for your specialty yet. They will appear here as our medical team validates them.",
      dansContenu: "“{q}” in the content",
      pages: "{n} pp.",
    },
    fiche: {
      titreMeta: "Summary — Medical Guidelines",
      messages: {
        indisponible: "This summary is not available for your account.",
        erreur: "Unlocking failed. Please try again in a moment.",
        suspendu: "Reading temporarily suspended: no credit was used.",
        publiee: "Summary published: it is now visible to members of its specialty.",
        depubliee: "Summary unpublished: it is no longer visible to members.",
        confirmation_requise: "Tick the review box before confirming.",
        relue: "Review recorded: the “Reviewed by …” mention is up to date on the summary.",
        relue_nom: "Enter your first and last name in My account: they appear in the review mention.",
        relue_erreur: "The review could not be recorded.",
        publication_erreur: "Publication failed (validator rights required).",
        publication_juridique:
          "Publication refused: the legal status of the source is not “Validated” (Legal register, from the dashboard).",
        publication_date: "Publication refused: the source's publication date is missing.",
        publication_source: "Publication refused: the URL of the official source is missing.",
        signalement_envoye: "Thank you: your report has been sent. It will be examined before any correction.",
        signalement_vide: "Describe the error in a few words before sending.",
        signalement_erreur: "The report could not be sent. Please try again in a moment.",
        veille_ok: "Summary status saved.",
        veille_version: "New version saved, summary status updated.",
        veille_invalide: "Incomplete form: check the status and the version type.",
        veille_remplacement: "Choose the summary that replaces this one.",
        veille_retrait: "Tick the confirmation box to withdraw the summary.",
        veille_version_existe: "This version is already recorded for this summary.",
        veille_erreur: "Saving failed (validator rights required).",
        correction_publiee: "Correction published in the public log.",
        correction_incomplete: "Choose the severity and summarise the correction (at least 5 characters).",
        correction_erreur: "The correction could not be published.",
      },
      quotaAtteint: "You have used your {quota} credits. The PREMIUM subscription unlocks every summary in your specialty.",
      revisionDetectee:
        "A new version of the source guideline has been detected: our team is revising this summary.",
      remplaceeNotice: "The source guideline has been superseded by a more recent text.",
      methodologie: "Methodology",
      version: "Version",
      nonIndiquee: "not stated",
      validation: "Endorsement",
      revision: "Revision",
      reluePar: "Reviewed by",
      relueParLe: "{nom}, on {date}",
      sourceVerifiee: "Source checked on",
      sourceVerifieeTexte: "{derniere} · next check due on {prochaine}",
      societes: { one: "Society", other: "Societies" },
      favoriOn: "★ In my favourites",
      favoriOff: "☆ Add to favourites",
      voirNouvelle: "See the new summary: {titre} →",
      suspendueTitre: "Reading temporarily suspended",
      suspendueTexte:
        "An unusual number of summaries has been opened from your account in a short time. To protect the content, reading is suspended for a few hours; it will resume automatically.",
      suspendueContact: "If this is normal use, write to us at contact@medical-guidelines.net: we will restore access.",
      bloqueeTitre: "🔒 Locked summary",
      debloquerTexte:
        "Unlocking this summary uses <b>1 credit</b>. You have <b>{n}</b> left out of {quota}. An unlocked summary stays unlocked for good.",
      debloquer: "Use 1 credit to unlock",
      passerPremium: "Go PREMIUM",
      pointsCles: "Key points",
      divergentesTitre: "Diverging recommendations: {question}",
      divergentesTexte:
        "The medical societies do not make the same recommendation. Their positions are shown separately, without presenting one as better.",
      societe: "Society",
      population: "Population",
      grade: "Grade",
      niveau: "Level of evidence",
      nonIndique: "not stated",
      voirFiche: "See the summary: {titre} →",
      citees: "Recommendations cited from",
      leursAuteurs: "their authors",
      proprietes: ". They remain the work and property of their authors",
      texteIntegral: "; full text freely available:",
      documentSource: "official source document",
      independante: ". Independent summary, neither edited nor endorsed by the societies cited.",
      correctionsTitre: "Corrections log for this summary",
      aucuneCorrection: "No correction published for this summary.",
      toutesCorrections: "Log of all corrections →",
      signalerTitre: "⚠ Report an error in this summary",
      signalerSection: "Section or table concerned (optional)",
      signalerDescription: "Description of the error",
      signalerEnvoyer: "Send the report",
      referenceTitre: "Source reference:",
      referenceIntegral: "Full text freely available:",
      documentOfficiel: "official document ↗",
      referenceFin:
        "The recommendations cited remain the work and property of their authors; this summary is an independent synthesis that does not replace the full text. Correction or removal:",
      toutesFiches: "← All summaries",
      recommandationsGroupe: "Recommendations",
      gradeNonIndique: "Grade not stated",
      niveauPreuve: "Level of evidence: {niveau}",
    },
  },
};
