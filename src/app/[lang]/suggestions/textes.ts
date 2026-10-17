import type { Traductions } from "@/i18n/serveur";

// Suggestions des membres (bouton « Une idée ? »).
export const SUGGESTIONS: Traductions<{
  titreMeta: string;
  messages: Record<string, string>;
  statuts: Record<string, string>;
  categories: Record<string, string>;
  retour: string;
  titre: string;
  intro: string;
  type: string;
  choisir: string;
  message: string;
  placeholder: string;
  page: string;
  patient: string;
  envoyer: string;
  derniers: string;
}> = {
  fr: {
    titreMeta: "Améliorer le site — medical-guidelines.net",
    messages: {
      merci: "Merci ! Votre message a bien été envoyé : il sera lu et traité.",
      vide: "Décrivez votre suggestion en quelques mots (5 caractères au moins).",
      invalide: "Choisissez le type de message.",
      limite: "Vous avez déjà envoyé 10 messages en 24 heures : merci de réessayer demain.",
      erreur: "L'envoi n'a pas abouti. Réessayez dans un instant.",
    },
    statuts: { nouveau: "Reçu", traite: "Traité", rejete: "Non retenu" },
    categories: {
      probleme: "Problème sur le site",
      amelioration: "Idée d'amélioration",
      contenu: "Contenu d'une fiche",
      autre: "Autre",
    },
    retour: "← Retour",
    titre: "Améliorer le site",
    intro:
      "Un problème, une idée, une remarque ? Chaque message est lu par l'équipe. Pour une erreur dans le contenu d'une fiche, vous pouvez aussi utiliser « Signaler une erreur » en bas de la fiche.",
    type: "Type de message",
    choisir: "Choisir…",
    message: "Votre message",
    placeholder: "Décrivez ce que vous avez constaté ou ce que vous proposez…",
    page: "Page concernée : {page}",
    patient: "N'indiquez aucune donnée concernant un patient.",
    envoyer: "Envoyer",
    derniers: "Vos derniers messages",
  },
  en: {
    titreMeta: "Improve the site — medical-guidelines.net",
    messages: {
      merci: "Thank you! Your message has been sent: it will be read and handled.",
      vide: "Describe your suggestion in a few words (at least 5 characters).",
      invalide: "Choose the type of message.",
      limite: "You have already sent 10 messages in 24 hours: please try again tomorrow.",
      erreur: "Sending failed. Please try again in a moment.",
    },
    statuts: { nouveau: "Received", traite: "Handled", rejete: "Not adopted" },
    categories: {
      probleme: "Problem on the site",
      amelioration: "Idea for improvement",
      contenu: "Content of a summary",
      autre: "Other",
    },
    retour: "← Back",
    titre: "Improve the site",
    intro:
      "A problem, an idea, a comment? The team reads every message. For an error in the content of a summary, you can also use “Report an error” at the bottom of the summary.",
    type: "Type of message",
    choisir: "Choose…",
    message: "Your message",
    placeholder: "Describe what you noticed or what you suggest…",
    page: "Page concerned: {page}",
    patient: "Do not include any data about a patient.",
    envoyer: "Send",
    derniers: "Your latest messages",
  },
  es: {
    titreMeta: "Mejorar el sitio — medical-guidelines.net",
    messages: {
      merci: "¡Gracias! Su mensaje se ha enviado: será leído y tramitado.",
      vide: "Describa su sugerencia en unas palabras (al menos 5 caracteres).",
      invalide: "Elija el tipo de mensaje.",
      limite: "Ya ha enviado 10 mensajes en 24 horas: vuelva a intentarlo mañana.",
      erreur: "El envío no se ha completado. Vuelva a intentarlo en un momento.",
    },
    statuts: { nouveau: "Recibido", traite: "Tramitado", rejete: "No adoptado" },
    categories: {
      probleme: "Problema en el sitio",
      amelioration: "Idea de mejora",
      contenu: "Contenido de un resumen",
      autre: "Otro",
    },
    retour: "← Volver",
    titre: "Mejorar el sitio",
    intro:
      "¿Un problema, una idea, un comentario? El equipo lee todos los mensajes. Para un error en el contenido de un resumen, también puede usar «Notificar un error» al final del resumen.",
    type: "Tipo de mensaje",
    choisir: "Elegir…",
    message: "Su mensaje",
    placeholder: "Describa lo que ha observado o lo que propone…",
    page: "Página afectada: {page}",
    patient: "No incluya ningún dato relativo a un paciente.",
    envoyer: "Enviar",
    derniers: "Sus últimos mensajes",
  },
  de: {
    titreMeta: "Die Website verbessern — medical-guidelines.net",
    messages: {
      merci: "Vielen Dank! Ihre Nachricht wurde gesendet: Sie wird gelesen und bearbeitet.",
      vide: "Beschreiben Sie Ihren Vorschlag in wenigen Worten (mindestens 5 Zeichen).",
      invalide: "Wählen Sie die Art der Nachricht.",
      limite: "Sie haben bereits 10 Nachrichten in 24 Stunden gesendet: Bitte versuchen Sie es morgen erneut.",
      erreur: "Das Senden ist fehlgeschlagen. Bitte versuchen Sie es gleich noch einmal.",
    },
    statuts: { nouveau: "Eingegangen", traite: "Bearbeitet", rejete: "Nicht übernommen" },
    categories: {
      probleme: "Problem auf der Website",
      amelioration: "Verbesserungsidee",
      contenu: "Inhalt einer Zusammenfassung",
      autre: "Sonstiges",
    },
    retour: "← Zurück",
    titre: "Die Website verbessern",
    intro:
      "Ein Problem, eine Idee, eine Anmerkung? Das Team liest jede Nachricht. Für einen inhaltlichen Fehler in einer Zusammenfassung können Sie auch „Fehler melden“ unten in der Zusammenfassung verwenden.",
    type: "Art der Nachricht",
    choisir: "Auswählen…",
    message: "Ihre Nachricht",
    placeholder: "Beschreiben Sie, was Ihnen aufgefallen ist oder was Sie vorschlagen…",
    page: "Betroffene Seite: {page}",
    patient: "Geben Sie keine Daten zu Patienten an.",
    envoyer: "Senden",
    derniers: "Ihre letzten Nachrichten",
  },
  ar: {
    titreMeta: "تحسين الموقع — medical-guidelines.net",
    messages: {
      merci: "شكرًا! أُرسلت رسالتك: ستُقرأ وتُعالَج.",
      vide: "صف اقتراحك في بضع كلمات (5 أحرف على الأقل).",
      invalide: "اختر نوع الرسالة.",
      limite: "لقد أرسلت 10 رسائل خلال 24 ساعة: يرجى المحاولة غدًا.",
      erreur: "تعذّر الإرسال. أعد المحاولة بعد قليل.",
    },
    statuts: { nouveau: "مستلمة", traite: "تمت معالجتها", rejete: "لم تُعتمد" },
    categories: {
      probleme: "مشكلة في الموقع",
      amelioration: "فكرة للتحسين",
      contenu: "محتوى ملخص",
      autre: "أخرى",
    },
    retour: "→ رجوع",
    titre: "تحسين الموقع",
    intro:
      "مشكلة، فكرة، ملاحظة؟ يقرأ الفريق كل رسالة. للإبلاغ عن خطأ في محتوى ملخص، يمكنك أيضًا استخدام «الإبلاغ عن خطأ» أسفل الملخص.",
    type: "نوع الرسالة",
    choisir: "اختر…",
    message: "رسالتك",
    placeholder: "صف ما لاحظته أو ما تقترحه…",
    page: "الصفحة المعنية: {page}",
    patient: "لا تُدرج أي بيانات تخص مريضًا.",
    envoyer: "إرسال",
    derniers: "رسائلك الأخيرة",
  },
  zh: {
    titreMeta: "改进本站 — medical-guidelines.net",
    messages: {
      merci: "谢谢！您的留言已发送：我们会阅读并处理。",
      vide: "请用几句话描述您的建议（至少 5 个字符）。",
      invalide: "请选择留言类型。",
      limite: "您在 24 小时内已发送 10 条留言：请明天再试。",
      erreur: "发送失败。请稍后重试。",
    },
    statuts: { nouveau: "已收到", traite: "已处理", rejete: "未采纳" },
    categories: {
      probleme: "网站问题",
      amelioration: "改进建议",
      contenu: "摘要内容",
      autre: "其他",
    },
    retour: "← 返回",
    titre: "改进本站",
    intro: "遇到问题、有想法或意见？团队会阅读每一条留言。如发现摘要内容有误，也可以使用摘要底部的“报告错误”。",
    type: "留言类型",
    choisir: "请选择……",
    message: "您的留言",
    placeholder: "请描述您注意到的情况或您的建议……",
    page: "相关页面：{page}",
    patient: "请勿填写任何患者数据。",
    envoyer: "发送",
    derniers: "您最近的留言",
  },
};
