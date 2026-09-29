-- Espace membre : favoris, suivi des sociétés savantes, alertes e-mail,
-- fiches mises à jour, fiches les plus consultées (cahier des charges V4.5,
-- §5.1, §6.2 « Favori », §8 « Alerte individuelle… »).
--
--   1. favorites                 : droits minimaux (chacun gère les siens) ;
--   2. notification_preferences  : un suivi par société et par compte ;
--   3. profiles.email_alerts     : alertes e-mail activées (désactivables
--      depuis « Mon compte » ou par le lien de désinscription) ;
--      profiles.alerts_token     : jeton du lien de désinscription ;
--   4. popular_documents()       : fiches les plus lues de la spécialité,
--      sans aucun chiffre ni historique individuel ;
--   5. my_document_updates()     : fiches du membre révisées, remplacées ou
--      retirées ;
--   6. pending_email_alerts()    : alertes à envoyer (tâche planifiée,
--      service_role uniquement).
-- Idempotent.

-- 1. Favoris ------------------------------------------------------------------
-- La règle favorites_own (schema_v2) limite déjà chaque compte à ses lignes.
revoke all on public.favorites from anon;
revoke update, truncate, references, trigger on public.favorites from authenticated;
grant select, insert, delete on public.favorites to authenticated;
create index if not exists favorites_user_id_idx on public.favorites (user_id, created_at desc);

-- 2. Suivi des sociétés savantes ------------------------------------------------
-- Doublons éventuels supprimés avant la contrainte (le plus ancien est gardé).
delete from public.notification_preferences a
using public.notification_preferences b
where a.society_id is not null
  and a.user_id = b.user_id
  and a.society_id = b.society_id
  and (a.created_at, a.id) > (b.created_at, b.id);
create unique index if not exists notification_preferences_user_society_key
  on public.notification_preferences (user_id, society_id)
  where society_id is not null;

revoke all on public.notification_preferences from anon;
revoke update, truncate, references, trigger on public.notification_preferences from authenticated;
grant select, insert, delete on public.notification_preferences to authenticated;

-- 3. Préférences d'alerte du profil ---------------------------------------------
alter table public.profiles add column if not exists email_alerts boolean not null default true;
alter table public.profiles add column if not exists alerts_token uuid not null default gen_random_uuid();
create unique index if not exists profiles_alerts_token_key on public.profiles (alerts_token);
-- Seul email_alerts devient modifiable ; le jeton ne l'est pas.
grant update (email_alerts) on public.profiles to authenticated;

create index if not exists consultation_history_document_viewed_idx
  on public.consultation_history (document_id, viewed_at desc);
create index if not exists notifications_log_user_document_idx
  on public.notifications_log (user_id, document_id, sent_at desc);

-- 4. Fiches les plus consultées ---------------------------------------------------
-- Rang des fiches lues par le plus de membres distincts sur 90 jours, parmi
-- celles que l'appelant peut voir. Ni nombre de lecteurs ni date ne sont
-- renvoyés, et une fiche n'entre au classement qu'à partir de 3 lecteurs
-- distincts : impossible d'en déduire la lecture d'une personne. Les
-- lectures de l'équipe éditoriale (relecture) ne comptent pas.
create or replace function public.popular_documents(max_results int default 5)
returns table (document_id uuid, rank int)
language sql
stable
security definer
set search_path = public
as $$
  with readers as (
    select h.document_id, count(distinct h.user_id) as n
    from public.consultation_history h
    join public.profiles p on p.id = h.user_id and p.editorial_role is null
    where h.document_id is not null
      and h.viewed_at > now() - interval '90 days'
    group by h.document_id
    having count(distinct h.user_id) >= 3
  ),
  visible as (
    select r.document_id, r.n
    from readers r
    where auth.uid() is not null
      and public.document_is_visible(r.document_id)
      and public.document_has_active_recommendation(r.document_id)
      and exists (
        select 1 from public.document_specialties ds
        where ds.document_id = r.document_id and public.has_specialty_access(ds.specialty_id)
      )
  )
  select v.document_id, (row_number() over (order by v.n desc, v.document_id))::int
  from visible v
  order by 2
  limit least(greatest(coalesce(max_results, 5), 1), 10);
$$;

revoke execute on function public.popular_documents(int) from public, anon;
grant execute on function public.popular_documents(int) to authenticated, service_role;

