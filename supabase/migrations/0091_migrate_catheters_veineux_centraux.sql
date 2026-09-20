-- Migration : Infections liées aux cathéters veineux centraux en
-- réanimation — réactualisation de la 12e conférence de consensus SRLF de
-- 1994. J.-F. Timsit (coordination adulte), P. Durand (coordination
-- pédiatrie). Reçu et accepté le 11 décembre 2002 ; publié Réanimation 12
-- (2003) 258-265, DOI 10.1016/S1624-0693(03)00051-3.
-- Source : rfe-sfar-website/build/content_catheters_veineux_centraux.json
-- (2 champs de fiche : Q1/Q2/Q3 définition-diagnostic/mécanismes/facteurs de
-- risque ; Q4/Q5 prévention 5.1-5.10 + stratégie diagnostique-thérapeutique
-- 6.1.1-6.2.4 + Figure 1 algorithme + sources).
--
-- ⚠️ NATURE DU DOCUMENT ET MÉTHODOLOGIE DE SÉLECTION DES LIGNES
-- `recommendations` — LIRE AVANT TOUTE RELECTURE DE CE FICHIER : contrairement
-- à `0086_migrate_brule_grave.sql` (24 recommandations déjà atomiques,
-- numérotées R par la source) ou `0084_migrate_sauv.sql` (aucun système de
-- grade, décomposé par sous-section normative), cette source est une PROSE
-- de conférence de consensus où PRESQUE CHAQUE PHRASE/CLAUSE porte son
-- propre tag Niveau-Score (voir grille ci-dessous) — mélangeant, sans les
-- distinguer typographiquement, (a) des recommandations de pratique
-- authentiques ("il faut/recommandé/préférée/à proscrire/réservé à"),
-- (b) des constats probatoires (efficacité démontrée/non démontrée, "réduit
-- le risque"), (c) des critères de définition/classification diagnostique,
-- (d) de l'épidémiologie/des facteurs de risque descriptifs, et (e) des
-- points explicitement non résolus. Le mandat de cette migration
-- ("énoncés cliniques atomiques 'il faut/il est recommandé de faire X'")
-- exige de ne migrer QUE la catégorie (a). Méthode appliquée, disclosed
-- intégralement pour audit :
--   - INCLUS : chaque clause à verbe prescriptif univoque (recommandé / non
--     recommandé / préférée / réservée à / à proscrire / doit être / n'a pas
--     d'indication / envisagé / discutée / limiter / former / élaborer...)
--     tirée de Q1 (uniquement le choix de technique diagnostique, PAS les
--     définitions de cas), Q4 (5.1 à 5.10, prévention) et Q5 (6.1.1 à
--     6.2.4, stratégie diagnostique/thérapeutique). Une clause non taguée
--     par la source (pas de "[N-lettre]") est incluse avec grade NULL
--     UNIQUEMENT si elle reste un énoncé directif ferme et unique (pas une
--     option parmi plusieurs) — ex. "intervalle optimal ... au moins 72 h" ;
--     jamais pour une clause présentant explicitement plusieurs attitudes
--     équivalentes ("plusieurs attitudes sont possibles", "peut être
--     envisagé, voire...").
--   - EXCLU, catégorie (c) définitions/critères diagnostiques de Q1 (tableau
--     "ILC sans bactériémie [2-c]" / "ILC bactériémique [2-c]" / "Infection
--     NON liée au CVC") : ce sont des critères de classification, pas des
--     directives d'action ; leur contenu complet reste dans le
--     `content_*.json` de la fiche (présentation), non dupliqué ici.
--   - EXCLU, catégorie (d) : la totalité de Q2 (mécanismes de colonisation —
--     2 tags gradés [2-b]/[2-b] sur des constats de voie de contamination,
--     aucun verbe prescriptif) et de Q3 (facteurs de risque/incidence/
--     pronostic — environ 15 clauses gradées : ex. sexe masculin [3-b],
--     immunodépression [3-c], densité des soins [2-b], durée de
--     cathétérisme [1-b]/[3-c], Swan-Ganz >J4 [2-b], morbi-mortalité
--     [1-b]x3) : ce sont des associations épidémiologiques/pronostiques,
--     pas des recommandations de pratique, même gradées.
--   - EXCLU, catégorie (e) : toute clause taguée "[point non résolu]" —
--     jamais convertie en fausse recommandation gradée. Liste exhaustive
--     des 7 occurrences trouvées : (1) Q1, délai différentiel de
--     positivité pour cathéters <14j ; (2) Q3, voie fémorale/jugulaire
--     interne chez l'enfant ; (3) §5.2, cathéters imprégnés d'antibiotiques
--     (études complémentaires nécessaires) ; (4) §5.5, éponges imprégnées
--     de chlorhexidine ; (5) §5.6, absence de comparaison povidone
--     iodée-alcool / chlorhexidine-alcool ; (6) §5.7, effet de
--     l'héparinisation générale sur le risque infectieux ; (7) §6.1.1,
--     extension du critère "ablation immédiate" au patient immunodéprimé.
--   - EXCLU, catégorie (b) constats probatoires sans verbe prescriptif même
--     gradés : ex. §5.1 "cathéters imprégnés d'héparine n'ont pas fait la
--     preuve de leur efficacité anti-infectieuse chez l'adulte [2-b]" / "ils
--     diminuent le risque de thrombose [1-a]" / suggestion pédiatrique
--     héparine [2-b] ; §5.2 caveat résistance rifampicine [2-c]/[1-b] ;
--     §5.3 "risque des cathéters multilumières non supérieur [2-a]" ; §5.6
--     caveat méthodologique méta-analyse chlorhexidine [2-a]. Ces constats
--     motivent des recommandations incluses par ailleurs (ex. R08/R09 pour
--     le caveat rifampicine) sans être eux-mêmes dupliqués comme lignes.
--   - EXCLU : la Figure 1 (algorithme décisionnel, 7 étapes, table "Étape /
--     Situation -> Conduite"). Aucune de ses cellules ne porte de tag
--     Niveau-Score (contrairement au reste du document) et chaque branche
--     combine plusieurs conditions (germe + délai + résultat d'examen) —
--     l'atomiser en lignes `recommendations` isolées risquerait de perdre
--     la conditionnalité multi-branches ou de forcer un grade NULL sur un
--     contenu que la source elle-même qualifie de "durée proposée avec
--     réserve dans le schéma source". Ses seuils numériques réellement
--     nouveaux (ex. durées d'antibiothérapie 14-21j si ILC certaine à germe
--     à haut risque, 4-6 semaines si endocardite/thrombophlébite, 6-8
--     semaines si ostéomyélite) ne sont donc PAS repris comme lignes
--     `recommendations` — disclosure au lieu d'une atomisation hasardeuse ;
--     contenu déjà intégralement dans `content_*.json` (fiche).
--
-- ⚠️ INCOHÉRENCES INTERNES DE LA SOURCE — disclosed, jamais résolues :
--   1. Fréquence des manipulations de la ligne comme facteur de risque
--      (Q3, tableau) est gradée [2-c], tandis que la recommandation "limiter
--      les manipulations" (§5.7, ligne R31 ci-dessous) est gradée [2-b] pour
--      le même phénomène clinique — un seul chiffre est repris par ligne
--      (celui effectivement attaché à la clause migrée), la divergence de
--      grade entre le tableau épidémiologique et la section prévention
--      n'est PAS arbitrée ici.
--   2. Liste des germes "à haut risque" imposant le retrait : §6.1.1 (gradé
--      [1-b]) cite "S. aureus, Pseudomonas ou Candida" ; §6.2 (non gradé à
--      cet endroit précis) cite "S. aureus, Candida sp., Pseudomonas sp.,
--      Coryné JK, Bacillus sp." — liste élargie mais non regradée. R54
--      reprend la liste gradée de 6.1.1 telle quelle ; l'élargissement de
--      6.2 n'est pas fusionné dedans (pas d'invention d'un grade pour
--      Coryné JK/Bacillus sp.).
--   3. L'asepsie chirurgicale à la pose est à la fois un facteur de risque
--      épidémiologique (Q3, "moins d'ILC en son absence [1-a]", exclu
--      catégorie (d)) et une recommandation de pratique (§5.3, R10 ci-
--      dessous, [1-a]) — même grade dans les deux mentions, donc pas de
--      contradiction à arbitrer, mais seule la formulation prescriptive de
--      5.3 est reprise en ligne `recommendations` (cf. méthode ci-dessus).
--
-- MÉTHODOLOGIE DE GRADE (reproduite intégralement, aucune interprétation
-- ajoutée) : chaque clause cotée "Niveau-Score", ex. [1-b]. Score
-- d'évaluation (type d'étude) : a = études prospectives contrôlées
-- randomisées ; b = études non randomisées, comparaisons simultanées ou
-- historiques de cohortes ; c = mises au point/revues générales/éditoriaux/
-- séries de cas revues par des experts extérieurs ; d = opinions publiées
-- sans comité de lecture. Niveau de recommandation : 1 = preuves
-- scientifiques indiscutables ; 2 = preuves scientifiques + consensus
-- d'experts ; 3 = pas de preuve scientifique adéquate, soutenu par les
-- données disponibles et l'opinion des experts. `grade` porte donc ici la
-- valeur exacte "N-lettre" (ex. '1-b', '2-c', '3-c'), jamais fusionnée avec
-- une autre — safety net vérifié (`grep -n '"[12][+-]/[12][+-]'`, aucune
-- occurrence possible : ce document n'utilise jamais la convention +/-).
-- `evidence_level` non renseigné (le schéma "Niveau-Score" combiné EST déjà
-- le grade complet pour ce document, il n'existe pas de niveau de preuve
-- distinct séparément publié).
--
-- SOURCE_URL / PDF_URL : `library_final.json` (recherche "cathéter" —
-- exactement 1 correspondance sur ce sujet, titre "Infections liées aux
-- cathéters veineux centraux en réanimation") donne `href` et
-- `direct_pdf_url`, identiques à l'URL source citée par le contenu construit
-- lui-même (aucune divergence). `exact_type` = "Autre" — reproduit tel quel
-- en `doc_type` bien que le contenu se décrive lui-même comme une
-- "réactualisation de la 12e conférence de consensus SRLF" (donc
-- conceptuellement une "CC") : divergence de classification disclosed, non
-- arbitrée (convention de ce projet : `doc_type` reprend `exact_type` de
-- l'index bibliographique verbatim, cf. 0086/0084).
--
-- ⚠️ DATE DE PUBLICATION — disclosed, 3 granularités différentes non
-- contradictoires mais non identiques : `library_final.json.exact_date` =
-- "2002" (année seule) ; le contenu construit cite "reçu et accepté le 11
-- décembre 2002" (date complète) ET une parution "Réanimation 12 (2003)
-- 258-265" (volume 2003). `publication_date` est renseigné à la date
-- complète la plus précise réellement donnée par la source, 2002-12-11 (date
-- d'acceptation du texte, cohérente avec l'année "2002" de l'index) ; la
-- parution en volume 2003 de la revue n'est PAS utilisée pour fabriquer un
-- jour/mois inexistant dans la source (aucun jour/mois de parution papier
-- n'est donné) — les deux faits (accepté 2002-12-11 / paru vol. 2003) sont
-- disclosed ici, non fusionnés en une fausse date unique.
--
-- SOCIÉTÉS — vérification exhaustive effectuée (recherche plein texte de
-- `content_catheters_veineux_centraux.json` pour "SFAR", "SFMU", "SAMU",
-- "SPILF", "CCLIN", "SF2H", "SFHH", "CNGOF", "ADARPEF", "GFRUP", "AFSSAPS",
-- "HAS", "Société" : SEULE une occurrence de "Société" existe, dans
-- "Société de réanimation de langue française (SRLF)") : aucune autre
-- société savante n'est citée nommément dans la fiche construite.
-- Référence [1] (la conférence de consensus ORIGINALE de 1994, pas ce
-- document de réactualisation) a été publiée dans "Rean Urg" (Réanimation
-- et Urgences) — indice possible d'une coorganisation historique avec la
-- médecine d'urgence en 1994, mais cela ne constitue pas une preuve de
-- coauteur pour LA RÉACTUALISATION DE 2002/2003 elle-même, qui s'attribue
-- explicitement à la seule SRLF ("Champ : réactualisation de la 12e
-- conférence de consensus SRLF de 1994", "validé par un groupe de lecture
-- désigné par la SRLF"). En conséquence : SRLF seule liée en
-- `document_societies`, PAS de SFAR/SFMU ajoutée par présomption du
-- périmètre général du site (contrairement à 0086/0084 où SFMU/SFAR étaient
-- explicitement nommées).
--
-- SPÉCIALITÉS — vérifiées contre la liste complète Annexe B/A fournie
-- (jamais une commande grep tronquée) :
--   - `medecine_intensive_reanimation` : société auteure SRLF + champ
--     d'application intégral "en réanimation" + `library_final.json`
--     "category": "Réanimation" (seule catégorie indiquée pour cette
--     entrée).
--   - `infectiologie_maladies_infectieuses_et_tropicales` : Q5 dans son
--     entier (diagnostic/traitement antibiotique des ILC, choix de
--     molécules, durées de traitement par pathogène) relève directement de
--     l'infectiologie.
--   - `pediatrie` : le champ de la fiche couvre explicitement "l'adulte ET
--     l'enfant" (coordination pédiatrique dédiée, P. Durand) ; plusieurs
--     clauses incluses concernent spécifiquement l'enfant (R59, ETO
--     transthoracique chez le jeune enfant).
--   - `anesthesie_reanimation` : EXPLICITEMENT ENVISAGÉE PUIS ÉCARTÉE après
--     vérification — recherche plein texte de "anesth" dans le contenu
--     construit : 0 occurrence ; `library_final.json` "category" pour cette
--     entrée = "Réanimation" seule (pas "Anesthésie, Réanimation" comme
--     d'autres entrées du même index) ; le seul terme périopératoire trouvé
--     ("péri-opératoire", 1 occurrence, §5.9 Swan-Ganz) ne suffit pas à
--     justifier ce rattachement disciplinaire pour l'ensemble du document.
--
-- `doi` repris tel que cité explicitement par la source (jamais deviné).
--
-- Numérotation `recommendation_code` : MG-ANES-000091-R01 à R71, consécutive
-- SANS trou — elle numérote les 71 lignes retenues par la méthode de
-- sélection ci-dessus dans l'ordre d'apparition de la source (Q1 -> §5.1 à
-- 5.10 -> §6.1.1 à 6.2.4), PAS une correspondance 1:1 avec la numérotation
-- fine de la source elle-même (qui n'est pas une liste plate : plusieurs
-- clauses distinctes cohabitent parfois sous un seul repère "§5.x" ou sous
-- un unique tag de grade partagé en fin de phrase composée — dans ce
-- dernier cas, chaque clause distincte de la phrase composée reçoit sa
-- propre ligne mais RÉPÈTE le même grade unique donné par la source, ce qui
-- n'est jamais une invention/fusion de grades différents (règle 4) : voir
-- par ex. R08/R09 (un seul "[2-c]" final couvrant deux clauses de §5.2),
-- R23/R24 (un seul "[2-a]" final, §5.4). Le mapping exact clause -> source
-- est porté par `source_section` sur chaque ligne, pour traçabilité
-- complète malgré cette numérotation séquentielle propre à cette migration.
--
-- ⚠️ A VERIFIER (currence clinique) : ce document date de 2002/2003 ; la
-- fiche source elle-même porte un avertissement explicite ("les pratiques
-- de prévention et de traitement des ILC ayant évolué depuis 2003... se
-- référer à un avis spécialisé et aux recommandations actualisées avant
-- toute décision"). `library_final.json` marque néanmoins ce document
-- "en vigueur" (pas "abrogé") et aucune version plus récente n'a été
-- identifiée dans l'index lors de cette migration — `freshness_status` =
-- 'a_jour' reflète cet état de l'index tel que vérifié, mais la currence
-- clinique réelle reste à reconfirmer par une relecture humaine avant toute
-- publication (statut `draft` sur toutes les lignes ci-dessous, conforme au
-- principe non négociable de relecture humaine du schéma cible).
--
-- ⚠️ A VERIFIER (R34) : "un intervalle de changement de ligne plus long (4
-- à 7 jours)" est présenté par la source elle-même comme une piste "à
-- confirmer en réanimation", pas comme une recommandation ferme au même
-- titre que R33 (2-3 jours) — le grade [2-b] est reproduit tel quel, mais
-- le statut de "R34" est d'ordre différent de R33 ; formulation de
-- `statement` conservée volontairement prudente/hypothétique pour ne pas
-- masquer cette nuance.

insert into public.documents (title, doc_type, original_language, publication_date, doi, source_url, pdf_url, grading_system, freshness_status)
values (
  'Infections liées aux cathéters veineux centraux en réanimation',
  'Autre', 'fr', '2002-12-11',
  '10.1016/S1624-0693(03)00051-3',
  'https://sfar.org/infections-liees-aux-catheters-veineux-centraux-en-reanimation-3/',
  'https://sfar.org/wp-content/uploads/2015/10/1-s2.0-S1624069303000513-main.pdf',
  'Grille "Niveau (1-3) - Score (a-d)" propre à la conférence de consensus SRLF : Niveau 1/2/3 = force de la recommandation (preuves indiscutables / preuves + consensus d''experts / opinion d''experts sur données insuffisantes), Score a/b/c/d = type d''étude (essai randomisé / cohorte non randomisée / revue-avis d''experts / opinion non revue). Chaque clause gradée individuellement (ex. "1-b", "2-c") ; certains points explicitement non tranchés par la source sont tagués "point non résolu" et n''ont jamais été convertis en recommandation. Réactualisation 2002/2003 (reçu et accepté le 11 décembre 2002 ; publié Réanimation 12 (2003) 258-265) de la 12e conférence de consensus SRLF de 1994.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/infections-liees-aux-catheters-veineux-centraux-en-reanimation-3/'
  and (s.acronym, s.country_or_region) in (('SRLF', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/infections-liees-aux-catheters-veineux-centraux-en-reanimation-3/'
  and s.slug in ('medecine_intensive_reanimation', 'infectiologie_maladies_infectieuses_et_tropicales', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.population, v.source_section,
  'https://sfar.org/infections-liees-aux-catheters-veineux-centraux-en-reanimation-3/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000091-R01', 'Ne pas affirmer un diagnostic d''infection liée au cathéter (ILC) sur la seule base d''un signe clinique isolé, à l''exclusion du pus au point de ponction : une confirmation microbiologique est nécessaire.', '2-b', 'Diagnostic — limite des signes cliniques isolés', null, 'Question 1 — Définition et diagnostic'),
  ('MG-ANES-000091-R02', 'Abandonner la culture qualitative en milieu liquide du cathéter comme technique diagnostique (ne distingue pas contamination, colonisation et infection).', '1-b', 'Techniques de culture du cathéter', null, 'Question 1 — Techniques de culture du cathéter'),
  ('MG-ANES-000091-R03', 'Préférer la technique de culture quantitative en milieu liquide après « vortexage » (seuil > 10³ ufc/ml) à la méthode semi-quantitative de Maki pour la culture du cathéter.', '2-b', 'Techniques de culture du cathéter', null, 'Question 1 — Techniques de culture du cathéter'),
  ('MG-ANES-000091-R04', 'Réserver les techniques diagnostiques « cathéter en place » (sans ablation) aux situations sans état de choc, tunnelite, thrombophlébite ni endocardite.', '2-c', 'Techniques « cathéter en place »', null, 'Question 1 — Techniques « cathéter en place »'),
  ('MG-ANES-000091-R05', 'Ne pas réaliser de surveillance microbiologique systématique du point d''insertion du cathéter en l''absence de point d''appel infectieux (aucune indication en routine).', '1-b', 'Techniques « cathéter en place »', null, 'Question 1 — Techniques « cathéter en place »'),
  ('MG-ANES-000091-R06', 'Ne pas se fier aux seules hémocultures prélevées par le cathéter pour diagnostiquer une ILC non bactériémique (nécessite une confrontation avec l''hémoculture périphérique).', '2-c', 'Techniques « cathéter en place »', null, 'Question 1 — Techniques « cathéter en place »'),
  ('MG-ANES-000091-R07', 'Utiliser des matériaux moins thrombogènes (polyuréthane, élastomère de silicone) pour la fabrication des cathéters veineux centraux.', '1-b', 'Choix du matériel', null, 'Champ 4 — Prévention, §5.1'),
  ('MG-ANES-000091-R08', 'Ne pas utiliser en première intention des cathéters imprégnés d''agents anti-infectieux (antiseptiques ou antibiotiques).', '2-c', 'Cathéters imprégnés d''antibiotiques/antiseptiques', null, 'Champ 4 — Prévention, §5.2'),
  ('MG-ANES-000091-R09', 'Réserver les cathéters imprégnés de chlorhexidine-sulfadiazine argent aux unités où l''incidence des ILC reste élevée malgré le renforcement des mesures préventives non anti-infectieuses.', '2-c', 'Cathéters imprégnés d''antibiotiques/antiseptiques', null, 'Champ 4 — Prévention, §5.2'),
  ('MG-ANES-000091-R10', 'Réaliser la pose du cathéter, y compris les échanges sur guide, selon les règles d''asepsie chirurgicale.', '1-a', 'Technique de pose — asepsie', null, 'Champ 4 — Prévention, §5.3'),
  ('MG-ANES-000091-R11', 'Déterger la peau au savon antiseptique puis la badigeonner d''un antiseptique (povidone iodée, chlorhexidine ou alcool) avant la pose du cathéter.', '1-a', 'Technique de pose — antisepsie cutanée', null, 'Champ 4 — Prévention, §5.3'),
  ('MG-ANES-000091-R12', 'Respecter un temps de contact de l''antiseptique jusqu''à peau sèche, au moins 2 minutes pour la polyvidone iodée.', '1-b', 'Technique de pose — antisepsie cutanée', null, 'Champ 4 — Prévention, §5.3'),
  ('MG-ANES-000091-R13', 'Ne pas utiliser de solvants (type acétone) avant l''insertion du cathéter ou la réfection des pansements.', '1-a', 'Technique de pose — antisepsie cutanée', null, 'Champ 4 — Prévention, §5.3'),
  ('MG-ANES-000091-R14', 'Utiliser des champs stériles larges lors de la pose du cathéter.', '1-a', 'Technique de pose — champ stérile', null, 'Champ 4 — Prévention, §5.3'),
  ('MG-ANES-000091-R15', 'Tunnéliser les cathéters posés par voie jugulaire interne ou fémorale (diminue le risque d''ILC).', '1-a', 'Technique de pose — tunnelisation', null, 'Champ 4 — Prévention, §5.3'),
  ('MG-ANES-000091-R16', 'La tunnelisation n''a pas d''intérêt démontré pour les cathéters posés par voie sous-clavière.', '2-a', 'Technique de pose — tunnelisation', null, 'Champ 4 — Prévention, §5.3'),
  ('MG-ANES-000091-R17', 'Respecter, lors d''un changement de cathéter sur guide, les mêmes conditions d''asepsie que pour la pose initiale.', '2-c', 'Technique de pose — changement sur guide', null, 'Champ 4 — Prévention, §5.3'),
  ('MG-ANES-000091-R18', 'Changer les gants stériles au moment de la mise en place du nouveau cathéter lors d''un changement sur guide.', '2-c', 'Technique de pose — changement sur guide', null, 'Champ 4 — Prévention, §5.3'),
  ('MG-ANES-000091-R19', 'Ne pas changer systématiquement le cathéter à intervalle régulier, que ce soit sur guide ou sur un nouveau site.', '1-a', 'Technique de pose — changement systématique', null, 'Champ 4 — Prévention, §5.3'),
  ('MG-ANES-000091-R20', 'Préférer la voie sous-clavière lorsque la durée prévue de cathétérisme dépasse 5 à 7 jours, si le risque de barotraumatisme/ponction artérielle non compressible n''est pas trop important.', '1-a', 'Site d''accès vasculaire', null, 'Champ 4 — Prévention, §5.4'),
  ('MG-ANES-000091-R21', 'Envisager la voie jugulaire interne si le risque mécanique de la voie sous-clavière est élevé.', '2-b', 'Site d''accès vasculaire', null, 'Champ 4 — Prévention, §5.4'),
  ('MG-ANES-000091-R22', 'Tunnéliser le cathéter en cas de pose par voie jugulaire interne du fait d''un risque mécanique élevé de la voie sous-clavière.', '1-a', 'Site d''accès vasculaire', null, 'Champ 4 — Prévention, §5.4'),
  ('MG-ANES-000091-R23', 'Discuter la voie fémorale comme abord vasculaire si le risque cave supérieur (jugulaire/sous-clavier) est élevé.', '2-a', 'Site d''accès vasculaire', null, 'Champ 4 — Prévention, §5.4'),
  ('MG-ANES-000091-R24', 'Tunnéliser le cathéter en cas de pose par voie fémorale du fait d''un risque cave supérieur élevé.', '2-a', 'Site d''accès vasculaire', null, 'Champ 4 — Prévention, §5.4'),
  ('MG-ANES-000091-R25', 'Occlure le site d''insertion du cathéter par un pansement (efficacité de l''occlusion démontrée).', '1-a', 'Pansement du site d''insertion', null, 'Champ 4 — Prévention, §5.5'),
  ('MG-ANES-000091-R26', 'Changer le pansement du site d''insertion à un intervalle optimal d''au moins 72 heures.', null, 'Pansement du site d''insertion', null, 'Champ 4 — Prévention, §5.5'),
  ('MG-ANES-000091-R27', 'Noter les dates de pose et de réfection du pansement du site d''insertion.', null, 'Pansement du site d''insertion', null, 'Champ 4 — Prévention, §5.5'),
  ('MG-ANES-000091-R28', 'Surveiller quotidiennement le site d''insertion du cathéter.', '2-c', 'Pansement du site d''insertion', null, 'Champ 4 — Prévention, §5.5'),
  ('MG-ANES-000091-R29', 'Privilégier la chlorhexidine à la povidone iodée comme antiseptique cutané pour la pose/l''entretien du cathéter (supériorité suggérée par méta-analyse).', '1-a', 'Choix de l''antiseptique', null, 'Champ 4 — Prévention, §5.6'),
  ('MG-ANES-000091-R30', 'Préférer la povidone iodée-alcool à la povidone iodée seule comme antiseptique cutané.', '2-a', 'Choix de l''antiseptique', null, 'Champ 4 — Prévention, §5.6'),
  ('MG-ANES-000091-R31', 'Limiter les manipulations de la ligne veineuse centrale.', '2-b', 'Entretien de la ligne veineuse', null, 'Champ 4 — Prévention, §5.7'),
  ('MG-ANES-000091-R32', 'Éloigner les sites d''injection du cathéter (via un prolongateur non changé) pour réduire la contamination.', '2-b', 'Entretien de la ligne veineuse', null, 'Champ 4 — Prévention, §5.7'),
  ('MG-ANES-000091-R33', 'Changer la ligne veineuse (tubulures) à un intervalle optimal de 2 à 3 jours.', '1-b', 'Entretien de la ligne veineuse', null, 'Champ 4 — Prévention, §5.7'),
  ('MG-ANES-000091-R34', 'Un intervalle de changement de ligne veineuse plus long (4 à 7 jours) est suggéré par certaines études mais reste, selon la source elle-même, à confirmer en réanimation (n''est pas présenté comme une recommandation ferme au même titre que l''intervalle de 2-3 jours).', '2-b', 'Entretien de la ligne veineuse', null, 'Champ 4 — Prévention, §5.7'),
  ('MG-ANES-000091-R35', 'Remplacer dans les 24 heures les tubulures ayant servi à l''administration de dérivés sanguins ou de lipides.', '2-c', 'Entretien de la ligne veineuse', null, 'Champ 4 — Prévention, §5.7'),
  ('MG-ANES-000091-R36', 'Appliquer les mêmes précautions de remplacement de tubulure sous 24h au propofol, assimilé à un lipide pour ce risque.', '2-b', 'Entretien de la ligne veineuse', null, 'Champ 4 — Prévention, §5.7'),
  ('MG-ANES-000091-R37', 'L''efficacité des filtres antimicrobiens en ligne dans la prévention de l''ILC n''est pas démontrée.', '1-a', 'Entretien de la ligne veineuse', null, 'Champ 4 — Prévention, §5.7'),
  ('MG-ANES-000091-R38', 'L''héparinisation générale diminue le risque de thrombose sur cathéter veineux central.', '1-a', 'Entretien de la ligne veineuse', null, 'Champ 4 — Prévention, §5.7'),
  ('MG-ANES-000091-R39', 'Limiter les indications de pose des cathéters veineux centraux et des cathéters de Swan-Ganz, et les retirer le plus précocement possible.', '1-b', 'Politique générale de prévention', null, 'Champ 4 — Prévention, §5.8'),
  ('MG-ANES-000091-R40', 'Élaborer en équipe et faire respecter par tous des protocoles écrits pour la pose, l''entretien et l''utilisation des cathéters veineux centraux.', '1-b', 'Politique générale de prévention', null, 'Champ 4 — Prévention, §5.8'),
  ('MG-ANES-000091-R41', 'Former des équipes dédiées à la prise en charge des cathéters (impact démontré sur la réduction des ILC).', '1-a', 'Politique générale de prévention', null, 'Champ 4 — Prévention, §5.8'),
  ('MG-ANES-000091-R42', 'Mettre en place des programmes d''éducation associant formation aux bonnes pratiques d''hygiène et directives précises sur la pose, l''utilisation et les soins des différents accès vasculaires.', '1-b', 'Politique générale de prévention', null, 'Champ 4 — Prévention, §5.8'),
  ('MG-ANES-000091-R43', 'Préférer le site jugulaire au site sous-clavier pour la surveillance hémodynamique péri-opératoire par cathéter de Swan-Ganz (balance risque infectieux/complications mécaniques).', null, 'Cathéter de Swan-Ganz et cathéter artériel', null, 'Champ 4 — Prévention, §5.9'),
  ('MG-ANES-000091-R44', 'Utiliser des manchons plastifiés protecteurs pour les cathéters de Swan-Ganz.', '2-a', 'Cathéter de Swan-Ganz et cathéter artériel', null, 'Champ 4 — Prévention, §5.9'),
  ('MG-ANES-000091-R45', 'Ne pas changer systématiquement le cathéter de Swan-Ganz ou les cathéters artériels.', '2-c', 'Cathéter de Swan-Ganz et cathéter artériel', null, 'Champ 4 — Prévention, §5.9'),
  ('MG-ANES-000091-R46', 'Préférer des sets de pression à usage unique.', '2-b', 'Cathéter de Swan-Ganz et cathéter artériel', null, 'Champ 4 — Prévention, §5.9'),
  ('MG-ANES-000091-R47', 'Utiliser des systèmes d''injection clos pour les bolus (Swan-Ganz et système Picco®).', '2-c', 'Cathéter de Swan-Ganz et cathéter artériel', null, 'Champ 4 — Prévention, §5.9'),
  ('MG-ANES-000091-R48', 'Ne pas utiliser de soluté glucosé pour la purge des sets de pression.', '1-b', 'Cathéter de Swan-Ganz et cathéter artériel', null, 'Champ 4 — Prévention, §5.9'),
  ('MG-ANES-000091-R49', 'Changer l''ensemble tubulures/set de pression/robinet tous les 4 jours.', '2-b', 'Cathéter de Swan-Ganz et cathéter artériel', null, 'Champ 4 — Prévention, §5.9'),
  ('MG-ANES-000091-R50', 'Ne pas utiliser le cathéter de dialyse pour la perfusion ou le prélèvement sanguin en dehors des séances de dialyse.', '2-c', 'Cathéters de dialyse', null, 'Champ 4 — Prévention, §5.10'),
  ('MG-ANES-000091-R51', 'Ne pas changer systématiquement le cathéter de dialyse.', '2-b', 'Cathéters de dialyse', null, 'Champ 4 — Prévention, §5.10'),
  ('MG-ANES-000091-R52', 'Retirer immédiatement un cathéter présumé infecté en présence de signes locaux francs (cellulite, tunnelite, collection purulente).', '1-b', 'Ablation immédiate du cathéter', null, 'Champ 5 — Stratégie diagnostique/thérapeutique, §6.1.1'),
  ('MG-ANES-000091-R53', 'Retirer immédiatement un cathéter présumé infecté en cas d''infection compliquée d''emblée (thrombophlébite ou endocardite).', '1-b', 'Ablation immédiate du cathéter', null, 'Champ 5 — Stratégie diagnostique/thérapeutique, §6.1.1'),
  ('MG-ANES-000091-R54', 'Retirer immédiatement un cathéter présumé infecté en cas de bactériémie à germe à haut risque (S. aureus, Pseudomonas ou Candida).', '1-b', 'Ablation immédiate du cathéter', null, 'Champ 5 — Stratégie diagnostique/thérapeutique, §6.1.1'),
  ('MG-ANES-000091-R55', 'Retirer immédiatement un cathéter présumé infecté devant des signes de gravité (choc septique) sans autre cause apparente.', '1-b', 'Ablation immédiate du cathéter', null, 'Champ 5 — Stratégie diagnostique/thérapeutique, §6.1.1'),
  ('MG-ANES-000091-R56', 'Retirer immédiatement un cathéter présumé infecté en cas de bactériémie chez un porteur de prothèse endovasculaire ou de valve cardiaque.', '1-c', 'Ablation immédiate du cathéter', null, 'Champ 5 — Stratégie diagnostique/thérapeutique, §6.1.1'),
  ('MG-ANES-000091-R57', 'Débuter immédiatement une antibiothérapie probabiliste en présence de signes de gravité (sepsis sévère, choc), de complications (tunnelite, thrombophlébite, endocardite) ou de signes locaux patents (suppuration).', '1-b', 'Antibiothérapie probabiliste', null, 'Champ 5 — Stratégie diagnostique/thérapeutique, §6.2'),
  ('MG-ANES-000091-R58', 'Diriger l''antibiothérapie probabiliste notamment contre les cocci à Gram positif, la guider par l''examen direct et l''écologie locale, et la réévaluer à réception des résultats microbiologiques définitifs.', '1-b', 'Antibiothérapie probabiliste', null, 'Champ 5 — Stratégie diagnostique/thérapeutique, §6.2'),
  ('MG-ANES-000091-R59', 'Réaliser une échocardiographie transœsophagienne (transthoracique chez le jeune enfant) avec Doppler veineux pour vérifier l''état valvulaire en cas de septicémie à S. aureus.', '1-b', 'Bactériémie à S. aureus', null, 'Champ 5 — Stratégie diagnostique/thérapeutique, §6.2'),
  ('MG-ANES-000091-R60', 'Traiter par une antibiothérapie courte (10 à 14 jours) une bactériémie à S. aureus sans lésion valvulaire ni thrombophlébite, si le contrôle de l''infection est rapide (hémocultures négativées et régression clinique en 48-72h).', '1-b', 'Bactériémie à S. aureus', null, 'Champ 5 — Stratégie diagnostique/thérapeutique, §6.2'),
  ('MG-ANES-000091-R61', 'Envisager un traitement antibiotique en cas d''infection à Acinetobacter baumannii ou à entérobactérie du groupe III (données insuffisantes mais orientant vers un traitement).', '3-c', 'Antibiothérapie — germes spécifiques', null, 'Champ 5 — Stratégie diagnostique/thérapeutique, §6.2'),
  ('MG-ANES-000091-R62', 'Considérer l''ablation du cathéter comme l''attitude la plus sûre en cas de bactériémie à staphylocoque à coagulase négative probablement liée au cathéter.', '2-c', 'Bactériémie à staphylocoque à coagulase négative', null, 'Champ 5 — Stratégie diagnostique/thérapeutique, §6.2.3'),
  ('MG-ANES-000091-R63', 'Ne pas traiter nécessairement par antibiothérapie une bactériémie isolée à staphylocoque à coagulase négative avec régression rapide après ablation du cathéter, en l''absence de facteurs de risque associés.', '2-c', 'Bactériémie à staphylocoque à coagulase négative', null, 'Champ 5 — Stratégie diagnostique/thérapeutique, §6.2.3'),
  ('MG-ANES-000091-R64', 'Ne pas utiliser la méthode du « verrou antibiotique » en réanimation pour le traitement d''un cathéter colonisé/infecté (non évaluée en réanimation, pas d''indication reconnue dans ce contexte).', '2-c', 'Bactériémie à staphylocoque à coagulase négative', null, 'Champ 5 — Stratégie diagnostique/thérapeutique, §6.2.3'),
  ('MG-ANES-000091-R65', 'Appliquer probablement le même raisonnement (verrou antibiotique non recommandé en réanimation) aux infections à entérobactéries du groupe I/II et aux entérocoques.', '3-c', 'Bactériémie à staphylocoque à coagulase négative', null, 'Champ 5 — Stratégie diagnostique/thérapeutique, §6.2.3'),
  ('MG-ANES-000091-R66', 'Traiter une infection locale non compliquée du site d''insertion par des soins locaux désinfectants et une surveillance après retrait du cathéter ; la régression rapide (48h) sous surveillance attentive peut constituer le seul traitement, en l''absence d''immunodépression.', '2-c', 'Infection locale non compliquée, sans germe à haut risque', null, 'Champ 5 — Stratégie diagnostique/thérapeutique, §6.2.4'),
  ('MG-ANES-000091-R67', 'Ne pas prescrire d''antibiothérapie systématique pour une infection locale non compliquée du site d''insertion, sauf signes généraux francs d''emblée ou aggravation/réapparition des signes dans les 48h (durée de traitement alors non déterminée par la source dans ce cas).', null, 'Infection locale non compliquée, sans germe à haut risque', null, 'Champ 5 — Stratégie diagnostique/thérapeutique, §6.2.4'),
  ('MG-ANES-000091-R68', 'Remplacer le cathéter sur un nouveau site en cas de colonisation significative du premier cathéter après un changement sur guide (antibiothérapie généralement non nécessaire en l''absence de bactériémie).', '2-c', 'Infection locale non compliquée, sans germe à haut risque', null, 'Champ 5 — Stratégie diagnostique/thérapeutique, §6.2.4'),
  ('MG-ANES-000091-R69', 'Laisser en place le second cathéter sous antibiothérapie et surveillance renforcée si un staphylocoque à coagulase négative est isolé sur le premier cathéter après changement sur guide, avec retrait imposé en cas de persistance des signes généraux.', '2-c', 'Infection locale non compliquée, sans germe à haut risque', null, 'Champ 5 — Stratégie diagnostique/thérapeutique, §6.2.4'),
  ('MG-ANES-000091-R70', 'Pour un cathéter laissé en place en cas de présomption faible/modérée d''ILC (sans suppuration, bactériémie ni signe de gravité) : assurer une simple surveillance sans antibiothérapie, avec prélèvements renouvelés au moindre doute.', null, 'Infection locale non compliquée, sans germe à haut risque', null, 'Champ 5 — Stratégie diagnostique/thérapeutique, §6.2.4'),
  ('MG-ANES-000091-R71', 'Rechercher systématiquement un autre foyer infectieux dans toute situation de présomption d''infection liée au cathéter.', null, 'Stratégie diagnostique et thérapeutique — principe général', null, 'Champ 5 — Stratégie diagnostique/thérapeutique, §6.2.4')
) as v(code, statement, grade, condition_topic, population, source_section)
where d.source_url = 'https://sfar.org/infections-liees-aux-catheters-veineux-centraux-en-reanimation-3/'
on conflict (recommendation_code) do nothing;
