-- Migration : Épanchement pleural liquidien de l'adulte en soins critiques — Recommandations
-- pour la Pratique Professionnelle (RPP, pas une RFE), sous l'égide de la SFAR, avec la
-- SFMU, la SPLF (pneumologie) et la SFCTCV (chirurgie thoracique). Validé par le Comité des
-- Référentiels Cliniques SFAR le 10/04/2023, CA SFAR 20/04/2023, CA SFCTCV/SFMU 21/06/2023,
-- CA SPLF 18/07/2023. Source : rfe-sfar-website/build/content_epanchement_pleural.json
-- (25 recommandations numérotées, 4 champs).
--
-- MÉTHODOLOGIE : méthode GRADE grid utilisée pour le vote, mais AUCUNE des 25
-- recommandations n'a pu être graduée numériquement faute de littérature suffisante — RPP
-- (avis d'experts), pas RFE. Un accord FORT a été obtenu pour les 25 recommandations, SANS
-- EXCEPTION, après 4 tours de cotation. Chip imprimé par la source pour chaque ligne : « AE »
-- (avis d'experts) littéralement, jamais de force de consensus distincte (contrairement à
-- `eer`/0020 où Fort/Faible varie ligne par ligne — ici toutes les lignes sont à Accord
-- fort, information disclosée au niveau du document via `grading_system`, pas dupliquée par
-- ligne puisque la source elle-même ne l'imprime pas par ligne). `grade = 'AE'` reproduit
-- tel quel le chip source, cohérent avec la convention déjà utilisée dans ce corpus pour
-- l'avis d'experts (ex. 0018_migrate_curares.sql). `evidence_level` laissé NULL.
--
-- COMPTAGE — RECONCILIÉ EXACTEMENT : la source annonce elle-même "25 recommandations
-- réparties en 4 champs" ; comptage direct des repères Rx.y.z du tableau "Réf. |
-- Recommandation | Accord" = 25 (R1.1-R1.3.2 : 4 ; R2.1.1-R2.6.4 : 15 ; R3.1-R3.2 : 2 ;
-- R4.1.1-R4.3 : 4). Reconciliation exacte, aucune ligne manquante ni surnuméraire.
--
-- PÉRIMÈTRE — volontairement pas migrés :
-- 1. 3 items « Absence de recommandation » (choix drainage vs ponction ; position du patient
--    allongée/demi-assise ; temps du cycle respiratoire pour le retrait chez le patient
--    ventilé) — les experts déclarent explicitement ne pas être en mesure de formuler de
--    recommandation faute de données. Cohérent avec le principe de ce projet de ne jamais
--    migrer une absence de recommandation comme une ligne graduée (même traitement que les
--    "questions sans recommandation" de curares/0018).
-- 2. Le tableau de référence "Suggestion de prise en charge des anticoagulants avant
--    drainage pleural" (7 lignes : Anticoagulant | Délai d'arrêt | Agent de réversion) —
--    tableau posologique par classe médicamenteuse, déjà couvert au niveau recommandation
--    par R14 (Réf. R2.4.3, "discuter au cas par cas de la réversion... évaluation
--    bénéfice/risque incluant la classe d'anticoagulant") : la donnée fine par molécule est
--    un référentiel pratique à l'appui de cette recommandation, pas une recommandation
--    distincte — même traitement que les tableaux de posologie déjà exclus ailleurs dans ce
--    corpus (ex. sugammadex/succinylcholine dans curares/0018).
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. **Incohérence interne à la source, disclosée telle quelle, non résolue silencieusement**
--    (principe 1.5 du projet) : le résumé de la source annonce « 15 experts », mais un
--    comptage direct des 4 listes nominatives imprimées par le contenu construit
--    (SFAR 9 + SFCTCV 3 + SFMU 2 + SPLF 2) donne 16 noms. Les deux chiffres sont reproduits
--    dans le commentaire ci-dessus et dans le contenu construit lui-même — aucun choix fait
--    entre les deux, à trancher par un relecteur humain disposant du texte intégral.
-- 2. Champ d'application explicitement restreint par la source elle-même : adultes de soins
--    critiques, HORS pleurésie purulente, hémothorax, épanchement néoplasique, ET hors
--    population pédiatrique — ce périmètre n'est pas répété par recommandation individuelle
--    (il s'applique globalement à tout le document) mais mérite d'être connu d'un relecteur
--    qui appliquerait ces recommandations hors du champ prévu par les auteurs. Reproduit dans
--    `grading_system`/à défaut dans ce commentaire plutôt que dans un champ dédié absent du
--    schéma actuel.
-- 3. RPP de 2023 (pas RFE) — `freshness_status` = 'a_jour' cohérent avec `library_final.json`
--    (`"status": "en vigueur"`), aucune divergence détectée pour ce document (contrairement à
--    `eclsa`/0019 ou `eer`/0020).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Épanchement pleural liquidien de l''adulte en soins critiques',
  'RPP', 'fr', '2023-09-01',
  'https://sfar.org/epanchement-pleural-liquidien-de-ladulte-en-soins-critiques/',
  'https://sfar.org/download/epanchement-pleural-liquidien-de-ladulte-en-soins-critiques/?wpdmdl=50053',
  'Recommandations pour la Pratique Professionnelle (RPP), pas RFE : méthode GRADE grid utilisée pour le vote, mais aucune des 25 recommandations n''a pu être graduée numériquement faute de littérature suffisante — toutes cotées « avis d''experts » (AE), avec accord FORT obtenu sans exception après 4 tours de cotation. Champ : adultes de soins critiques uniquement, hors pleurésie purulente, hémothorax, épanchement néoplasique et hors pédiatrie.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/epanchement-pleural-liquidien-de-ladulte-en-soins-critiques/'
  and s.acronym in ('SFAR', 'SFMU') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/epanchement-pleural-liquidien-de-ladulte-en-soins-critiques/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'medecine_d_urgence', 'pneumologie', 'chirurgie_thoracique')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/epanchement-pleural-liquidien-de-ladulte-en-soins-critiques/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000021-R01', 'Privilégier l''échographie pleuro-pulmonaire par rapport à la radiographie thoracique pour affirmer ou infirmer le diagnostic d''un épanchement pleural en soins critiques, sous réserve de la disponibilité d''un échographe et de l''expertise de l''opérateur.', 'AE', 'Champ 1 — Diagnostic et retentissement (Réf. R1.1)'),
  ('MG-ANES-000021-R02', 'Réaliser une analyse biochimique, cytologique et bactériologique du liquide pleural lors de la première ponction, puis à chaque fois que la cause de l''épanchement pourrait avoir changé, pour établir un diagnostic étiologique et optimiser la prise en charge thérapeutique.', 'AE', 'Champ 1 — Diagnostic et retentissement (Réf. R1.2)'),
  ('MG-ANES-000021-R03', 'Ne pas utiliser uniquement des critères quantitatifs basés sur l''imagerie pour poser l''indication d''une ponction ou d''un drainage d''un épanchement pleural liquidien, pour diminuer la morbi-mortalité.', 'AE', 'Champ 1 — Diagnostic et retentissement (Réf. R1.3.1)'),
  ('MG-ANES-000021-R04', 'Utiliser le volume de l''épanchement, le délai précoce et la rapidité d''installation, ainsi que la tolérance respiratoire (avec notamment une baisse de la compliance thoraco-pulmonaire chez le patient ventilé) pour poser l''indication d''une ponction ou d''un drainage et améliorer le rapport PaO2/FiO2.', 'AE', 'Champ 1 — Diagnostic et retentissement (Réf. R1.3.2)'),
  ('MG-ANES-000021-R05', 'Réaliser une échographie pleuro-pulmonaire (au minimum un écho-repérage ; au mieux un écho-guidage) pour améliorer la qualité et la sécurité du drainage pleural.', 'AE', 'Champ 2 — Procédure de drainage (Réf. R2.1.1)'),
  ('MG-ANES-000021-R06', 'Quelle que soit la voie d''abord, faire suivre la ponction et l''insertion du drain le bord supérieur de la côte, pour minimiser le risque de lésions vasculaires et nerveuses intercostales.', 'AE', 'Champ 2 — Procédure de drainage (Réf. R2.1.2)'),
  ('MG-ANES-000021-R07', 'Lorsque les données de l''échographie laissent le choix à plusieurs sites d''insertion, privilégier le « triangle de sécurité », pour diminuer la morbidité liée à la pose.', 'AE', 'Champ 2 — Procédure de drainage (Réf. R2.1.3)'),
  ('MG-ANES-000021-R08', 'Faire réaliser le drainage pleural par des personnes expérimentées lorsque les données de l''échographie ne retiennent pas le triangle de sécurité comme site possible d''insertion, pour diminuer la morbidité liée à la pose.', 'AE', 'Champ 2 — Procédure de drainage (Réf. R2.1.4)'),
  ('MG-ANES-000021-R09', 'Ne pas privilégier le drainage percutané par la technique de Seldinger par rapport à un drainage par technique chirurgicale, pour diminuer la mortalité.', 'AE', 'Champ 2 — Procédure de drainage (Réf. R2.2.1)'),
  ('MG-ANES-000021-R10', 'Privilégier le drainage percutané par la technique de Seldinger, pour diminuer la douleur.', 'AE', 'Champ 2 — Procédure de drainage (Réf. R2.2.2)'),
  ('MG-ANES-000021-R11', 'Devant l''absence de différence d''efficacité et de sécurité, privilégier un drain de petit calibre, pour diminuer la douleur.', 'AE', 'Champ 2 — Procédure de drainage (Réf. R2.3)'),
  ('MG-ANES-000021-R12', 'Ne pas arrêter les antithrombotiques (anticoagulants ou antiplaquettaires) avant de réaliser une ponction pleurale, considérée comme une procédure invasive à faible risque hémorragique, pour diminuer la morbi-mortalité.', 'AE', 'Champ 2 — Procédure de drainage (Réf. R2.4.1)'),
  ('MG-ANES-000021-R13', 'Suspendre les anticoagulants et les antiplaquettaires anti-P2Y12 (clopidogrel, prasugrel, ticagrelor) avant un drainage pleural, considéré comme une procédure invasive à haut risque hémorragique, pour diminuer la morbi-mortalité. L''aspirine peut être poursuivie.', 'AE', 'Champ 2 — Procédure de drainage (Réf. R2.4.2)'),
  ('MG-ANES-000021-R14', 'Lorsque l''urgence ne permet pas un arrêt suffisamment long des anticoagulants, discuter au cas par cas de la réversion de l''effet anticoagulant avant le drainage, pour diminuer la morbi-mortalité — évaluation bénéfice/risque incluant la classe d''anticoagulant, le niveau d''anticoagulation (par dosage biologique ou en fonction de la dernière administration), la technique de drainage (percutanée vs chirurgicale) et le niveau d''expertise de l''opérateur.', 'AE', 'Champ 2 — Procédure de drainage (Réf. R2.4.3)'),
  ('MG-ANES-000021-R15', 'Ne pas modifier les paramètres ventilatoires lors d''une ponction pleurale ou d''un drainage pleural, pour diminuer la morbidité liée à la pose.', 'AE', 'Champ 2 — Procédure de drainage (Réf. R2.5)'),
  ('MG-ANES-000021-R16', 'Réaliser systématiquement une anesthésie locale lors de la pose d''un drain pleural, quelle que soit la technique de pose utilisée, pour diminuer la douleur.', 'AE', 'Champ 2 — Procédure de drainage (Réf. R2.6.1)'),
  ('MG-ANES-000021-R17', 'Mettre en place une stratégie analgésique adaptée au patient pendant la durée du drainage, pour diminuer la douleur.', 'AE', 'Champ 2 — Procédure de drainage (Réf. R2.6.2)'),
  ('MG-ANES-000021-R18', 'Réévaluer quotidiennement l''indication du maintien du drain thoracique pour permettre de le retirer le plus rapidement possible, et ainsi diminuer la douleur liée à sa présence.', 'AE', 'Champ 2 — Procédure de drainage (Réf. R2.6.3)'),
  ('MG-ANES-000021-R19', 'Réaliser une analgésie multimodale associée à une infiltration d''anesthésique local et/ou à l''application locale de froid, afin de diminuer la douleur lors du retrait du drain.', 'AE', 'Champ 2 — Procédure de drainage (Réf. R2.6.4)'),
  ('MG-ANES-000021-R20', 'Réaliser systématiquement une radiographie thoracique après le drainage d''un épanchement pleural, pour visualiser la bonne position du drain (orientation, longueur dans la cavité pleurale) et dépister précocement une complication (pneumothorax, hémothorax).', 'AE', 'Champ 3 — Surveillance de l''efficacité et des complications (Réf. R3.1)'),
  ('MG-ANES-000021-R21', 'Ne pas mettre le drain systématiquement en aspiration, pour diminuer le risque de pneumothorax ou accélérer l''évacuation de l''épanchement.', 'AE', 'Champ 3 — Surveillance de l''efficacité et des complications (Réf. R3.2)'),
  ('MG-ANES-000021-R22', 'Ne pas retirer un drain évacuant plus de 450 mL/24h, pour ne pas augmenter la morbidité.', 'AE', 'Champ 4 — Procédure de retrait des drains (Réf. R4.1.1)'),
  ('MG-ANES-000021-R23', 'Retirer un drain évacuant moins de 300 mL/24h, pour diminuer la durée de drainage thoracique.', 'AE', 'Champ 4 — Procédure de retrait des drains (Réf. R4.1.2)'),
  ('MG-ANES-000021-R24', 'Lorsqu''une imagerie est jugée nécessaire, privilégier l''échographie à la radiographie de thorax pour évaluer la vidange pleurale et confirmer l''indication de l''ablation du drain.', 'AE', 'Champ 4 — Procédure de retrait des drains (Réf. R4.2)'),
  ('MG-ANES-000021-R25', 'Chez un patient en ventilation spontanée, retirer le drain pleural en fin d''expiration forcée, afin de diminuer le risque de pneumothorax après le retrait.', 'AE', 'Champ 4 — Procédure de retrait des drains (Réf. R4.3)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/epanchement-pleural-liquidien-de-ladulte-en-soins-critiques/'
on conflict (recommendation_code) do nothing;
