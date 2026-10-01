-- Mention « Relue par Dr …, le … » sur chaque fiche (recette 2.2-2).
--
-- Le nom affiché est figé au moment de la relecture (les profils ne sont pas
-- lisibles par les membres). Seul un validateur peut marquer une fiche comme
-- relue, et uniquement pour lui-même : le nom vient de son propre profil.

alter table public.documents add column if not exists relue_par_nom text;
alter table public.documents add column if not exists relue_le date;
grant select (relue_par_nom, relue_le) on public.documents to anon, authenticated;

create or replace function public.marquer_relue(doc_id uuid, docteur boolean)
returns text
language plpgsql
volatile
security definer
set search_path = public
as $$
declare
  uid uuid := auth.uid();
  nom_affiche text;
begin
  if uid is null or not public.has_editorial_role('validateur') then
    raise exception 'Réservé aux validateurs' using errcode = '42501';
  end if;
  select nullif(trim(coalesce(p.prenom, '') || ' ' || coalesce(p.nom, '')), '')
    into nom_affiche
    from public.profiles p
   where p.id = uid;
  if nom_affiche is null then
    raise exception 'Nom et prénom à renseigner dans Mon compte' using errcode = '23514';
  end if;
  if docteur then
    nom_affiche := 'Dr ' || nom_affiche;
  end if;

  update public.documents d
     set relue_par_nom = nom_affiche,
         relue_le = (now() at time zone 'Europe/Paris')::date
   where d.id = doc_id;
  if not found then
    raise exception 'Fiche introuvable' using errcode = 'P0002';
  end if;

  insert into public.audit_log (actor_id, action, entity_type, entity_id, after)
  values (uid, 'fiche_relue', 'documents', doc_id, jsonb_build_object('relue_par_nom', nom_affiche));
  return nom_affiche;
end;
$$;

revoke all on function public.marquer_relue(uuid, boolean) from public, anon;
grant execute on function public.marquer_relue(uuid, boolean) to authenticated;
