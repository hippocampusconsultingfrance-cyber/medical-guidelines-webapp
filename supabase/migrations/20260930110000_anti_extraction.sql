-- Protection contre l'extraction du contenu (cahier des charges V4.5, §11 ;
-- checklist 5.2 « Détection d'extraction : blocage temporaire après un
-- rythme anormal »). Mesures « essentielles » : limitation du nombre de
-- fiches consultées par période, détection de l'extraction automatisée,
-- journalisation des accès anormaux et alerte à l'administrateur.
--
--   - le contenu d'une fiche ne sort plus que par get_document_presentation(),
--     qui journalise chaque lecture (content_reads, conservé 30 jours) ; la
--     lecture directe de la table recommendations (qui permettait de tout
--     télécharger en un appel) est réservée à l'équipe éditoriale ;
--   - au-delà de 20 fiches différentes en 10 minutes, ou de 60 en 24 heures,
--     le compte est suspendu de lecture (1 h, ou 24 h) : access_blocks garde
--     la trace, le site prévient les administrateurs, qui peuvent lever la
--     suspension. L'équipe éditoriale n'est jamais concernée ;
--   - relire une fiche déjà ouverte ne compte pas.
-- Idempotent.

-- 1. Journal des lectures -----------------------------------------------------
create table if not exists public.content_reads (
  user_id uuid not null references public.profiles(id) on delete cascade,
  document_id uuid not null references public.documents(id) on delete cascade,
  read_at timestamptz not null default now()
);
create index if not exists content_reads_user_idx on public.content_reads (user_id, read_at desc);
alter table public.content_reads enable row level security;
revoke all on public.content_reads from public, anon, authenticated;
grant select on public.content_reads to authenticated;
grant all on public.content_reads to service_role;
drop policy if exists content_reads_select_admin on public.content_reads;
create policy content_reads_select_admin on public.content_reads for select
  to authenticated
  using (public.is_admin());

-- 2. Suspensions ----------------------------------------------------------------
create table if not exists public.access_blocks (
  id bigint generated always as identity primary key,
  user_id uuid not null references public.profiles(id) on delete cascade,
  reason text not null check (reason in ('rythme_10min', 'volume_24h')),
  distinct_documents int not null,
  blocked_at timestamptz not null default now(),
  blocked_until timestamptz not null,
  notified_at timestamptz,
  lifted_by uuid references public.profiles(id) on delete set null,
  lifted_at timestamptz
);
create index if not exists access_blocks_user_idx on public.access_blocks (user_id, blocked_until desc);
alter table public.access_blocks enable row level security;
revoke all on public.access_blocks from public, anon, authenticated;
grant select on public.access_blocks to authenticated;
grant all on public.access_blocks to service_role;
drop policy if exists access_blocks_select on public.access_blocks;
create policy access_blocks_select on public.access_blocks for select
  to authenticated
  using (user_id = (select auth.uid()) or public.is_admin());

create or replace function public.is_access_blocked()
returns boolean language sql stable security definer set search_path = public
as $$
  select exists (
    select 1 from public.access_blocks b
    where b.user_id = auth.uid() and b.blocked_until > now()
  );
$$;

-- 3. Droit de lecture : un compte suspendu ne lit plus rien ------------------
create or replace function public.can_read_document(doc_id uuid)
returns boolean language sql stable security definer set search_path = public
as $$
  select auth.uid() is not null and (
    public.has_editorial_role('relecteur')
    or (
      not public.is_access_blocked()
      and public.document_is_visible(doc_id)
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

-- 4. Lecture du contenu : journalisée et limitée ------------------------------
create or replace function public.get_document_presentation(doc_id uuid)
returns jsonb language plpgsql volatile security definer set search_path = public
as $$
declare
  uid uuid := auth.uid();
  n10 int;
  n24 int;
begin
  if not public.can_read_document(doc_id) then
    return null;
  end if;

  if not public.has_editorial_role('relecteur') then
    -- Une seule vérification à la fois par compte (onglets simultanés).
    perform pg_advisory_xact_lock(hashtextextended('lecture:' || uid::text, 0));
    delete from public.content_reads where user_id = uid and read_at < now() - interval '30 days';
    insert into public.content_reads (user_id, document_id) values (uid, doc_id);

    select count(distinct document_id) filter (where read_at > now() - interval '10 minutes'),
           count(distinct document_id)
      into n10, n24
      from public.content_reads
     where user_id = uid and read_at > now() - interval '24 hours';

    if n10 > 20 then
      insert into public.access_blocks (user_id, reason, distinct_documents, blocked_until)
      values (uid, 'rythme_10min', n10, now() + interval '1 hour');
      return null;
    elsif n24 > 60 then
      insert into public.access_blocks (user_id, reason, distinct_documents, blocked_until)
      values (uid, 'volume_24h', n24, now() + interval '24 hours');
      return null;
    end if;
  end if;

  return (select d.presentation_json from public.documents d where d.id = doc_id);
end;
$$;

-- Recommandations d'une fiche (affichage de secours des fiches sans mise en
-- page), avec le même contrôle que la présentation.
create or replace function public.get_document_recommendations(doc_id uuid)
returns jsonb language plpgsql volatile security definer set search_path = public
as $$
begin
  if public.get_document_presentation(doc_id) is null and not public.can_read_document(doc_id) then
    return null;
  end if;
  return coalesce((
    select jsonb_agg(jsonb_build_object(
      'id', r.id, 'recommendation_code', r.recommendation_code, 'statement', r.statement,
      'grade', r.grade, 'evidence_level', r.evidence_level, 'source_section', r.source_section,
      'source_page', r.source_page, 'status', r.status) order by r.recommendation_code)
    from public.recommendations r
    where r.document_id = doc_id and r.status = 'active'
  ), '[]'::jsonb);
end;
$$;

revoke execute on function public.is_access_blocked() from public, anon;
revoke execute on function public.get_document_presentation(uuid) from public, anon;
revoke execute on function public.get_document_recommendations(uuid) from public, anon;
grant execute on function public.is_access_blocked() to authenticated, service_role;
grant execute on function public.get_document_presentation(uuid) to authenticated, service_role;
grant execute on function public.get_document_recommendations(uuid) to authenticated, service_role;

-- 5. Recommandations : plus de lecture en masse par les membres ---------------
drop policy if exists recommendations_select_public on public.recommendations;
create policy recommendations_select_public on public.recommendations
  for select to authenticated
  using (public.has_editorial_role('relecteur'));

-- 6. Pas de déblocage (crédit consommé) pendant une suspension ---------------
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

  if public.is_access_blocked() then
    return jsonb_build_object('status', 'suspendu');
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
