// États d'une demande d'accord (outil d'envoi aux sociétés savantes),
// partagés par le serveur et le tableau de bord.

export const ETATS = {
  a_preparer: { libelle: "À préparer", ton: "neutral" },
  pret: { libelle: "À relire", ton: "accent" },
  valide: { libelle: "Validée, prête à partir", ton: "accent" },
  envoi_en_cours: { libelle: "Envoi en cours", ton: "warn" },
  envoye: { libelle: "Envoyée", ton: "good" },
  relance: { libelle: "Relancée", ton: "good" },
  reponse: { libelle: "Réponse reçue", ton: "accent" },
  accord: { libelle: "Accord obtenu", ton: "good" },
  refus: { libelle: "Refus", ton: "crit" },
  ne_pas_contacter: { libelle: "Ne pas contacter", ton: "crit" },
  erreur: { libelle: "Erreur d'envoi", ton: "crit" },
} as const;

export type Etat = keyof typeof ETATS;

export const estEtat = (v: string): v is Etat => v in ETATS;

// Une fois partie, une demande ne se régénère ni ne se renvoie.
export const ETATS_PARTIS: readonly Etat[] = ["envoi_en_cours", "envoye", "relance", "reponse", "accord", "refus", "ne_pas_contacter"];

export type Adresse = { adresse: string; nature: string; page: string };

export type LigneTableau = {
  id: string;
  societe_slug: string;
  sigle: string;
  nom: string | null;
  specialite: string | null;
  type: string | null;
  priorite: number | null;
  nb_fiches: number;
  destinataires: string[];
  nb_adresses: number;
  piece_jointe: "propre" | "defaut" | "aucune";
  etat: Etat;
  envoye_le: string | null;
  site: string | null;
};
