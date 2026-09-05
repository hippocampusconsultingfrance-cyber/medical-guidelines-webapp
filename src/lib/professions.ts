// Liste des professions médicales et paramédicales proposées à l'inscription.
// Si l'utilisateur ne se retrouve pas dans cette liste, il choisit "Autre"
// et précise sa spécialité en texte libre (champ professionAutre).

export type ProfessionGroup = {
  label: string;
  options: string[];
};

export const PROFESSION_GROUPS: ProfessionGroup[] = [
  {
    label: "Médecins",
    options: [
      "Anesthésiste-réanimateur",
      "Médecin généraliste",
      "Médecin urgentiste",
      "Réanimateur médical",
      "Chirurgien général",
      "Chirurgien orthopédiste",
      "Chirurgien cardiaque / thoracique",
      "Chirurgien vasculaire",
      "Chirurgien viscéral / digestif",
      "Chirurgien pédiatrique",
      "Chirurgien plastique",
      "Chirurgien ORL",
      "Chirurgien maxillo-facial",
      "Chirurgien urologue",
      "Neurochirurgien",
      "Gynécologue-obstétricien",
      "Pédiatre",
      "Cardiologue",
      "Pneumologue",
      "Néphrologue",
      "Hépato-gastro-entérologue",
      "Endocrinologue",
      "Neurologue",
      "Hématologue",
      "Oncologue",
      "Infectiologue",
      "Radiologue",
      "Médecin biologiste",
      "Médecin du travail",
      "Médecin légiste",
      "Gériatre",
      "Psychiatre",
      "Interne en médecine",
    ],
  },
  {
    label: "Odontologie et pharmacie",
    options: [
      "Chirurgien-dentiste",
      "Pharmacien hospitalier",
      "Pharmacien d'officine",
      "Préparateur en pharmacie",
    ],
  },
  {
    label: "Professions paramédicales",
    options: [
      "Infirmier(ère) diplômé(e) d'État (IDE)",
      "Infirmier(ère) anesthésiste (IADE)",
      "Infirmier(ère) de bloc opératoire (IBODE)",
      "Infirmier(ère) en pratique avancée (IPA)",
      "Infirmier(ère) de réanimation",
      "Sage-femme / Maïeuticien",
      "Aide-soignant(e)",
      "Auxiliaire de puériculture",
      "Kinésithérapeute",
      "Ergothérapeute",
      "Psychomotricien(ne)",
      "Orthophoniste",
      "Orthoptiste",
      "Diététicien(ne)",
      "Manipulateur(trice) en électroradiologie médicale",
      "Technicien(ne) de laboratoire médical",
      "Perfusionniste",
      "Ambulancier(ère)",
      "Podologue",
      "Opticien(ne)",
      "Audioprothésiste",
      "Psychologue",
    ],
  },
  {
    label: "Étudiants",
    options: [
      "Étudiant(e) en médecine",
      "Étudiant(e) en soins infirmiers",
      "Étudiant(e) sage-femme",
      "Étudiant(e) en pharmacie",
      "Étudiant(e) en odontologie",
      "Étudiant(e) paramédical (autre filière)",
    ],
  },
  {
    label: "Autre",
    options: ["Autre"],
  },
];

export const ALL_PROFESSIONS: string[] = PROFESSION_GROUPS.flatMap(
  (g) => g.options,
);
