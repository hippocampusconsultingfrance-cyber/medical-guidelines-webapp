-- Parcours membre : règles d'accès appliquées par la base.
-- Joué par tests/base/lancer.sh sur une base de test (jamais en production).
-- Chaque vérification arrête le test à la première erreur, avec son message.
\set ON_ERROR_STOP 1
\set QUIET 1
\pset tuples_only on
\pset format unaligned

-- Vérification : ok(condition, message) échoue si la condition est fausse.
create function pg_temp.ok(condition boolean, message text) returns text
language plpgsql as $$
begin
  if condition is not true then
    raise exception 'ÉCHEC : %', message;
  end if;
  return 'ok  ' || message;
end $$;

-- Agir comme un membre connecté (ou comme visiteur si identifiant vide).
create function pg_temp.agir(identifiant text) returns void
language plpgsql as $$
begin
  perform set_config('request.jwt.claim.sub', coalesce(identifiant, ''), false);
end $$;

\set gratuit   '00000000-0000-0000-0000-00000000a001'
\set premium   '00000000-0000-0000-0000-00000000a002'
\set urgence   '00000000-0000-0000-0000-00000000a003'
\set validateur '00000000-0000-0000-0000-00000000a004'

-- ---------------------------------------------------------------------------
-- Préparation : toutes les fiches en ligne, comme en production.
-- ---------------------------------------------------------------------------
update public.documents set published_at = now() where published_at is null;

-- Fiches réservées à l'anesthésie-réanimation (invisibles en médecine d'urgence).
create temp table fiches as
select d.id, row_number() over (order by d.title) as n
from public.documents d
where exists (select 1 from public.document_specialties ds join public.specialties s on s.id = ds.specialty_id
              where ds.document_id = d.id and s.slug = 'anesthesie_reanimation')
  and not exists (select 1 from public.document_specialties ds join public.specialties s on s.id = ds.specialty_id
                  where ds.document_id = d.id and s.slug = 'medecine_d_urgence')
  and d.presentation_json is not null;
grant select on fiches to authenticated;
select pg_temp.ok((select count(*) from fiches) >= 10, 'au moins 10 fiches d''anesthésie pour le scénario');
select id as f1 from fiches where n = 1 \gset
select id as f2 from fiches where n = 2 \gset
select id as f3 from fiches where n = 3 \gset
select id as f4 from fiches where n = 4 \gset
select id as f5 from fiches where n = 5 \gset
select id as f6 from fiches where n = 6 \gset
select id as f7 from fiches where n = 7 \gset
select id as f8 from fiches where n = 8 \gset

-- ---------------------------------------------------------------------------
-- 1. Inscription : la spécialité choisie est enregistrée sur le profil.
-- ---------------------------------------------------------------------------
insert into auth.users (id, email, raw_user_meta_data, email_confirmed_at) values
  (:'gratuit', 'gratuit@test.fr', '{"prenom":"Gratuit","specialty_slug":"anesthesie_reanimation"}', now()),
  (:'premium', 'premium@test.fr', '{"prenom":"Premium","specialty_slug":"anesthesie_reanimation"}', now()),
  (:'urgence', 'urgence@test.fr', '{"prenom":"Urgence","specialty_slug":"medecine_d_urgence"}', now()),
  (:'validateur', 'valid@test.fr', '{"prenom":"Valid","specialty_slug":"anesthesie_reanimation"}', now());
select pg_temp.ok(
  (select s.slug from public.profiles p join public.specialties s on s.id = p.specialty_id where p.id = :'gratuit') = 'anesthesie_reanimation',
  'inscription : spécialité anesthésie-réanimation enregistrée');
select pg_temp.ok(
  (select s.slug from public.profiles p join public.specialties s on s.id = p.specialty_id where p.id = :'urgence') = 'medecine_d_urgence',
  'inscription : spécialité médecine d''urgence enregistrée');
update public.profiles set editorial_role = 'validateur' where id = :'validateur';

-- ---------------------------------------------------------------------------
-- 2. Compte gratuit : fiches visibles mais bloquées, 5 crédits.
-- ---------------------------------------------------------------------------
set role authenticated;
select pg_temp.agir(:'gratuit');
select pg_temp.ok((select count(*) from public.documents) >= 10, 'gratuit : le catalogue de sa spécialité est visible');
select pg_temp.ok(not public.has_premium(), 'gratuit : pas PREMIUM');
select pg_temp.ok(not public.can_read_document(:'f1'), 'gratuit : fiche bloquée par défaut');
select pg_temp.ok(public.get_document_presentation(:'f1') is null, 'gratuit : contenu d''une fiche bloquée non transmis');
select pg_temp.ok(not has_column_privilege('public.documents', 'presentation_json', 'select'),
  'contenu des fiches jamais lisible directement (colonne protégée)');

