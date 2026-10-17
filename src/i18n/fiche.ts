import type { Pluriel } from "./format";
import type { Traductions } from "./serveur";

// Textes communs aux pages des fiches (page publique /recommandations/… et
// fiche de la bibliothèque) : états de la source, mentions, contenu encore
// en français dans les autres langues.
export const FICHE: Traductions<{
  remplacee: string;
  revision: string;
  ancienneTitre: string;
  ancienneTexte: string;
  sourceOfficielle: string;
  synthese: string;
  enFrancais: string;
  fiches: Pluriel;
  criticites: Record<string, string>;
  fraicheur: Record<string, string>;
  etats: { lock: string; open: string; draft: string };
  recommandation: string;
  catalogueOuvert: string;
  catalogueOuvertQuota: string;
}> = {
  fr: {
    remplacee: "Remplacée",
    revision: "Révision en cours",
    ancienneTitre: "Source ancienne.",
    ancienneTexte:
      "Recommandation publiée en {annee}, il y a plus de {max} ans : vérifiez auprès de la société savante qu'aucune actualisation n'a été publiée depuis.",
    sourceOfficielle: "Document source officiel ↗",
    synthese: "fiche de synthèse",
    enFrancais: "",
    fiches: { one: "{n} fiche", other: "{n} fiches" },
    criticites: { mineure: "Mineure", majeure: "Majeure", critique: "Critique" },
    fraicheur: { revision_detectee: "Révision détectée", remplacee: "Remplacée", retiree: "Retirée" },
    etats: { lock: "🔒 Bloquée", open: "Débloquée", draft: "Brouillon" },
    recommandation: "Recommandation",
    catalogueOuvert:
      "Votre spécialité est encore peu couverte : le catalogue porte aujourd'hui surtout sur l'anesthésie-réanimation, la réanimation, la médecine d'urgence et la pédiatrie. Vos {quota} fiches gratuites sont donc au choix dans tout le catalogue. L'abonnement PREMIUM vous sera proposé quand votre spécialité sera couverte : nous vous écrirons à ce moment-là.",
    catalogueOuvertQuota:
      "Vous avez utilisé vos {quota} crédits. Votre spécialité est encore peu couverte : l'abonnement PREMIUM vous sera proposé quand elle le sera, et nous vous écrirons à ce moment-là.",
  },
  en: {
    remplacee: "Superseded",
    revision: "Update in progress",
    ancienneTitre: "Older source.",
    ancienneTexte:
      "Guideline published in {annee}, more than {max} years ago: check with the society that no update has been published since.",
    sourceOfficielle: "Official source document ↗",
    synthese: "summary",
    enFrancais:
      "This summary is currently available in French only (titles, summaries and recommendations): the English version is in preparation.",
    fiches: { one: "{n} summary", other: "{n} summaries" },
    criticites: { mineure: "Minor", majeure: "Major", critique: "Critical" },
    fraicheur: { revision_detectee: "Update detected", remplacee: "Superseded", retiree: "Withdrawn" },
    etats: { lock: "🔒 Locked", open: "Unlocked", draft: "Draft" },
    recommandation: "Guideline",
    catalogueOuvert:
      "Your specialty is not yet well covered: the catalogue currently focuses on anaesthesiology and critical care, intensive care, emergency medicine and paediatrics. Your {quota} free summaries can therefore be chosen from the whole catalogue. The PREMIUM subscription will be offered once your specialty is covered: we will write to you then.",
    catalogueOuvertQuota:
      "You have used your {quota} credits. Your specialty is not yet well covered: the PREMIUM subscription will be offered once it is, and we will write to you then.",
  },
  es: {
    remplacee: "Sustituida",
    revision: "Actualización en curso",
    ancienneTitre: "Fuente antigua.",
    ancienneTexte:
      "Guía publicada en {annee}, hace más de {max} años: compruebe con la sociedad científica que no se ha publicado ninguna actualización desde entonces.",
    sourceOfficielle: "Documento fuente oficial ↗",
    synthese: "resumen",
    enFrancais:
      "Por ahora, este resumen solo está disponible en francés (títulos, resúmenes y recomendaciones): la versión en español está en preparación.",
    fiches: { one: "{n} resumen", other: "{n} resúmenes" },
    criticites: { mineure: "Menor", majeure: "Mayor", critique: "Crítica" },
    fraicheur: { revision_detectee: "Actualización detectada", remplacee: "Sustituida", retiree: "Retirada" },
    etats: { lock: "🔒 Bloqueado", open: "Desbloqueado", draft: "Borrador" },
    recommandation: "Guía",
    catalogueOuvert:
      "Su especialidad todavía está poco cubierta: el catálogo trata hoy sobre todo de anestesiología y reanimación, medicina intensiva, medicina de urgencias y pediatría. Por eso puede elegir sus {quota} resúmenes gratuitos en todo el catálogo. Le propondremos la suscripción PREMIUM cuando su especialidad esté cubierta: le escribiremos en ese momento.",
    catalogueOuvertQuota:
      "Ha utilizado sus {quota} créditos. Su especialidad todavía está poco cubierta: le propondremos la suscripción PREMIUM cuando lo esté y le escribiremos en ese momento.",
  },
  de: {
    remplacee: "Ersetzt",
    revision: "Aktualisierung in Arbeit",
    ancienneTitre: "Ältere Quelle.",
    ancienneTexte:
      "Leitlinie aus dem Jahr {annee}, vor mehr als {max} Jahren veröffentlicht: Prüfen Sie bei der Fachgesellschaft, ob seitdem eine Aktualisierung erschienen ist.",
    sourceOfficielle: "Offizielles Quelldokument ↗",
    synthese: "Zusammenfassung",
    enFrancais:
      "Diese Zusammenfassung ist derzeit nur auf Französisch verfügbar (Titel, Zusammenfassungen und Empfehlungen): Die deutsche Fassung ist in Vorbereitung.",
    fiches: { one: "{n} Zusammenfassung", other: "{n} Zusammenfassungen" },
    criticites: { mineure: "Gering", majeure: "Erheblich", critique: "Kritisch" },
    fraicheur: { revision_detectee: "Aktualisierung erkannt", remplacee: "Ersetzt", retiree: "Zurückgezogen" },
    etats: { lock: "🔒 Gesperrt", open: "Freigeschaltet", draft: "Entwurf" },
    recommandation: "Leitlinie",
    catalogueOuvert:
      "Ihr Fachgebiet ist noch wenig abgedeckt: Der Katalog umfasst derzeit vor allem Anästhesiologie und Intensivmedizin, Intensivmedizin, Notfallmedizin und Pädiatrie. Ihre {quota} kostenlosen Zusammenfassungen können Sie daher aus dem gesamten Katalog wählen. Das PREMIUM-Abonnement wird Ihnen angeboten, sobald Ihr Fachgebiet abgedeckt ist: Wir schreiben Ihnen dann.",
    catalogueOuvertQuota:
      "Sie haben Ihre {quota} Guthaben aufgebraucht. Ihr Fachgebiet ist noch wenig abgedeckt: Das PREMIUM-Abonnement wird Ihnen angeboten, sobald es abgedeckt ist, und wir schreiben Ihnen dann.",
  },
  ar: {
    remplacee: "مستبدلة",
    revision: "قيد التحديث",
    ancienneTitre: "مصدر قديم.",
    ancienneTexte:
      "توصية نُشرت عام {annee}، أي منذ أكثر من {max} سنوات: تحقّق لدى الجمعية العلمية من عدم نشر أي تحديث منذ ذلك الحين.",
    sourceOfficielle: "الوثيقة المصدر الرسمية ↗",
    synthese: "ملخص",
    enFrancais:
      "هذا الملخص متاح حاليًا باللغة الفرنسية فقط (العناوين والملخصات والتوصيات): النسخة العربية قيد الإعداد.",
    fiches: {
      zero: "{n} ملخص",
      one: "ملخص واحد",
      two: "ملخصان",
      few: "{n} ملخصات",
      many: "{n} ملخصًا",
      other: "{n} ملخص",
    },
    criticites: { mineure: "طفيفة", majeure: "كبيرة", critique: "حرجة" },
    fraicheur: { revision_detectee: "رُصد تحديث", remplacee: "مستبدلة", retiree: "مسحوبة" },
    etats: { lock: "🔒 مقفل", open: "مفتوح", draft: "مسودة" },
    recommandation: "توصية",
    catalogueOuvert:
      "تخصصك ما زال قليل التغطية: يتناول الفهرس حاليًا بشكل أساسي التخدير والإنعاش، والعناية المركزة، وطب الطوارئ، وطب الأطفال. لذلك يمكنك اختيار ملخصاتك المجانية الـ{quota} من الفهرس بأكمله. سنعرض عليك اشتراك PREMIUM عندما يصبح تخصصك مغطًّى، وسنراسلك حينها.",
    catalogueOuvertQuota:
      "لقد استخدمت أرصدتك الـ{quota}. تخصصك ما زال قليل التغطية: سنعرض عليك اشتراك PREMIUM عندما يصبح مغطًّى، وسنراسلك حينها.",
  },
  zh: {
    remplacee: "已被取代",
    revision: "更新中",
    ancienneTitre: "来源较旧。",
    ancienneTexte: "该指南发布于 {annee} 年，已超过 {max} 年：请向相关学会核实此后是否发布了更新版本。",
    sourceOfficielle: "官方原始文件 ↗",
    synthese: "摘要",
    enFrancais: "本摘要目前仅提供法文版本（标题、摘要和推荐意见）：中文版本正在准备中。",
    fiches: { other: "{n} 篇摘要" },
    criticites: { mineure: "轻微", majeure: "重要", critique: "严重" },
    fraicheur: { revision_detectee: "检测到更新", remplacee: "已被取代", retiree: "已撤回" },
    etats: { lock: "🔒 未解锁", open: "已解锁", draft: "草稿" },
    recommandation: "指南",
    catalogueOuvert:
      "您的专科目前覆盖尚少：目录现阶段主要涵盖麻醉与重症、重症医学、急诊医学和儿科。因此，您可以在整个目录中选择 {quota} 篇免费摘要。待您的专科有所覆盖时，我们将向您提供 PREMIUM 订阅，并届时写信通知您。",
    catalogueOuvertQuota:
      "您已用完 {quota} 个点数。您的专科目前覆盖尚少：待覆盖后我们将向您提供 PREMIUM 订阅，并届时写信通知您。",
  },
};
