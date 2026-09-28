-- Migration : Réactualisation de la recommandation sur la douleur
-- postopératoire (SFAR/ANREA, Recommandations formalisées d'experts, 2016,
-- Anesth Reanim. 2016;2:421-430, doi 10.1016/j.anrea.2016.09.006)
-- Source : rfe-sfar-website/build/content_douleur_reactualisation_2016.json
-- (729 lignes, lu intégralement). 17 recommandations formalisées identifiées
-- à la lecture, sur les 3 grands champs traités par le texte : évaluation de
-- la DPO chez l'adulte et l'enfant (incl. monitorage de l'analgésie),
-- thérapeutiques médicamenteuses par voies systémique et orale, anesthésie
-- locale et locorégionale postopératoire.
--
-- MÉTHODOLOGIE — GRADE®. Qualité des preuves en 4 catégories (haute,
-- modérée, basse, très basse) ; formulation finale toujours binaire : force
-- FORTE = GRADE 1+ ("il faut faire") / 1- ("il ne faut pas faire") ; force
-- FAIBLE = GRADE 2+ ("il faut probablement faire") / 2- ("il ne faut
-- probablement pas faire"). Quand aucune méta-analyse ne permettait
-- d'appliquer GRADE en totalité, un avis d'experts (AE) était proposé, validé
-- si >= 70 % d'accord (vote Delphi/GRADE Grid). `grade` reproduit EXACTEMENT
-- le tag imprimé par la source pour chacune des 17 recommandations
-- individuelles ('1+', '1-', '2+', '2-' ou 'AE') — jamais deviné ni
-- réassigné. `evidence_level` laissé NULL (la source ne détaille pas le
-- niveau de preuve GRADE par recommandation individuelle, seulement de façon
-- narrative dans l'argumentaire).
--
-- ⚠️ NUMÉROTATION SOURCE — PAS DE R2.x, DISCLOSURE EXPLICITE DE LA SOURCE
-- ELLE-MÊME (pas un oubli de cette migration) : les 17 recommandations
-- portent la numérotation propre à la source R1.1-R1.5, puis R3.1-R3.9, puis
-- R4.1-R4.3 — la numérotation saute directement de R1.5 à R3.1. La question
-- 2 (« quelles méthodes permettent de monitorer l'analgésie au bloc
-- opératoire et en postopératoire immédiat ? » — pupillométrie, index de
-- nociception ANI, surgical pleth index SPI) a explicitement abouti à une
-- « Absence de recommandation formalisée » imprimée telle quelle par la
-- source (aucune preuve que ce monitorage réduise la douleur ou la
-- consommation d'antalgiques postopératoires), donc AUCUN R2.x n'existe.
-- Reproduit ici tel quel : aucun R2.x n'est inventé, le trou de numérotation
-- n'est pas silencieusement renuméroté. Le numéro source propre de chaque
-- recommandation (R1.1..R4.3) est conservé dans `source_section` ; le
-- `recommendation_code` en base suit néanmoins le format plat standard de ce
-- corpus MG-ANES-000074-R01..R17 en ordre de lecture de la source.
--
-- ⚠️ DIVERGENCE SOURCE-INTERNE DISCLOSÉE (non résolue silencieusement,
-- reproduite mot pour mot dans le texte de disclosure ci-dessous) :
-- l'introduction de la source annonce elle-même « 11 [recommandations]
-- fortes, 3 [...] faibles et, pour 3 recommandations, [...] un avis
-- d'experts » (11+3+3 = 17). Le recompte exhaustif, tag par tag, des 17
-- recommandations imprimées individuellement (R1.1-R1.5, R3.1-R3.9,
-- R4.1-R4.3) donne 10x GRADE 1+/1- (fortes), 4x GRADE 2+/2- (faibles) et 3x
-- avis d'experts (10+4+3 = 17 également, mais 10 fortes et non 11). Aucun
-- grade individuel n'a été deviné ou réassigné pour faire correspondre les
-- deux comptages ; les 17 tags imprimés individuellement (reproduits
-- ci-dessous dans `grade`) font foi dans cette migration, exactement comme
-- dans la fiche construite dont ce contenu est issu.
--
-- ⚠️ DIVERGENCE SOURCE-INTERNE SUPPLÉMENTAIRE, PROPRE À R1.5 (disclosée par
-- la fiche construite, reproduite ici, non corrigée) : le texte de R1.5
-- emploie la formulation « il est probablement recommandé » (qui, selon la
-- légende GRADE de la source elle-même, correspond à une force FAIBLE,
-- 2+/2-), mais le chip imprimé par la source à côté de cette recommandation
-- est « 1+ » (force FORTE). `grade` = '1+' ci-dessous reproduit fidèlement
-- le tag imprimé par la source (pas le texte), conformément au principe
-- "jamais deviné ni réassigné" — non corrigé en '2+'.
--
-- ⚠️ RELATION AVEC LA RFE 2008 (0071) — NE PAS FUSIONNER, NE PAS SUPERSÉDER
-- (disclosure, pas une inférence) : ce document 2016 déclare explicitement
-- ne PAS remplacer la RFE 2008 « Prise en charge de la douleur
-- postopératoire chez l'adulte et l'enfant » (SFAR, déjà migrée dans ce
-- corpus : voir 0071_migrate_douleur_postoperatoire.sql, source_url
-- 'https://sfar.org/prise-en-charge-de-la-douleur-postoperatoire-chez-ladulte-et-lenfant-2/').
-- La source dit qu'elle COMPLÈTE cette RFE 2008 sur des questions non
-- traitées en 2008 (ex. échelle APAIS, DN4, lidocaïne IV continue,
-- dexaméthasone, doses maximales d'AL pour l'infiltration) et qu'elle en
-- MODIFIE certaines recommandations à la lumière de nouvelles données (ex.
-- gabapentinoïdes : R3.9 ici contredit l'usage plus favorable qu'en 2008).
-- Le schéma n'a pas de champ pour « amende des lignes précises d'un autre
-- document » — aucun champ n'est donc détourné pour le modéliser. En
-- conséquence : `freshness_status` = 'a_jour' (valeur par défaut) sur CE
-- document, et AUCUNE modification n'est faite sur le document 2008 (0071) —
-- ni `superseded_by_document_id`, ni changement de son `freshness_status`
-- (qui reste 'revision_detectee', déjà positionné ainsi par 0071 pour
-- d'autres raisons). Les deux fiches restent des documents indépendants,
-- complémentaires, à lire ensemble.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. ANREA (Association nationale de la recherche en anesthésie-réanimation
--    et médecine péri-opératoire), société co-publicatrice de ce document
--    aux côtés de la SFAR, ne figure PAS dans le seed Annexe B de
--    `public.societies`. Seule la SFAR (présente dans le seed) est liée en
--    `document_societies` ci-dessous ; ANREA n'est donc pas représentée en
--    base (même limitation que le GEHT pour 0072_migrate_tih_2002.sql).
-- 2. `publication_date` : trois dates distinctes apparaissent selon la
--    source consultée — `build/library_final.json` indexe cet item avec
--    `exact_date: "2016-09-01"` (date de synthèse de l'indexeur, précision
--    mensuelle apparente) ; le texte source lui-même déclare « Texte validé
--    par le conseil d'administration de la Sfar le 17/06/2016, disponible
--    sur Internet le 31 octobre 2016 ». `publication_date` retient ici
--    2016-10-31 (date de mise à disposition/« publication » au sens propre,
--    la plus proche sémantiquement du champ), sans effacer les deux autres
--    dates qui restent disponibles dans ce commentaire — aucune n'a été
--    choisie comme "la bonne" au prix de faire disparaître les autres.
-- 3. `population` : R1.4 est explicitement dédiée à l'enfant de moins de 7
--    ans ('Pédiatrie'). R1.5 couvre à la fois l'enfant (FLACC
--    modifiée-handicap) ET le sujet âgé/« vieillard » (ALGOPLUS) dans la
--    même recommandation — comme pour R84/R89 de 0071, aucune population
--    unique n'est assignable sans en écarter une : `population` laissé NULL
--    pour R1.5. NULL ailleurs (R3.x/R4.x s'appliquent à l'adulte en
--    général, sans restriction de population énoncée par la source pour ces
--    recommandations précises).
--
-- PÉRIMÈTRE — volontairement pas migré en recommandation distincte
-- (disclosure explicite de la source elle-même, reproduite ici, pas un
-- oubli) : la question du monitorage de l'analgésie (pupillométrie, ANI,
-- SPI) et les rappels méthodologiques sur le cathétérisme périnerveux/
-- péridural/paravertébral et sur la surveillance des patients sous opioïdes
-- en structure de soins conventionnels ont chacun explicitement abouti à
-- une « Absence de recommandation formalisée » imprimée telle quelle par la
-- source — aucune ligne `recommendations` n'est créée pour ces points
-- (l'absence elle-même est déjà disclosée ci-dessus et dans le panneau
-- méthodologique de la fiche construite ; en créer une ligne "recommandation"
-- pour une absence de recommandation serait fabriquer un contenu que la
-- source n'affirme pas). Le tableau des doses maximales d'anesthésiques
-- locaux (lidocaïne adrénalinée 7 mg/kg, mépivacaïne 5 mg/kg,
-- lévobupivacaïne 3 mg/kg, ropivacaïne 3 mg/kg) est un tableau de référence
-- contextuel directement lié à R4.1 ci-dessous plutôt qu'une recommandation
-- séparée numérotée par la source ; ses valeurs sont reproduites dans le
-- `statement` de R4.1 pour ne pas perdre l'information chiffrée.
--
-- SAFETY NET : `grep -n '"[12][+-]/[12][+-]'` sur ce fichier ne doit
-- retourner aucune correspondance (aucun chip composite fusionné) — vérifié
-- avant commit ; chaque ligne ci-dessous porte un unique tag GRADE/AE.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Réactualisation de la recommandation sur la douleur postopératoire',
  'RFE', 'fr', '2016-10-31',
  'https://sfar.org/reactualisation-de-la-recommandation-sur-la-douleur-postoperatoire/',
  'https://sfar.org/wp-content/uploads/2016/09/RFE-ANREA-Reactualisation-de-la-recommandation-sur-la-douleur-postoperatoire.pdf',
  'GRADE® — formulation binaire forte (1+/1-, "il faut"/"il ne faut pas faire") ou faible (2+/2-, "il faut probablement"/"il ne faut probablement pas faire") ; avis d''experts (AE) quand aucune méta-analyse ne permettait d''appliquer GRADE en totalité, validé si >= 70% d''accord. 17 recommandations formalisées (R1.1-R1.5, R3.1-R3.9, R4.1-R4.3 ; pas de R2.x, la question du monitorage de l''analgésie n''ayant abouti à aucune recommandation formalisée — disclosure de la source elle-même). Divergence source-interne disclosée sur le décompte agrégé : l''introduction annonce "11 fortes, 3 faibles, 3 avis d''experts" (11+3+3=17) mais le recompte tag par tag des 17 recommandations donne 10 fortes (1+/1-), 4 faibles (2+/2-) et 3 avis d''experts (10+4+3=17) — non résolu, les 17 tags individuels font foi. Complète (n''abroge pas) la RFE SFAR 2008 sur le même sujet, déjà migrée séparément (voir 0071).',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/reactualisation-de-la-recommandation-sur-la-douleur-postoperatoire/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/reactualisation-de-la-recommandation-sur-la-douleur-postoperatoire/'
  and s.slug in ('anesthesie_reanimation', 'medecine_de_la_douleur_algologie', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.condition_topic, v.source_section,
  'https://sfar.org/reactualisation-de-la-recommandation-sur-la-douleur-postoperatoire/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000074-R01', 'En période préopératoire, il est recommandé d''identifier les patients les plus vulnérables à la douleur (à risque de développer une douleur postopératoire sévère et/ou une douleur chronique post-chirurgicale, DCPC), en recherchant la présence d''une douleur préopératoire y compris en dehors du site opératoire, la consommation d''opiacés au long cours, des facteurs chirurgicaux et psychiques tels que l''anxiété ou la dépression. Avis d''experts, accord fort.', 'AE', null, 'Identification des patients vulnérables à la douleur', '1 — Évaluation de la douleur en périopératoire — R1.1'),
  ('MG-ANES-000074-R02', 'Il est probablement recommandé d''utiliser l''échelle Amsterdam Preoperative Anxiety and Information Scale (APAIS) pour rechercher une anxiété et/ou un besoin d''information en période préopératoire. Avis d''experts, accord fort.', 'AE', null, 'Dépistage de l''anxiété préopératoire (échelle APAIS)', '1 — Évaluation de la douleur en périopératoire — R1.2'),
  ('MG-ANES-000074-R03', 'Il est recommandé d''identifier les facteurs de risques postopératoires de chronicisation de la DPO en recherchant une intensité élevée de la DPO à l''aide d''une échelle numérique (EN), une prolongation inhabituelle de la DPO, une douleur neuropathique précoce (échelle DN4), des signes d''anxiété et/ou de dépression. Avis d''experts, accord fort.', 'AE', null, 'Facteurs de risque postopératoires de chronicisation de la DPO', '1 — Évaluation de la douleur en périopératoire — R1.3'),
  ('MG-ANES-000074-R04', 'Il est recommandé d''utiliser une échelle d''autoévaluation à partir de l''âge de 5 ans (échelle des visages). À défaut, il est recommandé d''utiliser l''échelle FLACC pour l''hétéroévaluation de la douleur postopératoire chez l''enfant de moins de 7 ans. Accord fort.', '1+', 'Pédiatrie', 'Échelles de douleur chez l''enfant de moins de 7 ans', '1 — Évaluation de la douleur en périopératoire — R1.4'),
  ('MG-ANES-000074-R05', 'Chez le patient non communiquant, il est probablement recommandé d''utiliser une échelle d''hétéroévaluation FLACC modifiée-handicap chez l''enfant et ALGOPLUS chez le vieillard. Divergence source-interne disclosée (non corrigée) : le tag imprimé par la source est "1+" (force forte) alors que la formulation textuelle ("il est probablement recommandé") correspond, selon la légende GRADE de la source elle-même, à une force faible (2+) — reproduit tel quel, non réassigné en 2+.', '1+', null, 'Échelles chez le patient non communicant (enfant et sujet âgé)', '1 — Évaluation de la douleur en périopératoire — R1.5'),
  ('MG-ANES-000074-R06', 'Il est recommandé d''associer un AINS non sélectif (AINS-NS) ou un inhibiteur sélectif des cyclo-oxygénases de type 2 (ISCOX2) à la morphine en l''absence de contre-indication à l''usage de l''AINS. Accord fort.', '1+', null, 'AINS/ISCOX2 associés à la morphine', '2 — Thérapeutiques médicamenteuses systémique et orale — R3.1'),
  ('MG-ANES-000074-R07', 'Il n''est pas recommandé d''utiliser un inhibiteur des cyclo-oxygénases de type 2 (ISCOX2) chez les patients ayant des antécédents athéro-thrombotiques artériels (artériopathie oblitérante des membres inférieurs AOMI, AVC, infarctus du myocarde IDM). Accord fort.', '1-', null, 'ISCOX2 et antécédents athéro-thrombotiques artériels', '2 — Thérapeutiques médicamenteuses systémique et orale — R3.2'),
  ('MG-ANES-000074-R08', 'Les AINS non sélectifs (AINS-NS) ne sont probablement pas recommandés chez les patients ayant des antécédents athéro-thrombotiques artériels (AOMI, AVC, IDM) au-delà de 7 jours de traitement. Accord fort.', '2-', null, 'AINS-NS et antécédents athéro-thrombotiques artériels au-delà de 7 jours', '2 — Thérapeutiques médicamenteuses systémique et orale — R3.3'),
  ('MG-ANES-000074-R09', 'Il n''est pas recommandé d''associer des AINS non sélectifs (AINS-NS) à un traitement anticoagulant à dose curative. (accord faible)', '1-', null, 'AINS-NS et anticoagulation curative', '2 — Thérapeutiques médicamenteuses systémique et orale — R3.4'),
  ('MG-ANES-000074-R10', 'Il est recommandé de prescrire un opiacé fort (morphine ou oxycodone), préférentiellement par voie orale, en cas de douleurs postopératoires sévères ou insuffisamment calmées par les antalgiques des paliers inférieurs, et ceci quel que soit l''âge. Accord fort.', '1+', null, 'Opiacés forts (morphine, oxycodone) par voie orale', '2 — Thérapeutiques médicamenteuses systémique et orale — R3.5'),
  ('MG-ANES-000074-R11', 'Il est probablement recommandé d''administrer de la lidocaïne en intraveineux et en continu à la dose d''1 à 2 mg/kg en bolus intraveineux suivi de 1 à 2 mg/kg/h, chez les patients adultes opérés d''une chirurgie majeure (abdomino-pelvienne, rachidienne) et ne bénéficiant pas d''une analgésie périnerveuse ou péridurale concomitante, dans le but de diminuer la douleur postopératoire et d''améliorer la réhabilitation. Accord fort.', '2+', null, 'Lidocaïne intraveineuse continue', '2 — Thérapeutiques médicamenteuses systémique et orale — R3.6'),
  ('MG-ANES-000074-R12', 'Il est probablement recommandé d''administrer la dexaméthasone IV à la dose de 8 mg pour diminuer la douleur postopératoire. Accord fort.', '2+', null, 'Dexaméthasone IV', '2 — Thérapeutiques médicamenteuses systémique et orale — R3.7'),
  ('MG-ANES-000074-R13', 'En peropératoire, l''administration de faible dose de kétamine chez un patient sous anesthésie générale est recommandée dans les deux situations suivantes : (a) chirurgie à risque de douleur aiguë intense ou pourvoyeuse de DCPC ; (b) patients vulnérables à la douleur, en particulier sous opioïdes au long cours ou présentant une toxicomanie aux opiacés. Accord fort.', '1+', null, 'Kétamine à faible dose en peropératoire', '2 — Thérapeutiques médicamenteuses systémique et orale — R3.8'),
  ('MG-ANES-000074-R14', 'L''utilisation systématique des gabapentinoïdes en périopératoire n''est pas recommandée pour la prise en charge de la douleur postopératoire. (accord faible)', '1-', null, 'Gabapentinoïdes en périopératoire', '2 — Thérapeutiques médicamenteuses systémique et orale — R3.9'),
  ('MG-ANES-000074-R15', 'Il est recommandé de rester en deçà des doses maximales toxiques d''anesthésiques locaux, en particulier pour les infiltrations périprothétiques orthopédiques et lors d''association d''infiltrations cicatricielles et de cathéters périnerveux analgésiques. Doses maximales pour la première injection chez un adulte jeune ASA 1 : lidocaïne adrénalinée 7 mg/kg, mépivacaïne 5 mg/kg, lévobupivacaïne 3 mg/kg, ropivacaïne 3 mg/kg. Accord fort.', '1+', null, 'Doses maximales toxiques des anesthésiques locaux (infiltration)', '3 — Anesthésie locale et locorégionale postopératoire — R4.1'),
  ('MG-ANES-000074-R16', 'En cas de laparotomie (laparotomie, césarienne et lombotomie) et en l''absence d''analgésie périmédullaire, il est probablement recommandé de proposer la mise en place d''un cathéter cicatriciel pour infiltration continue. Accord fort.', '2+', null, 'Cathéter cicatriciel pour infiltration continue après laparotomie', '3 — Anesthésie locale et locorégionale postopératoire — R4.2'),
  ('MG-ANES-000074-R17', 'Il n''est pas recommandé de réaliser une infiltration analgésique au moyen d''un cathéter intra-articulaire en raison du risque toxique des anesthésiques locaux sur le cartilage (toxicité directe sur les chondrocytes). Accord fort.', '1-', null, 'Cathéter intra-articulaire (infiltration analgésique)', '3 — Anesthésie locale et locorégionale postopératoire — R4.3')
) as v(code, statement, grade, population, condition_topic, source_section)
where d.source_url = 'https://sfar.org/reactualisation-de-la-recommandation-sur-la-douleur-postoperatoire/'
on conflict (recommendation_code) do nothing;
