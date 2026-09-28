-- Migration : Recommandations sur les indications de l'assistance circulatoire dans le
-- traitement des arrêts cardiaques réfractaires — coordination Bruno Riou, sous l'égide de
-- la Direction générale de la santé et de la Direction des hôpitaux, à la demande de 9
-- sociétés savantes. Ann Fr Anesth Reanim 2009;28:182-186, doi:10.1016/j.annfar.2008.12.011.
-- Source : rfe-sfar-website/build/content_eclsa.json.
--
-- MÉTHODOLOGIE — CAS PARTICULIER DE CE CORPUS : ce document est rédigé en PROSE CONTINUE,
-- SANS système GRADE, SANS numérotation R1/R2, et SANS tableau "Réf. | Recommandation |
-- Grade" d'aucune sorte. Une seule mention de niveau de preuve est imprimée dans tout le
-- texte source, appliquée globalement à l'ensemble des propositions du groupe d'experts :
-- « recommandations de niveau 5 » (échelle bibliographique citée en référence par la
-- source elle-même — le contenu construit traduit explicitement ce niveau comme « avis
-- d'experts »). Convention retenue ici, disclosure explicite : `grade = 'AE'` (avis
-- d'experts) pour toutes les lignes migrées, par cohérence avec la valeur déjà utilisée
-- dans ce corpus (ex. 0018_migrate_curares.sql) pour désigner un avis d'experts — PAS une
-- invention de grade individuel : c'est la seule cotation que la source imprime, appliquée
-- uniformément, et son libellé littéral exact ("niveau 5") est conservé ici en commentaire
-- pour qu'un relecteur puisse vérifier l'équivalence. `evidence_level` laissé NULL : aucun
-- second axe de cotation distinct dans ce document (contrairement par ex. à
-- 0008/0013_migrate_asthme_aigu_grave.sql, SRLF Preuve/Force, ou 0017_migrate_corticotherapie.sql).
--
-- À VÉRIFIER — JUGEMENT MÉTHODOLOGIQUE SPÉCIFIQUE À CETTE FICHE (disclosure, pas une
-- invention) :
-- 1. Ce document n'a NULLE PART de phrases-recommandations numérotées comme les autres
--    fiches migrées jusqu'ici. Les seuls éléments directement actionnables sont : (a) un
--    algorithme décisionnel reconstruit visuellement (Fig. 1 de la source, 3 colonnes
--    "INDICATION POSSIBLE / INCERTITUDE / PAS D'INDICATION") dont les critères de décision
--    (no-flow, low-flow, ETCO2, rythme, intoxication, hypothermie, comorbidités) ne sont
--    imprimés NULLE PART ailleurs dans le texte sous une autre forme, et (b) quelques
--    phrases de prose au style directif ("il est recommandé de...", "il n'est pas
--    raisonnable de..."). Contrairement aux précédents de ce corpus où une figure/algorithme
--    a été exclu de la migration parce que son contenu était redondant avec des lignes
--    déjà graduées séparément ailleurs dans le document (aap_urgence, aap_programmee,
--    anticoagulants, curares, civd — voir leurs migrations respectives), ici l'algorithme
--    EST la seule source des critères cliniques concrets de tout le document : l'exclure
--    reviendrait à ne migrer aucune recommandation clinique exploitable pour ce document,
--    en violation du principe de couverture de ce projet. Décision : les 12 lignes
--    ci-dessous reformulent fidèlement, sous forme de phrases déclaratives complètes, les
--    critères de l'algorithme et les phrases directives de prose — sans ajouter aucun
--    critère, seuil ou nuance qui ne figure pas explicitement dans le texte ou l'algorithme
--    source. Chaque statement a été relu contre le JSON source phrase par phrase.
-- 2. Grade unique appliqué à tout le texte ('AE' / "niveau 5") : voir disclosure
--    méthodologique ci-dessus. Aucune ligne n'a de grade individuel distinct dans la
--    source — ce n'est donc PAS une violation du principe "jamais de grade composite
--    fabriqué" : il s'agit d'un seul et même grade global, reproduit identiquement sur
--    chaque ligne, pas de deux grades fusionnés en un seul chip.
-- 3. R05 documente une exception explicitement disclosée par la source elle-même (pas
--    résolue silencieusement) : le seuil "low-flow > 100 min = pas d'indication" ne
--    s'applique pas aux intoxications par cardiotropes, où une durée de RCP plus longue
--    peut être acceptée sans contre-indiquer formellement l'assistance circulatoire (note
--    de bas de figure de la source, astérisque *).
-- 4. Non migré, volontairement, comme relevant du contexte/de la définition plutôt que de
--    recommandations actionnables distinctes : la définition classique de l'AC réfractaire
--    (30 min sans assistance circulatoire), les définitions de no-flow/low-flow elles-mêmes
--    (reproduites dans le tableau "Déterminant | Définition | Poids pronostique", à visée
--    pédagogique — les seuils qui en découlent sont eux bien capturés dans R02/R05), les
--    valeurs épidémiologiques de contexte (50 000 AC/an, survie 3-5 %), la phrase générale
--    "l'âge ne constitue pas en soi une raison suffisante pour limiter la RCP" (portée sur
--    la RCP courante en général, pas spécifique à l'indication de l'assistance circulatoire
--    — hors périmètre de ce document), et le paragraphe sur les machines à massage
--    cardiaque (absence de preuve d'efficacité disclosée par la source elle-même, pas une
--    recommandation positive ou négative formulée). Les lacunes de connaissances et
--    limites méthodologiques (cohortes monocentriques, absence d'essai randomisé) sont
--    reproduites dans la fiche elle-même mais ne sont pas des recommandations.
-- 5. Document de 2009, antérieur aux essais randomisés modernes sur l'ECPR (ARREST 2020,
--    PRAGUE-OHCA 2022, INCEPTION 2023) — disclosure explicitement imprimée par le contenu
--    construit lui-même dans son avertissement. `freshness_status` mis à 'revision_detectee'
--    (et non 'a_jour') précisément à cause de cet avertissement — valeur choisie parmi les
--    4 permises par la contrainte check de schema_v2.sql ('a_jour', 'revision_detectee',
--    'remplacee', 'retiree') comme la plus fidèle à "essais randomisés majeurs publiés
--    depuis, place de la technique nuancée depuis" sans affirmer que le document est
--    remplacé ou retiré (ce que ni la source ni library_final.json ne disent). Notez que
--    `library_final.json` indique lui `"status": "en vigueur"` — divergence disclosée ici,
--    à trancher par un relecteur humain avant toute publication en statut autre que 'draft'.
-- 6. Sociétés co-signataires (9 au total dans la source) vs. seed Annexe B de ce projet
--    (schema_v2.sql) : seules SFAR, SFMU, SFC (Société française de cardiologie) et SRLF
--    correspondent exactement à des acronymes du seed. Les 5 autres sociétés citées par la
--    source (Conseil français de réanimation cardiopulmonaire, Société française de
--    chirurgie thoracique et cardiovasculaire [SFCTCV], Société française de pédiatrie,
--    GFRUP, Société française de perfusion) n'ont PAS d'entrée correspondante dans le seed
--    `societies` de schema_v2.sql à ce jour — non liées en document_societies plutôt que
--    d'inventer un acronyme ou de les approximer sur une société existante différente ;
--    à compléter par un relecteur humain si le seed est étendu.
-- 7. `direct_pdf_url` de library_final.json (2015) diffère de l'URL d'origine 2009 citée
--    dans le corps du texte de la fiche construite (2_AFAR_Recommandations... vs. le
--    lien DOI Elsevier) — utilisé `direct_pdf_url` de library_final.json comme `source_url`/
--    `pdf_url`, cohérent avec la convention de ce projet pour toutes les fiches migrées
--    jusqu'ici (le lien effectivement hébergé par sfar.org, pas le DOI éditeur).

insert into public.documents (title, doc_type, original_language, publication_date, doi, source_url, pdf_url, grading_system, freshness_status)
values (
  'Indications de l''assistance circulatoire dans le traitement des arrêts cardiaques réfractaires',
  'RFE', 'fr', '2009-01-01',
  '10.1016/j.annfar.2008.12.011',
  'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Recommandations-sur-les-indications-de-lassistance-circulatoire-dans-le-traitement-des-arrets-cardiaques-refractaires.pdf',
  'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Recommandations-sur-les-indications-de-lassistance-circulatoire-dans-le-traitement-des-arrets-cardiaques-refractaires.pdf',
  'Aucun système GRADE ni numérotation R1/R2. Une seule mention globale de niveau de preuve imprimée par la source : « recommandations de niveau 5 » (avis d''experts), appliquée à l''ensemble du texte — pas de cotation individuelle par proposition.',
  'revision_detectee'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Recommandations-sur-les-indications-de-lassistance-circulatoire-dans-le-traitement-des-arrets-cardiaques-refractaires.pdf'
  and s.acronym in ('SFAR', 'SFMU', 'SFC', 'SRLF') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Recommandations-sur-les-indications-de-lassistance-circulatoire-dans-le-traitement-des-arrets-cardiaques-refractaires.pdf'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'medecine_d_urgence', 'cardiologie', 'chirurgie_cardiaque', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.source_section,
  'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Recommandations-sur-les-indications-de-lassistance-circulatoire-dans-le-traitement-des-arrets-cardiaques-refractaires.pdf',
  'draft'
from public.documents d, (values
  ('MG-ANES-000019-R01', 'Chez un patient en arrêt cardiaque réfractaire, l''assistance circulatoire est une indication possible, quelle que soit la durée de no-flow, en cas d''intoxication par un cardiotrope, d''hypothermie ≤ 32 °C, de signes de vie pendant la réanimation cardiopulmonaire, ou de trouble du rythme ventriculaire (tachycardie ventriculaire, torsade de pointes, fibrillation ventriculaire) hors rythme agonique.', 'AE', null, 'Algorithme décisionnel (Fig. 1) — colonne « Indication possible »'),
  ('MG-ANES-000019-R02', 'Chez un patient en arrêt cardiaque réfractaire avec un no-flow de 0 à 5 minutes, l''assistance circulatoire est indiquée en cas de durée de low-flow inférieure ou égale à 100 minutes et d''ETCO2 supérieure ou égale à 10 mmHg (mesurée après 20 minutes de réanimation cardiopulmonaire médicalisée).', 'AE', null, 'Algorithme décisionnel (Fig. 1) — évaluation du low-flow / ETCO2'),
  ('MG-ANES-000019-R03', 'Chez un patient en arrêt cardiaque réfractaire, il n''est pas recommandé de proposer l''assistance circulatoire en présence de comorbidités rendant déraisonnable un traitement invasif (réanimation, chirurgie, angioplastie coronaire).', 'AE', null, 'Algorithme décisionnel (Fig. 1) — colonne « Pas d''indication »'),
  ('MG-ANES-000019-R04', 'Chez un patient en arrêt cardiaque réfractaire avec un no-flow supérieur à 5 minutes ou non estimable (absence de témoin), il n''est pas recommandé de proposer l''assistance circulatoire en cas d''asystole ou de rythme agonique au moment de l''évaluation du rythme.', 'AE', null, 'Algorithme décisionnel (Fig. 1) — colonne « Pas d''indication »'),
  ('MG-ANES-000019-R05', 'Chez un patient en arrêt cardiaque réfractaire, il n''est pas recommandé de proposer l''assistance circulatoire en cas d''ETCO2 inférieure à 10 mmHg ou de durée de low-flow supérieure à 100 minutes — sauf en cas d''intoxication par un cardiotrope, où une durée de réanimation cardiopulmonaire plus longue peut être acceptée sans contre-indiquer formellement l''assistance circulatoire.', 'AE', null, 'Algorithme décisionnel (Fig. 1) — colonne « Pas d''indication » + note *'),
  ('MG-ANES-000019-R06', 'Il n''est pas nécessaire d''attendre les 30 minutes de la définition classique de l''arrêt cardiaque réfractaire pour déclencher la mise en œuvre d''une assistance circulatoire ; il n''est cependant pas raisonnable d''en évoquer l''hypothèse avant au moins 15 minutes de réanimation cardiopulmonaire médicalisée.', 'AE', null, 'Définition de l''AC réfractaire & changement de paradigme'),
  ('MG-ANES-000019-R07', 'Pour la mise en place de l''assistance circulatoire, un abord direct des vaisseaux fémoraux est recommandé.', 'AE', null, 'Modalités pratiques de mise en œuvre — Abord vasculaire'),
  ('MG-ANES-000019-R08', 'Pour la mise en place de l''assistance circulatoire, le concours d''un chirurgien formé à cette technique est recommandé.', 'AE', null, 'Modalités pratiques de mise en œuvre — Chirurgien'),
  ('MG-ANES-000019-R09', 'Une équipe de réanimation qualifiée est requise pour la gestion de l''assistance circulatoire.', 'AE', null, 'Modalités pratiques de mise en œuvre — Équipe de réanimation'),
  ('MG-ANES-000019-R10', 'La préparation et la maintenance du dispositif d''assistance circulatoire sont idéalement effectuées par un perfusionniste, cette compétence pouvant être acquise par une formation appropriée.', 'AE', null, 'Modalités pratiques de mise en œuvre — Perfusionniste'),
  ('MG-ANES-000019-R11', 'Chez l''enfant de moins de 15 kg, la pose de l''assistance circulatoire nécessite le concours d''un chirurgien spécialisé en chirurgie pédiatrique ainsi que la disponibilité du matériel d''assistance adapté et de sang homologue pour l''amorçage du circuit.', 'AE', 'Enfant < 15 kg', 'Spécificités pédiatriques'),
  ('MG-ANES-000019-R12', 'Chez le patient en arrêt cardiaque hypothermique, il est recommandé de limiter les indications de l''assistance circulatoire aux patients présentant des critères pronostiques favorables (par exemple une poche d''air en cas d''accident d''avalanche) ou en s''aidant de critères biologiques tels que la kaliémie, l''hypothermie ne permettant plus d''estimer la souffrance neurologique pendant les périodes de no-flow et de low-flow.', 'AE', 'Arrêt cardiaque hypothermique', 'Spécificités de l''AC hypothermique')
) as v(code, statement, grade, population, source_section)
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Recommandations-sur-les-indications-de-lassistance-circulatoire-dans-le-traitement-des-arrets-cardiaques-refractaires.pdf'
on conflict (recommendation_code) do nothing;
