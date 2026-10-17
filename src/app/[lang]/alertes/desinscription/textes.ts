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
  es: {
    titreMeta: "Darse de baja de las alertas — medical-guidelines.net",
    titre: "Alertas por correo",
    fait: "Hecho: ya no recibirá correos de alerta. Puede volver a activarlos en cualquier momento desde <compte>Mi cuenta</compte>.",
    invalide: "Este enlace de baja no es válido. Puede desactivar las alertas desde <compte>Mi cuenta</compte>.",
    texte:
      "Ya no recibirá ningún correo de alerta (nuevas guías de las sociedades que sigue, actualizaciones de sus resúmenes). Su cuenta y sus favoritos se conservan.",
    bouton: "Darme de baja de las alertas por correo",
  },
  de: {
    titreMeta: "Benachrichtigungen abbestellen — medical-guidelines.net",
    titre: "E-Mail-Benachrichtigungen",
    fait: "Erledigt: Sie erhalten keine Benachrichtigungs-E-Mails mehr. Sie können sie jederzeit unter <compte>Mein Konto</compte> wieder aktivieren.",
    invalide: "Dieser Abmeldelink ist ungültig. Sie können die Benachrichtigungen unter <compte>Mein Konto</compte> deaktivieren.",
    texte:
      "Sie erhalten keine Benachrichtigungs-E-Mails mehr (neue Leitlinien der Fachgesellschaften, denen Sie folgen, Aktualisierungen Ihrer Zusammenfassungen). Ihr Konto und Ihre Favoriten bleiben erhalten.",
    bouton: "E-Mail-Benachrichtigungen abbestellen",
  },
  ar: {
    titreMeta: "إلغاء الاشتراك في التنبيهات — medical-guidelines.net",
    titre: "التنبيهات بالبريد الإلكتروني",
    fait: "تم: لن تتلقى بعد الآن رسائل التنبيه. يمكنك إعادة تفعيلها في أي وقت من <compte>حسابي</compte>.",
    invalide: "رابط إلغاء الاشتراك هذا غير صالح. يمكنك إيقاف التنبيهات من <compte>حسابي</compte>.",
    texte:
      "لن تتلقى بعد الآن أي رسالة تنبيه (التوصيات الجديدة من الجمعيات التي تتابعها، وتحديثات ملخصاتك). يبقى حسابك ومفضلتك محفوظين.",
    bouton: "إلغاء الاشتراك في التنبيهات بالبريد الإلكتروني",
  },
  zh: {
    titreMeta: "取消提醒订阅 — medical-guidelines.net",
    titre: "电子邮件提醒",
    fait: "完成：您将不再收到提醒邮件。您可以随时在<compte>我的账户</compte>中重新开启。",
    invalide: "此退订链接无效。您可以在<compte>我的账户</compte>中关闭提醒。",
    texte: "您将不再收到任何提醒邮件（您关注的学会发布的新指南、您摘要的更新）。您的账户和收藏将保留。",
    bouton: "退订电子邮件提醒",
  },
};
