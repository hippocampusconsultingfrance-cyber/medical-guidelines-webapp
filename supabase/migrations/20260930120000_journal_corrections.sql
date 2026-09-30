-- Journal public des corrections (cahier des charges V4.5, §9.4 ; checklist
-- 2.4 « La correction apparaît dans le journal public, sans donnée
-- personnelle ») : date, fiche, criticité, résumé de la modification ;
-- accessible depuis chaque fiche et depuis le site, y compris sans compte.
--
--   - corrections_log : une ligne par correction publiée par un
--     administrateur (souvent à la suite d'un signalement validé) ;
--   - lecture publique des seules colonnes date, fiche, criticité, résumé,
--     et seulement pour une fiche en ligne : ni l'auteur de la correction ni
--     le signalement d'origine (donc ni son déclarant) ne sont exposés ;
--   - écriture par le serveur uniquement (clé service_role, après contrôle
--     du rôle administrateur).
-- Idempotent.

create table if not exists public.corrections_log (
  id uuid primary key default gen_random_uuid(),
  document_id uuid not null references public.documents(id) on delete cascade,
  corrected_at date not null default current_date,
  criticite text not null check (criticite in ('mineure', 'majeure', 'critique')),
  resume text not null check (char_length(resume) between 5 and 1000),
  error_report_id uuid references public.error_reports(id) on delete set null,
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now()
);
create index if not exists corrections_log_document_idx on public.corrections_log (document_id, corrected_at desc);
create index if not exists corrections_log_date_idx on public.corrections_log (corrected_at desc);

-- Fiche en ligne : publiée et non retirée.
create or replace function public.document_is_public(doc_id uuid)
returns boolean language sql stable security definer set search_path = public
as $$
  select exists (
    select 1 from public.documents d
    where d.id = doc_id and d.published_at is not null and d.freshness_status <> 'retiree'
  );
$$;
grant execute on function public.document_is_public(uuid) to anon, authenticated, service_role;

alter table public.corrections_log enable row level security;
revoke all on public.corrections_log from public, anon, authenticated;
grant select (id, document_id, corrected_at, criticite, resume) on public.corrections_log to anon, authenticated;
grant all on public.corrections_log to service_role;

drop policy if exists corrections_log_select_public on public.corrections_log;
create policy corrections_log_select_public on public.corrections_log for select
  to anon, authenticated
  using (public.document_is_public(document_id));
drop policy if exists corrections_log_select_admin on public.corrections_log;
create policy corrections_log_select_admin on public.corrections_log for select
  to authenticated
  using (public.is_admin());
