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
\set lecteur   '00000000-0000-0000-0000-00000000a005'

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

-- ---------------------------------------------------------------------------
-- 10. Tarif médecin en formation : chacun ne voit que ses demandes.
-- ---------------------------------------------------------------------------
insert into public.student_discount_requests (user_id, statut, annee_universitaire, file_path, file_name)
values (:'gratuit', 'interne', '2026-2027', :'gratuit' || '/x.pdf', 'carte.pdf');
select pg_temp.agir(:'gratuit');
set role authenticated;
select pg_temp.ok((select count(*) from public.student_discount_requests) = 1, 'interne : sa demande est visible');
reset role;
select pg_temp.agir(:'premium');
set role authenticated;
select pg_temp.ok((select count(*) from public.student_discount_requests) = 0, 'autre membre : demande d''autrui invisible');
do $$
begin
  insert into public.student_discount_requests (user_id, statut, annee_universitaire, file_path, file_name)
  values ('00000000-0000-0000-0000-00000000a002', 'interne', '2026-2027', 'x', 'x');
  raise exception 'ÉCHEC : un membre a pu créer une demande directement';
exception when insufficient_privilege then null;
end $$;
select pg_temp.ok(
  not has_table_privilege('authenticated', 'public.student_discount_requests', 'update'),
  'membre : ni création ni validation directe (serveur seulement)');
reset role;

-- ---------------------------------------------------------------------------
-- 11. Anti-extraction : pas de lecture en masse, suspension au-delà du rythme.
-- ---------------------------------------------------------------------------
insert into auth.users (id, email, raw_user_meta_data, email_confirmed_at) values
  (:'lecteur', 'lecteur@test.fr', '{"prenom":"Lecteur","specialty_slug":"anesthesie_reanimation"}', now());
insert into public.subscriptions (user_id, plan, status, current_period_end)
values (:'lecteur', 'premium', 'actif', now() + interval '1 year');
select pg_temp.agir(:'lecteur');
set role authenticated;
create temp table lisibles as
  select d.id, row_number() over (order by d.id) as n from public.documents d where public.can_read_document(d.id);
select pg_temp.ok((select count(*) from lisibles) > 21, 'PREMIUM : plus de 21 fiches lisibles pour le scénario');
select pg_temp.ok((select count(*) from public.recommendations) = 0,
  'membre : aucune recommandation lisible directement (pas de téléchargement en masse)');
select pg_temp.ok(jsonb_array_length(public.get_document_recommendations((select id from lisibles where n = 1))) >= 0,
  'membre : recommandations d''une fiche lisibles par la fonction contrôlée');
select pg_temp.ok((select bool_and(public.get_document_presentation(id) is not null) from lisibles where n <= 20),
  'lecture normale : 20 fiches différentes en 10 minutes acceptées');
select pg_temp.ok(public.get_document_presentation((select id from lisibles where n = 1)) is not null,
  'relire une fiche déjà ouverte ne compte pas');
select pg_temp.ok(public.get_document_presentation((select id from lisibles where n = 21)) is null,
  'rythme anormal : la 21e fiche en 10 minutes est refusée');
select pg_temp.ok(public.is_access_blocked() and not public.can_read_document((select id from lisibles where n = 2)),
  'compte suspendu : plus aucune fiche lisible');
select pg_temp.ok(public.unlock_document((select id from lisibles where n = 2)) ->> 'status' = 'suspendu',
  'compte suspendu : aucun déblocage possible');
select pg_temp.ok((select count(*) from public.content_reads) = 0, 'membre : journal des lectures non consultable');
reset role;
select pg_temp.ok(
  (select reason = 'rythme_10min' and distinct_documents = 21 and blocked_until > now() + interval '55 minutes'
     from public.access_blocks where user_id = :'lecteur'),
  'suspension enregistrée (motif, nombre de fiches, durée 1 h)');
update public.access_blocks set blocked_until = now() where user_id = :'lecteur';
select pg_temp.agir(:'lecteur');
set role authenticated;
select pg_temp.ok(not public.is_access_blocked() and public.can_read_document((select id from lisibles where n = 2)),
  'suspension levée : lecture rétablie');
reset role;
select pg_temp.agir(:'validateur');
set role authenticated;
select pg_temp.ok((select count(*) from public.recommendations) > 0, 'équipe éditoriale : recommandations lisibles');
select pg_temp.ok((select bool_and(public.get_document_presentation(d.id) is not null)
                     from (select id from public.documents limit 30) d),
  'équipe éditoriale : jamais suspendue');
reset role;

