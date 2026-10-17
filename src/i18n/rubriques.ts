import type { LangueOuverte } from "@/lib/langues";

// Rubriques du catalogue (card_json.section, en français dans la base) :
// nom affiché et forme dans une phrase (« Recommandations en … »). Une
// rubrique absente garde son nom français.
const RUBRIQUES: Record<string, Record<LangueOuverte, { nom: string; phrase: string }>> = {
  Anesthésie: {
    fr: { nom: "Anesthésie", phrase: "anesthésie" },
    en: { nom: "Anaesthesia", phrase: "anaesthesia" },
    es: { nom: "Anestesia", phrase: "anestesia" },
    de: { nom: "Anästhesie", phrase: "Anästhesie" },
    ar: { nom: "التخدير", phrase: "التخدير" },
    zh: { nom: "麻醉", phrase: "麻醉" },
  },
  Réanimation: {
    fr: { nom: "Réanimation", phrase: "réanimation" },
    en: { nom: "Intensive care", phrase: "intensive care" },
    es: { nom: "Medicina intensiva", phrase: "medicina intensiva" },
    de: { nom: "Intensivmedizin", phrase: "Intensivmedizin" },
    ar: { nom: "العناية المركزة", phrase: "العناية المركزة" },
    zh: { nom: "重症医学", phrase: "重症医学" },
  },
  Urgences: {
    fr: { nom: "Urgences", phrase: "médecine d'urgence" },
    en: { nom: "Emergency medicine", phrase: "emergency medicine" },
    es: { nom: "Urgencias", phrase: "medicina de urgencias" },
    de: { nom: "Notfallmedizin", phrase: "Notfallmedizin" },
    ar: { nom: "طب الطوارئ", phrase: "طب الطوارئ" },
    zh: { nom: "急诊医学", phrase: "急诊医学" },
  },
  Pédiatrie: {
    fr: { nom: "Pédiatrie", phrase: "pédiatrie" },
    en: { nom: "Paediatrics", phrase: "paediatrics" },
    es: { nom: "Pediatría", phrase: "pediatría" },
    de: { nom: "Pädiatrie", phrase: "Pädiatrie" },
    ar: { nom: "طب الأطفال", phrase: "طب الأطفال" },
    zh: { nom: "儿科", phrase: "儿科" },
  },
  Obstétrique: {
    fr: { nom: "Obstétrique", phrase: "obstétrique" },
    en: { nom: "Obstetrics", phrase: "obstetrics" },
    es: { nom: "Obstetricia", phrase: "obstetricia" },
    de: { nom: "Geburtshilfe", phrase: "Geburtshilfe" },
    ar: { nom: "طب التوليد", phrase: "طب التوليد" },
    zh: { nom: "产科", phrase: "产科" },
  },
  Infectiologie: {
    fr: { nom: "Infectiologie", phrase: "infectiologie" },
    en: { nom: "Infectious diseases", phrase: "infectious diseases" },
    es: { nom: "Enfermedades infecciosas", phrase: "enfermedades infecciosas" },
    de: { nom: "Infektiologie", phrase: "Infektiologie" },
    ar: { nom: "الأمراض المعدية", phrase: "الأمراض المعدية" },
    zh: { nom: "感染病学", phrase: "感染病学" },
  },
  Nutrition: {
    fr: { nom: "Nutrition", phrase: "nutrition" },
    en: { nom: "Nutrition", phrase: "nutrition" },
    es: { nom: "Nutrición", phrase: "nutrición" },
    de: { nom: "Ernährungsmedizin", phrase: "Ernährungsmedizin" },
    ar: { nom: "التغذية", phrase: "التغذية" },
    zh: { nom: "营养", phrase: "营养" },
  },
};

export function rubrique(section: string, langue: LangueOuverte) {
  return RUBRIQUES[section]?.[langue] ?? { nom: section, phrase: section.toLowerCase() };
}
