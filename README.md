# Medical Guidelines — site web

Site authentifié de **medical-guidelines.net** : inscription et connexion des
professionnels de santé, puis accès aux fiches de synthèse des
recommandations (SFAR, SRLF, HAS…).

- Framework : Next.js 16 (App Router), déployé sur Vercel.
- Base de données et authentification : Supabase (projet hébergé à
  Francfort).
- Fiches : produites dans le dépôt `rfe-sfar-website` (l'atelier), chargées
  dans la base par `scripts/import-atelier.mjs` puis l'outil d'import, et
  affichées par la bibliothèque (`/bibliotheque`) : bloquées par défaut,
  5 crédits pour un compte gratuit, tout ouvert pour PREMIUM.

## Développement

Node 24 (comme le projet Vercel : `.nvmrc`, `engines` de `package.json`,
GitHub Actions).

```bash
npm ci
cp .env.example .env.local   # puis renseigner les deux variables
npm run dev
```

Variables d'environnement (publiques, côté navigateur) :

- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`

Variables serveur (Vercel uniquement, jamais exposées au navigateur) :

- `SUPABASE_SERVICE_ROLE_KEY` : webhook Stripe, tâches planifiées,
  désinscription, aperçu public des fiches
- `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `STRIPE_PRICE_ID` : paiement
  PREMIUM (voir `src/lib/stripe.ts`) ; `STRIPE_PORTAL_CONFIG_ID` (portail
  client), `STRIPE_TAX=1` (Stripe Tax) ou `STRIPE_TAX_RATE_ID` (TVA fixe),
  `STRIPE_STUDENT_COUPON_ID` (remise étudiante). Contrôle :
  `/abonnement/verification` (administrateur)
- `RESEND_API_KEY` : envoi des e-mails (sans clé, aucun envoi)
- `ALERTS_FROM` (facultatif) : expéditeur des alertes, par défaut
  `medical-guidelines.net <alertes@medical-guidelines.net>` (domaine à
  vérifier dans Resend)
- `ALERTS_REPLY_TO` (facultatif) : adresse de réponse des alertes, par défaut
  `contact@medical-guidelines.net` (doit pouvoir recevoir des e-mails)
- `SITE_URL` (facultatif) : adresse du site dans les e-mails, par défaut
  `https://www.medical-guidelines.net` (le domaine nu y redirige)
- `CRON_SECRET` : secret des tâches planifiées (Vercel l'envoie
  automatiquement à chaque `/api/cron/…`)
- `ANTHROPIC_API_KEY`, `ASSISTANT_MODEL` (facultatif) : assistant IA ;
  `ASSISTANT_PUBLIC=1` l'ouvre aux membres (sinon équipe éditoriale seule)
- `NEXT_PUBLIC_SENTRY_DSN` (facultatif) : suivi des erreurs, actif en
  production seulement ; données personnelles retirées avant envoi
  (`src/lib/sentry.ts`)

Vérifications (lancées aussi par GitHub Actions sur chaque PR) :

```bash
npm run lint
npm run typecheck
npm run build
```

## Base de données

- `supabase/schema.sql` : schéma initial (profils, création automatique du
  profil à l'inscription).
- `supabase/schema_v2.sql`, `supabase/schema_v3.sql` : modèle de données cible
  (installés en production le 28/09/2026).
- `supabase/migrations/` : évolutions de **structure** uniquement, à appliquer
  dans l'ordre des noms de fichier. Ne jamais modifier la base de production
  sans relecture.
- `supabase/content/` : **contenu clinique** (une fiche par script, en
  brouillon), chargé par l'outil d'import, jamais par les migrations.
  Suivi : `supabase/content/SUIVI_CONTENU.md`.

## Import du contenu

```bash
npm run import:content                              # aperçu de l'ordre
DATABASE_URL=... npm run import:content -- --apply  # import
```

Ordre obligatoire : du document le plus récent au plus ancien. Tout reste en
brouillon ; l'outil refuse un script qui publierait directement. En
production : GitHub → Actions → « Importer le contenu » → Run workflow
(secret `SUPABASE_DB_URL` requis).

## Vérification des fiches par IA (pilote)

```bash
DATABASE_URL=... npm run verifier:fiches -- --sans-ia remplissage sdra   # chiffres seulement
DATABASE_URL=... ANTHROPIC_API_KEY=... GEMINI_API_KEY=... npm run verifier:fiches -- remplissage sdra
```

Chaque unité d'une fiche publiée (ligne de tableau, paragraphe, encadré) est
comparée à sa source officielle : contrôle des chiffres sans IA, puis verdict
de Claude et de Gemini, chacune sans voir la réponse de l'autre, avec un
extrait de la source revérifié mot pour mot. Le rapport (`rapport.md`) classe
les unités en rouge, orange ou vert pour orienter la relecture ; il ne valide
rien et n'écrit rien en base. En production : GitHub → Actions → « Vérifier
les fiches (IA) » → Run workflow (secrets `SUPABASE_DB_URL`,
`ANTHROPIC_API_KEY`, `GEMINI_API_KEY`) ; le rapport est joint à l'exécution.
Nécessite `psql` et `pdftotext` (poppler).

## Tâches planifiées

Déclarées dans `vercel.json` (heures UTC), authentifiées par `CRON_SECRET` :

| Route | Fréquence | Rôle |
|---|---|---|
| `/api/cron/purge` | tous les jours, 3 h 40 | Durées de conservation (journal de lecture, comptes inactifs) |
| `/api/cron/liens` | lundi, 4 h 30 | Vérification des liens vers les sources officielles |
| `/api/cron/synthese` | lundi, 5 h 50 | Synthèse hebdomadaire aux administrateurs |
| `/api/cron/alertes` | tous les jours, 6 h 10 | Alertes e-mail (ci-dessous) |
| `/api/cron/relances` | tous les jours, 8 h 20 | Relances (inscription, première fiche, crédits épuisés) et avis de renouvellement |

`?apercu=1` (alertes, relances, synthèse) montre ce qui serait envoyé sans
rien envoyer. Surveillance horaire du site et de la base :
`.github/workflows/surveillance.yml` (`/api/sante`).

## Alertes e-mail

Tâche planifiée Vercel (`vercel.json`), tous les jours à 6 h 10 UTC :
`/api/cron/alertes` envoie à chaque abonné PREMIUM (et aux comptes de
l'équipe éditoriale, pour les essais) un seul e-mail regroupant :

- les fiches publiées par les sociétés qu'il suit, dans sa spécialité ;
- les nouvelles versions (`document_versions.published_at`) des fiches qu'il
  a débloquées, mises en favori ou consultées.

Destinataires et déduplication sont décidés par la base
(`pending_email_alerts()`) ; chaque envoi est tracé dans `notifications_log`.
Aperçu sans envoi : `curl -H "Authorization: Bearer $CRON_SECRET"
"https://…/api/cron/alertes?apercu=1"`. Désinscription : lien et en-tête
« List-Unsubscribe » de chaque e-mail, ou « Mon compte ».

## Pages

| Route | Rôle |
|---|---|
| `/inscription`, `/finaliser-compte` | Création du compte (code par email, puis mot de passe) |
| `/connexion`, `/mot-de-passe-oublie`, `/nouveau-mot-de-passe` | Connexion et réinitialisation |
| `/` | Accueil public (visiteur) ou espace membre (connecté : fiches mises à jour, nouveautés de l'année par société savante, plus consultées, favoris, lecture en cours, crédits ou abonnement, sociétés suivies) |
| `/bibliotheque`, `/bibliotheque/[id]` | Catalogue (filtres `q`, `societe`, `annee`) et fiches (crédits, filigrane, signalement d'erreur, publication) |
| `/bibliotheque/signalements` | Tableau de bord des signalements (administrateur) |
| `/mentions-legales` | Mentions légales |
| `/compte` | Droits RGPD : rectification, consentement, export, suppression ; alertes e-mail |
| `/alertes/desinscription` | Désinscription des alertes e-mail (lien des e-mails) |
| `/cgu`, `/confidentialite` | Textes légaux |
| `/api/signalements` | Signalements d'erreurs sur les fiches |
| `/api/cron/…` | Tâches planifiées (voir ci-dessus) |
| `/api/stripe/webhook` | Notifications Stripe (abonnements) |
| `/api/sante` | État du site et de la base (surveillance) |

## Audit

Dernier audit complet : `docs/audit/AUDIT_2026-09-28.md`.
