# Medical Guidelines — site web

Site authentifié de **medical-guidelines.net** : inscription et connexion des
professionnels de santé, puis accès aux fiches de synthèse des
recommandations (SFAR, SRLF, HAS…).

- Framework : Next.js 16 (App Router), déployé sur Vercel.
- Base de données et authentification : Supabase (projet hébergé à
  Francfort).
- Fiches : `public/fiches/index.html`, généré dans le dépôt
  `rfe-sfar-website` et synchronisé ici. `npm run build` le prépare
  automatiquement (`scripts/prepare-fiches.mjs` : doctype, affichage mobile,
  bouton « Signaler une erreur » branché sur la base).

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
- `supabase/migrations/` : évolutions, à appliquer dans l'ordre des noms de
  fichier. Ne jamais modifier la base de production sans relecture.

## Pages

| Route | Rôle |
|---|---|
| `/inscription`, `/finaliser-compte` | Création du compte (code par email, puis mot de passe) |
| `/connexion`, `/mot-de-passe-oublie`, `/nouveau-mot-de-passe` | Connexion et réinitialisation |
| `/` | Accueil connecté, accès aux fiches |
| `/compte` | Droits RGPD : rectification, consentement, export, suppression |
| `/cgu`, `/confidentialite` | Textes légaux |
| `/api/signalements` | Signalements d'erreurs sur les fiches |

## Audit

Dernier audit complet : `docs/audit/AUDIT_2026-09-28.md`.
