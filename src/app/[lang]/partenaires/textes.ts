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
  es: {
    titreMeta: "Sociedades científicas socias — medical-guidelines.net",
    descriptionMeta:
      "Sociedades científicas: hágase socia. Acceso PREMIUM gratuito, estadísticas anónimas de lectura de sus guías y notificaciones de errores de los lectores en sus resúmenes.",
    surtitre: "Sociedades científicas",
    titre: "Hágase socia",
    intro:
      "¿Representa usted a una sociedad científica? Le proponemos una colaboración gratuita para ayudar a difundir sus guías entre los profesionales sanitarios.",
    offre: [
      [
        "Acceso PREMIUM gratuito",
        "Los miembros designados por su sociedad (junta directiva, consejo científico, comité de guías) reciben un acceso PREMIUM gratuito: todos los resúmenes de su especialidad y el asistente de búsqueda.",
      ],
      [
        "Estadísticas de lectura de sus guías",
        "Número de lectores por resumen, por mes y por especialidad, siempre anónimo y agregado (nunca por debajo de 10 lectores, nunca la identidad ni el historial de navegación de un miembro).",
      ],
      [
        "Notificaciones de errores en sus resúmenes",
        "Los errores e imprecisiones que los lectores señalan en los resúmenes de sus guías se le comunican, junto con la corrección realizada.",
      ],
    ],
    contactTitre: "Contacte con nosotros",
    contactTexte:
      "Escríbanos indicando su sociedad y una persona de contacto: le responderemos en un plazo de 7 días para acordar juntos las condiciones de la colaboración.",
    contactObjet: "Colaboración con una sociedad científica",
    note:
      "Una colaboración no significa que la sociedad valide ni apruebe los resúmenes: siguen siendo resúmenes independientes y no oficiales que remiten siempre al texto de referencia. Toda solicitud de corrección, actualización o retirada se sigue tramitando con prioridad, sea o no socia (véase <demarche>Nuestro enfoque</demarche>).",
  },
  de: {
    titreMeta: "Partner-Fachgesellschaften — medical-guidelines.net",
    descriptionMeta:
      "Fachgesellschaften: Werden Sie Partner. Kostenloser PREMIUM-Zugang, anonyme Lesestatistiken zu Ihren Leitlinien und Fehlermeldungen der Leser zu Ihren Zusammenfassungen.",
    surtitre: "Fachgesellschaften",
    titre: "Werden Sie unser Partner",
    intro:
      "Vertreten Sie eine Fachgesellschaft? Wir bieten Ihnen eine kostenlose Partnerschaft an, um die Verbreitung Ihrer Leitlinien unter Gesundheitsfachpersonen zu unterstützen.",
    offre: [
      [
        "Kostenloser PREMIUM-Zugang",
        "Von Ihrer Fachgesellschaft benannte Mitglieder (Vorstand, wissenschaftlicher Beirat, Leitlinienkommission) erhalten einen kostenlosen PREMIUM-Zugang: alle Zusammenfassungen ihres Fachgebiets und den Suchassistenten.",
      ],
      [
        "Lesestatistiken zu Ihren Leitlinien",
        "Anzahl der Leser pro Zusammenfassung, pro Monat und pro Fachgebiet, stets anonym und aggregiert (nie unter 10 Lesern, nie die Identität oder der Verlauf eines Mitglieds).",
      ],
      [
        "Fehlermeldungen zu Ihren Zusammenfassungen",
        "Von Lesern gemeldete Fehler und Ungenauigkeiten in den Zusammenfassungen Ihrer Leitlinien werden Ihnen mitgeteilt, zusammen mit der vorgenommenen Korrektur.",
      ],
    ],
    contactTitre: "Kontakt",
    contactTexte:
      "Schreiben Sie uns unter Angabe Ihrer Fachgesellschaft und einer Ansprechperson: Wir antworten innerhalb von 7 Tagen, um die Bedingungen der Partnerschaft gemeinsam festzulegen.",
    contactObjet: "Partnerschaft Fachgesellschaft",
    note:
      "Eine Partnerschaft bedeutet nicht, dass die Fachgesellschaft die Zusammenfassungen prüft oder billigt: Sie bleiben unabhängige, nicht offizielle Zusammenfassungen, die stets auf den Referenztext verweisen. Jede Bitte um Korrektur, Aktualisierung oder Entfernung wird weiterhin vorrangig bearbeitet, ob Partner oder nicht (siehe <demarche>Unser Ansatz</demarche>).",
  },
  ar: {
    titreMeta: "الجمعيات العلمية الشريكة — medical-guidelines.net",
    descriptionMeta:
      "الجمعيات العلمية: كونوا شركاءنا. وصول PREMIUM مجاني، وإحصاءات قراءة مجهولة الهوية لتوصياتكم، وبلاغات القرّاء عن الأخطاء في ملخصاتكم.",
    surtitre: "الجمعيات العلمية",
    titre: "كونوا شركاءنا",
    intro: "هل تمثلون جمعية علمية؟ نقترح عليكم شراكة مجانية للمساعدة على نشر توصياتكم بين العاملين في المهن الصحية.",
    offre: [
      [
        "وصول PREMIUM مجاني",
        "يحصل الأعضاء الذين تعيّنهم جمعيتكم (المكتب، المجلس العلمي، لجنة التوصيات) على وصول PREMIUM مجاني: جميع ملخصات تخصصهم ومساعد البحث.",
      ],
      [
        "إحصاءات قراءة توصياتكم",
        "عدد القرّاء لكل ملخص، شهريًا وحسب التخصص، مجهول الهوية ومجمّع دائمًا (لا يقل أبدًا عن 10 قرّاء، ولا يكشف أبدًا هوية أي عضو أو سجل تصفحه).",
      ],
      [
        "بلاغات الأخطاء في ملخصاتكم",
        "تُبلَّغون بالأخطاء وأوجه عدم الدقة التي يشير إليها القرّاء في الملخصات المستخرجة من توصياتكم، مع التصحيح الذي أُجري.",
      ],
    ],
    contactTitre: "تواصلوا معنا",
    contactTexte: "راسلونا مع ذكر جمعيتكم وشخص للتواصل: نردّ خلال 7 أيام لنتفق معًا على شروط الشراكة.",
    contactObjet: "شراكة مع جمعية علمية",
    note:
      "لا تعني الشراكة أن الجمعية تعتمد الملخصات أو توافق عليها: فهي تبقى ملخصات مستقلة وغير رسمية تحيل دائمًا إلى النص المرجعي. ويُعالَج أي طلب تصحيح أو تحديث أو سحب بأولوية، سواء أكانت الجمعية شريكة أم لا (انظر <demarche>نهجنا</demarche>).",
  },
  zh: {
    titreMeta: "合作学会 — medical-guidelines.net",
    descriptionMeta: "医学学会：成为我们的合作伙伴。免费 PREMIUM 访问、您指南的匿名阅读统计，以及读者对您摘要的错误报告。",
    surtitre: "医学学会",
    titre: "成为我们的合作伙伴",
    intro: "您代表某个医学学会吗？我们为您提供免费合作，帮助您的指南在医疗卫生专业人员中传播。",
    offre: [
      ["免费 PREMIUM 访问", "由贵学会指定的成员（理事会、学术委员会、指南委员会）可获得免费 PREMIUM 访问：其专科的全部摘要以及检索助手。"],
      [
        "您指南的阅读统计",
        "按摘要、按月、按专科统计的读者人数，始终匿名并经汇总（人数低于 10 人时不显示，绝不显示任何会员的身份或浏览记录）。",
      ],
      ["您摘要的错误报告", "读者在基于贵学会指南的摘要中报告的错误和不准确之处，会连同所作的更正一并转达给您。"],
    ],
    contactTitre: "联系我们",
    contactTexte: "请来信注明贵学会名称及联系人：我们将在 7 天内回复，共同商定合作条件。",
    contactObjet: "医学学会合作",
    note:
      "合作并不意味着学会审定或认可这些摘要：它们仍是独立、非官方的摘要，并始终链接到参考文本。无论是否为合作伙伴，任何更正、更新或撤下的请求都将优先处理（参见<demarche>我们的理念</demarche>）。",
  },
};
