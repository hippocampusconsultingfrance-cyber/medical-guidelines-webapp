-- Recherche dans le contenu des fiches (cahier des charges V4.5 : recherche
-- instantanée).
--
--   - documents.search_tsv : index plein texte (français, sans accents) du
--     titre, de la carte et du contenu mis en page (balises et clés JSON
--     retirées). Colonne NON lisible par anon/authenticated (elle révélerait
--     le contenu) : aucune permission de lecture n'est accordée ;
--   - search_documents(q) : renvoie seulement les identifiants et le rang des
--     fiches que le compte connecté a le droit de voir dans le catalogue
--     (même règle que la bibliothèque), jamais leur contenu. Recherche par
--     début de mot (« anticoag », « hemorr »).
-- Idempotent.

create extension if not exists unaccent with schema extensions;

create or replace function public.mg_unaccent(t text)
returns text
language sql
immutable
parallel safe
set search_path = public, extensions
as $$ select extensions.unaccent('extensions.unaccent'::regdictionary, t) $$;

alter table public.documents add column if not exists search_tsv tsvector
  generated always as (
    to_tsvector(
      'french',
      public.mg_unaccent(
        coalesce(title, '') || ' ' ||
        coalesce(card_json::text, '') || ' ' ||
        regexp_replace(
          coalesce(presentation_json::text, ''),
          '<[^>]+>|"(t|v|key|html|style|text|rows|label|tone|content|items|sections|title|short|badge|society|version|validated|methodology|pages|section)":',
          ' ',
          'g'
        )
      )
    )
  ) stored;
create index if not exists documents_search_tsv_idx on public.documents using gin (search_tsv);

create or replace function public.search_documents(q text)
returns table (document_id uuid, rank real)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  words text;
  query tsquery;
begin
  if auth.uid() is null then
    return;
  end if;
  -- Chaque mot (2 caractères ou plus) devient un début de mot, tous requis.
  select string_agg(w || ':*', ' & ')
    into words
  from regexp_split_to_table(lower(public.mg_unaccent(left(coalesce(q, ''), 200))), '[^a-z0-9]+') as w
  where length(w) >= 2;
  if words is null then
    return;
  end if;
  query := to_tsquery('french', words);

  return query
    select d.id, ts_rank(d.search_tsv, query)
    from public.documents d
    where d.search_tsv @@ query
      and (
        public.has_editorial_role('relecteur')
        or (
          public.document_is_visible(d.id)
          and public.document_has_active_recommendation(d.id)
          and exists (
            select 1 from public.document_specialties ds
            where ds.document_id = d.id and public.has_specialty_access(ds.specialty_id)
          )
        )
      )
    order by 2 desc
    limit 200;
end;
$$;

revoke execute on function public.search_documents(text) from public, anon;
grant execute on function public.search_documents(text) to authenticated, service_role;
revoke select (search_tsv) on public.documents from anon, authenticated;
