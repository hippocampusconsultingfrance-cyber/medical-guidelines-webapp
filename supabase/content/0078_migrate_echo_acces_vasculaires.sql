-- Migration : Recommandations sur l'utilisation de l'échographie lors de la
-- mise en place des accès vasculaires (RFE SFAR, méthode GRADE, validée par
-- le CA de la SFAR le 12/09/2014, publiée Anesth Réanim. 2015;1:183-189).
-- Source : rfe-sfar-website/build/content_echo_acces_vasculaires.json (deux
-- tableaux "N° | Recommandation | Grade" déjà atomiques, adulte R1-R5 puis
-- enfant R6-R10 ; chaque ligne = un seul site anatomique, un seul énoncé,
-- un seul grade — aucune fragmentation/fusion nécessaire).
--
-- R7 (voie sous-clavière chez l'enfant) N'EST PAS migrée en recommandation :
-- son chip est "?" et son texte dit explicitement "aucune recommandation ne
-- peut être proposée" (aucun essai randomisé disponible pour ce site chez
-- l'enfant, seules des études de faisabilité existent) — ce n'est pas un
-- énoncé "il faut faire X" avec un grade, donc hors périmètre du modèle
-- `recommendations` (même traitement que Question 5 de `tabagisme`/0077).
-- Numérotation native de la source (R1-R10) conservée telle quelle dans les
-- `recommendation_code` ci-dessous : la suite saute donc de R06 à R08,
-- disclosure de ce trou plutôt que renumérotation silencieuse.
--
-- SOURCE_URL / PDF_URL : `library_final.json` (titre "Recommandations sur
-- l'utilisation de l'échographie lors de la mise en place des accès
-- vasculaires", 2015 — exactement 1 correspondance) donne `href` et
-- `direct_pdf_url`, ce dernier identique à l'"URL source" citée par le
-- contenu construit lui-même.
--
-- `publication_date` = 2015-01-01 (année seule connue dans l'index comme
-- dans le contenu construit — "Anesth Réanim. 2015" ; même convention que le
-- cas "année seule" de `allergie_prevention`/0006 et `douleur_
-- postoperatoire`/0071). Distinct : la date de validation par le CA SFAR
-- (12/09/2014) est citée par le contenu construit mais n'est PAS la date de
-- publication — les deux dates sont disclosed ici, non confondues.
--
-- MÉTHODOLOGIE — GRADE® : qualité des preuves en 4 catégories (haute/
-- modérée/basse/très basse), formulation finale binaire positive/négative
-- et forte/faible. Le contenu construit donne, pour CHAQUE recommandation,
-- une qualité de preuve explicite distincte du grade de force (chip 1+/2+) —
-- ces deux informations sont donc portées par deux colonnes séparées
-- ci-dessous : `grade` (chip source, force de la recommandation) et
-- `evidence_level` (qualité de preuve textuelle explicite de la source,
-- reproduite telle quelle, jamais déduite du grade).
--
-- `population` : 'Adulte' pour R1-R5, 'Enfant' pour R6/R8-R10 — la source
-- structure elle-même le document en deux tableaux séparés par population.
-- `condition_topic` : site anatomique de ponction (seule variable
-- distinguant les recommandations d'un même tableau).
--
-- `specialties` : `anesthesie_reanimation` — sujet transversal (voies
-- veineuses centrales, artérielles et périphériques, tous types de
-- chirurgie/réanimation confondus dans la source), pas de spécialité plus
-- fine dans le seed Annexe B à ce jour.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Recommandations sur l''utilisation de l''échographie lors de la mise en place des accès vasculaires',
  'RFE', 'fr', '2015-01-01',
  'https://sfar.org/recommandations-sur-lutilisation-de-lechographie-lors-de-la-mise-en-place-des-acces-vasculaires/',
  'https://sfar.org/wp-content/uploads/2015/09/2_AFAR_utilisation-de-lechographie-lors-de-la-mise-en-place-des-acces-vasculaires.pdf',
  'GRADE® : qualité des preuves en 4 catégories (haute/modérée/basse/très basse, donnée explicitement par recommandation dans le contenu reproduit) ; formulation finale binaire forte (1+/1-, "il est recommandé") ou faible (2+/2-, "il est probablement recommandé"). 10 recommandations natives (R1-R10) : R7 (voie sous-clavière chez l''enfant) sans grade formulé, aucun essai randomisé disponible pour ce site — non migrée en recommandation, disclosure intégrale en base (voir commentaire de migration). Champ exclu par la source elle-même : échoguidage de l''artère fémorale, et techniques d''écho-repérage/Doppler seul.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/recommandations-sur-lutilisation-de-lechographie-lors-de-la-mise-en-place-des-acces-vasculaires/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/recommandations-sur-lutilisation-de-lechographie-lors-de-la-mise-en-place-des-acces-vasculaires/'
  and s.slug in ('anesthesie_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, evidence_level, condition_topic, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.evidence_level, v.condition_topic, v.population, v.source_section,
  'https://sfar.org/recommandations-sur-lutilisation-de-lechographie-lors-de-la-mise-en-place-des-acces-vasculaires/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000078-R01', 'Veine jugulaire interne (adulte) : il est recommandé d''utiliser une technique échoguidée plutôt que le repérage anatomique. Réduction des échecs de canulation de 86%, des ponctions artérielles de 80%, des hématomes de 78%, du pneumothorax de 90% et possible réduction de l''hémothorax de 94% (IC95% traversant 1) — 1 à 13 études selon le critère, 900 à 2675 patients.', '1+', 'élevée', 'Veine jugulaire interne', 'Adulte', 'Recommandations — accès vasculaires chez l''adulte, R1'),
  ('MG-ANES-000078-R02', 'Veine sous-clavière (adulte) : il est recommandé d''utiliser une technique échoguidée. Réduction des échecs de 94%, des ponctions artérielles de 82%, des hématomes de 77%, du pneumothorax de 78% et de l''hémothorax de 95% (3 études, ~450-500 patients). Qualité élevée malgré l''hétérogénéité et l''imprécision des résultats pour certains critères (études peu nombreuses pour cette voie).', '1+', 'élevée', 'Veine sous-clavière', 'Adulte', 'Recommandations — accès vasculaires chez l''adulte, R2'),
  ('MG-ANES-000078-R03', 'Veine fémorale (adulte) : il est recommandé d''utiliser une technique échoguidée. Réduction des échecs de 85%, des ponctions artérielles de 86% (2 études, 150 patients) et possible réduction des hématomes de 50% (1 étude, 110 patients).', '1+', 'modérée', 'Veine fémorale', 'Adulte', 'Recommandations — accès vasculaires chez l''adulte, R3'),
  ('MG-ANES-000078-R04', 'Artère radiale (adulte) : il est probablement recommandé d''utiliser une technique échoguidée. Réduction des échecs au premier essai de 39% et des hématomes de 83% (2-4 études, 132-281 patients).', '2+', 'basse', 'Artère radiale', 'Adulte', 'Recommandations — accès vasculaires chez l''adulte, R4'),
  ('MG-ANES-000078-R05', 'Veine périphérique a priori difficile (adulte) : il est probablement recommandé d''utiliser une technique échoguidée. Augmentation du taux de succès de 20% (3 études, 154 patients).', '2+', 'modérée', 'Veine périphérique a priori difficile', 'Adulte', 'Recommandations — accès vasculaires chez l''adulte, R5'),
  ('MG-ANES-000078-R06', 'Veine jugulaire interne (enfant) : il est recommandé d''utiliser une technique échoguidée. Réduction des échecs de 69% et des ponctions artérielles de 77% (4 études, 460 patients).', '1+', 'modérée', 'Veine jugulaire interne', 'Enfant', 'Recommandations — accès vasculaires chez l''enfant, R6'),
  ('MG-ANES-000078-R08', 'Veine fémorale (enfant) : il est recommandé d''utiliser une technique échoguidée. Réduction des échecs de 62% et des ponctions artérielles de 65% (3 études, 215 patients). Qualité modérée (risque de biais, imprécision).', '1+', 'modérée', 'Veine fémorale', 'Enfant', 'Recommandations — accès vasculaires chez l''enfant, R8'),
  ('MG-ANES-000078-R09', 'Artère radiale (enfant) : il est probablement recommandé d''utiliser une technique échoguidée. Réduction des échecs au premier essai de 33% et des hématomes de 80% (1-3 études, 118-300 patients).', '2+', 'modérée', 'Artère radiale', 'Enfant', 'Recommandations — accès vasculaires chez l''enfant, R9'),
  ('MG-ANES-000078-R10', 'Veine périphérique a priori difficile (enfant) : il est probablement recommandé d''utiliser une technique échoguidée. Augmentation probable du taux de succès de 20% (3 études, 134 patients).', '2+', 'basse', 'Veine périphérique a priori difficile', 'Enfant', 'Recommandations — accès vasculaires chez l''enfant, R10')
) as v(code, statement, grade, evidence_level, condition_topic, population, source_section)
where d.source_url = 'https://sfar.org/recommandations-sur-lutilisation-de-lechographie-lors-de-la-mise-en-place-des-acces-vasculaires/'
on conflict (recommendation_code) do nothing;