-- ---------------------------------------------------------------------------
-- 12. Journal public des corrections : lisible sans compte, sans donnée personnelle.
-- ---------------------------------------------------------------------------
insert into public.corrections_log (document_id, criticite, resume, created_by)
values (:'f8', 'majeure', 'Posologie corrigée dans le tableau 2', :'validateur'),
       (:'f6', 'mineure', 'Coquille corrigée (fiche retirée)', :'validateur');
set role anon;
select pg_temp.ok((select count(*) from public.corrections_log where resume like 'Posologie%') = 1,
  'visiteur : correction d''une fiche en ligne visible');
select pg_temp.ok((select count(*) from public.corrections_log where document_id = :'f6') = 0,
  'visiteur : correction d''une fiche retirée invisible');
select pg_temp.ok(not has_column_privilege('anon', 'public.corrections_log', 'created_by', 'select')
  and not has_column_privilege('authenticated', 'public.corrections_log', 'error_report_id', 'select')
  and not has_table_privilege('authenticated', 'public.corrections_log', 'insert'),
  'journal : ni auteur ni signalement exposés, aucune écriture directe');
select pg_temp.ok(has_column_privilege('anon', 'public.documents', 'source_verified_at', 'select'),
  'date de vérification de la source lisible avec les métadonnées');
reset role;

-- ---------------------------------------------------------------------------
-- 13. Recommandations divergentes : visibles avec la fiche, jamais sans droits.
-- ---------------------------------------------------------------------------
insert into public.divergences (id, question) values ('00000000-0000-0000-0000-0000000000d1', 'Question de test');
insert into public.divergence_positions (divergence_id, document_id, position, sort_order) values
  ('00000000-0000-0000-0000-0000000000d1', :'f1', 'Position A', 0),
  ('00000000-0000-0000-0000-0000000000d1', :'f8', 'Position B', 1);
select pg_temp.agir(:'gratuit');
set role authenticated;
select pg_temp.ok(jsonb_array_length(public.get_divergences(:'f1') -> 0 -> 'positions') = 2,
  'fiche lisible : encadré avec les deux positions');
select pg_temp.ok(public.get_divergences(:'f8') is null, 'fiche non débloquée : aucune divergence transmise');
select pg_temp.ok((select count(*) from public.divergence_positions) = 0, 'membre : tables non lisibles directement');
reset role;

-- ---------------------------------------------------------------------------
-- 14. Actualisations écartées : réservées à l'équipe éditoriale.
-- ---------------------------------------------------------------------------
insert into public.actualisations_ecartees (ancienne_id, nouvelle_id) values (:'f1', :'f2');
select pg_temp.agir(:'premium');
set role authenticated;
select pg_temp.ok((select count(*) from public.actualisations_ecartees) = 0, 'membre : propositions écartées invisibles');
reset role;
select pg_temp.agir(:'validateur');
set role authenticated;
select pg_temp.ok((select count(*) from public.actualisations_ecartees) = 1, 'équipe éditoriale : propositions écartées visibles');
reset role;

-- ---------------------------------------------------------------------------
-- 15. Recette : réservée aux administrateurs.
-- ---------------------------------------------------------------------------
insert into public.recette_validations (code) values ('1.1-1');
select pg_temp.agir(:'validateur');
set role authenticated;
select pg_temp.ok((select count(*) from public.recette_validations) = 0, 'recette : invisible hors administrateurs');
reset role;

-- ---------------------------------------------------------------------------
-- 16. Durcissement : aucun droit superflu, signalements limités.
-- ---------------------------------------------------------------------------
select pg_temp.ok(not has_table_privilege('authenticated', 'public.subscriptions', 'truncate')
  and not has_table_privilege('anon', 'public.profiles', 'update')
  and not has_table_privilege('anon', 'public.error_reports', 'insert'),
  'durcissement : ni TRUNCATE ni écriture pour les visiteurs');
select pg_temp.agir(:'urgence');
set role authenticated;
do $$
declare i int;
begin
  for i in 1..20 loop
    insert into public.error_reports (user_id, doc, description) values ('00000000-0000-0000-0000-00000000a003', 'x', 'test ' || i);
  end loop;
  begin
    insert into public.error_reports (user_id, doc, description) values ('00000000-0000-0000-0000-00000000a003', 'x', 'test 21');
    raise exception 'ÉCHEC : 21e signalement accepté';
  exception when sqlstate '54000' then null;
  end;
end $$;
select 'ok  signalements : 21e en 24 h refusé';
reset role;

