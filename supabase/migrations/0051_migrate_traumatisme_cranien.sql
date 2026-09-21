-- Migration : Prises en charge neurochirurgicales des traumatismes
-- cranio-encéphaliques de l'adulte et de l'enfant à la phase initiale —
-- RPP de la SFNC (Société Française de Neurochirurgie), avec SFNCP, SFNCL,
-- ANARLF, SFAR, GFRUP, SFNR, SPILF, SOFMER. V1.13, 19/03/2025 (R. Manet, A.
-- Dagain, H. de Courson, J-F. Payen), publiée sur sfar.org le 19/09/2025.
-- **Première RPP portée spécifiquement par la neurochirurgie depuis 2006**
-- (disclosure de la source elle-même) — les recommandations françaises
-- existantes sur le TC (SFAR/SFMU, monitorage cérébral) ne couvraient pas
-- les indications et modalités des gestes neurochirurgicaux eux-mêmes.
-- Source : rfe-sfar-website/build/content_traumatisme_cranien.json (43
-- recommandations réelles réparties en 7 champs, + 2 items « Absence de
-- recommandation »).
--
-- MÉTHODOLOGIE — GRADE® SIMPLIFIÉ À 2 NIVEAUX : cette RPP ne comporte ni
-- palier « GRADE 1 » ni suffixe +/- imprimé sur ses tags (contrairement
-- aux RFE classiques du corpus) — seuls « GRADE 2 (ACCORD FORT) » et « AVIS
-- D'EXPERTS (ACCORD FORT) » existent littéralement dans le texte source.
-- **Le sens (+/-) de chaque « GRADE 2 » est déduit de la formulation
-- littérale de la phrase** ("il est probablement recommandé de…" = 2+,
-- "il n'est probablement pas recommandé de…" = 2-) et non retypé depuis un
-- tag source qui ne le précise pas — disclosure explicite de cette
-- dérivation, conservée. **Incohérence source relevée et signalée par le
-- contenu construit lui-même (vérifiée par rendu visuel de la page 11),
-- non corrigée silencieusement** : R6.4 utilise la formule verbale du
-- Grade 2 ("il est probablement recommandé") mais est littéralement taguée
-- "AVIS D'EXPERTS" — le tag imprimé fait foi (chippée 'AE' ici, pas '2+').
-- `grade` reproduit tel quel le chip source (déjà résolu par le contenu
-- construit selon les règles ci-dessus). `evidence_level` laissé NULL.
--
-- COMPTAGE — "43" ET "45" RÉCONCILIÉS PAR LA SOURCE ELLE-MÊME, REPRODUIT
-- TEL QUEL : le résumé officiel annonce "45 items formulés", dont 43
-- recommandations réelles (39 avis d'experts + 4 "GRADE 2") et 2 "ABSENCE
-- DE RECOMMANDATION" explicites — ce qui réconcilie le chiffre "43"
-- affiché sur la page sfar.org avec le "45" du résumé officiel : les deux
-- comptent des ensembles différents, aucune divergence réelle. Inventaire
-- direct confirme exactement 43 recommandations migrées (39 AE + 3×2+ +
-- 1×2- = 43), R1.1 à R15.2.
--
-- PÉRIMÈTRE — volontairement pas migrés : les 2 items "Absence de
-- recommandation" (R11.4 : modalité endovasculaire vs chirurgicale du
-- traitement d'une lésion vasculaire intracrânienne, à discuter
-- collégialement ; R14.2 : craniectomie décompressive dans les TC non
-- accidentels du nourrisson) — cohérent avec le principe du projet. Les
-- annexes de référence (mFI-5, score SPIN, critères scanographiques de
-- mauvais pronostic du TC pénétrant, GOSE) — outils diagnostiques/
-- pronostiques, pas des recommandations graduées. La Clinical Frailty
-- Scale (9 niveaux), elle-même non reproduite intégralement par le contenu
-- construit (transcrite depuis une image source sans couche de texte,
-- "non reproduite ici par souci de place" — disclosure du contenu
-- construit), n'a donc pas de contenu à migrer au-delà du seuil déjà cité
-- dans R2.2 (CFS ≥ 4 = fragile). Exclusions explicites de la source
-- elle-même : dérivation ventriculaire externe et craniectomie
-- décompressive (adulte et enfant), déjà couvertes par d'autres
-- référentiels existants — disclosure de portée, pas une omission de ma
-- part.
--
-- POPULATION : les 7 recommandations du Champ 7 (Particularités
-- pédiatriques — nouveau-né et nourrisson <2 ans) taguées `population =
-- 'Pédiatrie'` ; le reste (adulte par défaut) laissé NULL.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SFAR et SPILF (2 des 9 sociétés du groupe de travail, toutes deux
--    dans le seed Annexe B) liées en document_societies. SFNC
--    (coordinatrice principale), SFNCP, SFNCL, ANARLF, GFRUP, SFNR et
--    SOFMER hors seed, non liées.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prises en charge neurochirurgicales des traumatismes cranio-encéphaliques de l''adulte et de l''enfant à la phase initiale',
  'RPP', 'fr', '2025-09-19',
  'https://sfar.org/prise-en-charge-neurochirurgicales-des-traumatismes-cranio-encephaliques-de-ladulte-et-de-lenfant-a-la-phase-initiale/',
  'https://sfar.org/download/prise-en-charge-neurochirurgicales-des-traumatismes-cranio-encephaliques-de-ladulte-et-de-lenfant-a-la-phase-initiale/?wpdmdl=123224',
  'GRADE® simplifié à 2 niveaux (pas de palier GRADE 1, pas de suffixe +/- imprimé) : "GRADE 2 (accord fort)" et "avis d''experts (accord fort)" seuls existent littéralement dans le texte source ; le sens +/- du GRADE 2 est déduit de la formulation littérale de chaque phrase (disclosure explicite). Incohérence source relevée (R6.4 : formule verbale de Grade 2 mais tag littéral "avis d''experts") — tag imprimé retenu, non réharmonisé. Comptage source "43 recommandations réelles (39 AE + 4 GRADE2) + 2 absence de recommandation, total 45 items" exactement reconcilié.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-neurochirurgicales-des-traumatismes-cranio-encephaliques-de-ladulte-et-de-lenfant-a-la-phase-initiale/'
  and s.acronym in ('SFAR', 'SPILF') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-neurochirurgicales-des-traumatismes-cranio-encephaliques-de-ladulte-et-de-lenfant-a-la-phase-initiale/'
  and s.slug in ('neurochirurgie', 'anesthesie_reanimation', 'medecine_intensive_reanimation', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.source_section,
  'https://sfar.org/prise-en-charge-neurochirurgicales-des-traumatismes-cranio-encephaliques-de-ladulte-et-de-lenfant-a-la-phase-initiale/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000051-R01', 'Chez le patient présentant un TC grave, nécessitant théoriquement une craniotomie en urgence, mais présentant des caractéristiques jugées « dépassées » (ne laissant aucun espoir de pronostic favorable), l''abstention neurochirurgicale précoce (avant 72h) doit systématiquement faire l''objet d''une décision collégiale, impliquant chaque fois que possible trois médecins séniors (neurochirurgien, anesthésiste-réanimateur, médecin rééducateur).', 'AE', null, 'Champ 1 — Facteurs de mauvais pronostic (craniotomie en urgence, adulte) (Réf. R1.1)'),
  ('MG-ANES-000051-R02', 'En période de permanence des soins, une « collégialité restreinte » doit être mise en œuvre, impliquant au moins 2 médecins séniors pour permettre une meilleure évaluation du pronostic.', 'AE', null, 'Champ 1 — Facteurs de mauvais pronostic (craniotomie en urgence, adulte) (Réf. R1.2)'),
  ('MG-ANES-000051-R03', 'Chez un patient victime de TC grave nécessitant une craniotomie en urgence, il est probablement recommandé de considérer les indices de fragilité pathologiques pour évaluer le pronostic, mais pas de manière isolée pour contre-indiquer le geste.', '2+', null, 'Champ 1 — Facteurs de mauvais pronostic (craniotomie en urgence, adulte) (Réf. R2.1)'),
  ('MG-ANES-000051-R04', 'Les scores suivants (détaillés en annexe ci-dessous) peuvent être considérés comme pathologiques pour évaluer le pronostic : mFI-5 ≥ 2 ; Clinical Frailty Scale ≥ 4.', 'AE', null, 'Champ 1 — Facteurs de mauvais pronostic (craniotomie en urgence, adulte) (Réf. R2.2)'),
  ('MG-ANES-000051-R05', 'Chez un patient présentant un TC grave nécessitant une craniotomie en urgence, la présence à la prise en charge d''une mydriase bilatérale aréactive non régressive (idéalement évaluée par pupillométrie automatisée) doit être considérée comme un facteur de mauvais pronostic, mais ne doit pas être considérée de manière isolée pour contre-indiquer le geste, en particulier si la mydriase est installée depuis moins de 2h.', 'AE', null, 'Champ 1 — Facteurs de mauvais pronostic (craniotomie en urgence, adulte) (Réf. R3)'),
  ('MG-ANES-000051-R06', 'Chez un patient victime de TC grave nécessitant une craniotomie en urgence, il ne faut pas prendre en compte le délai de prise en charge de manière isolée dans l''évaluation du pronostic et la décision neurochirurgicale.', 'AE', null, 'Champ 1 — Facteurs de mauvais pronostic (craniotomie en urgence, adulte) (Réf. R4)'),
  ('MG-ANES-000051-R07', 'Chez les patients nécessitant une craniotomie en urgence, en particulier chez ceux de plus de 65 ans, il est probablement recommandé de considérer, de manière non isolée, la présence d''un traitement anticoagulant (AVK ou AOD) comme facteur de mauvais pronostic, mais sans que cela ne contre-indique le geste de manière isolée.', '2+', null, 'Champ 1 — Facteurs de mauvais pronostic (craniotomie en urgence, adulte) (Réf. R5.1)'),
  ('MG-ANES-000051-R08', 'Chez un patient présentant un TC grave nécessitant une craniotomie en urgence, il n''est probablement pas recommandé de considérer la présence d''un traitement anti-agrégant plaquettaire en monothérapie par aspirine comme un facteur de mauvais pronostic ; cela ne doit pas influencer l''indication opératoire.', '2-', null, 'Champ 1 — Facteurs de mauvais pronostic (craniotomie en urgence, adulte) (Réf. R5.2)'),
  ('MG-ANES-000051-R09', 'Chez le patient présentant un TC associé à un hématome extra-dural (HED), il faut réaliser l''évacuation chirurgicale en urgence dans l''une ou plusieurs des circonstances suivantes : GCS ≤ 8 ; mydriase ; volume > 30 mL ; déviation de la ligne médiane > 5 mm ; compression du tronc cérébral ; signe de saignement actif (swirl sign).', 'AE', null, 'Champ 2 — Hématomes extra-duraux (Réf. R6.1)'),
  ('MG-ANES-000051-R10', 'Il faut privilégier un traitement conservateur en cas d''HED d''origine artérielle sans signe de gravité clinique et radiologique (cf. R6.1).', 'AE', null, 'Champ 2 — Hématomes extra-duraux (Réf. R6.2)'),
  ('MG-ANES-000051-R11', 'Pour un HED d''origine veineuse, il faut évaluer la balance bénéfice-risque d''une prise en charge conservatrice au cas par cas, y compris en présence de signe de gravité, compte tenu des difficultés chirurgicales (plaie de sinus dural).', 'AE', null, 'Champ 2 — Hématomes extra-duraux (Réf. R6.3)'),
  ('MG-ANES-000051-R12', 'En cas de décision de traitement conservateur, il faut effectuer une surveillance clinique rapprochée dans un centre doté d''un service de neurochirurgie.', 'AE', null, 'Champ 2 — Hématomes extra-duraux (Réf. R6.4)'),
  ('MG-ANES-000051-R13', 'En cas de traitement conservateur, il est probablement recommandé de réaliser un scanner de contrôle systématiquement à 6 heures post-traumatisme (si le premier scanner a été fait avant H6), ou plus précocement en cas d''aggravation clinique.', '2+', null, 'Champ 2 — Hématomes extra-duraux (Réf. R6.5)'),
  ('MG-ANES-000051-R14', 'Il faut réaliser l''évacuation chirurgicale en urgence d''un hématome sous-dural aigu (HSDA) dans les circonstances suivantes, cumulativement : âge <65 ans (ou 65-80 ans avec score de fragilité faible) ET troubles de vigilance (GCS≤8 et/ou GCS≤12 mais perte rapide de ≥2 points de GCS) non expliqués par un autre mécanisme, ou HTIC réfractaire ET critères radiologiques (épaisseur >10mm et/ou déviation de la ligne médiane >5mm).', 'AE', null, 'Champ 3 — Hématomes sous-duraux aigus (Réf. R7.1)'),
  ('MG-ANES-000051-R15', 'En cas de resaignement au sein d''un hématome sous-dural chronique, il faut envisager une chirurgie différée, moins invasive.', 'AE', null, 'Champ 3 — Hématomes sous-duraux aigus (Réf. R7.2)'),
  ('MG-ANES-000051-R16', 'En dehors des circonstances ci-dessus, il faut préférer un traitement conservateur, avec scanner de contrôle : en urgence si évolution clinique péjorative ; précocement (7-10j) si réintroduction d''un traitement antithrombotique ; à distance (3-4 semaines) dans les autres cas.', 'AE', null, 'Champ 3 — Hématomes sous-duraux aigus (Réf. R7.3)'),
  ('MG-ANES-000051-R17', 'En cas d''embarrure, il faut réaliser une prise en charge chirurgicale rapide (dans les 24h), afin d''améliorer le pronostic neurologique ou esthétique, dans l''une ou plusieurs des circonstances suivantes : plaie complexe/contaminée ou signes d''infection locale ; plaie durale suspectée/pneumencéphalie ; issue de LCS ; effet de masse significatif ; autre(s) lésion(s) neurochirurgicale(s) ; préjudice esthétique majeur.', 'AE', null, 'Champ 4 — Embarrures et brèches ostéo-durales de la base du crâne (Réf. R8.1)'),
  ('MG-ANES-000051-R18', 'En cas d''embarrure des sinus frontaux, il faut réaliser une réduction/ostéosynthèse de la paroi antérieure, en l''absence de défect majeur de la paroi postérieure, de brèche durale évidente, ou d''atteinte des canaux naso-frontaux. Sinon, le geste doit être complété par une cranialisation des sinus frontaux.', 'AE', null, 'Champ 4 — Embarrures et brèches ostéo-durales de la base du crâne (Réf. R8.2)'),
  ('MG-ANES-000051-R19', 'En cas de TC non pénétrant associé à une embarrure et à une crise épileptique, il faut instaurer une prophylaxie antiépileptique secondaire ; une prophylaxie primaire ne doit pas être systématique.', 'AE', null, 'Champ 4 — Embarrures et brèches ostéo-durales de la base du crâne (Réf. R8.3)'),
  ('MG-ANES-000051-R20', 'En cas de brèche ostéoméningée (BOM) traumatique, il faut réaliser une chirurgie rapide (dans les 24h) uniquement en cas de défect dural majeur associé à une liquorrhée abondante. En cas d''indication neurochirurgicale pour d''autres lésions associées, la fermeture de la BOM dans le même temps opératoire est déconseillée en cas d''hypertension intracrânienne.', 'AE', null, 'Champ 4 — Embarrures et brèches ostéo-durales de la base du crâne (Réf. R9.1)'),
  ('MG-ANES-000051-R21', 'Il faut envisager la chirurgie en cas de liquorrhée non abondante réfractaire à un traitement conservateur au-delà de 7 jours.', 'AE', null, 'Champ 4 — Embarrures et brèches ostéo-durales de la base du crâne (Réf. R9.2)'),
  ('MG-ANES-000051-R22', 'Il faut associer au traitement conservateur des BOM un alitement en proclive à 30°, ainsi que la prescription de laxatifs, d''antitussifs et d''antiémétiques pendant au moins 72h.', 'AE', null, 'Champ 4 — Embarrures et brèches ostéo-durales de la base du crâne (Réf. R9.3)'),
  ('MG-ANES-000051-R23', 'Il faut réaliser ou mettre à jour les vaccinations suivantes : anti-pneumococcique (vaccin conjugué 15-valent chez le moins de 18 ans, 1 dose chez le plus de 2 ans ; ou 20-valent chez le plus de 18 ans, 1 dose non suivie de vaccin non-conjugué) ; anti-Haemophilus influenzae (1 dose) ; anti-méningococcique B et ACYW (rattrapage selon les recommandations générales : méningocoque ABCYW avant 2 ans et ACYW avant 25 ans).', 'AE', null, 'Champ 4 — Embarrures et brèches ostéo-durales de la base du crâne (Réf. R9.4)'),
  ('MG-ANES-000051-R24', 'Il faut débuter la recherche d''une BOM traumatique par un scanner en fenêtre osseuse (coupes millimétriques) et une IRM incluant des séquences 3DT2 haute résolution. En cas de doute persistant, un myéloscanner puis une cisternographie isotopique peuvent être réalisés.', 'AE', null, 'Champ 4 — Embarrures et brèches ostéo-durales de la base du crâne (Réf. R9.5)'),
  ('MG-ANES-000051-R25', 'Il faut évaluer et prendre en compte le risque de mortalité (score SPIN, score de Maritzburg), de manière non isolée, dans l''indication d''une intervention chirurgicale en urgence.', 'AE', null, 'Champ 5 — Traumatismes cranio-encéphaliques pénétrants (Réf. R10.1)'),
  ('MG-ANES-000051-R26', 'Chez un patient avec un score de Glasgow ≥ 5, il faut proposer une prise en charge neurochirurgicale en urgence.', 'AE', null, 'Champ 5 — Traumatismes cranio-encéphaliques pénétrants (Réf. R10.2)'),
  ('MG-ANES-000051-R27', 'La prise en charge neurochirurgicale doit être discutée au cas par cas pour les patients avec un score de Glasgow ≤ 4, en l''absence de mydriase bilatérale aréactive et en l''absence de lésions scanographiques de mauvais pronostic (cf. critères ci-dessous).', 'AE', null, 'Champ 5 — Traumatismes cranio-encéphaliques pénétrants (Réf. R10.3)'),
  ('MG-ANES-000051-R28', 'En cas de délabrement cortical important, il faut réaliser une prophylaxie antiépileptique primaire pour une période d''au moins 7 jours, afin de réduire le risque épileptique à court terme.', 'AE', null, 'Champ 5 — Traumatismes cranio-encéphaliques pénétrants (Réf. R10.4)'),
  ('MG-ANES-000051-R29', 'Il faut réaliser ou mettre à jour les vaccinations suivantes : chez la personne non à jour, vaccination antitétanique associée à une injection de 250 UI d''immunoglobulines humaines antitétaniques en cas de plaie étendue, pénétrante avec corps étranger ou traitée tardivement ; anti-méningococcique B et ACYW (rattrapage selon les recommandations générales : méningocoque ABCYW avant 2 ans et ACYW avant 25 ans) ; anti-Haemophilus influenzae (1 dose) ; anti-pneumococcique (vaccin conjugué 15-valent chez le moins de 18 ans, 1 dose chez le plus de 2 ans ; ou 20-valent chez le plus de 18 ans, 1 dose non suivie de vaccin non-conjugué).', 'AE', null, 'Champ 5 — Traumatismes cranio-encéphaliques pénétrants (Réf. R10.5)'),
  ('MG-ANES-000051-R30', 'Il faut rechercher de manière systématique des lésions vasculaires intracrâniennes par angioscanner.', 'AE', null, 'Champ 5 — Traumatismes cranio-encéphaliques pénétrants (Réf. R11.1)'),
  ('MG-ANES-000051-R31', 'Il faut compléter ce bilan par une artériographie cérébrale par soustraction numérique 6 axes en présence d''un ou plusieurs des facteurs suivants : détection/doute sur lésion vasculaire à l''angioscanner ; blessure ptérionale et/ou fronto-orbitaire ; violation durale multiple ; trajectoire/hématome à proximité des axes vasculaires principaux ; TC (fermé ou pénétrant) par explosion avec GCS <8 ; vasospasme au doppler transcrânien et/ou baisse spontanée inexpliquée de la PtiO2.', 'AE', null, 'Champ 5 — Traumatismes cranio-encéphaliques pénétrants (Réf. R11.2)'),
  ('MG-ANES-000051-R32', 'En cas de lésion vasculaire intracrânienne symptomatique ou asymptomatique à haut risque de rupture et/ou d''aggravation neurologique, il faut discuter d''un traitement en urgence.', 'AE', null, 'Champ 5 — Traumatismes cranio-encéphaliques pénétrants (Réf. R11.3)'),
  ('MG-ANES-000051-R33', 'En l''absence d''authentification de lésion vasculaire intracrânienne initiale, il faut répéter une nouvelle imagerie cérébro-vasculaire à environ 14 jours du traumatisme.', 'AE', null, 'Champ 5 — Traumatismes cranio-encéphaliques pénétrants (Réf. R11.5)'),
  ('MG-ANES-000051-R34', 'En cas d''hygrome, il faut réaliser un traitement conservateur en première intention.', 'AE', null, 'Champ 6 — Désordres hydrauliques post-traumatiques (Réf. R12.1)'),
  ('MG-ANES-000051-R35', 'En cas d''hydrocéphalie externe, il faut drainer le LCS (ponction lombaire ou dérivation lombaire externe), après confirmation au scanner de : la perméabilité des citernes de la base ET l''absence de déviation de la ligne médiane > 10mm ET l''absence d''engagement amygdalien. En cas d''hypertension intracrânienne, cette option ne doit être envisagée qu''après échec des mesures de 1ère ligne.', 'AE', null, 'Champ 6 — Désordres hydrauliques post-traumatiques (Réf. R12.2)'),
  ('MG-ANES-000051-R36', 'En cas de dérivation lombaire externe pour hydrocéphalie externe, il faut placer le zéro de référence à hauteur du conduit auditif externe. En cas d''hypertension intracrânienne, un monitorage continu de la PIC doit être réalisé, et la contre-pression de drainage lombaire ne doit pas être abaissée en dessous de 10 mmHg. Le drainage lombaire doit être interrompu en cas de gradient de pression > 5 mmHg entre la PIC et la pression lombaire du LCS.', 'AE', null, 'Champ 6 — Désordres hydrauliques post-traumatiques (Réf. R12.3)'),
  ('MG-ANES-000051-R37', 'Chez le nouveau-né (<1 mois) avec TC associé à un hématome extradural (HED), il faut réaliser l''évacuation chirurgicale en urgence en présence de signes de gravité cliniques ou radiologiques (déviation >5mm de la ligne médiane, compression du tronc cérébral).', 'AE', 'Pédiatrie', 'Champ 7 — Particularités pédiatriques (Réf. R13.1)'),
  ('MG-ANES-000051-R38', 'En l''absence de consensus sur la technique chirurgicale optimale, il faut privilégier des approches moins invasives avant de recourir à une craniotomie : ponction du céphalhématome, ponction via une fracture crânienne, ou ponction épidurale (notamment si HED sans fracture ni céphalhématome).', 'AE', 'Pédiatrie', 'Champ 7 — Particularités pédiatriques (Réf. R13.2)'),
  ('MG-ANES-000051-R39', 'En l''absence de signes de gravité (cf. R13.1), il faut privilégier une approche conservatrice, avec surveillance étroite en unité de soins intensifs (examens cliniques rapprochés et imagerie de contrôle).', 'AE', 'Pédiatrie', 'Champ 7 — Particularités pédiatriques (Réf. R13.3)'),
  ('MG-ANES-000051-R40', 'Chez le nourrisson (<2 ans) avec TC non accidentel associé à un hématome sous-dural, il faut réaliser une prise en charge chirurgicale rapide, préférentiellement par drainage.', 'AE', 'Pédiatrie', 'Champ 7 — Particularités pédiatriques (Réf. R14.1)'),
  ('MG-ANES-000051-R41', 'Il faut envisager une prise en charge conservatrice en présence d''un hématome sous-dural chronique de faible épaisseur (<10mm), bien toléré cliniquement, avec surveillance rapprochée et contrôle de l''imagerie.', 'AE', 'Pédiatrie', 'Champ 7 — Particularités pédiatriques (Réf. R14.3)'),
  ('MG-ANES-000051-R42', 'Chez le nourrisson (<2 ans) avec embarrure type fracture « ping-pong », il faut réaliser une prise en charge chirurgicale en urgence en cas d''hypertension intracrânienne, ou d''effet de masse significatif sur le parenchyme, ou d''hématome intracrânien, ou de collection de LCS péri-encéphalique.', 'AE', 'Pédiatrie', 'Champ 7 — Particularités pédiatriques (Réf. R15.1)'),
  ('MG-ANES-000051-R43', 'En l''absence des critères ci-dessus, il faut privilégier initialement une prise en charge conservatrice ; une prise en charge chirurgicale pourra être ré-évaluée en l''absence d''évolution favorable.', 'AE', 'Pédiatrie', 'Champ 7 — Particularités pédiatriques (Réf. R15.2)')) as v(code, statement, grade, population, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-neurochirurgicales-des-traumatismes-cranio-encephaliques-de-ladulte-et-de-lenfant-a-la-phase-initiale/'
on conflict (recommendation_code) do nothing;
