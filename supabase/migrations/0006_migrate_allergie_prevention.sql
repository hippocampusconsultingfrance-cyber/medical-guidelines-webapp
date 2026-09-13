-- Migration : Prévention du risque allergique péranesthésique. Texte court (Sfar/SFA, RFE 2011)
-- Source : rfe-sfar-website/build/content_allergie_prevention.json (47 recommandations
-- atomiques identifiées à la lecture intégrale du texte, questions 1 à 5 — question 6
-- (traitement) volontairement PAS migrée, voir point 3 ci-dessous).
--
-- MÉTHODOLOGIE — PAS DE GRADE PAR RECOMMANDATION (disclosure explicite, déjà faite par le
-- contenu construit et auditée) : ce document (méthode GRADE modifiée, comité des
-- référentiels Sfar) attache des niveaux de preuve globale NP1 (forte) à NP4 (très faible)
-- à des CONSTATS DE L'ARGUMENTAIRE (épidémiologie, mécanismes) — PAS à la force d'une
-- recommandation individuelle. Recherche exhaustive sur l'intégralité du texte source pour
-- "Grade A/B/C" et "accord professionnel" : aucune occurrence. grade et evidence_level sont
-- donc laissés NULL sur les 47 lignes ci-dessous, conformément à la règle "jamais deviné,
-- jamais fabriqué" (1.3 du cahier des charges) — PAS une valeur par défaut, une absence
-- réelle et disclosée dans la source elle-même. Les citations NP, quand la source les
-- attache explicitement à l'énoncé d'une recommandation, sont conservées telles quelles À
-- L'INTÉRIEUR DU TEXTE de `statement` (entre parenthèses, à titre de citation de preuve —
-- jamais comme un grade structuré), exactement comme le fait déjà le contenu construit.
--
-- MÉTHODE D'ATOMISATION (structurellement différente de aap_urgence/aap_programmee, qui
-- ont des tableaux "Proposition | Accord" avec un chip par ligne) : ce document RFE
-- numérote lui-même officiellement une partie de ses propositions (repères "Sx.x.x",
-- reproduits par le contenu construit soit en tableau "Rep. | Recommandation / conduite
-- pratique", soit en paragraphe préfixé en gras "(Sx.x.x)") — chaque repère Sx.x.x du texte
-- source est traité ici comme 1 recommandation atomique, quelle que soit sa forme
-- grammaticale (y compris les items purement définitionnels comme S4.1.1-S4.1.5 : ce sont
-- des propositions numérotées par la RFE elle-même, pas une reformulation de ma part). Pour
-- le reste de la prose narrative SANS repère Sx.x.x (questions 1, 3(1/3), 3(2/3) hors
-- passages codés), les recommandations sont les phrases directives identifiées par les
-- marqueurs que le contenu construit énonce lui-même dans son panneau méthodologique
-- ("il faut", "il est recommandé de", "il est proposé de", "il ne faut pas", "il n'y a pas
-- lieu de" — recherche exhaustive de ces marqueurs sur l'intégralité du texte effectuée
-- avant d'écrire ce script) ; leur `source_section` ci-dessous le signale explicitement
-- ("sans repère source" / code entre parenthèses).
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. S4.1.1 à S4.1.5 (tableau "Patients à risque de réaction d'hypersensibilité") sont des
--    critères définitionnels (qui compte comme "patient à risque"), pas des phrases à
--    l'impératif — migrés comme recommandations atomiques individuelles car numérotés Sx.x.x
--    par la RFE elle-même (voir méthode d'atomisation ci-dessus), pas parce qu'ils
--    contiennent un verbe directif. Un relecteur pourrait légitimement préférer les
--    modéliser comme critères de `population` plutôt que comme recommandations à part
--    entière : choix laissé au relecteur humain, pas tranché unilatéralement ici.
-- 2. Plusieurs recommandations de la prose narrative (Q1, IgE spécifiques en Q3, conditions
--    requises des tests cutanés en Q3(2/3)) n'ont AUCUN repère Sx.x.x dans le texte source
--    tel que reproduit par le contenu construit — `source_section` le signale explicitement
--    ("sans repère source dans le texte reproduit") plutôt que d'inventer un numéro.
-- 3. Question 6 (traitement du choc anaphylactique) N'EST PAS migrée : le contenu construit
--    la présente lui-même explicitement comme un RÉSUMÉ avec renvoi ("cette section est
--    volontairement résumée... se référer à la fiche dédiée pour la prise en charge aiguë
--    du choc anaphylactique"), pas comme une reproduction intégrale du texte source à ce
--    point — migrer des recommandations atomiques à partir d'un résumé paraphrasé risquerait
--    de produire des `statement` qui ne sont pas la formulation du texte source lui-même.
--    Le traitement du choc sera à extraire de `Fiche_SFAR_Anaphylaxie_2025.pdf` (fiche
--    "anaphylaxie", pas encore migrée) le moment venu, qui le couvre intégralement et de
--    façon plus actuelle d'après le contenu construit lui-même.
-- 4. SFA (Société française d'allergologie, co-auteur de la RFE avec la Sfar) ne figure pas
--    dans le seed Annexe B (societies) : seule SFAR est liée en document_societies
--    ci-dessous, même cas de figure que aap_urgence/aap_programmee (GIHP/GFHT non liés).
-- 5. `library_final.json` ne donne que l'année de publication ("2011", pas de mois/jour) —
--    publication_date ci-dessous utilise 2011-01-01 par convention (même traitement que
--    transport_intrahospitalier, 0001), PAS une date exacte devinée.

insert into public.documents (title, doc_type, original_language, publication_date, doi, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prévention du risque allergique péranesthésique. Texte court',
  'RFE', 'fr', '2011-01-01',
  '10.1016/j.annfar.2010.12.002',
  'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Prevention-du-risque-allergique-peranesthesique.pdf',
  'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Prevention-du-risque-allergique-peranesthesique.pdf',
  'Méthode GRADE modifiée (comité des référentiels Sfar) : NP1 (forte) à NP4 (très faible), niveaux de preuve globale attachés aux constats de l''argumentaire — PAS un grade de force par recommandation (aucune occurrence de Grade A/B/C ni "accord professionnel" dans le texte source)',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Prevention-du-risque-allergique-peranesthesique.pdf'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Prevention-du-risque-allergique-peranesthesique.pdf'
  and s.slug in ('anesthesie_reanimation', 'allergologie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, condition_topic, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.condition_topic, v.population, v.source_section,
  'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Prevention-du-risque-allergique-peranesthesique.pdf',
  'draft'
from public.documents d, (values
  ('MG-ANES-000006-R01', 'L''exploration et la déclaration en pharmacovigilance ou matériovigilance des réactions d''hypersensibilité immédiate (HSI) doivent être systématiques.', 'Déclaration et vigilance', null, 'Question 1 — Réalité du risque (sans repère source dans le texte reproduit)'),
  ('MG-ANES-000006-R02', 'La constitution de réseaux de consultations spécialisées, d''observatoires et de registres des réactions d''HSI doit être encouragée.', 'Réseaux et registres', null, 'Question 1 — Réalité du risque (sans repère source dans le texte reproduit)'),
  ('MG-ANES-000006-R03', 'Tout patient présentant une réaction d''HSI péranesthésique doit bénéficier d''une investigation immédiate et à distance (type de réaction, agent causal, sensibilisation croisée éventuelle).', 'Investigation post-réaction', null, 'Question 3 (1/3) — Bilan diagnostique (sans repère source dans le texte reproduit)'),
  ('MG-ANES-000006-R04', 'L''anesthésiste-réanimateur doit : assurer la mise en œuvre des investigations en partenariat avec une consultation d''allergo-anesthésie ; informer le patient et remettre un courrier détaillé et une carte d''allergie provisoire ; déclarer l''accident au centre régional de pharmacovigilance (médicament suspecté) ou au responsable de matériovigilance de l''établissement (latex suspecté).', 'Devoirs de l''anesthésiste-réanimateur post-réaction', null, 'Question 3 (1/3) — Bilan diagnostique (sans repère source dans le texte reproduit)'),
  ('MG-ANES-000006-R05', 'Une augmentation franche de la tryptase sérique (> 25 microg/mL) est en faveur d''un mécanisme IgE-dépendant (NP2). Les concentrations restent normales ou peu augmentées dans les réactions cutanéomuqueuses (grade 1) et systémiques modérées (grade 2).', 'Tryptase sérique — interprétation', null, 'Question 3 (1/3), tableau des dosages biologiques (S3.3.2.1)'),
  ('MG-ANES-000006-R06', 'Délais optimaux de prélèvement de la tryptase : 15 à 60 minutes pour les grades 1-2 ; 30 minutes à 2 heures pour les grades 3-4. La positivité excède souvent 6 heures pour les grades sévères (NP3).', 'Tryptase sérique — délais de prélèvement', null, 'Question 3 (1/3), tableau des dosages biologiques (S3.3.2.2)'),
  ('MG-ANES-000006-R07', 'Le pic d''histamine plasmatique est observé dès la première minute suivant la réaction (d''autant plus élevé que la réaction est grave), avec une demi-vie d''élimination de 15 à 20 minutes (NP2).', 'Histamine plasmatique — cinétique', null, 'Question 3 (1/3), tableau des dosages biologiques (S3.3.3.2)'),
  ('MG-ANES-000006-R08', 'Délai idéal de prélèvement de l''histamine : < 15 min pour le grade 1, < 30 min pour le grade 2, < 2 h pour les réactions plus sévères.', 'Histamine plasmatique — délai de prélèvement', null, 'Question 3 (1/3), tableau des dosages biologiques (S3.3.3.3)'),
  ('MG-ANES-000006-R09', 'Il ne faut pas doser l''histamine plasmatique chez la femme enceinte à partir du 2e trimestre (synthèse placentaire de diamine oxydase) ni chez les patients sous héparine (augmentation de diamine oxydase proportionnelle à la dose).', 'Histamine plasmatique — contre-indications au dosage', 'Femme enceinte (>= 2e trimestre), patients sous héparine', 'Question 3 (1/3), tableau des dosages biologiques (S3.3.3.5)'),
  ('MG-ANES-000006-R10', 'En cas de décès, les prélèvements pour tryptase et IgE spécifiques doivent être pratiqués avant l''arrêt de la réanimation plutôt qu''en post-mortem (NP4) ; le prélèvement fémoral est recommandé (NP3).', 'Prélèvements en cas de décès', null, 'Question 3 (1/3), tableau des dosages biologiques (S3.5.4)'),
  ('MG-ANES-000006-R11', 'Seuls quelques antibiotiques sont dosables en IgE spécifiques (pénicilloyl G et V, amoxicilloyl, ampicilloyl, céfaclor) ; il ne faut pas les rechercher à titre systématique, et seul l''allergologue en charge du bilan est habilité à demander et interpréter ces dosages, compte tenu de leur sensibilité faible (NP2).', 'IgE spécifiques — dosage des antibiotiques', null, 'Question 3 (2/3, 3/3) — IgE spécifiques (sans repère source dans le texte reproduit)'),
  ('MG-ANES-000006-R12', 'Les tests cutanés doivent être effectués 4 à 6 semaines après la réaction, pour permettre la reconstitution des médiateurs dans les basophiles et mastocytes (NP3). En cas de nécessité, ils peuvent être réalisés plus précocement, mais cela accroît le risque de faux négatifs et seuls les résultats positifs sont alors pris en compte — ce bilan précoce ne se substitue pas au bilan réalisé après 4 à 6 semaines (NP4).', 'Délai de réalisation des tests cutanés', null, 'Question 3 (2/3) — Tests cutanés (S3.6.1)'),
  ('MG-ANES-000006-R13', 'Les tests cutanés ne peuvent être interprétés qu''en fonction de renseignements cliniques chronologiques et détaillés fournis par l''anesthésiste, idéalement avec copie de la feuille d''anesthésie et de SSPI ainsi que les résultats de tryptase/histamine. Conditions requises : consentement éclairé ; arrêt préalable des médicaments inhibant la réactivité cutanée (antihistaminiques, psychotropes) (NP2). Grossesse, jeune âge, bêta-bloquants (sauf pour les bêta-lactamines), corticoïdes oraux ou IEC ne sont PAS des contre-indications aux tests cutanés (NP3). Il est recommandé de tester l''ensemble des médicaments du protocole anesthésique, le latex et les autres produits périanesthésiques ; le choix se fait par le binôme allergologue-anesthésiste lors de la consultation d''allergo-anesthésie.', 'Conditions requises pour les tests cutanés', null, 'Question 3 (2/3) — Tests cutanés (sans repère source dans le texte reproduit)'),
  ('MG-ANES-000006-R14', 'Le site de réalisation des tests cutanés (dos, bras ou avant-bras) est indifférent à condition que l''interprétation du résultat tienne compte de la réactivité normale de la peau au site de réalisation du test et de la taille de la papule d''injection intradermique du produit à tester (NP2).', 'Site des tests cutanés', null, 'Question 3 (2/3) — Tests cutanés (S3.6.8.8)'),
  ('MG-ANES-000006-R15', 'Il faut réaliser les IDR en injectant dans le derme un volume de 0,03 à 0,05 mL de la solution commerciale diluée, afin d''obtenir une papule d''injection (PI) ayant au maximum 4 mm de diamètre.', 'Volume d''injection des IDR', null, 'Question 3 (2/3) — Tests cutanés (S3.6.8.10)'),
  ('MG-ANES-000006-R16', 'Il faut rechercher une sensibilisation croisée avec tous les autres curares commercialisés en cas de positivité à un curare (NP2), y compris avec les curares nouvellement commercialisés après une réaction anaphylactique prouvée lors d''une anesthésie antérieure (NP3).', 'Sensibilisation croisée entre curares', null, 'Question 3 (2/3) — Tests cutanés, autres points (S3.6.8.11 à S3.6.8.15)'),
  ('MG-ANES-000006-R17', 'En cas de réaction survenant plus de 24 heures après l''anesthésie, il est recommandé de réaliser des tests épicutanés (patch-tests) à lecture retardée (>= 48 h), notamment pour une symptomatologie à type d''eczéma : antibiotiques, produits de contraste iodés, allergènes de contact (métaux, caoutchouc, colorants, antiseptiques) (NP3).', 'Tests épicutanés à lecture retardée', null, 'Question 3 (2/3) — Tests cutanés, autres points (S3.6.8.11 à S3.6.8.15)'),
  ('MG-ANES-000006-R18', 'Il faut exclure le terme «douteux» des comptes rendus : la réponse est binaire (positif/négatif), à refaire à distance si nécessaire (NP4).', 'Compte rendu des tests cutanés', null, 'Question 3 (2/3) — Tests cutanés, autres points (S3.6.8.11 à S3.6.8.15)'),
  ('MG-ANES-000006-R19', 'Diagnostic d''allergie à un médicament/produit de l''anesthésie déjà établi par un bilan allergologique préalable.', 'Patients à risque de réaction d''hypersensibilité', null, 'Question 4 — Facteurs favorisants et bilan préanesthésique (S4.1.1)'),
  ('MG-ANES-000006-R20', 'Signes cliniques évocateurs d''une allergie lors d''une précédente anesthésie.', 'Patients à risque de réaction d''hypersensibilité', null, 'Question 4 — Facteurs favorisants et bilan préanesthésique (S4.1.2)'),
  ('MG-ANES-000006-R21', 'Manifestations cliniques lors d''une exposition au latex (NP2), quelles que soient les circonstances d''exposition.', 'Patients à risque de réaction d''hypersensibilité', null, 'Question 4 — Facteurs favorisants et bilan préanesthésique (S4.1.3)'),
  ('MG-ANES-000006-R22', 'Enfants multiopérés, notamment pour spina bifida ou myéloméningocèle (fréquence élevée de sensibilisation au latex, NP1, et d''HSI au latex, NP1).', 'Patients à risque de réaction d''hypersensibilité', 'Enfants multiopérés (spina bifida, myéloméningocèle)', 'Question 4 — Facteurs favorisants et bilan préanesthésique (S4.1.4)'),
  ('MG-ANES-000006-R23', 'Manifestations à l''ingestion d''avocat, kiwi, banane, châtaigne, sarrasin, etc., ou exposition au Ficus benjamina (fréquence élevée de sensibilisation croisée avec le latex, NP2).', 'Patients à risque de réaction d''hypersensibilité', null, 'Question 4 — Facteurs favorisants et bilan préanesthésique (S4.1.5)'),
  ('MG-ANES-000006-R24', 'Dans la population générale, il n''y a pas lieu de pratiquer avant une anesthésie un dépistage systématique d''une sensibilisation aux médicaments/produits utilisés en anesthésie : les valeurs prédictives positive et négative des tests dans la population générale ne sont pas suffisamment connues, et une valeur faussement positive peut avoir des conséquences néfastes (changement de technique non nécessairement adapté) — le rapport bénéfice/risque d''un tel dépistage est inconnu.', 'Dépistage systématique — non recommandé', 'Population générale', 'Question 4 — Facteurs favorisants et bilan préanesthésique (S4.2.2)'),
  ('MG-ANES-000006-R25', 'Chez les patients atopiques ou allergiques à un médicament non utilisé en anesthésie, il n''y a pas lieu de rechercher une sensibilisation aux produits anesthésiques.', 'Dépistage systématique — non recommandé', 'Patients atopiques ou allergiques à un médicament non utilisé en anesthésie', 'Question 4 — Facteurs favorisants et bilan préanesthésique (S4.2.3)'),
  ('MG-ANES-000006-R26', 'Chez les patients à risque, il faut proposer des investigations allergologiques avant toute anesthésie ; au-delà de 6 mois après la réaction, le risque de faux négatif existe. Investigations : patients avec allergie déjà diagnostiquée (S4.1.1) — conserver les conclusions du bilan antérieur, tester les curares nouvellement commercialisés en cas d''allergie aux curares ; patients avec signes cliniques évocateurs lors d''une anesthésie précédente (S4.1.2) — en situation réglée, rechercher le protocole suspect et le transmettre à l''allergologue (protocole inconnu : tester tous les curares et le latex ; protocole identifié : tester les médicaments du protocole ancien et le latex, avec test de réintroduction pour les anesthésiques locaux après tests cutanés négatifs) ; en situation d''urgence, exclure le latex de l''environnement et utiliser une anesthésie locorégionale ou générale évitant curares et histaminolibérateurs (NP4) ; patients à risque au latex (S4.1.3-S4.1.5) — pricks au latex + IgE spécifiques du latex.', 'Investigations allergologiques préanesthésiques', 'Patients à risque (S4.1.1 à S4.1.5)', 'Question 4 — Facteurs favorisants et bilan préanesthésique (S4.2.4)'),
  ('MG-ANES-000006-R27', 'HSI suspectée à un AINS non sélectif. Non urgent : bilan allergologique hospitalier avec tests de réintroduction réalistes. Urgence : pas d''anti-COX-1 ; anti-COX-2 utilisables (célécoxib, parécoxib) ; paracétamol possible à dose réduite (effet anti-COX-1 à fortes doses) (NP2).', 'HSI suspectée à un AINS non sélectif', null, 'Question 4 — Situations particulières et demande de bilan allergologique (S4.3)'),
  ('MG-ANES-000006-R28', 'HSI suspectée au paracétamol. Intervention non urgente : bilan en milieu hospitalier spécialisé avec tests de réintroduction réalistes.', 'HSI suspectée au paracétamol', null, 'Question 4 — Situations particulières et demande de bilan allergologique (S4.3)'),
  ('MG-ANES-000006-R29', 'Réaction à la morphine ou à la codéine : ne pas réinjecter morphine ou codéine ; tous les autres morphiniques sont utilisables.', 'Réaction à la morphine ou à la codéine', null, 'Question 4 — Situations particulières et demande de bilan allergologique (S4.3)'),
  ('MG-ANES-000006-R30', 'Allergie alimentaire à l''œuf ou au soja : propofol utilisable chez l''allergique à l''œuf (un seul cas rapporté) ; l''huile purifiée de soja de l''excipient ne contre-indique pas le propofol en cas d''allergie au soja (NP4).', 'Allergie alimentaire à l''œuf ou au soja', null, 'Question 4 — Situations particulières et demande de bilan allergologique (S4.3)'),
  ('MG-ANES-000006-R31', 'Allergie aux fruits de mer ou au poisson : l''allergène en cause n''étant pas l''iode, médicaments et badigeons iodés ne sont pas contre-indiqués (NP3).', 'Allergie aux fruits de mer ou au poisson', null, 'Question 4 — Situations particulières et demande de bilan allergologique (S4.3)'),
  ('MG-ANES-000006-R32', 'Allergie documentée à la protamine : contre-indication à la protamine. Un cas rapporté chez un allergique au poisson, mais une revue récente de la littérature ne justifie pas son éviction en cas d''allergie au poisson (NP2).', 'Allergie documentée à la protamine', null, 'Question 4 — Situations particulières et demande de bilan allergologique (S4.3)'),
  ('MG-ANES-000006-R33', 'La prévention primaire d''une sensibilisation correspond à la non-exposition au médicament ou au matériau. Impossible pour les agents anesthésiques, mais réalisable pour certains matériaux comme le latex ; l''administration des curares doit être raisonnée, selon les indications de la curarisation (NP4).', 'Prévention primaire — principe', null, 'Question 5 — Prévention primaire (S5.1.1-2)'),
  ('MG-ANES-000006-R34', 'Il faut éviter l''exposition des patients au latex pour diminuer le risque de sensibilisation. La décision institutionnelle de travailler en ambiance «latex-free» est une prévention primaire efficace (NP1).', 'Prévention primaire — latex', null, 'Question 5 — Prévention primaire (S5.1.3)'),
  ('MG-ANES-000006-R35', 'La meilleure prévention secondaire est la non-administration du médicament auquel le sujet est sensibilisé ; il faut déterminer l''allergène responsable pour éviter une récidive lors d''une utilisation ultérieure (NP2).', 'Prévention secondaire — principe', null, 'Question 5 — Prévention secondaire (S5.2.1)'),
  ('MG-ANES-000006-R36', 'Facteurs de risque de sensibilisation au latex : terrain atopique, exposition professionnelle ou non répétée au latex, malformations urinaires (spina bifida, vessie neurologique, etc.), malformations justifiant de multiples interventions.', 'Facteurs de risque de sensibilisation au latex', null, 'Question 5 — Prévention secondaire (S5.2.2)'),
  ('MG-ANES-000006-R37', 'Les patients sensibilisés au latex doivent être inscrits en première position sur le programme opératoire, dans un environnement exempt de latex ; il faut notifier la sensibilisation pendant tout le séjour hospitalier (service, bloc, SSPI) (NP3).', 'Organisation du programme opératoire — patients sensibilisés au latex', 'Patients sensibilisés au latex', 'Question 5 — Prévention secondaire (S5.2.3)'),
  ('MG-ANES-000006-R38', 'On peut utiliser un questionnaire préopératoire pour dépister la sensibilisation au latex lors de la consultation préanesthésique, ce qui pourrait réduire l''incidence des réactions au latex (NP4).', 'Questionnaire préopératoire de dépistage du latex', null, 'Question 5 — Prévention secondaire (S5.2.4)'),
  ('MG-ANES-000006-R39', 'En cas de suspicion de sensibilisation au latex, il faut adresser le patient en consultation d''allergologie en préopératoire (NP3).', 'Suspicion de sensibilisation au latex', null, 'Question 5 — Prévention secondaire (S5.2.5)'),
  ('MG-ANES-000006-R40', 'Il faut établir des listes, régulièrement mises à jour, des matériels contenant du latex dans chaque service d''anesthésie-réanimation, en collaboration avec la pharmacie (NP3).', 'Listes des matériels contenant du latex', null, 'Question 5 — Prévention secondaire (S5.2.6)'),
  ('MG-ANES-000006-R41', 'Il ne faut pas faire de recherche systématique préanesthésique d''une sensibilisation en dehors des patients à risque (NP2).', 'Recherche systématique — non recommandée', null, 'Question 5 — Prévention secondaire (S5.2.7)'),
  ('MG-ANES-000006-R42', 'Il faut adresser en consultation d''allergologie, avant une anesthésie, les patients à risque de réaction allergique aux médicaments/matériaux périopératoires : réaction inexpliquée à un allergène non identifié lors d''une anesthésie antérieure, ou sujets allergiques connus à une classe de médicaments à utiliser, ou à risque d''allergie au latex.', 'Consultation d''allergologie préanesthésique', 'Patients à risque de réaction allergique aux médicaments/matériaux périopératoires', 'Question 5 — Prévention secondaire (S5.2.8)'),
  ('MG-ANES-000006-R43', 'Il ne faut pas utiliser la méthode de la dose-test par voie intraveineuse pour détecter les sujets sensibilisés aux médicaments anesthésiques (NP4).', 'Dose-test intraveineuse — non recommandée', null, 'Question 5 — Prévention secondaire (S5.2.9)'),
  ('MG-ANES-000006-R44', 'Aucune prémédication n''est efficace pour prévenir une réaction d''HSI allergique.', 'Prémédication — absence d''efficacité démontrée', null, 'Question 5 — Prémédication (S5.3.1)'),
  ('MG-ANES-000006-R45', 'Il est recommandé d''administrer l''antibioprophylaxie préopératoire au bloc, chez un patient monitoré et éveillé, avant l''induction : l''imputabilité de l''antibiotique est plus facile à déterminer et la réanimation, sans médicament cardiovasculaire déjà reçu, est plus facile (NP4).', 'Administration de l''antibioprophylaxie', null, 'Question 5 — Anesthésie des patients allergiques (S5.4.1)'),
  ('MG-ANES-000006-R46', 'Le choix de la technique se fait selon le sujet et l''acte. En urgence, en l''absence de bilan allergologique, il faut privilégier les techniques locorégionales et les techniques générales évitant curares et histaminolibérateurs, en environnement sans latex (NP3).', 'Choix de la technique anesthésique en urgence', null, 'Question 5 — Anesthésie des patients allergiques (S5.4.2)'),
  ('MG-ANES-000006-R47', 'Le choix des agents se fait selon les données anamnestiques et les résultats du bilan allergologique (NP2) : les halogénés n''ont jamais été incriminés dans une HSI ; l''allergie au propofol et aux benzodiazépines est exceptionnelle ; les réactions aux opiacés (morphine, codéine) sont le plus souvent non allergiques ; tous les curares peuvent induire une HSI allergique — le choix se fait selon l''indication de la curarisation et les tests cutanés (NP3). En cas d''HSI allergique à un curare, il faut rechercher systématiquement une sensibilité croisée avec les autres curares disponibles pour proposer un curare pour les interventions ultérieures (NP3).', 'Choix des agents anesthésiques selon le bilan allergologique', null, 'Question 5 — Anesthésie des patients allergiques (S5.4.3)')
) as v(code, statement, condition_topic, population, source_section)
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Prevention-du-risque-allergique-peranesthesique.pdf'
on conflict (recommendation_code) do nothing;
