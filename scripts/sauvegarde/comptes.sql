-- État de la base comparé entre la production et sa restauration
-- (.github/workflows/sauvegarde.yml), une ligne « clé valeur » par mesure :
--   - lignes:<table> : nombre de lignes de chaque table du schéma public et
--     des comptes (auth.users) ;
--   - rls:<table> : 1 si la sécurité par ligne est activée, 0 sinon ;
--   - regles:<table> : nombre de règles d'accès de la table ;
--   - fonctions:public : nombre de fonctions du schéma public (hors
--     extensions).
-- Une table absente compte -1.
with tables as (
  select format('public.%I', c.relname) as t
    from pg_class c join pg_namespace n on n.oid = c.relnamespace
   where n.nspname = 'public' and c.relkind in ('r', 'p')
  union all
  select 'auth.users' where to_regclass('auth.users') is not null
)
select 'lignes:' || t,
       coalesce((xpath('/row/c/text()', query_to_xml(format('select count(*) as c from %s', t), false, true, '')))[1]::text::bigint, -1)
  from tables
union all
-- Tables indispensables : présentes même si la base est vide ou incomplète.
select 'lignes:' || t, -1
  from unnest(array['auth.users', 'public.profiles', 'public.documents', 'public.recommendations', 'public.subscriptions']) as t
 where to_regclass(t) is null
union all
select 'rls:' || c.relname, case when c.relrowsecurity then 1 else 0 end
  from pg_class c join pg_namespace n on n.oid = c.relnamespace
 where n.nspname = 'public' and c.relkind in ('r', 'p')
union all
select 'regles:' || tablename, count(*)
  from pg_policies
 where schemaname = 'public'
 group by tablename
union all
select 'fonctions:public', count(*)
  from pg_proc p join pg_namespace n on n.oid = p.pronamespace
 where n.nspname = 'public'
   and not exists (select 1 from pg_depend d where d.objid = p.oid and d.deptype = 'e')
order by 1;
