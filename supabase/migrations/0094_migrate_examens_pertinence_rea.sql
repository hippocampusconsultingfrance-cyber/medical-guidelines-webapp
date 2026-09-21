-- Migration : Pertinence de la prescription des examens biologiques et de
-- la radiographie thoracique en réanimation — RFE commune SFAR-SRLF, texte
-- validé par le CA de la SFAR (15/12/2016) et de la SRLF (13/12/2016).
-- Source : rfe-sfar-website/build/content_examens_pertinence_rea.json (1
-- section, 8 "champs" cliniques + 1 bloc "Sources et traçabilité").
--
-- library_final.json (recherche "examens biologiques"/"radiographie
-- thoracique en réanimation" — EXACTEMENT 1 correspondance, ligne ~1228-1244)
-- donne : href = 'https://sfar.org/pertinence-de-la-prescription-des-
-- examens-biologiques-et-de-la-radiographie-thoracique-en-reanimation/',
-- direct_pdf_url = 'https://sfar.org/wp-content/uploads/2017/01/2_RFE-EC-en-
-- rea-version-15-12-16.pdf', exact_type = 'RFE', exact_date = '2017-01-11'.
-- Convention de ce projet (documents.source_url = href, documents.pdf_url =
-- direct_pdf_url, cf. 0086/brule_grave et la quasi-totalité des migrations
-- précédentes) appliquée ci-dessous. Note (pas une incohérence à résoudre) :
-- le champ "URL source" imprimé DANS le contenu construit lui-même reproduit
-- en réalité le direct_pdf_url et non le href — repéré en lisant le JSON en
-- entier ; les deux URL désignent le même document, seul le choix de laquelle
-- afficher diffère, donc documents.source_url reste le href par convention de
-- ce projet. exact_date (2017-01-11, mise en ligne) diffère des deux dates de
-- validation en CA citées par la source elle-même (SFAR 15/12/2016, SRLF
-- 13/12/2016) — deux faits distincts et non contradictoires (mise en ligne
-- vs validation), pas une divergence à disclosed au sens de la règle 5.
--
-- Recherche de doublon (étape 3 de la procédure) : grep sur
-- supabase/migrations/ pour "examens biologiques" / "radiographie
-- thoracique" / "EC-en-rea" / "pertinence-de-la-prescription" trouve 5
-- fichiers, mais dans chacun le terme désigne un examen ponctuel cité en
-- passant dans un tout autre document (0083 plyo_transfusion, 0063
-- bris_dentaires, 0021 epanchement_pleural, 0041 securisation_proc, 0047
-- tih) — aucun ne migre CE document (source_url distinct dans les 5 cas,
-- vérifié individuellement). Aucun doublon.
--
-- MÉTHODOLOGIE — GRADE® : qualité des preuves en 4 catégories (haute/
-- modérée/basse/très basse), recommandation formulée forte ("il faut" /
-- "il ne faut pas") ou faible ("il faut probablement" / "il ne faut
-- probablement pas"), méthode PICO, cotation Delphi/GRADE Grid. Quand le
-- niveau de preuve est insuffisant pour une cotation GRADE mais qu'un
-- consensus existe, la source utilise "AE" (avis d'expert, hors échelle
-- GRADE 1+/1-/2+/2-) — reproduit tel quel, jamais requalifié en 1+/1-/2+/2-.
--
-- ⚠️ DISCLOSURE — DIVERGENCE DE COMPTAGE INTERNE À LA SOURCE (règle 5, non
-- réconciliée, reproduite telle qu'établie dans le contenu construit) : la
-- source annonce elle-même « 49 recommandations formalisées » (« accord
-- fort » pour 40, « accord faible » pour 1) et 3 cas sans recommandation
-- possible. Le compte direct des items numérotés du corps du texte donne
-- 42 (38 gradés 1+/1-/2+/2- + 4 « avis d'expert ») + 3 cas sans
-- recommandation confirmés = 45, ni 49 ni 52. Les deux comptes de la source
-- (49 annoncé, 42 dénombré dans le corps du texte) sont irréconciliables en
-- l'état ; cette migration liste les 42 items directement dénombrables dans
-- le corps du texte, plus l'item d'anomalie de numérotation ci-dessous, plus
-- les 3 cas "aucune recommandation possible" explicitement listés comme
-- exclus (jamais comme recommandations) — aucun chiffre n'est deviné pour
-- combler l'écart avec le "49" annoncé.
--
-- ⚠️ À VÉRIFIER — ANOMALIE DE NUMÉROTATION "R 7.2.5" (rang 29 ci-dessous) :
-- entre R7.10 et R7.12, le corps du texte source imprime un item intitulé
-- « R 7.2.5 » (repère de sous-section 7.2.5, pas la suite logique
-- "R7.11" de la séquence R7.x) portant sur un renvoi vers une autre
-- recommandation (SRLF-SFAR-SPILF, "Stratégies de réduction de
-- l'utilisation des antibiotiques à visée curative en réanimation") — SANS
-- aucun grade imprimé par la source pour cet item (ni 1+/1-/2+/2-, ni AE).
-- Le texte de couverture du contenu construit lui-même est ambigu sur le
-- point de savoir si cet item est inclus ou non dans le total "42" du
-- décompte méthodologique (38 gradés + 4 AE = 42 n'inclut PAS cet item sans
-- grade ; mais la phrase de couverture dit "42 items numérotés (R1.1-R8.4),
-- y compris l'anomalie de numérotation R 7.2.5", ce qui suggérerait qu'il
-- en fait partie — les deux lectures ne sont pas simultanément vraies
-- arithmétiquement). Décision prise ici, non devinée mais explicite :
-- l'item est un énoncé normatif numéroté distinct, réellement imprimé par
-- la source, et son omission violerait la couverture à 100% (règle 2) —
-- il est donc inclus ci-dessous comme sa propre ligne (rang 29,
-- recommendation_code ...-R29), grade = NULL (absence de grade constatée
-- dans la source elle-même, jamais inventée), avec l'anomalie documentée
-- intégralement dans source_section. Un relecteur humain qui déciderait que
-- cet item est hors du périmètre "recommandations" (puisque c'est un renvoi
-- vers un autre document plutôt qu'un énoncé d'action autonome) peut le
-- repasser en status='withdrawn' — aucune donnée n'est perdue en l'état.
--
-- ⚠️ DISCLOSURE — CONTENU VOLONTAIREMENT EXCLU DU MODÈLE `recommendations`
-- (avec justification, pas une simple affirmation) :
--  1. Résumé + paragraphe méthodologie + légende des grades (tableau
--     1+/1-/2+/2-/AE) : contenu descriptif/méthodologique, pas des énoncés
--     cliniques individuels — repris ci-dessous dans documents.grading_system
--     plutôt que dupliqué en lignes recommendations.
--  2. 4 encarts "Repère" (après Champ 3 : stratégie d'arrêt d'antibiothérapie
--     sur seuil de PCT ; après Champ 6 : corrélation TCA/anti-Xa et incidence
--     de la TIH sous HNF/HBPM ; après Champ 7-1 : sensibilité des hémocultures
--     selon le nombre de paires/le volume prélevé ; après Champ 8 : résultats
--     comparés RT "à la demande" vs systématique) — ce sont des rappels de
--     littérature/contexte, jamais formulés en "il faut/il ne faut pas", et
--     ne portent aucun grade propre : ils étayent une recommandation déjà
--     listée plutôt que d'en constituer une nouvelle.
--  3. 3 cas explicites "Aucune recommandation possible" (déjà comptés dans
--     le "45" du paragraphe de comptage ci-dessus, jamais comme des lignes
--     recommendations puisque, par définition, aucune recommandation n'a pu
--     être formulée par la source elle-même) :
--       a. Troponine hors contexte postopératoire (après R4.2) : "il n'est
--          pas possible de formuler de recommandation sur le dosage
--          systématique de la troponine en réanimation" hors post-op.
--       b. Peptides natriurétiques (BNP) hors contexte postopératoire
--          (après R5.1) : "la littérature ne permet de formuler aucune
--          recommandation sur l'utilisation du BNP" hors post-op.
--       c. Hémocultures systématiques sous traitements interférant avec le
--          monitorage de la température (après R7.5) : hypothermie
--          thérapeutique, épuration extra-rénale continue.
--  4. Bloc de clôture "Sources et traçabilité" + avertissement final
--     (mentions légales : fiche indépendante non éditée/validée par la
--     SFAR/SRLF, 106 références bibliographiques non reprises) — contenu
--     administratif/juridique, pas clinique.
--
-- `population` : renseignée UNIQUEMENT quand la source elle-même stratifie
-- explicitement par un sous-en-tête de section (jamais déduite d'un
-- qualificatif noyé dans une seule phrase de recommandation) : "Postopératoire,
-- hors chirurgie cardiaque" pour R4.1/R4.2/R5.1 (sous-en-tête source explicite
-- avant les tableaux des Champs 4 et 5) ; "Suspicion de pneumonie nosocomiale
-- (patients immunodéprimés exclus)" pour R7.6-R7.10 (sous-en-tête source
-- explicite avant le tableau pulmonaire du Champ 7 2/2) ; "Patients intubés
-- et ventilés" pour R8.1 (sujet direct de l'énoncé). Toutes les autres lignes
-- : population NULL, y compris quand un qualificatif de population figure
-- dans le corps de la phrase elle-même (ex. R3.4 "patients chirurgicaux",
-- R2.3 "patients instables") — pour ne pas fabriquer une strate de
-- population que la source ne présente pas comme un sous-en-tête normatif
-- distinct.
--
-- `specialties` : `anesthesie_reanimation` + `medecine_intensive_reanimation`
-- (base commune à tous les documents SFAR-SRLF de réanimation transversale
-- de ce corpus, ex. 0007/anemie, 0016/controle_temperature, 0031/
-- lat_soins_critiques) + `infectiologie_maladies_infectieuses_et_tropicales`
-- (décision éditoriale disclosed, pas une supposition : ~21 des 43 lignes
-- ci-dessous, soit près de la moitié du document — Champ 3 biomarqueurs du
-- sepsis + Champ 7 en totalité, hémocultures/pulmonaire/ECBU/coproculture —
-- portent spécifiquement sur la stratégie de prescription microbiologique ;
-- même slug déjà utilisé pour 0010/antibiotherapie_probabiliste sur un
-- raisonnement identique). `cardiologie` et `radiologie_et_imagerie_medicale`
-- délibérément NON ajoutées : la troponine/les peptides natriurétiques
-- (Champs 4-5, 3 lignes) et la radiographie thoracique (Champ 8, 4 lignes)
-- ne représentent chacun qu'une fraction mineure des 43 lignes et le document
-- les traite sous l'angle "pertinence de la prescription en réanimation",
-- pas comme un référentiel de cardiologie ou de radiologie — à rouvrir si un
-- relecteur humain juge that le seuil doit être différent.
-- Les 3 specialties ci-dessus et les 2 sociétés (SFAR, SRLF) ont été
-- vérifiées contre la liste COMPLÈTE fournie (18 sociétés, 77 specialties
-- avec "autre_paramedical"), lue intégralement dans schema_v2.sql
-- (sections 14 et 15, lignes ~1249-1351) — pas une commande grep/head
-- tronquée. Les 2 sociétés et les 3 specialties utilisées ci-dessous
-- appartiennent toutes au seed ; aucune société/specialty hors seed pour ce
-- document (contrairement à 0086/brule_grave qui avait dû disclosed
-- l'absence d'un slug "brûlologie" dédié).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Pertinence de la prescription des examens biologiques et de la radiographie thoracique en réanimation',
  'RFE', 'fr', '2017-01-11',
  'https://sfar.org/pertinence-de-la-prescription-des-examens-biologiques-et-de-la-radiographie-thoracique-en-reanimation/',
  'https://sfar.org/wp-content/uploads/2017/01/2_RFE-EC-en-rea-version-15-12-16.pdf',
  'GRADE® (qualité des preuves haute/modérée/basse/très basse ; recommandation forte "il faut/il ne faut pas" ou faible "il faut probablement/il ne faut probablement pas" ; méthode PICO ; cotation Delphi/GRADE Grid) + "AE" (avis d''expert, hors échelle 1+/1-/2+/2-) quand la preuve est insuffisante pour une cotation GRADE mais qu''un consensus existe. Divergence de comptage interne à la source, non réconciliée : "49 recommandations formalisées" annoncées vs 42 items directement dénombrables dans le corps du texte (38 gradés + 4 AE) + 3 cas "aucune recommandation possible" = 45, ni 49 ni 52 — disclosure intégrale en commentaire de migration.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/pertinence-de-la-prescription-des-examens-biologiques-et-de-la-radiographie-thoracique-en-reanimation/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'), ('SRLF', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/pertinence-de-la-prescription-des-examens-biologiques-et-de-la-radiographie-thoracique-en-reanimation/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'infectiologie_maladies_infectieuses_et_tropicales')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.population, v.source_section,
  'https://sfar.org/pertinence-de-la-prescription-des-examens-biologiques-et-de-la-radiographie-thoracique-en-reanimation/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000094-R01', 'Réduire autant que possible le nombre de prélèvements sanguins à l''admission et au quotidien, afin de réduire la spoliation sanguine et le coût lié aux examens.', 'AE', 'Réduction du nombre de prélèvements sanguins', null, 'Champ 1 — Bilan d''entrée systématique en réanimation, R1.1'),
  ('MG-ANES-000094-R02', 'Rechercher systématiquement une éventuelle grossesse à l''admission, soit par l''interrogatoire, soit par un dosage de β-hCG urinaire ou quantitatif sanguin.', 'AE', 'Dépistage systématique d''une grossesse à l''admission', null, 'Champ 1 — Bilan d''entrée systématique en réanimation, R1.2'),
  ('MG-ANES-000094-R03', 'Il ne faut probablement pas réaliser de façon systématique et quotidienne l''ensemble des examens biologiques (NFS, ionogrammes sanguin et urinaire, gazométrie, bilan hépatique).', '2-', 'Bilan biologique quotidien systématique — non systématique', null, 'Champ 2 — Bilan quotidien systématique en réanimation, R2.1'),
  ('MG-ANES-000094-R04', 'Il faut discuter la réalisation des examens biologiques à chaque évaluation clinique, en vue de restreindre leur nombre.', '1+', 'Discussion de la pertinence des examens biologiques à chaque évaluation clinique', null, 'Champ 2 — Bilan quotidien systématique en réanimation, R2.2'),
  ('MG-ANES-000094-R05', 'Il faut probablement réaliser un ionogramme sanguin et urinaire, une numération sanguine et des gaz du sang artériels quotidiennement chez les patients instables sur le plan hémodynamique, rénal ou respiratoire.', '2+', 'Bilan biologique quotidien chez le patient instable', null, 'Champ 2 — Bilan quotidien systématique en réanimation, R2.3'),
  ('MG-ANES-000094-R06', 'Il faut probablement écrire un protocole de service pour réduire le nombre d''examens biologiques et faire connaître le coût des prescriptions.', '2+', 'Protocole de service pour réduire les prescriptions biologiques', null, 'Champ 2 — Bilan quotidien systématique en réanimation, R2.4'),
  ('MG-ANES-000094-R07', 'La procalcitonine (PCT), comme tout biomarqueur, ne doit pas être utilisée ni interprétée indépendamment de l''ensemble des éléments cliniques et paracliniques, mais s''intégrer dans une démarche globale de prise en charge.', 'AE', 'Interprétation de la procalcitonine (PCT) en démarche clinique globale', null, 'Champ 3 — Biomarqueurs du sepsis, R3.1'),
  ('MG-ANES-000094-R08', 'Compte tenu de son manque de spécificité, l''utilisation de la CRP n''est pas recommandée chez tous les patients de réanimation.', 'AE', 'Utilisation de la CRP — non recommandée en systématique', null, 'Champ 3 — Biomarqueurs du sepsis, R3.2'),
  ('MG-ANES-000094-R09', 'Il ne faut pas doser la PCT dans les sepsis évidents dans le seul but d''en étayer le diagnostic — une valeur précoce peut néanmoins servir de référence pour la gestion ultérieure de l''antibiothérapie (arrêt plus rapide ou modification).', '1-', 'Dosage de la PCT dans les sepsis évidents', null, 'Champ 3 — Biomarqueurs du sepsis, R3.3'),
  ('MG-ANES-000094-R10', 'Dans certaines situations particulières (patients chirurgicaux, infections intra-abdominales), l''intérêt de la PCT n''est pas clairement établi et son utilisation n''est pas recommandée en routine.', '1-', 'Utilisation de la PCT en situations particulières (chirurgical, infections intra-abdominales)', null, 'Champ 3 — Biomarqueurs du sepsis, R3.4'),
  ('MG-ANES-000094-R11', 'Il ne faut pas doser systématiquement la troponine en postopératoire pour les chirurgies à faible risque cardiaque (<1 %). Pour les chirurgies à risque intermédiaire ou élevé, il ne faut pas la doser systématiquement chez les patients à faible risque cardiaque (Revised Cardiac Risk Index de Lee ≤1).', '1-', 'Dosage systématique de la troponine postopératoire', 'Postopératoire, hors chirurgie cardiaque', 'Champ 4 — Troponine en dehors de modifications du segment ST, R4.1'),
  ('MG-ANES-000094-R12', 'Lorsque le motif d''admission en réanimation/surveillance continue est la gestion du risque cardiaque postopératoire, il faut doser systématiquement la troponine — la période du jour de l''opération au 3e jour postopératoire est la meilleure fenêtre de détection.', '1+', 'Dosage de la troponine pour la gestion du risque cardiaque postopératoire', 'Postopératoire, hors chirurgie cardiaque', 'Champ 4 — Troponine en dehors de modifications du segment ST, R4.2'),
  ('MG-ANES-000094-R13', 'Il ne faut pas doser systématiquement les peptides natriurétiques en période postopératoire des chirurgies à faible risque cardiaque (<1 %). Pour les chirurgies à risque intermédiaire/élevé, il ne faut pas les doser systématiquement chez les patients à faible risque cardiaque (RCRI <2) ou à très haut risque (RCRI >3).', '1-', 'Dosage systématique des peptides natriurétiques (BNP) postopératoires', 'Postopératoire, hors chirurgie cardiaque', 'Champ 5 — Place des peptides natriurétiques, R5.1'),
  ('MG-ANES-000094-R14', 'Il faut probablement disposer d''un bilan d''hémostase (TP, TCA, plaquettes) chez tout patient admis en réanimation.', '2+', 'Bilan d''hémostase à l''admission', null, 'Champ 6 — Quand prescrire un bilan d''hémostase, R6.1'),
  ('MG-ANES-000094-R15', 'Il ne faut probablement pas répéter systématiquement les examens d''hémostase une fois le bilan initial prélevé.', '2-', 'Répétition systématique du bilan d''hémostase — non systématique', null, 'Champ 6 — Quand prescrire un bilan d''hémostase, R6.2'),
  ('MG-ANES-000094-R16', 'Il faut répéter les examens d''hémostase en cas d''anomalies ou de survenue d''une affection aiguë pouvant interférer avec l''hémostase.', '1+', 'Répétition ciblée du bilan d''hémostase', null, 'Champ 6 — Quand prescrire un bilan d''hémostase, R6.3'),
  ('MG-ANES-000094-R17', 'Il ne faut pas effectuer systématiquement de surveillance biologique de l''activité anticoagulante des traitements utilisés à dose préventive (prophylaxie de la MTEV), en dehors de la surveillance plaquettaire lorsque celle-ci est indiquée.', '1-', 'Surveillance biologique de l''anticoagulation prophylactique', null, 'Champ 6 — Quand prescrire un bilan d''hémostase, R6.4'),
  ('MG-ANES-000094-R18', 'Il faut probablement surveiller l''effet anticoagulant d''un traitement par héparine non fractionnée à doses thérapeutiques par la mesure de l''activité anti-Xa plutôt que par le TCA.', '2+', 'Surveillance de l''héparine non fractionnée à doses thérapeutiques — anti-Xa vs TCA', null, 'Champ 6 — Quand prescrire un bilan d''hémostase, R6.5'),
  ('MG-ANES-000094-R19', 'Il faut prélever des hémocultures devant tout sepsis.', '1+', 'Hémocultures devant tout sepsis', null, 'Champ 7 (1/2) — Examens bactériologiques standards : hémocultures, R7.1'),
  ('MG-ANES-000094-R20', 'Il ne faut probablement pas répéter ces prélèvements de manière systématique.', '2-', 'Répétition systématique des hémocultures — non systématique', null, 'Champ 7 (1/2) — Examens bactériologiques standards : hémocultures, R7.2'),
  ('MG-ANES-000094-R21', 'Il faut probablement prélever de nouvelles hémocultures 24h après la première série en cas de suspicion d''endocardite ou de syndrome infectieux persistant avec premières hémocultures restant négatives après 24h d''incubation.', '1+', 'Nouvelles hémocultures à 24h en cas d''endocardite ou de syndrome infectieux persistant', null, 'Champ 7 (1/2) — Examens bactériologiques standards : hémocultures, R7.3'),
  ('MG-ANES-000094-R22', 'Il faut probablement réduire le nombre de paires d''hémocultures à 2-3 par épisode clinique et par tranche de 24h, pour réduire coûts et spoliation sanguine.', '2+', 'Nombre de paires d''hémocultures par épisode/24h', null, 'Champ 7 (1/2) — Examens bactériologiques standards : hémocultures, R7.4'),
  ('MG-ANES-000094-R23', 'Il faut prélever par ponction veineuse directe, en une seule fois, un volume minimum de 40 à 60 mL et le répartir dans 4 à 6 flacons (2-3 aérobies, 2-3 anaérobies), pour minimiser faux positifs (défaut d''antisepsie) et faux négatifs (volume insuffisant).', '1+', 'Modalités de prélèvement des hémocultures (volume, flacons)', null, 'Champ 7 (1/2) — Examens bactériologiques standards : hémocultures, R7.5'),
  ('MG-ANES-000094-R24', 'Il faut réaliser des prélèvements microbiologiques pulmonaires uniquement en cas de suspicion de pneumonie nosocomiale, en respectant les conditions de prélèvement/acheminement pour une interprétation fiable.', '1+', 'Prélèvements microbiologiques pulmonaires ciblés', 'Suspicion de pneumonie nosocomiale (patients immunodéprimés exclus)', 'Champ 7 (2/2) — Prélèvements pulmonaires, ECBU, coproculture — Prélèvements pulmonaires, R7.6'),
  ('MG-ANES-000094-R25', 'Il faut probablement réaliser des prélèvements pulmonaires devant toute suspicion de pneumonie nosocomiale pour identifier le germe et adapter l''antibiothérapie.', '2+', 'Prélèvements pulmonaires pour identification du germe', 'Suspicion de pneumonie nosocomiale (patients immunodéprimés exclus)', 'Champ 7 (2/2) — Prélèvements pulmonaires, ECBU, coproculture — Prélèvements pulmonaires, R7.7'),
  ('MG-ANES-000094-R26', 'Il ne faut pas répéter les prélèvements pulmonaires en cas d''évolution favorable d''une pneumonie nosocomiale.', '1+', 'Répétition des prélèvements pulmonaires en cas d''évolution favorable — non recommandée', 'Suspicion de pneumonie nosocomiale (patients immunodéprimés exclus)', 'Champ 7 (2/2) — Prélèvements pulmonaires, ECBU, coproculture — Prélèvements pulmonaires, R7.8'),
  ('MG-ANES-000094-R27', 'Il ne faut probablement pas réaliser de prélèvements pulmonaires de « dépistage » systématiques, y compris chez les patients en SDRA.', '2-', 'Prélèvements pulmonaires de dépistage systématique — non recommandés', 'Suspicion de pneumonie nosocomiale (patients immunodéprimés exclus), y compris SDRA', 'Champ 7 (2/2) — Prélèvements pulmonaires, ECBU, coproculture — Prélèvements pulmonaires, R7.9'),
  ('MG-ANES-000094-R28', 'Il faut probablement dépister la grippe, même en situation nosocomiale, en cas de contexte épidémique ou de notion de contage, en particulier chez les patients avec comorbidités respiratoires ou cardiovasculaires.', '2+', 'Dépistage de la grippe en contexte épidémique', 'Suspicion de pneumonie nosocomiale (patients immunodéprimés exclus)', 'Champ 7 (2/2) — Prélèvements pulmonaires, ECBU, coproculture — Prélèvements pulmonaires, R7.10'),
  ('MG-ANES-000094-R29', 'Concernant les modes de prélèvement pulmonaire, les experts renvoient à la recommandation Q2 de la recommandation SRLF-SFAR-SPILF « Stratégies de réduction de l''utilisation des antibiotiques à visée curative en réanimation ».', null, 'Renvoi externe — modes de prélèvement pulmonaire (SRLF-SFAR-SPILF)', 'Suspicion de pneumonie nosocomiale (patients immunodéprimés exclus)', 'Champ 7 (2/2) — Prélèvements pulmonaires, ECBU, coproculture — item imprimé « R 7.2.5 » dans la source (anomalie de numérotation entre R7.10 et R7.12, non renuméroté « R7.11 » ; grade absent de la source elle-même ; disclosure complète en commentaire de migration, à vérifier si ce renvoi externe doit rester dans le périmètre recommandations)'),
  ('MG-ANES-000094-R30', 'Il faut réaliser un ECBU à visée diagnostique en présence de signes cliniques d''infection urinaire compliquée (pyélonéphrite aiguë, prostatite) ou en cas de sepsis sans autre porte d''entrée identifiée.', '1+', 'ECBU à visée diagnostique', null, 'Champ 7 (2/2) — Prélèvements pulmonaires, ECBU, coproculture — Examen cytobactériologique des urines (ECBU), R7.12'),
  ('MG-ANES-000094-R31', 'Il ne faut pas réaliser d''ECBU de contrôle 48-72h après le début de l''antibiothérapie, sauf en cas de non-réponse clinique au traitement.', '1-', 'ECBU de contrôle après antibiothérapie — non recommandé en systématique', null, 'Champ 7 (2/2) — Prélèvements pulmonaires, ECBU, coproculture — Examen cytobactériologique des urines (ECBU), R7.13'),
  ('MG-ANES-000094-R32', 'Il ne faut pas dépister systématiquement les colonisations urinaires (bandelette ou ECBU), en dehors de situations à risque (femmes enceintes, intervention chirurgicale sur les voies urinaires).', '1+', 'Dépistage systématique des colonisations urinaires — non recommandé', null, 'Champ 7 (2/2) — Prélèvements pulmonaires, ECBU, coproculture — Examen cytobactériologique des urines (ECBU), R7.14'),
  ('MG-ANES-000094-R33', 'Il faut réaliser une coproculture standard en cas de selles diarrhéiques uniquement si le patient est hospitalisé depuis moins de 3 jours.', '1+', 'Indication de la coproculture standard selon la durée d''hospitalisation', null, 'Champ 7 (2/2) — Prélèvements pulmonaires, ECBU, coproculture — Coproculture, R7.15'),
  ('MG-ANES-000094-R34', 'Il ne faut pas réaliser de coproculture standard de contrôle en cas de première coproculture négative, même si les diarrhées persistent (toutes les diarrhées n''étant pas d''origine infectieuse).', '2-', 'Coproculture de contrôle après négativité — non recommandée', null, 'Champ 7 (2/2) — Prélèvements pulmonaires, ECBU, coproculture — Coproculture, R7.16'),
  ('MG-ANES-000094-R35', 'Il faut rechercher d''autres bactéries entéropathogènes si la coproculture standard est négative en cas de contexte particulier précisé dès l''entrée : voyage récent en pays tropical, toxi-infection alimentaire collective, syndrome cholériforme ou diarrhée hémorragique.', '1+', 'Recherche de bactéries entéropathogènes en contexte particulier', null, 'Champ 7 (2/2) — Prélèvements pulmonaires, ECBU, coproculture — Coproculture, R7.17'),
  ('MG-ANES-000094-R36', 'Il ne faut pas réaliser de coproculture standard chez le patient hospitalisé depuis plus de 3 jours, excepté en cas d''immunodépression.', '2+', 'Coproculture standard au-delà de 3 jours d''hospitalisation — non recommandée', null, 'Champ 7 (2/2) — Prélèvements pulmonaires, ECBU, coproculture — Coproculture, R7.18'),
  ('MG-ANES-000094-R37', 'Il faut rechercher des micro-organismes particuliers en cas de diarrhée secondaire à un traitement antibiotique (Clostridium difficile, Klebsiella oxytoca, Pseudomonas aeruginosa, Candida albicans, Clostridium perfringens producteur d''entérotoxine).', '1+', 'Recherche de micro-organismes particuliers en cas de diarrhée post-antibiotique', null, 'Champ 7 (2/2) — Prélèvements pulmonaires, ECBU, coproculture — Coproculture, R7.19'),
  ('MG-ANES-000094-R38', 'Il faut rechercher le Clostridium difficile de façon spécifique, sans l''associer à la demande d''une coproculture standard (contexte totalement différent).', '1+', 'Recherche spécifique du Clostridium difficile', null, 'Champ 7 (2/2) — Prélèvements pulmonaires, ECBU, coproculture — Coproculture, R7.20'),
  ('MG-ANES-000094-R39', 'Il ne faut pas réitérer la recherche de Clostridium difficile lorsqu''elle est positive.', '1-', 'Réitération de la recherche du Clostridium difficile après positivité — non recommandée', null, 'Champ 7 (2/2) — Prélèvements pulmonaires, ECBU, coproculture — Coproculture, R7.21'),
  ('MG-ANES-000094-R40', 'Il ne faut pas faire de RT au lit quotidienne systématique chez les patients intubés et ventilés.', '1-', 'RT au lit quotidienne systématique — non recommandée', 'Patients intubés et ventilés', 'Champ 8 — Prescrire une radiographie thoracique (RT) au lit, R8.1'),
  ('MG-ANES-000094-R41', 'Il faut probablement réaliser une RT en cas d''altération des échanges gazeux, d''augmentation des pressions d''insufflation (pression de plateau) ou de modifications auscultatoires faisant suspecter une anomalie parenchymateuse/pleurale — bien que le scanner (voire l''échographie pulmonaire) soit vraisemblablement supérieur.', '2+', 'RT sur signes cliniques d''appel respiratoire', null, 'Champ 8 — Prescrire une radiographie thoracique (RT) au lit, R8.2'),
  ('MG-ANES-000094-R42', 'Il faut probablement faire une RT au décours de la pose de dispositifs invasifs (sonde d''intubation, canule de trachéotomie, cathéter veineux central en territoire cave supérieur, drain thoracique, sonde gastrique) pour en vérifier la position et l''absence de complications.', '2+', 'RT après pose de dispositifs invasifs', null, 'Champ 8 — Prescrire une radiographie thoracique (RT) au lit, R8.3'),
  ('MG-ANES-000094-R43', 'Il faut probablement envisager l''échographie thoracique comme alternative à la RT pour détecter des anomalies pleurales (pneumothorax, pleurésie) voire parenchymateuses (foyer, atélectasie).', '2+', 'Échographie thoracique comme alternative à la RT', null, 'Champ 8 — Prescrire une radiographie thoracique (RT) au lit, R8.4')
) as v(code, statement, grade, condition_topic, population, source_section)
where d.source_url = 'https://sfar.org/pertinence-de-la-prescription-des-examens-biologiques-et-de-la-radiographie-thoracique-en-reanimation/'
on conflict (recommendation_code) do nothing;
