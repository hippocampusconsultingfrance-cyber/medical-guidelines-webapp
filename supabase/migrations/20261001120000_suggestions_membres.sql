-- Suggestions des membres : à tout moment, depuis n'importe quelle page de
-- l'espace membre, un membre connecté signale un problème du site ou propose
-- une amélioration. L'administrateur les traite depuis le tableau de bord.
--
--   - un membre crée ses suggestions (auteur imposé par la base) et relit
--     les siennes ; il ne voit jamais celles des autres ;
--   - l'administrateur lit et change le statut par le serveur ;
--   - anti-spam : 10 suggestions par membre et par 24 h.
-- Idempotent.

create table if not exists public.site_suggestions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references public.profiles(id) on delete cascade,
  categorie text not null check (categorie in ('probleme', 'amelioration', 'contenu', 'autre')),
  page text check (char_length(page) <= 300),
  message text not null check (char_length(message) between 5 and 3000),
  status text not null default 'nouveau' check (status in ('nouveau', 'traite', 'rejete')),
  admin_note text check (char_length(admin_note) <= 1000),
  created_at timestamptz not null default now(),
  treated_at timestamptz
);
create index if not exists site_suggestions_status_idx on public.site_suggestions (status, created_at desc);
create index if not exists site_suggestions_user_idx on public.site_suggestions (user_id);

alter table public.site_suggestions enable row level security;
revoke all on public.site_suggestions from public, anon, authenticated;
grant select, insert on public.site_suggestions to authenticated;
grant all on public.site_suggestions to service_role;

drop policy if exists site_suggestions_insert_own on public.site_suggestions;
create policy site_suggestions_insert_own on public.site_suggestions for insert
  to authenticated with check (user_id = (select auth.uid()) and status = 'nouveau' and admin_note is null);
drop policy if exists site_suggestions_select_own on public.site_suggestions;
create policy site_suggestions_select_own on public.site_suggestions for select
  to authenticated using (user_id = (select auth.uid()) or public.is_admin());

create or replace function public.limiter_suggestions()
returns trigger language plpgsql security definer set search_path = public
as $$
begin
  if (select count(*) from public.site_suggestions
      where user_id = new.user_id and created_at > now() - interval '24 hours') >= 10 then
    raise exception 'Trop de suggestions en 24 heures' using errcode = '54000';
  end if;
  return new;
end;
$$;
revoke execute on function public.limiter_suggestions() from public, anon, authenticated;

drop trigger if exists limiter_suggestions on public.site_suggestions;
create trigger limiter_suggestions before insert on public.site_suggestions
  for each row execute function public.limiter_suggestions();
