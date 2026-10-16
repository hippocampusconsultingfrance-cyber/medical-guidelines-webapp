-- Assistant de recherche : la question est réservée (comptée) avant l'appel
-- à l'IA, sous un verrou par membre. Plusieurs questions envoyées en même
-- temps sont comptées l'une après l'autre : la limite quotidienne ne peut
-- plus être dépassée (poserQuestion, src/app/assistant/actions.ts).
-- Appelée par le serveur seulement (clé service_role) : le membre et la
-- limite sont fixés par le serveur.
-- Idempotent.

-- Renvoie l'identifiant de la ligne réservée dans assistant_usage, ou null
-- si la limite des 24 dernières heures est atteinte.
create or replace function public.reserver_question_assistant(membre uuid, quota integer)
returns bigint
language plpgsql
volatile
security definer
set search_path = public
as $fn$
declare
  reserve bigint;
begin
  -- Verrou jusqu'à la fin de la transaction, propre à ce membre.
  perform pg_advisory_xact_lock(hashtextextended('assistant:' || membre::text, 0));
  if (
    select count(*) from public.assistant_usage u
     where u.user_id = membre and u.created_at > now() - interval '24 hours'
  ) >= quota then
    return null;
  end if;
  insert into public.assistant_usage (user_id) values (membre) returning id into reserve;
  return reserve;
end;
$fn$;
revoke all on function public.reserver_question_assistant(uuid, integer) from public, anon, authenticated;
grant execute on function public.reserver_question_assistant(uuid, integer) to service_role;
