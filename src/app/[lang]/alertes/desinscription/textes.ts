import type { Traductions } from "@/i18n/serveur";

// Désinscription des alertes e-mail (lien des e-mails).
export const DESINSCRIPTION: Traductions<{
  titreMeta: string;
  titre: string;
  fait: string;
  invalide: string;
  texte: string;
  bouton: string;
}> = {
  fr: {
    titreMeta: "Désinscription des alertes — medical-guidelines.net",
    titre: "Alertes e-mail",
    fait: "C'est fait : vous ne recevrez plus d'e-mail d'alerte. Vous pouvez les réactiver à tout moment depuis <compte>Mon compte</compte>.",
    invalide: "Ce lien de désinscription n'est pas valide. Vous pouvez désactiver les alertes depuis <compte>Mon compte</compte>.",
    texte:
      "Vous ne recevrez plus aucun e-mail d'alerte (nouvelles recommandations des sociétés suivies, mises à jour de vos fiches). Votre compte et vos favoris sont conservés.",
    bouton: "Me désinscrire des alertes e-mail",
  },
  en: {
    titreMeta: "Unsubscribe from alerts — medical-guidelines.net",
    titre: "Email alerts",
    fait: "Done: you will no longer receive alert emails. You can turn them back on at any time from <compte>My account</compte>.",
    invalide: "This unsubscribe link is not valid. You can turn off alerts from <compte>My account</compte>.",
    texte:
      "You will no longer receive any alert email (new guidelines from the societies you follow, updates to your summaries). Your account and your favourites are kept.",
    bouton: "Unsubscribe from email alerts",
  },
};
