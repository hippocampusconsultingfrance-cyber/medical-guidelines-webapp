-- Migration : Indications de transfusion de plasmas lyophilisés (PLYO) chez
-- un patient en choc hémorragique ou à risque de transfusion massive en
-- milieu civil (adulte, enfant et nouveau-né) — RPP SFAR, avec SFMU,
-- ADARPEF, CARO, CNCRH, CTSA, EFS, GFRUP, GIHP, SSA. Texte validé par le
-- Comité des Référentiels Cliniques (16/06/2020) et le CA de la SFAR
-- (23/06/2020).
-- Source : rfe-sfar-website/build/content_plyo_transfusion.json (6
-- questions cliniques Q1-Q6, 10 énoncés gradés individuellement).
--
-- ⚠️ DISCLOSURE — GRANULARITÉ DE COMPTAGE (reproduite du contenu construit
-- lui-même) : la source distingue "six questions" cliniques (Q1-Q6) et,
-- séparément, "8 recommandations" (comptées par groupe : R1, R2-adulte,
-- R2-pédiatrie, R3-adulte, R3-pédiatrie, R4, R5, R6), alors que 10 énoncés
-- sont réellement gradés individuellement dans le corps du texte
-- (R2-adulte et R2-pédiatrie comportent chacun 2 sous-énoncés .1/.2 ; R3
-- n'en comporte qu'un chacun). Pas de divergence de fond, seulement de
-- granularité — cette migration retient les 10 énoncés individuellement
-- gradés (une ligne = un énoncé = un grade), cohérent avec le principe du
-- projet "un seul sujet et un seul grade par ligne".
--
-- MÉTHODOLOGIE — format RPP (pas RFE, très faible quantité d'études de
-- forte puissance sur le critère de mortalité selon la source) ; analyse
-- selon GRADE mais formulation uniforme "les experts suggèrent de faire/de
-- ne pas faire" (pas de grade 1+/1-/2+/2- individuel) ; cotation Delphi
-- GRADE grid (échelle 1-9, validée si ≥70% convergent et <20% divergent).
-- Toutes les recommandations sont à Accord fort. `grade` = 'AE' sur les 10
-- lignes, `evidence_level` non renseigné (absent du contenu construit pour
-- ce document).
--
-- Le tableau annexe "Posologies de référence (HAS 2012)" cite les GRADES
-- PROPRES à un document HAS 2012 distinct (ex. "grade C", "accord
-- professionnel" pour le ratio PFC:CGR et la posologie initiale) — ce ne
-- sont PAS des recommandations propres à cette RPP PLYO 2020, mais des
-- citations d'un autre référentiel repris en annexe informative. Migrer
-- ces citations sous le `document_id` de la RPP PLYO 2020 attribuerait à
-- tort leur grade et leur paternité à ce document — elles ne sont donc PAS
-- migrées ici (le document HAS 2012 sur les posologies transfusionnelles
-- pourra faire l'objet d'une migration propre s'il est un jour construit
-- comme fiche séparée).
--
-- SOURCE_URL / PDF_URL : `library_final.json` (recherche "lyophilisé" —
-- exactement 1 correspondance) donne `href` et `direct_pdf_url`, identique
-- à l'"URL source" du contenu construit.
--
-- ⚠️ DISCLOSURE — DIVERGENCE DE DATE : `library_final.json` donne
-- `exact_date` = 2020-12-19 (date de mise en ligne/indexation probable),
-- alors que le contenu construit cite une validation CA SFAR au 23/06/2020
-- — les deux dates sont distinctes et disclosed ; `publication_date`
-- retient 2020-12-19 (date la plus précise disponible dans l'index), pas
-- une déduction de la date de validation.
--
-- `population` : 'Adulte' pour R1-R2.2/R3-adulte/R4-R6 (R4, R5, R6 ne
-- distinguent pas explicitement adulte/enfant dans leur énoncé mais le
-- contexte de la question — HPP, bilan pré-transfusionnel, circuit
-- réglementaire du PSL — est un contexte adulte par défaut dans la
-- structure de la source, sauf R2/R3 qui ont un doublon pédiatrique
-- explicite) ; 'Enfant / nouveau-né' pour les 2 lignes R2-pédiatrie et la
-- ligne R3-pédiatrie.
--
-- `specialties` : `anesthesie_reanimation` (réanimation/urgences/pédiatrie
-- transversales au document, pas de spécialité "hématologie/transfusion"
-- ni "pédiatrie" dédiée retenue au-delà de ce libellé générique dans le
-- seed Annexe B à ce jour).
--
-- ADARPEF, CARO, CNCRH, CTSA, EFS, GFRUP, GIHP, SSA (co-auteurs/
-- participants cités par la source), ne figurent PAS dans le seed Annexe B
-- (`public.societies`) : seules SFAR et SFMU (toutes deux dans le seed)
-- sont liées en `document_societies` ci-dessous.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Indications de transfusion de plasmas lyophilisés (PLYO) chez un patient en choc hémorragique ou à risque de transfusion massive en milieu civil',
  'RPP', 'fr', '2020-12-19',
  'https://sfar.org/indications-de-transfusion-de-plasmas-lyophilises-plyo-chez-un-patient-en-choc-hemorragique-ou-a-risque-de-transfusion-massive-en-milieu-civil/',
  'https://sfar.org/download/indications-de-transfusion-de-plasmas-lyophilises-plyo-chez-un-patient-en-choc-hemorragique-ou-a-risque-de-transfusion-massive-en-milieu-civil-adulte-enfant-et-nouveau-ne/?wpdmdl=30312',
  'Format RPP (pas RFE, très peu d''études de forte puissance sur le critère de mortalité) ; analyse GRADE, formulation uniforme "les experts suggèrent" (pas de grade 1+/1-/2+/2- individuel), cotation Delphi GRADE grid (échelle 1-9, ≥70% convergents et <20% divergents). 10 énoncés gradés individuellement (AE, tous Accord fort), regroupés en "8 recommandations" par la source elle-même selon une granularité différente (R2 et R3 ont chacun un sous-énoncé adulte et un sous-énoncé pédiatrique) — disclosure de cette différence de granularité, pas de divergence de fond, voir commentaire de migration.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/indications-de-transfusion-de-plasmas-lyophilises-plyo-chez-un-patient-en-choc-hemorragique-ou-a-risque-de-transfusion-massive-en-milieu-civil/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'), ('SFMU', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/indications-de-transfusion-de-plasmas-lyophilises-plyo-chez-un-patient-en-choc-hemorragique-ou-a-risque-de-transfusion-massive-en-milieu-civil/'
  and s.slug in ('anesthesie_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.population, v.source_section,
  'https://sfar.org/indications-de-transfusion-de-plasmas-lyophilises-plyo-chez-un-patient-en-choc-hemorragique-ou-a-risque-de-transfusion-massive-en-milieu-civil/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000083-R01', 'Pour une hémorragie sans urgence vitale nécessitant une transfusion de plasma, les experts suggèrent d''utiliser des PFC.', 'AE', 'Choix PLYO vs PFC — hémorragie sans urgence vitale', 'Adulte', 'Q1 — Hémorragie sans urgence vitale, R1'),
  ('MG-ANES-000083-R02', 'Chez l''adulte, au cours des transports médicalisés, transfusion de 2 à 4 PLYO uniquement dans le cadre d''une activation d''un protocole de transfusion massive et lorsque la durée de transport vers le centre hospitalier le plus adapté est > 20 min.', 'AE', 'Transfusion de PLYO en transport médicalisé — indication', 'Adulte', 'Q2 — Transports médicalisés, R2.1 (adulte)'),
  ('MG-ANES-000083-R03', 'Dans cette indication chez l''adulte, transfusion de 2 à 4 PLYO seuls ou avec des concentrés de globules rouges (CGR) si disponibles immédiatement.', 'AE', 'Transfusion de PLYO en transport médicalisé — modalités', 'Adulte', 'Q2 — Transports médicalisés, R2.2 (adulte)'),
  ('MG-ANES-000083-R04', 'Par analogie avec l''adulte, transfusion initiale de 10-15 mL/kg de PLYO chez l''enfant/nourrisson, si hémorragie nécessitant un protocole de transfusion massive, en particulier si le centre hospitalier adapté n''est pas à proximité.', 'AE', 'Transfusion de PLYO en transport médicalisé — indication', 'Enfant / nourrisson', 'Q2 — Transports médicalisés, R2.1 (pédiatrie)'),
  ('MG-ANES-000083-R05', 'Dans cette indication, transfusion initiale de 10-15 mL/kg de PLYO seuls ou avec CGR si disponibles immédiatement.', 'AE', 'Transfusion de PLYO en transport médicalisé — modalités', 'Enfant / nourrisson', 'Q2 — Transports médicalisés, R2.2 (pédiatrie)'),
  ('MG-ANES-000083-R06', 'Chez tout adulte en choc hémorragique nécessitant l''activation d''un protocole de transfusion massive, débuter immédiatement la transfusion de 2 à 4 PLYO, dans un ratio plasma:CGR ≥ 1:2, dans l''attente de plasma décongelé disponible.', 'AE', 'Transfusion intra-hospitalière lors d''un protocole de transfusion massive', 'Adulte', 'Q3 — Transfusion intra-hospitalière, R3 (adulte)'),
  ('MG-ANES-000083-R07', 'Chez tout enfant/nourrisson en choc hémorragique nécessitant l''activation d''un protocole de transfusion massive, débuter immédiatement la transfusion de 10-15 mL/kg de PLYO, dans un ratio plasma:CGR ≥ 1:2, dans l''attente de plasma décongelé disponible.', 'AE', 'Transfusion intra-hospitalière lors d''un protocole de transfusion massive', 'Enfant / nourrisson', 'Q3 — Transfusion intra-hospitalière, R3 (pédiatrie)'),
  ('MG-ANES-000083-R08', 'En cas d''activation d''un protocole de transfusion massive lors d''une HPP et/ou de catastrophe obstétricale avec coagulopathie, recourir à la transfusion de plasma en complément de CGR — le choix entre PLYO ou PFC est guidé par des raisons logistiques, notamment de disponibilité immédiate.', 'AE', 'Transfusion de plasma lors d''une hémorragie du péripartum (HPP)', 'Adulte (obstétrique)', 'Q4 — Hémorragie du péripartum (HPP), R4'),
  ('MG-ANES-000083-R09', 'Réaliser un bilan d''immuno-hématologie pré-transfusionnel (phénotypage érythrocytaire + recherche d''anticorps anti-érythrocytaire, à la pose du premier abord veineux) systématique avant toute transfusion de PSL y compris de PLYO, si aucun résultat n''est disponible immédiatement.', 'AE', 'Bilan immuno-hématologique pré-transfusionnel', 'Adulte', 'Q5 — Examens biologiques et règles transfusionnelles, R5'),
  ('MG-ANES-000083-R10', 'Le PLYO étant un PSL, il répond aux mêmes règles de circuit que les autres PSL (prescription, transport, stockage, traçabilité).', 'AE', 'Circuit réglementaire du PLYO', 'Adulte', 'Q6 — Circuit du PLYO, R6')
) as v(code, statement, grade, condition_topic, population, source_section)
where d.source_url = 'https://sfar.org/indications-de-transfusion-de-plasmas-lyophilises-plyo-chez-un-patient-en-choc-hemorragique-ou-a-risque-de-transfusion-massive-en-milieu-civil/'
on conflict (recommendation_code) do nothing;
