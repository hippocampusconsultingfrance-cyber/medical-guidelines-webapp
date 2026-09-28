-- Migration : Stratégie du remplissage vasculaire périopératoire — RFE
-- SFAR, rédigée en collaboration avec l'Adarpef, validée par le CA de la
-- SFAR le 19/10/2012, publiée Ann Fr Anesth Réanim 32 (2013) 454-462.
-- Distincte de `remplissage`/0039 ("Choix du soluté pour le remplissage
-- vasculaire en situation critique", RFE 2021 — sujet et source_url
-- différents, aucune collision).
-- Source : rfe-sfar-website/build/content_remplissage_perioperatoire.json
-- (15 recommandations numérotées R1-R15, chacune déjà atomique).
--
-- MÉTHODOLOGIE — GRADE standard : qualité des preuves en 4 catégories
-- (Haute/Modérée/Basse/Très basse, non détaillée par recommandation dans
-- le contenu reproduit), force binaire forte (1+/1-, "il faut faire/ne pas
-- faire") ou faible (2+/2-, "il est possible de faire/ne pas faire"),
-- déterminée par vote Delphi ; avis d'experts (AE) en l'absence
-- d'évaluation quantifiée de l'effet, même formulation que les grades
-- GRADE. `evidence_level` non renseigné (absent du contenu construit pour
-- ce document).
--
-- ⚠️ DISCLOSURE — DIVERGENCE INTERNE À LA SOURCE (reproduite du contenu
-- construit lui-même) : le résumé de la source module la posologie de R4
-- selon la durée du geste (15 mL/kg gestes courts, 20-30 mL/kg gestes de
-- 1-2h), alors que le texte de la recommandation R4 elle-même donne un
-- intervalle unique "15 à 30 mL/kg" sans distinction de durée — les deux
-- formulations sont disclosed, le texte de la recommandation R4 elle-même
-- (pas le résumé) est retenu comme `statement` ci-dessous, conformément au
-- principe "la recommandation numérotée fait foi, pas son résumé".
--
-- La Figure 1 (algorithme de titration du remplissage guidé par le VES,
-- transcrite depuis un rendu visuel du PDF) est de nature procédurale/
-- descriptive (un arbre de décision, pas un énoncé "il faut faire X" isolé
-- avec son propre grade) — non migrée comme ligne `recommendations`
-- distincte ; son contenu reste rattaché à R1-R3 (titration sur le VES)
-- dans la fiche de synthèse HTML.
--
-- SOURCE_URL / PDF_URL : `library_final.json` (recherche "Stratégie du
-- remplissage vasculaire périopératoire" — exactement 1 correspondance)
-- donne `href` et `direct_pdf_url`, identique à l'"URL source" du contenu
-- construit. `exact_date` = "2012" (année seule) — `publication_date`
-- retient 2012-10-19 (date de validation CA SFAR citée par le contenu
-- construit, plus précise), distincte de la date de publication en revue
-- (2013), disclosed séparément, non confondue.
--
-- `specialties` : `anesthesie_reanimation` uniquement (R15 pédiatrie
-- rattachée au même document, pas de spécialité pédiatrie dédiée dans le
-- seed Annexe B au-delà de ce libellé générique).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Stratégie du remplissage vasculaire périopératoire',
  'RFE', 'fr', '2012-10-19',
  'https://sfar.org/strategie-du-remplissage-vasculaire-perioperatoire-2/',
  'https://sfar.org/wp-content/uploads/2015/09/2a_AFAR_FRANCAIS_Strategie-du-remplissage-vasculaire-perioperatoire.pdf',
  'GRADE standard : qualité des preuves en 4 catégories (non détaillée par recommandation dans le contenu reproduit), force binaire forte (1+/1-) ou faible (2+/2-), déterminée par vote Delphi ; avis d''experts (AE) en l''absence d''évaluation quantifiée de l''effet. 15 recommandations reproduites (R1-R15). Divergence interne disclosed sur R4 (résumé "15/20-30 mL/kg selon durée" vs texte de la recommandation "15 à 30 mL/kg" sans distinction) — le texte de la recommandation retenu comme statement.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/strategie-du-remplissage-vasculaire-perioperatoire-2/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/strategie-du-remplissage-vasculaire-perioperatoire-2/'
  and s.slug in ('anesthesie_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.population, v.source_section,
  'https://sfar.org/strategie-du-remplissage-vasculaire-perioperatoire-2/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000085-R01', 'Chez les patients chirurgicaux "à haut risque", il est recommandé de titrer le remplissage vasculaire peropératoire en se guidant sur une mesure du VES, pour réduire la morbidité postopératoire, la durée de séjour hospitalier et le délai de reprise d''une alimentation orale des patients de chirurgie digestive.', '1+', 'Titration du remplissage sur le volume d''éjection systolique (VES)', 'Chirurgie à haut risque', 'Recommandations 1 à 3 — Titration du remplissage sur le VES, R1'),
  ('MG-ANES-000085-R02', 'Il est recommandé d''interrompre le remplissage en l''absence d''augmentation du VES.', '1+', 'Titration du remplissage sur le VES — critère d''arrêt', null, 'Recommandations 1 à 3 — Titration du remplissage sur le VES, R2'),
  ('MG-ANES-000085-R03', 'Il est recommandé de réévaluer régulièrement le VES et son augmentation (ou non) en réponse à une épreuve de remplissage, en particulier lors des séquences d''instabilité hémodynamique.', '1+', 'Titration du remplissage sur le VES — réévaluation régulière', null, 'Recommandations 1 à 3 — Titration du remplissage sur le VES, R3'),
  ('MG-ANES-000085-R04', 'Au cours de la chirurgie "mineure" (durée < 2h, y compris ambulatoire), pour diminuer l''incidence des nausées/vomissements et le recours aux antiémétiques, il est probablement recommandé d''administrer de 15 à 30 mL/kg de cristalloïdes.', '2+', 'Remplissage en chirurgie mineure — prévention des NVPO', 'Chirurgie mineure (< 2h, y compris ambulatoire)', 'Recommandations 4 à 8 — Chirurgie mineure et obstétrique, R4'),
  ('MG-ANES-000085-R05', 'Il n''est pas recommandé d''utiliser un remplissage vasculaire systématique au cours du travail pour limiter le risque d''hypotension lors de l''installation d''une analgésie péridurale.', '1-', 'Remplissage systématique lors de l''analgésie péridurale obstétricale', 'Obstétrique — travail', 'Recommandations 4 à 8 — Chirurgie mineure et obstétrique, R5'),
  ('MG-ANES-000085-R06', 'Il n''est pas recommandé d''effectuer un préremplissage par des cristalloïdes pour une rachianesthésie pour césarienne.', '1-', 'Préremplissage avant rachianesthésie pour césarienne', 'Obstétrique — césarienne', 'Recommandations 4 à 8 — Chirurgie mineure et obstétrique, R6'),
  ('MG-ANES-000085-R07', 'Afin d''éviter/limiter les risques maternels et fœtaux liés à l''hypotension après rachianesthésie, il est recommandé d''associer un coremplissage par cristalloïdes avec des vasoconstricteurs (phényléphrine, éventuellement associée à l''éphédrine).', '1+', 'Prévention de l''hypotension post-rachianesthésie — coremplissage et vasoconstricteurs', 'Obstétrique — rachianesthésie', 'Recommandations 4 à 8 — Chirurgie mineure et obstétrique, R7'),
  ('MG-ANES-000085-R08', 'Il n''est pas recommandé d''utiliser un colloïde (HEA) chez une patiente prééclamptique en dehors d''un état de choc hypovolémique/hémorragique.', 'AE', 'Colloïdes chez la patiente prééclamptique', 'Obstétrique — prééclampsie', 'Recommandations 4 à 8 — Chirurgie mineure et obstétrique, R8'),
  ('MG-ANES-000085-R09', 'Il n''est pas recommandé d''exclure les colloïdes chez un patient allergique à une substance autre que le colloïde lui-même.', 'AE', 'Colloïdes chez le patient allergique à une autre substance', null, 'Recommandations 9 à 15 — Situations particulières, R9'),
  ('MG-ANES-000085-R10', 'Chez un opéré ayant présenté une anaphylaxie documentée ou suspectée à un colloïde (gélatine fluide modifiée ou HEA), il est recommandé d''utiliser, si nécessaire, un colloïde de l''autre classe.', 'AE', 'Choix du colloïde après anaphylaxie documentée ou suspectée', null, 'Recommandations 9 à 15 — Situations particulières, R10'),
  ('MG-ANES-000085-R11', 'En présence d''une altération de la fonction rénale (notamment d''origine septique), il est probablement recommandé d''éviter les HEA.', '2+', 'HEA et altération de la fonction rénale', null, 'Recommandations 9 à 15 — Situations particulières, R11'),
  ('MG-ANES-000085-R12', 'Il est probablement recommandé d''utiliser les cristalloïdes pour le remplissage vasculaire des donneurs de reins en état de mort encéphalique.', 'AE', 'Remplissage des donneurs de reins en état de mort encéphalique', 'Donneur d''organes en état de mort encéphalique', 'Recommandations 9 à 15 — Situations particulières, R12'),
  ('MG-ANES-000085-R13', 'Il est recommandé de respecter les posologies maximales des HEA (33 mL/kg/24h le 1er jour, 20 mL/kg/24h les 2 jours suivants) et de ne pas les utiliser chez les patients ayant des troubles de l''hémostase.', '1+', 'Posologies maximales des HEA et contre-indication hémostase', null, 'Recommandations 9 à 15 — Situations particulières, R13'),
  ('MG-ANES-000085-R14', 'Chez le patient cérébrolésé, il est recommandé de ne pas utiliser de solutés hypotoniques.', 'AE', 'Solutés hypotoniques chez le patient cérébrolésé', 'Patient cérébrolésé', 'Recommandations 9 à 15 — Situations particulières, R14'),
  ('MG-ANES-000085-R15', 'Chez l''enfant et le nouveau-né sans comorbidité, il est recommandé d''assurer un apport de base hydroélectrolytique et glucidique selon la règle des "4-2-1", avec solution saline isotonique glucosée à 1% (enfant/nourrisson) ou 10% (nouveau-né).', 'AE', 'Apport de base hydroélectrolytique pédiatrique — règle des 4-2-1', 'Enfant et nouveau-né sans comorbidité', 'Recommandations 9 à 15 — Situations particulières, R15')
) as v(code, statement, grade, condition_topic, population, source_section)
where d.source_url = 'https://sfar.org/strategie-du-remplissage-vasculaire-perioperatoire-2/'
on conflict (recommendation_code) do nothing;
