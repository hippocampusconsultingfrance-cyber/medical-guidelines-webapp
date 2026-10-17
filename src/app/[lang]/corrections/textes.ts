import type { Traductions } from "@/i18n/serveur";

// Journal public des corrections.
export const CORRECTIONS: Traductions<{
  titreMeta: string;
  descriptionMeta: string;
  titre: string;
  intro: string;
  enFrancais: string;
  aucune: string;
  fiche: string;
}> = {
  fr: {
    titreMeta: "Journal des corrections — medical-guidelines.net",
    descriptionMeta: "Corrections apportées aux fiches de synthèse : date, fiche, criticité et résumé de la modification.",
    titre: "Journal des corrections",
    intro:
      "Chaque erreur confirmée dans une fiche est corrigée puis consignée ici : date, fiche, criticité et résumé de la modification. Une erreur repérée ? Signalez-la depuis la fiche concernée.",
    enFrancais: "",
    aucune: "Aucune correction publiée à ce jour.",
    fiche: "Fiche",
  },
  en: {
    titreMeta: "Corrections log — medical-guidelines.net",
    descriptionMeta: "Corrections made to the summaries: date, summary, severity and an outline of the change.",
    titre: "Corrections log",
    intro:
      "Every confirmed error in a summary is corrected and then recorded here: date, summary, severity and an outline of the change. Spotted an error? Report it from the summary concerned.",
    enFrancais: "Summary titles and correction notes are written in French.",
    aucune: "No corrections published to date.",
    fiche: "Summary",
  },
  es: {
    titreMeta: "Registro de correcciones — medical-guidelines.net",
    descriptionMeta: "Correcciones realizadas en los resúmenes: fecha, resumen, gravedad y descripción del cambio.",
    titre: "Registro de correcciones",
    intro:
      "Todo error confirmado en un resumen se corrige y se registra aquí: fecha, resumen, gravedad y descripción del cambio. ¿Ha detectado un error? Notifíquelo desde el resumen correspondiente.",
    enFrancais: "Los títulos de los resúmenes y las notas de corrección están redactados en francés.",
    aucune: "Hasta la fecha no se ha publicado ninguna corrección.",
    fiche: "Resumen",
  },
  de: {
    titreMeta: "Korrekturprotokoll — medical-guidelines.net",
    descriptionMeta: "An den Zusammenfassungen vorgenommene Korrekturen: Datum, Zusammenfassung, Schweregrad und Beschreibung der Änderung.",
    titre: "Korrekturprotokoll",
    intro:
      "Jeder bestätigte Fehler in einer Zusammenfassung wird korrigiert und hier festgehalten: Datum, Zusammenfassung, Schweregrad und Beschreibung der Änderung. Einen Fehler entdeckt? Melden Sie ihn direkt in der betreffenden Zusammenfassung.",
    enFrancais: "Die Titel der Zusammenfassungen und die Korrekturhinweise sind auf Französisch verfasst.",
    aucune: "Bisher wurde keine Korrektur veröffentlicht.",
    fiche: "Zusammenfassung",
  },
  ar: {
    titreMeta: "سجل التصحيحات — medical-guidelines.net",
    descriptionMeta: "التصحيحات التي أُجريت على الملخصات: التاريخ، والملخص، ودرجة الخطورة، ووصف التعديل.",
    titre: "سجل التصحيحات",
    intro:
      "يُصحَّح كل خطأ مؤكد في ملخص ثم يُسجَّل هنا: التاريخ، والملخص، ودرجة الخطورة، ووصف التعديل. هل لاحظت خطأ؟ أبلغ عنه من الملخص المعني.",
    enFrancais: "عناوين الملخصات وملاحظات التصحيح مكتوبة باللغة الفرنسية.",
    aucune: "لم يُنشر أي تصحيح حتى الآن.",
    fiche: "الملخص",
  },
  zh: {
    titreMeta: "更正记录 — medical-guidelines.net",
    descriptionMeta: "对摘要所作的更正：日期、摘要、严重程度及修改说明。",
    titre: "更正记录",
    intro: "摘要中每个经确认的错误都会被更正并记录于此：日期、摘要、严重程度及修改说明。发现错误？请在相关摘要中报告。",
    enFrancais: "摘要标题和更正说明均以法文撰写。",
    aucune: "迄今尚未发布任何更正。",
    fiche: "摘要",
  },
};
