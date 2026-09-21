-- Migration : Prise en charge de la patiente avec une pré-éclampsie sévère —
-- Recommandations Formalisées d'Experts communes SFAR-CNGOF. 25 experts
-- (coord. M-P Bonnet, H. Keita, M-V Sénat, T. Schmitz, L. Sentilhes). Texte
-- validé par le Comité des Référentiels Cliniques SFAR le 08/07/2020, par le
-- CA SFAR le 04/09/2020. Source : rfe-sfar-website/build/content_preeclampsie.json
-- (27 recommandations réparties en 7 champs + 3 questions sans recommandation
-- possible).
--
-- MÉTHODOLOGIE : GRADE (force forte 1+/1-, force faible 2+/2-, avis d'experts
-- AE). `grade` reproduit tel quel le chip source. `evidence_level` laissé
-- NULL.
--
-- COMPTAGE — DIVERGENCE DISCLOSÉE, NON RÉSOLUE (principe 1.5 du projet) : le
-- résumé officiel de la source annonce « 25 recommandations (8 GRADE 1, 9
-- GRADE 2, avis d'experts pour le reste) ». Un inventaire direct, vérifié
-- tag par tag sur l'ensemble du document (7 champs), dénombre 27
-- recommandations numérotées R1.1 à R6.5 : 8 GRADE1 (6×1+, 2×1-) et 9 GRADE2
-- (7×2+, 2×2-) — CES DEUX SOUS-TOTAUX CONCORDENT EXACTEMENT avec le résumé
-- officiel — mais 10 avis d'experts (AE) sont dénombrés au lieu des 8
-- implicitement attendus (25-8-9=8). L'écart de 2 correspond très
-- précisément à R1.1 et R1.2 (Champ 1, définition de la pré-éclampsie
-- sévère et de son aggravation) : ces deux items portent chacun un tag
-- « avis d'experts » individuel et distinct dans le contenu construit, mais
-- pourraient avoir été comptés comme une seule entrée définitionnelle par le
-- résumé officiel de la source (hypothèse plausible, non vérifiable sans le
-- texte intégral de l'argumentaire) — reproduits ici comme 2 recommandations
-- distinctes puisque c'est ce qui est réellement imprimé, sans forcer le
-- total à 25. Les 3 « questions sans recommandation possible » annoncées
-- par le résumé sont, elles, exactement reconciliées (fullPIERS/Champ 1,
-- échographie thoracique/Champ 3, simulation/aides cognitives/Champ 7).
--
-- SUPERSESSION DISCLOSÉE, NON RÉSOLUE : la source dit elle-même se
-- substituer aux recommandations SFAR/CNGOF antérieures sur le même champ.
-- `library_final.json` liste pourtant encore une RFE 2009/2010 "Prise en
-- charge multidisciplinaire des formes graves de prééclampsie" comme
-- "en vigueur" (href distinct) — incohérence de cet index disclosée, hors
-- périmètre de correction de ce projet (même pattern que mtev_perioperatoire
-- / RFE SFAR 2011 remplacée, cf. migration 0033).
--
-- PÉRIMÈTRE — volontairement pas migrés (cohérent avec le principe déjà
-- appliqué ailleurs dans ce corpus) : l'algorithme de prise en charge
-- thérapeutique de l'HTA (Champ 2, tableau à 2 colonnes "Absence de signe de
-- gravité" / "Présence d'un signe de gravité", sans chip de grade propre —
-- restatement du contenu déjà couvert par R2.1-R2.7 sous forme de
-- synoptique) ; le rappel posologique du sulfate de magnésium (protocole de
-- référence des essais inclus dans l'argumentaire, pas une recommandation
-- graduée) ; la note sur la prudence d'utilisation des antihypertenseurs IV
-- en bolus (Champ 3, information contextuelle, pas un énoncé numéroté) ; les
-- 3 panneaux « Absence de recommandation » (fullPIERS, échographie
-- thoracique, simulation/aides cognitives — les experts déclarent
-- explicitement ne pas pouvoir statuer, faute de données, cohérent avec le
-- principe du projet).
--
-- POPULATION : l'intégralité du document concerne une population unique
-- (patientes avec pré-éclampsie sévère, période anté- et post-partum) —
-- `population` laissé NULL sur toutes les lignes plutôt que de répéter une
-- valeur constante non discriminante (contrairement aux fiches où seul un
-- sous-ensemble des recommandations est spécifique à une population, ex.
-- pédiatrie dans `pavm`/0037).
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SFAR et CNGOF (toutes deux dans le seed Annexe B) liées en
--    document_societies.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge de la patiente avec une pré-éclampsie sévère',
  'RFE', 'fr', '2020-12-19',
  'https://sfar.org/prise-en-charge-de-la-patiente-avec-une-pre-eclampsie-severe/',
  'https://sfar.org/download/rfe-prise-en-charge-de-la-patiente-avec-une-pre-eclampsie-severe-2/?wpdmdl=34698',
  'GRADE® : force forte (1+ recommandé / 1- non recommandé) ou faible (2+ proposé / 2- proposé de ne pas faire) ; avis d''experts (AE). Résumé officiel "25 recommandations, 8 GRADE1, 9 GRADE2" ; comptage direct tag par tag trouve 27 recommandations (8 GRADE1, 9 GRADE2 — sous-totaux concordants — mais 10 AE au lieu de 8 implicites). Écart isolé précisément à R1.1/R1.2 (Champ 1). Divergence disclosée, non résolue.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-de-la-patiente-avec-une-pre-eclampsie-severe/'
  and s.acronym in ('SFAR', 'CNGOF') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-de-la-patiente-avec-une-pre-eclampsie-severe/'
  and s.slug in ('anesthesie_reanimation', 'gynecologie_obstetrique', 'medecine_intensive_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/prise-en-charge-de-la-patiente-avec-une-pre-eclampsie-severe/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000038-R01', 'Au moins un des critères suivants définit la pré-éclampsie sévère : HTA sévère (PAS >= 160 mmHg et/ou PAD >= 110 mmHg) ou non contrôlée ; protéinurie > 3 g/24h ; créatininémie >= 90 µmol/L ; oligurie <= 500 mL/24h ou <= 25 mL/h ; thrombopénie < 100 000/mm³ ; cytolyse hépatique ASAT/ALAT > 2N ; douleur abdominale épigastrique et/ou de l''hypochondre droit « en barre » persistante ou intense ; douleur thoracique, dyspnée, œdème aigu du poumon ; signes neurologiques (céphalées sévères ne répondant pas au traitement, troubles visuels ou auditifs persistants, réflexes ostéo-tendineux vifs, diffusés et polycinétiques).', 'AE', 'Champ 1 — Définition et signes de gravité (Réf. R1.1)'),
  ('MG-ANES-000038-R02', 'Au-delà des valeurs seuils définissant la pré-éclampsie sévère (R1.1), une aggravation de ces paramètres constitue également un critère diagnostique de pré-éclampsie sévère.', 'AE', 'Champ 1 — Définition et signes de gravité (Réf. R1.2)'),
  ('MG-ANES-000038-R03', 'Signes cliniques ou biologiques de gravité, déclenchant une prise en charge plus intensive : PAS >= 180 mmHg et/ou PAD >= 120 mmHg ; douleur abdominale épigastrique et/ou de l''hypochondre droit « en barre » persistante ou intense ; céphalées sévères ne répondant pas au traitement, troubles visuels ou auditifs persistants, déficit neurologique, troubles de la conscience, réflexes ostéo-tendineux vifs, diffusés et polycinétiques ; détresse respiratoire, œdème aigu du poumon ; HELLP syndrome ; insuffisance rénale aiguë.', 'AE', 'Champ 1 — Définition et signes de gravité, accord fort (Réf. R1.3)'),
  ('MG-ANES-000038-R04', 'Administrer systématiquement un traitement antihypertenseur chez les patientes avec une pré-éclampsie sévère présentant une PAS >= 160 mmHg et/ou une PAD >= 110 mmHg au repos et persistant durant plus de 15 minutes, et maintenir la pression artérielle en dessous de ces seuils, pour réduire la survenue de complications maternelles, fœtales et néonatales sévères.', '1+', 'Champ 2 — Traitement antihypertenseur (Réf. R2.1)'),
  ('MG-ANES-000038-R05', 'En cas de pré-éclampsie sévère avec au moins un signe de gravité (R1.3), ou d''HTA sévère persistant malgré un traitement oral en mono ou bithérapie : administrer le traitement antihypertenseur par voie intraveineuse.', '1+', 'Champ 2 — Traitement antihypertenseur (Réf. R2.2)'),
  ('MG-ANES-000038-R06', 'Lorsqu''un antihypertenseur IV est indiqué : utiliser le labétalol en 1ère intention.', '2+', 'Champ 2 — Traitement antihypertenseur (Réf. R2.3)'),
  ('MG-ANES-000038-R07', 'Utiliser la nicardipine ou l''urapidil en association au labétalol IV si la PA n''est pas contrôlée, ou à sa place en cas de contre-indication aux bêtabloquants.', '2+', 'Champ 2 — Traitement antihypertenseur (Réf. R2.4)'),
  ('MG-ANES-000038-R08', 'HTA contrôlée par antihypertenseur IV : poursuivre le traitement et faire un relais par un antihypertenseur par voie orale, pour réduire le risque de récidive d''HTA sévère.', 'AE', 'Champ 2 — Traitement antihypertenseur (Réf. R2.5)'),
  ('MG-ANES-000038-R09', 'HTA contrôlée sous IV (PAS < 160 mmHg et PAD < 110 mmHg) : utiliser en relais le labétalol en 1ère intention comme antihypertenseur oral.', '2+', 'Champ 2 — Traitement antihypertenseur (Réf. R2.6)'),
  ('MG-ANES-000038-R10', 'Utiliser la nicardipine ou l''alpha-méthyldopa en association au labétalol per os si la PA n''est pas contrôlée, ou à sa place en cas de contre-indication aux bêtabloquants.', 'AE', 'Champ 2 — Traitement antihypertenseur (Réf. R2.7)'),
  ('MG-ANES-000038-R11', 'Administrer en anténatal du sulfate de magnésium aux femmes avec une pré-éclampsie sévère avec au moins un signe clinique de gravité (R1.3), afin de réduire le risque de survenue d''une éclampsie.', '1+', 'Champ 2 — Sulfate de magnésium, remplissage, corticoïdes (Réf. R2.8)'),
  ('MG-ANES-000038-R12', 'Chez les femmes avec une pré-éclampsie sévère avec au moins un signe clinique de gravité (R1.3) : administrer du sulfate de magnésium afin de réduire le risque de survenue d''un hématome rétro-placentaire.', '2+', 'Champ 2 — Sulfate de magnésium, remplissage, corticoïdes (Réf. R2.9)'),
  ('MG-ANES-000038-R13', 'Ne pas réaliser de remplissage vasculaire systématique des femmes avec une pré-éclampsie sévère (aucun bénéfice démontré ; tendance à un effet délétère).', '1-', 'Champ 2 — Sulfate de magnésium, remplissage, corticoïdes (Réf. R2.10)'),
  ('MG-ANES-000038-R14', 'Ne pas administrer de glucocorticoïdes pour réduire la morbidité maternelle, y compris en cas de HELLP syndrome.', '1-', 'Champ 2 — Sulfate de magnésium, remplissage, corticoïdes (Réf. R2.11)'),
  ('MG-ANES-000038-R15', 'Chez les femmes ayant eu une crise d''éclampsie : administrer du sulfate de magnésium en 1ère intention (plutôt qu''une benzodiazépine), afin de réduire le risque de mortalité maternelle et de récidive d''éclampsie.', '1+', 'Champ 2 — Sulfate de magnésium, remplissage, corticoïdes (Réf. R2.12)'),
  ('MG-ANES-000038-R16', 'En cas de pré-éclampsie sévère avec signes de gravité (R1.3) : surveillance multidisciplinaire dans une unité permettant un monitorage maternel continu (lieu à décider localement selon l''organisation des soins).', 'AE', 'Champ 3 — Surveillance / évaluation (Réf. R3.1)'),
  ('MG-ANES-000038-R17', 'Entre 24 et 34 SA : poursuivre la grossesse jusqu''à 34 SA, en l''absence de signes de gravité surajoutés maternels ou fœtaux (R1.3), afin de réduire la morbidité néonatale sans augmenter significativement la morbidité maternelle.', '1+', 'Champ 4 — Critères d''arrêt de grossesse (Réf. R4.1)'),
  ('MG-ANES-000038-R18', 'Compte tenu de l''absence de bénéfice associé à une césarienne programmée : ne pas réaliser de césarienne systématique en cas de pré-éclampsie sévère.', 'AE', 'Champ 4 — Critères d''arrêt de grossesse (Réf. R4.2)'),
  ('MG-ANES-000038-R19', 'Après une crise d''éclampsie, en l''absence d''urgence vitale maternelle ou fœtale : stabiliser l''état clinique maternel et initier le traitement par sulfate de magnésium avant la décision de naissance.', 'AE', 'Champ 4 — Critères d''arrêt de grossesse (Réf. R4.3)'),
  ('MG-ANES-000038-R20', 'Césarienne chez une femme pré-éclamptique sévère : réaliser une anesthésie périmédullaire plutôt qu''une anesthésie générale, pour réduire la morbidité maternelle.', '2+', 'Champ 5 — Prise en charge anesthésique (Réf. R5.1)'),
  ('MG-ANES-000038-R21', 'En cas d''anesthésie générale : injecter un morphinique ou un agent antihypertenseur à l''induction, afin de limiter les conséquences hémodynamiques de l''intubation trachéale.', '2+', 'Champ 5 — Prise en charge anesthésique (Réf. R5.2)'),
  ('MG-ANES-000038-R22', 'Utiliser en 1ère intention un bolus de 0,5 µg/kg de rémifentanil dans cette indication. L''alfentanil et l''esmolol représentent des alternatives thérapeutiques.', '2+', 'Champ 5 — Prise en charge anesthésique (Réf. R5.3)'),
  ('MG-ANES-000038-R23', 'Éclampsie inaugurale en postpartum : introduire un traitement par sulfate de magnésium pour réduire le risque de récidive d''éclampsie.', '1+', 'Champ 6 — Prise en charge postpartum (Réf. R6.1)'),
  ('MG-ANES-000038-R24', 'Pré-éclampsie sévère SANS éclampsie : ne pas initier ni poursuivre en postpartum un traitement par sulfate de magnésium.', '2-', 'Champ 6 — Prise en charge postpartum (Réf. R6.2)'),
  ('MG-ANES-000038-R25', 'Ne pas administrer systématiquement de diurétiques dans le postpartum pour diminuer la morbidité maternelle.', '2-', 'Champ 6 — Prise en charge postpartum (Réf. R6.3)'),
  ('MG-ANES-000038-R26', 'Faire reposer l''indication d''un traitement thromboprophylactique postpartum sur un calcul de risque de complications thromboemboliques (ex. score CNGOF 2015).', 'AE', 'Champ 6 — Prise en charge postpartum (Réf. R6.4)'),
  ('MG-ANES-000038-R27', 'Après une crise d''éclampsie : réaliser systématiquement une imagerie cérébrale, compte tenu de la fréquence élevée des diagnostics différentiels (PRES, AVC, thrombophlébite cérébrale…) et du risque de complications neurologiques sévères.', 'AE', 'Champ 6 — Prise en charge postpartum (Réf. R6.5)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-de-la-patiente-avec-une-pre-eclampsie-severe/'
on conflict (recommendation_code) do nothing;
