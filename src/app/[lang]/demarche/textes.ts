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
  es: {
    titreMeta: "Nuestro enfoque — medical-guidelines.net",
    descriptionMeta:
      "Las guías siguen siendo de libre acceso en las webs de las sociedades. La suscripción cubre el alojamiento, el desarrollo y las herramientas de IA del sitio, no las guías.",
    titre: "Nuestro enfoque",
    intro:
      "Una herramienta independiente para ayudar a los profesionales sanitarios a leer, encontrar y aplicar las guías francesas, al servicio de su difusión.",
    sections: [
      [
        "Las guías siguen siendo gratuitas y de libre acceso",
        [
          "Las guías son obra de las sociedades científicas y de las autoridades sanitarias que las publican. Siguen siendo de libre acceso en sus webs, y cada resumen enlaza directamente con el texto oficial.",
          "No vendemos las guías: no reivindicamos ningún derecho sobre ellas, no ofrecemos copias ni descargas, y un resumen nunca sustituye al texto de referencia.",
        ],
      ],
      [
        "La suscripción no busca obtener beneficio de las guías",
        [
          "La suscripción PREMIUM no es el precio de una guía. Cubre lo que cuesta el sitio: un alojamiento seguro, los desarrolladores que lo construyen y mantienen, y las herramientas de inteligencia artificial que ayudan a extraer, estructurar y actualizar los resúmenes.",
          "La inteligencia artificial ayuda, no decide: cada resumen es revisado por el equipo médico, y la fecha de esa revisión figura en el resumen; cualquier error notificado se corrige públicamente en el registro de correcciones.",
        ],
      ],
      [
        "Un proyecto construido con personas voluntarias",
        ["Este sitio no existiría sin las personas voluntarias que lo han hecho posible. Les damos las gracias."],
      ],
      [
        "Independencia",
        [
          "Los resúmenes son independientes y no oficiales. No están editados, avalados ni financiados por las sociedades citadas, que no están asociadas a ninguna oferta comercial del sitio.",
          "Ningún socio comercial influye en el contenido. Los desacuerdos entre sociedades se muestran uno junto a otro, sin arbitraje.",
        ],
      ],
    ],
    ecouteTitre: "Sociedades científicas y autores: les escuchamos",
    ecouteTexte:
      "¿Representa usted a una sociedad científica o es autor de una guía? Cualquier solicitud —corrección, atribución, actualización o retirada de un resumen— se tramita con prioridad: el resumen se retira a simple petición mientras se examina, y se le envía una respuesta motivada en un plazo de 7 días.",
    partenariat:
      "También proponemos a las sociedades científicas una colaboración gratuita: acceso PREMIUM gratuito, estadísticas anónimas de lectura de sus guías y notificaciones de errores de los lectores en sus resúmenes.",
    devenirPartenaire: "Ser socio",
  },
  de: {
    titreMeta: "Unser Ansatz — medical-guidelines.net",
    descriptionMeta:
      "Die Leitlinien bleiben auf den Websites der Fachgesellschaften frei zugänglich. Das Abonnement deckt Hosting, Entwicklung und KI-Werkzeuge der Website, nicht die Leitlinien.",
    titre: "Unser Ansatz",
    intro:
      "Ein unabhängiges Werkzeug, das Gesundheitsfachpersonen hilft, französische Leitlinien zu lesen, zu finden und anzuwenden, und so zu ihrer Verbreitung beiträgt.",
    sections: [
      [
        "Die Leitlinien bleiben kostenlos und frei zugänglich",
        [
          "Leitlinien sind das Werk der Fachgesellschaften und Gesundheitsbehörden, die sie veröffentlichen. Sie bleiben auf deren Websites frei zugänglich, und jede Zusammenfassung verlinkt direkt auf den offiziellen Text.",
          "Wir verkaufen die Leitlinien nicht: Wir beanspruchen keine Rechte daran, bieten weder Kopien noch Downloads an, und eine Zusammenfassung ersetzt nie den Referenztext.",
        ],
      ],
      [
        "Mit dem Abonnement wird kein Gewinn aus den Leitlinien erzielt",
        [
          "Das PREMIUM-Abonnement ist nicht der Preis einer Leitlinie. Es deckt die Kosten der Website: sicheres Hosting, die Entwickler, die sie aufbauen und pflegen, und die Werkzeuge der künstlichen Intelligenz, die beim Extrahieren, Strukturieren und Aktualisieren der Zusammenfassungen helfen.",
          "Künstliche Intelligenz hilft, sie entscheidet nicht: Jede Zusammenfassung wird vom ärztlichen Team geprüft, und das Datum dieser Prüfung steht auf der Zusammenfassung; jeder gemeldete Fehler wird öffentlich im Korrekturprotokoll berichtigt.",
        ],
      ],
      [
        "Ein Projekt, das mit Freiwilligen aufgebaut wurde",
        ["Diese Website gäbe es nicht ohne die Freiwilligen, die sie möglich gemacht haben. Ihnen gilt unser Dank."],
      ],
      [
        "Unabhängigkeit",
        [
          "Die Zusammenfassungen sind unabhängig und nicht offiziell. Sie werden von den genannten Fachgesellschaften weder herausgegeben noch gebilligt noch finanziert; diese sind mit keinem kommerziellen Angebot der Website verbunden.",
          "Kein kommerzieller Partner beeinflusst die Inhalte. Abweichungen zwischen Fachgesellschaften werden nebeneinander dargestellt, ohne Wertung.",
        ],
      ],
    ],
    ecouteTitre: "Fachgesellschaften und Autoren: Wir hören zu",
    ecouteTexte:
      "Vertreten Sie eine Fachgesellschaft oder sind Sie Autor einer Leitlinie? Jede Anfrage — Korrektur, Zuordnung, Aktualisierung oder Entfernung einer Zusammenfassung — wird vorrangig bearbeitet: Die Zusammenfassung wird auf einfache Anfrage während der Prüfung offline genommen, und Sie erhalten innerhalb von 7 Tagen eine begründete Antwort.",
    partenariat:
      "Wir bieten Fachgesellschaften außerdem eine kostenlose Partnerschaft an: kostenloser PREMIUM-Zugang, anonyme Lesestatistiken zu ihren Leitlinien und Fehlermeldungen der Leser zu ihren Zusammenfassungen.",
    devenirPartenaire: "Partner werden",
  },
  ar: {
    titreMeta: "نهجنا — medical-guidelines.net",
    descriptionMeta:
      "تبقى التوصيات متاحة مجانًا على مواقع الجمعيات. يغطي الاشتراك استضافة الموقع وتطويره وأدوات الذكاء الاصطناعي، لا التوصيات.",
    titre: "نهجنا",
    intro: "أداة مستقلة لمساعدة العاملين في المهن الصحية على قراءة التوصيات الفرنسية والعثور عليها وتطبيقها، خدمةً لنشرها.",
    sections: [
      [
        "تبقى التوصيات مجانية ومتاحة للجميع",
        [
          "التوصيات من عمل الجمعيات العلمية والسلطات الصحية التي تنشرها. وهي تبقى متاحة مجانًا على مواقعها، وكل ملخص يحيل مباشرة إلى النص الرسمي.",
          "نحن لا نبيع التوصيات: لا ندّعي أي حق عليها، ولا نقدّم نسخًا ولا تنزيلات، ولا يحلّ أي ملخص محلّ النص المرجعي.",
        ],
      ],
      [
        "لا يهدف الاشتراك إلى التربّح من التوصيات",
        [
          "اشتراك PREMIUM ليس ثمن توصية. بل يغطي تكاليف الموقع: الاستضافة الآمنة، والمطوّرين الذين يبنونه ويصونونه، وأدوات الذكاء الاصطناعي التي تساعد على استخراج الملخصات وتنظيمها وتحديثها.",
          "الذكاء الاصطناعي يساعد ولا يقرّر: يراجع الفريق الطبي كل ملخص، ويظهر تاريخ هذه المراجعة على الملخص؛ ويُصحَّح أي خطأ يُبلَّغ عنه علنًا في سجل التصحيحات.",
        ],
      ],
      ["مشروع بُني بفضل متطوعين", ["ما كان لهذا الموقع أن يوجد لولا المتطوعون الذين جعلوه ممكنًا. فلهم منا جزيل الشكر."]],
      [
        "الاستقلالية",
        [
          "الملخصات مستقلة وغير رسمية. ليست من إصدار الجمعيات المذكورة ولا معتمدة منها ولا ممولة من قبلها، وهذه الجمعيات غير مرتبطة بأي عرض تجاري للموقع.",
          "لا يؤثر أي شريك تجاري في المحتوى. وتُعرض الاختلافات بين الجمعيات جنبًا إلى جنب، دون ترجيح.",
        ],
      ],
    ],
    ecouteTitre: "الجمعيات العلمية والمؤلفون: نحن نصغي إليكم",
    ecouteTexte:
      "هل تمثلون جمعية علمية أو أنتم مؤلفو توصية؟ يُعالَج أي طلب — تصحيح أو نسبة أو تحديث أو سحب ملخص — بأولوية: يُسحب الملخص بمجرد الطلب أثناء دراسته، ويُرسل إليكم رد معلّل خلال 7 أيام.",
    partenariat:
      "نقترح أيضًا على الجمعيات العلمية شراكة مجانية: وصول PREMIUM مجاني، وإحصاءات قراءة مجهولة الهوية لتوصياتها، وبلاغات القرّاء عن الأخطاء في ملخصاتها.",
    devenirPartenaire: "كونوا شركاء",
  },
  zh: {
    titreMeta: "我们的理念 — medical-guidelines.net",
    descriptionMeta: "指南仍可在各学会网站免费获取。订阅费用于本站的托管、开发和人工智能工具，而非指南本身。",
    titre: "我们的理念",
    intro: "一个独立的工具，帮助医疗卫生专业人员阅读、查找和应用法国指南，助力其传播。",
    sections: [
      [
        "指南始终免费、公开",
        [
          "指南是发布它们的医学学会和卫生主管部门的成果。它们仍可在其网站上免费获取，每篇摘要均直接链接到官方文本。",
          "我们不出售指南：我们不主张对其拥有任何权利，不提供副本或下载，摘要也绝不替代参考文本。",
        ],
      ],
      [
        "订阅并非为了从指南中获利",
        [
          "PREMIUM 订阅不是指南的价格。它用于支付本站的运营成本：安全的托管、构建和维护本站的开发人员，以及协助提取、整理和更新摘要的人工智能工具。",
          "人工智能只是辅助，不作决定：每篇摘要均经医疗团队审阅，审阅日期显示在摘要上；任何被报告的错误都会在更正记录中公开更正。",
        ],
      ],
      ["由志愿者共同建成的项目", ["没有让本站得以实现的志愿者，就没有这个网站。在此向他们致谢。"]],
      [
        "独立性",
        [
          "这些摘要是独立、非官方的。它们并非由所引学会编辑、认可或资助，这些学会也不参与本站的任何商业服务。",
          "任何商业合作伙伴都不会影响内容。各学会之间的分歧会并列呈现，不作裁定。",
        ],
      ],
    ],
    ecouteTitre: "医学学会和作者：我们倾听您的意见",
    ecouteTexte:
      "您代表某个医学学会，或是某份指南的作者吗？任何请求（更正、署名、更新或撤下摘要）都将优先处理：只需提出请求，摘要即在审查期间下线，并会在 7 天内给您附理由的答复。",
    partenariat: "我们还为医学学会提供免费合作：免费 PREMIUM 访问、其指南的匿名阅读统计，以及读者对其摘要的错误报告。",
    devenirPartenaire: "成为合作伙伴",
  },
};
