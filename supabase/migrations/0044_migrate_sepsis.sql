-- Migration : Prise en charge du sepsis du nouveau-né, de l'enfant et de
-- l'adulte : recommandations pour un parcours de soins intégré — Haute
-- Autorité de Santé (HAS), validée par le Collège de la HAS le 29 janvier
-- 2025. Promoteurs : SRLF, SFAR, SFMU, SPILF, SOFMER, SFP, SFN, GFRUP,
-- GPIP, SFM, SFMM, SF2H, SFGG, SFSP, CNGE, WAAAR (16 sociétés). Coordination
-- Pr Djillali Annane (SRLF). Source :
-- rfe-sfar-website/build/content_sepsis.json — le document REPRODUIT
-- INTÉGRALEMENT, en Annexe 5 et Annexe 6, les recommandations de la
-- Surviving Sepsis Campaign (SSC) 2021 (adulte) et 2020 (enfant/nouveau-né),
-- "validées pour le contexte français par le groupe de travail HAS".
--
-- NATURE DU DOCUMENT — disclosure : ce n'est PAS une RFE SFAR au sens usuel
-- du corpus, mais une RPC (Recommandation pour la Pratique Clinique) de la
-- HAS elle-même, dont les Annexes 5-6 reproduisent un guideline
-- international (SSC) "validé pour le contexte français" (même situation
-- structurelle que sdra/0040, mais ici la SOURCE PUBLIANTE — HAS — est
-- elle-même le promoteur, pas une simple traductrice). `doc_type = 'RPC'`
-- retenu, conforme au texte source ("Méthodologie : Recommandation pour la
-- Pratique Clinique (RPC)") ; `library_final.json` classe ce document
-- "RPP" (Recommandation de Pratique Professionnelle) — divergence
-- terminologique mineure disclosée, non résolue (les deux désignations
-- coexistent dans la littérature HAS).
--
-- MÉTHODOLOGIE — GRADE (Annexes 5-6) : force forte (1+ recommandé / 1- non
-- recommandé) ou conditionnelle (2+ suggéré / 2- suggéré de ne pas faire) ;
-- catégorie « ? » = « Pas de recommandation possible (preuve insuffisante) »
-- — catégorie de LÉGENDE OFFICIELLE de la source (contrairement au '?' de
-- securisation_proc/0041, qui lui était un marqueur ad hoc du contenu
-- construit pour une absence de tag). `grade` reproduit tel quel le chip
-- source. `evidence_level` laissé NULL. **Particularité Annexe 6
-- (pédiatrique) disclosée par le contenu construit lui-même : la source SSC
-- imprime pour chaque recommandation pédiatrique DEUX axes (force + niveau
-- de certitude), que le contenu construit a synthétisés en un seul chip —
-- reproduit ici tel que déjà simplifié par le contenu construit, disclosure
-- de cette simplification conservée pour relecture future.**
--
-- COMPTAGE — TOTAL SOURCE RECONCILIÉ, MAIS PÉRIMÈTRE DE MIGRATION RESTREINT
-- AUX RECOMMANDATIONS DIRECTIONNELLES (principe 1.5 du projet) : le
-- panneau d'ouverture de la source annonce "149 recommandations au total
-- (84 adulte + 65 enfant)" — exactement reconcilié par inventaire direct
-- (84 lignes Annexe 5 + 65 lignes Annexe 6 = 149). MAIS sur ces 149, 19
-- portent le grade « ? » (« Pas de recommandation possible ») — 8 en
-- Annexe 5, 11 en Annexe 6 — c'est-à-dire des items où la source elle-même
-- déclare explicitement NE PAS pouvoir formuler de recommandation. Ces 19
-- lignes ne sont PAS migrées comme recommandations atomiques (même
-- traitement que les innombrables panneaux « Absence de recommandation »
-- de ce corpus, et que les 4 lignes « SR » de pancreatite/0036) — seules
-- les 130 lignes portant un grade directionnel réel (1+/1-/2+/2- : 38×1+,
-- 7×1-, 48×2+, 37×2- = 130) sont migrées (76 Annexe 5 + 54 Annexe 6). Le
-- total officiel "149" de la source INCLUT ces 19 items sans recommandation
-- dans son décompte (contrairement à d'autres fiches du corpus où de tels
-- items sont comptés séparément) — disclosure de cette différence de
-- convention de comptage entre la source et cette migration.
--
-- NUMÉROTATION SOURCE — DES NUMÉROS MANQUENT, DISCLOSURE DE LA SOURCE
-- ELLE-MÊME REPRODUITE : "Numérotation reprise telle quelle du document
-- source (des numéros sont absents : items exclus de la validation
-- française de la SSC)." Le `Réf.` dans `source_section` reproduit donc
-- fidèlement la numérotation SOURCE (avec ses propres discontinuités,
-- ex. Annexe 5 saute de 4 à 6, de 18 à 20), PAS une renumérotation
-- séquentielle de ma part.
--
-- PÉRIMÈTRE — volontairement pas migrés (aucun chip de grade individuel,
-- hors des 149 recommandations comptées par la source elle-même) :
-- Définitions (sepsis/choc septique/qSOFA), scores diagnostiques
-- (Phoenix pédiatrique, Feux tricolores NICE, normes des signes vitaux
-- pédiatriques) — outils de RÉFÉRENCE, pas des recommandations graduées ;
-- Messages clés du parcours de soins complet (prévention → dépistage →
-- bundle de la 1ère heure → prévention des séquelles → accompagnement au
-- long cours) — synthèse narrative sans chip individuel, dont le contenu
-- clinique substantiel est de toute façon repris dans les recommandations
-- graduées des Annexes 5-6 ; Bonnes pratiques de l'hémoculture (adulte +
-- tableau pédiatrique par poids) — référence pratique, pas une
-- recommandation graduée ; Facteurs de risque de BMR — liste de contexte.
-- Champ explicitement exclu par la source elle-même : indications
-- vaccinales spécifiques (Annexe 4, référentiel externe non actionnable
-- en situation aiguë).
--
-- POPULATION : Annexe 5 (adulte) laissée NULL par défaut ; Annexe 6
-- (pédiatrique, y compris nouveau-né) taguée intégralement `population =
-- 'Pédiatrie'` (54 lignes migrées), la source précisant elle-même que la
-- "population par défaut de chaque ligne" de cette annexe est "enfant en
-- choc septique ou défaillance d'organe liée au sepsis".
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SFAR, SRLF, SFMU et SPILF (4 des 16 promoteurs, toutes dans le seed
--    Annexe B) ET HAS elle-même (organisme publiant/validant le document,
--    également dans le seed) liées en document_societies. **Collision
--    d'acronyme potentielle "SFN"** (même pattern que "SFD" dans eer/0020
--    et "SFN" dans ira/0030) : la source cite un promoteur "SFN" —
--    probablement Société Française de Néonatologie dans ce contexte
--    (document couvrant explicitement le nouveau-né), le seed contient
--    déjà un 'SFN' sans `full_name` (expansion la plus courante étant
--    "Société Française de Neurologie", différente) ; PAR PRUDENCE, non
--    liée. Les 11 autres promoteurs (SOFMER, SFP, GFRUP, GPIP, SFM, SFMM,
--    SF2H, SFGG, SFSP, CNGE, WAAAR) hors seed, non liés.
-- 2. Un document distinct et bien plus ancien, "Prise en charge
--    hémodynamique du sepsis sévère (nouveau-né exclu)" (SRLF, CC
--    2005/2006, périmètre hémodynamique uniquement), existe dans
--    `library_final.json` — NON confondu avec cette migration-ci (href et
--    contenu vérifiés distincts).
-- 3. Document volumineux (130 recommandations migrées sur 149
--    dénombrées) extrait par script Python (walk programmatique du JSON),
--    contrôlé par inventaire exhaustif et tally avant écriture du SQL
--    final.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge du sepsis du nouveau-né, de l''enfant et de l''adulte : recommandations pour un parcours de soins intégré',
  'RPC', 'fr', '2025-01-29',
  'https://sfar.org/prise-en-charge-du-sepsis-du-nouveau-ne-de-lenfant-et-de-ladulte-has-2025/',
  'https://sfar.org/download/prise-en-charge-du-sepsis-du-nouveau-ne-de-lenfant-et-de-ladulte-recommandations-pour-un-parcours-de-soins-integre/?wpdmdl=75093',
  'GRADE (Annexes 5-6, reproduisant la Surviving Sepsis Campaign 2021 adulte / 2020 enfant, validées pour le contexte français) : force forte (1+/1-) ou conditionnelle (2+/2-) ; "?" = pas de recommandation possible (preuve insuffisante), catégorie officielle de la légende source. 149 items comptés par la source (84 adulte + 65 enfant), dont 19 sans recommandation directionnelle (8+11) — seules les 130 recommandations directionnelles réelles sont migrées ici (38×1+, 7×1-, 48×2+, 37×2-).',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-du-sepsis-du-nouveau-ne-de-lenfant-et-de-ladulte-has-2025/'
  and s.acronym in ('SFAR', 'SRLF', 'SFMU', 'SPILF', 'HAS') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-du-sepsis-du-nouveau-ne-de-lenfant-et-de-ladulte-has-2025/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'medecine_d_urgence', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.source_section,
  'https://sfar.org/prise-en-charge-du-sepsis-du-nouveau-ne-de-lenfant-et-de-ladulte-has-2025/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000044-R001', 'Adoption par les hôpitaux d''un programme d''amélioration des performances dans la prise en charge du sepsis (protocole de détection des patients graves/à haut risque + protocoles thérapeutiques).', '1+', null, 'Annexe 5 (SSC adulte) — Dépistage, organisation & prise en charge initiale (Réf. 1)'),
  ('MG-ANES-000044-R002', 'Ne pas utiliser un score isolé (qSOFA, SIRS, autre « early warning score ») comme seul outil de dépistage du sepsis/choc septique.', '1-', null, 'Annexe 5 (SSC adulte) — Dépistage, organisation & prise en charge initiale (Réf. 2)'),
  ('MG-ANES-000044-R003', 'Mesure du lactate sérique en cas de suspicion de sepsis.', '1+', null, 'Annexe 5 (SSC adulte) — Dépistage, organisation & prise en charge initiale (Réf. 3)'),
  ('MG-ANES-000044-R004', 'Sepsis et choc septique = urgences médicales : traitement et réanimation à débuter immédiatement.', '1+', null, 'Annexe 5 (SSC adulte) — Dépistage, organisation & prise en charge initiale (Réf. 4)'),
  ('MG-ANES-000044-R005', 'Utiliser des paramètres dynamiques plutôt que l''examen physique seul ou des paramètres statiques seuls pour guider le remplissage vasculaire.', '2+', null, 'Annexe 5 (SSC adulte) — Dépistage, organisation & prise en charge initiale (Réf. 6)'),
  ('MG-ANES-000044-R006', 'Guider la réanimation sur la baisse de la lactatémie chez les patients dont elle est élevée, plutôt que de ne pas utiliser le lactate.', '2+', null, 'Annexe 5 (SSC adulte) — Dépistage, organisation & prise en charge initiale (Réf. 7)'),
  ('MG-ANES-000044-R007', 'Utiliser le temps de recoloration cutanée comme mesure adjonctive aux autres paramètres de perfusion pour guider la réanimation.', '2+', null, 'Annexe 5 (SSC adulte) — Dépistage, organisation & prise en charge initiale (Réf. 8)'),
  ('MG-ANES-000044-R008', 'Objectif initial de pression artérielle moyenne à 65 mmHg plutôt que des objectifs supérieurs.', '1+', null, 'Annexe 5 (SSC adulte) — Dépistage, organisation & prise en charge initiale (Réf. 9)'),
  ('MG-ANES-000044-R009', 'Admettre en réanimation dans les 6 heures les patients qui le nécessitent.', '2+', null, 'Annexe 5 (SSC adulte) — Dépistage, organisation & prise en charge initiale (Réf. 10)'),
  ('MG-ANES-000044-R010', 'Réévaluation permanente + recherche de diagnostics alternatifs + arrêt des antimicrobiens probabilistes si infection non confirmée et cause alternative démontrée/fortement suspectée.', '1+', null, 'Annexe 5 (SSC adulte) — Prise en charge de l''infection (1/2) (Réf. 11)'),
  ('MG-ANES-000044-R011', 'Administration immédiate d''antimicrobiens (idéalement dans l''heure) en cas de choc septique possible ou forte probabilité de sepsis.', '1+', null, 'Annexe 5 (SSC adulte) — Prise en charge de l''infection (1/2) (Réf. 12)'),
  ('MG-ANES-000044-R012', 'Réévaluation rapide de la probabilité infectieuse vs non infectieuse en cas de sepsis possible sans choc (cf. bonnes pratiques hémoculture, page précédente).', '1+', null, 'Annexe 5 (SSC adulte) — Prise en charge de l''infection (1/2) (Réf. 13)'),
  ('MG-ANES-000044-R013', 'Durée limitée d''investigation rapide puis, si le problème persiste, antimicrobiens dans les 3 h à partir de l''identification du sepsis (sepsis possible sans choc).', '2+', null, 'Annexe 5 (SSC adulte) — Prise en charge de l''infection (1/2) (Réf. 14)'),
  ('MG-ANES-000044-R014', 'Différer les antimicrobiens en cas de faible probabilité d''infection et absence de choc, avec surveillance rapprochée.', '2+', null, 'Annexe 5 (SSC adulte) — Prise en charge de l''infection (1/2) (Réf. 15)'),
  ('MG-ANES-000044-R015', 'Ne pas utiliser la procalcitonine associée à l''évaluation clinique pour décider du moment de débuter les antimicrobiens, par rapport à l''évaluation clinique seule.', '2-', null, 'Annexe 5 (SSC adulte) — Prise en charge de l''infection (1/2) (Réf. 16)'),
  ('MG-ANES-000044-R016', 'Antimicrobiens probabilistes couvrant le SARM chez les patients à haut risque d''infection à SARM.', '1+', null, 'Annexe 5 (SSC adulte) — Prise en charge de l''infection (1/2) (Réf. 17)'),
  ('MG-ANES-000044-R017', 'Ne pas utiliser d''antimicrobiens couvrant le SARM chez les patients à faible risque.', '2-', null, 'Annexe 5 (SSC adulte) — Prise en charge de l''infection (1/2) (Réf. 18)'),
  ('MG-ANES-000044-R018', 'Ne pas utiliser 2 antimicrobiens probabilistes à Gram négatif (plutôt qu''1 seul) chez les patients à faible risque de BMR.', '1-', null, 'Annexe 5 (SSC adulte) — Prise en charge de l''infection (1/2) (Réf. 20)'),
  ('MG-ANES-000044-R019', 'Ne pas utiliser de double couverture antimicrobienne dès que le micro-organisme et sa sensibilité sont identifiés.', '2-', null, 'Annexe 5 (SSC adulte) — Prise en charge de l''infection (1/2) (Réf. 21)'),
  ('MG-ANES-000044-R020', 'Traitement antifongique probabiliste chez les patients à haut risque d''infection fongique.', '2+', null, 'Annexe 5 (SSC adulte) — Prise en charge de l''infection (1/2) (Réf. 22)'),
  ('MG-ANES-000044-R021', 'Ne pas utiliser de traitement antifongique probabiliste chez les patients à faible risque d''infection fongique.', '2-', null, 'Annexe 5 (SSC adulte) — Prise en charge de l''infection (1/2) (Réf. 23)'),
  ('MG-ANES-000044-R022', 'Perfusions prolongées de bêtalactamines après le bolus initial, plutôt qu''une perfusion en bolus conventionnelle.', '2+', null, 'Annexe 5 (SSC adulte) — Prise en charge de l''infection (1/2) (Réf. 25)'),
  ('MG-ANES-000044-R023', 'Identification/exclusion rapide d''un diagnostic anatomique nécessitant un contrôle du foyer infectieux en urgence, et mise en œuvre de ce contrôle dès que médicalement et logistiquement possible.', '1+', null, 'Annexe 5 (SSC adulte) — Prise en charge de l''infection (2/2) (Réf. 27)'),
  ('MG-ANES-000044-R024', 'Retrait rapide des dispositifs intravasculaires identifiés comme foyer possible, après mise en place d''un autre accès vasculaire.', '1+', null, 'Annexe 5 (SSC adulte) — Prise en charge de l''infection (2/2) (Réf. 28)'),
  ('MG-ANES-000044-R025', 'Réévaluation quotidienne en vue d''une désescalade des antimicrobiens, plutôt que des durées fixes sans réévaluation.', '2+', null, 'Annexe 5 (SSC adulte) — Prise en charge de l''infection (2/2) (Réf. 29)'),
  ('MG-ANES-000044-R026', 'Utiliser la procalcitonine + évaluation clinique pour décider d''interrompre les antimicrobiens (contrôle du foyer adéquat, durée optimale indéterminée), plutôt que l''évaluation clinique seule.', '2+', null, 'Annexe 5 (SSC adulte) — Prise en charge de l''infection (2/2) (Réf. 31)'),
  ('MG-ANES-000044-R027', 'Cristalloïdes en première ligne de réanimation liquidienne.', '1+', null, 'Annexe 5 (SSC adulte) — Prise en charge hémodynamique (Réf. 32)'),
  ('MG-ANES-000044-R028', 'Cristalloïdes « balancés » plutôt que sérum salé isotonique.', '2+', null, 'Annexe 5 (SSC adulte) — Prise en charge hémodynamique (Réf. 33)'),
  ('MG-ANES-000044-R029', 'Albumine chez les patients ayant reçu de grands volumes de cristalloïdes.', '2+', null, 'Annexe 5 (SSC adulte) — Prise en charge hémodynamique (Réf. 34)'),
  ('MG-ANES-000044-R030', 'Ne pas utiliser d''hydroxyéthylamidons pour le remplissage vasculaire.', '1-', null, 'Annexe 5 (SSC adulte) — Prise en charge hémodynamique (Réf. 35)'),
  ('MG-ANES-000044-R031', 'Ne pas utiliser de gélatines pour le remplissage vasculaire.', '2-', null, 'Annexe 5 (SSC adulte) — Prise en charge hémodynamique (Réf. 36)'),
  ('MG-ANES-000044-R032', 'Noradrénaline comme vasopresseur de 1ère ligne, par rapport aux autres vasopresseurs.', '1+', null, 'Annexe 5 (SSC adulte) — Prise en charge hémodynamique (Réf. 37)'),
  ('MG-ANES-000044-R033', 'Ne pas utiliser de terlipressine en choc septique.', '2-', null, 'Annexe 5 (SSC adulte) — Prise en charge hémodynamique (Réf. 40)'),
  ('MG-ANES-000044-R034', 'Dysfonction cardiaque avec hypoperfusion persistante malgré volémie/PA adéquates : ajouter la dobutamine à la noradrénaline, ou utiliser l''adrénaline seule.', '2+', null, 'Annexe 5 (SSC adulte) — Prise en charge hémodynamique (Réf. 41)'),
  ('MG-ANES-000044-R035', 'Même situation : ne pas utiliser de lévosimendan.', '2-', null, 'Annexe 5 (SSC adulte) — Prise en charge hémodynamique (Réf. 42)'),
  ('MG-ANES-000044-R036', 'Monitorage invasif de la pression artérielle plutôt que non invasif, dès que réalisable.', '2+', null, 'Annexe 5 (SSC adulte) — Prise en charge hémodynamique (Réf. 43)'),
  ('MG-ANES-000044-R037', 'Initier le vasopresseur sur une voie veineuse périphérique pour rétablir la PAM, plutôt que de retarder son initiation jusqu''à l''obtention d''une voie centrale.', '2+', null, 'Annexe 5 (SSC adulte) — Prise en charge hémodynamique (Réf. 44)'),
  ('MG-ANES-000044-R038', 'Oxygénothérapie nasale à haut débit plutôt que VNI, en insuffisance respiratoire hypoxémique liée au sepsis.', '2+', null, 'Annexe 5 (SSC adulte) — Prise en charge respiratoire (Réf. 47)'),
  ('MG-ANES-000044-R039', 'Ventilation à petits volumes courants (6 mL/kg) plutôt que grands volumes (> 10 mL/kg) en SDRA lié au sepsis.', '1+', null, 'Annexe 5 (SSC adulte) — Prise en charge respiratoire (Réf. 49)'),
  ('MG-ANES-000044-R040', 'Limite haute de pression de plateau à 30 cmH2O plutôt que pressions supérieures, en SDRA lié au sepsis.', '2+', null, 'Annexe 5 (SSC adulte) — Prise en charge respiratoire (Réf. 50)'),
  ('MG-ANES-000044-R041', 'Ventilation à petits volumes courants en détresse respiratoire liée au sepsis sans SDRA.', '2+', null, 'Annexe 5 (SSC adulte) — Prise en charge respiratoire (Réf. 52)'),
  ('MG-ANES-000044-R042', 'Si des manœuvres de recrutement sont utilisées : ne pas utiliser de titration incrémentale de la PEEP.', '1-', null, 'Annexe 5 (SSC adulte) — Prise en charge respiratoire (Réf. 54)'),
  ('MG-ANES-000044-R043', 'Décubitus ventral > 12 h en SDRA modéré à sévère lié au sepsis.', '1+', null, 'Annexe 5 (SSC adulte) — Prise en charge respiratoire (Réf. 55)'),
  ('MG-ANES-000044-R044', 'Bolus intermittents de curares non dépolarisants plutôt que perfusion continue, en SDRA modéré à sévère lié au sepsis.', '2+', null, 'Annexe 5 (SSC adulte) — Prise en charge respiratoire (Réf. 56)'),
  ('MG-ANES-000044-R045', 'ECMO veino-veineuse en SDRA sévère lié au sepsis si échec de la ventilation mécanique conventionnelle, dans des centres expérimentés.', '2+', null, 'Annexe 5 (SSC adulte) — Prise en charge respiratoire (Réf. 57)'),
  ('MG-ANES-000044-R046', 'Corticoïdes IV en choc septique avec besoins croissants en vasopresseurs.', '2+', null, 'Annexe 5 (SSC adulte) — Traitements adjuvants (Réf. 58)'),
  ('MG-ANES-000044-R047', 'Ne pas utiliser l''hémoperfusion de polymyxine B.', '2-', null, 'Annexe 5 (SSC adulte) — Traitements adjuvants (Réf. 59)'),
  ('MG-ANES-000044-R048', 'Stratégie transfusionnelle restrictive plutôt que sans limite imposée/libérale.', '1+', null, 'Annexe 5 (SSC adulte) — Traitements adjuvants (Réf. 61)'),
  ('MG-ANES-000044-R049', 'Ne pas utiliser d''immunoglobulines intraveineuses.', '2-', null, 'Annexe 5 (SSC adulte) — Traitements adjuvants (Réf. 62)'),
  ('MG-ANES-000044-R050', 'Prophylaxie de l''ulcère de stress chez les patients avec facteurs de risque de saignement gastro-intestinal.', '2+', null, 'Annexe 5 (SSC adulte) — Traitements adjuvants (Réf. 63)'),
  ('MG-ANES-000044-R051', 'Prophylaxie de la maladie thromboembolique veineuse en dehors de contre-indications existantes.', '1+', null, 'Annexe 5 (SSC adulte) — Traitements adjuvants (Réf. 64)'),
  ('MG-ANES-000044-R052', 'HBPM plutôt qu''HNF pour la prophylaxie de la maladie thromboembolique.', '1+', null, 'Annexe 5 (SSC adulte) — Traitements adjuvants (Réf. 65)'),
  ('MG-ANES-000044-R053', 'Ne pas utiliser la compression mécanique intermittente en prévention de la MTEV en plus de la prophylaxie pharmacologique.', '2-', null, 'Annexe 5 (SSC adulte) — Traitements adjuvants (Réf. 66)'),
  ('MG-ANES-000044-R054', 'Épuration extra-rénale (continue ou intermittente) en cas d''insuffisance rénale aiguë.', '2+', null, 'Annexe 5 (SSC adulte) — Traitements adjuvants (Réf. 67)'),
  ('MG-ANES-000044-R055', 'Ne pas utiliser l''épuration extra-rénale en l''absence d''indication définie.', '2-', null, 'Annexe 5 (SSC adulte) — Traitements adjuvants (Réf. 68)'),
  ('MG-ANES-000044-R056', 'Initiation d''une insulinothérapie à partir d''une glycémie ≥ 10 mmol/L.', '1+', null, 'Annexe 5 (SSC adulte) — Traitements adjuvants (Réf. 69)'),
  ('MG-ANES-000044-R057', 'Ne pas utiliser de vitamine C intraveineuse.', '2-', null, 'Annexe 5 (SSC adulte) — Traitements adjuvants (Réf. 70)'),
  ('MG-ANES-000044-R058', 'Choc septique + hypoperfusion par acidose lactique : ne pas utiliser de bicarbonate de sodium pour améliorer l''hémodynamique/réduire les besoins en vasopresseurs.', '2-', null, 'Annexe 5 (SSC adulte) — Traitements adjuvants (Réf. 71)'),
  ('MG-ANES-000044-R059', 'Choc septique + acidose métabolique sévère (pH ≤ 7,2) + insuffisance rénale aiguë (AKIN 2-3) : bicarbonate de sodium.', '2+', null, 'Annexe 5 (SSC adulte) — Traitements adjuvants (Réf. 72)'),
  ('MG-ANES-000044-R060', 'Initiation précoce (dans les 72 h) de l''alimentation entérale si possible.', '2+', null, 'Annexe 5 (SSC adulte) — Traitements adjuvants (Réf. 73)'),
  ('MG-ANES-000044-R061', 'Discussion sur les objectifs de soins et le pronostic avec le patient et son entourage.', '1+', null, 'Annexe 5 (SSC adulte) — Objectifs de soins & prise en charge au long cours (Réf. 74)'),
  ('MG-ANES-000044-R062', 'Définir les objectifs de soins précocement (dans les 72 h) plutôt que tardivement.', '2+', null, 'Annexe 5 (SSC adulte) — Objectifs de soins & prise en charge au long cours (Réf. 75)'),
  ('MG-ANES-000044-R063', 'Intégrer le principe de soins palliatifs (± consultation dédiée selon jugement médical) dans le plan de traitement si approprié.', '1+', null, 'Annexe 5 (SSC adulte) — Objectifs de soins & prise en charge au long cours (Réf. 77)'),
  ('MG-ANES-000044-R064', 'Ne pas organiser systématiquement une consultation formalisée de soins palliatifs, par rapport à une consultation basée sur le jugement médical.', '2-', null, 'Annexe 5 (SSC adulte) — Objectifs de soins & prise en charge au long cours (Réf. 78)'),
  ('MG-ANES-000044-R065', 'Orientation vers des groupes de soutien pour les survivants et leur entourage.', '2+', null, 'Annexe 5 (SSC adulte) — Objectifs de soins & prise en charge au long cours (Réf. 79)'),
  ('MG-ANES-000044-R066', 'Fiche de transmission avec les informations importantes pour la poursuite de la prise en charge.', '2+', null, 'Annexe 5 (SSC adulte) — Objectifs de soins & prise en charge au long cours (Réf. 80)'),
  ('MG-ANES-000044-R067', 'Évaluer systématiquement les besoins de soutien économique et social (logement, alimentation, finances, psychologique) et agir en conséquence.', '1+', null, 'Annexe 5 (SSC adulte) — Objectifs de soins & prise en charge au long cours (Réf. 82)'),
  ('MG-ANES-000044-R068', 'Éducation orale et écrite sur le sepsis (diagnostic, traitement, syndrome post-sepsis) avant la sortie et lors du suivi.', '2+', null, 'Annexe 5 (SSC adulte) — Objectifs de soins & prise en charge au long cours (Réf. 83)'),
  ('MG-ANES-000044-R069', 'Participation de l''équipe soignante aux décisions de sortie post-réanimation pour une planification de sortie acceptable et réalisable.', '1+', null, 'Annexe 5 (SSC adulte) — Objectifs de soins & prise en charge au long cours (Réf. 84)'),
  ('MG-ANES-000044-R070', 'Programme de transition (plutôt que soins standards) lors du transfert vers un service de soins non critiques.', '2+', null, 'Annexe 5 (SSC adulte) — Objectifs de soins & prise en charge au long cours (Réf. 85)'),
  ('MG-ANES-000044-R071', 'Reprise des traitements usuels à la sortie de réanimation et de l''hôpital.', '1+', null, 'Annexe 5 (SSC adulte) — Objectifs de soins & prise en charge au long cours (Réf. 86)'),
  ('MG-ANES-000044-R072', 'Information formalisée (résumé oral et écrit) sur le séjour en réanimation, le sepsis, les diagnostics associés, les traitements et les troubles habituels après un sepsis.', '1+', null, 'Annexe 5 (SSC adulte) — Objectifs de soins & prise en charge au long cours (Réf. 87)'),
  ('MG-ANES-000044-R073', 'Plan de sortie incluant un suivi par des cliniciens compétents en cas de nouvelles séquelles.', '1+', null, 'Annexe 5 (SSC adulte) — Objectifs de soins & prise en charge au long cours (Réf. 88)'),
  ('MG-ANES-000044-R074', 'Évaluation et suivi des problèmes physiques, cognitifs et émotionnels après la sortie de l''hôpital.', '1+', null, 'Annexe 5 (SSC adulte) — Objectifs de soins & prise en charge au long cours (Réf. 91)'),
  ('MG-ANES-000044-R075', 'Orientation vers un programme de suivi des maladies post-réanimation, lorsque celui-ci existe.', '2+', null, 'Annexe 5 (SSC adulte) — Objectifs de soins & prise en charge au long cours (Réf. 92)'),
  ('MG-ANES-000044-R076', 'Orientation vers un programme de réadaptation si ventilation mécanique > 48 h ou séjour en réanimation > 72 h.', '2+', null, 'Annexe 5 (SSC adulte) — Objectifs de soins & prise en charge au long cours (Réf. 93)'),
  ('MG-ANES-000044-R077', 'Mise en place et application de protocoles de prise en charge de l''enfant en choc septique ou en défaillance d''organe liée au sepsis.', '1+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Détection, diagnostic, prise en charge générale & anti-microbiens (Réf. 3)'),
  ('MG-ANES-000044-R078', 'Au moins 1 hémoculture d''au moins 2 mL avant antibiothérapie, dans toutes les situations où cela n''induit pas de retard d''administration (cf. bonnes pratiques hémoculture, page précédente).', '1+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Détection, diagnostic, prise en charge générale & anti-microbiens (Réf. 4)'),
  ('MG-ANES-000044-R079', 'Choc septique : débuter une antibiothérapie aussi vite que possible, dans l''heure.', '1+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Détection, diagnostic, prise en charge générale & anti-microbiens (Réf. 5)'),
  ('MG-ANES-000044-R080', 'En l''absence de choc : débuter une antibiothérapie aussi vite que possible, dans l''heure suivant la reconnaissance du sepsis.', '2+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Détection, diagnostic, prise en charge générale & anti-microbiens (Réf. 6)'),
  ('MG-ANES-000044-R081', 'Traitement empirique à large spectre couvrant les agents pathogènes les plus probables.', '1+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Détection, diagnostic, prise en charge générale & anti-microbiens (Réf. 7)'),
  ('MG-ANES-000044-R082', 'Dès que pathogène et sensibilité sont connus : réduire le spectre des traitements empiriques.', '1+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Détection, diagnostic, prise en charge générale & anti-microbiens (Réf. 8)'),
  ('MG-ANES-000044-R083', 'En l''absence de pathogène identifié : réduire le spectre ou arrêter les traitements empiriques selon l''état clinique, l''évolution, le site d''infection et les facteurs de risque, en lien avec l''infectiologie.', '1+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Détection, diagnostic, prise en charge générale & anti-microbiens (Réf. 9)'),
  ('MG-ANES-000044-R084', 'Enfants immunodéprimés et/ou à très haut risque de germe multirésistant : association d''antibiotiques probabilistes en cas de choc septique ou de défaillance d''organe liée au sepsis.', '1+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Détection, diagnostic, prise en charge générale & anti-microbiens (Réf. 11)'),
  ('MG-ANES-000044-R085', 'Stratégies de dosage d''antibiotiques fondées sur les principes pharmacocinétiques/pharmacodynamiques, en tenant compte des propriétés spécifiques des médicaments.', '1+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Détection, diagnostic, prise en charge générale & anti-microbiens (Réf. 12)'),
  ('MG-ANES-000044-R086', 'Évaluer quotidiennement (clinique et biologique) la possibilité d''une désescalade de l''antibiothérapie.', '1+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Détection, diagnostic, prise en charge générale & anti-microbiens (Réf. 13)'),
  ('MG-ANES-000044-R087', 'Déterminer la durée d''antibiothérapie selon le site d''infection, l''agent causal, la réponse au traitement et le contrôle de la source.', '1+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Détection, diagnostic, prise en charge générale & anti-microbiens (Réf. 14)'),
  ('MG-ANES-000044-R088', 'Contrôler au plus vite la source de l''infection (tests diagnostiques appropriés, avis d''équipes spécialisées si nécessaire pour prioriser les interventions).', '1+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Détection, diagnostic, prise en charge générale & anti-microbiens (Réf. 15)'),
  ('MG-ANES-000044-R089', 'Retrait d''un dispositif intravasculaire confirmé comme source de l''infection, après mise en place d''un autre dispositif — le maintien reste parfois possible selon le germe et la balance bénéfices/risques d''une chirurgie.', '1+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Détection, diagnostic, prise en charge générale & anti-microbiens (Réf. 16)'),
  ('MG-ANES-000044-R090', 'Cristalloïdes plutôt qu''albumine pour la réanimation initiale.', '2+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Remplissage vasculaire, monitorage hémodynamique & traitements vasoactifs (Réf. 20)'),
  ('MG-ANES-000044-R091', 'Cristalloïdes « balancés » plutôt que sérum salé à 0,9 %, en particulier pour les remplissages faisant suite au remplissage initial.', '2+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Remplissage vasculaire, monitorage hémodynamique & traitements vasoactifs (Réf. 21)'),
  ('MG-ANES-000044-R092', 'Ne pas utiliser les dérivés de l''amidon comme soluté de remplissage.', '1-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Remplissage vasculaire, monitorage hémodynamique & traitements vasoactifs (Réf. 22)'),
  ('MG-ANES-000044-R093', 'Ne pas utiliser les gélatines comme soluté de remplissage.', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Remplissage vasculaire, monitorage hémodynamique & traitements vasoactifs (Réf. 23)'),
  ('MG-ANES-000044-R094', 'La catégorisation clinique seule en choc septique « chaud »/« froid » n''est pas recommandée.', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Remplissage vasculaire, monitorage hémodynamique & traitements vasoactifs (Réf. 25)'),
  ('MG-ANES-000044-R095', 'Mesure de variables hémodynamiques avancées (au mieux par échographie : débit/index cardiaque, résistances vasculaires systémiques, ScvO2), en complément des variables cliniques, quand disponibles. Lactate persistant élevé → réanimation probablement incomplète, poursuivre l''optimisation.', '2+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Remplissage vasculaire, monitorage hémodynamique & traitements vasoactifs (Réf. 26)'),
  ('MG-ANES-000044-R096', 'Adrénaline plutôt que dopamine.', '2+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Remplissage vasculaire, monitorage hémodynamique & traitements vasoactifs (Réf. 28)'),
  ('MG-ANES-000044-R097', 'Noradrénaline plutôt que dopamine.', '2+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Remplissage vasculaire, monitorage hémodynamique & traitements vasoactifs (Réf. 29)'),
  ('MG-ANES-000044-R098', 'Ne pas utiliser l''étomidate pour l''intubation.', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Prise en charge respiratoire (Réf. 35)'),
  ('MG-ANES-000044-R099', 'Essai de ventilation non invasive en cas de SDRA sans indication claire d''intubation et ayant répondu à la réanimation initiale (réévaluation attentive, ne doit pas retarder l''intubation).', '2+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Prise en charge respiratoire (Réf. 36)'),
  ('MG-ANES-000044-R100', 'PEP élevée en cas de SDRA lié au sepsis (niveau exact non déterminé ; effets hémodynamiques délétères plus marqués en choc septique).', '2+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Prise en charge respiratoire (Réf. 37)'),
  ('MG-ANES-000044-R101', 'Essai de décubitus ventral en cas de SDRA sévère avec hypoxémie ne répondant pas aux autres thérapeutiques (durée non précisée chez l''enfant).', '2+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Prise en charge respiratoire (Réf. 39)'),
  ('MG-ANES-000044-R102', 'Ne pas utiliser en routine le NO inhalé chez tous les enfants avec SDRA lié au sepsis.', '1-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Prise en charge respiratoire (Réf. 40)'),
  ('MG-ANES-000044-R103', 'NO inhalé en dernier recours si hypoxie réfractaire + défaillance cardiaque droite, une fois les autres stratégies d''oxygénation utilisées.', '2+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Prise en charge respiratoire (Réf. 41)'),
  ('MG-ANES-000044-R104', 'Curares chez les enfants présentant un SDRA grave lié au sepsis.', '2+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Prise en charge respiratoire (Réf. 43)'),
  ('MG-ANES-000044-R105', 'Ne pas utiliser l''hydrocortisone IV si le remplissage vasculaire et le traitement vasopresseur ont restauré l''état hémodynamique.', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Corticostéroïdes & traitement hormonal/métabolique (Réf. 44)'),
  ('MG-ANES-000044-R106', 'Administration ou non d''hydrocortisone IV, au choix, en cas d''échec du remplissage vasculaire + traitement vasopresseur — recommandé chez l''adulte avec un niveau de preuve élevé, usage pouvant se justifier en choc réfractaire, en particulier si âge physiologique proche de l''adulte.', '2+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Corticostéroïdes & traitement hormonal/métabolique (Réf. 45)'),
  ('MG-ANES-000044-R107', 'Ne pas instituer de traitement par insuline pour maintenir la glycémie ≤ 7,8 mmol/L (140 mg/dL).', '1-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Corticostéroïdes & traitement hormonal/métabolique (Réf. 46)'),
  ('MG-ANES-000044-R108', 'Ne pas utiliser la lévothyroxine en routine en situation d''euthyroïdie.', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Corticostéroïdes & traitement hormonal/métabolique (Réf. 49)'),
  ('MG-ANES-000044-R109', 'Traitement antipyrétique ou attitude permissive de la fièvre, au choix.', '2+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Corticostéroïdes & traitement hormonal/métabolique (Réf. 50)'),
  ('MG-ANES-000044-R110', 'Ne pas interrompre l''alimentation sur le seul critère de l''usage d''un traitement vasoactif.', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Nutrition (Réf. 52)'),
  ('MG-ANES-000044-R111', 'Alimentation entérale privilégiée par rapport à la nutrition parentérale dans les 7 premiers jours suivant l''admission.', '2+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Nutrition (Réf. 53)'),
  ('MG-ANES-000044-R112', 'Ne pas administrer de supplémentation en émulsions lipidiques (chez le nouveau-né/prématuré sous nutrition parentérale : données insuffisantes pour trancher).', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Nutrition (Réf. 54)'),
  ('MG-ANES-000044-R113', 'Ne pas surveiller en routine le volume de résidu gastrique.', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Nutrition (Réf. 55)'),
  ('MG-ANES-000044-R114', 'Nutrition entérale par sonde gastrique plutôt que sonde transpylorique, en l''absence de contre-indication.', '2+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Nutrition (Réf. 56)'),
  ('MG-ANES-000044-R115', 'Ne pas administrer de prokinétiques en routine pour le traitement de l''intolérance alimentaire.', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Nutrition (Réf. 57)'),
  ('MG-ANES-000044-R116', 'Ne pas administrer de sélénium.', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Nutrition (Réf. 58)'),
  ('MG-ANES-000044-R117', 'Ne pas administrer de supplémentation en glutamine.', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Nutrition (Réf. 59)'),
  ('MG-ANES-000044-R118', 'Ne pas administrer de supplémentation en arginine.', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Nutrition (Réf. 60)'),
  ('MG-ANES-000044-R119', 'Ne pas administrer de supplémentation en zinc.', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Nutrition (Réf. 61)'),
  ('MG-ANES-000044-R120', 'Ne pas administrer de supplémentation en vitamine C.', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Nutrition (Réf. 62)'),
  ('MG-ANES-000044-R121', 'Ne pas administrer de supplémentation en thiamine.', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Nutrition (Réf. 63)'),
  ('MG-ANES-000044-R122', 'Ne pas administrer de supplémentation en vitamine D.', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Nutrition (Réf. 64)'),
  ('MG-ANES-000044-R123', 'Ne pas transfuser de globules rouges si Hb ≥ 7 g/dL (seuil variable chez le nouveau-né selon le terme, l''âge postnatal et les comorbidités, notamment le canal artériel persistant).', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Transfusion, épuration extra-rénale/échanges plasmatiques, immunoglobulines & prophylaxie (Réf. 65)'),
  ('MG-ANES-000044-R124', 'Ne pas transfuser de plaquettes en prophylaxie sur le seul taux de plaquettes, en l''absence de signes hémorragiques.', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Transfusion, épuration extra-rénale/échanges plasmatiques, immunoglobulines & prophylaxie (Réf. 67)'),
  ('MG-ANES-000044-R125', 'Ne pas transfuser de plasma en prophylaxie en l''absence de signes hémorragiques.', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Transfusion, épuration extra-rénale/échanges plasmatiques, immunoglobulines & prophylaxie (Réf. 68)'),
  ('MG-ANES-000044-R126', 'Ne pas faire d''échanges plasmatiques en l''absence de syndrome de thrombopénie associée à une défaillance multi-organe (TAMOF).', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Transfusion, épuration extra-rénale/échanges plasmatiques, immunoglobulines & prophylaxie (Réf. 69)'),
  ('MG-ANES-000044-R127', 'Épuration extra-rénale pour prévenir/traiter une surcharge hydrique ne répondant pas à la restriction hydrique et au traitement diurétique (techniques parfois limitées chez le nouveau-né/prématuré ; considérations éthiques à prendre en compte).', '2+', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Transfusion, épuration extra-rénale/échanges plasmatiques, immunoglobulines & prophylaxie (Réf. 71)'),
  ('MG-ANES-000044-R128', 'Ne pas utiliser en routine les immunoglobulines intraveineuses — possible en choc toxique streptococcique réfractaire aux amines vasopressives/inotropes, si disponibles.', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Transfusion, épuration extra-rénale/échanges plasmatiques, immunoglobulines & prophylaxie (Réf. 75)'),
  ('MG-ANES-000044-R129', 'Ne pas faire en routine de prophylaxie contre l''ulcère de stress (sauf patients à très haut risque, ≥ 13 %).', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Transfusion, épuration extra-rénale/échanges plasmatiques, immunoglobulines & prophylaxie (Réf. 76)'),
  ('MG-ANES-000044-R130', 'Ne pas faire en routine de prophylaxie (mécanique ou pharmacologique) contre la maladie thromboembolique veineuse, sauf populations spécifiques à bénéfice potentiel supérieur aux risques/coûts.', '2-', 'Pédiatrie', 'Annexe 6 (SSC pédiatrique) — Transfusion, épuration extra-rénale/échanges plasmatiques, immunoglobulines & prophylaxie (Réf. 77)')) as v(code, statement, grade, population, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-du-sepsis-du-nouveau-ne-de-lenfant-et-de-ladulte-has-2025/'
on conflict (recommendation_code) do nothing;
