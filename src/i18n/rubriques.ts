import type { LangueOuverte } from "@/lib/langues";

// Rubriques du catalogue (card_json.section, en français dans la base) :
// nom affiché et forme dans une phrase (« Recommandations en … »). Une
// rubrique absente garde son nom français.
const RUBRIQUES: Record<string, Record<LangueOuverte, { nom: string; phrase: string }>> = {
  Anesthésie: { fr: { nom: "Anesthésie", phrase: "anesthésie" }, en: { nom: "Anaesthesia", phrase: "anaesthesia" } },
  Réanimation: { fr: { nom: "Réanimation", phrase: "réanimation" }, en: { nom: "Intensive care", phrase: "intensive care" } },
  Urgences: { fr: { nom: "Urgences", phrase: "médecine d'urgence" }, en: { nom: "Emergency medicine", phrase: "emergency medicine" } },
  Pédiatrie: { fr: { nom: "Pédiatrie", phrase: "pédiatrie" }, en: { nom: "Paediatrics", phrase: "paediatrics" } },
  Obstétrique: { fr: { nom: "Obstétrique", phrase: "obstétrique" }, en: { nom: "Obstetrics", phrase: "obstetrics" } },
  Infectiologie: { fr: { nom: "Infectiologie", phrase: "infectiologie" }, en: { nom: "Infectious diseases", phrase: "infectious diseases" } },
  Nutrition: { fr: { nom: "Nutrition", phrase: "nutrition" }, en: { nom: "Nutrition", phrase: "nutrition" } },
};

export function rubrique(section: string, langue: LangueOuverte) {
  return RUBRIQUES[section]?.[langue] ?? { nom: section, phrase: section.toLowerCase() };
}
