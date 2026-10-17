// Champs du registre juridique par source (cahier des charges V4.5 §12.4),
// avec les valeurs admises par la base (table source_legal_profiles).
export type Champ = { nom: string; label: string; options: [string, string][] };

export const CHAMPS: Champ[] = [
  {
    nom: "legal_review_status",
    label: "Statut de revue juridique",
    options: [
      ["non_revu", "Non revu"],
      ["en_revue", "En revue"],
      ["valide", "Validé (publication permise)"],
      ["bloque", "Bloqué"],
    ],
  },
  {
    nom: "copyright_status",
    label: "Statut du droit d'auteur",
    options: [
      ["a_verifier", "À vérifier"],
      ["connu", "Connu"],
      ["autorisation_requise", "Autorisation requise"],
    ],
  },
  {
    nom: "commercial_reuse_allowed",
    label: "Réutilisation commerciale",
    options: [
      ["", "Non renseigné"],
      ["oui", "Oui"],
      ["non", "Non"],
      ["incertain", "Incertain"],
    ],
  },
  {
    nom: "automated_access_allowed",
    label: "Accès automatisé (veille)",
    options: [
      ["", "Non renseigné"],
      ["oui", "Oui"],
      ["non", "Non"],
      ["conditions", "Sous conditions"],
    ],
  },
  {
    nom: "translation_allowed",
    label: "Traduction d'un résumé",
    options: [
      ["", "Non renseigné"],
      ["oui", "Oui"],
      ["non", "Non"],
      ["conditions", "Sous conditions"],
    ],
  },
  {
    nom: "permission_obtained",
    label: "Autorisation obtenue",
    options: [
      ["", "Non renseigné"],
      ["oui", "Oui"],
      ["non", "Non"],
      ["non_necessaire", "Non nécessaire selon avis"],
    ],
  },
];

export const STATUT_LABEL: Record<string, string> = Object.fromEntries(CHAMPS[0].options);
