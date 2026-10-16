import { FREE_QUOTA } from "@/lib/fiches";

// Spécialités encore peu couvertes par le catalogue (fonction SQL
// catalogue_ouvert : moins de seuil_specialite_couverte() fiches publiées).
// Le membre voit tout le catalogue et choisit ses fiches gratuites parmi
// toutes les fiches publiées ; l'abonnement PREMIUM (toutes les fiches de la
// spécialité) ne lui est pas proposé tant que sa spécialité n'est pas couverte.
export const CATALOGUE_OUVERT = `Votre spécialité est encore peu couverte : le catalogue porte aujourd'hui surtout sur l'anesthésie-réanimation, la réanimation, la médecine d'urgence et la pédiatrie. Vos ${FREE_QUOTA} fiches gratuites sont donc au choix dans tout le catalogue. L'abonnement PREMIUM vous sera proposé quand votre spécialité sera couverte : nous vous écrirons à ce moment-là.`;

export const CATALOGUE_OUVERT_QUOTA = `Vous avez utilisé vos ${FREE_QUOTA} crédits. Votre spécialité est encore peu couverte : l'abonnement PREMIUM vous sera proposé quand elle le sera, et nous vous écrirons à ce moment-là.`;
