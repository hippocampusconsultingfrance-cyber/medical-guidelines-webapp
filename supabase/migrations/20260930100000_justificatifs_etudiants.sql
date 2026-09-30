-- Tarif médecin en formation (CGV §4 ; cahier des charges V4.5 §10) :
-- externes, internes, résidents et docteurs juniors déposent un
-- justificatif de l'année universitaire en cours ; un administrateur le
-- valide ou le refuse. Validation : code promotionnel personnel à usage
-- unique (−30 % la première année), ou remise appliquée au prochain
-- renouvellement si le membre est déjà abonné.
--
--   - student_discount_requests : une ligne par demande ; le membre lit les
--     siennes, les administrateurs toutes ; aucune écriture directe (actions
--     serveur avec la clé service_role, après contrôle du compte) ;
--   - bucket privé « justificatifs » : aucun accès public ni direct ; dépôt
--     et consultation (lien signé de courte durée) par le serveur ; fichier
--     supprimé dès la décision (CGV : justificatifs supprimés après décision).
-- Idempotent.

create table if not exists public.student_discount_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  statut text not null check (statut in ('externe', 'interne', 'resident', 'docteur_junior', 'autre')),
  annee_universitaire text not null,
  file_path text,
  file_name text,
  status text not null default 'en_attente' check (status in ('en_attente', 'valide', 'refuse')),
  decision_note text,
  decided_by uuid references public.profiles(id) on delete set null,
  decided_at timestamptz,
  promotion_code text,
  applied_to_subscription boolean not null default false,
  created_at timestamptz not null default now()
);
create index if not exists student_discount_requests_user_idx on public.student_discount_requests (user_id, created_at desc);
create index if not exists student_discount_requests_pending_idx on public.student_discount_requests (status) where status = 'en_attente';

alter table public.student_discount_requests enable row level security;
revoke all on public.student_discount_requests from anon, authenticated;
grant select on public.student_discount_requests to authenticated;

drop policy if exists student_discount_requests_select_own_or_admin on public.student_discount_requests;
create policy student_discount_requests_select_own_or_admin on public.student_discount_requests for select
  to authenticated
  using (user_id = (select auth.uid()) or public.is_admin());

-- Bucket privé (Supabase Storage), sans aucune règle d'accès pour les
-- membres : seule la clé service_role y lit et y écrit.
do $$
begin
  if to_regclass('storage.buckets') is not null then
    insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
    values ('justificatifs', 'justificatifs', false, 3145728, array['application/pdf', 'image/jpeg', 'image/png'])
    on conflict (id) do update
      set public = false,
          file_size_limit = excluded.file_size_limit,
          allowed_mime_types = excluded.allowed_mime_types;
  end if;
end $$;
