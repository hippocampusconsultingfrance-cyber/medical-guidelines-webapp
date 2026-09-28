-- Accès aux fiches et quota gratuit (cahier des charges V4.5, §5 ; checklist 1.2, 1.3).
--
-- Règles appliquées par la base, donc impossibles à contourner par un appel
-- direct à l'API :
--   - le contenu d'une fiche (recommandations, presentation_json) n'est lu
--     que par un compte connecté, de la spécialité de la fiche, abonné
--     PREMIUM ou ayant débloqué cette fiche ; les relecteurs voient tout ;
--   - un compte gratuit débloque au plus 5 fiches, à vie ; une fiche
--     débloquée le reste et n'est jamais recomptée ;
--   - un visiteur sans compte ne lit aucune recommandation (les pages
--     publiques de résumé passeront par une fonction dédiée).
-- Les métadonnées des fiches (titre, date, source) restent lisibles pour
-- afficher le catalogue. Idempotent.

-- 1. Fiches débloquées ---------------------------------------------------------
create table if not exists public.document_unlocks (
  user_id uuid not null references public.profiles(id) on delete cascade,
  document_id uuid not null references public.documents(id) on delete cascade,
  unlocked_at timestamptz not null default now(),
  primary key (user_id, document_id)
);
alter table public.document_unlocks enable row level security;
-- Écriture uniquement par unlock_document() : aucun droit direct.
revoke all on public.document_unlocks from public, anon, authenticated;
grant select on public.document_unlocks to authenticated;
grant all on public.document_unlocks to service_role;
drop policy if exists document_unlocks_select_own on public.document_unlocks;
create policy document_unlocks_select_own on public.document_unlocks
  for select to authenticated
  using (user_id = (select auth.uid()) or public.is_admin());

-- 2. Fonctions d'accès --------------------------------------------------------
create or replace function public.free_unlock_quota()
returns int language sql immutable set search_path = public
as $$ select 5 $$;

create or replace function public.has_premium()
returns boolean language sql stable security definer set search_path = public
as $$
  select exists (
    select 1 from public.subscriptions s
    where s.user_id = auth.uid()
      and s.status = 'actif'
      and (s.current_period_end is null or s.current_period_end > now())
  );
$$;

create or replace function public.can_read_document(doc_id uuid)
returns boolean language sql stable security definer set search_path = public
as $$
  select auth.uid() is not null and (
    public.has_editorial_role('relecteur')
    or (
      public.document_is_visible(doc_id)
      and exists (
        select 1 from public.document_specialties ds
        where ds.document_id = doc_id and public.has_specialty_access(ds.specialty_id)
      )
      and (
        public.has_premium()
        or exists (
          select 1 from public.document_unlocks u
          where u.user_id = auth.uid() and u.document_id = doc_id
        )
      )
    )
  );
$$;

-- Débloque une fiche pour un compte gratuit. Statuts renvoyés :
-- debloque, deja, premium, quota_atteint, indisponible.
create or replace function public.unlock_document(doc_id uuid)
returns jsonb language plpgsql volatile security definer set search_path = public
as $$
declare
  uid uuid := auth.uid();
  used int;
begin
  if uid is null then
    raise exception 'Connexion requise' using errcode = '28000';
  end if;

  if not (
    public.document_is_visible(doc_id)
    and public.document_has_active_recommendation(doc_id)
    and exists (
      select 1 from public.document_specialties ds
      where ds.document_id = doc_id and public.has_specialty_access(ds.specialty_id)
    )
  ) then
    return jsonb_build_object('status', 'indisponible');
  end if;

  if public.has_premium() then
    return jsonb_build_object('status', 'premium');
  end if;

  -- Sérialise les déblocages d'un même compte : deux onglets simultanés ne
  -- peuvent pas dépasser le quota.
  perform pg_advisory_xact_lock(hashtextextended(uid::text, 0));

  select count(*) into used from public.document_unlocks where user_id = uid;

  if exists (select 1 from public.document_unlocks where user_id = uid and document_id = doc_id) then
    return jsonb_build_object('status', 'deja', 'used', used, 'quota', public.free_unlock_quota());
  end if;

  if used >= public.free_unlock_quota() then
    return jsonb_build_object('status', 'quota_atteint', 'used', used, 'quota', public.free_unlock_quota());
  end if;

  insert into public.document_unlocks (user_id, document_id) values (uid, doc_id);
  return jsonb_build_object('status', 'debloque', 'used', used + 1, 'quota', public.free_unlock_quota());
end;
$$;

-- Contenu de présentation d'une fiche (arbre JSON), seulement si lisible.
create or replace function public.get_document_presentation(doc_id uuid)
returns jsonb language sql stable security definer set search_path = public
as $$
  select d.presentation_json from public.documents d
  where d.id = doc_id and public.can_read_document(doc_id);
$$;

revoke execute on function public.has_premium() from public, anon;
revoke execute on function public.can_read_document(uuid) from public, anon;
revoke execute on function public.unlock_document(uuid) from public, anon;
revoke execute on function public.get_document_presentation(uuid) from public, anon;
grant execute on function public.has_premium() to authenticated, service_role;
grant execute on function public.can_read_document(uuid) to authenticated, service_role;
grant execute on function public.unlock_document(uuid) to authenticated, service_role;
grant execute on function public.get_document_presentation(uuid) to authenticated, service_role;
grant execute on function public.free_unlock_quota() to anon, authenticated, service_role;

-- 3. Recommandations : lecture réservée aux fiches accessibles ---------------
-- Remplace l'ancienne règle qui laissait lire toute recommandation active,
-- y compris sans compte.
drop policy if exists recommendations_select_public on public.recommendations;
create policy recommendations_select_public on public.recommendations
  for select to authenticated
  using (
    public.has_editorial_role('relecteur')
    or (status = 'active' and public.can_read_document(document_id))
  );

-- 4. Documents : presentation_json retiré de la lecture directe ---------------
-- Lecture colonne par colonne : toutes les colonnes sauf le contenu, qui
-- passe par get_document_presentation(). Les droits d'écriture (réservés
-- aux rôles éditoriaux par les règles existantes) sont inchangés.
do $$
declare
  cols text;
begin
  select string_agg(quote_ident(column_name), ', ' order by ordinal_position)
    into cols
  from information_schema.columns
  where table_schema = 'public' and table_name = 'documents'
    and column_name <> 'presentation_json';
  execute 'revoke select on public.documents from anon, authenticated';
  execute format('grant select (%s) on public.documents to anon, authenticated', cols);
end;
$$;

-- 5. Abonnements : plus aucune écriture par l'utilisateur ---------------------
-- L'ancienne règle « own_or_admin » permettait à un compte gratuit de
-- s'attribuer lui-même un abonnement actif. Les abonnements ne sont créés
-- et modifiés que par le serveur (webhook Stripe, service_role) ou par un
-- administrateur. La lecture de son propre abonnement reste possible.
drop policy if exists subscriptions_write_own_or_admin on public.subscriptions;
drop policy if exists subscriptions_write_admin on public.subscriptions;
create policy subscriptions_write_admin on public.subscriptions
  for all to authenticated
  using (public.is_admin())
  with check (public.is_admin());
revoke insert, update, delete, truncate on public.subscriptions from anon;
