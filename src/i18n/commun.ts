import type { Traductions } from "./serveur";

// Textes communs à toutes les pages : métadonnées par défaut, pied de page,
// en-têtes, pages 404 et d'erreur.
export const COMMUN: Traductions<{
  meta: { description: string; ogLocale: string };
  pied: {
    societe: string;
    societeLien: string;
    medecin: string;
    medecinLien: string;
    mentions: string;
    cgu: string;
    cgv: string;
    confidentialite: string;
    corrections: string;
    langues: string;
  };
  entete: { accueilAria: string; accueil: string };
  introuvable: { titreMeta: string; surtitre: string; titre: string; texte: string; recommandations: string; accueil: string };
  erreur: { surtitre: string; titre: string; texte: string; reference: string; reessayer: string; accueil: string };
  deconnexion: string;
  image: { alt: string; surtitre: string; titre: string; pied: string };
}> = {
  fr: {
    meta: {
      description: "Fiches de synthèse des recommandations professionnelles, pour le personnel médical et paramédical.",
      ogLocale: "fr_FR",
    },
    pied: {
      societe:
        "<b>Société savante ?</b> Devenez notre partenaire : accès PREMIUM offert, statistiques anonymes de lecture et signalements d'erreurs sur vos fiches.",
      societeLien: "En savoir plus",
      medecin:
        "<b>Médecin ?</b> Participez à la correction des fiches : accès gratuit au site et 5 accès offerts aux personnes de votre choix.",
      medecinLien: "Devenir relecteur",
      mentions: "Mentions légales",
      cgu: "CGU",
      cgv: "CGV",
      confidentialite: "Confidentialité",
      corrections: "Journal des corrections",
      langues: "Langue du site",
    },
    entete: { accueilAria: "medical-guidelines.net, accueil", accueil: "← Accueil" },
    introuvable: {
      titreMeta: "Page introuvable — medical-guidelines.net",
      surtitre: "Erreur 404",
      titre: "Page introuvable",
      texte:
        "Cette adresse ne correspond à aucune page. La fiche a peut-être changé de nom : retrouvez-la dans la liste des recommandations.",
      recommandations: "Voir les recommandations",
      accueil: "Retour à l'accueil",
    },
    erreur: {
      surtitre: "Erreur",
      titre: "Un problème est survenu",
      texte:
        "La page n'a pas pu s'afficher. Réessayez dans un instant ; si le problème continue, écrivez-nous à <mail>contact@medical-guidelines.net</mail>",
      reference: " (référence {ref})",
      reessayer: "Réessayer",
      accueil: "Retour à l'accueil",
    },
    deconnexion: "Se déconnecter",
    image: {
      alt: "medical-guidelines.net — les recommandations professionnelles en fiches claires et sourcées",
      surtitre: "Médecins et paramédicaux",
      titre: "Les recommandations professionnelles, en fiches claires et sourcées",
      pied: "Grades conservés · Source officielle à portée de clic · 5 fiches gratuites",
    },
  },
  en: {
    meta: {
      description: "Summaries of professional clinical guidelines, for doctors, nurses and allied health professionals.",
      ogLocale: "en_GB",
    },
    pied: {
      societe:
        "<b>A medical society?</b> Become our partner: free PREMIUM access, anonymous readership statistics and error reports on your summaries.",
      societeLien: "Learn more",
      medecin:
        "<b>A doctor?</b> Help correct our summaries: free access to the site, plus 5 free accounts for people of your choice.",
      medecinLien: "Become a reviewer",
      mentions: "Legal notice",
      cgu: "Terms of use",
      cgv: "Terms of sale",
      confidentialite: "Privacy",
      corrections: "Corrections log",
      langues: "Site language",
    },
    entete: { accueilAria: "medical-guidelines.net, home", accueil: "← Home" },
    introuvable: {
      titreMeta: "Page not found — medical-guidelines.net",
      surtitre: "Error 404",
      titre: "Page not found",
      texte:
        "This address does not match any page. The summary may have been renamed: find it in the list of guidelines.",
      recommandations: "Browse the guidelines",
      accueil: "Back to home",
    },
    erreur: {
      surtitre: "Error",
      titre: "Something went wrong",
      texte:
        "The page could not be displayed. Please try again in a moment; if the problem persists, write to us at <mail>contact@medical-guidelines.net</mail>",
      reference: " (reference {ref})",
      reessayer: "Try again",
      accueil: "Back to home",
    },
    deconnexion: "Sign out",
    image: {
      alt: "medical-guidelines.net — professional guidelines in clear, referenced summaries",
      surtitre: "Doctors and allied health professionals",
      titre: "Professional guidelines, in clear and referenced summaries",
      pied: "Original grades kept · Official source one click away · 5 free summaries",
    },
  },
  es: {
    meta: {
      description: "Resúmenes de las guías de práctica clínica, para médicos y profesionales sanitarios.",
      ogLocale: "es_ES",
    },
    pied: {
      societe:
        "<b>¿Una sociedad científica?</b> Hágase socia: acceso PREMIUM gratuito, estadísticas anónimas de lectura y notificaciones de errores en sus resúmenes.",
      societeLien: "Más información",
      medecin:
        "<b>¿Es usted médico?</b> Participe en la corrección de los resúmenes: acceso gratuito al sitio y 5 accesos gratuitos para las personas que usted elija.",
      medecinLien: "Ser revisor",
      mentions: "Aviso legal",
      cgu: "Condiciones de uso",
      cgv: "Condiciones de venta",
      confidentialite: "Privacidad",
      corrections: "Registro de correcciones",
      langues: "Idioma del sitio",
    },
    entete: { accueilAria: "medical-guidelines.net, inicio", accueil: "← Inicio" },
    introuvable: {
      titreMeta: "Página no encontrada — medical-guidelines.net",
      surtitre: "Error 404",
      titre: "Página no encontrada",
      texte:
        "Esta dirección no corresponde a ninguna página. Es posible que el resumen haya cambiado de nombre: búsquelo en la lista de guías.",
      recommandations: "Ver las guías",
      accueil: "Volver al inicio",
    },
    erreur: {
      surtitre: "Error",
      titre: "Se ha producido un problema",
      texte:
        "No se ha podido mostrar la página. Vuelva a intentarlo en un momento; si el problema continúa, escríbanos a <mail>contact@medical-guidelines.net</mail>",
      reference: " (referencia {ref})",
      reessayer: "Reintentar",
      accueil: "Volver al inicio",
    },
    deconnexion: "Cerrar sesión",
    image: {
      alt: "medical-guidelines.net — las guías de práctica clínica en resúmenes claros y referenciados",
      surtitre: "Médicos y profesionales sanitarios",
      titre: "Las guías de práctica clínica, en resúmenes claros y referenciados",
      pied: "Grados conservados · Fuente oficial a un clic · 5 resúmenes gratuitos",
    },
  },
  de: {
    meta: {
      description: "Zusammenfassungen klinischer Leitlinien für Ärztinnen und Ärzte sowie Gesundheitsfachberufe.",
      ogLocale: "de_DE",
    },
    pied: {
      societe:
        "<b>Eine Fachgesellschaft?</b> Werden Sie unser Partner: kostenloser PREMIUM-Zugang, anonyme Lesestatistiken und Fehlermeldungen zu Ihren Zusammenfassungen.",
      societeLien: "Mehr erfahren",
      medecin:
        "<b>Sind Sie Ärztin oder Arzt?</b> Helfen Sie bei der Korrektur der Zusammenfassungen: kostenloser Zugang zur Website und 5 kostenlose Zugänge für Personen Ihrer Wahl.",
      medecinLien: "Gutachter werden",
      mentions: "Impressum",
      cgu: "Nutzungsbedingungen",
      cgv: "Verkaufsbedingungen",
      confidentialite: "Datenschutz",
      corrections: "Korrekturprotokoll",
      langues: "Sprache der Website",
    },
    entete: { accueilAria: "medical-guidelines.net, Startseite", accueil: "← Startseite" },
    introuvable: {
      titreMeta: "Seite nicht gefunden — medical-guidelines.net",
      surtitre: "Fehler 404",
      titre: "Seite nicht gefunden",
      texte:
        "Diese Adresse entspricht keiner Seite. Die Zusammenfassung wurde möglicherweise umbenannt: Sie finden sie in der Liste der Leitlinien.",
      recommandations: "Leitlinien ansehen",
      accueil: "Zurück zur Startseite",
    },
    erreur: {
      surtitre: "Fehler",
      titre: "Ein Problem ist aufgetreten",
      texte:
        "Die Seite konnte nicht angezeigt werden. Versuchen Sie es gleich noch einmal; besteht das Problem weiter, schreiben Sie uns an <mail>contact@medical-guidelines.net</mail>",
      reference: " (Referenz {ref})",
      reessayer: "Erneut versuchen",
      accueil: "Zurück zur Startseite",
    },
    deconnexion: "Abmelden",
    image: {
      alt: "medical-guidelines.net — klinische Leitlinien in klaren, belegten Zusammenfassungen",
      surtitre: "Ärztinnen, Ärzte und Gesundheitsfachberufe",
      titre: "Klinische Leitlinien in klaren, belegten Zusammenfassungen",
      pied: "Empfehlungsgrade erhalten · Offizielle Quelle mit einem Klick · 5 kostenlose Zusammenfassungen",
    },
  },
  ar: {
    meta: {
      description: "ملخصات للتوصيات المهنية، للأطباء والعاملين في المهن الصحية.",
      ogLocale: "ar_AR",
    },
    pied: {
      societe:
        "<b>هل تمثلون جمعية علمية؟</b> كونوا شركاءنا: وصول PREMIUM مجاني، وإحصاءات قراءة مجهولة الهوية، وبلاغات عن الأخطاء في ملخصاتكم.",
      societeLien: "اعرف المزيد",
      medecin:
        "<b>هل أنت طبيب؟</b> شارك في تصحيح الملخصات: وصول مجاني إلى الموقع و5 حسابات مجانية لأشخاص من اختيارك.",
      medecinLien: "كن مراجعًا",
      mentions: "البيانات القانونية",
      cgu: "شروط الاستخدام",
      cgv: "شروط البيع",
      confidentialite: "الخصوصية",
      corrections: "سجل التصحيحات",
      langues: "لغة الموقع",
    },
    entete: { accueilAria: "medical-guidelines.net، الصفحة الرئيسية", accueil: "→ الصفحة الرئيسية" },
    introuvable: {
      titreMeta: "الصفحة غير موجودة — medical-guidelines.net",
      surtitre: "خطأ 404",
      titre: "الصفحة غير موجودة",
      texte: "لا يطابق هذا العنوان أي صفحة. ربما تغيّر اسم الملخص: ابحث عنه في قائمة التوصيات.",
      recommandations: "عرض التوصيات",
      accueil: "العودة إلى الصفحة الرئيسية",
    },
    erreur: {
      surtitre: "خطأ",
      titre: "حدثت مشكلة",
      texte:
        "تعذّر عرض الصفحة. أعد المحاولة بعد قليل؛ وإذا استمرت المشكلة، فراسلنا على <mail>contact@medical-guidelines.net</mail>",
      reference: " (المرجع {ref})",
      reessayer: "إعادة المحاولة",
      accueil: "العودة إلى الصفحة الرئيسية",
    },
    deconnexion: "تسجيل الخروج",
    image: {
      alt: "medical-guidelines.net — التوصيات المهنية في ملخصات واضحة وموثّقة",
      surtitre: "الأطباء والعاملون في المهن الصحية",
      titre: "التوصيات المهنية في ملخصات واضحة وموثّقة",
      pied: "الدرجات محفوظة · المصدر الرسمي بنقرة واحدة · 5 ملخصات مجانية",
    },
  },
  zh: {
    meta: {
      description: "专业临床指南摘要，面向医生及医疗卫生专业人员。",
      ogLocale: "zh_CN",
    },
    pied: {
      societe: "<b>您代表学会吗？</b>成为我们的合作伙伴：免费 PREMIUM 访问、匿名阅读统计以及读者对您摘要的错误报告。",
      societeLien: "了解更多",
      medecin: "<b>您是医生吗？</b>参与摘要的校对：免费访问本站，另有 5 个免费账户供您指定的人使用。",
      medecinLien: "成为审校者",
      mentions: "法律声明",
      cgu: "使用条款",
      cgv: "销售条款",
      confidentialite: "隐私",
      corrections: "更正记录",
      langues: "网站语言",
    },
    entete: { accueilAria: "medical-guidelines.net，首页", accueil: "← 首页" },
    introuvable: {
      titreMeta: "页面未找到 — medical-guidelines.net",
      surtitre: "错误 404",
      titre: "页面未找到",
      texte: "此地址不对应任何页面。摘要可能已更名：请在指南列表中查找。",
      recommandations: "查看指南",
      accueil: "返回首页",
    },
    erreur: {
      surtitre: "错误",
      titre: "出现了问题",
      texte: "页面无法显示。请稍后重试；如果问题仍然存在，请发送邮件至 <mail>contact@medical-guidelines.net</mail>",
      reference: "（参考号 {ref}）",
      reessayer: "重试",
      accueil: "返回首页",
    },
    deconnexion: "退出登录",
    image: {
      alt: "medical-guidelines.net — 清晰、有出处的专业指南摘要",
      surtitre: "医生及医疗卫生专业人员",
      titre: "专业指南，以清晰、有出处的摘要呈现",
      pied: "保留推荐等级 · 一键直达官方来源 · 5 篇免费摘要",
    },
  },
};
