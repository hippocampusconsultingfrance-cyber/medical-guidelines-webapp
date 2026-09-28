-- Migration : Pancréatite aigüe grave du patient adulte en soins critiques — Recommandations
-- Formalisées d'Experts, SFAR, en collaboration avec la SNFGE, la SFR, la SFNCM et la SFED.
-- Actualise les précédentes recommandations françaises SFAR/CNGOF de 2001. 14 questions
-- PICO réparties en 3 champs, méthode GRADE. Source :
-- rfe-sfar-website/build/content_pancreatite.json (24 recommandations formalisées + 4
-- questions sans recommandation possible).
--
-- MÉTHODOLOGIE : GRADE (qualité des preuves Haute/Modérée/Basse/Très basse → force Forte
-- [GRADE 1+/1-] ou Faible [GRADE 2+/2-] ; avis d'experts « AE » quand GRADE ne s'applique
-- pas, validé à >70 % d'accord ; « SR » quand aucune réponse n'a pu être apportée — jamais
-- migré, cf. PÉRIMÈTRE ci-dessous). Accord fort pour 100 % des 24 recommandations après 1 à
-- 2 tours de cotation. `grade` reproduit tel quel le chip source. `evidence_level` laissé
-- NULL.
--
-- COMPTAGE — DEUX INCOHÉRENCES INTERNES À LA SOURCE, DISCLOSÉES TELLES QUELLES, NON
-- RÉSOLUES SILENCIEUSEMENT (principe 1.5 du projet) :
-- 1. Le résumé français et l'abstract anglais du document annoncent tous deux « 8
--    recommandations de niveau GRADE 1+/-, 12 de niveau GRADE 2+/- » — chiffre qui
--    correspond EXACTEMENT au tally direct des 20 énoncés GRADE-tagués du corps du texte
--    (6×1+, 2×1-, 6×2+, 6×2-, vérifié ci-dessous). Mais la section « 2.2 Recommandations »
--    du même document annonce l'INVERSE : « 9 GRADE 1+/-, 11 GRADE 2+/- ». Cette migration
--    retient le compte vérifié par tally direct (8/12), cohérent avec les deux résumés
--    (français et anglais), sans trancher laquelle des deux mentions internes de la source
--    (résumés vs section 2.2) est erronée.
-- 2. Comptage total : 24 lignes migrées (8 GRADE + 12 GRADE + 4 AE = 24), exactement
--    conforme à « 24 recommandations formalisées » annoncé par la source — obtenu en
--    excluant les 4 lignes "SR" du tableau (absence de recommandation, cf. PÉRIMÈTRE).
--
-- PÉRIMÈTRE — volontairement pas migrés :
-- 1. Les 4 lignes portant le chip « SR » (« sans recommandation ») dans les tableaux
--    Réf./Recommandation/Niveau eux-mêmes : ventilation mécanique invasive et stratégie
--    protectrice spécifique à la PA grave ; type d'abord pour la nutrition entérale ;
--    molécule d'antibiothérapie probabiliste préférentielle en cas d'infection de coulée de
--    nécrose ; prise en charge de la thrombose veineuse splanchnique — cohérent avec le
--    principe de ce projet de ne jamais migrer une absence de recommandation comme une
--    ligne graduée (ici disclosé avec plus de netteté que d'habitude : le "SR" figure
--    littéralement dans la même colonne "Niveau" que les grades réels, contrairement aux
--    autres documents de ce corpus où l'absence de recommandation est présentée hors
--    tableau, en panneau texte séparé).
-- 2. Figure 1 (algorithme diagnostique/orientation, "transcrit fidèlement depuis la source —
--    image pure page 46, aucune couche texte" d'après le contenu construit lui-même) —
--    organigramme de synthèse, pas des recommandations graduées individuellement.
-- 3. Tableau 1 (Score modifié de Marshall, défaillances d'organe — avec une incohérence
--    interne à la source elle-même déjà disclosée par le contenu construit : le texte
--    source répète le même débit d'O2 "2 L/min" pour les paliers FiO2 25 % et 30 %) et
--    l'Annexe 1 (scores de Balthazar, aspects morphologiques/étendue de nécrose) —
--    échelles de score de référence, pas des recommandations graduées.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SNFGE, SFR, SFNCM, SFED (collaboratrices de cette RFE au même titre que la SFAR) :
--    aucune ne correspond à un acronyme du seed Annexe B de schema_v2.sql — seule la SFAR
--    est liée en document_societies.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Pancréatite aigüe grave du patient adulte en soins critiques',
  'RFE', 'fr', '2021-09-25',
  'https://sfar.org/pancreatite-aigue-grave-du-patient-adulte-en-soins-critiques/',
  'https://sfar.org/download/pancreatite-aigue-grave-du-patient-adulte-en-soins-critiques/?wpdmdl=35411',
  'GRADE® : force forte (1+ recommandé / 1- non recommandé) ou faible (2+ probablement recommandé / 2- probablement non recommandé) ; avis d''experts (AE) si GRADE ne s''applique pas ; « SR » (sans recommandation) si aucune réponse n''a pu être apportée. Accord fort pour 100 % des 24 recommandations. Incohérence interne disclosée : le résumé (français et anglais) annonce "8 GRADE1 / 12 GRADE2", mais la section 2.2 du même document annonce l''inverse "9/11" — le tally direct (8/12) est retenu ici, cohérent avec les résumés.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/pancreatite-aigue-grave-du-patient-adulte-en-soins-critiques/'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/pancreatite-aigue-grave-du-patient-adulte-en-soins-critiques/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'gastro_enterologie_et_hepatologie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/pancreatite-aigue-grave-du-patient-adulte-en-soins-critiques/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000036-R01', 'Décider de l''admission en soins critiques sur la présence d''une pancréatite aigüe grave (défaillance(s) d''organe(s) cardiovasculaire/respiratoire/rénale, avec ou sans nécrose infectée) ou jugée à risque de le devenir après évaluation multidisciplinaire — aucun score isolé ne peut à ce jour être recommandé pour cette décision.', '2+', 'CHAMP 1 — Évaluation et admission en soins critiques (Réf. R1.1)'),
  ('MG-ANES-000036-R02', 'En cas de doute diagnostique après anamnèse/examen clinique/lipasémie, ou en l''absence de réponse au traitement ou d''aggravation clinique : réaliser un scanner abdomino-pelvien le plus tôt possible pour confirmer le diagnostic positif.', '1+', 'CHAMP 1 — Évaluation et admission en soins critiques (Réf. R1.2.1)'),
  ('MG-ANES-000036-R03', 'Réaliser le plus rapidement possible : bilan hépatique (ASAT, ALAT, γGT, PAL, bilirubine), triglycéridémie, calcémie et échographie abdominale, pour préciser le diagnostic étiologique.', '1+', 'CHAMP 1 — Évaluation et admission en soins critiques (Réf. R1.2.2)'),
  ('MG-ANES-000036-R04', 'Chez le patient ventilé de façon invasive : monitorer la pression intra-abdominale pour diagnostiquer et traiter précocement une hypertension intra-abdominale (retrouvée chez plus de la moitié des patients, facteur de mortalité indépendant).', '1+', 'CHAMP 1 — Évaluation et admission en soins critiques (Réf. R1.3)'),
  ('MG-ANES-000036-R05', 'Ne pas utiliser systématiquement une stratégie de remplissage vasculaire massif (3-5 mL/kg/h pendant les premières 24 h) : pas de bénéfice démontré sur la mortalité, et risque accru d''insuffisance rénale aigüe (méta-analyse, RR 2,17).', '2-', 'CHAMP 2 — Prise en charge à la phase initiale (Réf. R2.1)'),
  ('MG-ANES-000036-R06', 'Ne pas utiliser de probiotiques par voie entérale pour réduire la mortalité ou les pneumonies associées aux soins (l''unique essai randomisé disponible montre une surmortalité et un excès d''ischémie mésentérique sous probiotiques).', '2-', 'CHAMP 2 — Prise en charge à la phase initiale (Réf. R2.2)'),
  ('MG-ANES-000036-R07', 'Utiliser une nutrition entérale plutôt qu''une nutrition parentérale exclusive (réduction de mortalité démontrée par plusieurs méta-analyses, y compris dans les formes graves).', '1+', 'CHAMP 2 — Prise en charge à la phase initiale (Réf. R2.3)'),
  ('MG-ANES-000036-R08', 'Ne pas introduire systématiquement une nutrition entérale précoce (24-48 premières heures) dans le seul but de réduire la mortalité, les infections ou les défaillances d''organes — bénéfice non démontré sur ces critères pris isolément.', '1-', 'CHAMP 2 — Prise en charge à la phase initiale (Réf. R2.4)'),
  ('MG-ANES-000036-R09', 'Ne pas recourir en première intention à une sonde naso-jéjunale pour améliorer la tolérance de la nutrition entérale (pas de différence vs sonde naso-gastrique) ; réserver la voie jéjunale à l''impossibilité de la voie gastrique.', '1-', 'CHAMP 2 — Prise en charge à la phase initiale (Réf. R2.5)'),
  ('MG-ANES-000036-R10', 'Ne pas privilégier les mélanges semi-élémentaires/élémentaires, ni l''immunonutrition entérale, par rapport à une nutrition entérale polymérique standard.', '2-', 'CHAMP 2 — Prise en charge à la phase initiale (Réf. R2.6)'),
  ('MG-ANES-000036-R11', 'En cas d''intolérance avérée ou de contre-indication à la nutrition entérale : ajouter de la glutamine IV (0,20 g/kg/j de L-glutamine) à la nutrition parentérale.', '2+', 'CHAMP 2 — Prise en charge à la phase initiale (Réf. R2.7)'),
  ('MG-ANES-000036-R12', 'Ne pas utiliser d''antioxydants en complément de la nutrition entérale ou parentérale.', '2-', 'CHAMP 2 — Prise en charge à la phase initiale (Réf. R2.8)'),
  ('MG-ANES-000036-R13', 'Pancréatite biliaire : ne réaliser une CPRE en urgence que chez les patients avec angiocholite associée — pas de bénéfice démontré d''une CPRE systématique en l''absence d''angiocholite (essai APEC notamment).', '1+', 'CHAMP 2 — Prise en charge à la phase initiale (Réf. R2.9)'),
  ('MG-ANES-000036-R14', 'Ne pas utiliser de thérapeutique médicamenteuse non conventionnelle (aucune des nombreuses molécules testées — aprotinine, gabexate, octréotide, somatostatine, lexipafant, etc. — ne réduit la mortalité).', '2-', 'CHAMP 2 — Prise en charge à la phase initiale (Réf. R2.10)'),
  ('MG-ANES-000036-R15', 'Pancréatite hypertriglycéridémique en échec du traitement médical de 1re intention (fibrate, héparine + insuline) : envisager des échanges plasmatiques pour réduire rapidement une hypertriglycéridémie sévère (>11,3 mmol/L) ou très sévère (>22,4 mmol/L), objectif <5,7 mmol/L.', 'AE', 'CHAMP 2 — Prise en charge à la phase initiale (Réf. R2.11)'),
  ('MG-ANES-000036-R16', 'Ne pas administrer de traitement anti-infectieux intraveineux préventif en l''absence d''infection documentée : pas de réduction démontrée de la mortalité, des infections de coulées de nécrose ni des infections extra-pancréatiques.', '2-', 'CHAMP 3 — Prise en charge des complications évolutives (Réf. R3.1)'),
  ('MG-ANES-000036-R17', 'Ne pas se limiter à l''examen clinique et à la CRP : s''appuyer aussi sur la procalcitonine et la tomodensitométrie abdominale (air extra-digestif intra/extra-pancréatique) pour établir le diagnostic.', '2+', 'CHAMP 3 — Prise en charge des complications évolutives (Réf. R3.2)'),
  ('MG-ANES-000036-R18', 'Ne pas réaliser de ponction à l''aiguille fine pour le diagnostic d''infection de nécrose en l''absence de signes cliniques de sepsis et/ou de scanner évocateur de surinfection (faux négatifs 20-25 %, risque de complications iatrogènes).', 'AE', 'CHAMP 3 — Prise en charge des complications évolutives (Réf. R3.3)'),
  ('MG-ANES-000036-R19', 'Nécrose pancréatique infectée : réaliser un drainage, et ne pas se limiter à une antibiothérapie systémique seule.', '2+', 'CHAMP 3 — Prise en charge des complications évolutives (Réf. R3.4)'),
  ('MG-ANES-000036-R20', 'Privilégier en première intention une approche graduée « mini-invasive » (endoscopique et/ou radiologique percutanée) pour le drainage, selon l''expertise locale et la localisation des coulées de nécrose.', '1+', 'CHAMP 3 — Prise en charge des complications évolutives (Réf. R3.5.1)'),
  ('MG-ANES-000036-R21', 'En l''absence d''équipe d''endoscopie et/ou de radiologie interventionnelle entraînée localement au drainage mini-invasif : transférer le patient vers un centre expert.', 'AE', 'CHAMP 3 — Prise en charge des complications évolutives (Réf. R3.5.2)'),
  ('MG-ANES-000036-R22', 'Infection de coulée de nécrose : administrer une antibiothérapie probabiliste ciblant les entérobactéries résistantes, Enterococcus faecium, Pseudomonas aeruginosa et les levures (surinfections fongiques ≈30 % des cas).', '2+', 'CHAMP 3 — Prise en charge des complications évolutives (Réf. R3.6.1)'),
  ('MG-ANES-000036-R23', 'Adapter secondairement l''antibiothérapie aux résultats microbiologiques (ponction percutanée, écho-endoscopie, drainage chirurgical, hémocultures) après avis pluridisciplinaire réanimation/gastro-entérologie/infectiologie, pour réduire le spectre et préserver l''écologie bactérienne.', 'AE', 'CHAMP 3 — Prise en charge des complications évolutives (Réf. R3.6.2)'),
  ('MG-ANES-000036-R24', 'Complication hémorragique viscérale (rupture de pseudo-anévrysme le plus souvent, mortalité 34-52 %) : privilégier en priorité une technique de radiologie interventionnelle endovasculaire (moindre surmortalité qu''une chirurgie de sauvetage : 13 % vs 29 % dans une étude rétrospective).', '2+', 'CHAMP 3 — Prise en charge des complications évolutives (Réf. R3.7)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/pancreatite-aigue-grave-du-patient-adulte-en-soins-critiques/'
on conflict (recommendation_code) do nothing;
