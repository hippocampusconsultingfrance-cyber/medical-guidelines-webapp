-- Durées de conservation promises par la politique de confidentialité
-- (src/app/confidentialite/page.tsx), appliquées chaque jour par la tâche
-- planifiée /api/cron/purge :
--
--   - journal de lecture anti-extraction (content_reads) : 30 jours. Jusqu'ici
--     purgé seulement quand le même membre ouvrait une nouvelle fiche ;
--   - comptes inactifs depuis 3 ans (dernière connexion, ou inscription si
--     aucune connexion) : supprimés comme une suppression par le membre
--     lui-même (delete_my_account : toutes ses données suivent). Jamais un
--     compte de l'équipe éditoriale ni un compte dont l'abonnement est en
--     cours (payé ou offert).
--
-- Réservé au serveur (service_role). Chaque passage est tracé au journal
-- d'administration avec les nombres supprimés, jamais les identités.
-- Idempotent.

create or replace function public.purger_donnees_expirees()
returns jsonb
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  n_lectures int;
  n_comptes int;
begin
  delete from public.content_reads where read_at < now() - interval '30 days';
  get diagnostics n_lectures = row_count;

  delete from auth.users u
   where coalesce(u.last_sign_in_at, u.created_at) < now() - interval '3 years'
     and not exists (
       select 1 from public.profiles p where p.id = u.id and p.editorial_role is not null
     )
     and not exists (
       select 1 from public.subscriptions s
        where s.user_id = u.id
          and s.status in ('actif', 'en_retard')
          and (s.current_period_end is null or s.current_period_end > now())
     );
  get diagnostics n_comptes = row_count;

  insert into public.audit_log (actor_id, action, entity_type, entity_id, after)
  values (null, 'purge_conservation', 'systeme', null,
          jsonb_build_object('lectures_30j', n_lectures, 'comptes_inactifs_3ans', n_comptes));

  return jsonb_build_object('lectures_30j', n_lectures, 'comptes_inactifs_3ans', n_comptes);
end;
$$;

revoke execute on function public.purger_donnees_expirees() from public, anon, authenticated;
grant execute on function public.purger_donnees_expirees() to service_role;

create index if not exists content_reads_read_at_idx on public.content_reads (read_at);
