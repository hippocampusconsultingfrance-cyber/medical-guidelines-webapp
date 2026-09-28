-- Migration : Prise en charge du brûlé grave à la phase aiguë chez l'adulte
-- et l'enfant — RPP SFAR, en association avec SFB/SFMU/Adarpef. Texte
-- validé par le Comité des Référentiels Cliniques SFAR (15/05/2019) et le
-- CA SFAR (24/05/2019). Champ : brûlures thermiques uniquement — brûlures
-- électriques et chimiques explicitement hors champ.
-- Source : rfe-sfar-website/build/content_brule_grave.json (6 champs —
-- régulation/admission R1.1-R1.2.4, réanimation hémodynamique
-- R2.1.1-R2.4, voies aériennes/inhalation R3.1.1-R3.4, anesthésie-analgésie
-- R4.1.1-R4.1.3, traitement local R5.1.1-R5.3, autres traitements
-- R6.1-R6.2 — 24 énoncés numérotés, chacun déjà atomique).
--
-- ⚠️ DISCLOSURE — ANNEXES ABSENTES DU PDF SOURCE (reproduite du contenu
-- construit lui-même, vérification exhaustive documentée) : le texte cite
-- 10 annexes (Lund & Browder, formules/algorithmes de remplissage vasculaire
-- adulte/enfant, algorithme d'intubation, posologie hydroxocobalamine
-- détaillée, choix des pansements, formules nutritionnelles de Toronto/
-- Schofield) — AUCUNE de ces annexes n'est présente dans le fichier PDF
-- téléchargé (0 image sur 38 pages hors logo, vérifié par recherche
-- textuelle et rendu visuel à 170dpi de 9 pages cibles). Le texte des 24
-- recommandations elles-mêmes reste intégralement couvert ; les formules/
-- seuils numériques cités dans le corps du texte (ex. 20 mL/kg, SCB ≥20%/
-- ≥10%) sont repris tels quels, mais les tableaux/algorithmes visuels des
-- annexes ne sont pas reconstitués.
--
-- MÉTHODOLOGIE — RPP (pas RFE, trop peu d'études de puissance suffisante
-- sur le critère mortalité selon la source) : analyse de la littérature
-- selon GRADE mais formulation uniforme "les experts suggèrent de faire/de
-- ne pas faire", cotation Delphi (échelle 1-9, validée si ≥70% convergent
-- et <20% divergent). Aucun grade 1+/1-/2+/2- individuel — seul un accord
-- global (fort/faible) est coté ; les 24 recommandations sont toutes à
-- Accord fort (vérifié par la source : aucune occurrence d'"Accord
-- faible"). `grade` = 'AE' sur les 24 lignes, `evidence_level` non
-- renseigné (absent du contenu construit pour ce document).
--
-- ⚠️ CORRECTIF POST-COMMIT (2026-09-19, même session) : la version
-- initialement committée affirmait à tort que SFB, SFMU et Adarpef
-- étaient toutes absentes du seed Annexe B et ne liait que SFAR.
-- Vérification exhaustive de la liste complète du seed (`grep` intégral de
-- `schema_v2.sql`, pas la version tronquée utilisée par erreur au premier
-- passage) : **SFMU EST bien présente dans le seed** (`('SFMU', 'France')`).
-- SFB et Adarpef restent, elles, correctement absentes. SFMU est donc
-- ajoutée ci-dessous en `document_societies`, aux côtés de SFAR.
--
-- SOURCE_URL / PDF_URL : `library_final.json` (recherche "brûlé grave" —
-- exactement 1 correspondance) donne `href` et `direct_pdf_url`, identique
-- à l'"URL source" du contenu construit. `exact_date` = 2019-09-21.
--
-- `population` : 'Adulte' ou 'Enfant' précisée quand la recommandation
-- distingue explicitement les deux (ex. R2.1.1, R5.1.1) ; NULL quand
-- l'énoncé s'applique indifféremment aux deux (formulation non stratifiée
-- par âge dans la source).
--
-- `specialties` : `anesthesie_reanimation` et `medecine_d_urgence` (SFMU
-- co-autrice à l'initiative du Champ 1 régulation/admission/télémédecine,
-- sujet directement de médecine d'urgence) — pas de spécialité
-- "brûlologie" dédiée dans le seed Annexe B à ce jour.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge du brûlé grave à la phase aiguë chez l''adulte et l''enfant',
  'RPP', 'fr', '2019-09-21',
  'https://sfar.org/prise-en-charge-du-brule-grave-a-la-phase-aigue-chez-ladulte-et-lenfant/',
  'https://sfar.org/download/rpp-prise-en-charge-du-brule-grave/?wpdmdl=24465',
  'RPP (pas RFE, trop peu d''études de puissance suffisante sur la mortalité) ; analyse GRADE, formulation uniforme "les experts suggèrent" (pas de grade 1+/1-/2+/2- individuel), cotation Delphi (échelle 1-9, ≥70% convergents et <20% divergents). 24 recommandations, toutes AE/Accord fort (aucune "Accord faible"). 10 annexes citées par la source (Lund & Browder, formules de remplissage, algorithme d''intubation, posologie hydroxocobalamine, pansements, formules nutritionnelles) absentes du PDF téléchargé (0 image sur 38 pages) — non reproduites, disclosure intégrale en base.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-du-brule-grave-a-la-phase-aigue-chez-ladulte-et-lenfant/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'), ('SFMU', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-du-brule-grave-a-la-phase-aigue-chez-ladulte-et-lenfant/'
  and s.slug in ('anesthesie_reanimation', 'medecine_d_urgence')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.population, v.source_section,
  'https://sfar.org/prise-en-charge-du-brule-grave-a-la-phase-aigue-chez-ladulte-et-lenfant/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000086-R01', 'Utiliser la méthode standardisée de Lund et Browder (adulte ou pédiatrique) pour évaluer la surface cutanée brûlée (SCB).', 'AE', 'Évaluation de la surface cutanée brûlée', null, 'Champ 1 — Régulation, admission, télémédecine, R1.1'),
  ('MG-ANES-000086-R02', 'Requérir sans délai un avis spécialisé en cas de brûlure grave, afin d''envisager une hospitalisation en Centre de Traitement des Brûlés (CTB).', 'AE', 'Avis spécialisé et orientation en CTB', null, 'Champ 1 — Régulation, admission, télémédecine, R1.2.1'),
  ('MG-ANES-000086-R03', 'Utiliser la télémédecine pour améliorer l''évaluation initiale du brûlé grave.', 'AE', 'Télémédecine pour l''évaluation initiale', null, 'Champ 1 — Régulation, admission, télémédecine, R1.2.2'),
  ('MG-ANES-000086-R04', 'Si une hospitalisation en CTB est retenue, privilégier une admission directe en CTB.', 'AE', 'Admission directe en Centre de Traitement des Brûlés', null, 'Champ 1 — Régulation, admission, télémédecine, R1.2.3'),
  ('MG-ANES-000086-R05', 'Réaliser une escarrotomie si la brûlure profonde induit une hyperpression compartimentale des membres/du tronc compromettant voies aériennes, ventilation et/ou circulation — idéalement en CTB par un praticien expérimenté.', 'AE', 'Indication de l''escarrotomie', null, 'Champ 1 — Régulation, admission, télémédecine, R1.2.4'),
  ('MG-ANES-000086-R06', 'Administrer 20 mL/kg d''une solution cristalloïde IV dans la première heure de prise en charge si SCB ≥ 20% (adulte) ou ≥ 10% (enfant).', 'AE', 'Remplissage initial de la première heure', null, 'Champ 2 — Réanimation hémodynamique, R2.1.1'),
  ('MG-ANES-000086-R07', 'Utiliser des solutions cristalloïdes balancées dans la prise en charge du brûlé grave.', 'AE', 'Choix des cristalloïdes — solutions balancées', null, 'Champ 2 — Réanimation hémodynamique, R2.1.2'),
  ('MG-ANES-000086-R08', 'Utiliser, au-delà de la 1re heure, une formule d''estimation du remplissage initial intégrant au minimum le poids et la SCB pour définir les apports en cristalloïdes.', 'AE', 'Formule d''estimation du remplissage au-delà de la 1re heure', null, 'Champ 2 — Réanimation hémodynamique, R2.2'),
  ('MG-ANES-000086-R09', 'Ajuster dès que possible les volumes perfusés de réanimation liquidienne en fonction des données de l''évaluation hémodynamique.', 'AE', 'Ajustement du remplissage sur l''évaluation hémodynamique', null, 'Champ 2 — Réanimation hémodynamique, R2.3'),
  ('MG-ANES-000086-R10', 'Utiliser l''albumine humaine si SCB > 30%, au-delà des 6 premières heures de prise en charge.', 'AE', 'Indication de l''albumine humaine', null, 'Champ 2 — Réanimation hémodynamique, R2.4'),
  ('MG-ANES-000086-R11', 'Ne pas intuber systématiquement un patient avec une brûlure du visage ou du cou.', 'AE', 'Intubation systématique — brûlure du visage/cou', null, 'Champ 3 — Voies aériennes et inhalation de fumées, R3.1.1'),
  ('MG-ANES-000086-R12', 'Intuber si brûlure de la totalité du visage associée à : (1) brûlure profonde et circulaire du cou, et/ou (2) symptômes d''obstruction des voies aériennes (voix modifiée, stridor, dyspnée laryngée), et/ou (3) brûlure très étendue (SCB ≥ 40%).', 'AE', 'Critères d''intubation en cas de brûlure faciale', null, 'Champ 3 — Voies aériennes et inhalation de fumées, R3.1.2'),
  ('MG-ANES-000086-R13', 'Ne pas réaliser de fibroscopie bronchique en cas de suspicion d''inhalation de fumées en dehors d''un centre spécialisé, pour ne pas retarder le transfert.', 'AE', 'Fibroscopie bronchique hors centre spécialisé', null, 'Champ 3 — Voies aériennes et inhalation de fumées, R3.2'),
  ('MG-ANES-000086-R14', 'Ne pas administrer systématiquement d''hydroxocobalamine en cas d''inhalation de fumées.', 'AE', 'Hydroxocobalamine — non-administration systématique', null, 'Champ 3 — Voies aériennes et inhalation de fumées, R3.3.1'),
  ('MG-ANES-000086-R15', 'Réserver l''hydroxocobalamine aux cas avec suspicion élevée d''intoxication majeure aux cyanures (adulte) ou modérée (enfant).', 'AE', 'Hydroxocobalamine — indication ciblée', null, 'Champ 3 — Voies aériennes et inhalation de fumées, R3.3.2'),
  ('MG-ANES-000086-R16', 'Ne pas réaliser systématiquement une séance d''oxygénothérapie hyperbare en cas de suspicion d''intoxication au CO secondaire à une inhalation de fumées.', 'AE', 'Oxygénothérapie hyperbare — non-systématique', null, 'Champ 3 — Voies aériennes et inhalation de fumées, R3.4'),
  ('MG-ANES-000086-R17', 'Utiliser une analgésie multimodale, titrée sur des échelles validées d''évaluation du confort et de l''analgésie.', 'AE', 'Analgésie multimodale titrée', null, 'Champ 4 — Anesthésie et analgésie, R4.1.1'),
  ('MG-ANES-000086-R18', 'Utiliser la kétamine IV en titration pour les douleurs intenses induites par la brûlure, en association avec d''autres antalgiques.', 'AE', 'Kétamine IV pour douleurs intenses', null, 'Champ 4 — Anesthésie et analgésie, R4.1.2'),
  ('MG-ANES-000086-R19', 'Recourir à des techniques non pharmacologiques en association avec les antalgiques lors des pansements, chez le patient stable.', 'AE', 'Techniques non pharmacologiques lors des pansements', null, 'Champ 4 — Anesthésie et analgésie, R4.1.3'),
  ('MG-ANES-000086-R20', 'Refroidir les brûlures si SCB < 20% (adulte) ou < 10% (enfant), en l''absence d''état de choc.', 'AE', 'Refroidissement des brûlures', null, 'Champ 5 — Traitement local, R5.1.1'),
  ('MG-ANES-000086-R21', 'Couvrir les zones brûlées dès la phase initiale, pour limiter l''hypothermie et le risque de contamination microbienne, jusqu''à l''avis spécialisé.', 'AE', 'Couverture des zones brûlées', null, 'Champ 5 — Traitement local, R5.2'),
  ('MG-ANES-000086-R22', 'Ne pas administrer d''antibioprophylaxie systémique en dehors de la période périopératoire.', 'AE', 'Antibioprophylaxie systémique — non-systématique', null, 'Champ 5 — Traitement local, R5.3'),
  ('MG-ANES-000086-R23', 'Débuter un support nutritionnel dans les 12 heures suivant la brûlure, en privilégiant la voie orale ou entérale à la voie parentérale.', 'AE', 'Support nutritionnel précoce', null, 'Champ 6 — Traitements autres, R6.1'),
  ('MG-ANES-000086-R24', 'Administrer une thromboprophylaxie à la phase initiale chez le brûlé grave.', 'AE', 'Thromboprophylaxie à la phase initiale', null, 'Champ 6 — Traitements autres, R6.2')
) as v(code, statement, grade, condition_topic, population, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-du-brule-grave-a-la-phase-aigue-chez-ladulte-et-lenfant/'
on conflict (recommendation_code) do nothing;
