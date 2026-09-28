-- Migration : Nutrition artificielle en réanimation — Recommandations Formalisées d'Experts
-- communes SFAR-SRLF-SFNEP (Société francophone nutrition clinique et métabolique). 33
-- experts, 3 présidents, 3 pilotes. Source :
-- rfe-sfar-website/build/content_nutrition.json (10 champs, 70 recommandations migrées).
--
-- MÉTHODOLOGIE : méthode GRADE pour l'analyse de la littérature, mais chaque recommandation
-- (« Encadré ») porte dans le texte source un tag explicite UNIQUE « (Accord fort) » ou
-- « (Accord faible) » (force du consensus Delphi), reproduit ici littéralement comme `grade`
-- ('Fort'/'Faible'), cohérent avec la convention déjà utilisée dans ce corpus pour cette
-- cotation à un seul axe (ex. `eer`/0020, dont la source signale explicitement partager
-- cette particularité méthodologique avec ce document). Le niveau de force GRADE (1 = fort,
-- 2 = faible) n'est JAMAIS réimprimé à côté de chaque encadré individuel dans la source — il
-- se déduit seulement du verbe de l'énoncé lui-même (« il faut » = GRADE 1 ; « il faut
-- probablement » = GRADE 2), une INFÉRENCE de lecture et non une cotation imprimée : par
-- cohérence avec le principe de ne jamais faire apparaître comme "source-printed" une valeur
-- qui ne l'est pas (même logique que la disclosure du signe "+" pour
-- `lat_soins_critiques`/0031), cette inférence n'est PAS extraite dans un champ structuré
-- séparé — `evidence_level` laissé NULL, la nuance GRADE restant lisible directement dans le
-- texte verbatim de chaque `statement`.
--
-- COMPTAGE — DIVERGENCE DISCLOSÉE PAR LA SOURCE ELLE-MÊME, NON RÉSOLUE SILENCIEUSEMENT
-- (principe 1.5 du projet) : le résumé officiel de la source annonce « 69 recommandations »
-- issues des « six derniers champs » (4 à 10, jugés formellement cotés) — mais un inventaire
-- direct, item par item, dénombre 71 encadrés numérotés au total sur l'ENSEMBLE des 10
-- champs, y compris 4 encadrés des champs 1-3 (1.1, 2.1, 2.2, 3.1) que la méthodologie
-- décrit pourtant comme de simples « points forts » non formellement cotés — ces 4 encadrés
-- portent pourtant, dans le texte, un tag « Accord fort/faible » identique en format à la
-- quasi-totalité des autres. Aucun sous-ensemble testé ne correspond exactement à « 69 ».
-- Une seule exception existe par ailleurs : l'encadré 9.3.1 ne porte AUCUN tag dans la
-- source et est traité comme une absence de recommandation (cohérent avec le principe de ce
-- projet de ne jamais migrer une absence de recommandation comme une ligne graduée) — d'où
-- 71 - 1 = 70 lignes effectivement graduées et migrées ci-dessous. Comptage vérifié : 42
-- « Fort » + 28 « Faible » = 70.
--
-- PÉRIMÈTRE — volontairement pas migrés (référence/posologie, pas des recommandations
-- individuellement graduées) : le Tableau 1 (besoins énergétiques du brûlé — formules de
-- calcul) et le Tableau 2 (apports recommandés en glucides/lipides/protides par jour j1-j4
-- chez l'enfant) — tableaux de référence chiffrés appuyant des recommandations déjà migrées
-- (champ 9 brûlé, champ 10 pédiatrie), pas des recommandations graduées en tant que telles.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SFAR et SRLF (toutes deux dans le seed Annexe B) liées en document_societies ; SFNEP
--    (Société francophone nutrition clinique et métabolique), co-organisatrice au même
--    titre, n'a pas d'entrée correspondante dans le seed.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Nutrition artificielle en réanimation',
  'RFE', 'fr', '2014-01-01',
  'https://sfar.org/nutrition-artificielle-en-reanimation%E2%80%A8/',
  'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Nutrition-artificielle-en-reanimation.pdf',
  'Méthode GRADE pour l''analyse de la littérature, mais chip unique « Accord fort »/« Accord faible » imprimé après chaque recommandation (force du consensus Delphi) — reproduit tel quel comme grade. Le niveau de force GRADE (1/2) n''est jamais réimprimé par recommandation ; il ne se déduit que du verbe de l''énoncé, non extrait comme cotation séparée. Champs 1-3 décrits par la méthodologie comme "points forts" non formellement cotés, mais portant en pratique le même tag Accord que les autres champs (divergence disclosée). Résumé officiel "69 recommandations" vs 71 encadrés numérotés trouvés par inventaire direct (aucun sous-ensemble ne correspond à 69) — 70 effectivement gradées et migrées, 1 (encadré 9.3.1) sans tag traitée comme absence de recommandation.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/nutrition-artificielle-en-reanimation%E2%80%A8/'
  and s.acronym in ('SFAR', 'SRLF') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/nutrition-artificielle-en-reanimation%E2%80%A8/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'endocrinologie_diabetologie_maladies_metaboliques', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.source_section,
  'https://sfar.org/nutrition-artificielle-en-reanimation%E2%80%A8/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000034-R01', 'Tout patient admis en réanimation pour une durée présumée supérieure à 3 jours est à risque de dénutrition. Cette dernière augmente la morbi-mortalité (infection en particulier) et les durées de ventilation, de séjour et d''hospitalisation.', 'Fort', null, 'Champs 1-3 — Points forts (physiopathologie et évaluation) (Réf. 1.1)'),
  ('MG-ANES-000034-R02', 'Pour évaluer précisément la dépense énergétique d''un patient de réanimation, il faut utiliser la calorimétrie indirecte (méthode de référence, en tenant compte de ses limites d''utilisation) plutôt que les équations prédictives.', 'Faible', null, 'Champs 1-3 — Points forts (physiopathologie et évaluation) (Réf. 2.1)'),
  ('MG-ANES-000034-R03', 'Il faut probablement limiter le déficit énergétique précoce (dépenses moins apports cumulés) durant la première semaine pour réduire la morbi-mortalité en réanimation.', 'Fort', null, 'Champs 1-3 — Points forts (physiopathologie et évaluation) (Réf. 2.2)'),
  ('MG-ANES-000034-R04', 'Il faut probablement évaluer l''état nutritionnel des patients à l''admission au minimum en calculant l''IMC et en évaluant la perte de poids.', 'Faible', null, 'Champs 1-3 — Points forts (physiopathologie et évaluation) (Réf. 3.1)'),
  ('MG-ANES-000034-R05', 'Il faut administrer dans les 24 premières heures un support nutritionnel entéral aux patients dénutris ou jugés incapables de s''alimenter suffisamment dans les 3 jours après l''admission.', 'Fort', null, 'Champ 4 — Stratégie générale du support nutritionnel (Réf. 4.1)'),
  ('MG-ANES-000034-R06', 'Il faut utiliser la nutrition entérale (NE) plutôt que la nutrition parentérale (NP), en l''absence de contre-indication formelle.', 'Fort', null, 'Champ 4 — Stratégie générale du support nutritionnel (Réf. 4.2)'),
  ('MG-ANES-000034-R07', 'Il ne faut probablement pas utiliser la NE en amont d''une fistule digestive de haut débit, en cas d''occlusion intestinale, d''ischémie du grêle ou d''hémorragie digestive active.', 'Fort', null, 'Champ 4 — Stratégie générale du support nutritionnel (Réf. 4.3)'),
  ('MG-ANES-000034-R08', 'Il faut instaurer une NP de complément lorsque la NE n''atteint pas la cible calorique choisie au plus tard après 1 semaine de séjour en réanimation.', 'Fort', null, 'Champ 4 — Stratégie générale du support nutritionnel (Réf. 4.4)'),
  ('MG-ANES-000034-R09', 'En cas d''utilisation de calorimétrie indirecte, il ne faut probablement pas dépasser la dépense énergétique mesurée.', 'Faible', null, 'Champ 4 — Stratégie générale du support nutritionnel (Réf. 4.5)'),
  ('MG-ANES-000034-R10', 'En l''absence de calorimétrie indirecte, il faut probablement un objectif calorique total de 20-25 kcal/kg/j à la phase aiguë et 25-30 kcal/kg/j après stabilisation.', 'Faible', null, 'Champ 4 — Stratégie générale du support nutritionnel (Réf. 4.6)'),
  ('MG-ANES-000034-R11', 'En l''absence de calorimétrie indirecte, il faut tenir compte du poids habituel (ou à défaut du poids à l''admission) pour des IMC entre 20 et 35.', 'Faible', null, 'Champ 4 — Stratégie générale du support nutritionnel (Réf. 4.7)'),
  ('MG-ANES-000034-R12', 'Il faut répartir les apports caloriques non protéiques en 60-70 % glucidiques et 30-40 % lipidiques.', 'Fort', null, 'Champ 4 — Stratégie générale du support nutritionnel (Réf. 4.8)'),
  ('MG-ANES-000034-R13', 'Il faut apporter 1,2 à 1,5 g/kg/j de protéines.', 'Fort', null, 'Champ 4 — Stratégie générale du support nutritionnel (Réf. 4.9)'),
  ('MG-ANES-000034-R14', 'En cas de limitation ou arrêt thérapeutique, il faut discuter de l''opportunité du support nutritionnel.', 'Fort', null, 'Champ 4 — Stratégie générale du support nutritionnel (Réf. 4.10)'),
  ('MG-ANES-000034-R15', 'Lorsque l''alimentation orale exclusive est insuffisante, il faut probablement ajouter des compléments nutritionnels oraux (CNO), en dehors des heures de repas.', 'Faible', null, 'Champ 5 — Compléments oraux (Réf. 5.1)'),
  ('MG-ANES-000034-R16', 'Il ne faut pas mesurer le volume résiduel gastrique.', 'Faible', null, 'Champ 6 — Nutrition entérale (Réf. 6.1)'),
  ('MG-ANES-000034-R17', 'Il faut probablement privilégier la sonde d''alimentation naso- ou oro-gastrique en première intention (simplicité, moindre coût).', 'Fort', null, 'Champ 6 — Nutrition entérale (Réf. 6.2)'),
  ('MG-ANES-000034-R18', 'Il faut envisager l''administration de prokinétiques (métoclopramide et/ou érythromycine) pour améliorer l''apport calorique global en cas de trouble de la vidange gastrique.', 'Fort', null, 'Champ 6 — Nutrition entérale (Réf. 6.3)'),
  ('MG-ANES-000034-R19', 'Il faut probablement envisager le site post-pylorique en cas de trouble persistant (malgré les prokinétiques) de la vidange gastrique.', 'Faible', null, 'Champ 6 — Nutrition entérale (Réf. 6.4)'),
  ('MG-ANES-000034-R20', 'Il faut installer le patient en position semi-assise (>30°) pendant la NE.', 'Fort', null, 'Champ 6 — Nutrition entérale (Réf. 6.5)'),
  ('MG-ANES-000034-R21', 'Il faut instituer une stratégie multidisciplinaire formalisée de NE.', 'Faible', null, 'Champ 6 — Nutrition entérale (Réf. 6.6)'),
  ('MG-ANES-000034-R22', 'Il faut probablement poser une gastrostomie lorsque la durée anticipée d''une NE dépasse 4 semaines.', 'Faible', null, 'Champ 6 — Nutrition entérale (Réf. 6.7)'),
  ('MG-ANES-000034-R23', 'Il faut utiliser des mélanges polymériques pour débuter une NE.', 'Fort', null, 'Champ 6 — Nutrition entérale (Réf. 6.8)'),
  ('MG-ANES-000034-R24', 'Il faut probablement réserver les mélanges semi-élémentaires à certaines situations digestives spécifiques (grêle court).', 'Fort', null, 'Champ 6 — Nutrition entérale (Réf. 6.9)'),
  ('MG-ANES-000034-R25', 'Il ne faut pas utiliser de mélanges polymériques spécifiques (diabète, insuffisance respiratoire).', 'Fort', null, 'Champ 6 — Nutrition entérale (Réf. 6.10)'),
  ('MG-ANES-000034-R26', 'Il faut administrer le mélange nutritif entéral de manière continue 24h/24 à l''aide d''une pompe.', 'Faible', null, 'Champ 6 — Nutrition entérale (Réf. 6.11)'),
  ('MG-ANES-000034-R27', 'Il faut probablement adapter le débit d''administration en vue d''atteindre la cible nutritionnelle en moins de 48 heures.', 'Fort', null, 'Champ 6 — Nutrition entérale (Réf. 6.12)'),
  ('MG-ANES-000034-R28', 'Il faut probablement utiliser les mélanges contenant des fibres extraites de la gomme de guar en cas de diarrhée.', 'Fort', null, 'Champ 6 — Nutrition entérale (Réf. 6.13)'),
  ('MG-ANES-000034-R29', 'Il faut utiliser les mélanges prêts à l''emploi plutôt que les flacons séparés.', 'Fort', null, 'Champ 7 — Nutrition parentérale (Réf. 7.1)'),
  ('MG-ANES-000034-R30', 'Il faut supplémenter le patient en vitamines et éléments traces en cas de nutrition parentérale.', 'Fort', null, 'Champ 7 — Nutrition parentérale (Réf. 7.2)'),
  ('MG-ANES-000034-R31', 'Il ne faut pas excéder un apport lipidique de 1,5 g/kg/j.', 'Fort', null, 'Champ 7 — Nutrition parentérale (Réf. 7.3)'),
  ('MG-ANES-000034-R32', 'Il faut administrer la nutrition parentérale en continu à l''aide d''une pompe électrique à régulation de débit, et éviter son administration cyclique.', 'Fort', null, 'Champ 7 — Nutrition parentérale (Réf. 7.4)'),
  ('MG-ANES-000034-R33', 'Il faut utiliser un abord veineux central en cas d''administration de solutés hyperosmolaires (>850 mOsm/L).', 'Fort', null, 'Champ 7 — Nutrition parentérale (Réf. 7.5)'),
  ('MG-ANES-000034-R34', 'Il faut probablement privilégier l''administration de la nutrition parentérale sur une voie dédiée du cathéter veineux central.', 'Faible', null, 'Champ 7 — Nutrition parentérale (Réf. 7.6)'),
  ('MG-ANES-000034-R35', 'Il faut évoquer une complication métabolique ou un excès d''apport en cas d''anomalie(s) du bilan biologique (transaminases, bilirubine, gamma-GT, PAL, ionogramme, phosphore, glycémie, triglycérides).', 'Fort', null, 'Champ 7 — Nutrition parentérale (Réf. 7.7)'),
  ('MG-ANES-000034-R36', 'Si le patient a bénéficié d''une pharmaconutrition préopératoire (chirurgie carcinologique digestive), il faut la poursuivre en période postopératoire chez le patient préalablement dénutri.', 'Fort', null, 'Champ 8 — Pharmaconutrition, vitamines, éléments traces (Réf. 8.1)'),
  ('MG-ANES-000034-R37', 'Il ne faut pas administrer de solution entérale enrichie en arginine chez le patient en sepsis sévère.', 'Fort', null, 'Champ 8 — Pharmaconutrition, vitamines, éléments traces (Réf. 8.2)'),
  ('MG-ANES-000034-R38', 'Il faut probablement associer à la nutrition parentérale exclusive de la glutamine intraveineuse à la posologie d''au moins 0,35 g/kg/j (sous forme de dipeptide à ≥0,5 g/kg/j), pendant une période minimale de 10 jours.', 'Faible', null, 'Champ 8 — Pharmaconutrition, vitamines, éléments traces (Réf. 8.3)'),
  ('MG-ANES-000034-R39', 'Il faut probablement majorer l''apport protéique quotidien du patient sous épuration extrarénale continue à 1,7-2 g/kg/j.', 'Faible', null, 'Champ 9 — Particularités liées au terrain (Réf. 9.2.1)'),
  ('MG-ANES-000034-R40', 'Si une supplémentation en glutamine est indiquée, il faut probablement la majorer.', 'Faible', null, 'Champ 9 — Particularités liées au terrain (Réf. 9.2.2)'),
  ('MG-ANES-000034-R41', 'Il faut probablement augmenter les apports en vitamines hydrosolubles (B1, C) et en éléments trace (sélénium, cuivre) chez les patients sous épuration extrarénale continue.', 'Faible', null, 'Champ 9 — Particularités liées au terrain (Réf. 9.2.3)'),
  ('MG-ANES-000034-R42', 'Il ne faut probablement pas diminuer l''apport d''acides aminés chez l''insuffisant hépatique aigu, sauf transitoirement en cas d''encéphalopathie et/ou d''hyperammoniémie.', 'Fort', null, 'Champ 9 — Particularités liées au terrain (Réf. 9.3.2)'),
  ('MG-ANES-000034-R43', 'Il ne faut pas interrompre systématiquement la nutrition entérale lors de la mise en décubitus ventral.', 'Fort', null, 'Champ 9 — Particularités liées au terrain (Réf. 9.4.1)'),
  ('MG-ANES-000034-R44', 'Il ne faut pas calculer les apports en fonction du poids réel.', 'Fort', null, 'Champ 9 — Particularités liées au terrain (Réf. 9.6.1)'),
  ('MG-ANES-000034-R45', 'Il faut probablement calculer les apports nutritionnels en fonction du poids ajusté (PIT + 1/4 × [poids réel − PIT]).', 'Faible', null, 'Champ 9 — Particularités liées au terrain (Réf. 9.6.2)'),
  ('MG-ANES-000034-R46', 'En tenant compte de ce poids ajusté, il faut probablement apporter 20 kcal/kg/j dont 2 g/kg/j de protéines.', 'Faible', null, 'Champ 9 — Particularités liées au terrain (Réf. 9.6.3)'),
  ('MG-ANES-000034-R47', 'En cas de dénutrition sévère et/ou de jeûne prolongé >1 semaine, il faut probablement débuter la nutrition artificielle à 10 kcal/kg/j, puis augmenter progressivement selon la tolérance.', 'Faible', null, 'Champ 9 — Particularités liées au terrain (Réf. 9.7.1)'),
  ('MG-ANES-000034-R48', 'Il faut supplémenter systématiquement en vitamines (B surtout), éléments trace et phosphore.', 'Fort', null, 'Champ 9 — Particularités liées au terrain (Réf. 9.7.2)'),
  ('MG-ANES-000034-R49', 'En cas de dénutrition sévère et/ou de jeûne prolongé de plus d''une semaine, il faut doser la phosphatémie au moins 1×/jour ; suspecter un syndrome de renutrition si hypophosphatémie — dans ce cas, stopper temporairement l''alimentation et corriger la phosphatémie.', 'Fort', null, 'Champ 9 — Particularités liées au terrain (Réf. 9.7.3)'),
  ('MG-ANES-000034-R50', 'Les besoins énergétiques du patient gravement brûlé sont fortement augmentés mais variables dans le temps, proportionnels à la surface corporelle atteinte, mais plafonnant à partir d''une SCB de 60 %.', 'Fort', null, 'Champ 9 (suite) — Patient gravement brûlé (Réf. 9.8.1)'),
  ('MG-ANES-000034-R51', 'En l''absence de calorimétrie indirecte, il faut déterminer les besoins énergétiques avec la formule de Toronto (adulte) — les formules fixes conduisent à une sous/surestimation.', 'Fort', null, 'Champ 9 (suite) — Patient gravement brûlé (Réf. 9.8.2)'),
  ('MG-ANES-000034-R52', 'Il faut utiliser des mesures non nutritionnelles pour atténuer l''hypermétabolisme/hypercatabolisme (température ambiante, chirurgie d''excision précoce, bêtabloquants non sélectifs, oxandrolone). Contrairement à l''adulte, il faut substituer en rh-GH les enfants brûlés à plus de 60 %.', 'Faible', null, 'Champ 9 (suite) — Patient gravement brûlé (Réf. 9.8.3)'),
  ('MG-ANES-000034-R53', 'Il faut probablement situer les besoins protéiques à 1,5-2 g/kg/j (respecter une proportion de l''apport énergétique total chez l''enfant).', 'Fort', 'Pédiatrie', 'Champ 9 (suite) — Patient gravement brûlé (Réf. 9.8.4)'),
  ('MG-ANES-000034-R54', 'Il faut probablement supplémenter en glutamine ou en alpha-cétoglutarate d''ornithine.', 'Faible', null, 'Champ 9 (suite) — Patient gravement brûlé (Réf. 9.8.5)'),
  ('MG-ANES-000034-R55', 'Il ne faut probablement pas supplémenter en arginine.', 'Faible', null, 'Champ 9 (suite) — Patient gravement brûlé (Réf. 9.8.6)'),
  ('MG-ANES-000034-R56', 'Il faut probablement associer une supplémentation en zinc, cuivre et sélénium.', 'Faible', null, 'Champ 9 (suite) — Patient gravement brûlé (Réf. 9.8.7)'),
  ('MG-ANES-000034-R57', 'Il faut dépister la dénutrition protéino-calorique à l''admission et surveiller sa survenue en cours de séjour.', 'Fort', 'Pédiatrie', 'Champ 10 — Particularités pédiatriques (Réf. 10.1.1)'),
  ('MG-ANES-000034-R58', 'Il faut rechercher une évolution récente des courbes de croissance (cassure Poids/Taille/IMC) ou une perte de poids récente.', 'Faible', 'Pédiatrie', 'Champ 10 — Particularités pédiatriques (Réf. 10.1.2)'),
  ('MG-ANES-000034-R59', 'Il faut mesurer poids, taille, périmètre crânien (PC) et périmètre brachial (PB) pour calculer les indices pédiatriques de dénutrition (rapport poids-taille, taille/âge, IMC, PB/PC chez les <4 ans).', 'Fort', 'Pédiatrie', 'Champ 10 — Particularités pédiatriques (Réf. 10.1.3)'),
  ('MG-ANES-000034-R60', 'Il faut probablement estimer la taille des patients >1 mètre, alités, rétractés ou déformés par la mesure de la longueur de l''ulna.', 'Faible', 'Pédiatrie', 'Champ 10 — Particularités pédiatriques (Réf. 10.1.4)'),
  ('MG-ANES-000034-R61', 'Il faut fournir au moins les apports caloriques (100-90 kcal/kg/j <1 an, nouveau-né exclu ; 90-75 entre 1-6 ans ; 75-60 entre 7-12 ans ; 60-30 entre 13-18 ans) et protidiques (2-3 g/kg/j <2 ans, nouveau-né exclu ; 1,5-2 entre 2-12 ans ; 1,5 entre 13-18 ans) adaptés au poids et à l''âge.', 'Fort', 'Pédiatrie', 'Champ 10 — Particularités pédiatriques (Réf. 10.2.1)'),
  ('MG-ANES-000034-R62', 'Il faut probablement majorer les apports caloriques et protidiques en cas d''augmentation importante du travail respiratoire.', 'Faible', 'Pédiatrie', 'Champ 10 — Particularités pédiatriques (Réf. 10.2.2)'),
  ('MG-ANES-000034-R63', 'Il faut fournir des apports lipidiques couvrant 30-40 % des apports caloriques totaux ; il ne faut probablement pas dépasser 4 g/kg/j.', 'Faible', 'Pédiatrie', 'Champ 10 — Particularités pédiatriques (Réf. 10.2.3)'),
  ('MG-ANES-000034-R64', 'En situation normale d''hydratation, il faut fournir les apports liquidiens suivants : 120-150 mL/kg/j (<1 an, nouveau-né exclu) ; 80-120 (1-2 ans) ; 80-100 (3-5 ans) ; 60-80 (6-12 ans) ; 50-70 (13-18 ans), avec facteur correctif selon l''état d''hydratation.', 'Fort', 'Pédiatrie', 'Champ 10 — Particularités pédiatriques (Réf. 10.2.4)'),
  ('MG-ANES-000034-R65', 'Il faut assurer les apports recommandés en vitamines et éléments trace en fonction de l''âge — utiliser des produits spécifiquement destinés à l''enfant.', 'Fort', 'Pédiatrie', 'Champ 10 — Particularités pédiatriques (Réf. 10.2.5)'),
  ('MG-ANES-000034-R66', 'Il faut nourrir tous les enfants hospitalisés en réanimation.', 'Fort', 'Pédiatrie', 'Champ 10 — Particularités pédiatriques (Réf. 10.3.1)'),
  ('MG-ANES-000034-R67', 'Il faut utiliser la voie entérale en première intention chez l''enfant présentant un tube digestif fonctionnel.', 'Fort', 'Pédiatrie', 'Champ 10 — Particularités pédiatriques (Réf. 10.3.2)'),
  ('MG-ANES-000034-R68', 'Il faut probablement instaurer une nutrition parentérale entre le 3e et le 5e jour pour atteindre l''objectif calorique, en complément ou exclusivement.', 'Fort', 'Pédiatrie', 'Champ 10 — Particularités pédiatriques (Réf. 10.3.3)'),
  ('MG-ANES-000034-R69', 'Il faut utiliser des solutés de nutrition entérale et parentérale spécifiquement destinés à l''enfant.', 'Fort', 'Pédiatrie', 'Champ 10 — Particularités pédiatriques (Réf. 10.3.4)'),
  ('MG-ANES-000034-R70', 'Il faut augmenter les apports énergétiques de manière progressive, en particulier les apports glucosés parentéraux (incrémentation de 2 g/kg/j).', 'Faible', 'Pédiatrie', 'Champ 10 — Particularités pédiatriques (Réf. 10.3.5)')
) as v(code, statement, grade, population, source_section)
where d.source_url = 'https://sfar.org/nutrition-artificielle-en-reanimation%E2%80%A8/'
on conflict (recommendation_code) do nothing;
