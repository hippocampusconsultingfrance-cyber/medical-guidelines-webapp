-- Migration : Prise en charge des urgences obstétricales en médecine
-- d'urgence — Recommandations de Pratiques Professionnelles (RPP), SFMU
-- (coord. Gilles Bagou), en association avec la SFAR (coord. Frédéric J.
-- Mercier) et le CNGOF (coord. Patrick Rozenberg), 24 experts. Texte
-- validé par le Comité des Référentiels Cliniques SFAR (28/02/2022), le CA
-- SFAR (04/03/2022), le Comité des Référentiels SFMU (26/01/2022), le CA
-- SFMU (31/03/2022) et le Conseil Scientifique du CNGOF. Remplace/actualise
-- la RFE 2010 "Urgences Obstétricales Extrahospitalières" de
-- `library_final.json` (document distinct, non migré séparément ici).
-- Source : rfe-sfar-website/build/content_urgences_obstetricales.json (15
-- recommandations sur 6 champs cliniques + 2 champs formation/sources).
--
-- MÉTHODOLOGIE : RPP, pas RFE — la littérature en médecine d'urgence
-- extrahospitalière étant très limitée pour ces questions, les experts ont
-- choisi de formuler des avis d'experts (« AE », accord fort ≥ 70 %)
-- plutôt que des recommandations gradées GRADE 1/2, SAUF pour les
-- recommandations explicitement reprises telles quelles d'une RFE
-- antérieure (2 cas : R4.2/R4.3, reprises de la RFE pré-éclampsie sévère
-- SFAR/CNGOF 2020, qui conservent leur tag GRADE 1+ d'origine).
--
-- DISCLOSURE MÉTHODOLOGIQUE — TRAITEMENT INCOHÉRENT DES REPRISES,
-- REPRODUIT SANS RÉSOLUTION : la source dispose de 4 recommandations
-- explicitement présentées comme des reprises littérales d'une RFE
-- antérieure (R2.1 de la RPC HPP CNGOF/SFAR 2014 ; R4.1/R4.2/R4.3 de la
-- RFE pré-éclampsie sévère SFAR/CNGOF 2020). Or seules R4.2 et R4.3
-- conservent leur tag GRADE d'origine (1+) ; R2.1 et R4.1, elles, sont
-- re-tagués « AE » par ce document malgré leur origine GRADE — traitement
-- non uniforme des 4 reprises par la source elle-même, reproduit tel quel
-- (`grade` = ce qui est effectivement imprimé dans CE document, pas le
-- grade de la RFE d'origine).
--
-- COMPTAGE — AMBIGUÏTÉ SOURCE-INTERNE DISCLOSED, NON RÉSOLUE : le panneau
-- méthodologique de la source annonce « 15 recommandations + 4
-- recommandations reprises telles quelles de RFE antérieures ». Un
-- inventaire exhaustif de tous les repères Rx.y.z du contenu construit ne
-- trouve que 15 items distinctement numérotés au total (dont R2.1,
-- R4.1, R4.2, R4.3 SONT les 4 "reprises" annoncées, pas des items
-- supplémentaires) — la phrase "15 + 4" pourrait signifier soit "15 au
-- total, dont 4 reprises" (lecture retenue ici, cohérente avec
-- l'inventaire direct), soit "15 natives + 4 reprises = 19 au total"
-- (lecture qui impliquerait 4 lignes manquantes, non identifiables dans le
-- contenu construit) — les 15 lignes réellement présentes dans le JSON de
-- build (l'artefact faisant foi pour ce projet) sont toutes migrées,
-- aucune ligne inventée pour atteindre 19.
--
-- PÉRIMÈTRE — volontairement pas migrés : 2 questions déclarées « Absence
-- de recommandation » PAR LA SOURCE ELLE-MÊME (transfert inter-hospitalier
-- d'une HPP grave ; extraction fœtale préhospitalière en cas d'arrêt
-- cardiaque non traumatique) — disclosure explicite de la source, pas une
-- omission de ma part ; correspond exactement aux "2 questions sans
-- recommandation possible" annoncées. Le tableau de seuils de dose
-- d'exposition fœtale (Champ 6, référence radioprotection) et le panneau
-- "Points clés" sur l'arrêt cardiaque (accompagnant la question 7, sans
-- recommandation) volontairement pas migrés séparément (contenu de
-- référence, pas des recommandations graduées).
--
-- POPULATION : l'intégralité du document concerne une population unique
-- (femmes enceintes en contexte d'urgence extrahospitalière) —
-- `population` laissé NULL sur toutes les lignes plutôt que de répéter une
-- valeur triviale sur 15/15 lignes (même convention que `preeclampsie`/
-- 0038, réservant `population='Grossesse'` aux cas où seul un
-- sous-ensemble d'un document plus large est spécifique à la grossesse).
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SFMU, SFAR ET CNGOF (toutes trois dans le seed Annexe B) liées en
--    document_societies.
-- 2. `publication_date` = date de la dernière validation instance
--    disclosée par la source (CA SFMU, 31/03/2022), plus précise que
--    `library_final.json` qui n'indique que "2022-03".

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge des urgences obstétricales en médecine d''urgence',
  'RPP', 'fr', '2022-03-31',
  'https://sfar.org/prise-en-charge-des-urgences-obstetricales-en-medecine-durgence/',
  'https://sfar.org/download/prise-en-charge-des-urgences-obstetricales-en-medecine-durgence/?wpdmdl=36656',
  'RPP (avis d''experts, cotation GRADE grid, accord fort ≥ 70 %) : AE = avis d''experts. 2 recommandations (R4.2, R4.3) reprises littéralement de la RFE pré-éclampsie sévère SFAR/CNGOF 2020 conservent leur tag GRADE d''origine (1+) ; les 2 autres reprises littérales (R2.1 de la RPC HPP 2014, R4.1 de la RFE 2020) sont re-taguées AE par ce document — traitement non uniforme des reprises par la source elle-même, disclosed. 15 recommandations au total, dont ces 4 reprises ; 2 questions sans recommandation possible (transfert HPP grave, extraction fœtale en arrêt cardiaque).',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-des-urgences-obstetricales-en-medecine-durgence/'
  and s.acronym in ('SFMU', 'SFAR', 'CNGOF') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-des-urgences-obstetricales-en-medecine-durgence/'
  and s.slug in ('gynecologie_obstetrique', 'medecine_d_urgence', 'anesthesie_reanimation', 'radiologie_et_imagerie_medicale')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/prise-en-charge-des-urgences-obstetricales-en-medecine-durgence/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000057-R01', 'Rechercher à l''interrogatoire, pour prédire l''imminence de l''accouchement : multiparité, antécédent d''accouchement rapide ou extrahospitalier, contractions utérines douloureuses et rapprochées, envie de pousser.', 'AE', 'Champ 1 — Accouchement imminent hors structure spécialisée (Réf. R1.1.1)'),
  ('MG-ANES-000057-R02', 'En cas de suspicion d''accouchement imminent en préhospitalier, avec présence médicale habilitée (médecin ou sage-femme) sur place : réaliser un toucher vaginal avant de prendre contact avec l''équipe obstétricale d''accueil, pour orienter la suite de la prise en charge (transfert en maternité ou accouchement sur place).', 'AE', 'Champ 1 — Accouchement imminent hors structure spécialisée (Réf. R1.1.2)'),
  ('MG-ANES-000057-R03', 'En l''absence de supériorité démontrée d''une installation par rapport à une autre : le soignant choisit avec la patiente la position dans laquelle ils sont tous deux le plus à l''aise pour réaliser l''accouchement.', 'AE', 'Champ 1 — Accouchement imminent hors structure spécialisée (Réf. R1.2.1)'),
  ('MG-ANES-000057-R04', 'Avoir la possibilité d''installer rapidement la patiente dans une position compatible avec la manœuvre de Mc Roberts (décubitus dorsal, cuisses hyperfléchies sur le tronc, tête fœtale abaissée dans l''axe ombilico-coccygien) en cas de dystocie des épaules.', 'AE', 'Champ 1 — Accouchement imminent hors structure spécialisée (Réf. R1.2.2)'),
  ('MG-ANES-000057-R05', 'Ne pas réaliser d''épisiotomie systématique en dehors des structures spécialisées dans le seul but de diminuer le risque de lésion du sphincter anal.', 'AE', 'Champ 1 — Accouchement imminent hors structure spécialisée (Réf. R1.3)'),
  ('MG-ANES-000057-R06', 'En l''absence de spécificité liée au contexte hors maternité : appliquer les Recommandations de Pratique Clinique CNGOF/SFAR 2014 sur la prévention de l''HPP — « il est recommandé d''administrer 5 à 10 UI d''oxytocine, en IVL ou en IM, au dégagement des épaules ou en post-partum immédiat pour réduire l''incidence d''hémorragie du post-partum ».', 'AE', 'Champ 2 — Hémorragie du post-partum, reprise RPC CNGOF/SFAR 2014 (Réf. R2.1)'),
  ('MG-ANES-000057-R07', 'Chez une patiente ayant accouché hors structure maternité : ne pas réaliser de délivrance artificielle pour réduire le risque d''HPP, sauf en cas de survenue d''une HPP sévère non contrôlable (dans ce cas, opérateur guidé à distance par un professionnel de l''obstétrique).', 'AE', 'Champ 2 — Hémorragie du post-partum (Réf. R2.2)'),
  ('MG-ANES-000057-R08', 'Chez la patiente présentant une HPP hors structure spécialisée : administrer 1 g d''acide tranexamique en intraveineux, dans un délai maximal de 1 h à 3 h après le début du saignement, pour réduire la morbi-mortalité maternelle.', 'AE', 'Champ 2 — Hémorragie du post-partum (Réf. R2.3)'),
  ('MG-ANES-000057-R09', 'Ne pas médicaliser systématiquement les transferts inter-hospitaliers des femmes enceintes présentant une menace d''accouchement prématuré en dehors d''une structure spécialisée, du fait de l''absence d''impact démontré sur le pronostic materno-fœtal.', 'AE', 'Champ 3 — Menace d''accouchement prématuré (Réf. R3.1)'),
  ('MG-ANES-000057-R10', 'Pré-éclampsie sévère hors structure spécialisée : appliquer la RFE SFAR/CNGOF 2020 (argumentaire R2.1/R2.2 du texte 2020).', 'AE', 'Champ 4 — Pathologies hypertensives gravidiques, reprise RFE SFAR/CNGOF 2020 (Réf. R4.1)'),
  ('MG-ANES-000057-R11', 'Pré-éclampsie sévère hors structure spécialisée : appliquer la RFE SFAR/CNGOF 2020 — « R2.1 [2020] – Il est recommandé d''administrer systématiquement un traitement antihypertenseur chez les patientes avec une pré-éclampsie sévère présentant une PAS ≥ 160 mmHg et/ou une PAD ≥ 110 mmHg au repos et persistant durant plus de 15 minutes, et de maintenir la pression artérielle en dessous de ces seuils, pour réduire la survenue de complications maternelles, fœtales et néonatales sévères ».', '1+', 'Champ 4 — Pathologies hypertensives gravidiques, reprise RFE SFAR/CNGOF 2020 R2.1 (Réf. R4.2)'),
  ('MG-ANES-000057-R12', 'Éclampsie hors structure spécialisée : appliquer la RFE SFAR/CNGOF 2020 — « R2.8 [2020] – Il est recommandé d''administrer en anténatal du sulfate de magnésium aux femmes avec une pré-éclampsie sévère avec au moins un signe clinique de gravité afin de réduire le risque de survenue d''une éclampsie » et « R2.12 [2020] – Il est recommandé d''administrer du sulfate de magnésium en première intention chez des femmes ayant eu une crise d''éclampsie afin de réduire le risque de mortalité maternelle et le risque de récidive d''éclampsie ».', '1+', 'Champ 4 — Pathologies hypertensives gravidiques, reprise RFE SFAR/CNGOF 2020 R2.8/R2.12 (Réf. R4.3)'),
  ('MG-ANES-000057-R13', 'Faire réaliser systématiquement un examen obstétrical par un obstétricien ou une sage-femme dans les suites immédiates d''un traumatisme thoraco-abdominal, même mineur, survenu chez une femme enceinte de plus de 20 SA, à la recherche de signes prédictifs de morbi-mortalité fœtale.', 'AE', 'Champ 5 — Traumatisme et grossesse (Réf. R5.1)'),
  ('MG-ANES-000057-R14', 'Réaliser une tomodensitométrie thoraco-abdomino-pelvienne (avec ou sans injection de produit de contraste), dès lors qu''elle est indiquée sur le plan maternel ; la balance bénéfice/risque de l''examen doit prévaloir à la décision de sa réalisation. Ne pas éviter l''examen au seul motif que la patiente est enceinte.', 'AE', 'Champ 6 — Imagerie et grossesse (Réf. R6.1)'),
  ('MG-ANES-000057-R15', 'Former les équipes de médecine d''urgence aux urgences obstétricales via la simulation, incluant les situations difficiles (dystocies mécaniques et dystocies dynamiques), pour améliorer l''apprentissage et le maintien des compétences techniques des professionnels, et pour pouvoir en étudier ensuite l''impact sur la morbi-mortalité materno-fœtale.', 'AE', 'Champ 8 — Formation aux urgences obstétricales (Réf. R8.1)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-des-urgences-obstetricales-en-medecine-durgence/'
on conflict (recommendation_code) do nothing;