-- 5. Fiches du membre mises à jour ----------------------------------------------
-- Fiches débloquées, favorites ou consultées par l'appelant qui ne sont plus
-- « à jour » (révision détectée, remplacée, retirée) ou dont une version a été
-- publiée depuis sa dernière visite. Une fiche retirée n'est plus lisible par
-- les membres : cette fonction en renvoie seulement le titre et le statut,
-- et uniquement à ceux qui la suivaient.
create or replace function public.my_document_updates()
returns table (
  document_id uuid,
  title text,
  freshness_status text,
  superseded_by uuid,
  version_label text,
  change_type text,
  diff_summary text,
  version_published_at timestamptz
)
language sql
stable
security definer
set search_path = public
as $$
  with interest as (
    select s.document_id, max(s.at) as seen_at
    from (
      select u.document_id, u.unlocked_at as at from public.document_unlocks u where u.user_id = auth.uid()
      union all
      select f.document_id, f.created_at from public.favorites f
      where f.user_id = auth.uid() and f.document_id is not null
      union all
      select h.document_id, h.viewed_at from public.consultation_history h
      where h.user_id = auth.uid() and h.document_id is not null
    ) s
    group by s.document_id
  ),
  last_version as (
    select distinct on (v.document_id)
      v.document_id, v.version_label, v.change_type, v.diff_summary, v.published_at
    from public.document_versions v
    join interest i on i.document_id = v.document_id
    where v.published_at is not null
    order by v.document_id, v.published_at desc
  )
  select d.id,
         coalesce(d.card_json ->> 'title', d.title),
         d.freshness_status,
         d.superseded_by_document_id,
         lv.version_label,
         lv.change_type,
         lv.diff_summary,
         lv.published_at
  from interest i
  join public.documents d on d.id = i.document_id
  left join last_version lv on lv.document_id = d.id
  where auth.uid() is not null
    and (d.freshness_status <> 'a_jour' or lv.published_at > i.seen_at)
  order by lv.published_at desc nulls last, 2
  limit 10;
$$;

revoke execute on function public.my_document_updates() from public, anon;
grant execute on function public.my_document_updates() to authenticated, service_role;

-- 6. Alertes e-mail à envoyer -------------------------------------------------------
-- Appelée par la tâche planifiée (/api/cron/alertes, clé service_role).
-- Destinataires : abonnés PREMIUM (les alertes font partie de l'offre,
-- §5.1 et §10.1) et comptes de l'équipe éditoriale (envois d'essai), adresse
-- confirmée, alertes non désactivées. Deux motifs :
--   societe     : fiche publiée, depuis le début du suivi, par une société
--                 suivie, dans la spécialité du membre ;
--   mise_a_jour : version publiée d'une fiche débloquée, favorite ou
--                 consultée avant cette version (§8).
-- Fenêtre de 14 jours ; une fiche déjà signalée à un membre depuis
-- l'événement (notifications_log) ne l'est pas une seconde fois.
create or replace function public.pending_email_alerts()
returns table (user_id uuid, email text, prenom text, alerts_token uuid, document_id uuid, motif text, event_at timestamptz)
language sql
stable
security definer
set search_path = public, auth
as $$
  with recipients as (
    select p.id, u.email::text as email, p.prenom, p.alerts_token, p.specialty_id
    from public.profiles p
    join auth.users u on u.id = p.id
    where p.email_alerts
      and u.email is not null
      and u.email_confirmed_at is not null
      and (
        p.editorial_role is not null
        or exists (
          select 1 from public.subscriptions s
          where s.user_id = p.id
            and s.status = 'actif'
            and (s.current_period_end is null or s.current_period_end > now())
        )
      )
  ),
  candidates as (
    select r.id as user_id, d.id as document_id, 'societe'::text as motif, d.published_at as event_at
    from recipients r
    join public.notification_preferences np on np.user_id = r.id and np.society_id is not null
    join public.document_societies dsoc on dsoc.society_id = np.society_id
    join public.documents d on d.id = dsoc.document_id
    where d.published_at is not null
      and d.published_at > np.created_at
      and d.published_at > now() - interval '14 days'
      and d.freshness_status <> 'retiree'
      and exists (
        select 1 from public.document_specialties ds
        where ds.document_id = d.id and ds.specialty_id = r.specialty_id
      )
    union all
    select r.id, v.document_id, 'mise_a_jour', v.published_at
    from recipients r
    join public.document_versions v
      on v.published_at is not null and v.published_at > now() - interval '14 days'
    join public.documents d on d.id = v.document_id and d.freshness_status <> 'retiree'
    where exists (
        select 1 from public.document_unlocks x
        where x.user_id = r.id and x.document_id = v.document_id and x.unlocked_at < v.published_at
      )
      or exists (
        select 1 from public.favorites x
        where x.user_id = r.id and x.document_id = v.document_id and x.created_at < v.published_at
      )
      or exists (
        select 1 from public.consultation_history x
        where x.user_id = r.id and x.document_id = v.document_id and x.viewed_at < v.published_at
      )
  )
  select distinct on (c.user_id, c.document_id)
    c.user_id, r.email, r.prenom, r.alerts_token, c.document_id, c.motif, c.event_at
  from candidates c
  join recipients r on r.id = c.user_id
  where not exists (
    select 1 from public.notifications_log l
    where l.user_id = c.user_id and l.document_id = c.document_id and l.sent_at >= c.event_at
  )
  order by c.user_id, c.document_id, c.event_at desc;
$$;

revoke execute on function public.pending_email_alerts() from public, anon, authenticated;
grant execute on function public.pending_email_alerts() to service_role;