-- ---------------------------------------------------------------------------
-- 17. Double authentification : droits éditoriaux seulement avec le code.
-- ---------------------------------------------------------------------------
insert into auth.mfa_factors (user_id) values (:'validateur');
select pg_temp.agir(:'validateur');
set role authenticated;
select set_config('request.jwt.claims', '{"aal":"aal1"}', false);
select pg_temp.ok(not public.has_editorial_role('relecteur'), 'MFA activée, session sans code (aal1) : aucun droit éditorial');
select set_config('request.jwt.claims', '{"aal":"aal2"}', false);
select pg_temp.ok(public.has_editorial_role('validateur'), 'MFA activée, code saisi (aal2) : droits rétablis');
reset role;
select set_config('request.jwt.claims', '', false);

-- ---------------------------------------------------------------------------
-- 18. Journal d'administration : changements de l'équipe et rôles tracés.
-- ---------------------------------------------------------------------------
select pg_temp.agir(:'validateur');
select set_config('request.jwt.claims', '{"aal":"aal2"}', false);
set role authenticated;
update public.documents set freshness_status = 'a_jour' where id = :'f5';
select pg_temp.ok((select count(*) from public.audit_log) = 0, 'journal : illisible hors administrateurs');
reset role;
select set_config('request.jwt.claims', '', false);
select pg_temp.ok(exists (select 1 from public.audit_log where entity_type = 'documents' and entity_id = :'f5' and actor_id = :'validateur'),
  'journal : modification de fiche tracée avec son auteur');
update public.profiles set editorial_role = 'admin' where id = :'gratuit';
select pg_temp.ok(exists (select 1 from public.audit_log where entity_type = 'profiles' and entity_id = :'gratuit'),
  'journal : élévation de rôle tracée même hors du site');
update public.profiles set editorial_role = null where id = :'gratuit';

-- ---------------------------------------------------------------------------
-- 19. Verrou de publication : source, date et statut juridique validé.
-- ---------------------------------------------------------------------------
create function pg_temp.refuse(requete text, raison text) returns boolean
language plpgsql as $$
begin
  execute requete;
  return false;
exception when others then
  return sqlerrm like '%' || raison || '%';
end $$;
grant execute on function pg_temp.refuse(text, text) to authenticated;
select id as fv from public.documents
 where freshness_status <> 'retiree' and published_at is not null and publication_date is not null
   and coalesce(source_url, '') <> '' and id not in (:'f1', :'f2', :'f3', :'f4', :'f5', :'f6', :'f7', :'f8')
 order by title limit 1 \gset
select pg_temp.agir(:'validateur');
select set_config('request.jwt.claims', '{"aal":"aal2"}', false);
set role authenticated;
select public.publish_document(:'fv', false);
select pg_temp.ok(pg_temp.refuse(format('select public.publish_document(%L, true)', :'fv'), 'juridique'),
  'publication refusée sans statut juridique validé');
select pg_temp.ok(pg_temp.refuse(format('update public.documents set published_at = now() where id = %L', :'fv'), 'juridique'),
  'mise en ligne directe par l''API refusée sans statut juridique validé');
insert into public.source_legal_profiles (document_id, legal_review_status) values (:'fv', 'en_revue');
select pg_temp.ok(pg_temp.refuse(format('select public.publish_document(%L, true)', :'fv'), 'juridique'),
  'publication refusée avec un statut juridique « en revue »');
update public.source_legal_profiles set legal_review_status = 'valide' where document_id = :'fv';
select public.publish_document(:'fv', true);
select pg_temp.ok((select published_at is not null from public.documents where id = :'fv'),
  'publication acceptée avec source, date et statut juridique validé');
select public.publish_document(:'fv', false);
reset role;
update public.documents set publication_date = null where id = :'fv';
set role authenticated;
select pg_temp.ok(pg_temp.refuse(format('select public.publish_document(%L, true)', :'fv'), 'Date'),
  'publication refusée sans date de la source');
reset role;
select set_config('request.jwt.claims', '', false);
select pg_temp.ok(exists (select 1 from public.audit_log where entity_type = 'source_legal_profiles'),
  'registre juridique : modifications tracées');
update public.documents set publication_date = '2020-01-01', published_at = now() where id = :'fv';

-- ---------------------------------------------------------------------------
-- 20. Suggestions des membres : privées, auteur imposé, limitées.
-- ---------------------------------------------------------------------------
select pg_temp.agir(:'gratuit');
set role authenticated;
insert into public.site_suggestions (categorie, message, page) values ('amelioration', 'Ajouter un mode sombre', '/bibliotheque');
select pg_temp.ok(pg_temp.refuse(format('insert into public.site_suggestions (user_id, categorie, message) values (%L, %L, %L)', :'premium', 'autre', 'au nom d''un autre'), 'row-level security'),
  'suggestion : impossible d''écrire au nom d''un autre membre');
