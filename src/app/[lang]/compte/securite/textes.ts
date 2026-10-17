import type { Traductions } from "@/i18n/serveur";

// Double authentification : réglage (Mon compte) et saisie du code à la
// connexion (/mfa).
export type TextesSecurite = (typeof SECURITE)["fr"];

const fr = {
  titreMeta: "Double authentification — medical-guidelines.net",
  obligatoire:
    "Votre compte fait partie de l'équipe éditoriale : la double authentification est obligatoire. Activez-la ci-dessous pour retrouver vos droits de relecture et d'administration.",
  nomFacteur: "Téléphone",
  erreurDemarrage: "L'activation n'a pas pu démarrer. Réessayez dans un instant.",
  codeIncorrect: "Code incorrect ou expiré : saisissez le code affiché maintenant dans l'application.",
  activee: "Double authentification activée. Le code vous sera demandé à chaque nouvelle connexion.",
  confirmerDesactivation:
    "Désactiver la double authentification ? Votre compte sera moins protégé ; pour l'équipe éditoriale, les droits d'équipe seront suspendus.",
  desactivationImpossible: "Désactivation impossible : saisissez d'abord votre code (reconnexion), puis réessayez.",
  desactivee: "Double authentification désactivée.",
  monCompte: "← Mon compte",
  titre: "Double authentification",
  intro:
    "En plus du mot de passe, un code à 6 chiffres donné par une application de votre téléphone (Google Authenticator, Microsoft Authenticator, ou l'app Mots de passe de l'iPhone). Même si votre mot de passe était volé, personne ne pourrait se connecter sans votre téléphone.",
  chargement: "Chargement…",
  etatActivee: "✓ Activée",
  application: "Application d'authentification",
  depuis: " — depuis le {date}",
  desactiver: "Désactiver",
  etape1:
    "1. Dans l'application, ajoutez un compte en scannant ce QR code (sur iPhone : réglages Mots de passe → « Configurer un code de validation »).",
  qrAlt: "QR code de double authentification",
  cle: "Sans appareil photo, saisissez cette clé :",
  etape2: "2. Saisissez le code à 6 chiffres affiché par l'application",
  activer: "Activer",
  activerDouble: "Activer la double authentification",
  mfa: {
    titreMeta: "Code de sécurité — medical-guidelines.net",
    titre: "Code de sécurité",
    intro:
      "Votre compte est protégé par la double authentification : saisissez le code affiché par votre application.",
    libelle: "Code à 6 chiffres de votre application d'authentification",
    valider: "Valider",
  },
};

export const SECURITE: Traductions<typeof fr> = {
  fr,
  en: {
    titreMeta: "Two-factor authentication — medical-guidelines.net",
    obligatoire:
      "Your account belongs to the editorial team: two-factor authentication is mandatory. Turn it on below to recover your review and administration rights.",
    nomFacteur: "Phone",
    erreurDemarrage: "Activation could not start. Please try again in a moment.",
    codeIncorrect: "Incorrect or expired code: enter the code currently shown in the app.",
    activee: "Two-factor authentication turned on. The code will be requested at each new sign-in.",
    confirmerDesactivation:
      "Turn off two-factor authentication? Your account will be less protected; for the editorial team, team rights will be suspended.",
    desactivationImpossible: "Cannot turn it off: first enter your code (sign in again), then try again.",
    desactivee: "Two-factor authentication turned off.",
    monCompte: "← My account",
    titre: "Two-factor authentication",
    intro:
      "In addition to your password, a 6-digit code given by an app on your phone (Google Authenticator, Microsoft Authenticator, or the iPhone Passwords app). Even if your password were stolen, nobody could sign in without your phone.",
    chargement: "Loading…",
    etatActivee: "✓ On",
    application: "Authenticator app",
    depuis: " — since {date}",
    desactiver: "Turn off",
    etape1:
      "1. In the app, add an account by scanning this QR code (on iPhone: Passwords settings → “Set Up Verification Code”).",
    qrAlt: "Two-factor authentication QR code",
    cle: "Without a camera, enter this key:",
    etape2: "2. Enter the 6-digit code shown by the app",
    activer: "Turn on",
    activerDouble: "Turn on two-factor authentication",
    mfa: {
      titreMeta: "Security code — medical-guidelines.net",
      titre: "Security code",
      intro: "Your account is protected by two-factor authentication: enter the code shown by your app.",
      libelle: "6-digit code from your authenticator app",
      valider: "Confirm",
    },
  },
};
