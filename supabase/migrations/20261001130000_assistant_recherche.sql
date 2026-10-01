-- Assistant de recherche (bêta) : compteur des questions posées, pour la
-- limite quotidienne par membre. Ni la question ni la réponse ne sont
-- conservées (aucune donnée clinique stockée). Écriture et lecture par le
-- serveur uniquement.
-- Idempotent.

create table if not exists public.assistant_usage (
  id bigint generated always as identity primary key,
  user_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  extraits int not null default 0,
  refus boolean not null default false
);
create index if not exists assistant_usage_user_idx on public.assistant_usage (user_id, created_at desc);

alter table public.assistant_usage enable row level security;
revoke all on public.assistant_usage from public, anon, authenticated;
grant all on public.assistant_usage to service_role;
