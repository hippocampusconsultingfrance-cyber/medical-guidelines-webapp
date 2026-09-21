-- Migration : Prise en charge des complications hémorragiques graves et de la
-- chirurgie en urgence chez les patients recevant un anticoagulant oral
-- anti-IIa ou anti-Xa direct — Propositions du GIHP (Groupe d'Intérêt en
-- Hémostase Périopératoire). Coordinateurs G. Pernod, P. Albaladejo. Reçu le
-- 18/03/2013, accepté le 25/04/2013, publié Ann Fr Anesth Reanim
-- 2013;32:691-700.
-- Source : rfe-sfar-website/build/content_aod_urgence.json (2 champs — dosage
-- plasmatique disponible/indisponible en chirurgie urgente, puis hémorragie
-- grave spontanée ou chirurgicale — 21 énoncés atomiques extraits ci-dessous).
--
-- TITRE — divergence disclosed, non résolue silencieusement : le titre migré
-- ici est celui de l'article lui-même (cité intégralement en pied du contenu
-- construit, « Document source »). `library_final.json` (recherche
-- `wpdmdl=34804` — EXACTEMENT 1 correspondance, confirmée) indexe ce même
-- document sous le titre raccourci "Gestion périopératoire des AOD en
-- urgence" — un intitulé de page/slug SFAR, pas le titre scientifique de
-- l'article. Les deux désignent sans ambiguïté le même PDF (même
-- `direct_pdf_url`/`href`) ; le titre le plus précis et sourcé (celui de
-- l'article) est retenu pour `documents.title`.
--
-- DATE — divergence disclosed (déjà documentée par le contenu construit
-- lui-même, reproduite ici) : `library_final.json` indexe ce document sous
-- "year": "2021" (probable date de mise en ligne/réindexation sur sfar.org),
-- mais l'article est daté et signé 2013 (reçu 18/03/2013, accepté
-- 25/04/2013) — la date d'origine 2013 est retenue. `publication_date` =
-- 2013-03-18 = date de RÉCEPTION par la revue (la seule date à la précision
-- du jour donnée par la source) ; la date de publication imprimée exacte
-- n'est pas précisée au-delà du volume/pages (Ann Fr Anesth Reanim
-- 2013;32:691-700) — non devinée. `exact_date` de `library_final.json`
-- ("2013-03", précision mois) est cohérent avec cette date.
--
-- DOC_TYPE — 'Propositions' plutôt que 'Autre' (exact_type de
-- `library_final.json`, générique) : la source affirme elle-même
-- explicitement "ce n'est ni une RFE, ni une RPC, ni une conférence
-- d'experts SFAR" et se nomme "propositions", précisant "le peu de données
-- disponibles ne permet pas d'émettre des recommandations, mais seulement
-- des propositions" — vocabulaire libre (doc_type, cf. schema_v2.sql), donc
-- ce libellé plus précis est préféré ici sans contredire l'index.
--
-- MÉTHODOLOGIE / GRADING — AUCUN système de cotation dans ce document
-- (vérifié : aucune occurrence de grade A/B/C, GRADE 1+/1-/2+/2-, ni
-- "accord fort/faible" dans le contenu construit) : analyse de la
-- littérature pharmacocinétique + relecture critique par les membres du
-- GIHP jusqu'à consensus, sans vote coté. Conformément à l'instruction du
-- projet (ne jamais forcer un grade GRADE/AE par défaut quand la source n'a
-- aucun système de grade — cf. `0084_migrate_sauv.sql`), `grade` est laissé
-- NULL sur les 21 lignes ci-dessous ; `evidence_level` également NULL (même
-- motif). La décomposition ci-dessous suit l'ordre de présentation de la
-- source (tableaux/figures puis paragraphes), PAS un système de numérotation
-- R1/R2 natif à la source — ce document n'en a aucun (contrairement à
-- `sauv`/0084 qui, lui, avait des sous-sections numérotées par la source
-- elle-même) ; la numérotation `-R01` à `-R21` est donc une atomisation
-- éditoriale au fil du texte, sans trou (aucune exclusion volontaire ne
-- "saute" un numéro préexistant, puisqu'aucun numéro préexistant n'existe).
--
-- ⚠️ OBSOLESCENCE CLINIQUE DISCLOSED (mais document non abrogé côté SFAR) :
-- ce texte de 2013 précède la commercialisation de l'idarucizumab
-- (Praxbind®, antidote spécifique du dabigatran, autorisé en France en
-- 2016) et de l'andexanet alfa (Ondexxya®, antidote spécifique des anti-Xa,
-- autorisé en 2019) — il ne propose donc que des agents procoagulants non
-- spécifiques (CCP/FEIBA) et NE REFLÈTE PAS la prise en charge actuelle de
-- référence. `library_final.json` ne marque toutefois PAS ce document
-- "abrogé" (`"status": "en vigueur"`) et la page 1 du PDF ne porte aucun
-- tampon d'obsolescence — `freshness_status` = 'a_jour' est donc conservé
-- (reflet fidèle du statut affiché par la source elle-même), avec cette
-- disclosure intégrale portée dans `grading_system` pour ne jamais induire
-- un lecteur en erreur sur la pertinence clinique actuelle du contenu.
--
-- PORTÉE — limitée PAR LA SOURCE ELLE-MÊME à 2 molécules : dabigatran
-- (Pradaxa®) et rivaroxaban (Xarelto®). Apixaban et edoxaban sont
-- explicitement exclus par la source ("données insuffisantes en 2013") —
-- aucune recommandation n'est donc migrée pour ces 2 molécules (absence
-- fidèle à la source, pas un oubli).
--
-- CONTENU VOLONTAIREMENT EXCLU du modèle `recommendations` (avec
-- justification, jamais une simple affirmation) :
-- 1. Le paragraphe général "Seuil de sécurité hémostatique" (concentration
--    ≤ 30 ng/mL extrapolée des essais RE-LY/ROCKET-AF comme compatible avec
--    la chirurgie) : son contenu actionnable est déjà intégralement et plus
--    précisément porté par R01 (dabigatran ≤30 ng/mL) et R05 (rivaroxaban
--    ≤30 ng/mL) ci-dessous — le migrer en plus créerait une ligne
--    quasi-doublon de la même action clinique, pas une recommandation
--    distincte.
-- 2. Tableau 1 (données pharmacocinétiques Cmax/Cmin par schéma
--    posologique) : donnée de référence pharmacologique pure, sans
--    directive d'action ("il faut/il est proposé de faire X") — même
--    traitement que le tableau de posologie AOD/DFGe exclu par
--    `0012_migrate_anticoagulants.sql`.
-- 3. La mise en garde partagée CCP/FEIBA (notes de la source : "aucune
--    donnée sur le risque thrombotique de fortes doses", "l'antagonisation
--    ne corrige pas complètement les anomalies biologiques de l'hémostase",
--    "le rFVIIa n'est pas envisagé en première intention") : c'est une
--    réserve qualifiant l'usage du CCP/FEIBA déjà cité dans R02/R03/R06/R07/
--    R10/R11/R16/R17/R20 — pas une directive d'action distincte à part
--    entière. À lire par le clinicien en complément de chacune de ces lignes.
-- 4. Tableau 2 "Définition HAS 2008 d'une hémorragie grave ou potentiellement
--    grave sous AVK" : classification/définition explicitement EMPRUNTÉE À
--    UNE AUTRE SOURCE (HAS/GEHT 2008, AVK) et "reprise par défaut, faute de
--    définition spécifique aux AOD" — ce n'est pas une proposition du GIHP
--    pour CE document, mais un critère de définition qui sert de contexte à
--    R18-R21 (quand une hémorragie est qualifiée de "grave"). Non migré
--    comme recommandation atomique (pas un "il faut faire X"), disponible
--    en intégralité dans le contenu construit/le site pour le lecteur.
-- 5. Panneaux de contexte/avertissement (portée limitée à 2 molécules,
--    avertissement pré-antidotes, 2 défauts de production du PDF source sur
--    les légendes de figures Fig.4/5/6) : disclosures documentaires déjà
--    reportées ci-dessus dans ce bloc de commentaires, pas des
--    recommandations cliniques en tant que telles.
--
-- À VÉRIFIER (disclosure, pas une invention) — divergences internes à la
-- source, reproduites telles quelles, jamais résolues silencieusement :
-- 1. Fig. 1 (dabigatran) : le diagramme original indique un délai
--    "12-24 h" pour la tranche 200-400 ng/mL, tandis que le corps du texte
--    précise "un délai minimum de 24 heures" au même endroit — les deux
--    formulations sont reproduites dans R03/R07 (le texte du corps, plus
--    explicite, est retenu comme délai principal ; la divergence avec le
--    diagramme est disclosed dans le `statement` lui-même, pas seulement en
--    commentaire).
-- 2. R17 (hémorragie d'organe critique) : la source utilise ici l'abréviation
--    "CPP 50 UI/kg", alors qu'elle utilise partout ailleurs dans le même
--    document "CCP" (Concentré de Complexe Prothrombinique) pour désigner
--    manifestement le même produit — probable coquille de la source, mais
--    NON corrigée ici (reproduite telle quelle avec la divergence signalée
--    dans le `statement`), conformément au principe de ne jamais résoudre
--    silencieusement une incohérence de la source.
-- 3. Fig. 4 (rivaroxaban, dosage indisponible) : absente du PDF source en
--    tant que diagramme correctement légendé (défaut de production
--    disclosed par le contenu construit lui-même — l'emplacement annoncé
--    imprime en réalité une duplication du diagramme "hémorragie grave").
--    R12-R14 sont donc reconstruits UNIQUEMENT à partir du texte du corps
--    (§3.3 de la source), pas d'un diagramme — disclosed dans le
--    `source_section` de ces 3 lignes.
--
-- SOCIÉTÉS — vérification EXHAUSTIVE contre la liste complète des 18
-- sociétés du seed Annexe B (pas une commande grep tronquée) : le seul
-- organisme cité par CE document est le GIHP (Groupe d'Intérêt en Hémostase
-- Périopératoire) — GIHP N'EST PAS dans cette liste de 18 (SFAR, SRLF, HAS,
-- SPILF, SFMU, CNGOF, SFC, SFN, SFD, ESAIC, ESICM, SCCM, ASA, DAS, ASRA,
-- NICE, AWMF, SEMICYUC), même constat déjà documenté par
-- `0011_migrate_anticoag_urgence.sql` et `0012_migrate_anticoagulants.sql`
-- pour ce même organisme. Aucune autre société (SFAR incluse) n'est citée
-- par le texte de CE document précis (contrairement à `anticoagulants`/0012
-- où SFAR est explicitement co-signataire) — donc AUCUNE société de
-- substitution n'est ajoutée : la requête `document_societies` ci-dessous
-- cible volontairement 'GIHP', qui ne matchera aucune ligne de `societies`
-- (0 ligne insérée, comportement attendu et disclosed, pas une erreur).
--
-- SPÉCIALITÉS — vérification exhaustive contre la liste complète des 78
-- slugs du seed Annexe A : `anesthesie_reanimation` (cœur de cible du GIHP —
-- hémostase périopératoire), `medecine_d_urgence` (chirurgie EN URGENCE et
-- hémorragie grave, contexte d'urgence explicite du titre lui-même) et
-- `hematologie` (gestion de l'hémostase/anticoagulation — même choix que
-- `0011_migrate_anticoag_urgence.sql` et `0012_migrate_anticoagulants.sql`
-- pour des documents de périmètre GIHP comparable). Pas de slug "hémostase"
-- ou "GIHP" dédié dans le seed à ce jour.
--
-- DOUBLON — vérification faite (grep intégral de supabase/migrations/ pour
-- "anticoag" et "aod") : ni `0011_migrate_anticoag_urgence.sql` (source =
-- wpdmdl=62045, "Gestion de l'anticoagulation dans un contexte d'urgence",
-- SFMU/SFAR/GIHP/SFTH, RFE 2024 — tous anticoagulants, méthodologie GRADE
-- complète) ni `0012_migrate_anticoagulants.sql` (source = URL 2026
-- distincte, "Gestion des anticoagulants pour une procédure invasive
-- PROGRAMMÉE") ne couvrent ce document précis (wpdmdl=34804, 2013,
-- dabigatran/rivaroxaban uniquement, chirurgie EN URGENCE + hémorragie
-- grave, SANS système de cotation). `library_final.json` recensait aussi 2
-- autres PDF distincts contenant "AOD" + "GIHP" (wpdmdl=33608 "acte
-- programmé" 2015 et wpdmdl=34412 "dabigatran en urgence" 2016, seule
-- molécule) — ni l'un ni l'autre ne partage l'URL de ce document ; aucun des
-- deux n'est migré ici (hors périmètre de cette tâche).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge des complications hémorragiques graves et de la chirurgie en urgence chez les patients recevant un anticoagulant oral anti-IIa ou anti-Xa direct',
  'Propositions', 'fr', '2013-03-18',
  'https://sfar.org/download/gestion-perioperatoire-des-aod-en-urgence/?wpdmdl=34804',
  'https://sfar.org/download/gestion-perioperatoire-des-aod-en-urgence/?wpdmdl=34804',
  'Propositions du GIHP (pas des recommandations : "le peu de données disponibles ne permet pas d''émettre des recommandations, mais seulement des propositions") — analyse de la littérature pharmacocinétique + relecture critique du GIHP jusqu''à consensus. AUCUN système de cotation (pas de grade A/B/C ni GRADE 1+/1-/2+/2-, pas d''accord fort/faible). Limité aux 2 seules molécules couvertes par la source : dabigatran et rivaroxaban (apixaban/edoxaban explicitement exclus, "données insuffisantes en 2013"). ⚠️ Document antérieur aux antidotes spécifiques (idarucizumab 2016, andexanet alfa 2019) : ne propose que des agents procoagulants non spécifiques (CCP/FEIBA) et ne reflète pas la prise en charge actuelle de référence — non marqué "abrogé" par la source (`library_final.json` : "en vigueur"), freshness_status reflète fidèlement ce statut source malgré l''obsolescence clinique disclosed ici.',
  'a_jour'
)
on conflict (source_url) do nothing;

