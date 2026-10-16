-- Ouverture d'un paiement d'abonnement : une seule tentative à la fois par
-- membre. Un double clic, deux onglets ou deux requêtes simultanées ne
-- créent qu'une session de paiement Stripe (startCheckout,
-- src/app/abonnement/actions.ts) ; une nouvelle tentative est possible
-- 30 secondes plus tard. La date de réservation sert aussi de clé
-- d'idempotence auprès de Stripe.
-- Idempotent.

create table if not exists public.paiements_en_cours (
  user_id uuid primary key references auth.users (id) on delete cascade,
  reserve_le timestamptz not null default now()
);
-- Aucune règle d'accès : seule la fonction ci-dessous lit et écrit.
alter table public.paiements_en_cours enable row level security;
revoke all on table public.paiements_en_cours from anon, authenticated;

-- Réserve l'ouverture d'un paiement pour le membre connecté : renvoie la
-- date de réservation, ou null si une autre tentative a moins de 30 s.
create or replace function public.reserver_paiement()
returns timestamptz
language plpgsql
volatile
security definer
set search_path = public
as $fn$
declare
  uid uuid := auth.uid();
  le timestamptz;
begin
  if uid is null then
    raise exception 'Connexion requise' using errcode = '28000';
  end if;
  insert into public.paiements_en_cours as r (user_id, reserve_le)
  values (uid, clock_timestamp())
  on conflict (user_id) do update
     set reserve_le = excluded.reserve_le
   where r.reserve_le < clock_timestamp() - interval '30 seconds'
  returning r.reserve_le into le;
  return le;
end;
$fn$;
revoke all on function public.reserver_paiement() from public, anon;
grant execute on function public.reserver_paiement() to authenticated;
