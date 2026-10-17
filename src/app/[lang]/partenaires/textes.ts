import type { Traductions } from "@/i18n/serveur";

// Offre de partenariat aux sociétés savantes.
export const PARTENAIRES: Traductions<{
  titreMeta: string;
  descriptionMeta: string;
  surtitre: string;
  titre: string;
  intro: string;
  offre: [string, string][];
  contactTitre: string;
  contactTexte: string;
  contactObjet: string;
  note: string;
}> = {
  fr: {
    titreMeta: "Sociétés savantes partenaires — medical-guidelines.net",
    descriptionMeta:
      "Sociétés savantes : devenez partenaires. Accès PREMIUM offert, statistiques anonymes de lecture de vos recommandations et signalements d'erreurs des lecteurs sur vos fiches.",
    surtitre: "Sociétés savantes",
    titre: "Devenez notre partenaire",
    intro:
      "Vous représentez une société savante ? Nous vous proposons un partenariat gratuit, au service de la diffusion de vos recommandations auprès des professionnels de santé.",
    offre: [
      [
        "Accès PREMIUM offert",
        "Les membres désignés par votre société (bureau, conseil scientifique, comité des référentiels) reçoivent un accès PREMIUM gratuit : toutes les fiches de leur spécialité et l'assistant de recherche.",
      ],
      [
        "Statistiques de lecture de vos recommandations",
        "Nombre de lecteurs par fiche, par mois et par spécialité, toujours anonymes et agrégées (jamais en dessous de 10 lecteurs, jamais l'identité ni le parcours d'un membre).",
      ],
      [
        "Signalements d'erreurs sur vos fiches",
        "Les erreurs et imprécisions signalées par les lecteurs sur les fiches tirées de vos recommandations vous sont transmises, avec la correction apportée.",
      ],
    ],
    contactTitre: "Nous contacter",
    contactTexte:
      "Écrivez-nous en précisant votre société et la personne à contacter : nous vous répondons sous 7 jours pour définir ensemble les modalités du partenariat.",
    contactObjet: "Partenariat société savante",
    note:
      "Un partenariat ne vaut ni validation ni approbation des fiches par la société : elles restent des synthèses indépendantes et non officielles, qui renvoient toujours au texte de référence. Toute demande de correction, de mise à jour ou de retrait reste traitée en priorité, partenaire ou non (voir <demarche>Notre démarche</demarche>).",
  },
  en: {
    titreMeta: "Partner medical societies — medical-guidelines.net",
    descriptionMeta:
      "Medical societies: become partners. Free PREMIUM access, anonymous readership statistics for your guidelines and readers' error reports on your summaries.",
    surtitre: "Medical societies",
    titre: "Become our partner",
    intro:
      "Do you represent a medical society? We offer you a free partnership, to help spread your guidelines among health professionals.",
    offre: [
      [
        "Free PREMIUM access",
        "Members appointed by your society (board, scientific council, guidelines committee) receive free PREMIUM access: every summary in their specialty and the research assistant.",
      ],
      [
        "Readership statistics for your guidelines",
        "Number of readers per summary, per month and per specialty, always anonymous and aggregated (never below 10 readers, never a member's identity or browsing history).",
      ],
      [
        "Error reports on your summaries",
        "Errors and inaccuracies reported by readers on the summaries drawn from your guidelines are passed on to you, with the correction made.",
      ],
    ],
    contactTitre: "Contact us",
    contactTexte:
      "Write to us stating your society and a contact person: we reply within 7 days to agree on the terms of the partnership together.",
    contactObjet: "Medical society partnership",
    note:
      "A partnership does not mean that the society validates or approves the summaries: they remain independent, unofficial summaries that always link to the reference text. Any request for correction, update or removal is still handled as a priority, partner or not (see <demarche>Our approach</demarche>).",
  },
};
