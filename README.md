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

```bash
npm ci
cp .env.example .env.local   # puis renseigner les deux variables
npm run dev
```

Variables d'environnement (publiques, côté navigateur) :

- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`

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

## Pages

| Route | Rôle |
|---|---|
| `/inscription`, `/finaliser-compte` | Création du compte (code par email, puis mot de passe) |
| `/connexion`, `/mot-de-passe-oublie`, `/nouveau-mot-de-passe` | Connexion et réinitialisation |
| `/` | Accueil public (visiteur) ou espace membre (connecté) |
| `/bibliotheque`, `/bibliotheque/[id]` | Catalogue et fiches (crédits, filigrane, signalement d'erreur, publication) |
| `/bibliotheque/signalements` | Tableau de bord des signalements (administrateur) |
| `/mentions-legales` | Mentions légales |
| `/compte` | Droits RGPD : rectification, consentement, export, suppression |
| `/cgu`, `/confidentialite` | Textes légaux |
| `/api/signalements` | Signalements d'erreurs sur les fiches |

## Audit

Dernier audit complet : `docs/audit/AUDIT_2026-09-28.md`.
