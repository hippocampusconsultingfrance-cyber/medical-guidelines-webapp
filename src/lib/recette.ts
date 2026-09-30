// Checklist de recette (cahier des charges V4.5, document 3/3) : critères
// à vérifier, dater et signer par le porteur de projet avant l'ouverture
// commerciale. Texte repris de docs/cahier-des-charges/V4.5_3_Checklist_de_recette.txt.

export type Critere = {
  code: string;
  rubrique: string;
  critere: string;
  verif: string;
};

export const RECETTE: Critere[] = [
  {
    code: "1.1-1",
    rubrique: "1.1 Parcours complet (mobile et ordinateur)",
    critere:
      "Inscription → e-mail confirmé (par code et par lien) → 1 à 5 fiches débloquées → quota atteint → paiement → accès à toute la spécialité → résiliation",
    verif:
      "Test automatique de bout en bout + test manuel sur iOS Safari, Android Chrome et un navigateur d’ordinateur",
  },
  {
    code: "1.1-2",
    rubrique: "1.1 Parcours complet (mobile et ordinateur)",
    critere: "Le lien reçu par e-mail fonctionne même ouvert deux fois",
    verif:
      "Ouvrir deux fois le même lien de confirmation et de mot de passe oublié",
  },
  {
    code: "1.1-3",
    rubrique: "1.1 Parcours complet (mobile et ordinateur)",
    critere: "Mot de passe oublié fonctionne de bout en bout",
    verif: "Demande, e-mail reçu, nouveau mot de passe, connexion",
  },
  {
    code: "1.2-1",
    rubrique: "1.2 Compte gratuit (CDC §5)",
    critere:
      "Un 6ᵉ déblocage est refusé, y compris par appel direct au serveur",
    verif: "Test automatique : appel de la fonction de déblocage une 6ᵉ fois",
  },
  {
    code: "1.2-2",
    rubrique: "1.2 Compte gratuit (CDC §5)",
    critere: "Une fiche débloquée reste consultable et n’est pas recomptée",
    verif: "Rouvrir une fiche déjà débloquée : compteur inchangé",
  },
  {
    code: "1.2-3",
    rubrique: "1.2 Compte gratuit (CDC §5)",
    critere: "Confirmation affichée avant chaque déblocage",
    verif: "Test manuel",
  },
  {
    code: "1.2-4",
    rubrique: "1.2 Compte gratuit (CDC §5)",
    critere: "Compteur « x/5 » visible et exact",
    verif: "Test manuel",
  },
  {
    code: "1.2-5",
    rubrique: "1.2 Compte gratuit (CDC §5)",
    critere:
      "Une recommandation ouverte depuis la recherche compte pour sa fiche",
    verif: "Rechercher, ouvrir, vérifier le compteur",
  },
  {
    code: "1.2-6",
    rubrique: "1.2 Compte gratuit (CDC §5)",
    critere:
      "Les pages publiques ne consomment aucun quota et n’exposent pas le contenu premium",
    verif:
      "Consulter une page publique sans compte ; vérifier le code source de la page",
  },
  {
    code: "1.3-1",
    rubrique: "1.3 Spécialité et droits (CDC §5.3)",
    critere:
      "Un compte ne peut pas lire le contenu premium d’une autre spécialité",
    verif: "Test automatique d’accès croisé",
  },
  {
    code: "1.3-2",
    rubrique: "1.3 Spécialité et droits (CDC §5.3)",
    critere: "Aucun contenu premium n’est envoyé au navigateur sans droits",
    verif:
      "Inspecter les réponses du serveur d’un compte gratuit sur une fiche non débloquée",
  },
  {
    code: "1.3-3",
    rubrique: "1.3 Spécialité et droits (CDC §5.3)",
    critere:
      "Aucune fiche n’est accessible sans session (redirection vers la connexion)",
    verif: "Test automatique quotidien",
  },
  {
    code: "2.1-1",
    rubrique: "2.1 Verrou de publication (CDC §9.2)",
    critere:
      "Publication refusée sans URL source, sans date, sans statut juridique validé",
    verif: "Tenter de publier une fiche incomplète pour chaque condition",
  },
  {
    code: "2.1-2",
    rubrique: "2.1 Verrou de publication (CDC §9.2)",
    critere:
      "Publication d’une traduction refusée sans autorisation de traduction ni relecture de la langue",
    verif: "Test sur une fiche de test",
  },
  {
    code: "2.1-3",
    rubrique: "2.1 Verrou de publication (CDC §9.2)",
    critere: "Aucun grade vide : valeur de la source ou « non indiqué »",
    verif: "Contrôle automatique à l’import",
  },
  {
    code: "2.2-1",
    rubrique: "2.2 Fiche (CDC §6.2)",
    critere: "Points clés (3 à 5) en tête de fiche",
    verif: "Revue de 5 fiches au hasard",
  },
  {
    code: "2.2-2",
    rubrique: "2.2 Fiche (CDC §6.2)",
    critere: "Mention « Relue par Dr …, le … »",
    verif: "Revue de 5 fiches",
  },
  {
    code: "2.2-3",
    rubrique: "2.2 Fiche (CDC §6.2)",
    critere: "Dernière et prochaine vérification affichées",
    verif: "Revue de 5 fiches",
  },
  {
    code: "2.2-4",
    rubrique: "2.2 Fiche (CDC §6.2)",
    critere: "Avertissement d’ancienneté au-delà de 10 ans",
    verif: "Fiche d’un document de plus de 10 ans",
  },
  {
    code: "2.2-5",
    rubrique: "2.2 Fiche (CDC §6.2)",
    critere:
      "Encadré « Recommandations divergentes » quand deux sociétés divergent",
    verif: "Fiche de test reliée à une recommandation divergente",
  },
  {
    code: "2.2-6",
    rubrique: "2.2 Fiche (CDC §6.2)",
    critere: "Filigrane personnalisé visible sur 100 % des fiches premium",
    verif: "Ordinateur et mobile",
  },
  {
    code: "2.2-7",
    rubrique: "2.2 Fiche (CDC §6.2)",
    critere: "Aucun export, téléchargement ni impression du contenu premium",
    verif: "Tenter l’impression et l’enregistrement de la page",
  },
  {
    code: "2.3-1",
    rubrique: "2.3 Ordre de traitement et langues (CDC §4.2, §7)",
    critere:
      "La file de travail et l’import sont triés du plus récent au plus ancien",
    verif: "Contrôle de la file et du compte rendu de session de la routine",
  },
  {
    code: "2.3-2",
    rubrique: "2.3 Ordre de traitement et langues (CDC §4.2, §7)",
    critere:
      "Une fiche française validée peut être publiée sans attendre l’anglais",
    verif: "Test sur une fiche de test",
  },
  {
    code: "2.3-3",
    rubrique: "2.3 Ordre de traitement et langues (CDC §4.2, §7)",
    critere: "La version anglaise n’est publiée qu’après relecture",
    verif: "Test sur une fiche de test",
  },
  {
    code: "2.4-1",
    rubrique: "2.4 Qualité et corrections (CDC §9.3, §9.4)",
    critere:
      "Un signalement d’erreur est enregistré et visible dans le back-office",
    verif: "Signaler une erreur depuis une fiche",
  },
  {
    code: "2.4-2",
    rubrique: "2.4 Qualité et corrections (CDC §9.3, §9.4)",
    critere: "Une erreur critique peut entraîner une dépublication immédiate",
    verif: "Test de dépublication",
  },
  {
    code: "2.4-3",
    rubrique: "2.4 Qualité et corrections (CDC §9.3, §9.4)",
    critere:
      "La correction apparaît dans le journal public, sans donnée personnelle",
    verif: "Corriger une fiche de test",
  },
  {
    code: "3.1-1",
    rubrique: "3.1 Cycle mensuel (CDC §8)",
    critere:
      "Un cycle complet a été exécuté sur l’environnement de test : détection, brouillons français et anglais, validation, e-mail, compte rendu",
    verif: "Journal watch_runs + e-mail d’essai reçu par l’administrateur",
  },
  {
    code: "3.1-2",
    rubrique: "3.1 Cycle mensuel (CDC §8)",
    critere: "Aucun e-mail n’est envoyé aux membres sans validation humaine",
    verif: "Vérifier qu’un brouillon non validé ne déclenche aucun envoi",
  },
  {
    code: "3.1-3",
    rubrique: "3.1 Cycle mensuel (CDC §8)",
    critere:
      "Mois sans nouveauté : aucun e-mail aux membres, compte rendu envoyé au porteur de projet",
    verif: "Simulation",
  },
  {
    code: "3.1-4",
    rubrique: "3.1 Cycle mensuel (CDC §8)",
    critere:
      "L’e-mail contient le lien vers la fiche sur le site et le lien vers la source",
    verif: "Lecture de l’e-mail d’essai",
  },
  {
    code: "3.1-5",
    rubrique: "3.1 Cycle mensuel (CDC §8)",
    critere: "Lien de désinscription fonctionnel et préférence respectée",
    verif: "Se désinscrire puis relancer un envoi d’essai",
  },
  {
    code: "3.1-6",
    rubrique: "3.1 Cycle mensuel (CDC §8)",
    critere:
      "Alerte envoyée quand une fiche consultée ou favorite est mise à jour",
    verif: "Mettre à jour une fiche de test",
  },
  {
    code: "3.1-7",
    rubrique: "3.1 Cycle mensuel (CDC §8)",
    critere: "Capacité du service d’envoi adaptée au nombre de membres",
    verif: "Vérifier l’offre Resend",
  },
  {
    code: "4.1-1",
    rubrique: "4.1 Paiement (CDC §10)",
    critere: "Paiement annuel de 50 € TTC en mode test Stripe",
    verif: "Test automatique",
  },
  {
    code: "4.1-2",
    rubrique: "4.1 Paiement (CDC §10)",
    critere:
      "Facture conforme avec identité de l’éditeur, SIREN et TVA selon le pays",
    verif:
      "Paiement test depuis la France et depuis un autre pays de l’UE, avec et sans numéro de TVA",
  },
  {
    code: "4.1-3",
    rubrique: "4.1 Paiement (CDC §10)",
    critere: "CGV acceptées par case à cocher ; version et date conservées",
    verif: "Contrôle en base",
  },
  {
    code: "4.1-4",
    rubrique: "4.1 Paiement (CDC §10)",
    critere:
      "Case distincte de renonciation au droit de rétractation, confirmée dans l’e-mail de commande",
    verif: "Test manuel",
  },
  {
    code: "4.1-5",
    rubrique: "4.1 Paiement (CDC §10)",
    critere:
      "Résiliation : accès maintenu jusqu’à la fin de l’année payée, puis retour au gratuit",
    verif: "Simulation de fin de période",
  },
  {
    code: "4.1-6",
    rubrique: "4.1 Paiement (CDC §10)",
    critere:
      "Hausse de tarif : e-mail 30 jours avant le renouvellement avec lien de résiliation",
    verif: "Simulation",
  },
  {
    code: "4.2-1",
    rubrique: "4.2 Réductions (CDC §10.2)",
    critere:
      "Code FONDATEURS : -30 % la 1ʳᵉ année, refusé après 100 utilisations",
    verif: "Test automatique",
  },
  {
    code: "4.2-2",
    rubrique: "4.2 Réductions (CDC §10.2)",
    critere: "Code étudiant personnel : -30 %, usage unique",
    verif: "Test automatique",
  },
  {
    code: "4.2-3",
    rubrique: "4.2 Réductions (CDC §10.2)",
    critere: "Non-cumul : une seule réduction appliquée",
    verif: "Tenter deux codes",
  },
  {
    code: "4.2-4",
    rubrique: "4.2 Réductions (CDC §10.2)",
    critere: "Renouvellement au tarif normal alors en vigueur",
    verif: "Simulation",
  },
  {
    code: "5.1-1",
    rubrique: "5.1 Mentions légales et RGPD (CDC §12)",
    critere:
      "Vérification finale des informations légales de l’éditeur (Kbis à jour)",
    verif: "Contrôle par le porteur de projet",
  },
  {
    code: "5.1-2",
    rubrique: "5.1 Mentions légales et RGPD (CDC §12)",
    critere: "Page « Mentions légales » publiée et complète",
    verif: "Lecture de la page",
  },
  {
    code: "5.1-3",
    rubrique: "5.1 Mentions légales et RGPD (CDC §12)",
    critere: "Adresse contact@medical-guidelines.net opérationnelle",
    verif: "Envoyer un e-mail de test",
  },
  {
    code: "5.1-4",
    rubrique: "5.1 Mentions légales et RGPD (CDC §12)",
    critere:
      "Politique de confidentialité : sous-traitants et localisation listés",
    verif: "Lecture de la page",
  },
  {
    code: "5.1-5",
    rubrique: "5.1 Mentions légales et RGPD (CDC §12)",
    critere:
      "« Mon compte » : rectification, retrait du consentement, export, suppression",
    verif: "Test manuel (en production depuis le 28/09/2026)",
  },
  {
    code: "5.1-6",
    rubrique: "5.1 Mentions légales et RGPD (CDC §12)",
    critere:
      "Mesure d’audience sans cookies ; aucune ressource chargée depuis un service tiers sans nécessité",
    verif:
      "Outils de développement du navigateur : aucun cookie de mesure, aucun appel à Google Fonts",
  },
  {
    code: "5.1-7",
    rubrique: "5.1 Mentions légales et RGPD (CDC §12)",
    critere:
      "CGV validées par un conseil juridique ; médiateur de la consommation désigné",
    verif: "Document signé",
  },
  {
    code: "5.2-1",
    rubrique: "5.2 Sécurité (ST §5, §6)",
    critere: "En-têtes de sécurité présents sur toutes les pages",
    verif: "Test automatique",
  },
  {
    code: "5.2-2",
    rubrique: "5.2 Sécurité (ST §5, §6)",
    critere: "Analyse de sécurité Supabase sans alerte nouvelle",
    verif: "Revue mensuelle",
  },
  {
    code: "5.2-3",
    rubrique: "5.2 Sécurité (ST §5, §6)",
    critere:
      "Détection d’extraction : blocage temporaire après un rythme anormal",
    verif: "Simulation",
  },
  {
    code: "5.2-4",
    rubrique: "5.2 Sécurité (ST §5, §6)",
    critere: "Dépôts de code privés",
    verif: "Contrôle GitHub",
  },
  {
    code: "6.1-1",
    rubrique: "6.1 Environnements et surveillance (ST §7)",
    critere: "Supabase en offre payante (pas de mise en pause, sauvegardes)",
    verif: "Tableau de bord Supabase",
  },
  {
    code: "6.1-2",
    rubrique: "6.1 Environnements et surveillance (ST §7)",
    critere: "Restauration d’une sauvegarde testée et documentée",
    verif: "Procédure de test",
  },
  {
    code: "6.1-3",
    rubrique: "6.1 Environnements et surveillance (ST §7)",
    critere: "Une panne simulée déclenche une alerte e-mail",
    verif: "Couper l’environnement de test",
  },
  {
    code: "6.1-4",
    rubrique: "6.1 Environnements et surveillance (ST §7)",
    critere: "Une erreur simulée remonte dans Sentry",
    verif: "Erreur de test",
  },
  {
    code: "6.1-5",
    rubrique: "6.1 Environnements et surveillance (ST §7)",
    critere:
      "Tests de bout en bout et intégration continue au vert avant mise en production",
    verif: "GitHub Actions",
  },
  {
    code: "6.1-6",
    rubrique: "6.1 Environnements et surveillance (ST §7)",
    critere: "Connecteur Vercel autorisé pour la supervision",
    verif: "Test de lecture des déploiements",
  },
  {
    code: "6.2-1",
    rubrique: "6.2 Organisation (CDC §14)",
    critere: "Chaque dépôt ne compte que main + au plus une branche de travail",
    verif: "Contrôle GitHub",
  },
  {
    code: "6.2-2",
    rubrique: "6.2 Organisation (CDC §14)",
    critere: "Rendez-vous hebdomadaire en place, avec synthèse de la routine",
    verif: "Première synthèse reçue",
  },
  {
    code: "6.2-3",
    rubrique: "6.2 Organisation (CDC §14)",
    critere: "Mesure du tunnel de conversion opérationnelle",
    verif: "Tableau de bord d’audience",
  },
];
