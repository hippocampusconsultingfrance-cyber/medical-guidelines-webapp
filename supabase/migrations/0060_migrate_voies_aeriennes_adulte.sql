-- Migration : Prise en charge des voies aériennes en anesthésie adulte, à
-- l'exception de l'intubation difficile — Conférence de Consensus SFAR,
-- Recommandations du Jury, texte court, 2002 (publié Ann Fr Anesth Réanim
-- 2003;22:745-749). Label de qualité Anaes. Source :
-- rfe-sfar-website/build/content_voies_aeriennes_adulte.json (fiche 60/160
-- du corpus rfe-sfar-website — voir aussi son fiche_voies_aeriennes_adulte.py
-- pour la construction/l'audit de ce contenu).
--
-- CHAMP — exclusions explicites de la source elle-même (jamais migrées comme
-- si couvertes) : médecine extrahospitalière, urgence médicale hospitalière,
-- anesthésie pédiatrique, ventilation à poumons séparés, et l'intubation
-- difficile elle-même (déjà couverte par `intubation_difficile_adulte`/0027
-- dans ce projet).
--
-- MÉTHODOLOGIE — échelle ANAES A à E (PAS GRADE 1+/2+, PAS RAND/UCLA),
-- explicitement définie par la source elle-même (contrairement à `hsa`/0023
-- où les lettres D/E n'étaient pas définies par le texte court) :
-- A = 2 études ou plus de niveau de preuve I ; B = une étude de niveau I ;
-- C = étude(s) de niveau II ; D = une étude ou plus de niveau III ;
-- E = étude(s) de niveau IV ou V. `grade` reproduit la lettre source telle
-- quelle ; `evidence_level` laissé NULL (l'échelle ANAES est un axe unique,
-- contrairement aux grilles SRLF Preuve/Force à deux axes de
-- asthme_aigu_grave/0013 ou civd/0015).
--
-- COMPTAGE — reconcilié via un script Python dédié (regex sur le texte
-- source aplati, contournant le piège des coupures de ligne PDF qu'un grep
-- naïf ne détecte que 49/53 fois — détaillé dans le docstring de
-- fiche_voies_aeriennes_adulte.py côté rfe-sfar-website) : 53 citations
-- « (Grade X) » explicites — 2×A, 1×B, 10×C, 14×D, 26×E — toutes les 53
-- migrées ici, une ligne chacune, aucune fusionnée ni omise.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Deux cellules du contenu construit (Q4.15, Q5.10) associaient, dans la
--    MÊME cellule de tableau PDF, l'énoncé gradé et une phrase de contexte
--    explicitement NON gradée par la source (esmolol 100 mg pour Q4.15 ;
--    absence d'étude sur le tube laryngé pour Q5.10) — ces deux asides ne
--    portent aucun grade dans la source et ne sont donc PAS des
--    recommandations distinctes : migrées uniquement pour leur clause gradée
--    (R31/R41 ci-dessous), l'aside non gradé n'est pas reproduit comme ligne
--    séparée (cohérent avec le principe du projet : jamais de grade inventé
--    ni de ligne sans base source graduée).
-- 2. Seule la SFAR (organisatrice) liée en document_societies. La source
--    précise que l'Anaes a attribué son label de qualité à la conférence
--    (méthodologie), mais l'Anaes n'est ni auteure ni signataire du texte au
--    sens société savante — non ajoutée en document_societies pour cette
--    raison, et de toute façon absente du seed Annexe B.
-- 3. Document de 2002 (texte imprimé 2003) : le contenu construit
--    disclose lui-même, dans son propre panneau d'avertissement, que les
--    pratiques et le matériel ont évolué depuis (vidéolaryngoscopie,
--    oxygénation apnéique, dispositifs supraglottiques de 2e génération).
--    `freshness_status` mis à 'revision_detectee' (même pattern que
--    `hsa`/0023, `eclsa`/0019, `glycemie`/0022) malgré `library_final.json`
--    "en vigueur" — divergence disclosée, pas résolue unilatéralement.
-- 4. `population` laissé NULL sur toutes les lignes : document à population
--    unique (adulte, hors pédiatrie explicitement exclue au niveau document)
--    — même convention que `voies_aeriennes_enfant`/0059,
--    `preeclampsie`/0038, `urgences_obstetricales`/0057.
-- 5. Au moment de la rédaction de cette migration, le site publié
--    (Artifact medical-guidelines.net côté rfe-sfar-website) contenait DÉJÀ
--    une fiche `voies_aeriennes_adulte` construite indépendamment pour ce
--    même document par une session non tracée dans git (même URL source,
--    même tally 53/2A-1B-10C-14D-26E) — voir la note "KNOWN DRIFT" ajoutée
--    dans `rfe-sfar-website/CLAUDE.md` le même jour. Cette migration-ci
--    utilise le contenu de CE dépôt (`content_voies_aeriennes_adulte.json`,
--    construit et audité dans cette session), pas celui du site publié —
--    signalé ici au cas où un relecteur comparerait les deux plus tard.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge des voies aériennes en anesthésie adulte à l''exception de l''intubation difficile',
  'CC', 'fr', '2002-01-01',
  'https://sfar.org/prise-en-charge-des-voies-aeriennes-en-anesthesie-adulte-a-lexception-de-lintubation-difficile/',
  'https://sfar.org/wp-content/uploads/2016/12/1-2a_SFAR_Texte-court-Controle-des-voies-aeriennes-en-anesthesie-en-dehors-de-l-intubation-difficile.pdf',
  'Échelle ANAES A à E (niveau de preuve, axe unique) explicitement définie par la source : A = 2+ études niveau I ; B = 1 étude niveau I ; C = étude(s) niveau II ; D = 1+ étude niveau III ; E = étude(s) niveau IV/V. Comptage exhaustif (script Python dédié, texte aplati) : 53 citations « (Grade X) » — 2×A, 1×B, 10×C, 14×D, 26×E — toutes migrées.',
  'revision_detectee'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-des-voies-aeriennes-en-anesthesie-adulte-a-lexception-de-lintubation-difficile/'
  and s.acronym in ('SFAR') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-des-voies-aeriennes-en-anesthesie-adulte-a-lexception-de-lintubation-difficile/'
  and s.slug in ('anesthesie_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/prise-en-charge-des-voies-aeriennes-en-anesthesie-adulte-a-lexception-de-lintubation-difficile/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000060-R01', 'La recherche de critères anatomiques, pathologiques et anamnestiques est recommandée pour prédire une intubation difficile (ID) : l''association de plusieurs items améliore la prédictibilité par rapport à un critère isolé.', 'D', 'Question 1 — Critères ID/VMD (Réf. Q1.1)'),
  ('MG-ANES-000060-R02', 'Trois critères anatomiques sont recherchés en priorité pour prédire une ID : classe de Mallampati > 2, distance thyromentale < 65 mm, ouverture de bouche < 35 mm — complétés en consultation d''anesthésie par la proéminence des incisives supérieures, la mobilité mandibulaire (sub-luxation) et la mobilité cervicale (flexion/extension 80-100° ou < 80°).', 'D', 'Question 1 — Critères ID/VMD (Réf. Q1.2)'),
  ('MG-ANES-000060-R03', 'Cinq critères prédictifs de ventilation au masque difficile (VMD) sont recherchés en consultation d''anesthésie : âge > 55 ans, IMC > 26 kg/m², édentation, ronflements, barbe (+ anomalies morphologiques faciales). En leur absence, une ventilation au masque facile est hautement probable.', 'D', 'Question 1 — Critères ID/VMD (Réf. Q1.3)'),
  ('MG-ANES-000060-R04', 'La détection combinée des facteurs d''ID et de VMD est recommandée, leur association identifiant les situations les plus critiques en termes de morbidité liée à l''anesthésie.', 'E', 'Question 1 — Critères ID/VMD (Réf. Q1.4)'),
  ('MG-ANES-000060-R05', 'Choisir la plus petite taille de sonde d''intubation compatible avec une ventilation efficace sans fuite, en respectant les limites de pression du ballonnet. Tailles habituelles : 6,5-7-7,5 mm chez la femme, 7-7,5-8 mm chez l''homme.', 'E', 'Question 2 — Matériel, alternatives à la sonde d''intubation (Réf. Q2.1)'),
  ('MG-ANES-000060-R06', 'Masque facial, masque laryngé et tube laryngé sont des alternatives à l''intubation trachéale, en l''absence de risque de régurgitation.', 'E', 'Question 2 — Matériel, alternatives à la sonde d''intubation (Réf. Q2.2)'),
  ('MG-ANES-000060-R07', 'La ventilation spontanée pendant 3 minutes à FiO2 = 1 est la méthode de référence de pré-oxygénation.', 'C', 'Question 3 — Pré-oxygénation (Réf. Q3.1)'),
  ('MG-ANES-000060-R08', 'D''autres méthodes ont été proposées pour raccourcir la pré-oxygénation (4 manœuvres consécutives de capacité vitale ; 8 respirations profondes en 1 min), mais restent difficiles à réaliser en pratique.', 'D', 'Question 3 — Pré-oxygénation (Réf. Q3.2)'),
  ('MG-ANES-000060-R09', 'Quelle que soit la méthode utilisée, le matériel de pré-oxygénation doit être adapté et étanche, en particulier au niveau du masque facial.', 'D', 'Question 3 — Pré-oxygénation (Réf. Q3.3)'),
  ('MG-ANES-000060-R10', 'La pré-oxygénation est impérative en cas de risque de désaturation avant la sécurisation des voies aériennes : séquence d''induction rapide, critères de VMD ou d''ID, diminution de la capacité résiduelle fonctionnelle.', 'E', 'Question 3 — Pré-oxygénation (Réf. Q3.4)'),
  ('MG-ANES-000060-R11', 'En dehors des situations à risque de désaturation, une oxygénation préalable est recommandée pour se prémunir d''un risque d''hypoxie en cas de VMD ou d''ID non prévues.', 'E', 'Question 3 — Pré-oxygénation (Réf. Q3.5)'),
  ('MG-ANES-000060-R12', 'Le monitorage de la fraction télé-expiratoire d''O2 (FETO2) est recommandé pendant la pré-oxygénation — la SpO2 seule ne permet pas d''en apprécier correctement l''efficacité.', 'E', 'Question 3 — Pré-oxygénation (Réf. Q3.6)'),
  ('MG-ANES-000060-R13', 'Il est important de poursuivre la pré-oxygénation au-delà de l''obtention d''une FETO2 > 90 % (témoin d''une dénitrogénation optimale, mais pas des réserves tissulaires en O2).', 'E', 'Question 3 — Pré-oxygénation (Réf. Q3.7)'),
  ('MG-ANES-000060-R14', 'Il est recommandé d''identifier en consultation d''anesthésie les facteurs de risque de désaturation/VMD/ID et de déterminer une stratégie d''oxygénation adaptée, avec des techniques alternatives en cas d''échec.', 'E', 'Question 3 — Pré-oxygénation (Réf. Q3.8)'),
  ('MG-ANES-000060-R15', 'Des manœuvres simples (extension de la tête, sub-luxation antérieure de la mandibule, canule de Guedel) permettent d''améliorer la perméabilité des voies aériennes supérieures, modifiée par les agents anesthésiques.', 'E', 'Question 3 — Pré-oxygénation (Réf. Q3.9)'),
  ('MG-ANES-000060-R16', 'La ventilation au masque doit s''effectuer à des pressions d''insufflation < 25 cmH2O (risque d''insufflation gastrique) ; il est recommandé de contrôler ces pressions pendant la ventilation au masque.', 'C', 'Question 3 — Pré-oxygénation (Réf. Q3.10)'),
  ('MG-ANES-000060-R17', 'L''utilisation d''un curare améliore les conditions de l''intubation trachéale, sous réserve d''une dose suffisante (≥ 2 DA95) et du respect du délai d''installation de l''effet maximal.', 'A', 'Question 4 — Agents d''induction, intubation avec curare (Réf. Q4.1)'),
  ('MG-ANES-000060-R18', 'Le délai d''installation de l''effet maximal d''un curare est estimé au mieux par le monitorage de la curarisation.', 'A', 'Question 4 — Agents d''induction, intubation avec curare (Réf. Q4.2)'),
  ('MG-ANES-000060-R19', 'En présence d''un curare, les conditions d''intubation sont toujours bonnes ; la réaction somatique et neurovégétative à l''intubation, marquée en l''absence de morphinique, peut être diminuée par un morphinique à dose modérée.', 'C', 'Question 4 — Agents d''induction, intubation avec curare (Réf. Q4.3)'),
  ('MG-ANES-000060-R20', 'En administration en bolus, la séquence des 3 agents (hypnotique / morphinique / curare) doit être synchronisée pour que leurs pics d''action coïncident au moment de la stimulation de l''intubation.', 'E', 'Question 4 — Agents d''induction, intubation avec curare (Réf. Q4.4)'),
  ('MG-ANES-000060-R21', 'L''association thiopental-succinylcholine reste le protocole de référence de l''induction en séquence rapide.', 'C', 'Question 4 — Agents d''induction, intubation avec curare (Réf. Q4.5)'),
  ('MG-ANES-000060-R22', 'Si un morphinique est utilisé lors d''une induction en séquence rapide, le choix d''un agent à délai et durée d''action courts paraît raisonnable.', 'E', 'Question 4 — Agents d''induction, intubation avec curare (Réf. Q4.6)'),
  ('MG-ANES-000060-R23', 'L''intubation sans curare peut être proposée lorsque la curarisation n''est pas nécessaire pour la chirurgie ; les conditions d''intubation dépendent alors de l''association hypnotique-morphinique.', 'C', 'Question 4 — Anesthésie IV pour intubation sans curare (Réf. Q4.7)'),
  ('MG-ANES-000060-R24', 'L''utilisation d''un hypnotique seul, sans curare ni morphinique, n''est pas recommandée pour l''intubation : elle nécessite des doses très élevées et offre des conditions d''intubation médiocres.', 'C', 'Question 4 — Anesthésie IV pour intubation sans curare (Réf. Q4.8)'),
  ('MG-ANES-000060-R25', 'L''association d''un morphinique rapproche les conditions d''intubation de celles obtenues avec succinylcholine, et diminue par exemple de moitié les doses de propofol nécessaires pour contrôler la réaction motrice à l''intubation.', 'C', 'Question 4 — Anesthésie IV pour intubation sans curare (Réf. Q4.9)'),
  ('MG-ANES-000060-R26', 'La concentration télé-expiratoire de sévoflurane n''est pas un estimateur fiable de la concentration cérébrale à l''induction (délai d''équilibration) ; elle doit être maintenue un délai suffisant avant de tenter l''intubation (> 6 min sous sévoflurane seul, réductible de 40 % par midazolam et/ou fentanyl).', 'E', 'Question 4 — Anesthésie IV pour intubation sans curare (Réf. Q4.10)'),
  ('MG-ANES-000060-R27', 'La curarisation n''est pas nécessaire pour l''insertion du masque laryngé, technique la plus utilisée en alternative à l''intubation.', 'E', 'Question 4 — Alternatives à l''intubation (Réf. Q4.11)'),
  ('MG-ANES-000060-R28', 'Le propofol est l''hypnotique IV de choix pour l''insertion du masque laryngé (dépression plus marquée des réflexes pharyngolaryngés que le thiopental) ; l''ajout d''une faible dose de morphinique améliore significativement le taux de succès et diminue d''1/3 la concentration cible de propofol en AIVOC.', 'D', 'Question 4 — Alternatives à l''intubation (Réf. Q4.12)'),
  ('MG-ANES-000060-R29', 'Le sévoflurane est le seul agent halogéné recommandé pour l''insertion du masque laryngé (faible solubilité, absence d''effet irritant sur les voies aériennes supérieures) ; MAC95 de l''ordre de 4 %.', 'E', 'Question 4 — Alternatives à l''intubation (Réf. Q4.13)'),
  ('MG-ANES-000060-R30', 'L''association d''un morphinique améliore les conditions d''insertion du masque laryngé par rapport au sévoflurane seul.', 'D', 'Question 4 — Alternatives à l''intubation (Réf. Q4.14)'),
  ('MG-ANES-000060-R31', 'L''efficacité de la lidocaïne IV pour limiter la réaction adrénergique à l''intubation est controversée.', 'E', 'Question 4 — Traitements annexes et symptomatiques (Réf. Q4.15 ; aside non gradé sur l''esmolol non repris, voir note À VÉRIFIER #1)'),
  ('MG-ANES-000060-R32', 'L''utilisation systématique et en première intention d''un coussin sous la nuque (flexion du cou) n''est pas justifiée, sauf chez les patients obèses ou présentant une limitation de la mobilité du rachis cervical.', 'B', 'Question 5 — Positionnement, techniques d''intubation (Réf. Q5.1)'),
  ('MG-ANES-000060-R33', 'L''intubation endotrachéale sous laryngoscopie directe par voie orale est la méthode de référence en anesthésie.', 'E', 'Question 5 — Positionnement, techniques d''intubation (Réf. Q5.2)'),
  ('MG-ANES-000060-R34', 'La manœuvre de Sellick (pression cricoïdienne) peut gêner l''exposition glottique en laryngoscopie directe.', 'D', 'Question 5 — Positionnement, techniques d''intubation (Réf. Q5.3)'),
  ('MG-ANES-000060-R35', 'La manœuvre « BURP » (déplacement postérieur puis céphalique du cartilage thyroïde) permet de diminuer l''incidence des laryngoscopies difficiles.', 'D', 'Question 5 — Positionnement, techniques d''intubation (Réf. Q5.4)'),
  ('MG-ANES-000060-R36', 'Le mandrin long est plus efficace que le mandrin court comme aide à l''intubation en cas de difficulté d''exposition (Cormack II-III) ; ces mandrins restent des « petits moyens » d''aide à l''intubation.', 'C', 'Question 5 — Positionnement, techniques d''intubation (Réf. Q5.5)'),
  ('MG-ANES-000060-R37', 'La mesure de la PETCO2 est la méthode de référence pour contrôler l''absence d''intubation œsophagienne ; les capnogrammes doivent être visualisés et stables sur au moins 6 cycles ventilatoires.', 'E', 'Question 5 — Contrôle de la position du tube et du ballonnet (Réf. Q5.6)'),
  ('MG-ANES-000060-R38', 'L''auscultation pulmonaire axillaire est le meilleur moyen de déceler une intubation sélective ; à renouveler après chaque changement de position du patient.', 'E', 'Question 5 — Contrôle de la position du tube et du ballonnet (Réf. Q5.7)'),
  ('MG-ANES-000060-R39', 'Si le ballonnet est gonflé à l''air chez un patient ventilé en O2/N2O, le monitorage de la pression du ballonnet (dégonflages itératifs si besoin) ou un système d''évacuation automatique du gaz en surpression est recommandé (lésions trachéales au-delà de 30 cmH2O).', 'C', 'Question 5 — Contrôle de la position du tube et du ballonnet (Réf. Q5.8)'),
  ('MG-ANES-000060-R40', 'Une pression de gonflage de 20 mmHg (≈ 27 cmH2O) assure une bonne protection des voies aériennes tout en restant sous la pression de perfusion de la muqueuse trachéale.', 'E', 'Question 5 — Contrôle de la position du tube et du ballonnet (Réf. Q5.9)'),
  ('MG-ANES-000060-R41', 'L''utilisation du masque laryngé (LMA) repose sur une analyse bénéfice-risque individuelle ; contre-indiquée en cas d''estomac plein, de risque de pression ventilatoire élevée, d''absence d''accès aux voies aériennes, d''antécédents de reflux gastro-œsophagien, et en chirurgie thoracique ou abdominale haute.', 'E', 'Question 5 — Dispositifs alternatifs (Réf. Q5.10 ; aside non gradé sur le tube laryngé non repris, voir note À VÉRIFIER #1)'),
  ('MG-ANES-000060-R42', 'Recherche systématique en consultation d''anesthésie d''une fragilité ou d''un mauvais état dentaire, avec utilisation d''une protection dentaire dans les cas à risque.', 'E', 'Question 6 — Lésions liées à l''intubation oro/nasotrachéale (Réf. Q6.1)'),
  ('MG-ANES-000060-R43', 'Choisir la sonde d''intubation de la plus petite taille possible, compte tenu des contraintes de ventilation ; en intubation nasotrachéale, rétraction muqueuse par un vasoconstricteur.', 'D', 'Question 6 — Lésions liées à l''intubation oro/nasotrachéale (Réf. Q6.2)'),
  ('MG-ANES-000060-R44', 'Limiter l''hyperextension du cou pour éviter les lésions trachéales.', 'E', 'Question 6 — Lésions liées à l''intubation oro/nasotrachéale (Réf. Q6.3)'),
  ('MG-ANES-000060-R45', 'Le dépistage des complications de l''intubation est clinique (douleur cervicale latéralisée, douleur thoracique à irradiation postérieure, dysphagie/odynophagie douloureuses, douleur à la palpation, crépitation cervicale, fièvre) : cette suspicion doit faire discuter l''arrêt de l''alimentation orale, une antibiothérapie, et un avis spécialisé.', 'E', 'Question 6 — Lésions liées à l''intubation oro/nasotrachéale (Réf. Q6.4)'),
  ('MG-ANES-000060-R46', 'Une dysphonie intense, persistant au-delà de 48 h, ou associée à une otalgie/odynophagie, doit conduire à une consultation ORL spécialisée à la recherche de lésions laryngées.', 'E', 'Question 6 — Lésions liées à l''intubation oro/nasotrachéale (Réf. Q6.5)'),
  ('MG-ANES-000060-R47', 'Avec le masque laryngé, s''assurer d''une anesthésie profonde et ne pas multiplier les essais d''insertion.', 'D', 'Question 6 — Lésions liées au masque laryngé (Réf. Q6.6)'),
  ('MG-ANES-000060-R48', 'Choisir une taille de masque laryngé appropriée.', 'D', 'Question 6 — Lésions liées au masque laryngé (Réf. Q6.7)'),
  ('MG-ANES-000060-R49', 'Utiliser la méthode d''insertion « coussinet semi-gonflé » du masque laryngé — qui majore cependant le risque de mauvais positionnement.', 'C', 'Question 6 — Lésions liées au masque laryngé (Réf. Q6.8)'),
  ('MG-ANES-000060-R50', 'Limiter la pression dans le ballonnet du masque laryngé.', 'D', 'Question 6 — Lésions liées au masque laryngé (Réf. Q6.9)'),
  ('MG-ANES-000060-R51', 'Le jeûne (abstention de liquide clair 2 h, de solides 6 h avant la chirurgie) reste l''attitude classique de prévention de l''inhalation bronchique, quel que soit le mode d''accès aux voies aériennes.', 'E', 'Question 6 — Prévention de l''inhalation bronchique (Réf. Q6.10)'),
  ('MG-ANES-000060-R52', 'Dans les situations prédisposant à l''inhalation, l''induction en séquence rapide associée à une pression cricoïdienne et à des préparations neutralisant l''acidité gastrique est recommandée.', 'D', 'Question 6 — Prévention de l''inhalation bronchique (Réf. Q6.11)'),
  ('MG-ANES-000060-R53', 'La protection des voies aériennes par le masque laryngé, supposée moins efficace que par la sonde endotrachéale, contre-indique son utilisation dans les situations à risque d''inhalation.', 'E', 'Question 6 — Prévention de l''inhalation bronchique (Réf. Q6.12)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-des-voies-aeriennes-en-anesthesie-adulte-a-lexception-de-lintubation-difficile/'
on conflict (recommendation_code) do nothing;
