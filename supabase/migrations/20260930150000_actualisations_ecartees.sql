-- Actualisations proposées (tableau de bord → « Actualisations à valider ») :
-- le site rapproche les fiches probablement remplacées par une version plus
-- récente (src/lib/actualisations.ts) ; un validateur confirme (la fiche
-- passe « remplacée ») ou écarte la proposition, qui n'est alors plus
-- présentée. Lecture : équipe éditoriale ; écriture : serveur. Idempotent.

create table if not exists public.actualisations_ecartees (
  ancienne_id uuid not null references public.documents(id) on delete cascade,
  nouvelle_id uuid not null references public.documents(id) on delete cascade,
  ecartee_par uuid references public.profiles(id) on delete set null,
  ecartee_le timestamptz not null default now(),
  primary key (ancienne_id, nouvelle_id)
);

alter table public.actualisations_ecartees enable row level security;
revoke all on public.actualisations_ecartees from public, anon, authenticated;
grant select on public.actualisations_ecartees to authenticated;
grant all on public.actualisations_ecartees to service_role;
drop policy if exists actualisations_ecartees_select on public.actualisations_ecartees;
create policy actualisations_ecartees_select on public.actualisations_ecartees for select
  to authenticated using (public.has_editorial_role('relecteur'));
