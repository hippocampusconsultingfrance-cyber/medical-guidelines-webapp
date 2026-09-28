-- Abonnement PREMIUM payé par Stripe (cahier des charges V4.5, §10).
--
--   - plan « premium » (50 € TTC / an) ajouté aux plans autorisés ;
--   - preuve de l'acceptation des CGV (version, date) et de la demande
--     d'exécution immédiate avec renonciation au droit de rétractation
--     (§10.3), recopiées depuis la session de paiement ;
--   - une souscription Stripe correspond à une seule ligne.
-- Les lignes sont écrites uniquement par le serveur (webhook Stripe, clé
-- service_role) : la règle d'accès subscriptions_write_admin interdit toute
-- écriture par un membre (migration 20260928220000). Idempotent.

alter table public.subscriptions drop constraint if exists subscriptions_plan_check;
alter table public.subscriptions add constraint subscriptions_plan_check
  check (plan in ('premium', 'professional', 'essential', 'paramedical', 'institution'));

alter table public.subscriptions add column if not exists cgv_version text;
alter table public.subscriptions add column if not exists cgv_accepted_at timestamptz;
alter table public.subscriptions add column if not exists withdrawal_waiver_at timestamptz;
alter table public.subscriptions add column if not exists updated_at timestamptz not null default now();

create unique index if not exists subscriptions_stripe_subscription_id_key
  on public.subscriptions (stripe_subscription_id)
  where stripe_subscription_id is not null;