-- GIHP absent du seed Annexe B (vérifié contre la liste complète des 18
-- sociétés ci-dessus) : cette requête ne matchera intentionnellement aucune
-- ligne de `societies` (0 ligne insérée) ; aucune société de substitution.
insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/download/gestion-perioperatoire-des-aod-en-urgence/?wpdmdl=34804'
  and s.acronym in ('GIHP')
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/download/gestion-perioperatoire-des-aod-en-urgence/?wpdmdl=34804'
  and s.slug in ('anesthesie_reanimation', 'medecine_d_urgence', 'hematologie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.source_section,
  'https://sfar.org/download/gestion-perioperatoire-des-aod-en-urgence/?wpdmdl=34804',
  'draft'
from public.documents d, (values
  ('MG-ANES-000089-R01', 'Chez un patient traité par dabigatran (Pradaxa®) nécessitant une chirurgie urgente à risque hémorragique, si un dosage plasmatique spécifique est disponible et que la concentration est ≤ 30 ng/mL, opérer sans délai.', null, 'Dabigatran — chirurgie urgente, dosage disponible, ≤ 30 ng/mL', 'Section 1 — Chirurgie urgente à risque hémorragique, dosage plasmatique disponible — Fig. 1 (Dabigatran)'),
  ('MG-ANES-000089-R02', 'Chez un patient traité par dabigatran (Pradaxa®) nécessitant une chirurgie urgente à risque hémorragique, si la concentration plasmatique est comprise entre 30 et 200 ng/mL : si un report est possible, attendre jusqu''à 12 h puis effectuer un nouveau dosage ; si un report n''est pas possible, opérer, et en cas de saignement anormal, antagoniser par CCP (25-50 UI/kg) ou FEIBA (30-50 UI/kg) selon disponibilité.', null, 'Dabigatran — chirurgie urgente, dosage disponible, 30-200 ng/mL', 'Section 1 — Chirurgie urgente à risque hémorragique, dosage plasmatique disponible — Fig. 1 (Dabigatran)'),
  ('MG-ANES-000089-R03', 'Chez un patient traité par dabigatran (Pradaxa®) nécessitant une chirurgie urgente à risque hémorragique, si la concentration plasmatique est comprise entre 200 et 400 ng/mL : retarder au maximum l''intervention, avec un délai minimum de 24 h avant un nouveau dosage (le diagramme original de la source indique « 12-24 h », tandis que le corps du texte précise « un délai minimum de 24 heures » — divergence interne à la source, disclosed, non résolue ici) ; si la clairance de la créatinine (formule de Cockcroft et Gault) est < 50 mL/min, discuter une épuration par hémodialyse (35 % du dabigatran est lié à l''albumine ; l''hémodialyse réduit la concentration de 40-60 % en 4 h).', null, 'Dabigatran — chirurgie urgente, dosage disponible, 200-400 ng/mL', 'Section 1 — Chirurgie urgente à risque hémorragique, dosage plasmatique disponible — Fig. 1 (Dabigatran)'),
  ('MG-ANES-000089-R04', 'Chez un patient traité par dabigatran (Pradaxa®) nécessitant une chirurgie urgente à risque hémorragique, si la concentration plasmatique est > 400 ng/mL : situation de surdosage à risque hémorragique majeur — discuter une dialyse avant la chirurgie, le délai pour atteindre le seuil de 30 ng/mL étant long en cas de surdosage et devant être intégré à la décision de report.', null, 'Dabigatran — chirurgie urgente, dosage disponible, > 400 ng/mL', 'Section 1 — Chirurgie urgente à risque hémorragique, dosage plasmatique disponible — Fig. 1 (Dabigatran)'),
  ('MG-ANES-000089-R05', 'Chez un patient traité par rivaroxaban (Xarelto®) nécessitant une chirurgie urgente à risque hémorragique, si un dosage plasmatique spécifique est disponible et que la concentration est ≤ 30 ng/mL, opérer sans délai.', null, 'Rivaroxaban — chirurgie urgente, dosage disponible, ≤ 30 ng/mL', 'Section 1 — Chirurgie urgente à risque hémorragique, dosage plasmatique disponible — Fig. 2 (Rivaroxaban)'),
  ('MG-ANES-000089-R06', 'Chez un patient traité par rivaroxaban (Xarelto®) nécessitant une chirurgie urgente à risque hémorragique, si la concentration plasmatique est comprise entre 30 et 200 ng/mL : si un report est possible, attendre jusqu''à 12 h puis effectuer un nouveau dosage ; si un report n''est pas possible, opérer, et en cas de saignement anormal, antagoniser par CCP (25-50 UI/kg) ou FEIBA (30-50 UI/kg) selon disponibilité.', null, 'Rivaroxaban — chirurgie urgente, dosage disponible, 30-200 ng/mL', 'Section 1 — Chirurgie urgente à risque hémorragique, dosage plasmatique disponible — Fig. 2 (Rivaroxaban)'),
  ('MG-ANES-000089-R07', 'Chez un patient traité par rivaroxaban (Xarelto®) nécessitant une chirurgie urgente à risque hémorragique, si la concentration plasmatique est comprise entre 200 et 400 ng/mL : retarder au maximum l''intervention, avec un délai minimum de 24 h avant un nouveau dosage (même divergence interne diagramme/texte de la source que pour le dabigatran, disclosed) ; à la différence du dabigatran, aucune option de dialyse n''est proposée par la source pour le rivaroxaban.', null, 'Rivaroxaban — chirurgie urgente, dosage disponible, 200-400 ng/mL', 'Section 1 — Chirurgie urgente à risque hémorragique, dosage plasmatique disponible — Fig. 2 (Rivaroxaban)'),
  ('MG-ANES-000089-R08', 'Chez un patient traité par rivaroxaban (Xarelto®) nécessitant une chirurgie urgente à risque hémorragique, si la concentration plasmatique est > 400 ng/mL : situation de surdosage à risque hémorragique majeur ; contrairement au dabigatran, la dialyse n''est pas envisageable avec le rivaroxaban (motif non précisé par la source) — retarder au maximum l''intervention si l''état du patient le permet.', null, 'Rivaroxaban — chirurgie urgente, dosage disponible, > 400 ng/mL', 'Section 1 — Chirurgie urgente à risque hémorragique, dosage plasmatique disponible — Fig. 2 (Rivaroxaban)'),
  ('MG-ANES-000089-R09', 'Chez un patient traité par dabigatran (Pradaxa®) nécessitant une chirurgie urgente à risque hémorragique et pour lequel le dosage plasmatique spécifique n''est pas immédiatement disponible, si le rapport malade/témoin (M/T) TCA ≤ 1,2 ET TQ ≤ 1,2 (TP ≥ 70-80 %), opérer sans délai.', null, 'Dabigatran — chirurgie urgente, dosage indisponible (TCA/TQ), ratio normal', 'Section 2 — Chirurgie urgente, dosage spécifique indisponible — Fig. 3 (Dabigatran, ratio TCA/TQ)'),
  ('MG-ANES-000089-R10', 'Chez un patient traité par dabigatran (Pradaxa®) nécessitant une chirurgie urgente à risque hémorragique et pour lequel le dosage plasmatique spécifique n''est pas immédiatement disponible, si 1,2 < TCA ≤ 1,5, ou TQ > 1,2 (TP < 70-80 %) — situation correspondant à environ 30-200 ng/mL : si un report est possible, attendre jusqu''à 12 à 24 h selon la fonction rénale et obtenir un dosage spécifique avec un nouveau TP/TCA ; si non, opérer, et en cas de saignement anormal, antagoniser par CCP (25-50 UI/kg) ou FEIBA (30-50 UI/kg).', null, 'Dabigatran — chirurgie urgente, dosage indisponible (TCA/TQ), ratio intermédiaire', 'Section 2 — Chirurgie urgente, dosage spécifique indisponible — Fig. 3 (Dabigatran, ratio TCA/TQ)'),
  ('MG-ANES-000089-R11', 'Chez un patient traité par dabigatran (Pradaxa®) nécessitant une chirurgie urgente à risque hémorragique et pour lequel le dosage plasmatique spécifique n''est pas immédiatement disponible, si TCA > 1,5 — situation correspondant à > 200 ng/mL (Cmax) : retarder au maximum l''intervention, avec un délai minimum de 24 h, et obtenir un dosage spécifique avec un nouveau TP/TCA ; si la clairance de Cockcroft est < 50 mL/min, discuter une dialyse.', null, 'Dabigatran — chirurgie urgente, dosage indisponible (TCA/TQ), ratio élevé', 'Section 2 — Chirurgie urgente, dosage spécifique indisponible — Fig. 3 (Dabigatran, ratio TCA/TQ)'),
  ('MG-ANES-000089-R12', 'Chez un patient traité par rivaroxaban (Xarelto®) nécessitant une chirurgie urgente à risque hémorragique et pour lequel le dosage plasmatique spécifique n''est pas immédiatement disponible, si le rapport malade/témoin (M/T) TCA ≤ 1,2 ET TQ ≤ 1,2 (ou activité anti-Xa ≤ 0,1 U/mL), opérer sans délai.', null, 'Rivaroxaban — chirurgie urgente, dosage indisponible (TCA/TQ), ratio normal', 'Section 2 — Chirurgie urgente, dosage spécifique indisponible — Fig. 4 (Rivaroxaban, ratio TCA/TQ ; algorithme absent du PDF source, reconstruit à partir du texte du §3.3 — disclosed)'),
  ('MG-ANES-000089-R13', 'Chez un patient traité par rivaroxaban (Xarelto®) nécessitant une chirurgie urgente à risque hémorragique et pour lequel le dosage plasmatique spécifique n''est pas immédiatement disponible, si 1,2 < TCA ≤ 1,5 — situation correspondant à 30-200 ng/mL : attendre jusqu''à 12 h (la source ne précise pas de modulation « selon la fonction rénale » pour cette molécule, à la différence du dabigatran), répéter le TCA, et obtenir un dosage spécifique si compatible avec l''urgence.', null, 'Rivaroxaban — chirurgie urgente, dosage indisponible (TCA/TQ), ratio intermédiaire', 'Section 2 — Chirurgie urgente, dosage spécifique indisponible — Fig. 4 (Rivaroxaban, ratio TCA/TQ ; algorithme absent du PDF source, reconstruit à partir du texte du §3.3 — disclosed)'),
  ('MG-ANES-000089-R14', 'Chez un patient traité par rivaroxaban (Xarelto®) nécessitant une chirurgie urgente à risque hémorragique et pour lequel le dosage plasmatique spécifique n''est pas immédiatement disponible, si TCA > 1,5 — situation correspondant à > 200 ng/mL : retarder au maximum l''intervention, avec un délai minimum de 24 h, et obtenir un dosage spécifique dans ce délai ; la source ne mentionne pas d''option de dialyse pour cette situation.', null, 'Rivaroxaban — chirurgie urgente, dosage indisponible (TCA/TQ), ratio élevé', 'Section 2 — Chirurgie urgente, dosage spécifique indisponible — Fig. 4 (Rivaroxaban, ratio TCA/TQ ; algorithme absent du PDF source, reconstruit à partir du texte du §3.3 — disclosed)'),
  ('MG-ANES-000089-R15', 'Chez un patient traité par un anticoagulant oral direct (dabigatran ou rivaroxaban), l''INR n''a aucune place dans la gestion des situations critiques — c''est un mode d''expression conçu pour les AVK ; lui préférer le rapport malade/témoin (M/T) du temps de Quick (TQ).', null, 'Choix du test biologique — INR non pertinent sous AOD', 'Section 2 — note sur la place de l''INR'),
  ('MG-ANES-000089-R16', 'Si la chirurgie ne peut être repoussée alors que les seuils de sécurité définis ci-dessus ne sont pas atteints, opérer sans administration préventive de médicaments procoagulants ; ne recourir à ceux-ci (CCP 25-50 UI/kg, ou FEIBA 30-50 UI/kg, éventuellement renouvelable une fois en cas d''échec) qu''en cas de saignement anormal per- ou postopératoire, en privilégiant en première ligne la dose la plus faible proposée.', null, 'Chirurgie non différable, seuils de sécurité non atteints', 'Section 2 — Si la chirurgie ne peut être repoussée et les seuils ne sont pas atteints'),
  ('MG-ANES-000089-R17', 'En cas d''hémorragie dans un organe critique (intracérébrale, sous-durale aiguë, intra-oculaire…) chez un patient traité par anticoagulant oral anti-IIa (dabigatran) ou anti-Xa (rivaroxaban), neutraliser immédiatement l''effet anticoagulant par FEIBA (30-50 UI/kg) ou CPP (50 UI/kg — ainsi désigné dans la source à cet endroit précis, contre « CCP » ailleurs dans le même document ; divergence de nommage interne à la source, reproduite telle quelle, disclosed), éventuellement renouvelé une fois à 8 h d''intervalle, quel que soit le résultat des tests biologiques et sans attendre ceux-ci.', null, 'Hémorragie grave — organe critique', 'Section 2 — Hémorragie grave spontanée ou chirurgicale, 1 — Hémorragie dans un organe critique'),
  ('MG-ANES-000089-R18', 'En cas d''hémorragie grave (hors organe critique) chez un patient traité par anticoagulant oral anti-IIa ou anti-Xa direct, si un geste hémostatique est praticable d''emblée (endoscopique, intravasculaire), le privilégier quel que soit le taux du médicament.', null, 'Hémorragie grave (hors organe critique) — geste hémostatique disponible', 'Section 2 — Hémorragie grave spontanée ou chirurgicale, 2 — Autres hémorragies graves (définition HAS/GEHT 2008, reprise par défaut)'),
  ('MG-ANES-000089-R19', 'En cas d''hémorragie grave (hors organe critique) chez un patient traité par anticoagulant oral anti-IIa ou anti-Xa direct, si la concentration plasmatique est ≤ 30 ng/mL, l''hémorragie ne peut être imputée au seul médicament : ne pas administrer d''agent hémostatique (CCP/FEIBA).', null, 'Hémorragie grave (hors organe critique) — concentration ≤ 30 ng/mL', 'Section 2 — Hémorragie grave spontanée ou chirurgicale, 2 — Autres hémorragies graves (définition HAS/GEHT 2008, reprise par défaut)'),
  ('MG-ANES-000089-R20', 'En cas d''hémorragie grave (hors organe critique) chez un patient traité par anticoagulant oral anti-IIa ou anti-Xa direct, si la concentration plasmatique est > 30 ng/mL et qu''aucun geste hémostatique n''est adapté, tenter d''inhiber l''effet anticoagulant (CCP 25-50 UI/kg, ou FEIBA 30-50 UI/kg, éventuellement renouvelable une fois) et optimiser la réanimation ; pour le dabigatran spécifiquement, envisager une épuration par hémodialyse guidée par la concentration.', null, 'Hémorragie grave (hors organe critique) — concentration > 30 ng/mL, pas de geste hémostatique adapté', 'Section 2 — Hémorragie grave spontanée ou chirurgicale, 2 — Autres hémorragies graves (définition HAS/GEHT 2008, reprise par défaut)'),
  ('MG-ANES-000089-R21', 'En cas d''hémorragie grave (hors organe critique) chez un patient traité par anticoagulant oral anti-IIa ou anti-Xa direct, si le dosage spécifique n''est pas disponible, raisonner sur le TCA et le TP avec un niveau élevé d''incertitude : un ratio TCA ≤ 1,2 et TQ ≤ 1,2 (TP ≥ 70-80 %) oriente vers l''absence d''antagonisation, au-delà desquels l''antagonisation doit être discutée et un dosage spécifique obtenu.', null, 'Hémorragie grave (hors organe critique) — dosage spécifique non disponible', 'Section 2 — Hémorragie grave spontanée ou chirurgicale, 2 — Autres hémorragies graves (définition HAS/GEHT 2008, reprise par défaut)')
) as v(code, statement, grade, condition_topic, source_section)
where d.source_url = 'https://sfar.org/download/gestion-perioperatoire-des-aod-en-urgence/?wpdmdl=34804'
on conflict (recommendation_code) do nothing;
