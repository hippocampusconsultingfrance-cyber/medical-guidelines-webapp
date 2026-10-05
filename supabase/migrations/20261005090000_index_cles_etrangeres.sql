-- Performance de la base avant la croissance (audit du 04/10/2026) :
--   - index sur les 48 clés étrangères signalées par Supabase (jointures et
--     suppressions en cascade, notamment la purge des comptes inactifs) ;
--   - clé primaire sur le journal de lecture (content_reads), qui n'en avait
--     pas.
-- Sans effet sur les données. Idempotent.

create index if not exists access_blocks_lifted_by_idx on public.access_blocks (lifted_by);
create index if not exists actualisations_ecartees_ecartee_par_idx on public.actualisations_ecartees (ecartee_par);
create index if not exists actualisations_ecartees_nouvelle_id_idx on public.actualisations_ecartees (nouvelle_id);
create index if not exists audit_log_actor_id_idx on public.audit_log (actor_id);
create index if not exists consultation_history_recommendation_id_idx on public.consultation_history (recommendation_id);
create index if not exists corrections_log_created_by_idx on public.corrections_log (created_by);
create index if not exists corrections_log_error_report_id_idx on public.corrections_log (error_report_id);
create index if not exists divergences_created_by_idx on public.divergences (created_by);
create index if not exists document_translations_reviewed_by_idx on public.document_translations (reviewed_by);
create index if not exists document_versions_created_by_idx on public.document_versions (created_by);
create index if not exists documents_society_id_idx on public.documents (society_id);
create index if not exists documents_superseded_by_document_id_idx on public.documents (superseded_by_document_id);
create index if not exists editorial_reviews_reviewer_id_idx on public.editorial_reviews (reviewer_id);
create index if not exists error_reports_recommendation_id_idx on public.error_reports (recommendation_id);
create index if not exists favorites_recommendation_id_idx on public.favorites (recommendation_id);
create index if not exists institution_members_user_id_idx on public.institution_members (user_id);
create index if not exists libelles_reformulation_decided_by_idx on public.libelles_reformulation (decided_by);
create index if not exists libelles_reformulation_document_id_idx on public.libelles_reformulation (document_id);
create index if not exists notification_preferences_document_id_idx on public.notification_preferences (document_id);
create index if not exists notification_preferences_recommendation_id_idx on public.notification_preferences (recommendation_id);
create index if not exists notification_preferences_society_id_idx on public.notification_preferences (society_id);
create index if not exists notification_preferences_specialty_id_idx on public.notification_preferences (specialty_id);
create index if not exists notification_preferences_topic_id_idx on public.notification_preferences (topic_id);
create index if not exists notifications_log_document_id_idx on public.notifications_log (document_id);
create index if not exists notifications_log_recommendation_id_idx on public.notifications_log (recommendation_id);
create index if not exists plan_prices_updated_by_idx on public.plan_prices (updated_by);
create index if not exists points_cles_propositions_decided_by_idx on public.points_cles_propositions (decided_by);
create index if not exists profession_specialty_map_specialty_id_idx on public.profession_specialty_map (specialty_id);
create index if not exists profiles_specialty_id_idx on public.profiles (specialty_id);
create index if not exists promotion_codes_created_by_idx on public.promotion_codes (created_by);
create index if not exists promotion_redemptions_subscription_id_idx on public.promotion_redemptions (subscription_id);
create index if not exists recette_validations_validated_by_idx on public.recette_validations (validated_by);
create index if not exists recommendation_drugs_drug_id_idx on public.recommendation_drugs (drug_id);
create index if not exists recommendation_interventions_intervention_id_idx on public.recommendation_interventions (intervention_id);
create index if not exists recommendation_links_linked_recommendation_id_idx on public.recommendation_links (linked_recommendation_id);
create index if not exists recommendation_populations_population_id_idx on public.recommendation_populations (population_id);
create index if not exists recommendation_topics_topic_id_idx on public.recommendation_topics (topic_id);
create index if not exists recommendation_translations_reviewed_by_idx on public.recommendation_translations (reviewed_by);
create index if not exists recommendation_translations_translated_by_idx on public.recommendation_translations (translated_by);
create index if not exists recommendations_approved_by_idx on public.recommendations (approved_by);
create index if not exists recommendations_created_by_idx on public.recommendations (created_by);
create index if not exists recommendations_edited_by_idx on public.recommendations (edited_by);
create index if not exists recommendations_published_by_idx on public.recommendations (published_by);
create index if not exists recommendations_reviewed_by_idx on public.recommendations (reviewed_by);
create index if not exists student_discount_requests_decided_by_idx on public.student_discount_requests (decided_by);
create index if not exists subscriptions_promotion_code_id_idx on public.subscriptions (promotion_code_id);
create index if not exists watch_sources_document_id_idx on public.watch_sources (document_id);
create index if not exists watch_sources_society_id_idx on public.watch_sources (society_id);

alter table public.content_reads add column if not exists id bigint generated always as identity primary key;
