-- Migration : Prise en charge des infections intra-abdominales (IIA) — RFE
-- conjointe SFAR/SRLF/SPILF, en association avec deux sociétés savantes de
-- chirurgie digestive (AFC, SFCD — voir disclosure ci-dessous). Actualisation
-- 2015 de la Conférence de consensus SFAR de 2000 sur les péritonites
-- communautaires, étendue aux IIA pédiatriques et associées aux soins.
-- Champ : péritonites nécessitant une prise en charge chirurgicale — hors
-- champ, explicitement exclu par la source elle-même : infections primaires
-- des cirrhoses, infections focalisées isolées (biliaires, abcès hépatiques
-- isolés, sigmoïdites).
-- Source : rfe-sfar-website/build/content_infections_intra_abdominales.json
-- (44 recommandations finales numérotées R1-R44, réparties en 5
-- sous-sections normatives : communautaires/diagnostic R1-R8, communautaires/
-- antibiothérapie R9-R24, particularités pédiatriques R25-R27, associées aux
-- soins/diagnostic postopératoire R28-R37, associées aux soins/antibiothérapie
-- R38-R44). Extraction programmatique (script Python, pas de retranscription
-- manuelle) depuis le JSON source : les 44 lignes R1-R44 et leurs 5 tags de
-- grade (1+/1-/2+/2-/AE) ont été relus et comptés un par un par ce script,
-- zéro trou, zéro doublon de numéro (vérifié par assertion automatique).
--
-- DOUBLON POTENTIEL VÉRIFIÉ, AUCUN TROUVÉ : grep du dossier migrations/ pour
-- "intra-abdominal"/"péritonite"/"IIA" trouve des mentions dans
-- 0010_migrate_antibiotherapie_probabiliste.sql (R19-R21, section "4.6
-- Infections intra-abdominales communautaires et nosocomiales") et
-- 0050_migrate_traumatisme_abdominal.sql (une seule recommandation citant la
-- péritonite comme diagnostic différentiel d'une cœlioscopie post-trauma) —
-- ce sont deux documents SOURCE DIFFÉRENTS (0010 : "Antibiothérapie
-- probabiliste des états septiques graves", conférence d'experts SFAR 2004,
-- qui ne couvre les IIA que comme l'une de ses 12 sections par site
-- infectieux ; 0050 : traumatologie abdominale), pas une migration existante
-- de CE document (RFE SFAR/SRLF/SPILF/AFC/SFCD 2015 dédiée aux IIA). Aucun
-- chevauchement de source_url avec cette migration.
--
-- MÉTHODOLOGIE — GRADE standard + vote Delphi (PAS le schéma "accord fort
-- uniforme sans grade individuel" de brule_grave/0086, ni le schéma "aucun
-- grade du tout" de sauv/0084) : qualité des preuves en 4 catégories (Haute/
-- Modérée/Basse/Très basse) et force binaire — forte (1+/1−) ou faible
-- (2+/2−) — déterminée par vote Delphi (40 experts, 6 groupes de travail ;
-- 62 recommandations initiales → groupe de relecture de 38 médecins → 2
-- tours de cotation → 18 abandonnées/reformulées → 44 recommandations
-- finales, toutes votées à Accord fort). Chaque recommandation porte un
-- grade individuel (1+/1-/2+/2-/AE) — contrairement à brule_grave, ce
-- document COTE chaque énoncé séparément ; `grade` reprend donc ce tag exact
-- par ligne, jamais un accord global forcé.
-- `evidence_level` (catégorie de qualité de preuve Haute/Modérée/Basse/Très
-- basse) est laissé NULL sur les 44 lignes : le contenu source disponible
-- (content_infections_intra_abdominales.json) documente cette échelle au
-- niveau MÉTHODOLOGIQUE général (texte descriptif), mais ne l'attribue à
-- AUCUNE recommandation individuelle — seul le tag de force (1+/1-/2+/2-/AE)
-- est repris par recommandation dans le contenu construit. Absence réelle
-- documentée, pas une valeur par défaut.
--
-- ⚠️ DISCLOSURE — INCOHÉRENCE INTERNE DE LA SOURCE, NON RÉSOLUE (reproduite
-- telle quelle du contenu construit, qui l'a déjà relevée) : le texte source
-- affirme que parmi les 44 recommandations, « 10 sont fortes (Grade 1), 25
-- sont faibles (Grade 2) et ... 9 ... avis d'experts ». Un comptage direct
-- des 44 tags individuels de ce document (repris ici ligne par ligne, et
-- revérifié par le script d'extraction de cette migration) donne 11 Grade 1
-- (7×1+, 4×1−), 24 Grade 2 (19×2+, 5×2−) et 9 avis d'experts — soit
-- 11+24+9=44, donc le TOTAL et le compte « avis d'experts » concordent avec
-- la source, mais la répartition forte/faible qu'elle annonce (10/25) diffère
-- du tally direct (11/24). Aucune tentative n'est faite ici de deviner quelle
-- des deux valeurs (10 ou 11 ; 25 ou 24) est la "bonne" — les 44 grades
-- individuels stockés ci-dessous sont ceux effectivement imprimés en face de
-- chaque recommandation dans la source, qui priment sur le total résumé.
--
-- DISCLOSURE — CONTENU DÉLIBÉRÉMENT EXCLU DU MODÈLE recommendations (aucune
-- perte silencieuse ; raisons documentées) :
--  1. Les 3 algorithmes/figures du texte source (pages 97-99, purs schémas
--     boîtes/flèches sans couche texte, retranscrits en tableaux dans le
--     contenu construit après rendu visuel à 170dpi) ne sont PAS repris comme
--     recommandations distinctes : comparaison ligne à ligne confirmant
--     qu'ils ne font que représenter sous forme d'arbre de décision des
--     recommandations DÉJÀ numérotées R1-R44 ci-dessous (Figure 1 : R1/R3/R6 ;
--     Figure 2 : R15/R17/R18/R20/R21 ; Figure 3 : R15/R41/R42/R43) — aucun
--     énoncé clinique nouveau, donc aucune ligne recommendations dédiée (les
--     y dupliquer créerait un doublon de contenu, pas une couverture
--     supplémentaire).
--  2. Le tableau définissant une "péritonite grave" (≥ 2 critères parmi 7,
--     préambule méthodologique) est une DÉFINITION, pas un énoncé "il
--     faut/il est recommandé de" — non migré en `recommendations` (qui ne
--     porte que des actions/décisions atomiques), conformément au principe
--     "n'invente ni ne force un format sur du contenu qui n'en a pas".
--     Le contenu construit signale par ailleurs une coquille d'unité dans ce
--     même tableau source ("176,8 mmol/L"/"34,2 mmol/L" au lieu de µmol/L,
--     probable artefact d'extraction du symbole µ) — sans impact sur les 44
--     recommandations elles-mêmes, donc sans conséquence sur cette migration,
--     mais mentionné ici pour traçabilité complète de ce qui a été audité.
--  3. L'argumentaire discursif (statistiques d'études, références
--     bibliographiques détaillées derrière chaque recommandation) est
--     volontairement condensé dans le contenu construit lui-même aux seuls
--     seuils/schémas cliniquement actionnables (déjà repris dans les 44
--     `statement` ci-dessous) — pas de perte supplémentaire introduite par
--     cette migration.
--
-- SOURCE_URL / PDF_URL : `library_final.json` — recherche "intra-abdominal"/
-- "péritonite" sur title+href+direct_pdf_url donne EXACTEMENT 1 correspondance
-- (index 83 : "Prise en charge des infections intra-abdominales", year 2015,
-- exact_type RFE, status "en vigueur" — pas "abrogé"), dont le `href` et le
-- `direct_pdf_url` sont identiques à l'« URL source » citée par le contenu
-- construit lui-même. `exact_date` de library_final.json ne donne que
-- l'année ("2015") ; le contenu construit précise "Ann Fr Anesth Réanim,
-- tome 1, n°1, février 2015" (mois connu, jour inconnu) — `publication_date`
-- fixé au 1er du mois connu ('2015-02-01'), même convention que
-- 0010_migrate_antibiotherapie_probabiliste.sql pour une précision
-- incomplète (année seule là-bas -> 1er janvier ; ici année+mois -> 1er du
-- mois), documentée plutôt que silencieuse.
--
-- `document_societies` — sociétés co-auteures citées nommément par le
-- contenu construit via ses coordinateurs ("P. Montravers, H. Dupont, M.
-- Leone, J-M. Constantin, P-M. Mertes (Sfar/SRLF), P-F. Laterre, B. Misset
-- (SRLF), J-P. Bru, R. Gauzit, A. Sotto (SPILF), C. Brigand, A. Hamy (AFC),
-- J-J. Tuech (SFCD)") : SFAR, SRLF, SPILF, AFC (Association Française de
-- Chirurgie), SFCD (Société Française de Chirurgie Digestive) — 5 sociétés
-- au total, conforme à l'indice de la tâche ("au moins 2 autres sociétés
-- chirurgicales").
-- ⚠️ VÉRIFICATION EXPLICITE CONTRE LA LISTE COMPLÈTE DU SEED (Annexe B,
-- schema_v2.sql section 15, relue intégralement — pas un grep tronqué) :
-- SFAR ('SFAR','France'), SRLF ('SRLF','France') et SPILF ('SPILF','France')
-- SONT dans le seed. AFC et SFCD n'y figurent PAS — et ne doivent surtout
-- PAS être confondues avec 'SFC' (présente dans le seed sous ('SFC',
-- 'France')), qui est un acronyme distinct (société savante différente, non
-- documentée comme chirurgicale dans ce cahier des charges) : aucun lien
-- document_societies n'est créé vers 'SFC' au prétexte d'une ressemblance de
-- sigle avec 'SFCD'. AFC et SFCD restent donc de vraies sociétés
-- co-auteures de la source, correctement NON liées ici faute d'entrée seed
-- — à ajouter à `societies` lors d'une validation Annexe B ultérieure
-- (vetting_status), pas devinées ou approximées vers une entrée existante.
--
-- `document_specialties` : anesthesie_reanimation (SFAR, prise en charge
-- périopératoire/réanimation du patient grave — chirurgie et anesthésie sont
-- au cœur des R1-R8/R28-R37) ; medecine_intensive_reanimation (SRLF,
-- réanimation du sepsis/choc septique, critères de gravité et traitement du
-- patient grave dans R3/R6/R10/R15/R19-21/R38-42) ; infectiologie_maladies_
-- infectieuses_et_tropicales (SPILF, cœur du champ antibiothérapie
-- probabiliste/désescalade R9-R24 et R38-R44 — spécialité candidate
-- confirmée par lecture du contenu, présente dans la liste complète des
-- spécialités valides) ; chirurgie_digestive_et_viscerale (AFC/SFCD,
-- décisions de contrôle chirurgical de la source — laparoscopie/laparotomie,
-- relaparotomie, drainage R1-R8/R28-R37 — bien que ces 2 sociétés
-- elles-mêmes soient absentes du seed sociétés, la spécialité
-- "chirurgie_digestive_et_viscerale" EST présente dans la liste complète des
-- spécialités valides et correspond directement au contenu chirurgical du
-- texte, indépendamment du seed sociétés).
-- À VÉRIFIER : `chirurgie_pediatrique` et `pediatrie` n'ont volontairement
-- PAS été ajoutées malgré la sous-section pédiatrique dédiée (R25-R27,
-- 3/44 recommandations) — le contenu construit précise lui-même que ces 3
-- recommandations sont "majoritairement extrapolées des données adulte",
-- sans spécificité diagnostique propre à l'enfant ; ajouter une spécialité
-- entière pour 3/44 énoncés extrapolés a semblé disproportionné, mais ce
-- choix reste discutable et n'a pas été tranché avec le porteur de projet.
--
-- `population` : 'Enfant' uniquement sur R25-R27 (seule sous-section où la
-- source stratifie explicitement par âge — "Chez l'enfant..." / "...
-- pédiatrique...") ; NULL sur les 41 autres lignes, la source ne
-- distinguant pas explicitement adulte/enfant pour le reste du texte (pas
-- d'invention d'un "Adulte" implicite non écrit par la source).
--
-- SAFETY NET ANTI-GRADE-COMPOSÉ : `grep -n '"[12][+-]/[12][+-]'` (et son
-- équivalent en guillemets simples SQL) sur ce fichier ne doit renvoyer AUCUNE
-- correspondance — vérifié avant commit, voir note de fin de fichier.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge des infections intra-abdominales',
  'RFE', 'fr', '2015-02-01',
  'https://sfar.org/prise-en-charge-des-infections-intra-abdominales/',
  'https://sfar.org/wp-content/uploads/2015/09/2_AFAR_Prise-en-charge-des-infections-intra-abdominales.pdf',
  'GRADE standard (qualité des preuves Haute/Modérée/Basse/Très basse — non attribuée par recommandation individuelle dans le contenu source disponible ; force binaire forte 1+/1- ou faible 2+/2-, ou avis d''experts AE), déterminé par vote Delphi (40 experts, 6 groupes de travail, 2 tours de cotation). 62 recommandations initiales -> 44 recommandations finales, toutes votées à Accord fort. Disclosure : la source annonce une répartition 10 fortes/25 faibles/9 AE alors qu''un comptage direct des 44 tags individuels donne 11 fortes (7x1+, 4x1-)/24 faibles (19x2+, 5x2-)/9 AE (total 44 concordant) — incohérence interne non résolue, les grades individuels stockés priment sur le résumé chiffré de la source.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-des-infections-intra-abdominales/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'), ('SRLF', 'France'), ('SPILF', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-des-infections-intra-abdominales/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation',
                 'infectiologie_maladies_infectieuses_et_tropicales', 'chirurgie_digestive_et_viscerale')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.population, v.source_section,
  'https://sfar.org/prise-en-charge-des-infections-intra-abdominales/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000095-R01', 'Il ne faut probablement pas faire d''imagerie en cas de suspicion de péritonite par perforation d''organe chez un patient grave si celle-ci retarde la procédure chirurgicale.', 'AE', 'Indication de l''imagerie en cas de suspicion de péritonite', null, 'IIA communautaires — Diagnostic, contrôle de la source, R1'),
  ('MG-ANES-000095-R02', 'En cas de suspicion de péritonite par perforation d''ulcère gastroduodénal, l''indication opératoire peut être portée sur l''histoire clinique et la présence d''un pneumopéritoine sur un cliché d''abdomen sans préparation.', 'AE', 'Indication opératoire — perforation d''ulcère gastroduodénal', null, 'IIA communautaires — Diagnostic, contrôle de la source, R2'),
  ('MG-ANES-000095-R03', 'Il faut opérer le plus rapidement possible un patient suspect de péritonite par perforation d''organe, tout particulièrement en cas de choc septique.', '1+', 'Délai opératoire — péritonite par perforation d''organe', null, 'IIA communautaires — Diagnostic, contrôle de la source, R3'),
  ('MG-ANES-000095-R04', 'Il ne faut probablement pas utiliser la voie laparoscopique pour l''ulcère peptique perforé en péritonite chez un patient avec plus d''1 des facteurs suivants : choc à l''admission, score ASA III-IV, symptômes > 24 h (score de Boey).', '2-', 'Voie laparoscopique — ulcère peptique perforé, score de Boey', null, 'IIA communautaires — Diagnostic, contrôle de la source, R4'),
  ('MG-ANES-000095-R05', 'Il ne faut pas faire de voie d''abord laparoscopique en cas de péritonite stercorale d''origine diverticulaire (Hinchey IV) ou de péritonite généralisée.', '1-', 'Voie laparoscopique — péritonite stercorale diverticulaire ou généralisée', null, 'IIA communautaires — Diagnostic, contrôle de la source, R5'),
  ('MG-ANES-000095-R06', 'En l''absence d''instabilité hémodynamique (> 0,1 mg/kg/min adrénaline/noradrénaline), il faut probablement discuter en pluridisciplinaire le drainage radiologique percutané en 1re intention des abcès intra-abdominaux (sans signe de perforation) avec analyse microbiologique.', '2+', 'Drainage radiologique percutané des abcès intra-abdominaux', null, 'IIA communautaires — Diagnostic, contrôle de la source, R6'),
  ('MG-ANES-000095-R07', 'Il faut réaliser un contrôle du drainage par TDM en cas d''évolution défavorable.', '1+', 'Contrôle du drainage par TDM', null, 'IIA communautaires — Diagnostic, contrôle de la source, R7'),
  ('MG-ANES-000095-R08', 'Lorsque le traitement chirurgical a été jugé satisfaisant (contrôle de la source, lavage), il ne faut pas programmer systématiquement de relaparotomies.', '1-', 'Relaparotomies systématiques', null, 'IIA communautaires — Diagnostic, contrôle de la source, R8'),
  ('MG-ANES-000095-R09', 'Il faut probablement prélever les liquides péritonéaux pour identification microbienne et sensibilité aux anti-infectieux.', '2+', 'Prélèvement des liquides péritonéaux', null, 'IIA communautaires — Microbiologie et antibiothérapie, R9'),
  ('MG-ANES-000095-R10', 'Chez les patients en choc septique et/ou immunodéprimés, il faut réaliser des hémocultures et un examen direct du liquide péritonéal à la recherche de levures.', '1+', 'Hémocultures et recherche de levures — choc septique/immunodéprimés', null, 'IIA communautaires — Microbiologie et antibiothérapie, R10'),
  ('MG-ANES-000095-R11', 'Il faut établir les protocoles de traitement probabiliste sur la base de l''analyse régulière des données microbiologiques nationales/régionales de résistance.', '1+', 'Protocoles de traitement probabiliste — données de résistance locorégionales', null, 'IIA communautaires — Microbiologie et antibiothérapie, R11'),
  ('MG-ANES-000095-R12', 'Il ne faut probablement pas prendre en compte les E. coli résistants aux C3G sans signe de gravité, sauf résistance locorégionale > 10 % ou séjour en zone à forte prévalence de BMR.', '2-', 'Prise en compte des E. coli résistants aux C3G', null, 'IIA communautaires — Microbiologie et antibiothérapie, R12'),
  ('MG-ANES-000095-R13', 'Compte tenu de l''évolution des profils de sensibilité des bactéroïdes, il ne faut pas utiliser la clindamycine et la céfoxitine en probabiliste.', '1-', 'Clindamycine et céfoxitine en probabiliste', null, 'IIA communautaires — Microbiologie et antibiothérapie, R13'),
  ('MG-ANES-000095-R14', 'En l''absence de signes de gravité, il ne faut pas initier de traitement probabiliste actif sur les Candidas.', '1-', 'Traitement probabiliste actif sur les Candidas', null, 'IIA communautaires — Microbiologie et antibiothérapie, R14'),
  ('MG-ANES-000095-R15', 'Dans les péritonites graves (communautaires ou associées aux soins), il faut probablement instaurer un traitement antifongique si ≥ 3 des critères suivants : défaillance hémodynamique, sexe féminin, chirurgie sus-mésocolique, antibiothérapie > 48 h.', '2+', 'Indication du traitement antifongique — péritonites graves', null, 'IIA communautaires — Microbiologie et antibiothérapie, R15'),
  ('MG-ANES-000095-R16', 'Il ne faut probablement pas prendre en compte les entérocoques sans signe de gravité.', '2-', 'Prise en compte des entérocoques sans signe de gravité', null, 'IIA communautaires — Microbiologie et antibiothérapie, R16'),
  ('MG-ANES-000095-R17', 'En 1re intention : (1) amoxicilline/ac. clavulanique + gentamicine ; OU (2) céfotaxime/ceftriaxone + imidazolés.', '2+', 'Antibiothérapie probabiliste de 1re intention — IIA communautaire', null, 'IIA communautaires — Microbiologie et antibiothérapie, R17'),
  ('MG-ANES-000095-R18', 'Si allergie avérée aux β-lactamines : lévofloxacine + gentamicine + métronidazole, ou à défaut tigécycline.', 'AE', 'Antibiothérapie probabiliste — allergie aux β-lactamines (communautaire)', null, 'IIA communautaires — Microbiologie et antibiothérapie, R18'),
  ('MG-ANES-000095-R19', 'En cas d''IIA grave, le traitement probabiliste doit être adapté sur les germes suspectés.', '1+', 'Adaptation du traitement probabiliste sur les germes suspectés — IIA grave', null, 'IIA communautaires — Microbiologie et antibiothérapie, R19'),
  ('MG-ANES-000095-R20', 'Patient grave, IIA communautaire : pipéracilline/tazobactam ± gentamicine.', '2+', 'Antibiothérapie probabiliste — patient grave, IIA communautaire', null, 'IIA communautaires — Microbiologie et antibiothérapie, R20'),
  ('MG-ANES-000095-R21', 'Patient grave (communautaire ou associée aux soins), si traitement antifongique probabiliste décidé : échinocandine.', 'AE', 'Choix de l''antifongique probabiliste — patient grave', null, 'IIA communautaires — Microbiologie et antibiothérapie, R21'),
  ('MG-ANES-000095-R22', 'Après réception des analyses microbiologiques/mycologiques, il faut probablement une désescalade (spectre le plus étroit possible).', '2+', 'Désescalade antibiotique', null, 'IIA communautaires — Microbiologie et antibiothérapie, R22'),
  ('MG-ANES-000095-R23', 'IIA communautaires localisées : antibiothérapie 2 à 3 jours.', '2+', 'Durée d''antibiothérapie — IIA communautaires localisées', null, 'IIA communautaires — Microbiologie et antibiothérapie, R23'),
  ('MG-ANES-000095-R24', 'IIA communautaires généralisées : antibiothérapie 5 à 7 jours.', '2+', 'Durée d''antibiothérapie — IIA communautaires généralisées', null, 'IIA communautaires — Microbiologie et antibiothérapie, R24'),
  ('MG-ANES-000095-R25', 'Chez l''enfant, il faut privilégier les examens iconographiques non irradiants.', '1+', 'Imagerie non irradiante chez l''enfant', 'Enfant', 'Particularités pédiatriques des IIA, R25'),
  ('MG-ANES-000095-R26', 'Chez l''enfant, il faut probablement prendre en compte Pseudomonas aeruginosa en cas de facteurs de gravité (défaillance viscérale, comorbidités) ou d''échec thérapeutique.', '2+', 'Prise en compte de Pseudomonas aeruginosa chez l''enfant', 'Enfant', 'Particularités pédiatriques des IIA, R26'),
  ('MG-ANES-000095-R27', 'Il ne faut probablement pas prolonger la durée de l''antibiothérapie pédiatrique au-delà de ce qui est recommandé chez l''adulte.', '2-', 'Durée de l''antibiothérapie pédiatrique', 'Enfant', 'Particularités pédiatriques des IIA, R27'),
  ('MG-ANES-000095-R28', 'En cas de survenue ou d''aggravation d''une dysfonction d''organe dans les jours suivant une chirurgie abdominale, il faut probablement évoquer une IIA.', '2+', 'Évocation diagnostique d''une IIA postopératoire', null, 'IIA associées aux soins — Diagnostic postopératoire, R28'),
  ('MG-ANES-000095-R29', 'À partir du 4e-5e jour post-intervention, il faut probablement discuter une reprise chirurgicale si aucune amélioration clinique/biologique.', '2+', 'Reprise chirurgicale à J4-J5 postopératoire', null, 'IIA associées aux soins — Diagnostic postopératoire, R29'),
  ('MG-ANES-000095-R30', 'L''apparition postopératoire de signes de gravité sans autre cause évidente doit faire discuter une réintervention.', '2+', 'Réintervention devant des signes de gravité postopératoires', null, 'IIA associées aux soins — Diagnostic postopératoire, R30'),
  ('MG-ANES-000095-R31', 'Pour les abcès postopératoires : discuter en collégial le bénéfice-risque du drainage radiologique vs reprise chirurgicale, et probablement proposer une ponction diagnostique première à l''aiguille fine sous contrôle radiologique.', '2+', 'Drainage radiologique vs reprise chirurgicale — abcès postopératoires', null, 'IIA associées aux soins — Diagnostic postopératoire, R31'),
  ('MG-ANES-000095-R32', 'En cas de suspicion de péritonite postopératoire chez un patient stable, il faut probablement réaliser une TDM abdominopelvienne avec injection (± opacification digestive à discuter).', '2+', 'TDM abdominopelvienne — suspicion de péritonite postopératoire, patient stable', null, 'IIA associées aux soins — Diagnostic postopératoire, R32'),
  ('MG-ANES-000095-R33', 'En l''absence d''amélioration clinique/biologique à 4-5 j, une TDM non contributive ne permet pas d''éliminer une IIA persistante.', 'AE', 'Valeur d''une TDM non contributive à J4-J5', null, 'IIA associées aux soins — Diagnostic postopératoire, R33'),
  ('MG-ANES-000095-R34', 'Il ne faut probablement pas utiliser de biomarqueur pour le diagnostic d''IIA persistante.', '2-', 'Biomarqueurs pour le diagnostic d''IIA persistante', null, 'IIA associées aux soins — Diagnostic postopératoire, R34'),
  ('MG-ANES-000095-R35', 'Ponction diagnostique première à l''aiguille fine sous contrôle radiologique pour les collections des IIA associées aux soins, en cas de doute diagnostique.', 'AE', 'Ponction diagnostique à l''aiguille fine — IIA associées aux soins', null, 'IIA associées aux soins — Diagnostic postopératoire, R35'),
  ('MG-ANES-000095-R36', 'Il faut prélever hémocultures et liquides péritonéaux pour identification microbienne/fongique et sensibilité.', 'AE', 'Prélèvements microbiologiques — IIA associées aux soins', null, 'IIA associées aux soins — Diagnostic postopératoire, R36'),
  ('MG-ANES-000095-R37', 'Il faut probablement effectuer un examen direct du liquide péritonéal à la recherche de levures.', '2+', 'Examen direct du liquide péritonéal — recherche de levures', null, 'IIA associées aux soins — Diagnostic postopératoire, R37'),
  ('MG-ANES-000095-R38', '1er épisode d''IIA associée aux soins : risque élevé de bactérie multirésistante si antibiothérapie dans les 3 mois précédents et/ou > 2 jours avant le 1er épisode, et/ou délai > 5 j entre 1re chirurgie et reprise.', '1+', 'Facteurs de risque de bactérie multirésistante — 1er épisode d''IIA associée aux soins', null, 'IIA associées aux soins — Antibiothérapie, R38'),
  ('MG-ANES-000095-R39', 'Patients porteurs connus d''entérobactéries résistantes aux C3G, entérocoques résistants ampicilline/vancomycine, ou SARM : il faut probablement en tenir compte dans le traitement probabiliste.', '2+', 'Prise en compte des portages connus de bactéries résistantes', null, 'IIA associées aux soins — Antibiothérapie, R39'),
  ('MG-ANES-000095-R40', 'Facteurs de risque d''entérocoque résistant à l''ampicilline (pathologie hépatobiliaire, transplanté hépatique, antibiothérapie en cours) : choisir un probabiliste actif (vancomycine, voire tigécycline).', '2+', 'Choix du probabiliste — facteurs de risque d''entérocoque résistant à l''ampicilline', null, 'IIA associées aux soins — Antibiothérapie, R40'),
  ('MG-ANES-000095-R41', 'Traitement antifongique probabiliste si levure à l''examen direct (échinocandines si infection grave) ; traitement systématique si culture positive à levures hors redons/drains (échinocandines si grave ou souches résistantes au fluconazole).', '2+', 'Traitement antifongique — IIA associées aux soins', null, 'IIA associées aux soins — Antibiothérapie, R41'),
  ('MG-ANES-000095-R42', '1er épisode, sans facteur de risque de BMR : pipéracilline/tazobactam + amikacine (optionnelle si non grave). ≥ 2 des 6 critères de BMR (ou 1 seul si choc septique) : carbapénème large spectre (imipénème/méropénème/doripénème) + amikacine (optionnelle si non grave — même règle que pour le 1er schéma). 6 critères BMR : traitement antérieur par céphalosporine de 3e gén. ou fluoroquinolone (dont monodose) < 3 mois ; portage BLSE ou P. aeruginosa résistant ceftazidime < 3 mois ; hospitalisation à l''étranger < 12 mois ; EHPAD médicalisé + sonde/gastrotomie ; échec d''un traitement par céphalosporine 3e gén., fluoroquinolone ou pipéracilline-tazobactam à large spectre ; récidive < 15 j d''infection traitée par pipéracilline-tazobactam ≥ 3 j.', '2+', 'Antibiothérapie probabiliste — IIA associées aux soins et critères de BMR', null, 'IIA associées aux soins — Antibiothérapie, R42'),
  ('MG-ANES-000095-R43', 'Allergie aux β-lactamines : (1) ciprofloxacine + amikacine + métronidazole + vancomycine ; ou (2) aztréonam + amikacine + vancomycine + métronidazole ; ou (3) à défaut, tigécycline + ciprofloxacine.', 'AE', 'Antibiothérapie probabiliste — allergie aux β-lactamines (associées aux soins)', null, 'IIA associées aux soins — Antibiothérapie, R43'),
  ('MG-ANES-000095-R44', 'IIA nosocomiales/postopératoires : antibiothérapie 5 à 15 jours.', 'AE', 'Durée d''antibiothérapie — IIA nosocomiales/postopératoires', null, 'IIA associées aux soins — Antibiothérapie, R44')
) as v(code, statement, grade, condition_topic, population, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-des-infections-intra-abdominales/'
on conflict (recommendation_code) do nothing;

-- Numérotation R01-R44 sans trou : les 44 recommandations finales de la
-- source sont toutes reprises, dans leur ordre d'origine (aucune exclusion
-- individuelle) ; seuls les 3 algorithmes et le tableau de définition
-- (non-recommandations, voir disclosure ci-dessus) sont hors modèle
-- `recommendations`, sans que cela crée de trou dans la numérotation R.
