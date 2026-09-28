-- Migration : Choix du soluté pour le remplissage vasculaire en situation
-- critique — Recommandations Formalisées d'Experts communes SFAR-SFMU.
-- Comité de 24 experts, coordination O. Joannes-Boyau (SFAR), P. Le Conte
-- (SFMU). Texte validé par le Comité des Référentiels Cliniques SFAR le
-- 10/05/2021, le CA SFAR le 19/05/2021, le CA SFMU le 29/06/2021. Source :
-- rfe-sfar-website/build/content_remplissage.json (9 recommandations,
-- 4 champs cliniques : sepsis/choc septique, choc hémorragique,
-- cérébrolésés, péripartum).
--
-- MÉTHODOLOGIE : GRADE (force forte 1+/1-, force faible 2+/2-, avis
-- d'experts AE), format PICO. `grade` reproduit tel quel le chip source.
-- `evidence_level` laissé NULL. Champ d'application : choix du TYPE de
-- soluté uniquement — ce référentiel ne traite ni de la quantité à
-- administrer, ni des modalités d'administration (disclosure de portée,
-- pas une omission de ma part).
--
-- COMPTAGE — EXACTEMENT RECONCILIÉ : le résumé officiel annonce "9
-- recommandations : 2 GRADE1 (+/-), 6 GRADE2 (+/-), 1 avis d'experts" et
-- "pour 2 questions, aucune recommandation n'a pu être formulée". Un
-- inventaire direct tag par tag des 9 lignes R1.1-R3.2 confirme
-- exactement 2 GRADE1 (R1.1 : 1-, R2.3 : 1-), 6 GRADE2 (R1.3 : 2-, R1.4 :
-- 2+, R2.1 : 2-, R2.2 : 2+, R3.1 : 2-, R3.2 : 2+) et 1 AE (R1.2) — aucun
-- écart, contrairement à plusieurs fiches précédentes de ce corpus. Les 2
-- questions « absence de recommandation » (albumine en 2e intention/Champ
-- 1, choix du soluté en péripartum/Champ 4) sont également exactement
-- reconciliées.
--
-- INCOHÉRENCE INTERNE À LA SOURCE DISCLOSÉE (déjà relevée par le contenu
-- construit lui-même, reproduite ici sans être résolue) : le résumé
-- officiel de la RFE mentionne « trois protocoles de prise en charge »
-- élaborés par les experts. Après vérification visuelle exhaustive des 28
-- pages du texte court source, ces protocoles n'y apparaissent ni sous
-- forme de texte ni sous forme de figure — non reproduits ici, se référer
-- au texte long / aux annexes de la RFE (hors périmètre du contenu
-- construit disponible pour cette migration).
--
-- PÉRIMÈTRE — volontairement pas migrés : le Tableau 1 (composition
-- ionique comparée de 5 solutés — donnée de référence pharmacologique,
-- pas une recommandation graduée) ; le panneau « Exception SSH » (Champ 2
-- — un bolus de sérum salé hypertonique reste indiqué en cas de choc
-- hémorragique associé à un traumatisme crânien grave avec signe de
-- focalisation, nuance clinique importante à R2.3, mais SANS chip de
-- grade propre — disclosure plutôt qu'un grade inventé, contrairement à
-- R2.3 qui, elle, est individuellement cotée '1-' pour le cas général).
-- « Périmètre exclu » de la RFE elle-même (cirrhose, pancréatite aiguë,
-- SDRA, insuffisance rénale, population pédiatrique) — disclosure de
-- portée du document, rien à migrer.
--
-- POPULATION : les 4 « champs » de cette RFE sont des contextes cliniques
-- (sepsis, hémorragie, cérébrolésion, péripartum), pas des sous-groupes
-- démographiques au sens des autres fiches de ce corpus (ex. Pédiatrie) —
-- `population` laissé NULL, le contexte clinique de chaque recommandation
-- restant identifiable via `source_section`.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SFAR et SFMU (toutes deux dans le seed Annexe B) liées en
--    document_societies.
-- 2. Un document distinct, "Stratégie du remplissage vasculaire
--    périopératoire" (SFAR/Afar, 2012, hors soins critiques), partage le
--    même thème général mais un périmètre et un href différents —
--    NON confondu avec cette migration-ci (source_url vérifié).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Choix du soluté pour le remplissage vasculaire en situation critique',
  'RFE', 'fr', '2021-09-25',
  'https://sfar.org/choix-du-solute-pour-le-remplissage-vasculaire-en-situation-critique/',
  'https://sfar.org/download/choix-du-solute-pour-le-remplissage-vasculaire-en-situation-critique/?wpdmdl=35406',
  'GRADE® : force forte (1+ recommandé / 1- non recommandé) ou faible (2+ probablement recommandé / 2- probablement non recommandé) ; avis d''experts (AE). Comptage source ("9 recommandations : 2 GRADE1, 6 GRADE2, 1 AE ; 2 questions sans recommandation possible") exactement reconcilié par tally direct, aucun écart.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/choix-du-solute-pour-le-remplissage-vasculaire-en-situation-critique/'
  and s.acronym in ('SFAR', 'SFMU') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/choix-du-solute-pour-le-remplissage-vasculaire-en-situation-critique/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'medecine_d_urgence')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/choix-du-solute-pour-le-remplissage-vasculaire-en-situation-critique/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000039-R01', 'Il n''est pas recommandé d''utiliser les hydroxyéthylamidons pour le remplissage vasculaire au cours du sepsis ou du choc septique, comparativement aux cristalloïdes non hypertoniques, pour diminuer la mortalité et/ou le recours à l''épuration extrarénale.', '1-', 'Champ 1 — Sepsis/choc septique, colloïdes vs cristalloïdes (Réf. R1.1)'),
  ('MG-ANES-000039-R02', 'Les experts suggèrent de ne pas utiliser les gélatines pour le remplissage vasculaire au cours du sepsis ou du choc septique, comparativement aux cristalloïdes non hypertoniques, pour diminuer la mortalité et/ou le recours à l''épuration extrarénale.', 'AE', 'Champ 1 — Sepsis/choc septique, colloïdes vs cristalloïdes (Réf. R1.2)'),
  ('MG-ANES-000039-R03', 'Il n''est probablement pas recommandé d''utiliser en première intention de l''albumine au cours du sepsis ou du choc septique, comparativement aux cristalloïdes, pour diminuer la mortalité ou le recours à l''épuration extrarénale.', '2-', 'Champ 1 — Sepsis/choc septique, colloïdes vs cristalloïdes (Réf. R1.3)'),
  ('MG-ANES-000039-R04', 'Chez les patients atteints de sepsis ou de choc septique, il est probablement recommandé d''utiliser des solutés cristalloïdes balancés pour le remplissage vasculaire pour diminuer la mortalité et/ou la survenue d''évènements indésirables rénaux.', '2+', 'Champ 1 (suite) — Choix du type de cristalloïde (Réf. R1.4)'),
  ('MG-ANES-000039-R05', 'Chez les patients en situation de choc hémorragique, quel que soit le contexte, il n''est probablement pas recommandé d''utiliser un colloïde comme soluté de remplissage vasculaire, comparativement aux cristalloïdes non hypertoniques, pour diminuer la mortalité et/ou le recours à l''épuration extrarénale.', '2-', 'Champ 2 — Choc hémorragique, colloïdes vs cristalloïdes (Réf. R2.1)'),
  ('MG-ANES-000039-R06', 'Chez les patients en situation de choc hémorragique, il est probablement recommandé d''utiliser des solutés cristalloïdes balancés en première intention plutôt que du NaCl 0,9 % comme soluté de remplissage vasculaire pour diminuer la mortalité et/ou les évènements indésirables rénaux.', '2+', 'Champ 2 (suite) — Choix du type de cristalloïde (Réf. R2.2)'),
  ('MG-ANES-000039-R07', 'Chez les patients en situation de choc hémorragique, il n''est pas recommandé d''administrer un soluté salé hypertonique à 3 % ou 7,5 % en première intention comme soluté de remplissage vasculaire pour diminuer la mortalité.', '1-', 'Champ 2 (suite) — Choix du type de cristalloïde (Réf. R2.3)'),
  ('MG-ANES-000039-R08', 'Il n''est probablement pas recommandé d''utiliser des colloïdes, en particulier l''albumine, comme soluté de remplissage chez les patients cérébrolésés pour diminuer la mortalité et/ou améliorer le pronostic neurologique.', '2-', 'Champ 3 — Patients cérébrolésés (Réf. R3.1)'),
  ('MG-ANES-000039-R09', 'Il est probablement recommandé d''utiliser des cristalloïdes isotoniques, en première intention, comme soluté de remplissage vasculaire chez les patients cérébrolésés pour diminuer la mortalité et/ou améliorer le pronostic neurologique.', '2+', 'Champ 3 — Patients cérébrolésés (Réf. R3.2)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/choix-du-solute-pour-le-remplissage-vasculaire-en-situation-critique/'
on conflict (recommendation_code) do nothing;
