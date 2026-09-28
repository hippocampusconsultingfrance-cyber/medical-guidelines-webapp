-- Migration : Prise en charge de l'Hyperthermie Maligne — Recommandations de Pratiques
-- Professionnelles (RPP), SFAR, 2019 (texte validé par le Comité des Référentiels Cliniques
-- SFAR le 30/05/2018, CA SFAR le 21/06/2018). Actualise et REMPLACE les Recommandations
-- d'Experts SFAR de septembre 2013 sur le même sujet (`library_final.json` marque
-- correctement l'entrée 2013 `"status": "abrogé"`).
-- Source : rfe-sfar-website/build/content_hyperthermie_maligne.json.
--
-- MÉTHODOLOGIE : RPP, avis d'experts — chip unique « AE » imprimé pour chaque
-- recommandation, aucun autre système de cotation dans ce document. `grade = 'AE'`,
-- `evidence_level` laissé NULL.
--
-- COMPTAGE — DIVERGENCE DISCLOSÉE, NON RÉSOLUE SILENCIEUSEMENT (principe 1.5 du projet) :
-- le panneau d'introduction du contenu construit annonce « 12 recommandations (avis
-- d'experts) réparties en 5 questions ». Un comptage exhaustif direct des repères Rx.y
-- imprimés dans le JSON source (vérifié par un parcours programmatique de l'intégralité de
-- l'arborescence, pas seulement des tableaux visibles) donne 11 recommandations : R1.1-R1.3
-- (3), R2.1 (1), R3.1 (1), R4.1-R4.2 (2), R5.1-R5.4 (4) = 11. Aucune 12e recommandation
-- numérotée n'existe nulle part dans le contenu construit. Les deux chiffres (12 annoncé,
-- 11 trouvé) sont disclosés ici tels quels ; aucune ligne n'a été inventée pour atteindre 12.
--
-- PÉRIMÈTRE — volontairement pas migrés (référence/algorithme non gradé individuellement,
-- cohérent avec le principe déjà appliqué à plusieurs reprises dans ce corpus, ex.
-- 0018_migrate_curares.sql pour ses 2 algorithmes de décurarisation) :
-- 1. Le tableau "Situation | Conduite à tenir" (Figure 1, reconstruction d'un arbre
--    décisionnel qui est une pure image sans calque de texte extractible dans la source,
--    reformulée par le contenu construit lui-même "pour la lisibilité" — donc déjà une
--    paraphrase éditoriale, pas une citation verbatim d'un texte source individuellement
--    gradé). R1.1 elle-même ("dépister... selon l'arbre décisionnel de la Figure 1") est
--    migrée comme recommandation ; le contenu détaillé de la figure ne l'est pas,
--    contrairement au cas d'`eclsa`/0019 où l'exclusion de l'algorithme aurait réduit la
--    migration à zéro recommandation — ici 11 recommandations individuellement graduées
--    existent déjà indépendamment de cette figure.
-- 2. Le protocole "Annexe 2 — Affiche : diagnostic et traitement de la crise" (15 étapes) et
--    le protocole "Reconstitution du dantrolène" (7 étapes) — tous deux transcrits depuis
--    des affiches-photos (pages 3 et 11 du document source, pure image sans calque de texte,
--    vérifié visuellement par le contenu construit) et SANS chip de cotation individuelle
--    (colonnes "Étape | Action", pas "Réf. | Recommandation | Grade") : protocoles
--    opérationnels détaillés, pas des recommandations graduées une à une par le jury RPP.
--    Contenu cliniquement critique (posologie du dantrolène, séquence de traitement de la
--    crise) mais de nature différente d'une recommandation atomique au sens de ce modèle de
--    données — cohérent avec l'exclusion des algorithmes de décurarisation de curares/0018.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Écart de comptage "12 annoncé / 11 trouvé" — voir ci-dessus, à trancher par un
--    relecteur humain disposant du texte intégral (peut-être une recommandation
--    supplémentaire existe dans le texte long/argumentaire, non repris par cette fiche).
-- 2. Seule la SFAR est société organisatrice de ce RPP (pas de co-signataires multiples) —
--    liée seule en document_societies.
-- 3. Coordonnées des centres experts français « Hyperthermie Maligne » (Lille, Robert Debré,
--    Grenoble, Marseille) datées 2018 par la source elle-même, qui invite à vérifier sur
--    sfar.org en cas de doute — non reproduites dans les recommandations elles-mêmes
--    (contenu informatif, pas une recommandation graduée).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge de l''Hyperthermie Maligne',
  'RPP', 'fr', '2019-09-19',
  'https://sfar.org/prise-en-charge-de-lhyperthermie-maligne/',
  'https://sfar.org/download/rpp-hyperthermie-maligne/?wpdmdl=24495',
  'Recommandations de Pratiques Professionnelles (RPP), avis d''experts. Chip unique « AE » (avis d''experts) pour chaque recommandation, aucune autre échelle de cotation dans ce document. Actualise et remplace les Recommandations d''Experts SFAR de septembre 2013 (désormais abrogées) sur le même sujet.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-de-lhyperthermie-maligne/'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-de-lhyperthermie-maligne/'
  and s.slug in ('anesthesie_reanimation', 'genetique_medicale', 'medecine_intensive_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/prise-en-charge-de-lhyperthermie-maligne/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000024-R01', 'Dépister les patients à risque d''hyperthermie maligne en consultation d''anesthésie selon l''arbre décisionnel de la Figure 1.', 'AE', 'Q1 — Dépistage des patients à risque en consultation d''anesthésie (Réf. R1.1)'),
  ('MG-ANES-000024-R02', 'Pour tout patient présentant une notion d''antécédent d''HM au cours d''une précédente anesthésie (personnel ou familial), non encore exploré : contacter l''un des centres experts « Hyperthermie Maligne » pour préciser le risque réel par des investigations appropriées.', 'AE', 'Q1 — Dépistage des patients à risque en consultation d''anesthésie (Réf. R1.2)'),
  ('MG-ANES-000024-R03', 'En dehors de l''anesthésie, l''évaluation du risque HM chez les patients à risque et leur famille, et la décision d''investigations complémentaires, doivent faire l''objet d''une réflexion pluridisciplinaire (anesthésiste, expert HM, généticien, neurologue, patient).', 'AE', 'Q1 — Dépistage des patients à risque en consultation d''anesthésie (Réf. R1.3)'),
  ('MG-ANES-000024-R04', 'Préciser le diagnostic de sensibilité à l''HM chez les sujets à risque par des « In Vitro Contracture Tests » (IVCT) sur biopsie musculaire, ou par analyse génétique de l''ADN extrait du sang périphérique.', 'AE', 'Q2 — Diagnostic de sensibilité à l''hyperthermie maligne (Réf. R2.1)'),
  ('MG-ANES-000024-R05', 'Respecter trois principes absolus chez le patient à risque d''HM : (1) exclure tous les agents anesthésiques volatils halogénés ainsi que le curare dépolarisant (suxaméthonium/succinylcholine, Célocurine®) ; (2) disposer d''un monitorage de la capnographie et de la température centrale ; (3) vérifier avant l''induction la disponibilité du protocole (affiche diagnostic/traitement, fiche de reconstitution du dantrolène) et le libre accès au dantrolène injectable.', 'AE', 'Q3 — Conduite de l''anesthésie chez un patient à risque d''HM (Réf. R3.1)'),
  ('MG-ANES-000024-R06', 'Disposer dans tous les lieux où sont réalisées des anesthésies générales d''une affiche « résumé » décrivant le diagnostic et le traitement de la crise d''HM.', 'AE', 'Q4 — Affiche résumé (diagnostic et traitement) (Réf. R4.1)'),
  ('MG-ANES-000024-R07', 'L''affiche « résumé » doit comporter des informations claires et précises sur l''accès immédiat au stock de dantrolène et sur la procédure de reconstitution pour injection IV.', 'AE', 'Q4 — Affiche résumé (diagnostic et traitement) (Réf. R4.2)'),
  ('MG-ANES-000024-R08', 'Colliger dans un document tous les éléments en faveur du diagnostic (feuille d''anesthésie, cinétique des signes par rapport aux médicaments déclenchants, paramètres de surveillance, résultats biologiques) — capital pour la confirmation diagnostique ultérieure.', 'AE', 'Q5 — Que faire après une crise d''hyperthermie maligne ? (Réf. R5.1)'),
  ('MG-ANES-000024-R09', 'Réaliser un dosage des CPK à 12h et 24h après la crise, répété jusqu''à normalisation en cas de positivité. Un taux normal est un argument important contre le diagnostic ; un taux qui reste élevé plusieurs jours doit faire rechercher une myopathie sous-jacente.', 'AE', 'Q5 — Que faire après une crise d''hyperthermie maligne ? (Réf. R5.2)'),
  ('MG-ANES-000024-R10', 'Informer systématiquement le patient et sa famille de la suspicion clinique, remettre un document relatant le protocole anesthésique et les signes évocateurs, et un document sur les conséquences du diagnostic (précautions futures, risque familial autosomique dominant).', 'AE', 'Q5 — Que faire après une crise d''hyperthermie maligne ? (Réf. R5.3)'),
  ('MG-ANES-000024-R11', 'Prendre contact le plus rapidement possible avec un centre expert HM pour confirmer/infirmer le diagnostic et organiser les investigations de sensibilité HM.', 'AE', 'Q5 — Que faire après une crise d''hyperthermie maligne ? (Réf. R5.4)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-de-lhyperthermie-maligne/'
on conflict (recommendation_code) do nothing;
