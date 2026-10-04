import { PROFESSION_GROUPS } from "@/lib/professions";

// Médecins relecteurs : candidatures envoyées depuis la page publique
// /relecteurs, traitées par l'administrateur (/bibliotheque/relecteurs).

export const STATUTS_CANDIDATURE: Record<string, string> = {
  nouvelle: "Nouvelle",
  contactee: "Contactée",
  acceptee: "Acceptée",
  refusee: "Refusée",
};

// L'offre s'adresse aux médecins : seules les professions du groupe
// « Médecins » de l'inscription sont proposées.
export const PROFESSIONS_MEDECIN: string[] = PROFESSION_GROUPS.find((g) => g.label === "Médecins")?.options ?? [];

export const TELEPHONE = /^\+?[0-9 .()-]{6,30}$/;
export const EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