select pg_temp.ok(public.unlock_document(:'f1') ->> 'status' = 'debloque', 'crédit 1 : fiche débloquée');
select pg_temp.ok(public.can_read_document(:'f1'), 'fiche débloquée : lisible');
select pg_temp.ok(public.get_document_presentation(:'f1') is not null, 'fiche débloquée : contenu transmis');
select pg_temp.ok(public.unlock_document(:'f1') ->> 'status' = 'deja', 'même fiche : aucun crédit consommé');
select pg_temp.ok(public.unlock_document(:'f2') ->> 'status' = 'debloque', 'crédit 2');
select pg_temp.ok(public.unlock_document(:'f3') ->> 'status' = 'debloque', 'crédit 3');
select pg_temp.ok(public.unlock_document(:'f4') ->> 'status' = 'debloque', 'crédit 4');
select pg_temp.ok((public.unlock_document(:'f5') ->> 'used')::int = 5, 'crédit 5 : 5 crédits utilisés');
select pg_temp.ok(public.unlock_document(:'f6') ->> 'status' = 'quota_atteint', '6e fiche : refusée, quota atteint');
select pg_temp.ok(not public.can_read_document(:'f6'), '6e fiche : reste bloquée');

-- Tentatives de contournement.
do $$
declare passe boolean := false;
begin
  begin
    insert into public.document_unlocks (user_id, document_id)
    values (auth.uid(), (select id from pg_temp.fiches where n = 6));
    passe := true;
  exception when others then null;
  end;
  if passe then raise exception 'ÉCHEC : un membre a pu s''ajouter un déblocage lui-même'; end if;

  begin
    insert into public.subscriptions (user_id, plan, status) values (auth.uid(), 'premium', 'actif');
    passe := true;
  exception when others then null;
  end;
  if passe then raise exception 'ÉCHEC : un membre a pu s''attribuer PREMIUM'; end if;

  begin
    update public.profiles set editorial_role = 'admin' where id = auth.uid();
    passe := true;
  exception when others then null;
  end;
  if passe then raise exception 'ÉCHEC : un membre a pu se donner un rôle éditorial'; end if;

  update public.documents set freshness_status = 'retiree' where id = (select id from pg_temp.fiches where n = 1);
  if found then raise exception 'ÉCHEC : un membre a pu modifier une fiche'; end if;
end $$;
select 'ok  contournements refusés (déblocage, PREMIUM, rôle, modification de fiche)';
reset role;

-- ---------------------------------------------------------------------------
-- 3. PREMIUM : tout est ouvert sans consommer de crédit.
-- ---------------------------------------------------------------------------
select pg_temp.agir(:'premium');
set role authenticated;
select pg_temp.ok(public.unlock_document(:'f1') ->> 'status' = 'debloque', 'futur PREMIUM : 1 crédit utilisé avant abonnement');
select pg_temp.ok(public.unlock_document(:'f2') ->> 'status' = 'debloque', 'futur PREMIUM : 2 crédits utilisés avant abonnement');
reset role;
-- Abonnement enregistré par le webhook Stripe (clé service_role).
insert into public.subscriptions (user_id, plan, status, current_period_end)
values (:'premium', 'premium', 'actif', now() + interval '1 year');
set role authenticated;
select pg_temp.ok(public.has_premium(), 'PREMIUM actif');
select pg_temp.ok(public.can_read_document(:'f8'), 'PREMIUM : fiche jamais débloquée lisible');
select pg_temp.ok(public.get_document_presentation(:'f8') is not null, 'PREMIUM : contenu transmis');
select pg_temp.ok(public.unlock_document(:'f7') ->> 'status' = 'premium', 'PREMIUM : aucun crédit consommé');
reset role;

-- ---------------------------------------------------------------------------
-- 4. Fin d'abonnement : retour au gratuit sans rien perdre.
-- ---------------------------------------------------------------------------
update public.subscriptions set status = 'expire', current_period_end = now() - interval '1 day'
where user_id = :'premium';
set role authenticated;
select pg_temp.ok(not public.has_premium(), 'abonnement expiré : plus PREMIUM');
select pg_temp.ok(public.can_read_document(:'f1') and public.can_read_document(:'f2'),
  'abonnement expiré : fiches débloquées avant restent ouvertes');
