-- Nombre de lignes des tables essentielles, comparé entre la base de
-- production et sa restauration (.github/workflows/sauvegarde.yml).
-- Une table absente compte -1.
select t, coalesce((xpath('/row/c/text()', query_to_xml(format('select count(*) as c from %s', t), false, true, '')))[1]::text::bigint, -1)
from unnest(array[
  'auth.users', 'public.profiles', 'public.subscriptions', 'public.document_unlocks',
  'public.favorites', 'public.documents', 'public.recommendations', 'public.societies',
  'public.document_societies', 'public.document_specialties', 'public.document_versions',
  'public.error_reports'
]) as t
where to_regclass(t) is not null
union all
select t, -1
from unnest(array['auth.users', 'public.profiles', 'public.documents', 'public.recommendations']) as t
where to_regclass(t) is null
order by 1;
