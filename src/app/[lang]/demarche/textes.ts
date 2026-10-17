import type { Traductions } from "@/i18n/serveur";

// Notre démarche (positionnement vis-à-vis des sociétés savantes).
export const DEMARCHE: Traductions<{
  titreMeta: string;
  descriptionMeta: string;
  titre: string;
  intro: string;
  sections: [string, string[]][];
  ecouteTitre: string;
  ecouteTexte: string;
  partenariat: string;
  devenirPartenaire: string;
}> = {
  fr: {
    titreMeta: "Notre démarche — medical-guidelines.net",
    descriptionMeta:
      "Les recommandations restent en accès libre sur les sites des sociétés savantes. L'abonnement couvre l'hébergement, le développement et les outils d'IA du site, pas les recommandations.",
    titre: "Notre démarche",
    intro:
      "Un outil indépendant pour aider les professionnels de santé à lire, retrouver et appliquer les recommandations françaises, au service de leur diffusion.",
    sections: [
      [
        "Les recommandations restent libres et gratuites",
        [
          "Les recommandations sont l'œuvre des sociétés savantes et des autorités de santé qui les publient. Elles restent en accès libre sur leurs sites, et chaque fiche renvoie directement au texte officiel.",
          "Nous ne vendons pas les recommandations : nous n'en revendiquons aucun droit, n'en proposons ni copie ni téléchargement, et la fiche ne remplace jamais le texte de référence.",
        ],
      ],
      [
        "L'abonnement ne sert pas à tirer profit des recommandations",
        [
          "L'abonnement PREMIUM n'est pas le prix d'une recommandation. Il sert à couvrir ce que coûte le site : l'hébergement sécurisé, les développeurs qui le construisent et le maintiennent, et les outils d'intelligence artificielle qui aident à extraire, structurer et tenir à jour les fiches.",
          "L'intelligence artificielle aide, elle ne décide pas : chaque fiche est relue par l'équipe médicale, et la date de cette relecture figure sur la fiche ; toute erreur signalée est corrigée publiquement dans le journal des corrections.",
        ],
      ],
      [
        "Un projet construit avec des volontaires",
        ["Ce site n'existerait pas sans des personnes volontaires qui ont permis sa construction. Qu'elles en soient remerciées."],
      ],
      [
        "Indépendance",
        [
          "Les fiches sont des synthèses indépendantes et non officielles. Elles ne sont ni éditées, ni validées, ni financées par les sociétés savantes citées, qui ne sont associées à aucune offre commerciale du site.",
          "Aucun partenaire commercial n'influence le contenu. Les divergences entre sociétés savantes sont présentées côte à côte, sans arbitrage.",
        ],
      ],
    ],
    ecouteTitre: "Sociétés savantes et auteurs : à votre écoute",
    ecouteTexte:
      "Vous représentez une société savante ou êtes l'auteur d'une recommandation ? Toute demande — correction, mention, mise à jour ou retrait d'une fiche — est traitée en priorité : la fiche est retirée du site sur simple demande pendant l'examen, et une réponse motivée vous est adressée sous 7 jours.",
    partenariat:
      "Nous proposons aussi aux sociétés savantes un partenariat gratuit : accès PREMIUM offert, statistiques anonymes de lecture de leurs recommandations et signalements d'erreurs des lecteurs sur leurs fiches.",
    devenirPartenaire: "Devenir partenaire",
  },
  en: {
    titreMeta: "Our approach — medical-guidelines.net",
    descriptionMeta:
      "The guidelines remain freely available on the societies' websites. The subscription covers the site's hosting, development and AI tools, not the guidelines.",
    titre: "Our approach",
    intro:
      "An independent tool to help health professionals read, find and apply French guidelines, in support of their dissemination.",
    sections: [
      [
        "The guidelines remain free and open",
        [
          "Guidelines are the work of the medical societies and health authorities that publish them. They remain freely available on their websites, and every summary links directly to the official text.",
          "We do not sell the guidelines: we claim no rights over them, offer neither copies nor downloads, and a summary never replaces the reference text.",
        ],
      ],
      [
        "The subscription is not about profiting from the guidelines",
        [
          "The PREMIUM subscription is not the price of a guideline. It covers what the site costs: secure hosting, the developers who build and maintain it, and the artificial intelligence tools that help extract, structure and update the summaries.",
          "Artificial intelligence helps, it does not decide: every summary is reviewed by the medical team, and the date of that review appears on the summary; any error reported is corrected publicly in the corrections log.",
        ],
      ],
      [
        "A project built with volunteers",
        ["This site would not exist without the volunteers who made it possible. Our thanks go to them."],
      ],
      [
        "Independence",
        [
          "The summaries are independent and unofficial. They are neither edited, endorsed nor funded by the societies cited, which are not associated with any commercial offer of the site.",
          "No commercial partner influences the content. Disagreements between societies are shown side by side, without arbitration.",
        ],
      ],
    ],
    ecouteTitre: "Medical societies and authors: we are listening",
    ecouteTexte:
      "Do you represent a medical society or are you the author of a guideline? Any request — correction, attribution, update or removal of a summary — is handled as a priority: the summary is taken down on simple request while it is examined, and a reasoned reply is sent to you within 7 days.",
    partenariat:
      "We also offer medical societies a free partnership: free PREMIUM access, anonymous readership statistics for their guidelines and readers' error reports on their summaries.",
    devenirPartenaire: "Become a partner",
  },
};
