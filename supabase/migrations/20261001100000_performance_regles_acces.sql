-- Performance des règles d'accès (conseiller Supabase « auth_rls_initplan »,
-- 01/10/2026) : auth.uid() écrit tel quel dans une règle RLS est recalculé
-- pour chaque ligne ; écrit (select auth.uid()), il est calculé une seule
-- fois par requête. Les règles restent identiques (mêmes rôles, mêmes
-- conditions) : seule l'écriture change.
-- Index des clés étrangères les plus lues (fiches débloquées, signalements,
-- favoris, lectures).
-- Idempotent.

do $$
begin
  if to_regclass('public.subscriptions') is not null then
    alter policy subscriptions_select_own on public.subscriptions
      using (user_id = (select auth.uid()) or public.is_admin());
  end if;
  if to_regclass('public.institution_members') is not null then
    alter policy institution_members_select_own_or_admin on public.institution_members
      using (user_id = (select auth.uid()) or public.is_admin());
  end if;
  if to_regclass('public.notification_preferences') is not null then
    alter policy notification_preferences_own on public.notification_preferences
      using (user_id = (select auth.uid()))
      with check (user_id = (select auth.uid()));
  end if;
  if to_regclass('public.notifications_log') is not null then
    alter policy notifications_log_select_own on public.notifications_log
      using (user_id = (select auth.uid()) or public.is_admin());
  end if;
  if to_regclass('public.favorites') is not null then
    alter policy favorites_own on public.favorites
      using (user_id = (select auth.uid()) or public.is_admin())
      with check (user_id = (select auth.uid()) or public.is_admin());
  end if;
  if to_regclass('public.consultation_history') is not null then
    alter policy consultation_history_own on public.consultation_history
      using (user_id = (select auth.uid()) or public.is_admin())
      with check (user_id = (select auth.uid()) or public.is_admin());
  end if;
  if to_regclass('public.promotion_redemptions') is not null then
    alter policy promotion_redemptions_select_own_or_admin on public.promotion_redemptions
      using (user_id = (select auth.uid()) or public.is_admin());
  end if;
  alter policy documents_select_public on public.documents
    using (
      public.has_editorial_role('relecteur')
      or (
        freshness_status <> 'retiree'
        and public.document_has_active_recommendation(id)
        and (
          (select auth.uid()) is null
          or exists (
            select 1 from public.document_specialties ds
            where ds.document_id = documents.id and public.has_specialty_access(ds.specialty_id)
          )
        )
      )
    );
end $$;

create index if not exists document_unlocks_document_idx on public.document_unlocks (document_id);
create index if not exists error_reports_document_idx on public.error_reports (document_id);
create index if not exists favorites_document_idx on public.favorites (document_id);
create index if not exists content_reads_document_idx on public.content_reads (document_id);
create index if not exists document_societies_society_idx on public.document_societies (society_id);
create index if not exists document_specialties_specialty_idx on public.document_specialties (specialty_id);
