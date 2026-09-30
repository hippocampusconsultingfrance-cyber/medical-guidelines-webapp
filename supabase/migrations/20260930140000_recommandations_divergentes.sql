-- Recommandations divergentes (cahier des charges V4.5, §4.4 ; checklist 2.2
-- « Encadré Recommandations divergentes quand deux sociétés divergent ») :
-- sur une même question clinique, la fiche présente séparément, pour chaque
-- société, la position, la date, la population, le grade et le niveau de
-- preuve, sans présenter une position comme meilleure, avec un avertissement
-- sur les différences de population ou de gradation.
--
--   - divergences : une question clinique et son avertissement ;
--   - divergence_positions : 2 à 4 positions, chacune rattachée à une fiche ;
--   - lecture par get_divergences(doc_id) seulement, pour un compte qui peut
--     lire la fiche (même contrôle que le contenu) ; tables lisibles
--     directement par l'équipe éditoriale ;
--   - écriture par le serveur (validateur ou administrateur).
-- Idempotent.

create table if not exists public.divergences (
  id uuid primary key default gen_random_uuid(),
  question text not null check (char_length(question) between 5 and 300),
  avertissement text check (char_length(avertissement) <= 1000),
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now()
);

create table if not exists public.divergence_positions (
  id uuid primary key default gen_random_uuid(),
  divergence_id uuid not null references public.divergences(id) on delete cascade,
  document_id uuid not null references public.documents(id) on delete cascade,
  position text not null check (char_length(position) between 3 and 1500),
  population text check (char_length(population) <= 300),
  grade text check (char_length(grade) <= 100),
  evidence_level text check (char_length(evidence_level) <= 100),
  sort_order int not null default 0,
  unique (divergence_id, document_id)
);
create index if not exists divergence_positions_document_idx on public.divergence_positions (document_id);

alter table public.divergences enable row level security;
alter table public.divergence_positions enable row level security;
revoke all on public.divergences, public.divergence_positions from public, anon, authenticated;
grant select on public.divergences, public.divergence_positions to authenticated;
grant all on public.divergences, public.divergence_positions to service_role;

drop policy if exists divergences_select_editorial on public.divergences;
create policy divergences_select_editorial on public.divergences for select
  to authenticated using (public.has_editorial_role('relecteur'));
drop policy if exists divergence_positions_select_editorial on public.divergence_positions;
create policy divergence_positions_select_editorial on public.divergence_positions for select
  to authenticated using (public.has_editorial_role('relecteur'));

-- Divergences d'une fiche, avec toutes leurs positions (y compris celles des
-- autres fiches, présentées côte à côte), si la fiche est lisible.
create or replace function public.get_divergences(doc_id uuid)
returns jsonb language sql stable security definer set search_path = public
as $$
  select case when public.can_read_document(doc_id) then coalesce((
    select jsonb_agg(jsonb_build_object(
      'id', d.id,
      'question', d.question,
      'avertissement', d.avertissement,
      'positions', (
        select jsonb_agg(jsonb_build_object(
          'document_id', p.document_id,
          'titre', coalesce(doc.card_json ->> 'title', doc.title),
          'societes', (
            select string_agg(s.acronym, ' / ' order by s.acronym)
            from public.document_societies ds join public.societies s on s.id = ds.society_id
            where ds.document_id = p.document_id
          ),
          'date', doc.publication_date,
          'position', p.position,
          'population', p.population,
          'grade', p.grade,
          'niveau', p.evidence_level
        ) order by p.sort_order, doc.publication_date desc nulls last)
        from public.divergence_positions p
        join public.documents doc on doc.id = p.document_id
        where p.divergence_id = d.id and public.document_is_visible(p.document_id)
      )
    ) order by d.created_at)
    from public.divergences d
    where exists (select 1 from public.divergence_positions x where x.divergence_id = d.id and x.document_id = doc_id)
  ), '[]'::jsonb) end;
$$;

revoke execute on function public.get_divergences(uuid) from public, anon;
grant execute on function public.get_divergences(uuid) to authenticated, service_role;