select pg_temp.ok(not public.can_read_document(:'f8'), 'abonnement expiré : les autres fiches se rebloquent');
select pg_temp.ok((public.unlock_document(:'f3') ->> 'used')::int = 3, 'abonnement expiré : crédits restants utilisables (3e sur 5)');
reset role;
-- Paiement en retard : PREMIUM suspendu aussi.
update public.subscriptions set status = 'en_retard', current_period_end = now() + interval '1 month'
where user_id = :'premium';
set role authenticated;
select pg_temp.ok(not public.has_premium(), 'paiement en retard : PREMIUM suspendu');
reset role;

-- ---------------------------------------------------------------------------
-- 5. Cloisonnement par spécialité.
-- ---------------------------------------------------------------------------
select pg_temp.agir(:'urgence');
set role authenticated;
select pg_temp.ok(not exists (select 1 from public.documents where id = :'f1'),
  'médecine d''urgence : fiche d''anesthésie absente du catalogue');
select pg_temp.ok(public.unlock_document(:'f1') ->> 'status' = 'indisponible',
  'médecine d''urgence : fiche d''anesthésie impossible à débloquer');
reset role;

-- ---------------------------------------------------------------------------
-- 6. Fiche dépubliée ou retirée : invisible pour les membres.
-- ---------------------------------------------------------------------------
update public.documents set published_at = null where id = :'f7';
update public.recommendations set status = 'draft' where document_id = :'f7' and status = 'active';
update public.documents set freshness_status = 'retiree' where id = :'f6';
select pg_temp.agir(:'gratuit');
set role authenticated;
select pg_temp.ok(not exists (select 1 from public.documents where id = :'f7'), 'fiche dépubliée : invisible');
select pg_temp.ok(public.unlock_document(:'f7') ->> 'status' = 'indisponible', 'fiche dépubliée : impossible à débloquer');
select pg_temp.ok(not exists (select 1 from public.documents where id = :'f6'), 'fiche retirée : invisible');
select pg_temp.ok(not exists (select 1 from public.search_documents('recommandation') s where s.document_id in (:'f6', :'f7')),
  'recherche : ne renvoie ni fiche dépubliée ni fiche retirée');
reset role;

-- ---------------------------------------------------------------------------
-- 7. Visiteur non connecté : rien de lisible.
-- ---------------------------------------------------------------------------
select pg_temp.ok(
  not has_function_privilege('anon', 'public.get_document_presentation(uuid)', 'execute')
  and not has_function_privilege('anon', 'public.unlock_document(uuid)', 'execute')
  and not has_column_privilege('anon', 'public.documents', 'presentation_json', 'select'),
  'visiteur : aucun accès au contenu des fiches ni au déblocage');

-- ---------------------------------------------------------------------------
-- 8. Veille : un validateur peut changer le statut et publier une version.
-- ---------------------------------------------------------------------------
select pg_temp.agir(:'validateur');
set role authenticated;
insert into public.document_versions (document_id, version_label, change_type, published_at, created_by)
values (:'f5', 'Test 2026', 'majeure', now(), :'validateur');
update public.documents set freshness_status = 'revision_detectee' where id = :'f5';
select pg_temp.ok((select freshness_status from public.documents where id = :'f5') = 'revision_detectee',
  'validateur : statut de fraîcheur modifié et version publiée');
reset role;

-- ---------------------------------------------------------------------------
-- 9. Traductions : brouillons réservés à l'équipe éditoriale.
-- ---------------------------------------------------------------------------
select pg_temp.ok((select count(*) from public.document_translations) >= 1, 'traductions importées en brouillon');
select document_id as tr from public.document_translations limit 1 \gset
select pg_temp.agir(:'premium');
set role authenticated;
select pg_temp.ok((select count(*) from public.document_translations) = 0, 'membre : aucune traduction visible');
select pg_temp.ok(not public.review_translation(:'tr', 'en', true, 'x'), 'membre : relecture refusée');
reset role;
select pg_temp.agir(:'validateur');
set role authenticated;
select pg_temp.ok((select count(*) from public.document_translations) >= 1, 'équipe éditoriale : traductions visibles');
select pg_temp.ok(public.review_translation(:'tr', 'en', true, 'relu'), 'équipe éditoriale : traduction marquée relue');
reset role;
select pg_temp.ok(
  (select status = 'relue' and reviewed_by = :'validateur' from public.document_translations where document_id = :'tr' and lang = 'en'),
  'relecture enregistrée avec son auteur');

select 'Parcours membre : toutes les vérifications sont passées.';
