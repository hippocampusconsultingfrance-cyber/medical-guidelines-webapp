import type { Traductions } from "@/i18n/serveur";

// Abonnement PREMIUM (page des membres).
export const ABONNEMENT: Traductions<{
  titreMeta: string;
  messages: Record<string, string>;
  etudiantTitre: string;
  etudiantTexte: string;
  justificatifRecu: string;
  valideRemise: string;
  valideRenouvellement: string;
  refuse: string;
  refuseFin: string;
  statut: string;
  choisir: string;
  fichier: string;
  atteste: string;
  envoyerJustificatif: string;
  bibliotheque: string;
  titre: string;
  premiumActif: string;
  premiumTexte: string;
  offertJusquau: string;
  offertSansFin: string;
  jusquauResilie: string;
  renouvellement: string;
  factures: string;
  resilier: string;
  bientotTitre: string;
  choisirGratuites: string;
  prixEtudiant: string;
  prixEtudiantDetail: string;
  prix: string;
  prixDetail: string;
  avantages: string[];
  note: string;
  demarche: string;
  attente: string;
  deposerDabord: string;
  code: string;
  cgv: string;
  retractation: string;
  payer: string;
  stripe: string;
  bientot: string;
}> = {
  fr: {
    titreMeta: "Abonnement PREMIUM — medical-guidelines.net",
    messages: {
      etudiant_envoye: "Justificatif reçu : nous le vérifions et vous répondons par e-mail, en général sous 48 h.",
      etudiant_statut: "Choisissez votre statut.",
      etudiant_atteste: "Cochez l'attestation avant d'envoyer.",
      etudiant_fichier: "Joignez votre justificatif.",
      etudiant_format: "Format non accepté : envoyez un PDF, un JPEG ou un PNG.",
      etudiant_taille: "Fichier trop lourd : 3 Mo au maximum.",
      etudiant_deja: "Une demande est déjà en cours d'examen.",
      etudiant_attente: "Votre justificatif est en cours de vérification : le paiement s'ouvrira avec −30 % dès sa validation.",
      etudiant_erreur: "L'envoi n'a pas abouti. Réessayez dans un instant.",
      merci: "Merci ! Votre paiement est enregistré. L'accès PREMIUM s'active dans quelques secondes : rechargez la page si besoin.",
      annule: "Paiement annulé : aucun montant n'a été débité.",
      cases: "Cochez les deux cases pour continuer.",
      code: "Ce code promotionnel n'est pas valable. Vérifiez-le, ou laissez le champ vide.",
      resiliation:
        "Résiliation enregistrée : votre accès PREMIUM reste ouvert jusqu'à la fin de la période payée, sans renouvellement.",
      portail: "Espace de facturation indisponible pour ce compte : écrivez-nous à contact@medical-guidelines.net.",
      specialite: "L'abonnement PREMIUM n'est pas encore proposé pour votre spécialité.",
      erreur: "Le paiement n'a pas pu être ouvert. Réessayez dans un instant.",
      deja_abonne: "Votre abonnement PREMIUM est déjà actif : aucun nouveau paiement n'a été lancé.",
      paiement_en_cours: "Un paiement est déjà en cours d'ouverture : patientez quelques secondes, puis rechargez la page.",
    },
    etudiantTitre: "Professionnel de santé en formation ? −30 % la première année",
    etudiantTexte:
      "Étudiants en médecine ou paramédicaux, internes, résidents, docteurs juniors : déposez un justificatif de l'année universitaire en cours (carte d'étudiant, certificat de scolarité, attestation d'affectation) <b>avant de payer</b>. Après vérification (en général sous 48 h), la réduction de 30 % s'applique automatiquement au paiement (35 € TTC la première année). Le justificatif est supprimé dès notre décision.",
    justificatifRecu: "Justificatif reçu le {date} : vérification en cours. Réponse par e-mail.",
    valideRemise: "Justificatif validé : −30 % appliqués automatiquement au paiement ci-dessous, soit 35 € TTC la première année.",
    valideRenouvellement: "Justificatif validé : −30 % sur votre prochain renouvellement.",
    refuse: "Votre précédent justificatif n'a pas été validé",
    refuseFin: " Vous pouvez en déposer un nouveau.",
    statut: "Votre statut",
    choisir: "Choisir…",
    fichier: "Justificatif (PDF, JPEG ou PNG, 3 Mo maximum)",
    atteste: "J'atteste être en formation pour l'année universitaire en cours.",
    envoyerJustificatif: "Envoyer mon justificatif",
    bibliotheque: "Bibliothèque",
    titre: "Abonnement PREMIUM",
    premiumActif: "Votre abonnement PREMIUM est actif.",
    premiumTexte: "Toutes les fiches de votre spécialité sont ouvertes",
    offertJusquau: ", accès offert jusqu'au {date}.",
    offertSansFin: ", accès offert sans date de fin.",
    jusquauResilie: " jusqu'au {date} (résiliation enregistrée).",
    renouvellement: " ; prochain renouvellement le {date}.",
    factures: "Factures et moyen de paiement",
    resilier: "Résilier mon abonnement",
    bientotTitre: "Abonnement bientôt proposé pour votre spécialité",
    choisirGratuites: "Choisir mes fiches gratuites →",
    prixEtudiant: "35 €",
    prixEtudiantDetail: "TTC la première année, puis 50 € / an",
    prix: "50 €",
    prixDetail: "TTC / an",
    avantages: [
      "Toutes les fiches de votre spécialité, sans limite de crédits",
      "Alertes e-mail : nouvelles recommandations des sociétés savantes que vous suivez et mises à jour de vos fiches",
      "Paiement annuel ; résiliation à tout moment, accès maintenu jusqu'à la fin de l'année payée",
      "Offre membres fondateurs : −30 % la première année pour les 100 premiers abonnés (code FONDATEURS)",
      "Professionnels de santé en formation : −30 % sur justificatif déposé ci-dessus (non cumulable)",
    ],
    note:
      "Votre abonnement ne paie pas les recommandations : elles restent en accès libre sur les sites des sociétés savantes. Il ne sert pas à en tirer profit mais à couvrir ce que coûte le site : l'hébergement, les développeurs et les outils d'intelligence artificielle. Ce site a été construit grâce à des personnes volontaires.",
    demarche: "Notre démarche",
    attente:
      "Votre justificatif de formation est en cours de vérification. Vous recevrez un e-mail dès sa validation : le paiement s'ouvrira alors ici, avec −30 %.",
    deposerDabord: "Vous avez indiqué être en formation : déposez d'abord votre justificatif ci-dessus pour bénéficier de −30 %.",
    code: "Code promotionnel (facultatif)",
    cgv: "J'ai lu et j'accepte les <cgv>Conditions Générales de Vente</cgv>.",
    retractation:
      "Je demande l'accès immédiat au service et je renonce expressément à mon droit de rétractation de 14 jours dès le début de l'accès.",
    payer: "Payer et activer PREMIUM",
    stripe: "Paiement sécurisé par Stripe. Une facture vous est envoyée par e-mail.",
    bientot: "Les abonnements ouvrent bientôt. En attendant, vos 5 crédits gratuits restent disponibles.",
  },
  en: {
    titreMeta: "PREMIUM subscription — medical-guidelines.net",
    messages: {
      etudiant_envoye: "Proof received: we will check it and reply by email, usually within 48 hours.",
      etudiant_statut: "Choose your status.",
      etudiant_atteste: "Tick the declaration before sending.",
      etudiant_fichier: "Attach your proof.",
      etudiant_format: "Format not accepted: send a PDF, JPEG or PNG.",
      etudiant_taille: "File too large: 3 MB maximum.",
      etudiant_deja: "A request is already being examined.",
      etudiant_attente: "Your proof is being checked: payment will open with −30% as soon as it is validated.",
      etudiant_erreur: "Sending failed. Please try again in a moment.",
      merci: "Thank you! Your payment is recorded. PREMIUM access activates within a few seconds: reload the page if needed.",
      annule: "Payment cancelled: nothing has been charged.",
      cases: "Tick both boxes to continue.",
      code: "This promotion code is not valid. Check it, or leave the field empty.",
      resiliation:
        "Cancellation recorded: your PREMIUM access remains open until the end of the paid period, without renewal.",
      portail: "Billing area unavailable for this account: write to us at contact@medical-guidelines.net.",
      specialite: "The PREMIUM subscription is not yet offered for your specialty.",
      erreur: "Payment could not be opened. Please try again in a moment.",
      deja_abonne: "Your PREMIUM subscription is already active: no new payment was started.",
      paiement_en_cours: "A payment is already being opened: wait a few seconds, then reload the page.",
    },
    etudiantTitre: "Health professional in training? −30% in the first year",
    etudiantTexte:
      "Medical or allied health students, residents, junior doctors: upload proof for the current academic year (student card, certificate of enrolment, placement certificate) <b>before paying</b>. After checking (usually within 48 hours), the 30% discount is applied automatically at payment (€35 incl. VAT for the first year). The document is deleted as soon as we have decided.",
    justificatifRecu: "Proof received on {date}: being checked. Reply by email.",
    valideRemise: "Proof validated: −30% applied automatically to the payment below, i.e. €35 incl. VAT for the first year.",
    valideRenouvellement: "Proof validated: −30% on your next renewal.",
    refuse: "Your previous proof was not validated",
    refuseFin: " You can upload a new one.",
    statut: "Your status",
    choisir: "Choose…",
    fichier: "Proof (PDF, JPEG or PNG, 3 MB maximum)",
    atteste: "I declare that I am in training for the current academic year.",
    envoyerJustificatif: "Send my proof",
    bibliotheque: "Library",
    titre: "PREMIUM subscription",
    premiumActif: "Your PREMIUM subscription is active.",
    premiumTexte: "Every summary in your specialty is unlocked",
    offertJusquau: ", free access until {date}.",
    offertSansFin: ", free access with no end date.",
    jusquauResilie: " until {date} (cancellation recorded).",
    renouvellement: "; next renewal on {date}.",
    factures: "Invoices and payment method",
    resilier: "Cancel my subscription",
    bientotTitre: "Subscription coming soon for your specialty",
    choisirGratuites: "Choose my free summaries →",
    prixEtudiant: "€35",
    prixEtudiantDetail: "incl. VAT for the first year, then €50 / year",
    prix: "€50",
    prixDetail: "incl. VAT / year",
    avantages: [
      "Every summary in your specialty, with no credit limit",
      "Email alerts: new guidelines from the societies you follow and updates to your summaries",
      "Annual payment; cancel at any time, access maintained until the end of the paid year",
      "Founding members offer: −30% in the first year for the first 100 subscribers (code FONDATEURS)",
      "Health professionals in training: −30% with proof uploaded above (not combinable)",
    ],
    note:
      "Your subscription does not pay for the guidelines: they remain freely available on the societies' websites. It is not about profiting from them but about covering what the site costs: hosting, developers and artificial intelligence tools. This site was built thanks to volunteers.",
    demarche: "Our approach",
    attente:
      "Your proof of training is being checked. You will receive an email as soon as it is validated: payment will then open here, with −30%.",
    deposerDabord: "You indicated that you are in training: first upload your proof above to get −30%.",
    code: "Promotion code (optional)",
    cgv: "I have read and accept the <cgv>Terms of Sale</cgv>.",
    retractation:
      "I request immediate access to the service and expressly waive my 14-day right of withdrawal from the start of access.",
    payer: "Pay and activate PREMIUM",
    stripe: "Secure payment by Stripe. An invoice is sent to you by email.",
    bientot: "Subscriptions open soon. Meanwhile, your 5 free credits remain available.",
  },
};
