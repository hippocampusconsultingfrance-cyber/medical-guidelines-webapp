-- Médecins relecteurs : un médecin propose de participer à la correction des
-- fiches (déjà relues deux fois par des outils d'intelligence artificielle),
-- en échange d'un accès gratuit au site et de 5 accès au choix.
--
--   - formulaire public (page /relecteurs), sans compte : nom, prénom,
--     téléphone, e-mail, profession, spécialité dont il souhaite corriger
--     les fiches, message facultatif ;
--   - écriture par le serveur uniquement (clé service_role), après contrôle
--     des champs : aucune lecture ni écriture directe depuis le navigateur ;
--   - l'administrateur lit les candidatures et change leur statut depuis le
--     tableau de bord ; l'accès offert est attribué à la main ;
--   - anti-abus : 3 candidatures par e-mail et 200 au total par 24 h ;
--   - conservation (politique de confidentialité, §4) : candidature refusée
--     effacée 6 mois après la décision, toute autre candidature 3 ans après
--     son envoi ; appliqué chaque jour par purger_donnees_expirees.
-- Idempotent.

create table if not exists public.candidatures_relecteurs (
  id uuid primary key default gen_random_uuid(),
  nom text not null check (char_length(nom) between 1 and 100),
  prenom text not null check (char_length(prenom) between 1 and 100),
  telephone text not null check (char_length(telephone) between 6 and 30),
  email text not null check (char_length(email) between 5 and 254 and email like '%_@_%'),
  profession text not null check (char_length(profession) between 2 and 120),
  specialite text not null check (char_length(specialite) between 2 and 120),
  message text check (char_length(message) <= 2000),
  status text not null default 'nouvelle' check (status in ('nouvelle', 'contactee', 'acceptee', 'refusee')),
  admin_note text check (char_length(admin_note) <= 1000),
  created_at timestamptz not null default now(),
  decided_at timestamptz
);
create index if not exists candidatures_relecteurs_status_idx on public.candidatures_relecteurs (status, created_at desc);
create index if not exists candidatures_relecteurs_email_idx on public.candidatures_relecteurs (lower(email), created_at desc);

alter table public.candidatures_relecteurs enable row level security;
revoke all on public.candidatures_relecteurs from public, anon, authenticated;
grant all on public.candidatures_relecteurs to service_role;

create or replace function public.limiter_candidatures_relecteurs()
returns trigger language plpgsql security definer set search_path = public
as $$
begin
  if (select count(*) from public.candidatures_relecteurs
      where lower(email) = lower(new.email) and created_at > now() - interval '24 hours') >= 3 then
    raise exception 'Trop de candidatures pour cette adresse en 24 heures' using errcode = '54000';
  end if;
  if (select count(*) from public.candidatures_relecteurs
      where created_at > now() - interval '24 hours') >= 200 then
    raise exception 'Trop de candidatures en 24 heures' using errcode = '54000';
  end if;
  return new;
end;
$$;
revoke execute on function public.limiter_candidatures_relecteurs() from public, anon, authenticated;

drop trigger if exists limiter_candidatures_relecteurs on public.candidatures_relecteurs;
create trigger limiter_candidatures_relecteurs before insert on public.candidatures_relecteurs
  for each row execute function public.limiter_candidatures_relecteurs();

-- Purge quotidienne : même fonction que 20261003120000_purge_conservation.sql,
-- avec l'effacement des candidatures expirées.
create or replace function public.purger_donnees_expirees()
returns jsonb
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  n_lectures int;
  n_comptes int;
  n_candidatures int;
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

  delete from public.candidatures_relecteurs c
   where (c.status = 'refusee' and coalesce(c.decided_at, c.created_at) < now() - interval '6 months')
      or c.created_at < now() - interval '3 years';
  get diagnostics n_candidatures = row_count;

  insert into public.audit_log (actor_id, action, entity_type, entity_id, after)
  values (null, 'purge_conservation', 'systeme', null,
          jsonb_build_object('lectures_30j', n_lectures, 'comptes_inactifs_3ans', n_comptes, 'candidatures_relecteurs', n_candidatures));

  return jsonb_build_object('lectures_30j', n_lectures, 'comptes_inactifs_3ans', n_comptes, 'candidatures_relecteurs', n_candidatures);
end;
$$;

revoke execute on function public.purger_donnees_expirees() from public, anon, authenticated;
grant execute on function public.purger_donnees_expirees() to service_role;

