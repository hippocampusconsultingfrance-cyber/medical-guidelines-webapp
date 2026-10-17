import type { Traductions } from "@/i18n/serveur";

// Appel aux médecins relecteurs et formulaire de candidature.
export const RELECTEURS: Traductions<{
  titreMeta: string;
  descriptionMeta: string;
  messages: Record<string, string>;
  surtitre: string;
  titre: string;
  intro: string;
  offreTitre: string;
  offre: string[];
  offreTexte: string;
  formulaireTitre: string;
  nom: string;
  prenom: string;
  telephone: string;
  email: string;
  profession: string;
  choisirProfession: string;
  specialite: string;
  choisirSpecialite: string;
  listeIndisponible: string;
  message: string;
  siteWeb: string;
  consentement: string;
  envoyer: string;
}> = {
  fr: {
    titreMeta: "Médecins relecteurs — medical-guidelines.net",
    descriptionMeta:
      "Vous êtes médecin ? Participez à la correction des fiches, déjà relues deux fois par des outils d'intelligence artificielle : accès gratuit et illimité au site, plus 5 accès gratuits illimités pour les personnes de votre choix.",
    messages: {
      merci: "Merci ! Votre candidature a bien été envoyée : nous vous recontactons rapidement.",
      nom: "Indiquez votre nom et votre prénom.",
      telephone: "Le numéro de téléphone n'est pas valide.",
      email: "L'adresse e-mail n'est pas valide.",
      profession: "Choisissez votre profession dans la liste.",
      specialite: "Choisissez la spécialité dont vous souhaitez corriger les fiches.",
      consentement: "Cochez la case d'accord pour que nous puissions vous recontacter.",
      limite: "Vous avez déjà envoyé plusieurs candidatures aujourd'hui : nous les avons bien reçues.",
      erreur: "L'envoi n'a pas abouti. Réessayez dans un instant.",
    },
    surtitre: "Médecins relecteurs",
    titre: "Vous êtes médecin et vous souhaitez participer à la correction des fiches ?",
    intro:
      "Chaque fiche a déjà été relue deux fois par des outils d'intelligence artificielle, qui la comparent au texte de la recommandation source. Votre regard de praticien permet d'aller plus loin.",
    offreTitre: "Ce que nous vous offrons",
    offre: [
      "un <b>accès gratuit et illimité</b> au site ;",
      "ainsi que <b>5 accès gratuits illimités</b> pour les personnes que vous désignez.",
    ],
    offreTexte:
      "Laissez-nous vos coordonnées et la spécialité dont vous souhaitez corriger les fiches : nous vous recontactons pour convenir des modalités.",
    formulaireTitre: "Je souhaite participer",
    nom: "Nom",
    prenom: "Prénom",
    telephone: "Numéro de téléphone",
    email: "Adresse e-mail",
    profession: "Profession",
    choisirProfession: "Sélectionnez votre profession",
    specialite: "Spécialité dont vous souhaitez corriger les fiches",
    choisirSpecialite: "Sélectionnez une spécialité",
    listeIndisponible: "Liste indisponible : rechargez la page",
    message: "Message (facultatif)",
    siteWeb: "Site web",
    consentement:
      "J'accepte que ces informations soient utilisées pour me recontacter au sujet de cette proposition (voir la <confidentialite>politique de confidentialité</confidentialite>).",
    envoyer: "Envoyer ma candidature",
  },
  en: {
    titreMeta: "Physician reviewers — medical-guidelines.net",
    descriptionMeta:
      "Are you a doctor? Help correct the summaries, already checked twice by artificial intelligence tools: free unlimited access to the site, plus 5 free unlimited accounts for people of your choice.",
    messages: {
      merci: "Thank you! Your application has been sent: we will get back to you shortly.",
      nom: "Enter your last name and first name.",
      telephone: "The phone number is not valid.",
      email: "The email address is not valid.",
      profession: "Choose your profession from the list.",
      specialite: "Choose the specialty whose summaries you would like to correct.",
      consentement: "Tick the consent box so that we can contact you.",
      limite: "You have already sent several applications today: we have received them.",
      erreur: "Sending failed. Please try again in a moment.",
    },
    surtitre: "Physician reviewers",
    titre: "Are you a doctor who would like to help correct the summaries?",
    intro:
      "Every summary has already been checked twice by artificial intelligence tools, which compare it with the text of the source guideline. Your eye as a practitioner takes it further.",
    offreTitre: "What we offer you",
    offre: ["<b>free, unlimited access</b> to the site;", "plus <b>5 free unlimited accounts</b> for the people you choose."],
    offreTexte:
      "Leave us your contact details and the specialty whose summaries you would like to correct: we will contact you to agree on the arrangements.",
    formulaireTitre: "I would like to take part",
    nom: "Last name",
    prenom: "First name",
    telephone: "Phone number",
    email: "Email address",
    profession: "Profession",
    choisirProfession: "Select your profession",
    specialite: "Specialty whose summaries you would like to correct",
    choisirSpecialite: "Select a specialty",
    listeIndisponible: "List unavailable: reload the page",
    message: "Message (optional)",
    siteWeb: "Website",
    consentement:
      "I agree that this information may be used to contact me about this proposal (see the <confidentialite>privacy policy</confidentialite>).",
    envoyer: "Send my application",
  },
  es: {
    titreMeta: "Médicos revisores — medical-guidelines.net",
    descriptionMeta:
      "¿Es usted médico? Participe en la corrección de los resúmenes, ya revisados dos veces por herramientas de inteligencia artificial: acceso gratuito e ilimitado al sitio y 5 cuentas gratuitas ilimitadas para las personas que usted elija.",
    messages: {
      merci: "¡Gracias! Su candidatura se ha enviado: nos pondremos en contacto con usted en breve.",
      nom: "Indique sus apellidos y su nombre.",
      telephone: "El número de teléfono no es válido.",
      email: "La dirección de correo electrónico no es válida.",
      profession: "Elija su profesión en la lista.",
      specialite: "Elija la especialidad cuyos resúmenes desea corregir.",
      consentement: "Marque la casilla de consentimiento para que podamos contactarle.",
      limite: "Ya ha enviado varias candidaturas hoy: las hemos recibido.",
      erreur: "El envío no se ha completado. Vuelva a intentarlo en un momento.",
    },
    surtitre: "Médicos revisores",
    titre: "¿Es usted médico y quiere ayudar a corregir los resúmenes?",
    intro:
      "Cada resumen ya ha sido revisado dos veces por herramientas de inteligencia artificial, que lo comparan con el texto de la guía de origen. Su mirada de profesional va más allá.",
    offreTitre: "Lo que le ofrecemos",
    offre: ["un <b>acceso gratuito e ilimitado</b> al sitio;", "además de <b>5 cuentas gratuitas ilimitadas</b> para las personas que usted elija."],
    offreTexte:
      "Déjenos sus datos de contacto y la especialidad cuyos resúmenes desea corregir: nos pondremos en contacto con usted para acordar las condiciones.",
    formulaireTitre: "Quiero participar",
    nom: "Apellidos",
    prenom: "Nombre",
    telephone: "Teléfono",
    email: "Dirección de correo electrónico",
    profession: "Profesión",
    choisirProfession: "Seleccione su profesión",
    specialite: "Especialidad cuyos resúmenes desea corregir",
    choisirSpecialite: "Seleccione una especialidad",
    listeIndisponible: "Lista no disponible: recargue la página",
    message: "Mensaje (opcional)",
    siteWeb: "Sitio web",
    consentement:
      "Acepto que esta información se utilice para contactarme en relación con esta propuesta (véase la <confidentialite>política de privacidad</confidentialite>).",
    envoyer: "Enviar mi candidatura",
  },
  de: {
    titreMeta: "Ärztliche Gutachter — medical-guidelines.net",
    descriptionMeta:
      "Sind Sie Ärztin oder Arzt? Helfen Sie bei der Korrektur der Zusammenfassungen, die bereits zweimal von KI-Werkzeugen geprüft wurden: kostenloser, unbegrenzter Zugang zur Website sowie 5 kostenlose, unbegrenzte Konten für Personen Ihrer Wahl.",
    messages: {
      merci: "Vielen Dank! Ihre Bewerbung wurde gesendet: Wir melden uns in Kürze bei Ihnen.",
      nom: "Geben Sie Ihren Nachnamen und Vornamen an.",
      telephone: "Die Telefonnummer ist ungültig.",
      email: "Die E-Mail-Adresse ist ungültig.",
      profession: "Wählen Sie Ihren Beruf aus der Liste.",
      specialite: "Wählen Sie das Fachgebiet, dessen Zusammenfassungen Sie korrigieren möchten.",
      consentement: "Kreuzen Sie das Einwilligungskästchen an, damit wir Sie kontaktieren können.",
      limite: "Sie haben heute bereits mehrere Bewerbungen gesendet: Wir haben sie erhalten.",
      erreur: "Das Senden ist fehlgeschlagen. Bitte versuchen Sie es gleich noch einmal.",
    },
    surtitre: "Ärztliche Gutachter",
    titre: "Sind Sie Ärztin oder Arzt und möchten bei der Korrektur der Zusammenfassungen helfen?",
    intro:
      "Jede Zusammenfassung wurde bereits zweimal von Werkzeugen der künstlichen Intelligenz geprüft, die sie mit dem Text der Quellleitlinie vergleichen. Ihr Blick als Praktiker geht weiter.",
    offreTitre: "Was wir Ihnen bieten",
    offre: ["<b>kostenlosen, unbegrenzten Zugang</b> zur Website;", "dazu <b>5 kostenlose, unbegrenzte Konten</b> für Personen Ihrer Wahl."],
    offreTexte:
      "Hinterlassen Sie uns Ihre Kontaktdaten und das Fachgebiet, dessen Zusammenfassungen Sie korrigieren möchten: Wir melden uns, um die Einzelheiten zu vereinbaren.",
    formulaireTitre: "Ich möchte mitmachen",
    nom: "Nachname",
    prenom: "Vorname",
    telephone: "Telefon",
    email: "E-Mail-Adresse",
    profession: "Beruf",
    choisirProfession: "Wählen Sie Ihren Beruf",
    specialite: "Fachgebiet, dessen Zusammenfassungen Sie korrigieren möchten",
    choisirSpecialite: "Wählen Sie ein Fachgebiet",
    listeIndisponible: "Liste nicht verfügbar: Laden Sie die Seite neu",
    message: "Nachricht (optional)",
    siteWeb: "Website",
    consentement:
      "Ich bin damit einverstanden, dass diese Angaben verwendet werden, um mich zu diesem Angebot zu kontaktieren (siehe <confidentialite>Datenschutzerklärung</confidentialite>).",
    envoyer: "Meine Bewerbung senden",
  },
  ar: {
    titreMeta: "الأطباء المراجعون — medical-guidelines.net",
    descriptionMeta:
      "هل أنت طبيب؟ شارك في تصحيح الملخصات التي خضعت بالفعل لمراجعتين بأدوات الذكاء الاصطناعي: وصول مجاني وغير محدود إلى الموقع، و5 حسابات مجانية غير محدودة لأشخاص من اختيارك.",
    messages: {
      merci: "شكرًا! أُرسل طلبك: سنتواصل معك قريبًا.",
      nom: "أدخل اسم عائلتك واسمك الأول.",
      telephone: "رقم الهاتف غير صالح.",
      email: "عنوان البريد الإلكتروني غير صالح.",
      profession: "اختر مهنتك من القائمة.",
      specialite: "اختر التخصص الذي تريد تصحيح ملخصاته.",
      consentement: "حدّد مربع الموافقة حتى نتمكن من التواصل معك.",
      limite: "لقد أرسلت عدة طلبات اليوم: وقد استلمناها.",
      erreur: "تعذّر الإرسال. أعد المحاولة بعد قليل.",
    },
    surtitre: "الأطباء المراجعون",
    titre: "هل أنت طبيب وترغب في المساعدة على تصحيح الملخصات؟",
    intro:
      "خضع كل ملخص بالفعل لمراجعتين بأدوات الذكاء الاصطناعي التي تقارنه بنص التوصية المصدر. ونظرتك كممارس تذهب أبعد من ذلك.",
    offreTitre: "ما نقدّمه لك",
    offre: ["<b>وصول مجاني وغير محدود</b> إلى الموقع؛", "إضافة إلى <b>5 حسابات مجانية غير محدودة</b> لأشخاص من اختيارك."],
    offreTexte: "اترك لنا بيانات التواصل والتخصص الذي تريد تصحيح ملخصاته: سنتواصل معك للاتفاق على التفاصيل.",
    formulaireTitre: "أرغب في المشاركة",
    nom: "اسم العائلة",
    prenom: "الاسم الأول",
    telephone: "الهاتف",
    email: "عنوان البريد الإلكتروني",
    profession: "المهنة",
    choisirProfession: "اختر مهنتك",
    specialite: "التخصص الذي تريد تصحيح ملخصاته",
    choisirSpecialite: "اختر تخصصًا",
    listeIndisponible: "القائمة غير متاحة: أعد تحميل الصفحة",
    message: "رسالة (اختياري)",
    siteWeb: "الموقع الإلكتروني",
    consentement: "أوافق على استخدام هذه المعلومات للتواصل معي بشأن هذا العرض (انظر <confidentialite>سياسة الخصوصية</confidentialite>).",
    envoyer: "إرسال طلبي",
  },
  zh: {
    titreMeta: "医生审校者 — medical-guidelines.net",
    descriptionMeta: "您是医生吗？参与校对已经过人工智能工具两轮核查的摘要：免费、无限制访问本站，另有 5 个免费无限制账户供您指定的人使用。",
    messages: {
      merci: "谢谢！您的申请已发送：我们会尽快与您联系。",
      nom: "请填写您的姓和名。",
      telephone: "电话号码无效。",
      email: "电子邮箱地址无效。",
      profession: "请从列表中选择您的职业。",
      specialite: "请选择您希望校对其摘要的专科。",
      consentement: "请勾选同意框，以便我们与您联系。",
      limite: "您今天已发送多份申请：我们已全部收到。",
      erreur: "发送失败。请稍后重试。",
    },
    surtitre: "医生审校者",
    titre: "您是医生并愿意帮助校对摘要吗？",
    intro: "每篇摘要都已经过人工智能工具的两轮核查，这些工具会将摘要与原始指南文本进行比对。您作为临床医生的眼光能让它更进一步。",
    offreTitre: "我们为您提供",
    offre: ["本站<b>免费、无限制的访问权限</b>；", "另有 <b>5 个免费无限制账户</b>，供您指定的人使用。"],
    offreTexte: "请留下您的联系方式以及希望校对其摘要的专科：我们会与您联系，商定具体安排。",
    formulaireTitre: "我希望参与",
    nom: "姓",
    prenom: "名",
    telephone: "电话",
    email: "电子邮箱地址",
    profession: "职业",
    choisirProfession: "请选择您的职业",
    specialite: "希望校对其摘要的专科",
    choisirSpecialite: "请选择专科",
    listeIndisponible: "列表不可用：请刷新页面",
    message: "留言（可选）",
    siteWeb: "网站",
    consentement: "我同意使用这些信息就本提议与我联系（参见<confidentialite>隐私政策</confidentialite>）。",
    envoyer: "提交我的申请",
  },
};
