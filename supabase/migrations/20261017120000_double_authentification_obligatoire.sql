-- Double authentification obligatoire pour l'équipe éditoriale et les
-- administrateurs (analyse du 16/10/2026, point 10) : les droits d'équipe
-- (is_admin, has_editorial_role, donc toutes les règles d'accès qui en
-- dépendent) exigent une session de niveau aal2, c'est-à-dire un code de
-- double authentification saisi. Un compte d'équipe sans double
-- authentification activée n'a plus que les droits d'un membre : le site
-- l'envoie l'activer (Mon compte → Double authentification).
-- Remplace la règle du 30/09/2026 (20260930180000), qui laissait les droits
-- aux comptes sans facteur activé. Sans effet pour les membres.
-- Idempotent.

create or replace function public.mfa_satisfaite()
returns boolean language sql stable security definer set search_path = public, auth
as $fn$
  select coalesce(auth.jwt() ->> 'aal', 'aal1') = 'aal2'
$fn$;
revoke execute on function public.mfa_satisfaite() from public;
grant execute on function public.mfa_satisfaite() to anon, authenticated, service_role;