select pg_temp.ok(pg_temp.refuse('insert into public.site_suggestions (categorie, message, status) values (''autre'', ''déjà traitée ?'', ''traite'')', 'row-level security'),
  'suggestion : statut imposé à « nouveau »');
select pg_temp.agir(:'premium');
select pg_temp.ok((select count(*) from public.site_suggestions) = 0, 'suggestion : invisible pour les autres membres');
select pg_temp.agir(:'gratuit');
select pg_temp.ok((select count(*) from public.site_suggestions) = 1, 'suggestion : relue par son auteur');
select pg_temp.ok(pg_temp.refuse('update public.site_suggestions set status = ''traite''', 'permission denied'),
  'suggestion : statut non modifiable par le membre');
insert into public.site_suggestions (categorie, message) select 'autre', 'message ' || g from generate_series(1, 9) g;
select pg_temp.ok(pg_temp.refuse('insert into public.site_suggestions (categorie, message) values (''autre'', ''onzième'')', '24 heures'),
  'suggestion : 11e message en 24 h refusé');
reset role;

-- ---------------------------------------------------------------------------
-- 21. Traductions : publication seulement si le registre l'autorise.
-- ---------------------------------------------------------------------------
select document_id as ft, lang as lt from public.document_translations limit 1 \gset
select pg_temp.ok(pg_temp.refuse(format('update public.document_translations set status = ''publiee'' where document_id = %L and lang = %L', :'ft', :'lt'), 'traduction non autorisée'),
  'traduction : publication refusée sans autorisation de traduction');
insert into public.source_legal_profiles (document_id, legal_review_status, translation_allowed) values (:'ft', 'valide', 'oui')
  on conflict (document_id) do update set legal_review_status = 'valide', translation_allowed = 'oui';
update public.document_translations set status = 'publiee' where document_id = :'ft' and lang = :'lt';
select pg_temp.ok((select status = 'publiee' from public.document_translations where document_id = :'ft' and lang = :'lt'),
  'traduction : publication acceptée quand le registre l''autorise');

-- ---------------------------------------------------------------------------
-- 22. Reformulation des libellés : validateur seulement, fiche inchangée.
-- ---------------------------------------------------------------------------
-- Les propositions se rattachent aux fiches : rejouer la migration une fois
-- le contenu chargé (idempotent).
\set QUIET 1
set client_min_messages = warning;
\i supabase/migrations/20261001150000_reformulation_libelles.sql
select id as r1, document_id as rd, chemin as rc from public.libelles_reformulation order by fiche_key, chemin limit 1 \gset
select id as r2 from public.libelles_reformulation where id <> :'r1' order by fiche_key, chemin limit 1 \gset
select pg_temp.agir(:'gratuit');
set role authenticated;
select pg_temp.ok((select count(*) from public.libelles_reformulation) = 0, 'reformulations : invisibles pour un membre');
select pg_temp.ok(pg_temp.refuse(format('select public.appliquer_reformulation(%L, %L)', :'r1', 'texte'), 'Réservé'),
  'reformulations : application refusée à un membre');
reset role;
select pg_temp.agir(:'validateur');
select set_config('request.jwt.claims', '{"aal":"aal2"}', false);
set role authenticated;
select pg_temp.ok(public.appliquer_reformulation(:'r1', 'Libellé reformulé de test.') = 'ok', 'reformulation appliquée par un validateur');
select pg_temp.ok(public.appliquer_reformulation(:'r1', 'autre') = 'introuvable', 'reformulation : pas de seconde application');
select pg_temp.ok(public.refuser_reformulation(:'r2') = 'ok', 'reformulation refusée par un validateur');
reset role;
select set_config('request.jwt.claims', '', false);
select pg_temp.ok((select presentation_json #>> (:'rc'::text[] || array['html']) from public.documents where id = :'rd') = 'Libellé reformulé de test.',
  'reformulation : le libellé de la fiche est remplacé');
select pg_temp.ok(exists (select 1 from public.audit_log where action = 'reformulation_appliquee' and entity_id = :'rd'),
  'reformulation : tracée au journal');
update public.libelles_reformulation set status = 'proposee' where id = :'r2';
update public.documents d set presentation_json = jsonb_set(d.presentation_json, l.chemin || array['html'], '"modifié entre-temps"')
  from public.libelles_reformulation l where l.id = :'r2' and d.id = l.document_id;
select pg_temp.agir(:'validateur');
select set_config('request.jwt.claims', '{"aal":"aal2"}', false);
set role authenticated;
select pg_temp.ok(public.appliquer_reformulation(:'r2', 'x x x') = 'fiche_modifiee', 'reformulation : refusée si la fiche a changé');
reset role;
select set_config('request.jwt.claims', '', false);

select 'Parcours membre : toutes les vérifications sont passées.';
