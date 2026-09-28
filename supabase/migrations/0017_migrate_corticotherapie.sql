-- Migration : Corticothérapie au cours du choc septique et du SDRA — SFAR (XXe Conférence de
-- Consensus, avec SPILF/SPLF/GFRUP, labellisée ANAES), 12 octobre 2000
-- Source : rfe-sfar-website/build/content_corticotherapie.json (18 recommandations
-- atomiques, cotation à DEUX AXES INDÉPENDANTS non-GRADE : niveau de recommandation (1/2/3)
-- et niveau de preuve bibliographique (a/b/c/d), imprimés par le jury comme un chip COMBINÉ
-- unique ("1a", "2a", "2b"...) ou parfois un seul des deux axes seul ("2" ou "a"), ou "N.C."
-- quand le texte source ne porte aucun code entre crochets (anomalie disclosée par le
-- contenu construit lui-même pour les Questions 4 et l'énoncé 5.5).
--
-- SPLIT DU CHIP COMPOSITE SOURCE (disclosure méthodologique, pas une invention) : contrairement
-- au "grade composite fabriqué" que le safety net de ce projet (grep '"[12][+-]/[12][+-]')
-- est censé empêcher (deux clauses DIFFÉRENTES fusionnées en un seul grade inventé), le chip
-- de cette source EST authentiquement composite pour UNE SEULE recommandation, sur deux axes
-- que la légende de la source elle-même nomme explicitement ("Niveau 1 + preuve a" etc.) —
-- il se décompose donc proprement, sans perte ni invention, sur les deux champs distincts du
-- schéma : la partie chiffrée (1/2/3) -> `grade`, la partie lettrée (a/b/c/d) -> `evidence_level`.
-- Quand un seul axe est imprimé ("2" seul ou "a" seul), seul le champ correspondant est
-- renseigné, l'autre reste NULL (jamais déduit). "N.C." -> les deux champs NULL.
--
-- Le contenu construit disclose lui-même deux points supplémentaires, reproduits sans
-- ré-argumentation : (a) aucune phrase de la Question 4 ne porte de code entre crochets dans
-- le texte source — chippée "N.C." plutôt qu'une cotation inventée ; (b) les énoncés 5.3
-- (preuve seule "a") et 5.4 (recommandation graduée "2b") sont deux phrases CONSÉCUTIVES du
-- texte source portant deux cotations distinctes, migrées en deux lignes séparées (R16/R17
-- ci-dessous) plutôt que fusionnées en un seul chip composite — 5.5 ne porte aucun code
-- (même anomalie qu'à la Question 4).
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SFAR (organisateur via le Bureau du Consensus) et SPILF ("Société de Pathologie
--    Infectieuse de Langue Française") liées en document_societies (toutes deux dans le
--    seed Annexe B). SPLF (Société de Pneumologie de Langue Française — distincte de SPILF
--    malgré la ressemblance d'acronyme) et GFRUP, également co-organisateurs, n'y figurent
--    pas — non liées.
-- 2. Document de 2000 (25 ans à la date de cette migration) : le contenu construit invite
--    lui-même à se référer "en complément" aux données plus récentes sur la corticothérapie
--    du choc septique — `freshness_status` reste 'a_jour' faute d'information de retrait
--    dans `library_final.json`, à vérifier par un relecteur humain avant publication.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Corticothérapie au cours du choc septique et du SDRA',
  'CC', 'fr', '2000-10-12',
  'https://sfar.org/wp-content/uploads/2015/09/2_SFAR_Corticotherapie-au-cours-du-choc-septique-et-du-SDRA.pdf',
  'https://sfar.org/wp-content/uploads/2015/09/2_SFAR_Corticotherapie-au-cours-du-choc-septique-et-du-SDRA.pdf',
  'Cotation à deux axes indépendants, non-GRADE : niveau de recommandation (1>2>3) et niveau de preuve bibliographique (a>b>c>d). Niveau "3" et preuve "d" définis par l''échelle mais non utilisés dans le corps du texte. "N.C." = non coté (aucun code entre crochets dans le texte source à cet endroit).',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/09/2_SFAR_Corticotherapie-au-cours-du-choc-septique-et-du-SDRA.pdf'
  and s.acronym in ('SFAR', 'SPILF') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/09/2_SFAR_Corticotherapie-au-cours-du-choc-septique-et-du-SDRA.pdf'
  and s.slug in ('medecine_intensive_reanimation', 'pneumologie', 'infectiologie_maladies_infectieuses_et_tropicales')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, evidence_level, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.evidence_level, v.source_section,
  'https://sfar.org/wp-content/uploads/2015/09/2_SFAR_Corticotherapie-au-cours-du-choc-septique-et-du-SDRA.pdf',
  'draft'
from public.documents d, (values
  ('MG-ANES-000017-R01', 'Les phénomènes des phases exsudative (phase 1) et de fibrose évoluée endo-alvéolaire/interstitielle (phase 3) du SDRA ne justifient pas de corticothérapie.', '1', 'a', 'Question 1 — Manifestations du SDRA accessibles à la corticothérapie (1.1)'),
  ('MG-ANES-000017-R02', 'La phase fibro-proliférative (à partir du 7e jour environ) ne justifie un traitement que dans deux situations : intensité excessive de la réponse, ou durée anormalement prolongée (« late ARDS »).', '2', 'a', 'Question 1 — Manifestations du SDRA accessibles à la corticothérapie (1.2)'),
  ('MG-ANES-000017-R03', 'Doser systématiquement la cortisolémie avant de débuter un traitement par GC, pour dépister les rares insuffisances surrénales (IS) absolues — seuil proposé par le jury faute de valeur validée : cortisolémie de base < 10 µg/dl (≈ 275 nmol/L).', '2', null, 'Question 2 — Conséquences surrénaliennes et vasculaires du choc septique (2.1)'),
  ('MG-ANES-000017-R04', 'Ne pas réaliser systématiquement de test au Synacthène (ACTH) : la réponse normale n''est pas clairement définie au cours du choc septique et son résultat n''influence pas la conduite thérapeutique.', null, null, 'Question 2 — Conséquences surrénaliennes et vasculaires du choc septique (2.2)'),
  ('MG-ANES-000017-R05', 'En cas d''urgence absolue (ex. purpura fulminans), débuter le traitement par GC sans attendre le dosage préalable de la cortisolémie.', null, null, 'Question 2 — Conséquences surrénaliennes et vasculaires du choc septique (2.3)'),
  ('MG-ANES-000017-R06', 'Il n''existe aucun bénéfice à un traitement précoce par GC au cours du SDRA (contrairement à leur administration en cas de fibroprolifération prolongée et/ou excessive).', null, 'a', 'Question 3 — Bénéfices attendus et risques de la corticothérapie (3.1)'),
  ('MG-ANES-000017-R07', 'Dans le choc septique, seule l''utilisation de faibles doses d''hydrocortisone est bénéfique : diminution attendue de la mortalité, amélioration hémodynamique (baisse de la fréquence cardiaque, hausse des résistances artérielles systémiques et de la pression artérielle moyenne) permettant un sevrage plus rapide des amines vasoactives.', null, 'a', 'Question 3 — Bénéfices attendus et risques de la corticothérapie (3.2)'),
  ('MG-ANES-000017-R08', 'Avant de débuter la corticothérapie (SDRA comme choc septique), rechercher systématiquement une infection ; en cas d''infection bactérienne, prescrire une antibiothérapie adaptée au moins 3 jours avant de débuter les GC.', '2', null, 'Question 3 — Bénéfices attendus et risques de la corticothérapie (3.3)'),
  ('MG-ANES-000017-R09', 'Surveiller la glycémie pendant toute la durée du traitement par GC (intolérance glucidique, en particulier chez l''enfant).', '2', null, 'Question 3 — Bénéfices attendus et risques de la corticothérapie (3.4)'),
  ('MG-ANES-000017-R10', 'Indication : choc septique de gravité particulière, nécessitant des doses élevées et/ou croissantes d''agents vaso-actifs du fait d''une hypotension persistante malgré un remplissage vasculaire jugé satisfaisant. Avant traitement : s''assurer du caractère approprié de l''antibiothérapie et de l''absence d''indication chirurgicale d''éradication d''un foyer infectieux — le traitement peut alors être instauré, y compris plusieurs jours après l''installation du choc.', null, null, 'Question 4 — Indications et modalités dans le choc septique (4.1)'),
  ('MG-ANES-000017-R11', 'Posologie : hémisuccinate d''hydrocortisone 200 à 300 mg/j, en perfusion continue ou répartis en 3–4 injections IV, après prélèvement pour dosage de cortisol (des inducteurs enzymatiques/substrats du cytochrome P3A4 peuvent modifier le taux sanguin). Chez l''enfant : 100 mg/m²/j en 4 injections/6h, dès que possible en cas de purpura fulminans.', null, null, 'Question 4 — Indications et modalités dans le choc septique (4.2)'),
  ('MG-ANES-000017-R12', 'Durée : au moins 5 jours en cas de réponse clinique, avec réduction progressive puis arrêt à la disparition des signes de choc (sauf exceptionnelles IS absolues). Au-delà de 72 h sans réponse hémodynamique (hausse de la PA, stabilisation/sevrage des vaso-actifs), arrêter le traitement.', null, null, 'Question 4 — Indications et modalités dans le choc septique (4.3)'),
  ('MG-ANES-000017-R13', 'Surveillance : glycémie, natrémie, kaliémie. La modification des signes systémiques d''inflammation sous GC peut masquer une surinfection.', null, null, 'Question 4 — Indications et modalités dans le choc septique (4.4)'),
  ('MG-ANES-000017-R14', 'Une corticothérapie n''est indiquée ni en prévention d''un SDRA, ni à la phase initiale de son évolution ; à ce stade, elle augmente l''incidence des infections et le taux de mortalité.', '1', 'a', 'Question 5 — Indications et modalités dans le SDRA (5.1)'),
  ('MG-ANES-000017-R15', 'Une corticothérapie peut se discuter à la phase fibro-proliférative, chez un nombre restreint de patients : SDRA évoluant depuis 7 jours au moins, avec LIS ≥ 2,5, sans amélioration malgré une prise en charge adéquate.', '2', 'a', 'Question 5 — Indications et modalités dans le SDRA (5.2)'),
  ('MG-ANES-000017-R16', 'Aucun marqueur biologique validé ne permet de poser l''indication des GC à ce stade.', null, 'a', 'Question 5 — Indications et modalités dans le SDRA (5.3)'),
  ('MG-ANES-000017-R17', 'Une biopsie pulmonaire systématique n''est pas justifiée avant l''instauration des GC (risques non négligeables et absence de bénéfice documenté).', '2', 'b', 'Question 5 — Indications et modalités dans le SDRA (5.4)'),
  ('MG-ANES-000017-R18', 'Posologie : méthylprednisolone (MP) 2 mg/kg/j en 4 injections IV, débutée entre le 7e et le 10e jour d''évolution du SDRA, poursuivie 3 à 4 semaines puis arrêtée progressivement (risque de rebond). Amélioration attendue entre le 5e et le 14e jour (clinique, LIS en baisse de plus d''1 point, régression des défaillances viscérales) ; recherche systématique d''une infection surajoutée pendant tout le traitement. Chez le nourrisson/l''enfant : protocole identique proposé, en l''absence de données spécifiques exploitables.', null, null, 'Question 5 — Indications et modalités dans le SDRA (5.5)')) as v(code, statement, grade, evidence_level, source_section)
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/09/2_SFAR_Corticotherapie-au-cours-du-choc-septique-et-du-SDRA.pdf'
on conflict (recommendation_code) do nothing;
