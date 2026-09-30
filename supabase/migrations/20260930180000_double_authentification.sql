-- Double authentification (MFA, code TOTP) des comptes de l'équipe
-- éditoriale et des administrateurs (audit de sécurité du 30/09/2026).
--
-- Un compte éditorial qui a activé un facteur TOTP n'obtient ses droits
-- (is_admin, has_editorial_role, donc toutes les règles d'accès qui en
-- dépendent) qu'avec une session de niveau aal2, c'est-à-dire après avoir
-- saisi son code. Un mot de passe volé ne suffit plus. Tant qu'aucun
-- facteur n'est activé, rien ne change (pas de blocage involontaire) ; le
-- tableau de bord invite à l'activer. Idempotent.

create or replace function public.mfa_satisfaite()
returns boolean language sql stable security definer set search_path = public, auth
as $$
  select coalesce(auth.jwt() ->> 'aal', 'aal1') = 'aal2'
      or not exists (
        select 1 from auth.mfa_factors f where f.user_id = auth.uid() and f.status = 'verified'
      );
$$;
revoke execute on function public.mfa_satisfaite() from public;
grant execute on function public.mfa_satisfaite() to anon, authenticated, service_role;

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public
as $$
  select exists (
    select 1 from public.profiles p where p.id = auth.uid() and p.editorial_role = 'admin'
  ) and public.mfa_satisfaite();
$$;

create or replace function public.has_editorial_role(min_role text)
returns boolean language sql stable security definer set search_path = public
as $$
  select exists (
    select 1 from public.profiles p
    where p.id = auth.uid()
      and (
        p.editorial_role = 'admin'
        or (min_role = 'relecteur' and p.editorial_role in ('relecteur', 'validateur'))
        or (min_role = 'validateur' and p.editorial_role = 'validateur')
      )
  ) and public.mfa_satisfaite();
$$;
