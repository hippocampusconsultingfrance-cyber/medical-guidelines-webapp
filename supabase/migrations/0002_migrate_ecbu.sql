-- Migration : Place de l'ECBU avant une prise en charge urologique chirurgicale ou interventionnelle
-- chez l'adulte et modalités de traitement en cas de colonisation (AFU/CIAFU, RBP, texte court janvier 2026)
-- Source : rfe-sfar-website/build/content_ecbu.json (46 recommandations atomiques identifiées à la lecture)
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. build/library_final.json donne un direct_pdf_url différent de celui cité dans le panneau "Sources et
--    traçabilité" du contenu déjà construit et audité (content_ecbu.json) : la bibliothèque indique
--    'Reco_ECBU_Synthese_04.03.2026_MEL.pdf', le contenu vérifié cite 'Reco_ECBU_Synthese_23.02.2023_MEL.pdf'.
--    C'est cette seconde URL (celle réellement lue/auditée au moment de la construction de la fiche) qui
--    est utilisée ci-dessous comme source_url — à confirmer/mettre à jour si la bibliothèque a raison et
--    que le fichier a été remplacé depuis.
-- 2. La synthèse numérote ses recommandations sur 3 pistes indépendantes (Q1/Q2/Q3, une question clinique
--    distincte chacune), chacune recommençant à R1 : ce n'est PAS une collision (R1(Q1) != R1(Q2) != R1(Q3)).
--    R5(Q2) est absent de la synthèse source sans explication (saut R4->R6) — gap non résolu, reproduit tel quel.
-- 3. Le fabricant "fiche" d'origine ne numérote pas individuellement le tableau des lignes de traitement
--    antibiotique (Grade AE global) ; sa note de bas de page porte, elle, le numéro R6(Q3) explicite — les
--    deux sont fusionnés ici en une seule recommandation R6(Q3), la source ne permettant pas de les séparer
--    proprement (voir commentaire sur cette ligne plus bas).
--
-- Méthodologie : HAS — Recommandations par Consensus Formalisé (RCF, guide méthodologique HAS 2011).
-- Grades A (preuve établie) / B (présomption scientifique) / C (faible niveau de preuve) / AE (accord d'experts).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Place de l''ECBU avant une prise en charge urologique chirurgicale ou interventionnelle chez l''adulte et modalités de traitement en cas de colonisation',
  'RBP', 'fr', '2026-01-01',
  'https://www.urofrance.org/wp-content/uploads/2026/03/Reco_ECBU_Synthese_23.02.2023_MEL.pdf',
  'https://www.urofrance.org/wp-content/uploads/2026/03/Reco_ECBU_Synthese_23.02.2023_MEL.pdf',
  'HAS — Recommandations par Consensus Formalisé (RCF) : grades A/B/C ou Accord d''Experts (AE)',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://www.urofrance.org/wp-content/uploads/2026/03/Reco_ECBU_Synthese_23.02.2023_MEL.pdf'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;
-- À VÉRIFIER : document élaboré par l'AFU/CIAFU (Association Française d'Urologie), pas par SFAR elle-même
-- (SFAR est seulement co-signataire relais, cf. content_ecbu.json : "avec l'AFUF, la SF2H, la SFM, la SFAR,
-- Renaloo et Le Lien"). AFU/CIAFU/AFUF/SF2H/SFM/Renaloo/Le Lien ne figurent pas dans le seed Annexe B (qui
-- ne liste que des sociétés d'anesthésie-réanimation/urgences) — non ajoutées ici pour ne pas fabriquer de
-- lignes societies hors du périmètre validé par l'Annexe B ; à compléter lors de l'extension du référentiel.

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://www.urofrance.org/wp-content/uploads/2026/03/Reco_ECBU_Synthese_23.02.2023_MEL.pdf'
  and s.slug in ('urologie', 'anesthesie_reanimation', 'infectiologie_maladies_infectieuses_et_tropicales')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, intervention, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.intervention, v.source_section,
  'https://www.urofrance.org/wp-content/uploads/2026/03/Reco_ECBU_Synthese_23.02.2023_MEL.pdf',
  'draft'
from public.documents d, (values
  ('MG-ANES-000002-R01', 'Lorsqu''un ECBU n''est pas recommandé en préopératoire, il est de fait non recommandé de traiter une colonisation urinaire, qu''il y ait ou non du matériel endo-urinaire en place.', 'AE', 'Décision de traiter une colonisation urinaire (Q1)', null, 'Règle d''or, R1 (Q1)'),
  ('MG-ANES-000002-R02', 'En cas d''infection urinaire (et non simple colonisation), le groupe de travail suggère de reporter l''intervention chirurgicale jusqu''à résolution de l''infection.', 'AE', 'Décision de traiter une colonisation urinaire (Q1)', null, 'R1.bis (Q1)'),
  ('MG-ANES-000002-R03', 'L''ECBU est la méthode de référence pour dépister une colonisation urinaire.', 'A', 'Indication et réalisation de l''ECBU préopératoire (Q2)', null, 'R1 (Q2)'),
  ('MG-ANES-000002-R04', 'Ne PAS utiliser la bandelette urinaire pour dépister une colonisation urinaire.', 'B', 'Indication et réalisation de l''ECBU préopératoire (Q2)', null, 'R2 (Q2)'),
  ('MG-ANES-000002-R05', 'Réaliser l''ECBU préopératoire dans les 10 jours précédant l''intervention (extensible à 15 jours si contrainte organisationnelle).', 'AE', 'Indication et réalisation de l''ECBU préopératoire (Q2)', null, 'R3 (Q2)'),
  ('MG-ANES-000002-R06', 'Seul le résultat de la culture bactérienne compte : ni le Gram ni la leucocyturie ne préjugent du résultat définitif.', 'C', 'Indication et réalisation de l''ECBU préopératoire (Q2)', null, 'R4 (Q2)'),
  ('MG-ANES-000002-R07', 'Culture mono/bi-microbienne : antibiogramme sur les espèces retrouvées selon le référentiel REMIC.', 'AE', 'Indication et réalisation de l''ECBU préopératoire (Q2)', null, 'R6 (Q2)'),
  ('MG-ANES-000002-R08', 'Culture polymicrobienne (au moins 3 germes) : pas de consensus pour recommander (ou non) un nouvel ECBU ou un antibiogramme complet.', 'AE', 'Indication et réalisation de l''ECBU préopératoire (Q2)', null, 'R7 (Q2)'),
  ('MG-ANES-000002-R09', 'Dérivation urinaire (néphrostomie, Bricker...) : pas de données ni de consensus sur le mode de prélèvement à réaliser.', 'AE', 'Indication et réalisation de l''ECBU préopératoire (Q2)', null, 'R8 (Q2)'),
  ('MG-ANES-000002-R10', 'ECBU per-opératoire sur urines pyéliques suggéré (à défaut, culture de calcul) pour ajuster l''antibiothérapie en cas de sepsis post-opératoire.', 'C', 'Cas particulier — néphrolithotomie percutanée (NLPC) et calculs infectieux', null, 'Note NLPC/calculs infectieux (numéro non précisé dans la source)'),
  ('MG-ANES-000002-R11', 'ECBU préopératoire indiqué avant : Résection transurétrale de prostate (RTUP).', 'B', 'Indication de l''ECBU préopératoire par acte', 'Résection transurétrale de prostate (RTUP)', 'Tableau ECBU indiqué — Résection transurétrale de prostate (RTUP) (réf. ElMalik 2000 (NP2))'),
  ('MG-ANES-000002-R12', 'ECBU préopératoire indiqué avant : Énucléation de la prostate pour HBP (HoLEP, ThuLEP, GreenLEP, bipolaire).', 'AE', 'Indication de l''ECBU préopératoire par acte', 'Énucléation de la prostate pour HBP (HoLEP, ThuLEP, GreenLEP, bipolaire)', 'Tableau ECBU indiqué — Énucléation de la prostate pour HBP (HoLEP, ThuLEP, GreenLEP, bipolaire)'),
  ('MG-ANES-000002-R13', 'ECBU préopératoire indiqué avant : Résection transurétrale de la vessie (RTUV).', 'C', 'Indication de l''ECBU préopératoire par acte', 'Résection transurétrale de la vessie (RTUV)', 'Tableau ECBU indiqué — Résection transurétrale de la vessie (RTUV) (réf. Kohada 2019, Kutchukian 2024)'),
  ('MG-ANES-000002-R14', 'ECBU préopératoire indiqué avant : Cure de jonction pyélo-urétérale (sonde JJ).', 'AE', 'Indication de l''ECBU préopératoire par acte', 'Cure de jonction pyélo-urétérale (sonde JJ)', 'Tableau ECBU indiqué — Cure de jonction pyélo-urétérale (sonde JJ) (réf. cf. reco CIAFU)'),
  ('MG-ANES-000002-R15', 'ECBU préopératoire indiqué avant : Urétéroplastie.', 'AE', 'Indication de l''ECBU préopératoire par acte', 'Urétéroplastie', 'Tableau ECBU indiqué — Urétéroplastie'),
  ('MG-ANES-000002-R16', 'ECBU préopératoire indiqué avant : Urétéroscopie diagnostique et/ou thérapeutique.', 'B', 'Indication de l''ECBU préopératoire par acte', 'Urétéroscopie diagnostique et/ou thérapeutique', 'Tableau ECBU indiqué — Urétéroscopie diagnostique et/ou thérapeutique (réf. Martov 2015, Sohn 2013 — cf. reco CLAFU)'),
  ('MG-ANES-000002-R17', 'ECBU préopératoire indiqué avant : Uréthrotomie.', 'C', 'Indication de l''ECBU préopératoire par acte', 'Uréthrotomie', 'Tableau ECBU indiqué — Uréthrotomie (réf. Noble 2022 (NP4))'),
  ('MG-ANES-000002-R18', 'ECBU préopératoire indiqué avant : Uréthroplastie.', 'C', 'Indication de l''ECBU préopératoire par acte', 'Uréthroplastie', 'Tableau ECBU indiqué — Uréthroplastie (réf. Noble 2022 (NP4))'),
  ('MG-ANES-000002-R19', 'ECBU préopératoire indiqué avant : Montée / changement de sonde de néphrostomie, mono-J ou JJ.', 'AE', 'Indication de l''ECBU préopératoire par acte', 'Montée / changement de sonde de néphrostomie, mono-J ou JJ', 'Tableau ECBU indiqué — Montée / changement de sonde de néphrostomie, mono-J ou JJ (réf. cf. reco CIAFU)'),
  ('MG-ANES-000002-R20', 'ECBU préopératoire indiqué avant : Néphrolithotomie percutanée (NLPC).', 'A', 'Indication de l''ECBU préopératoire par acte', 'Néphrolithotomie percutanée (NLPC)', 'Tableau ECBU indiqué — Néphrolithotomie percutanée (NLPC) (réf. + urine pyélique si possible — cf. reco CLAFU)'),
  ('MG-ANES-000002-R21', 'ECBU préopératoire indiqué avant : Bilan urodynamique.', 'AE', 'Indication de l''ECBU préopératoire par acte', 'Bilan urodynamique', 'Tableau ECBU indiqué — Bilan urodynamique (réf. Egrot 2018 — accord fort)'),
  ('MG-ANES-000002-R22', 'ECBU préopératoire non indiqué avant : Prostatectomie totale.', 'C', 'Non-indication de l''ECBU préopératoire par acte', 'Prostatectomie totale', 'Tableau ECBU non indiqué — Prostatectomie totale (réf. Bourgi 2025b (NP4))'),
  ('MG-ANES-000002-R23', 'ECBU préopératoire non indiqué avant : Traitement de l''HBP par UROLIFT® / embolisation des artères prostatiques.', 'AE', 'Non-indication de l''ECBU préopératoire par acte', 'Traitement de l''HBP par UROLIFT® / embolisation des artères prostatiques', 'Tableau ECBU non indiqué — Traitement de l''HBP par UROLIFT® / embolisation des artères prostatiques'),
  ('MG-ANES-000002-R24', 'ECBU préopératoire non indiqué avant : Adénomectomie chirurgicale.', 'AE', 'Non-indication de l''ECBU préopératoire par acte', 'Adénomectomie chirurgicale', 'Tableau ECBU non indiqué — Adénomectomie chirurgicale'),
  ('MG-ANES-000002-R25', 'ECBU préopératoire non indiqué avant : Biopsie de prostate (trans-périnéale ou transrectale).', 'AE', 'Non-indication de l''ECBU préopératoire par acte', 'Biopsie de prostate (trans-périnéale ou transrectale)', 'Tableau ECBU non indiqué — Biopsie de prostate (trans-périnéale ou transrectale) (réf. cf. reco CCAFU / CIAFU)'),
  ('MG-ANES-000002-R26', 'ECBU préopératoire non indiqué avant : Cystectomie partielle ou totale (quel que soit le mode de dérivation).', 'C', 'Non-indication de l''ECBU préopératoire par acte', 'Cystectomie partielle ou totale (quel que soit le mode de dérivation)', 'Tableau ECBU non indiqué — Cystectomie partielle ou totale (quel que soit le mode de dérivation) (réf. Haider 2019, Kyoda 2010)'),
  ('MG-ANES-000002-R27', 'ECBU préopératoire non indiqué avant : Cystoscopie (quelle que soit l''indication).', 'B', 'Non-indication de l''ECBU préopératoire par acte', 'Cystoscopie (quelle que soit l''indication)', 'Tableau ECBU non indiqué — Cystoscopie (quelle que soit l''indication) (réf. Herr 2012-2016 (études concordantes))'),
  ('MG-ANES-000002-R28', 'ECBU préopératoire non indiqué avant : Implantation d''un sphincter urinaire artificiel.', 'C', 'Non-indication de l''ECBU préopératoire par acte', 'Implantation d''un sphincter urinaire artificiel', 'Tableau ECBU non indiqué — Implantation d''un sphincter urinaire artificiel (réf. Kavoussi 2017 (NP4))'),
  ('MG-ANES-000002-R29', 'ECBU préopératoire non indiqué avant : Instillations endovésicales (chimiothérapie, BCG, acide hyaluronique...).', 'B', 'Non-indication de l''ECBU préopératoire par acte', 'Instillations endovésicales (chimiothérapie, BCG, acide hyaluronique...)', 'Tableau ECBU non indiqué — Instillations endovésicales (chimiothérapie, BCG, acide hyaluronique...) (réf. Herr 2012-2020 (études concordantes))'),
  ('MG-ANES-000002-R30', 'ECBU préopératoire non indiqué avant : Injection de toxine botulique A / neuromodulation des racines sacrées.', 'AE', 'Non-indication de l''ECBU préopératoire par acte', 'Injection de toxine botulique A / neuromodulation des racines sacrées', 'Tableau ECBU non indiqué — Injection de toxine botulique A / neuromodulation des racines sacrées'),
  ('MG-ANES-000002-R31', 'ECBU préopératoire non indiqué avant : Néphrectomie partielle ou totale / néphro-urétérectomie.', 'C', 'Non-indication de l''ECBU préopératoire par acte', 'Néphrectomie partielle ou totale / néphro-urétérectomie', 'Tableau ECBU non indiqué — Néphrectomie partielle ou totale / néphro-urétérectomie (réf. Bruyere 2025, Ayoub 2024)'),
  ('MG-ANES-000002-R32', 'ECBU préopératoire non indiqué avant : Surrénalectomie / embolisation des artères rénales.', 'AE', 'Non-indication de l''ECBU préopératoire par acte', 'Surrénalectomie / embolisation des artères rénales', 'Tableau ECBU non indiqué — Surrénalectomie / embolisation des artères rénales'),
  ('MG-ANES-000002-R33', 'ECBU préopératoire non indiqué avant : Biopsie rénale ou thermoablation de tumeur rénale.', 'AE', 'Non-indication de l''ECBU préopératoire par acte', 'Biopsie rénale ou thermoablation de tumeur rénale', 'Tableau ECBU non indiqué — Biopsie rénale ou thermoablation de tumeur rénale'),
  ('MG-ANES-000002-R34', 'ECBU préopératoire non indiqué avant : Pose ou changement de cathéter de dialyse intrapéritonéale.', 'AE', 'Non-indication de l''ECBU préopératoire par acte', 'Pose ou changement de cathéter de dialyse intrapéritonéale', 'Tableau ECBU non indiqué — Pose ou changement de cathéter de dialyse intrapéritonéale'),
  ('MG-ANES-000002-R35', 'ECBU préopératoire non indiqué avant : Uréthrocystographie rétrograde.', 'AE', 'Non-indication de l''ECBU préopératoire par acte', 'Uréthrocystographie rétrograde', 'Tableau ECBU non indiqué — Uréthrocystographie rétrograde'),
  ('MG-ANES-000002-R36', 'ECBU préopératoire non indiqué avant : Pose d''implant pénien.', 'C', 'Non-indication de l''ECBU préopératoire par acte', 'Pose d''implant pénien', 'Tableau ECBU non indiqué — Pose d''implant pénien (réf. Kavoussi 2017 (NP4))'),
  ('MG-ANES-000002-R37', 'ECBU préopératoire non indiqué avant : Pose de prothèse testiculaire / chirurgie scrotale ou du pénis sans prothèse.', 'AE', 'Non-indication de l''ECBU préopératoire par acte', 'Pose de prothèse testiculaire / chirurgie scrotale ou du pénis sans prothèse', 'Tableau ECBU non indiqué — Pose de prothèse testiculaire / chirurgie scrotale ou du pénis sans prothèse'),
  ('MG-ANES-000002-R38', 'ECBU préopératoire non indiqué avant : Pose, ablation ou changement de sonde vésicale, cathéter sus-pubien.', 'AE', 'Non-indication de l''ECBU préopératoire par acte', 'Pose, ablation ou changement de sonde vésicale, cathéter sus-pubien', 'Tableau ECBU non indiqué — Pose, ablation ou changement de sonde vésicale, cathéter sus-pubien'),
  ('MG-ANES-000002-R39', 'ECBU préopératoire non indiqué avant : Radiothérapie, curiethérapie, pose de fiduciaires prostatiques.', 'AE', 'Non-indication de l''ECBU préopératoire par acte', 'Radiothérapie, curiethérapie, pose de fiduciaires prostatiques', 'Tableau ECBU non indiqué — Radiothérapie, curiethérapie, pose de fiduciaires prostatiques'),
  ('MG-ANES-000002-R40', 'Pour les actes suivants, aucun consensus n''existe sur la réalisation d''un ECBU préopératoire : thermothérapie vapeur (Rezum(R)), ultrasons focalises (HIFU), cure de prolapsus/incontinence (femme et homme), injection de macroplastique, transplantation renale, lithotripsie extra-corporelle. La balance benefice-risque (antibioresistance vs risque infectieux non demontre) penche pour la non-prescription selon la majorite du groupe de travail.', null, 'Actes sans consensus (ni recommandé, ni exclu)', null, 'Actes sans consensus (aucun grade individuel imprime pour ces 6 actes dans la source)'),
  ('MG-ANES-000002-R41', 'Traitement antibiotique adapté si indiqué, indépendamment de la quantité de micro-organisme isolé.', 'AE', 'Prise en charge d''un ECBU positif (colonisation confirmée)', null, 'R1 (Q3)'),
  ('MG-ANES-000002-R42', 'Durée du traitement : débuter 48h avant le geste, poursuivre au minimum jusqu''à J0 et au maximum 48h après, soit un total de 3 à 5 jours.', 'C', 'Prise en charge d''un ECBU positif (colonisation confirmée)', null, 'R2 (Q3)'),
  ('MG-ANES-000002-R43', 'NLPC : traiter systématiquement la colonisation (durée optimale non consensuelle en France).', 'AE', 'Prise en charge d''un ECBU positif (colonisation confirmée)', null, 'R3 (Q3)'),
  ('MG-ANES-000002-R44', 'Colonisation urinaire fongique préopératoire : pas de données ni de consensus pour recommander ou non un traitement.', 'AE', 'Prise en charge d''un ECBU positif (colonisation confirmée)', null, 'R4.bis (Q3)'),
  ('MG-ANES-000002-R45', 'Culture polymicrobienne (au moins 3 germes) : pas de consensus pour recommander ou non un traitement antibiotique.', 'AE', 'Prise en charge d''un ECBU positif (colonisation confirmée)', null, 'R5 (Q3)'),
  ('MG-ANES-000002-R46', 'Ordre de préférence des antibiotiques pour traiter une colonisation urinaire confirmée (même en cas de BLSE/SARM, privilégier une molécule simple, efficace selon l''antibiogramme, à bonne diffusion urinaire, peu délétère sur le microbiote, par voie orale de préférence) : 1re intention — fosfomycine-trométamol, nitrofurantoïne, pivmécillinam, triméthoprime ; 2e intention — amoxicilline, cotrimoxazole ; 3e intention — amoxicilline + acide clavulanique ; 4e intention — fluoroquinolones, céfixime ; 5e intention — autres antibiotiques selon antibiogramme si les 4 premières lignes ne sont pas adaptées (résistance, allergie...). En cas de décision de traiter un ECBU polymicrobien sans antibiogramme exploitable par souche, privilégier fosfomycine-trométamol, nitrofurantoïne, pivmécillinam ou triméthoprime.', 'AE', 'Antibiothérapie d''un ECBU positif — ordre de préférence', null, 'R6 (Q3) — tableau des lignes de traitement + note de bas de page combinés (la source ne les numérote pas séparément)')
) as v(code, statement, grade, condition_topic, intervention, source_section)
where d.source_url = 'https://www.urofrance.org/wp-content/uploads/2026/03/Reco_ECBU_Synthese_23.02.2023_MEL.pdf'
on conflict (recommendation_code) do nothing;
