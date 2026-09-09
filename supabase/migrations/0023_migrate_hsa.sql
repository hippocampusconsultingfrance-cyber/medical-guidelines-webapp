-- Migration : Hémorragie sous-arachnoïdienne (HSA) grave — Conférence d'experts, texte
-- court, 2004. SFAR, en partenariat avec l'Association de neuroanesthésie-réanimation de
-- langue française (ANARLF), la Société française de neurochirurgie et la Société française
-- de neuroradiologie. Panel présidé par le Pr L. Beydon (Angers).
-- Source : rfe-sfar-website/build/content_hsa.json (60 recommandations graduées).
--
-- MÉTHODOLOGIE : conférence d'experts, PAS une recommandation GRADE — la source elle-même
-- justifie ce choix par le « faible niveau de preuve » de la majorité des études
-- disponibles. Chaque proposition du jury porte un grade parmi A, B, D, E — AUCUNE
-- occurrence de Grade C dans tout le texte. **Le texte court exploité ici ne définit NULLE
-- PART la signification précise de ces lettres** ; cette définition figure vraisemblablement
-- dans l'argumentaire scientifique complet (texte long), non disponible pour cette fiche.
-- Disclosure explicite reprise ici plutôt qu'une définition devinée : A = preuve scientifique
-- forte (seule lettre dont le sens est donné littéralement par le texte court, "Grade A"),
-- B = présomption scientifique (idem, donné littéralement), D et E = signification NON
-- définie dans le texte court disponible. `grade` reproduit tel quel la lettre imprimée par
-- la source (A/B/D/E), jamais interprété ni fait correspondre à un système GRADE 1+/2+/AE
-- utilisé ailleurs dans ce corpus — ce serait inventer une équivalence non fournie par la
-- source. `evidence_level` laissé NULL : un seul axe de cotation dans ce document.
--
-- COMPTAGE — RECONCILIÉ, ÉCART EXPLIQUÉ : le panneau méthodologique du contenu construit
-- rapporte un "comptage exhaustif du corps du texte" de 2× Grade A, 1× Grade B, 10× Grade D,
-- 48× Grade E (total 61 occurrences textuelles de la chaîne "Grade X"). Le comptage direct
-- des 60 lignes du tableau "Réf. | Recommandation | Grade" donne 2 A + 1 B + 9 D + 48 E = 60.
-- L'écart d'une occurrence de Grade D est expliqué : le panneau de champ d'application en
-- introduction ("HSA grave par rupture d'anévrysme (WFNS III à V, Grade D)") restate la
-- définition de D.2 dans le texte de cadrage, hors tableau de recommandations — ce n'est pas
-- une 61e recommandation manquante, juste une 2e occurrence textuelle de "Grade D" en dehors
-- d'un tableau. Reconciliation explicite, aucune ligne inventée ni omise.
--
-- PÉRIMÈTRE — volontairement pas migrés : les 4 tableaux de classification/référence
-- (Tableau 1, WFNS ; Tableau 2, Hunt et Hess ; Tableau 3, échelle scanographique de Fisher ;
-- le tableau âge/index bicaudé normal) — échelles cliniques de référence international
-- établies, pas des recommandations individuellement graduées par le jury ; leur contenu est
-- déjà référencé par les recommandations D.1/D.2 elles-mêmes (ex. D.2 définit "HSA grave"
-- par rapport à l'échelle WFNS). Cohérent avec le principe d'exclusion des tableaux de
-- classification/référence déjà appliqué dans ce corpus.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Signification des grades D et E NON définie par le texte court disponible — voir
--    disclosure méthodologique ci-dessus. Un relecteur humain disposant de l'argumentaire
--    scientifique complet (texte long) de cette conférence d'experts pourrait combler cette
--    lacune ; non fait ici pour éviter d'inventer une définition.
-- 2. Conférence d'experts de 2004 — la fiche source avertit explicitement : "se référer
--    également, en complément, aux recommandations et pratiques plus récentes sur la prise
--    en charge de l'HSA anévrysmale". `freshness_status` mis à `revision_detectee` (et non
--    `a_jour`), bien que `library_final.json` indique `"status": "en vigueur"` — divergence
--    disclosée, même pattern que `eclsa`/0019 et `glycemie`/0022.
-- 3. Sociétés partenaires (ANARLF, Société française de neurochirurgie, Société française
--    de neuroradiologie) : aucune ne correspond à un acronyme du seed Annexe B de
--    schema_v2.sql — seule la SFAR est liée en document_societies.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Hémorragie sous-arachnoïdienne grave',
  'CE', 'fr', '2004-01-01',
  'https://sfar.org/hemorragie-sous-arachnoidienne-hsa-grave/',
  'https://sfar.org/wp-content/uploads/2015/10/2a_SFAR_texte-court_Hemorragies-sous-arachnoidienne.pdf',
  'Conférence d''experts (pas de recommandation GRADE — motivée par le faible niveau de preuve de la majorité des études disponibles). Grades A/B/D/E imprimés par le jury pour chaque proposition ; A = preuve scientifique forte, B = présomption scientifique (définis littéralement par le texte court) ; D et E = signification NON définie dans le texte court disponible (disclosure explicite de la source elle-même) ; aucune occurrence de Grade C.',
  'revision_detectee'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/hemorragie-sous-arachnoidienne-hsa-grave/'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/hemorragie-sous-arachnoidienne-hsa-grave/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'neurochirurgie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/hemorragie-sous-arachnoidienne-hsa-grave/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000023-R01', 'Le score de Glasgow doit être utilisé en complément de ces échelles pour quantifier la gravité de l''HSA tout au long de l''évolution clinique.', 'E', 'Diagnostic en hôpital général et prise en charge initiale (Réf. D.1)'),
  ('MG-ANES-000023-R02', 'On retient la définition d''HSA grave pour des HSA cotées III à V dans l''échelle de la WFNS, qui doit être privilégiée par rapport à celle de Hunt et Hess.', 'D', 'Diagnostic en hôpital général et prise en charge initiale (Réf. D.2)'),
  ('MG-ANES-000023-R03', 'Tout patient suspect d''HSA doit être exploré par un scanner cérébral, en urgence — permettant d''évaluer l''importance de l''HSA et ses conséquences (hydrocéphalie, hématome, infarctus).', 'D', 'Imagerie, ponction lombaire, transfert (Réf. D.3)'),
  ('MG-ANES-000023-R04', 'En cas de doute d''interprétation, les images feront l''objet d''une télétransmission vers un centre de référence.', 'E', 'Imagerie, ponction lombaire, transfert (Réf. D.4)'),
  ('MG-ANES-000023-R05', 'L''intérêt de pratiquer un angio-scanner pour rechercher la cause de l''HSA en dehors d''un centre neurochirurgical est discutable — cet examen n''a qu''un intérêt préthérapeutique et n''est donc pas utile pour la décision de transfert.', 'E', 'Imagerie, ponction lombaire, transfert (Réf. D.5)'),
  ('MG-ANES-000023-R06', 'Toute dégradation neurologique impose la réalisation d''un nouveau scanner.', 'D', 'Imagerie, ponction lombaire, transfert (Réf. D.6)'),
  ('MG-ANES-000023-R07', 'La ponction lombaire n''a aucune indication lorsque l''HSA est visualisée sur le scanner cérébral. On y recourt pour l''éliminer lorsque la symptomatologie est évocatrice et le scanner normal — exceptionnel dans les formes graves.', 'D', 'Imagerie, ponction lombaire, transfert (Réf. D.7)'),
  ('MG-ANES-000023-R08', 'Le diagnostic d''HSA impose le transfert dans un centre de référence incluant des équipes de neurochirurgie, de neuroradiologie et de neuroanesthésie-réanimation, comportant une unité compétente en neuro-réanimation.', 'E', 'Imagerie, ponction lombaire, transfert (Réf. D.8)'),
  ('MG-ANES-000023-R09', 'Un hématome intracérébral compressif doit être évacué chirurgicalement, geste associé au traitement chirurgical de l''anévrysme.', 'D', 'Complications précoces — HTIC, hydrocéphalie, resaignement, épilepsie (Réf. C.1)'),
  ('MG-ANES-000023-R10', 'En cas d''engagement cérébral avec localisation de l''hématome suffisamment informative au scanner, le traitement chirurgical de l''anévrysme peut être réalisé sans angiographie diagnostique (pronostic dépendant de la précocité du traitement).', 'E', 'Complications précoces — HTIC, hydrocéphalie, resaignement, épilepsie (Réf. C.2)'),
  ('MG-ANES-000023-R11', 'Un œdème cérébral impose un monitorage de la PIC, au mieux par cathéter intraventriculaire.', 'E', 'Complications précoces — HTIC, hydrocéphalie, resaignement, épilepsie (Réf. C.3)'),
  ('MG-ANES-000023-R12', 'Une hydrocéphalie impose une dérivation ventriculaire externe (DVE) en urgence.', 'E', 'Complications précoces — HTIC, hydrocéphalie, resaignement, épilepsie (Réf. C.4)'),
  ('MG-ANES-000023-R13', 'Si un geste endovasculaire est envisagé, la DVE devrait être posée avant l''embolisation (l''héparinothérapie péri-embolisation gênerait sa pose ultérieure) ; elle est maintenue à 15 cm au-dessus de l''orifice du conduit auditif externe.', 'E', 'Complications précoces — HTIC, hydrocéphalie, resaignement, épilepsie (Réf. C.5)'),
  ('MG-ANES-000023-R14', 'En cas de doute sur une HTIC, le Doppler transcrânien (DTC) peut permettre d''en objectiver des signes.', 'E', 'Complications précoces — HTIC, hydrocéphalie, resaignement, épilepsie (Réf. C.6)'),
  ('MG-ANES-000023-R15', 'Le traitement de l''HTA relève d''un nécessaire compromis entre le risque de resaignement et celui d''hypoperfusion cérébrale.', 'E', 'Complications précoces — HTIC, hydrocéphalie, resaignement, épilepsie (Réf. C.7)'),
  ('MG-ANES-000023-R16', 'L''objectif premier du traitement de l''anévrysme est d''éviter la récidive hémorragique (mortalité > 70 % en cas de resaignement) par une exclusion précoce.', 'D', 'Complications précoces — HTIC, hydrocéphalie, resaignement, épilepsie (Réf. C.8)'),
  ('MG-ANES-000023-R17', 'Une prophylaxie anti-épileptique peut être envisagée chez les patients à haut risque de convulsions (sang dans les citernes, infarctus cérébral, lésion focale, hématome sous-dural) — aucune donnée ne permet de statuer sur la durée de cette prophylaxie.', 'E', 'Complications précoces — HTIC, hydrocéphalie, resaignement, épilepsie (Réf. C.9)'),
  ('MG-ANES-000023-R18', 'Des taux élevés de troponine I doivent inciter à réaliser un bilan échocardiographique.', 'E', 'Complications précoces — retentissement cardio-pulmonaire, natrémie (Réf. C.10)'),
  ('MG-ANES-000023-R19', 'Une défaillance cardiovasculaire et/ou respiratoire sévère peut nécessiter de différer le traitement étiologique de l''anévrysme, réalisé dès la situation contrôlée.', 'E', 'Complications précoces — retentissement cardio-pulmonaire, natrémie (Réf. C.11)'),
  ('MG-ANES-000023-R20', 'En cas de CSWS (hyponatrémie + hypovolémie + natriurèse augmentée), remplacer les pertes en eau et en sel et proscrire toute restriction hydrique (minéralocorticoïdes possibles en complément).', 'E', 'Complications précoces — retentissement cardio-pulmonaire, natrémie (Réf. C.12)'),
  ('MG-ANES-000023-R21', 'En cas d''hyponatrémie symptomatique, une correction initiale rapide, objectif natrémie 125 mmol/l, est recommandée.', 'E', 'Complications précoces — retentissement cardio-pulmonaire, natrémie (Réf. C.13)'),
  ('MG-ANES-000023-R22', 'En cas d''hypernatrémie (diabète insipide à rechercher), la correction ne doit pas être trop rapide (< 12 mmol/l/24 h) — elle peut majorer une éventuelle HTIC.', 'E', 'Complications précoces — retentissement cardio-pulmonaire, natrémie (Réf. C.14)'),
  ('MG-ANES-000023-R23', 'Le traitement précoce (dans les 72 premières heures) du sac anévrysmal s''impose.', 'E', 'Traitement de l''anévrysme (Réf. T.1)'),
  ('MG-ANES-000023-R24', 'La décision du choix thérapeutique doit résulter d''une discussion entre chirurgiens, radiologues et neuro-anesthésistes.', 'E', 'Traitement de l''anévrysme (Réf. T.2)'),
  ('MG-ANES-000023-R25', 'Un traitement intensif des patients en grade clinique élevé (monitorage de la PIC, drainage du LCS, monitorage hémodynamique, « triple H » thérapie précoce) améliore significativement leur pronostic.', 'D', 'Traitement de l''anévrysme (Réf. T.3)'),
  ('MG-ANES-000023-R26', 'Quand le traitement endovasculaire et chirurgical sont tous deux possibles, en dehors des hématomes compressifs, le traitement endovasculaire est probablement l''option thérapeutique appropriée (extrapolation de l''étude ISAT, menée sur des grades WFNS faibles, aux grades élevés).', 'B', 'Traitement de l''anévrysme (Réf. T.4)'),
  ('MG-ANES-000023-R27', 'Le choix thérapeutique ne doit pas retarder la mise en place d''une DVE ; en cas de défaillance cardiaque, le traitement du sac anévrysmal doit être différé jusqu''à stabilisation de la fonction cardiaque.', 'E', 'Traitement de l''anévrysme (Réf. T.5)'),
  ('MG-ANES-000023-R28', 'Traitement chirurgical : le volet doit être large en raison de l''HTIC souvent associée aux formes graves d''HSA.', 'E', 'Traitement de l''anévrysme (Réf. T.6)'),
  ('MG-ANES-000023-R29', 'Traitement chirurgical : l''hypotension artérielle est à proscrire, sauf conditions de sauvetage sur rupture incontrôlable.', 'E', 'Traitement de l''anévrysme (Réf. T.7)'),
  ('MG-ANES-000023-R30', 'Traitement endovasculaire : une héparinothérapie à dose efficace est nécessaire durant le geste.', 'E', 'Traitement de l''anévrysme (Réf. T.8)'),
  ('MG-ANES-000023-R31', 'Traitement endovasculaire : en cas de rupture durant la procédure, il convient de poursuivre le remplissage de la poche anévrysmale le plus rapidement possible.', 'E', 'Traitement de l''anévrysme (Réf. T.9)'),
  ('MG-ANES-000023-R32', 'Traitement endovasculaire : avant de reprendre un éventuel traitement anticoagulant, un scanner de contrôle est indiqué.', 'E', 'Traitement de l''anévrysme (Réf. T.10)'),
  ('MG-ANES-000023-R33', 'Traitement endovasculaire : une thrombose en cours d''embolisation doit faire envisager un traitement par fibrinolytique in situ ou par agent antiplaquettaire.', 'E', 'Traitement de l''anévrysme (Réf. T.11)'),
  ('MG-ANES-000023-R34', 'Traitement endovasculaire : en cas de déficit neurologique apparaissant dans les suites de la procédure, une exploration tomodensitométrique doit être impérativement réalisée pour écarter un resaignement.', 'E', 'Traitement de l''anévrysme (Réf. T.12)'),
  ('MG-ANES-000023-R35', 'Traitement endovasculaire : il est particulièrement indiqué de poser la DVE avant l''embolisation (arrêt/antagonisation de l''héparine circulante requis sinon, ce qui n''est pas sans danger) — même justification que C.5.', 'E', 'Traitement de l''anévrysme (Réf. T.13)'),
  ('MG-ANES-000023-R36', 'En cas d''HSA grave avec HTIC, l''anesthésie intraveineuse est clairement à préférer ; l''injection de fortes doses de morphiniques en bolus est à éviter (risque d''augmentation de la PIC). Objectif peranesthésique : éviter les poussées hypertensives (risque de rupture) et l''hypotension (hypoperfusion cérébrale).', 'D', 'Anesthésie et traitement de la douleur (Réf. A.1)'),
  ('MG-ANES-000023-R37', 'Les principes de l''anesthésie pour le traitement endovasculaire sont les mêmes que ceux de la chirurgie : maintien d''une PPC suffisante et immobilité absolue.', 'E', 'Anesthésie et traitement de la douleur (Réf. A.2)'),
  ('MG-ANES-000023-R38', 'Les patients d''HSA grave hospitalisés en réanimation et ventilés ne présentent aucune contre-indication aux opiacés ; l''utilisation du paracétamol est intéressante par son effet antipyrétique associé.', 'E', 'Anesthésie et traitement de la douleur (Réf. A.3)'),
  ('MG-ANES-000023-R39', 'Les AINS sont à discuter, car ils induisent des risques mal documentés.', 'E', 'Anesthésie et traitement de la douleur (Réf. A.4)'),
  ('MG-ANES-000023-R40', 'La première étape du diagnostic par imagerie consiste à éliminer les autres causes d''aggravation neurologique (ischémie postopératoire, hydrocéphalie, resaignement, troubles hydroélectrolytiques, convulsions infracliniques) ; on réalisera un scanner de façon systématique.', 'E', 'Vasospasme — aspects cliniques et diagnostic (Réf. V.1)'),
  ('MG-ANES-000023-R41', 'La réalisation quotidienne d''un Doppler transcrânien est recommandée. Seul le vasospasme de l''artère sylvienne peut être prédit avec une sensibilité et une spécificité suffisantes pour être validé en pratique clinique.', 'E', 'Vasospasme — aspects cliniques et diagnostic (Réf. V.2)'),
  ('MG-ANES-000023-R42', 'La valeur seuil de 120 cm/s pour la vitesse moyenne du flux sanguin de l''artère cérébrale moyenne est celle retenue habituellement ; un rapport vitesse ACM/carotide interne extra-crânienne > 3 traduit un vasospasme, > 6 un vasospasme sévère.', 'E', 'Vasospasme — aspects cliniques et diagnostic (Réf. V.3)'),
  ('MG-ANES-000023-R43', 'Un accroissement des vitesses supérieur à 50 cm/s par jour est un facteur prédictif de déficit neurologique.', 'E', 'Vasospasme — aspects cliniques et diagnostic (Réf. V.4)'),
  ('MG-ANES-000023-R44', 'En cas de doute et pour pallier les limites du Doppler, l''IRM, le scanner de perfusion, ou toute imagerie évaluant le débit sanguin cérébral peuvent être utilisés, selon les possibilités locales.', 'E', 'Vasospasme — aspects cliniques et diagnostic (Réf. V.5)'),
  ('MG-ANES-000023-R45', 'La prévention pharmacologique du vasospasme cérébral dans les suites d''une HSA est basée sur l''utilisation de nimodipine (nombre de sujets à traiter pour une bonne évolution neurologique supplémentaire : 7 à 13).', 'A', 'Vasospasme — traitement préventif, curatif et endovasculaire (Réf. V.6)'),
  ('MG-ANES-000023-R46', 'La nimodipine doit être administrée par voie orale à la dose de 360 mg/j pendant 21 jours (voie IV 1-2 mg/h selon le poids = alternative courante en France, à risque d''hypotension systémique).', 'A', 'Vasospasme — traitement préventif, curatif et endovasculaire (Réf. V.7)'),
  ('MG-ANES-000023-R47', 'Cette durée de 21 jours pourrait être abrégée à 15 jours.', 'D', 'Vasospasme — traitement préventif, curatif et endovasculaire (Réf. V.8)'),
  ('MG-ANES-000023-R48', 'L''hypotension sous nimodipine IV doit impérativement être corrigée.', 'E', 'Vasospasme — traitement préventif, curatif et endovasculaire (Réf. V.9)'),
  ('MG-ANES-000023-R49', 'Le traitement hyperdynamique (« triple H therapy » : hypervolémie, hypertension, hémodilution) n''a démontré son efficacité dans aucune étude contrôlée randomisée ; la stratégie est réduite, dans la plupart des centres, au contrôle de la volémie associé à l''HTA, une fois l''anévrysme sécurisé.', 'E', 'Vasospasme — traitement préventif, curatif et endovasculaire (Réf. V.10)'),
  ('MG-ANES-000023-R50', 'Un objectif de PAM jusqu''à 100-120 mmHg peut être envisagé en l''absence d''infarctus constitué (l''HTA contrôlée doit être limitée en cas d''infarctus, pour réduire le risque de transformation hémorragique).', 'E', 'Vasospasme — traitement préventif, curatif et endovasculaire (Réf. V.11)'),
  ('MG-ANES-000023-R51', 'Le traitement hyperdynamique nécessite un monitorage continu approprié (mesure invasive de la PA et de la PVC au minimum) et un contrôle fréquent de la natrémie, de la glycémie et de la température.', 'E', 'Vasospasme — traitement préventif, curatif et endovasculaire (Réf. V.12)'),
  ('MG-ANES-000023-R52', 'L''infusion intra-artérielle de vasodilatateur (papavérine, nimodipine diluée) et/ou l''angioplastie par ballonnet sont deux techniques endovasculaires utilisables pour le traitement du vasospasme (évaluation en cours, indications non généralisables).', 'E', 'Vasospasme — traitement préventif, curatif et endovasculaire (Réf. V.13)'),
  ('MG-ANES-000023-R53', 'L''efficacité du traitement endovasculaire du vasospasme est corrélée à la précocité de l''intervention.', 'E', 'Vasospasme — traitement préventif, curatif et endovasculaire (Réf. V.14)'),
  ('MG-ANES-000023-R54', 'La protéine S100b peut s''intégrer dans le monitorage multimodal des patients ayant une HSA d''origine anévrysmale.', 'E', 'Stratégie de suivi du malade (Réf. S.1)'),
  ('MG-ANES-000023-R55', 'Chez les patients en grade sévère d''HSA, un monitorage systématique de la PIC par une DVE ou, à défaut, par capteur intraparenchymateux, est recommandé ; la DVE est utilisée avec une contre-pression de 15 cmH2O.', 'E', 'Stratégie de suivi du malade (Réf. S.2)'),
  ('MG-ANES-000023-R56', 'Pendant la phase aiguë, la réalisation d''un Doppler par jour est utile pour détecter l''apparition d''un vasospasme, principalement sur le territoire sylvien — même recommandation que V.2, répétée par la source dans cette section dédiée au suivi.', 'E', 'Stratégie de suivi du malade (Réf. S.3)'),
  ('MG-ANES-000023-R57', 'Une filière de prise en charge permettant l''hospitalisation dans le centre de référence dans les plus brefs délais doit être préalablement établie dans chaque région ; l''information des différents acteurs potentiels de la filière d''amont doit être assurée.', 'E', 'Filière de prise en charge de l''HSA (Réf. F.1)'),
  ('MG-ANES-000023-R58', 'Le centre de référence doit traiter un nombre suffisant de patients souffrant d''HSA pour entretenir une filière interne efficace.', 'E', 'Filière de prise en charge de l''HSA (Réf. F.2)'),
  ('MG-ANES-000023-R59', 'Cette filière doit prendre en compte les particularités propres à chaque établissement.', 'E', 'Filière de prise en charge de l''HSA (Réf. F.3)'),
  ('MG-ANES-000023-R60', 'Cela implique : en amont, un diagnostic précoce reposant sur la qualité de formation des médecins généralistes et urgentistes ; au cours de l''hospitalisation, le traitement précoce du sac anévrysmal dès que les conditions physiologiques le permettent.', 'E', 'Filière de prise en charge de l''HSA (Réf. F.4)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/hemorragie-sous-arachnoidienne-hsa-grave/'
on conflict (recommendation_code) do nothing;
