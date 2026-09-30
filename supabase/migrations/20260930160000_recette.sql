-- Recette avant ouverture commerciale (cahier des charges V4.5, document
-- 3/3 : « Chaque ligne doit être cochée, datée et signée par le porteur de
-- projet ») : une ligne par critère vérifié (code du critère, date, auteur,
-- remarque). Lecture et écriture : administrateurs, par le serveur.
-- Idempotent.

create table if not exists public.recette_validations (
  code text primary key check (code ~ '^[0-9]+\.[0-9]+-[0-9]+$'),
  validated_at timestamptz not null default now(),
  validated_by uuid references public.profiles(id) on delete set null,
  note text check (char_length(note) <= 500)
);

alter table public.recette_validations enable row level security;
revoke all on public.recette_validations from public, anon, authenticated;
grant select on public.recette_validations to authenticated;
grant all on public.recette_validations to service_role;
drop policy if exists recette_validations_select_admin on public.recette_validations;
create policy recette_validations_select_admin on public.recette_validations for select
  to authenticated using (public.is_admin());
