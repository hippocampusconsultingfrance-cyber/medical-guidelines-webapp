-- Migration : Insuffisance hépatique en soins critiques (Liver failure in intensive care
-- unit) — Recommandations Formalisées d'Experts (RFE) commune SFAR et AFEF (Association
-- Française pour l'Étude du Foie). Prise en charge de première ligne, pour un public large
-- de réanimateurs — ne détaille pas les mesures spécifiques des unités de transplantation
-- hépatique. Population pédiatrique exclue du champ. Source :
-- rfe-sfar-website/build/content_ih.json (19 recommandations, 2 champs : IHA et ACLF).
--
-- MÉTHODOLOGIE : GRADE classique (force forte 1+/1-, force faible 2+/2-, avis d'experts AE),
-- méthode GRADE grid (validation d'une recommandation si ≥ 50 % des experts convergent et
-- < 20 % s'y opposent). `grade` reproduit tel quel le chip source. `evidence_level` laissé
-- NULL. Après deux tours de cotation, un accord fort a été obtenu pour 100 % des
-- recommandations — aucune exception « Accord Faible » à signaler pour ce document
-- (contrairement à `hypothermie`/0025 ou `glycemie`/0022).
--
-- DEUX INCOHÉRENCES SOURCE-INTERNES, DISCLOSÉES TELLES QUELLES, NON RÉSOLUES
-- SILENCIEUSEMENT (principe 1.5 du projet) :
-- 1. Nombre d'experts : le résumé de la source annonce « 23 experts francophones » (confirmé
--    par un comptage direct des listes nominatives par le contenu construit), mais
--    l'introduction du même document affirme séparément « vingt » experts — incohérence
--    interne à la source, non reconciliée ici, reproduite dans `grading_system` ci-dessous.
-- 2. Nombre de recommandations : le résumé de la source annonce « 18 recommandations », mais
--    sa PROPRE répartition par grade imprimée dans le même résumé (6 Grade 1 + 7 Grade 2 +
--    6 avis d'experts = 19) correspond exactement à un comptage direct des 19 items
--    numérotés du texte (R1 à R10, avec sous-numéros) — 19 est donc le total correct
--    d'après la source elle-même, "18" étant une coquille de son propre résumé. Les 19
--    recommandations sont migrées ci-dessous ; comptage vérifié par grade : 1+ ×6, 2+ ×6 +
--    2- ×1 = 7 Grade 2, AE ×6 = 6+7+6=19, exactement conforme à la répartition annoncée par
--    la source elle-même.
--
-- PÉRIMÈTRE — volontairement pas migrés (référence/algorithme/score de classification, pas
-- des recommandations individuellement graduées, cohérent avec le principe déjà appliqué
-- ailleurs dans ce corpus) :
-- 1. TABLEAU 1 — "Système | Ce qu'il faut faire | Ce qu'il ne faut pas faire" (prise en
--    charge symptomatique des défaillances d'organe extrahépatiques au cours de l'IHA
--    sévère) — référencé par R3 mais son contenu détaillé par système n'est pas gradué
--    individuellement par le jury.
-- 2. FIGURE 1 — "Étape | Contenu" (prise en charge spécifique de l'IHA sévère, TP < 50 %) —
--    algorithme de synthèse, pas une recommandation graduée en soi.
-- 3. TABLEAU 2 — "Élément | Définition" (classification KDIGO modifiée de l'IRA chez le
--    cirrhotique) et FIGURE 2 (algorithme de prise en charge de l'IRA du cirrhotique par
--    stade KDIGO) — référencés par R5.1 mais reproduisant un système de classification
--    établi (KDIGO modifié), pas des recommandations individuellement graduées.
-- 4. TABLEAU 3 — définition du syndrome hépatorénal (SHR, critères diagnostiques) —
--    définition clinique de référence, pas une recommandation graduée.
-- 5. Annexes CLIF-SOFA (score par organe/système) et Grade ACLF (définitions à partir du
--    CLIF-SOFA) — échelles de score de référence utilisées dans l'argumentaire des
--    questions 4 et 10, pas des recommandations individuellement graduées par le jury.
-- Ces 5 tableaux/figures de référence, cliniquement précieux, restent entièrement
-- reproduits dans la fiche de synthèse elle-même — simplement pas migrés comme des lignes
-- `recommendations` individuellement graduées.
--
-- Également volontairement pas migré : la sous-question de thromboprophylaxie médicamenteuse
-- (Question 9), pour laquelle les experts déclarent explicitement ne pas être en mesure de
-- formuler de recommandation après analyse de la littérature (niveau de preuve bas, études
-- hétérogènes) — cohérent avec le principe de ne jamais migrer une absence de recommandation
-- comme une ligne graduée.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. AFEF (Association Française pour l'Étude du Foie), co-organisatrice de cette RFE au
--    même titre que la SFAR, n'a pas d'entrée correspondante dans le seed Annexe B de
--    schema_v2.sql — seule la SFAR est liée en document_societies, à compléter par un
--    relecteur humain si le seed est étendu.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Insuffisance hépatique en soins critiques',
  'RFE', 'fr', '2018-09-29',
  'https://sfar.org/insuffisance-hepatique-en-soins-critiques/',
  'https://sfar.org/wp-content/uploads/2018/09/RFE-IH-soins-critiques.pdf',
  'GRADE® grid (force forte 1+/1- ou faible 2+/2- ; avis d''experts AE), validation si ≥ 50 % des experts convergent et < 20 % s''y opposent. Accord fort obtenu pour 100 % des recommandations après 2 tours de cotation. Deux incohérences internes à la source disclosées, non reconciliées : nombre d''experts ("23" au résumé vs "vingt" en introduction) et nombre de recommandations ("18" au résumé texte vs 19 confirmé par la propre répartition par grade du résumé, 6+7+6=19, et par comptage direct des items numérotés).',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/insuffisance-hepatique-en-soins-critiques/'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/insuffisance-hepatique-en-soins-critiques/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'gastro_enterologie_et_hepatologie', 'nephrologie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/insuffisance-hepatique-en-soins-critiques/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000026-R01', 'Chez les patients présentant une IHA sévère, il est recommandé d''effectuer le dosage sanguin du paracétamol, les sérologies virales A (IgM VHA) et B (Ag HBs, IgM HBc), la recherche urinaire de toxiques (amphétamine, cocaïne), une échographie cardiaque, et une écho-Doppler hépatique.', '1+', 'Champ 1 — Insuffisance hépatique aiguë (IHA) (Réf. R1)'),
  ('MG-ANES-000026-R02', 'En cas d''IHA, lorsqu''une intoxication au paracétamol est suspectée, il est recommandé d''instaurer un traitement par N-acétylcystéine sans attendre le résultat du dosage sanguin du paracétamol et quelle que soit sa valeur.', '1+', 'Champ 1 — Insuffisance hépatique aiguë (IHA) (Réf. R2.1)'),
  ('MG-ANES-000026-R03', 'En cas d''IHA sévère, quelle que soit l''étiologie suspectée, il est probablement recommandé d''instaurer un traitement par N-acétylcystéine afin de diminuer la morbi-mortalité.', '2+', 'Champ 1 — Insuffisance hépatique aiguë (IHA) (Réf. R2.2)'),
  ('MG-ANES-000026-R04', 'En cas d''IHA sévère, quelle que soit l''étiologie suspectée, les experts suggèrent de prendre contact avec un centre de transplantation hépatique pour discuter du bilan étiologique de seconde intention (si le bilan initial est négatif) et de l''indication de transplantation.', 'AE', 'Champ 1 — Insuffisance hépatique aiguë (IHA) (Réf. R2.3)'),
  ('MG-ANES-000026-R05', 'Afin de diminuer la morbi-mortalité des patients présentant une IHA sévère, les experts suggèrent de traiter précocement la survenue des défaillances d''organes autres que la défaillance hépatique et d''éviter tout facteur aggravant, selon le tableau proposé (Tableau 1).', 'AE', 'Champ 1 — Insuffisance hépatique aiguë (IHA) (Réf. R3)'),
  ('MG-ANES-000026-R06', 'Il n''est probablement pas recommandé de refuser d''admettre les patients cirrhotiques en soins critiques, du fait de leur seule maladie cirrhotique.', '2-', 'Champ 2 — Insuffisance hépatique sur foie cirrhotique (ACLF) (Réf. R4)'),
  ('MG-ANES-000026-R07', 'Afin de définir et d''évaluer la sévérité de l''insuffisance rénale aiguë (IRA) chez les patients cirrhotiques, les experts suggèrent : d''utiliser la classification KDIGO modifiée pour ces patients (Tableau 2) ; de traiter l''IRA selon son stade de gravité et selon l''algorithme proposé (Figure 2) ; de ne pas contre-indiquer de principe une épuration extrarénale en cas d''IRA chez le patient cirrhotique du fait de sa seule pathologie cirrhotique.', 'AE', 'Champ 2 — Insuffisance hépatique sur foie cirrhotique (ACLF) (Réf. R5.1)'),
  ('MG-ANES-000026-R08', 'Il est probablement recommandé de traiter, chez les patients cirrhotiques hospitalisés en soins critiques, un syndrome hépatorénal (SHR) par un vasoconstricteur (terlipressine en première intention), en association avec de l''albumine.', '2+', 'Champ 2 — Insuffisance hépatique sur foie cirrhotique (ACLF) (Réf. R5.2)'),
  ('MG-ANES-000026-R09', 'Afin de diminuer la morbi-mortalité des patients cirrhotiques hospitalisés en unité de soins critiques, il est probablement recommandé, quels que soient les symptômes et la (les) défaillance(s) d''organe présentés, de rechercher systématiquement une infection (incluant le prélèvement du liquide d''ascite — polynucléaires neutrophiles > 250/mm³ définissant une infection) et de débuter précocement une antibiothérapie probabiliste ciblée sur le foyer suspecté et adaptée à l''écologie locale et à celle du patient.', '2+', 'Champ 2 — Insuffisance hépatique sur foie cirrhotique (ACLF) (Réf. R6)'),
  ('MG-ANES-000026-R10', 'Il est recommandé d''administrer de l''albumine concentrée chez le cirrhotique en soins critiques, en cas de paracentèse excédant 4 à 5 litres.', '1+', 'Champ 2 — Insuffisance hépatique sur foie cirrhotique (ACLF) (Réf. R7.1)'),
  ('MG-ANES-000026-R11', 'Il est probablement recommandé d''administrer de l''albumine concentrée chez le cirrhotique en soins critiques en cas d''infection spontanée du liquide d''ascite (ILA).', '2+', 'Champ 2 — Insuffisance hépatique sur foie cirrhotique (ACLF) (Réf. R7.2)'),
  ('MG-ANES-000026-R12', 'Chez les patients cirrhotiques, en cas d''hémorragie digestive, il est recommandé d''administrer le plus tôt possible un traitement vasoactif intraveineux par octréotide, somatostatine ou terlipressine, en association avec une antibiothérapie préventive.', '1+', 'Question 8 — Hémorragie digestive chez le cirrhotique (Réf. R8.1)'),
  ('MG-ANES-000026-R13', 'Chez les patients cirrhotiques, en cas d''hémorragie digestive, il est probablement recommandé d''administrer le plus tôt possible un traitement par inhibiteurs de la pompe à protons.', '2+', 'Question 8 — Hémorragie digestive chez le cirrhotique (Réf. R8.2)'),
  ('MG-ANES-000026-R14', 'Chez les patients cirrhotiques, en cas d''hémorragie digestive, il est recommandé de réaliser une endoscopie œsogastroduodénale dès que possible.', '1+', 'Question 8 — Hémorragie digestive chez le cirrhotique (Réf. R8.3)'),
  ('MG-ANES-000026-R15', 'Chez les patients cirrhotiques, en cas d''hémorragie digestive, il est recommandé d''adopter une stratégie transfusionnelle restrictive visant une hémoglobinémie comprise entre 7 et 8 g/dL.', '1+', 'Question 8 — Hémorragie digestive chez le cirrhotique (Réf. R8.4)'),
  ('MG-ANES-000026-R16', 'En cas de rupture de varices œsophagiennes ou œsogastriques chez un patient cirrhotique, il est probablement recommandé d''envisager un TIPS (shunt porto-cave intra-hépatique par voie transjugulaire) à l''aide d''une prothèse couverte, dans un délai de 24 à 72 heures, chez les patients avec un score Child-Pugh C < 14, ou un score Child-Pugh B ayant initialement présenté un saignement actif à l''endoscopie (prophylaxie secondaire par TIPS préemptif).', '2+', 'Question 8 — Hémorragie digestive chez le cirrhotique (Réf. R8.5)'),
  ('MG-ANES-000026-R17', 'En cas de rupture de varices œsophagiennes ou œsogastriques chez un patient cirrhotique, les experts suggèrent d''envisager un TIPS avec prothèse couverte, en urgence, en cas d''hémorragie réfractaire au traitement endoscopique (TIPS de sauvetage).', 'AE', 'Question 8 — Hémorragie digestive chez le cirrhotique (Réf. R8.6)'),
  ('MG-ANES-000026-R18', 'Avant la réalisation d''un geste invasif chez le patient cirrhotique, les experts suggèrent de ne pas administrer systématiquement, de manière préventive, du plasma, des plaquettes ou du fibrinogène pour limiter le saignement.', 'AE', 'Questions 9-10 — Hémostase et recours à un avis spécialisé (Réf. R9)'),
  ('MG-ANES-000026-R19', 'Les experts suggèrent de demander un avis spécialisé pour tout patient cirrhotique hospitalisé en soins critiques : (1) à l''admission si le patient est déjà inscrit sur liste de transplantation hépatique ; (2) pour discuter précocement de l''engagement thérapeutique selon le nombre de défaillances d''organes et leur évolution ; (3) pour discuter de l''intérêt d''une suppléance hépatique ; (4) à la sortie des soins critiques, pour organiser une prise en charge en hépatologie en vue d''une possible transplantation.', 'AE', 'Questions 9-10 — Hémostase et recours à un avis spécialisé (Réf. R10)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/insuffisance-hepatique-en-soins-critiques/'
on conflict (recommendation_code) do nothing;
