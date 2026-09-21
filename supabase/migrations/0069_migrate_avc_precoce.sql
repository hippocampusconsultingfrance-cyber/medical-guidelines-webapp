-- Migration : Accident vasculaire cérébral : prise en charge précoce
-- (alerte, phase préhospitalière, phase hospitalière initiale, indications
-- de la thrombolyse) (HAS, Recommandations de bonne pratique, mai 2009,
-- à la demande de la Société française neuro-vasculaire et de la DHOS)
-- Source : rfe-sfar-website/build/content_avc_precoce.json (54
-- recommandations atomiques identifiées à la lecture, réparties sur les 5
-- sous-sections cliniques du texte : l'alerte (13), la phase
-- préhospitalière (14), la phase hospitalière initiale (16), la
-- thrombolyse IV (8), la thrombolyse IA/combinée/mécanique (3) — dont 50
-- portent un tag de force explicite, exactement le compte que la fiche
-- construite annonce elle-même ("50 énoncés cliniques tagués — 1x grade A,
-- 2x grade B, 4x grade C, 43x accord professionnel — retranscrits un pour
-- un contre le texte source").
--
-- ⚠️ PROVENANCE — DISCLOSURE OBLIGATOIRE : `content_avc_precoce.json` fait
-- partie des 9 fichiers "KNOWN DRIFT" documentés dans `rfe-sfar-website/
-- CLAUDE.md` — récupéré depuis l'Artifact publié en ligne sans qu'aucun
-- `fiche_*.py` ni fichier source n'ait jamais été committé dans ce dépôt.
-- Ce contenu N'A PAS suivi le pipeline de triple-lecture + audit
-- indépendant normalement exigé par ce projet et N'A PAS été re-vérifié
-- contre le PDF source par cette migration. Statut `draft` comme toute
-- migration, mais attention de relecture supérieure recommandée (même
-- disclosure que `examens_preinterventionnels`/0065 et les fiches
-- suivantes de ce lot).
--
-- MÉTHODOLOGIE — grades HAS A/B/C + « accord professionnel » (AP), À LA
-- DIFFÉRENCE du GRADE 1+/2+ utilisé ailleurs dans ce corpus (même schéma
-- que `transfusion_plasma`/0049) : A = preuve scientifique établie (niveau
-- 1) ; B = présomption scientifique (niveau 2) ; C = faible niveau de
-- preuve (niveaux 3-4) ; AP = en l'absence d'études, avis du groupe de
-- travail après consultation du groupe de lecture — cas de la GRANDE
-- MAJORITÉ des recommandations de ce texte (43/50). `grade` reproduit
-- cette lettre/sigle tel quel. `evidence_level` laissé NULL (pas de niveau
-- distinct du grade HAS/AP lui-même). 4 énoncés cliniquement pertinents
-- mais explicitement SANS tag dans la source (le scanner cérébral à
-- défaut d'IRM ; l'orientation systématique vers une UNV ; la
-- sonothrombolyse ; la thrombolyse combinée/revascularisation mécanique)
-- ont `grade` NULL — reproduction fidèle de cette absence, jamais un tag
-- inventé pour compléter la ligne.
--
-- PÉRIMÈTRE — volontairement pas migrés en recommandations distinctes
-- (disclosure, pas un oubli) :
-- 1. L'Annexe 1 (algorithme de prise en charge précoce, restructuré par la
--    fiche construite en séquence de 5 boîtes) : chaîne opérationnelle à
--    un seul chemin décisionnel principal, déjà couverte en substance par
--    les recommandations individuelles migrées ci-dessus (alerte, phase
--    préhospitalière) — même traitement que les algorithmes/protocoles
--    opérationnels déjà exclus ailleurs dans ce corpus
--    (`infarctus_myocarde`/0068 Algorithme 3, `traumatisme_
--    vertebromedullaire`/0056).
-- 2. L'Annexe 2 (contre-indications de l'altéplase, extrait littéral du
--    RCP/AMM ACTILYSE®) : texte réglementaire du fabricant/de l'ANSM cité
--    tel quel par la source, PAS une recommandation formulée et gradée par
--    le groupe de travail HAS lui-même — donnée de référence pharmaceu-
--    tique, pas une proposition clinique de cette conférence.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Société française neuro-vasculaire et DHOS (Direction de
--    l'hospitalisation et de l'organisation des soins — une administration,
--    pas une société savante), toutes deux demandeurs explicites de ce
--    texte, ne figurent pas dans le seed Annexe B — seule la HAS
--    (promoteur méthodologique) est liée en `document_societies`.
-- 2. `library_final.json` ne donne que le mois/année ("mai 2009", pas de
--    jour précis) — `publication_date` utilise 2009-05-01 par convention
--    (même traitement que le cas "année seule" de `allergie_prevention`/
--    0006, étendu ici au cas "mois+année sans jour").
-- 3. Freshness : la source elle-même déclare "Les indications de la
--    thrombolyse et les techniques de revascularisation mécanique ont
--    évolué depuis 2009 (fenêtre thérapeutique élargie, thrombectomie
--    mécanique désormais recommandée dans certaines indications)" —
--    `freshness_status = 'revision_detectee'` retenu (même critère que
--    `infarctus_myocarde`/0068, `monitorage_traumatise`/0067).
-- 4. `population` laissé NULL sauf mentions explicites d'âge (R47 : "après
--    80 ans" ; R48 : "en dessous de 18 ans") — reproduites en clair dans
--    `population`.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Accident vasculaire cérébral : prise en charge précoce (alerte, phase préhospitalière, phase hospitalière initiale, indications de la thrombolyse)',
  'RBP', 'fr', '2009-05-01',
  'https://sfar.org/accident-vasculaire-cerebral-prise-en-charge-precoce/',
  'https://sfar.org/wp-content/uploads/2015/10/2_HAS_Accident-vasculaire-cerebral-prise-en-charge-precoce.pdf',
  'Grades HAS A/B/C (niveaux de preuve 1-4) + "accord professionnel" (AP, avis du groupe de travail en l''absence d''études), à la différence du GRADE 1+/2+ utilisé ailleurs dans ce corpus. 50 énoncés cliniques tagués (1xA, 2xB, 4xC, 43xAP) sur les sections cliniques retranscrites, retranscrits un pour un contre le texte source. evidence_level non applicable (pas de niveau distinct du grade HAS/AP).',
  'revision_detectee'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/accident-vasculaire-cerebral-prise-en-charge-precoce/'
  and s.acronym = 'HAS' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/accident-vasculaire-cerebral-prise-en-charge-precoce/'
  and s.slug in ('neurologie', 'medecine_d_urgence', 'anesthesie_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.source_section,
  'https://sfar.org/accident-vasculaire-cerebral-prise-en-charge-precoce/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000069-R01', 'Les symptômes de l''AVC doivent être connus par la population générale et plus particulièrement par les patients à risque/ATCD vasculaires, ainsi que leur entourage.', 'C', null, '2 — L''alerte'),
  ('MG-ANES-000069-R02', 'Il convient de sensibiliser les professionnels pour des filières préhospitalière et hospitalière initiale efficaces.', 'AP', null, '2 — L''alerte'),
  ('MG-ANES-000069-R03', 'Les campagnes d''information grand public doivent être encouragées et répétées (effet temporaire) ; ne pas se limiter aux patients à risque vasculaire, concerner toute la population y compris les jeunes.', 'C', null, '2 — L''alerte'),
  ('MG-ANES-000069-R04', 'Information du grand public — reconnaissance des symptômes : le message FAST (Face Arm Speech Time, dérivé de l''échelle de Cincinnati) est recommandé comme vecteur efficace.', 'AP', null, '2 — L''alerte'),
  ('MG-ANES-000069-R05', 'La prise en charge et les traitements de l''AVC sont urgents (admission en UNV et thrombolyse éventuelle), d''autant plus efficaces que précoces ; même régressifs, les symptômes imposent d''appeler le SAMU-Centre 15.', 'AP', null, '2 — L''alerte'),
  ('MG-ANES-000069-R06', 'Nécessité de laisser le patient allongé.', 'AP', null, '2 — L''alerte'),
  ('MG-ANES-000069-R07', 'Le médecin traitant doit informer les patients à risque (ATCD vasculaires, HTA, diabète, artériopathie des membres inférieurs) et leur entourage des signes de l''AVC ; préconiser l''appel immédiat au 15 avant tout appel à son cabinet ; expliquer l''importance de noter l''heure des premiers symptômes.', 'AP', null, '2 — L''alerte'),
  ('MG-ANES-000069-R08', 'En cas d''appel direct au médecin traitant : transférer l''appel au SAMU-Centre 15 et, au mieux, rester en ligne pour une conférence à 3 (appelant, médecin traitant, régulateur).', 'AP', null, '2 — L''alerte'),
  ('MG-ANES-000069-R09', 'Formation continue renforcée pour les permanenciers/standardistes des Centres 15, utilisant les 5 signes d''alerte de l''ASA (faiblesse/engourdissement brutal, baisse/perte de vision, difficulté de langage/compréhension, mal de tête sévère soudain, perte d''équilibre inexpliquée).', 'AP', null, '2 — L''alerte'),
  ('MG-ANES-000069-R10', 'Programmes de formation renforcés pour les acteurs du premier secours (pompiers, ambulanciers, secouristes), utilisant le message FAST.', 'AP', null, '2 — L''alerte'),
  ('MG-ANES-000069-R11', 'Développer la formation continue auprès de tous les professionnels de la filière d''urgence (généralistes, spécialistes, IDE, aides-soignants, kinésithérapeutes, orthophonistes...).', 'AP', null, '2 — L''alerte'),
  ('MG-ANES-000069-R12', 'Messages clés aux professionnels : tout déficit neurologique brutal, transitoire ou prolongé est une urgence absolue ; noter l''heure exacte de survenue ; connaître l''efficacité de la prise en charge en UNV et les traitements spécifiques.', 'AP', null, '2 — L''alerte'),
  ('MG-ANES-000069-R13', 'L''AIT est une urgence et justifie une prise en charge neuro-vasculaire immédiate pour confirmer le diagnostic, préciser l''étiologie et instaurer le traitement en urgence.', 'C', null, '2 — L''alerte'),
  ('MG-ANES-000069-R14', 'Utiliser un nombre limité d''échelles standardisées : échelle FAST (ou équivalent français) pour les paramédicaux/premiers secours (formation requise).', 'AP', null, '3 — Phase préhospitalière'),
  ('MG-ANES-000069-R15', 'Tout médecin urgentiste doit savoir utiliser l''échelle NIHSS (National Institute of Health Stroke Scale) et évaluer la sévérité de l''AVC.', 'AP', null, '3 — Phase préhospitalière'),
  ('MG-ANES-000069-R16', 'La gestion de l''appel initial pour suspicion d''AVC doit être faite par les centres de régulation médicale des SAMU-Centre 15.', 'AP', null, '3 — Phase préhospitalière'),
  ('MG-ANES-000069-R17', 'Des questionnaires ciblés et standardisés doivent être utilisés pour l''évaluation téléphonique des patients suspects d''AVC et pour aider à la décision du régulateur.', 'AP', null, '3 — Phase préhospitalière'),
  ('MG-ANES-000069-R18', 'Tout acte de régulation pour suspicion d''AVC/AIT comprend l''appel au médecin de l''UNV la plus proche ; l''orientation est décidée de concert entre régulateur et médecin UNV.', 'AP', null, '3 — Phase préhospitalière'),
  ('MG-ANES-000069-R19', 'L''envoi d''une équipe médicale (Smur) ne doit pas retarder la prise en charge ; il est nécessaire en cas de troubles de la vigilance, détresse respiratoire ou instabilité hémodynamique.', 'AP', null, '3 — Phase préhospitalière'),
  ('MG-ANES-000069-R20', 'Les centres de régulation doivent choisir le moyen de transport le plus rapide (aucune recommandation possible sur l''imagerie embarquée — à évaluer).', 'AP', null, '3 — Phase préhospitalière'),
  ('MG-ANES-000069-R21', 'Remplir une fiche standardisée : antécédents, traitements en cours, heure de début des symptômes, éléments de gravité clinique (NIHSS).', 'AP', null, '3 — Phase préhospitalière'),
  ('MG-ANES-000069-R22', 'En cas de transport médicalisé, effectuer les prélèvements sanguins pour le bilan biologique.', 'AP', null, '3 — Phase préhospitalière'),
  ('MG-ANES-000069-R23', 'Autoriser la réalisation d''une glycémie capillaire en préhospitalier par tous les acteurs de la chaîne d''urgence ; corriger l''hypoglycémie (pas de preuve pour débuter l''insuline en préhospitalier en cas d''hyperglycémie).', 'AP', null, '3 — Phase préhospitalière'),
  ('MG-ANES-000069-R24', 'Réaliser un électrocardiogramme en cas de médicalisation du transport.', 'AP', null, '3 — Phase préhospitalière'),
  ('MG-ANES-000069-R25', 'Privilégier le transport en décubitus dorsal, sauf signes d''HTIC, troubles de la vigilance, nausées/vomissements.', 'AP', null, '3 — Phase préhospitalière'),
  ('MG-ANES-000069-R26', 'Mesurer la pression artérielle ; pas d''argument pour traiter une HTA sauf indication extraneurologique associée (ex. décompensation cardiaque).', 'AP', null, '3 — Phase préhospitalière'),
  ('MG-ANES-000069-R27', 'Oxygénothérapie non systématique, sauf si SpO2 < 95 %.', 'AP', null, '3 — Phase préhospitalière'),
  ('MG-ANES-000069-R28', 'La filière intrahospitalière neuro-vasculaire doit être organisée au préalable, coordonnée (urgentistes, neurologues, radiologues, réanimateurs, biologistes) et formalisée par procédures écrites ; elle doit privilégier la rapidité d''accès à l''expertise neuro-vasculaire et à l''imagerie cérébrale, avec évaluation régulière de la performance de l''organisation.', 'AP', null, '4 — Phase hospitalière initiale'),
  ('MG-ANES-000069-R29', 'Les patients adressés à un établissement avec UNV doivent être pris en charge dès leur arrivée par un médecin de la filière neuro-vasculaire.', 'AP', null, '4 — Phase hospitalière initiale'),
  ('MG-ANES-000069-R30', 'Fiche standardisée (antécédents, traitements, heure de début, NIHSS) remplie dès l''admission si non faite en préhospitalier.', 'AP', null, '4 — Phase hospitalière initiale'),
  ('MG-ANES-000069-R31', 'ECG et bilan biologique (hémostase, hémogramme, glycémie capillaire) réalisés en urgence si non faits en préhospitalier.', 'AP', null, '4 — Phase hospitalière initiale'),
  ('MG-ANES-000069-R32', 'Monitoring de la pression artérielle, du rythme cardiaque, de la SpO2 et surveillance de la température.', 'AP', null, '4 — Phase hospitalière initiale'),
  ('MG-ANES-000069-R33', 'Les établissements sans UNV doivent structurer une filière de prise en charge des patients suspects d''AVC en coordination avec une UNV.', 'AP', null, '4 — Phase hospitalière initiale'),
  ('MG-ANES-000069-R34', 'Accès prioritaire 24h/24 et 7j/7 à l''imagerie cérébrale, avec protocoles formalisés et contractualisés avec le service de radiologie.', 'AP', null, '4 — Phase hospitalière initiale'),
  ('MG-ANES-000069-R35', 'L''IRM est l''examen le plus performant (ischémie récente précoce + hémorragie intracrânienne) et doit être privilégiée. Si accessible en urgence en 1ère intention : protocole court (séquences diffusion, FLAIR, écho de gradient).', 'B', null, '4 — Phase hospitalière initiale'),
  ('MG-ANES-000069-R36', 'À défaut d''IRM en urgence : scanner cérébral (montre inconstamment l''ischémie récente, visualise l''hémorragie intracrânienne).', null, null, '4 — Phase hospitalière initiale'),
  ('MG-ANES-000069-R37', 'Exploration des artères intracrâniennes par ARM cérébrale, angioscanner ou Doppler transcrânien.', 'AP', null, '4 — Phase hospitalière initiale'),
  ('MG-ANES-000069-R38', 'Exploration des artères cervicales précoce devant tout accident ischémique cérébral (urgente si AIT, infarctus mineur, accident fluctuant/évolutif) : écho-Doppler, ARM des vaisseaux cervico-encéphaliques avec gadolinium, ou angioscanner des troncs supra-aortiques.', 'B', null, '4 — Phase hospitalière initiale'),
  ('MG-ANES-000069-R39', 'Tout patient ayant un AVC doit être proposé à une UNV.', null, null, '4 — Phase hospitalière initiale'),
  ('MG-ANES-000069-R40', 'Hospitalisation en réanimation : décision au cas par cas, partagée par l''ensemble des professionnels (réanimateurs, neurologues), en respectant les souhaits du patient.', 'AP', null, '4 — Phase hospitalière initiale'),
  ('MG-ANES-000069-R41', 'Les décisions de limitation et d''arrêt de traitement doivent être prises de façon collégiale.', 'AP', null, '4 — Phase hospitalière initiale'),
  ('MG-ANES-000069-R42', 'Les réanimateurs sont aussi impliqués dans la prise en charge des patients en mort cérébrale.', 'AP', null, '4 — Phase hospitalière initiale'),
  ('MG-ANES-000069-R43', 'Avis neurochirurgical (après avis neuro-vasculaire) pour infarctus sylvien malin, infarctus/hématome cérébelleux compliqué d''HTIC, ou certains hématomes cérébraux hémisphériques.', 'AP', null, '4 — Phase hospitalière initiale'),
  ('MG-ANES-000069-R44', 'La thrombolyse IV par rt-PA des infarctus cérébraux est recommandée jusqu''à 4 h 30 (hors AMM).', 'AP', null, '5.1 — Thrombolyse intraveineuse (IV)'),
  ('MG-ANES-000069-R45', 'La thrombolyse IV doit être effectuée le plus tôt possible.', 'A', null, '5.1 — Thrombolyse intraveineuse (IV)'),
  ('MG-ANES-000069-R46', 'La thrombolyse IV peut être envisagée après 80 ans jusqu''à 3 heures.', 'AP', 'Sujet âgé (> 80 ans)', '5.1 — Thrombolyse intraveineuse (IV)'),
  ('MG-ANES-000069-R47', 'En dessous de 18 ans, les indications de thrombolyse IV sont discutées au cas par cas avec un neurologue d''UNV.', 'AP', 'Pédiatrie (< 18 ans)', '5.1 — Thrombolyse intraveineuse (IV)'),
  ('MG-ANES-000069-R48', 'Une glycémie initiale > 11 mmol/l doit conduire à réévaluer l''indication de la thrombolyse, du fait du risque hémorragique accru.', 'C', null, '5.1 — Thrombolyse intraveineuse (IV)'),
  ('MG-ANES-000069-R49', 'Les données actuelles ne permettent pas de recommander la sonothrombolyse.', null, null, '5.1 — Thrombolyse intraveineuse (IV)'),
  ('MG-ANES-000069-R50', 'Dans les établissements avec UNV : thrombolyse IV prescrite par un neurologue (AMM) et/ou un médecin titulaire du DIU de pathologie neuro-vasculaire (hors AMM) ; patient surveillé au sein de l''UNV.', 'AP', null, '5.1 — Thrombolyse intraveineuse (IV)'),
  ('MG-ANES-000069-R51', 'Dans les établissements sans UNV : indication portée par téléconsultation du médecin neuro-vasculaire de l''UNV où le patient sera transféré après thrombolyse (hors AMM).', 'AP', null, '5.1 — Thrombolyse intraveineuse (IV)'),
  ('MG-ANES-000069-R52', 'Décisions de thrombolyse intra-artérielle (IA) au cas par cas, après concertation entre neurologues vasculaires et neuroradiologues, jusqu''à 6 h pour les occlusions de l''artère cérébrale moyenne, voire au-delà pour les occlusions du tronc basilaire (gravité extrême) (hors AMM).', 'AP', null, '5.2 — Thrombolyse intra-artérielle, combinée et revascularisation mécanique'),
  ('MG-ANES-000069-R53', 'La thrombolyse IA doit être réalisée dans un établissement disposant d''un centre de neuroradiologie interventionnelle autorisé (SIOS) et d''une UNV.', 'AP', null, '5.2 — Thrombolyse intra-artérielle, combinée et revascularisation mécanique'),
  ('MG-ANES-000069-R54', 'La thrombolyse combinée (IV puis IA) et la revascularisation mécanique (thrombectomie ou ultrasons par voie endovasculaire) ne sont pas recommandées et doivent être évaluées.', null, null, '5.2 — Thrombolyse intra-artérielle, combinée et revascularisation mécanique')
) as v(code, statement, grade, population, source_section)
where d.source_url = 'https://sfar.org/accident-vasculaire-cerebral-prise-en-charge-precoce/'
on conflict (recommendation_code) do nothing;
