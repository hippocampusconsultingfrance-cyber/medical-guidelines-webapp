-- Migration : Insuffisance d'analgésie au cours de la césarienne sous
-- anesthésie périmédullaire : prévention - prise en charge immédiate et
-- différée — Préconisations du Club d'Anesthésie Réanimation Obstétricale
-- (CARO), avec le CNGOF, la SFAR, la SFMP, le CNSF, la SoFraSimS, des
-- experts médecine légale, IADE, IBODE, le CIANE, l'association Césarine
-- et la SFPP. Comité de pilotage : D. Benhamou, H. Keita-Meyer (auteur
-- correspondant), P. Deruelle, A. Evrard. Version 2021.
-- Source : rfe-sfar-website/build/content_insuffisance_analgesie_cesarienne.json
-- (5 thèmes — P1.1-P1.9 évaluation du bloc, P2.1-P2.4 délai décision-
-- naissance, P3.1-P3.5 douleur per-incision, P4.1-P4.3 ESPT, P5.1-P5.3
-- aspects médico-légaux — 24 préconisations numérotées natives, chacune
-- déjà atomique).
--
-- MÉTHODOLOGIE — AUCUN SYSTÈME GRADE, AUCUN PROCESSUS DE COTATION/VOTE
-- FORMEL DÉCRIT (disclosed explicitement par la source elle-même) : chaque
-- préconisation est introduite par "Les experts suggèrent que..." ou "Les
-- experts rappellent que...", sans tag de force individuelle imprimé.
-- `grade` NULL sur les 24 lignes (même traitement que `ponction_
-- lombaire`/0075 et `sauv`/0084, sources également sans grade). Les 10
-- préconisations marquées ★ ("clés") par les experts sont une sélection
-- éditoriale de la source, PAS un niveau de preuve — le schéma n'a pas de
-- colonne dédiée à ce marqueur ; il est reporté dans `condition_topic`
-- ("(préconisation clé)") plutôt qu'inventé comme un grade.
--
-- ⚠️ DISCLOSURE — DOUBLON D'IMPRESSION DANS LA SOURCE (reproduit tel quel,
-- jamais silencieusement fusionné) : P1.7 et P1.8 sont imprimées avec un
-- texte rigoureusement identique dans le document source lui-même — les
-- deux lignes sont migrées séparément ci-dessous (MG-ANES-000096-R07 et
-- R08), fidèles à la numérotation native, sans supposer laquelle des deux
-- serait "la bonne".
--
-- ⚠️ DISCLOSURE — INCOHÉRENCE CHIFFRÉE NON RÉCONCILIÉE : la fréquence de
-- l'insuffisance d'analgésie est donnée deux fois différemment dans la
-- source — "0,5-17% (rachianesthésie) / 1,7-20% (extension d'APD)" dans le
-- résumé/l'introduction, contre "5 à 10% des cas" dans l'encart "Informer"
-- de l'annexe décisionnelle — non résolu ici, disclosed dans le
-- `grading_system` du document ci-dessous, aucune des deux valeurs n'étant
-- portée par une colonne `recommendations` individuelle.
--
-- ⚠️ DISCLOSURE — SIGLE INCOHÉRENT DANS LA SOURCE ELLE-MÊME : le corps du
-- texte (P1.6) emploie "RPC" (rachi-péridurale combinée) alors que
-- l'annexe décisionnelle emploie "PRC" pour la même technique — reproduit
-- tel quel dans les statements concernés, non harmonisé.
--
-- L'annexe "Aide à la décision" (arbre décisionnel en 6 étapes, reproduit
-- depuis un rendu visuel à 200dpi faute de couche texte fiable) est de
-- nature procédurale/algorithmique, pas un énoncé "il faut faire X" isolé
-- avec sa propre préconisation numérotée par la source — non migrée comme
-- ligne `recommendations` distincte, son contenu reste rattaché aux
-- préconisations P1-P3 correspondantes dans la fiche de synthèse HTML.
-- Idem pour le tableau "Facteurs de risque d'échec des techniques d'APM"
-- (données de référence descriptives, sans préconisation numérotée propre).
--
-- SOCIÉTÉS : CARO (organisme porteur), SFMP, CNSF, SoFraSimS, CIANE,
-- Césarine, SFPP ne figurent PAS dans le seed Annexe B (`public.societies`)
-- — vérifié contre la liste complète des 18 sociétés. SFAR et CNGOF sont
-- toutes deux présentes dans le seed et sont donc liées en
-- `document_societies` ci-dessous ; CARO reste non lié malgré son rôle
-- d'organisme porteur, faute d'entrée correspondante dans le seed.
--
-- SOURCE_URL / PDF_URL : `library_final.json` (recherche "insuffisance
-- d'analgésie" / "césarienne périmédullaire" — exactement 1 correspondance
-- attendue) — voir ci-dessous ; à défaut d'entrée retrouvée dans
-- `library_final.json`, l'URL de téléchargement citée par le contenu
-- construit lui-même est utilisée comme source_url ET pdf_url (page de
-- téléchargement directe, pas de page HTML dédiée distincte identifiée).
-- `publication_date` = 2021-01-01 (année seule connue, "Version : 2021"
-- dans le contenu construit — même convention que `allergie_prevention`/
-- 0006 pour une année seule).
--
-- `specialties` : `anesthesie_reanimation`, `gynecologie_obstetrique`
-- (sujet obstétrical central) et `medecine_legale` (Thème 5 — aspects
-- médico-légaux, explicitement co-rédigé avec des experts en médecine
-- légale selon la source).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Insuffisance d''analgésie au cours de la césarienne sous anesthésie périmédullaire : prévention - prise en charge immédiate et différée',
  'Préconisation', 'fr', '2021-01-01',
  'https://sfar.org/download/preconisations-insuffisance-danalgesie-au-cours-de-la-cesarienne-sous-anesthesie-perimedullaire-prevention-prise-en-charge-immediate-et-differee/?wpdmdl=32629',
  'https://sfar.org/download/preconisations-insuffisance-danalgesie-au-cours-de-la-cesarienne-sous-anesthesie-perimedullaire-prevention-prise-en-charge-immediate-et-differee/?wpdmdl=32629',
  'Aucun système GRADE, aucun processus de cotation/vote formel décrit — chaque préconisation introduite par "les experts suggèrent/rappellent que", sans tag de force individuelle. 24 préconisations (5 thèmes), dont 10 marquées "clés" par sélection éditoriale des experts (pas un niveau de preuve). Incohérence chiffrée non réconciliée sur la fréquence de l''insuffisance d''analgésie : "0,5-17%/1,7-20%" (résumé) vs "5 à 10% des cas" (annexe) — les deux valeurs disclosed, aucune retenue comme "la bonne".',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/download/preconisations-insuffisance-danalgesie-au-cours-de-la-cesarienne-sous-anesthesie-perimedullaire-prevention-prise-en-charge-immediate-et-differee/?wpdmdl=32629'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'), ('CNGOF', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/download/preconisations-insuffisance-danalgesie-au-cours-de-la-cesarienne-sous-anesthesie-perimedullaire-prevention-prise-en-charge-immediate-et-differee/?wpdmdl=32629'
  and s.slug in ('anesthesie_reanimation', 'gynecologie_obstetrique', 'medecine_legale')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.source_section,
  'https://sfar.org/download/preconisations-insuffisance-danalgesie-au-cours-de-la-cesarienne-sous-anesthesie-perimedullaire-prevention-prise-en-charge-immediate-et-differee/?wpdmdl=32629',
  'draft'
from public.documents d, (values
  ('MG-ANES-000096-R01', 'L''insuffisance et l''échec d''analgésie sont définis comme toute anesthésie périmédullaire conduisant à un complément nécessaire par la patiente.', null, 'Définition de l''insuffisance/échec d''analgésie (préconisation clé)', 'Thème 1 — Évaluation du bloc avant incision, P1.1'),
  ('MG-ANES-000096-R02', 'Le confort exprimé par la patiente est tout aussi important que l''évaluation du niveau d''anesthésie. L''existence d''un inconfort majeur doit être pris en compte.', null, 'Confort exprimé par la patiente (préconisation clé)', 'Thème 1 — Évaluation du bloc avant incision, P1.2'),
  ('MG-ANES-000096-R03', 'L''évaluation de l''adéquation du niveau sensitif repose sur la sensation de toucher ± de froid. Un niveau sensitif supérieur bilatéral et symétrique en T6 au toucher ± en T3 au froid est requis (T6 = pointe xiphoïde, T4 = ligne mamelonnaire).', null, 'Critères d''évaluation du niveau sensitif (préconisation clé)', 'Thème 1 — Évaluation du bloc avant incision, P1.3'),
  ('MG-ANES-000096-R04', 'Le test de pincement cutané par l''obstétricien doit être systématiquement réalisé, même en urgence, au niveau de la zone d''incision, toujours au plus haut, en limite du champ opératoire (ombilic).', null, 'Test de pincement cutané', 'Thème 1 — Évaluation du bloc avant incision, P1.4'),
  ('MG-ANES-000096-R05', 'Pour la rachianesthésie (RA), une dose de bupivacaïne hyperbare (HB) supérieure à 10 mg limiterait le risque d''échec — dose à adapter aux tailles extrêmes et à la présence d''un syndrome de compression cave.', null, 'Dose de bupivacaïne HB en rachianesthésie', 'Thème 1 — Évaluation du bloc avant incision, P1.5'),
  ('MG-ANES-000096-R06', 'La rachianesthésie-péridurale combinée (RPC) peut limiter le risque d''échec par la présence du cathéter péridural permettant l''injection d''un complément anesthésique.', null, 'Rachianesthésie-péridurale combinée (RPC)', 'Thème 1 — Évaluation du bloc avant incision, P1.6'),
  ('MG-ANES-000096-R07', 'Une analgésie péridurale imparfaite pendant le travail obstétrical expose au risque d''échec de conversion de la péridurale analgésique en péridurale anesthésique pour la césarienne en cours de travail.', null, 'Risque d''échec de conversion de l''APD (préconisation clé)', 'Thème 1 — Évaluation du bloc avant incision, P1.7'),
  ('MG-ANES-000096-R08', 'Une analgésie péridurale imparfaite pendant le travail obstétrical expose au risque d''échec de conversion de la péridurale analgésique en péridurale anesthésique pour la césarienne en cours de travail. (Texte identique à P1.7 dans la source — doublon d''impression disclosed, reproduit tel quel.)', null, 'Risque d''échec de conversion de l''APD (doublon source de P1.7)', 'Thème 1 — Évaluation du bloc avant incision, P1.8'),
  ('MG-ANES-000096-R09', 'L''échec peut également survenir lors d''une césarienne programmée avec une rachianesthésie et les mêmes critères de bonne pratique sont requis.', null, 'Échec possible en césarienne programmée sous rachianesthésie (préconisation clé)', 'Thème 1 — Évaluation du bloc avant incision, P1.9'),
  ('MG-ANES-000096-R10', 'En cas de suspicion d''acidose fœtale, l''obstétricien décide du degré d''urgence de la césarienne et communique de manière intelligible avec les autres acteurs, par exemple à l''aide d''un système de communication simplifié et validé en équipe (type code couleur).', null, 'Communication du degré d''urgence en cas de suspicion d''acidose fœtale (préconisation clé)', 'Thème 2 — Délai décision-naissance et communication, P2.1'),
  ('MG-ANES-000096-R11', 'Dans chaque maternité, les procédures de transfert, d''installation des patientes et de modalité d''anesthésie en salle de césarienne doivent être optimisées pour minimiser le temps décision-incision.', null, 'Optimisation du temps décision-incision', 'Thème 2 — Délai décision-naissance et communication, P2.2'),
  ('MG-ANES-000096-R12', 'La possibilité de réaliser un enregistrement du rythme cardiaque fœtal (RCF) à l''arrivée en salle de césarienne est une préconisation forte du CNGOF et du CNEMM (Comité National d''Experts sur les Morts Maternelles).', null, 'Enregistrement du RCF à l''arrivée en salle de césarienne', 'Thème 2 — Délai décision-naissance et communication, P2.3'),
  ('MG-ANES-000096-R13', 'Une évaluation des pratiques pourrait être réalisée avec comme indicateurs le taux et les indications des césariennes en extrême urgence, ainsi que le taux de conversion en anesthésie générale suite à un échec d''APM.', null, 'Évaluation des pratiques (préconisation clé)', 'Thème 2 — Délai décision-naissance et communication, P2.4'),
  ('MG-ANES-000096-R14', 'Réaliser une pause opératoire en cas de douleur peropératoire afin d''évaluer et traiter la douleur de manière adaptée au contexte.', null, 'Pause opératoire en cas de douleur peropératoire (préconisation clé)', 'Thème 3 — Reconnaître et gérer la douleur avant/après incision, P3.1'),
  ('MG-ANES-000096-R15', 'Réaliser une anesthésie générale en cas d''échec constaté d''une APM juste avant ou dès l''incision pour césarienne code rouge.', null, 'AG en cas d''échec constaté d''APM en césarienne code rouge (préconisation clé)', 'Thème 3 — Reconnaître et gérer la douleur avant/après incision, P3.2'),
  ('MG-ANES-000096-R16', 'Administrer par voie intraveineuse de faibles doses d''un opioïde de courte durée d''action (alfentanil ou rémifentanil) ou des doses infra-anesthésiques de propofol ou kétamine en cas d''insuffisance d''analgésie constatée en cours d''intervention.', null, 'Complément analgésique/anesthésique intraveineux en cours d''intervention', 'Thème 3 — Reconnaître et gérer la douleur avant/après incision, P3.3'),
  ('MG-ANES-000096-R17', 'Réaliser une anesthésie générale en cas d''échec de la gestion médicamenteuse de la douleur, même avant le clampage du cordon.', null, 'AG en cas d''échec de la gestion médicamenteuse de la douleur (préconisation clé)', 'Thème 3 — Reconnaître et gérer la douleur avant/après incision, P3.4'),
  ('MG-ANES-000096-R18', 'L''efficacité de toute action de complément d''anesthésie doit être réévaluée.', null, 'Réévaluation de l''efficacité des compléments anesthésiques', 'Thème 3 — Reconnaître et gérer la douleur avant/après incision, P3.5'),
  ('MG-ANES-000096-R19', 'Informer les femmes, en préparation à l''accouchement et dans les feuillets d''information, de l''éventualité d''une analgésie insuffisante et des solutions possibles, y compris en cas de césarienne.', null, 'Information anténatale sur le risque d''analgésie insuffisante', 'Thème 4 — Prévention et gestion de l''ESPT, P4.1'),
  ('MG-ANES-000096-R20', 'Tracer l''insuffisance d''analgésie en cours de césarienne, renforcer l''anesthésie locorégionale et/ou générale, accompagner la naissance puis débriefer l''expérience douloureuse avec l''équipe, en particulier les soignants impliqués.', null, 'Traçabilité, renforcement et débriefing après insuffisance d''analgésie (préconisation clé)', 'Thème 4 — Prévention et gestion de l''ESPT, P4.2'),
  ('MG-ANES-000096-R21', 'Identifier la sidération et réaliser le soin psychique d''urgence (defusing) en postpartum ; à distance, diagnostiquer l''ESPT en explorant le bien-être maternel et la relation mère-enfant, puis confier la patiente à des spécialistes de l''ESPT pour une psychothérapie adaptée.', null, 'Prise en charge psychique — sidération et ESPT', 'Thème 4 — Prévention et gestion de l''ESPT, P4.3'),
  ('MG-ANES-000096-R22', 'Une information préanesthésique adaptée (art. D. 6124-91 et D. 6124-92 du Code de la Santé Publique) est le fondement d''un consentement libre et éclairé, mais doit aussi en situer les limites, imperfections ou échecs.', null, 'Information préanesthésique et consentement éclairé', 'Thème 5 — Aspects médico-légaux, P5.1'),
  ('MG-ANES-000096-R23', 'L''article L 1110-5-3 du Code de la Santé Publique dispose que "toute personne a le droit de recevoir des traitements et des soins visant à soulager sa souffrance [...] celle-ci devant être, en toutes circonstances, prévenue, prise en compte, évaluée et traitée".', null, 'Droit au soulagement de la souffrance (cadre légal)', 'Thème 5 — Aspects médico-légaux, P5.2'),
  ('MG-ANES-000096-R24', 'En termes de préjudice corporel, les dommages les plus fréquemment observés incluent la prolongation et la majoration de l''intensité des gênes temporaires partielles, une chronicisation des douleurs et l''apparition de troubles neuropsychologiques pouvant témoigner d''un syndrome de stress post-traumatique.', null, 'Préjudice corporel associé à l''insuffisance d''analgésie', 'Thème 5 — Aspects médico-légaux, P5.3')
) as v(code, statement, grade, condition_topic, source_section)
where d.source_url = 'https://sfar.org/download/preconisations-insuffisance-danalgesie-au-cours-de-la-cesarienne-sous-anesthesie-perimedullaire-prevention-prise-en-charge-immediate-et-differee/?wpdmdl=32629'
on conflict (recommendation_code) do nothing;
