-- Durcissement après installation de schema_v2 et schema_v3 (28/09/2026).
-- Répond aux alertes de l'analyse de sécurité Supabase :
--   - function_search_path_mutable : search_path figé sur les fonctions concernées ;
--   - anon_security_definer_function_executable : get_editorial_role et
--     check_promotion_code ne sont plus appelables sans connexion.
-- Les fonctions utilisées par les règles d'accès des visiteurs
-- (document_is_visible, document_has_active_recommendation, has_editorial_role)
-- restent exécutables par anon : les politiques RLS sont évaluées avec les
-- droits de l'appelant. Idempotent.

alter function public.set_updated_at() set search_path = public;
alter function public.is_privileged_context() set search_path = public;
alter function public.default_specialty_id() set search_path = public;
alter function public.resolve_specialty_id(text) set search_path = public;
alter function public.has_specialty_access(uuid) set search_path = public;

-- Rôle éditorial d'un profil quelconque : utile aux déclencheurs de relecture
-- (exécutés par un utilisateur connecté), jamais à un visiteur anonyme.
revoke execute on function public.get_editorial_role(uuid) from public, anon;
grant execute on function public.get_editorial_role(uuid) to authenticated, service_role;

-- Vérification d'un code promotionnel : au moment de la souscription, donc
-- par un utilisateur connecté.
revoke execute on function public.check_promotion_code(text, text) from public, anon;
grant execute on function public.check_promotion_code(text, text) to authenticated, service_role;
