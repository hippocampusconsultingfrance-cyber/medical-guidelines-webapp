// Langues des traductions des fiches (table document_translations).
export const LANGUES_TRADUCTION = ["en", "es", "de", "ar", "zh"] as const;
export type LangueTraduction = (typeof LANGUES_TRADUCTION)[number];
export const NOMS_TRADUCTION: Record<LangueTraduction, { adjectif: string; autonyme: string; legende: string }> = {
  en: { adjectif: "anglaise", autonyme: "English", legende: "Grade legend:" },
  es: { adjectif: "espagnole", autonyme: "Español", legende: "Leyenda de los grados:" },
  de: { adjectif: "allemande", autonyme: "Deutsch", legende: "Legende der Empfehlungsgrade:" },
  ar: { adjectif: "arabe", autonyme: "العربية", legende: "دليل الدرجات:" },
  zh: { adjectif: "chinoise", autonyme: "中文", legende: "等级说明：" },
};
