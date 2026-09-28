-- Migration : Anesthésie pour amygdalectomie chez l'enfant — Conférence
-- d'experts, texte court. SFAR / Adarpef (Association des anesthésistes
-- réanimateurs pédiatriques d'expression française) / Carorl (Club de
-- l'anesthésie réanimation en ORL). Secrétaire : Pr I. Constant ; Président :
-- Pr G. Orliaguet. 2005 (dépôt légal novembre 2006).
-- Source : rfe-sfar-website/build/content_amygdalectomie_enfant.json (72
-- recommandations atomiques identifiées à la lecture intégrale des 5
-- questions / 12 sous-questions du texte court — couverture intégrale
-- déclarée par le contenu construit lui-même : "cette fiche reprend
-- l'intégralité des 5 questions / 12 sous-questions du texte court").
--
-- MÉTHODOLOGIE — DEUX SYSTÈMES DE COTATION COMBINÉS, JAMAIS FUSIONNÉS :
-- (a) niveaux de preuve fondés sur la littérature, Grade A (>= 2 études de
-- niveau I) / B (1 étude de niveau I) / C (étude(s) de niveau II) ; (b)
-- cotation RAND/UCLA modifiée des experts (« Accord fort » = intervalle
-- borné dans une seule zone, ou « Accord faible » = intervalle empiétant
-- sur une borne) pour les propositions sans preuve littéraire suffisante.
-- Chaque proposition du texte source porte l'UN OU L'AUTRE de ces deux
-- tags, jamais les deux à la fois (disclosure explicite de la fiche
-- construite elle-même, reproduite ici sans fusion) — vérifié ligne par
-- ligne ci-dessous : `grade` contient soit 'Grade A'/'Grade B'/'Grade C'
-- (exactement les chips A/B/C de la source), soit 'Accord fort'/'Accord
-- faible' (exactement les chips Fort/Faible de la source), jamais un
-- mélange des deux sur une même ligne. `evidence_level` laissé NULL sur
-- les 72 lignes : aucune sous-cotation distincte du grade/accord n'est
-- imprimée par la source pour une recommandation individuelle (les seules
-- autres mentions numériques du texte, ex. "SAOS grave", "0,5 à 3 %", sont
-- des données épidémiologiques dans le corps du `statement`, pas une
-- cotation structurée séparée).
--
-- PIÈGE "GRADE D/E" EXPLICITEMENT VÉRIFIÉ — la légende méthodologique de la
-- source précise elle-même "Aucune proposition D ou E dans ce texte" (texte
-- reproduit littéralement dans le panneau légende du contenu construit).
-- Recherche exhaustive effectuée sur les 72 lignes ci-dessous : AUCUNE ne
-- porte un chip D ou E — confirmé, ce ne sont que des mentions de légende
-- méthodologique jamais appliquées à une recommandation réelle. Voir aussi
-- le garde-fou grade composite (grep '"[12][+-]/[12][+-]' — sans objet ici,
-- cette source n'utilise pas la convention GRADE 1+/2- ; garde-fou
-- équivalent vérifié : aucune ligne ne porte de chip fusionné du type
-- 'A/B', 'Fort/Faible' ou 'B/C' — chaque proposition ne porte qu'UN seul
-- tag, jamais deux combinés sur une même ligne).
--
-- MÉTHODE D'ATOMISATION : chaque ligne des tableaux "Proposition | Cotation"
-- du texte source est une recommandation atomique. Les 4 exceptions
-- narratives hors tableau (critères de report d'intervention 1.4, douleur
-- post-amygdalectomie 3.3, critères d'ambulatoire et de sortie à domicile
-- Q5) portent elles aussi un tag [Accord fort] explicite dans le texte
-- source et sont migrées comme recommandations atomiques ; lorsqu'une
-- telle phrase introduit une liste à puces de critères (se terminant par
-- ":"), la liste est reproduite intégralement DANS le même `statement`
-- (un seul tag Accord fort couvrant l'ensemble des critères énumérés dans
-- la source — pas une fragmentation artificielle d'une liste que la
-- source elle-même présente comme un tout sous un seul accord).
--
-- POPULATION : l'intégralité du document concerne une population unique
-- (enfant opéré d'amygdalectomie, avec ou sans adénoïdectomie) — pas de
-- sous-population distincte identifiée nommément par une recommandation
-- individuelle (le SAOS grave, cité dans plusieurs lignes, est un critère
-- clinique de gravité au sein de la même population pédiatrique, pas une
-- sous-population distincte). `population` laissé NULL sur toutes les
-- lignes plutôt que de répéter 'Enfant' 72 fois (même convention que
-- voies_aeriennes_enfant/0059).
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. L'Adarpef et le Carorl, co-organisateurs à égalité de cette conférence
--    d'experts avec la SFAR (titre du document source : SFAR/Adarpef/
--    Carorl), ne figurent pas dans le seed Annexe B (societies) — seule la
--    SFAR (présente dans le seed) est liée en `document_societies`
--    ci-dessous, même situation que `voies_aeriennes_enfant`/0059
--    (SFAR-ADARPEF) et `allergie_prevention`/0006 (SFAR-SFA).
-- 2. `library_final.json` ne donne que l'année de publication ("2005") ;
--    la fiche construite précise par ailleurs un dépôt légal "novembre
--    2006" pour le même document — `publication_date` ci-dessous utilise
--    2005-01-01 par convention (année de la conférence d'experts elle-même,
--    pas le dépôt légal, qui est une formalité administrative postérieure),
--    même traitement que les autres documents de ce corpus sans date exacte
--    connue (ex. `allergie_prevention`/0006).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Anesthésie pour amygdalectomie chez l''enfant',
  'CE', 'fr', '2005-01-01',
  'https://sfar.org/anesthesie-pour-amygdalectomie-chez-lenfant/',
  'https://sfar.org/wp-content/uploads/2015/10/2a_SFAR_TEXTE-COURT_Anesthesie-pour-amygdalectomie-chez-lenfant.pdf',
  'Deux systèmes de cotation combinés, jamais fusionnés sur une même proposition : Grade A/B/C (niveaux de preuve fondés sur la littérature) pour les propositions disposant de preuve suffisante ; cotation RAND/UCLA modifiée des experts ("Accord fort"/"Accord faible") pour les propositions sans preuve littéraire suffisante. Aucune proposition D ou E (légende méthodologique de la source, vérifié).',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/anesthesie-pour-amygdalectomie-chez-lenfant/'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/anesthesie-pour-amygdalectomie-chez-lenfant/'
  and s.slug in ('anesthesie_reanimation', 'chirurgie_pediatrique', 'orl_et_chirurgie_cervico_faciale', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/anesthesie-pour-amygdalectomie-chez-lenfant/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000073-R01', 'La consultation d''anesthésie en prévision d''une amygdalectomie a deux buts essentiels : l''évaluation des risques inhérents à l''acte et l''information du patient et de ses parents.', 'Accord fort', '1.1 — Objectifs et modalités de la consultation d''anesthésie, information sur le risque'),
  ('MG-ANES-000073-R02', 'L''évaluation des risques repose sur l''interrogatoire des parents et si possible de l''enfant, ainsi que sur l''examen clinique de l''enfant.', 'Accord fort', '1.1 — Objectifs et modalités de la consultation d''anesthésie, information sur le risque'),
  ('MG-ANES-000073-R03', 'Les risques respiratoires et hémorragiques doivent faire l''objet d''une attention et d''une information particulières.', 'Accord fort', '1.1 — Objectifs et modalités de la consultation d''anesthésie, information sur le risque'),
  ('MG-ANES-000073-R04', 'Le risque respiratoire est majoré en cas de syndrome d''apnée obstructive du sommeil (SAOS) grave.', 'Accord fort', '1.1 — Objectifs et modalités de la consultation d''anesthésie, information sur le risque'),
  ('MG-ANES-000073-R05', 'L''information s''adresse à la fois à l''enfant et aux parents, et doit être adaptée au degré de compréhension de chacun.', 'Accord fort', '1.1 — Objectifs et modalités de la consultation d''anesthésie, information sur le risque'),
  ('MG-ANES-000073-R06', 'L''évaluation préopératoire du risque hémorragique repose sur un interrogatoire précis à la recherche d''antécédents personnels et/ou familiaux suggérant une anomalie de l''hémostase, et sur un examen clinique recherchant une symptomatologie hémorragique.', 'Accord fort', '1.2 — Bilan préopératoire'),
  ('MG-ANES-000073-R07', 'En cas d''antécédents personnels ou familiaux d''hémorragie connus ou suspectés, ou lorsque l''évaluation préopératoire ne peut être considérée comme fiable (notamment chez l''enfant de moins de 3 ans), une étude de l''hémostase doit être réalisée.', 'Accord fort', '1.2 — Bilan préopératoire'),
  ('MG-ANES-000073-R08', 'Les résultats de cette étude initiale, s''ils restent anormaux après contrôle, doivent être discutés avec un spécialiste de l''hémostase afin de déterminer l''opportunité d''une étude plus approfondie.', 'Accord fort', '1.2 — Bilan préopératoire'),
  ('MG-ANES-000073-R09', 'Si des examens d''hémostase sont prescrits, le temps de céphaline avec activateur et la numération plaquettaire sont les tests les plus utiles.', 'Accord fort', '1.2 — Bilan préopératoire'),
  ('MG-ANES-000073-R10', 'Chez l''enfant de plus de 3 ans, lorsque l''évaluation clinique préopératoire ne dépiste pas de risque hémorragique anormal, l''étude systématique de l''hémostase ne s''impose pas.', 'Accord fort', '1.2 — Bilan préopératoire'),
  ('MG-ANES-000073-R11', 'L''amygdalectomie majore le risque de complications respiratoires du fait de la localisation du site chirurgical sur les voies aériennes supérieures.', 'Grade A', '1.3 — Gestion d''une infection des voies aériennes supérieures (IVAS) avant amygdalectomie'),
  ('MG-ANES-000073-R12', 'Ces complications respiratoires contribuent à générer une morbidité dénuée de réelle gravité si l''anesthésiste est expérimenté dans ce contexte.', 'Grade B', '1.3 — Gestion d''une infection des voies aériennes supérieures (IVAS) avant amygdalectomie'),
  ('MG-ANES-000073-R13', 'L''IVAS entraîne une fréquence accrue de complications respiratoires telles que désaturation et pause respiratoire.', 'Grade A', '1.3 — Gestion d''une infection des voies aériennes supérieures (IVAS) avant amygdalectomie'),
  ('MG-ANES-000073-R14', 'L''IVAS entraîne une augmentation de la fréquence des bronchospasmes lorsque l''enfant est intubé.', 'Grade A', '1.3 — Gestion d''une infection des voies aériennes supérieures (IVAS) avant amygdalectomie'),
  ('MG-ANES-000073-R15', 'L''intervention est différée si l''enfant présente : - des signes spastiques bronchiques ; | - une laryngite ; | - une température supérieure à 38 °C.', 'Accord fort', '1.4 — Critères de report d''intervention en cas d''IVAS'),
  ('MG-ANES-000073-R16', 'En cas de report d''intervention, le délai de re-programmation est d''au moins trois semaines.', 'Accord fort', '1.4 — Critères de report d''intervention en cas d''IVAS'),
  ('MG-ANES-000073-R17', 'Le SAOS représente environ deux tiers des indications d''amygdalectomie.', 'Accord fort', '1.5 — Conséquences du syndrome d''apnée du sommeil (SAOS) sur la prise en charge anesthésique'),
  ('MG-ANES-000073-R18', 'Les enfants concernés ont le plus souvent moins de 5 ans.', 'Accord fort', '1.5 — Conséquences du syndrome d''apnée du sommeil (SAOS) sur la prise en charge anesthésique'),
  ('MG-ANES-000073-R19', 'En l''absence de critères de gravité, le SAOS ne modifie habituellement pas la prise en charge anesthésique.', 'Accord fort', '1.5 — Conséquences du syndrome d''apnée du sommeil (SAOS) sur la prise en charge anesthésique'),
  ('MG-ANES-000073-R20', 'Les formes graves de SAOS sont plus fréquentes chez le jeune enfant et en cas de dysmorphie faciale ou de pathologies associées.', 'Accord fort', '1.5 — Conséquences du syndrome d''apnée du sommeil (SAOS) sur la prise en charge anesthésique'),
  ('MG-ANES-000073-R21', 'Les formes graves de SAOS nécessitent une évaluation préopératoire du retentissement cardio-pulmonaire, et justifient une surveillance postopératoire d''au moins 24 heures dans une structure de type SSPI ou surveillance continue.', 'Accord fort', '1.5 — Conséquences du syndrome d''apnée du sommeil (SAOS) sur la prise en charge anesthésique'),
  ('MG-ANES-000073-R22', 'Les règles de jeûne habituelles, adaptées à l''âge de l''enfant, doivent être appliquées.', 'Grade C', '2.1 — Prise en charge anesthésique des patients'),
  ('MG-ANES-000073-R23', 'En dehors des syndromes obstructifs graves, une prémédication anxiolytique est utile.', 'Grade C', '2.1 — Prise en charge anesthésique des patients'),
  ('MG-ANES-000073-R24', 'Les structures de prise en charge et le matériel utilisé doivent être conformes aux recommandations de la Sfar et de l''Adarpef.', 'Accord fort', '2.1 — Prise en charge anesthésique des patients'),
  ('MG-ANES-000073-R25', 'La surveillance peropératoire repose sur un monitorage conforme aux recommandations de la Sfar.', 'Accord fort', '2.1 — Prise en charge anesthésique des patients'),
  ('MG-ANES-000073-R26', 'L''anesthésie générale lors de l''amygdalectomie a pour but d''assurer une composante hypnotique suffisante pour éviter la mémorisation peropératoire, et une composante analgésique efficace.', 'Accord fort', '2.1 — Prise en charge anesthésique des patients'),
  ('MG-ANES-000073-R27', 'L''induction par inhalation est la modalité la plus fréquente.', 'Accord fort', '2.1 — Prise en charge anesthésique des patients'),
  ('MG-ANES-000073-R28', 'L''induction intraveineuse est parfois préférée chez les grands enfants ou en cas de syndrome obstructif sévère.', 'Accord fort', '2.1 — Prise en charge anesthésique des patients'),
  ('MG-ANES-000073-R29', 'L''entretien de l''anesthésie est souvent assuré par un agent halogéné associé à un morphinique.', 'Accord fort', '2.1 — Prise en charge anesthésique des patients'),
  ('MG-ANES-000073-R30', 'Les apports hydroélectrolytiques peropératoires reposent sur l''utilisation d''un soluté isotonique en sel, pouvant contenir une faible concentration de glucose et perfusé à un débit adapté à l''âge de l''enfant.', 'Accord fort', '2.1 — Prise en charge anesthésique des patients'),
  ('MG-ANES-000073-R31', 'Débit de perfusion — règle des 4-2-1 : 4 mL/kg/h pour les 10 premiers kg, + 2 mL/kg/h pour les 10 kg suivants, + 1 mL/kg/h pour les 10 kg suivants (soit 65 mL/h pour un enfant de 25 kg par exemple).', 'Accord fort', '2.1 — Prise en charge anesthésique des patients'),
  ('MG-ANES-000073-R32', 'Il est recommandé d''utiliser un dispositif médical de contrôle du débit de perfusion.', 'Accord fort', '2.1 — Prise en charge anesthésique des patients'),
  ('MG-ANES-000073-R33', 'L''administration peropératoire de dexaméthasone est recommandée car elle réduit l''incidence des NVPO et le délai avant la reprise alimentaire.', 'Grade B', '2.1 — Prise en charge anesthésique des patients'),
  ('MG-ANES-000073-R34', 'L''administration d''une antibioprophylaxie peropératoire n''a pas démontré son intérêt, et ne s''impose donc pas systématiquement.', 'Accord fort', '2.1 — Prise en charge anesthésique des patients'),
  ('MG-ANES-000073-R35', 'L''amygdalectomie chez l''enfant requiert une anesthésie générale balancée impliquant une protection des voies aériennes.', 'Accord fort', '2.2 — Modalités de contrôle des voies aériennes'),
  ('MG-ANES-000073-R36', 'Le contrôle optimal des voies aériennes est assuré par une sonde d''intubation trachéale à ballonnet.', 'Accord fort', '2.2 — Modalités de contrôle des voies aériennes'),
  ('MG-ANES-000073-R37', 'L''extubation est réalisée, en présence d''un médecin anesthésiste, au réveil complet de l''enfant, déterminé par l''ouverture des yeux à la demande.', 'Accord fort', '2.2 — Modalités de contrôle des voies aériennes'),
  ('MG-ANES-000073-R38', 'La surveillance en SSPI doit être systématique.', 'Accord fort', '3.1 — Modalités de surveillance postopératoire'),
  ('MG-ANES-000073-R39', 'En plus de la surveillance habituelle, le dépistage et le traitement éventuel des complications respiratoires et hémorragiques est indispensable.', 'Accord fort', '3.1 — Modalités de surveillance postopératoire'),
  ('MG-ANES-000073-R40', 'La surveillance en SSPI peut être prolongée chez les jeunes enfants opérés dans un contexte de SAOS grave.', 'Accord fort', '3.1 — Modalités de surveillance postopératoire'),
  ('MG-ANES-000073-R41', 'La sortie de SSPI est autorisée après vérification des critères habituels (respiration, état hémodynamique, conscience, douleur, NVPO) et vérification de l''absence de saignement pharyngé par le chirurgien.', 'Accord fort', '3.1 — Modalités de surveillance postopératoire'),
  ('MG-ANES-000073-R42', 'Les apports hydroélectrolytiques postopératoires reposent sur un soluté isotonique en sel, pouvant contenir une faible concentration de glucose.', 'Accord fort', '3.2 — Perfusion postopératoire, reprise des boissons et de l''alimentation'),
  ('MG-ANES-000073-R43', 'La perfusion est poursuivie jusqu''à la reprise efficace des boissons.', 'Accord fort', '3.2 — Perfusion postopératoire, reprise des boissons et de l''alimentation'),
  ('MG-ANES-000073-R44', 'En raison du risque hémorragique, la reprise de l''alimentation s''effectue 6 heures après la fin de l''intervention ; la reprise des liquides clairs est possible dès la 2e heure.', 'Accord fort', '3.2 — Perfusion postopératoire, reprise des boissons et de l''alimentation'),
  ('MG-ANES-000073-R45', 'Un régime alimentaire spécifique n''a pas fait la preuve de sa supériorité par rapport à une alimentation libre après amygdalectomie.', 'Grade C', '3.2 — Perfusion postopératoire, reprise des boissons et de l''alimentation'),
  ('MG-ANES-000073-R46', 'La douleur post-amygdalectomie est considérée comme une douleur forte à composante inflammatoire, durant en moyenne 8 jours (maximum les 3 premiers jours).', 'Accord fort', '3.3 — Modalités de l''analgésie postopératoire'),
  ('MG-ANES-000073-R47', 'L''évaluation et le traitement de la douleur doivent être systématiques, y compris à domicile.', 'Grade C', '3.3 — Modalités de l''analgésie postopératoire'),
  ('MG-ANES-000073-R48', 'L''utilisation du paracétamol doit être large, quasi-systématique ; les voies IV et orale sont les plus fiables.', 'Grade B', '3.3 — Modalités de l''analgésie postopératoire'),
  ('MG-ANES-000073-R49', 'Seule la morphine est efficace en monothérapie, administrée par voie IV en SSPI ; elle est considérée comme l''antalgique de référence. Les autres analgésiques doivent être utilisés en association et en tenant compte de leur délai d''action.', 'Grade C', '3.3 — Modalités de l''analgésie postopératoire'),
  ('MG-ANES-000073-R50', 'La posologie de la morphine doit être réduite en cas de SAOS grave.', 'Accord fort', '3.3 — Modalités de l''analgésie postopératoire'),
  ('MG-ANES-000073-R51', 'Les antalgiques du palier II en association avec le paracétamol peuvent prendre le relais de la morphine IV. Leur administration par voie orale doit être débutée dès que possible.', 'Grade C', '3.3 — Modalités de l''analgésie postopératoire'),
  ('MG-ANES-000073-R52', 'Les AINS non sélectifs ne sont pas recommandés car ils peuvent s''associer à une augmentation de la fréquence des reprises chirurgicales pour saignement.', 'Accord faible', '3.3 — Modalités de l''analgésie postopératoire'),
  ('MG-ANES-000073-R53', 'Les principales complications primaires (avant la 24e heure) sont : les complications respiratoires, l''hémorragie et les nausées et vomissements.', 'Grade B', '4.1 — Principales complications postopératoires'),
  ('MG-ANES-000073-R54', 'Les principaux facteurs de risque de complications respiratoires sont : la gravité du SAOS et l''importance de la désaturation artérielle préopératoire.', 'Grade C', '4.1 — Principales complications postopératoires'),
  ('MG-ANES-000073-R55', 'Chez les patients atteints de SAOS, 70 % des complications respiratoires majeures surviennent dans la première heure postopératoire, alors que les complications mineures surviennent habituellement avant la 6e heure.', 'Grade C', '4.1 — Principales complications postopératoires'),
  ('MG-ANES-000073-R56', 'L''hémorragie postopératoire survient chez 0,5 à 3 % des patients.', 'Grade B', '4.1 — Principales complications postopératoires'),
  ('MG-ANES-000073-R57', '80 % des hémorragies primaires surviennent avant la 6e heure.', 'Grade B', '4.1 — Principales complications postopératoires'),
  ('MG-ANES-000073-R58', 'Environ 25 % des hémorragies postopératoires vont nécessiter une reprise chirurgicale.', 'Grade C', '4.1 — Principales complications postopératoires'),
  ('MG-ANES-000073-R59', 'Les patients nécessitant une reprise chirurgicale pour hémostase doivent être considérés comme ayant l''estomac plein et justifient une induction en séquence rapide.', 'Accord fort', '4.1 — Principales complications postopératoires'),
  ('MG-ANES-000073-R60', 'Après amygdalectomie, on observe des nausées et vomissements chez 40 à 70 % des patients.', 'Grade C', '4.2 — Nausées et vomissements postopératoires (NVPO)'),
  ('MG-ANES-000073-R61', 'L''utilisation peropératoire de protoxyde d''azote ne modifie pas l''incidence des NVPO.', 'Grade C', '4.2 — Nausées et vomissements postopératoires (NVPO)'),
  ('MG-ANES-000073-R62', 'Les NVPO sont moins fréquentes après injection peropératoire de propofol.', 'Grade C', '4.2 — Nausées et vomissements postopératoires (NVPO)'),
  ('MG-ANES-000073-R63', 'L''administration prophylactique IV de sétron réduit significativement l''incidence des NVPO après amygdalectomie chez l''enfant.', 'Grade C', '4.2 — Nausées et vomissements postopératoires (NVPO)'),
  ('MG-ANES-000073-R64', 'La dexaméthasone réduit significativement l''incidence des NVPO, et potentialise l''efficacité des sétrons.', 'Grade C', '4.2 — Nausées et vomissements postopératoires (NVPO)'),
  ('MG-ANES-000073-R65', 'Des protocoles de prise en charge des NVPO doivent être prévus et accessibles en SSPI.', 'Accord fort', '4.2 — Nausées et vomissements postopératoires (NVPO)'),
  ('MG-ANES-000073-R66', 'La réalisation de l''amygdalectomie en ambulatoire est possible si : - l''enfant est âgé de plus de 3 ans ; | - il n''existe pas de comorbidité majorant notamment le risque respiratoire ; | - il n''existe pas d''anomalie de l''hémostase ; | - il n''existe pas de syndrome d''apnée du sommeil grave ; | - les critères habituels de proximité et d''entourage familial sont satisfaits ; | - et sous réserve d''un consensus entre le chirurgien, l''anesthésiste et les parents.', 'Accord fort', 'Question 5 — Conditions requises pour l''amygdalectomie en ambulatoire'),
  ('MG-ANES-000073-R67', 'L''intervention doit être réalisée le plus tôt possible dans la matinée afin de permettre la sortie après une surveillance postopératoire de 6 heures.', 'Accord fort', 'Question 5 — Conditions requises pour l''amygdalectomie en ambulatoire'),
  ('MG-ANES-000073-R68', 'La gestion anesthésique doit privilégier la prévention des NVPO, et l''anticipation peropératoire de l''analgésie postopératoire.', 'Accord fort', 'Question 5 — Conditions requises pour l''amygdalectomie en ambulatoire'),
  ('MG-ANES-000073-R69', 'Le relais antalgique oral devrait être débuté avant la sortie du patient.', 'Accord fort', 'Question 5 — Conditions requises pour l''amygdalectomie en ambulatoire'),
  ('MG-ANES-000073-R70', 'Il est recommandé de remettre aux parents un document avec les coordonnées de la personne à contacter en cas de difficultés, ainsi que l''ordonnance d''antalgiques de sortie.', 'Accord fort', 'Question 5 — Conditions requises pour l''amygdalectomie en ambulatoire'),
  ('MG-ANES-000073-R71', 'La sortie de l''enfant est autorisée après la 6e heure postopératoire, si les critères suivants sont réunis : - absence de saignement au niveau des loges amygdaliennes, confirmée par le chirurgien ; | - absence de douleur ; | - absence de NVPO ; | - accord signé du chirurgien et de l''anesthésiste.', 'Accord fort', 'Question 5 — Conditions requises pour l''amygdalectomie en ambulatoire'),
  ('MG-ANES-000073-R72', 'Un suivi téléphonique du patient à domicile à la 24e heure est souhaitable, car il améliore la qualité de la prise en charge.', 'Accord fort', 'Question 5 — Conditions requises pour l''amygdalectomie en ambulatoire')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/anesthesie-pour-amygdalectomie-chez-lenfant/'
on conflict (recommendation_code) do nothing;
