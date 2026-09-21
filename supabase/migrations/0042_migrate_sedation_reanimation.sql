-- Migration : Sédation et analgésie en réanimation (nouveau-né exclu) —
-- Conférence de Consensus SFAR-SRLF, Paris, 15 novembre 2007. Texte court
-- du jury, publié in Annales Françaises d'Anesthésie et de Réanimation
-- 2008;27:552-555 (doi:10.1016/j.annfar.2008.04.025). Source :
-- rfe-sfar-website/build/content_sedation_reanimation.json (45
-- recommandations réparties en 5 questions, particularités pédiatriques
-- entre crochets « [pédiatrie] », nouveau-né et analgésie postopératoire
-- explicitement exclus du champ).
--
-- NATURE DU DOCUMENT — disclosure : `library_final.json` classe ce
-- document `"exact_type": "RFE"`, mais le contenu construit précise
-- lui-même qu'il s'agit d'une CONFÉRENCE DE CONSENSUS (CC), pas d'une RFE
-- au sens usuel du corpus — divergence disclosée, non résolue (`doc_type`
-- renseigné 'CC' ici, conforme au texte source, pas à la classification de
-- l'index).
--
-- MÉTHODOLOGIE — GRADES DÉDUITS, PAS IMPRIMÉS INDIVIDUELLEMENT :
-- particularité méthodologique disclosée explicitement par la source
-- elle-même — AUCUN tag GRADE n'est imprimé à côté de chaque
-- recommandation dans le texte source. Le jury énonce en préambule une
-- CONVENTION DE FORMULATION explicite : « il faut faire »/« il ne faut pas
-- faire » = recommandation forte (1+/1-) ; « il faut probablement »/« il
-- ne faut probablement pas » = recommandation optionnelle (2+/2-) ; une
-- formulation plus libre (« il est proposé », « peut être utilisé », un
-- simple constat) = AE (proposition/avis non formellement gradée). Le
-- contenu construit applique CETTE CONVENTION EXPLICITEMENT ÉNONCÉE PAR LE
-- JURY LUI-MÊME (pas une inférence visuelle non sourcée comme le "+" de
-- lat_soins_critiques/0031) pour dériver le chip de chaque énoncé — chip
-- reproduit ici tel que déjà calculé par le contenu construit, disclosure
-- de la méthode de dérivation conservée. `evidence_level` laissé NULL.
--
-- COMPTAGE : 45 recommandations, réparties 26×1+, 8×1-, 6×2+, 0×2-, 5×AE
-- (inventaire direct programmatique, tables "Thème/Recommandation
-- (formulation du jury)/Grade" des 5 questions). Le contenu construit ne
-- publie PAS de total officiel agrégé pour ce document — rien à
-- réconcilier, comptage direct retenu tel quel.
--
-- PÉRIMÈTRE — volontairement pas migrés : Tableau 2 (agents de la
-- sédation, posologies par médicament — référence pharmacologique, pas de
-- grade individuel) ; Tableau 3 (morphiniques, posologies — idem) ;
-- l'algorithme de la Question 5 (transcrit depuis une image pure de la
-- page 4/555 du document source, sans calque de texte extractible, sans
-- chip de grade individuel par étape — disclosure du contenu construit
-- lui-même).
--
-- POPULATION : 5 recommandations portent un marqueur pédiatrique explicite
-- dans la source ("[Pédiatrie]"/"[pédiatrie]") — taguées `population =
-- 'Pédiatrie'` ; le reste laissé NULL (nouveau-né exclu du champ, reste
-- adulte/enfant mêlé sans marqueur individuel).
--
-- FRAÎCHEUR — disclosure explicite de la source elle-même, reproduite :
-- « Document ancien (2007/2008) — les pratiques de sédation-analgésie en
-- réanimation ont évolué depuis (échelles, molécules) ; en cas de doute,
-- se référer au texte intégral, aux mises à jour ultérieures et/ou à un
-- avis spécialisé. » — `freshness_status = 'revision_detectee'` retenu en
-- conséquence (même pattern que eclsa/0019, glycemie/0022, hsa/0023,
-- mal_epileptique/0032 — CONTRAIREMENT à securisation_proc/0041, qui elle
-- ne portait aucune disclosure de ce type), malgré `library_final.json`
-- "en vigueur".
--
-- DATE — divergence mineure disclosée : la conférence s'est tenue le 15
-- novembre 2007 (date précise citée par la source elle-même), mais
-- `library_final.json` indique `exact_date: "2008"` (probablement l'année
-- de publication de l'article AFAR plutôt que la date de la conférence) —
-- date de la conférence retenue (`publication_date = '2007-11-15'`), plus
-- précise et directement sourcée.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SFAR et SRLF (toutes deux dans le seed Annexe B, co-organisatrices de
--    la Conférence de Consensus) liées en document_societies.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Sédation et analgésie en réanimation (nouveau-né exclu)',
  'CC', 'fr', '2007-11-15',
  'https://sfar.org/sedation-et-analgesie-en-reanimation-nouveau-ne-exclu/',
  'https://sfar.org/wp-content/uploads/2015/10/2a_AFAR_Texte_court_Sedation-et-analgesie-en-reanimation_nouveau-ne-exclu.pdf',
  'GRADE, SANS tag imprimé individuellement par recommandation dans le texte source : chip dérivé de la convention de formulation explicite du jury (« il faut faire »/« il ne faut pas faire » = 1+/1- ; « il faut probablement »/« il ne faut probablement pas » = 2+/2- ; formulation plus libre = AE). 45 recommandations (26×1+, 8×1-, 6×2+, 5×AE), comptage direct sans total officiel source à réconcilier. Document ancien (Conférence de Consensus 2007/2008) : la source elle-même avertit que les pratiques ont évolué depuis (échelles, molécules).',
  'revision_detectee'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/sedation-et-analgesie-en-reanimation-nouveau-ne-exclu/'
  and s.acronym in ('SFAR', 'SRLF') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/sedation-et-analgesie-en-reanimation-nouveau-ne-exclu/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.source_section,
  'https://sfar.org/sedation-et-analgesie-en-reanimation-nouveau-ne-exclu/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000042-R01', 'Il faut éviter une sédation-analgésie insuffisante ou excessive.', '1+', null, 'Question 1 — Définitions et buts de la sédation-analgésie (Objectifs) [Réf. 1]'),
  ('MG-ANES-000042-R02', 'Il faut promouvoir les moyens non médicamenteux — l''organisation du service doit prendre en compte l''environnement thermique, lumineux et sonore, et le sommeil.', '1+', null, 'Question 2 (1/3) — Moyens non médicamenteux (Moyens non médicamenteux) [Réf. 2]'),
  ('MG-ANES-000042-R03', 'Il faut limiter la douleur induite par les soins.', '1+', null, 'Question 2 (1/3) — Moyens non médicamenteux (Douleur induite par les soins) [Réf. 3]'),
  ('MG-ANES-000042-R04', 'Il faut encourager les programmes d''éducation et d''assistance parentale.', '1+', 'Pédiatrie', 'Question 2 (1/3) — Moyens non médicamenteux ([Pédiatrie]) [Réf. 4]'),
  ('MG-ANES-000042-R05', 'Chez les patients dont l''hémodynamique est instable, il faut toujours diminuer les doses des agents de sédation.', '1+', null, 'Question 2 (2/3) — Moyens médicamenteux : hypnotiques (Hémodynamique instable) [Réf. 5]'),
  ('MG-ANES-000042-R06', 'Chez les patients dont l''hémodynamique est instable, il ne faut pas utiliser le nesdonal (thiopental) ou le propofol.', '1-', null, 'Question 2 (2/3) — Moyens médicamenteux : hypnotiques (Hémodynamique instable) [Réf. 6]'),
  ('MG-ANES-000042-R07', 'Si le propofol est utilisé, il faut limiter l''administration à une durée inférieure à 48 heures et à des doses inférieures à 5 mg/kg/h, et dépister la survenue du « propofol infusion syndrome » (PRIS), qui engage le pronostic vital.', '1+', null, 'Question 2 (2/3) — Moyens médicamenteux : hypnotiques (Propofol) [Réf. 7]'),
  ('MG-ANES-000042-R08', 'Le propofol est contre-indiqué en sédation continue chez l''enfant de moins de 15 ans.', '1-', 'Pédiatrie', 'Question 2 (2/3) — Moyens médicamenteux : hypnotiques (Propofol [pédiatrie]) [Réf. 8]'),
  ('MG-ANES-000042-R09', 'Pour le midazolam, si un effet plateau est constaté, il ne faut pas poursuivre l''augmentation des doses.', '1-', null, 'Question 2 (2/3) — Moyens médicamenteux : hypnotiques (Midazolam) [Réf. 9]'),
  ('MG-ANES-000042-R10', 'L''étomidate ne doit pas être utilisé pour la sédation-analgésie en réanimation.', '1-', null, 'Question 2 (2/3) — Moyens médicamenteux : hypnotiques (Étomidate) [Réf. 10]'),
  ('MG-ANES-000042-R11', 'Le nesdonal ne doit être utilisé qu''en cas d''hypertension intracrânienne (HTIC) ou d''état de mal épileptique, après échec du traitement initial.', 'AE', null, 'Question 2 (2/3) — Moyens médicamenteux : hypnotiques (Thiopental (Nesdonal)) [Réf. 11]'),
  ('MG-ANES-000042-R12', 'Il faut probablement utiliser un neuroleptique dans les états confuso-délirants, l''agitation, les orages neurovégétatifs et les syndromes de sevrage.', '2+', null, 'Question 2 (2/3) — Moyens médicamenteux : hypnotiques (Neuroleptiques) [Réf. 12]'),
  ('MG-ANES-000042-R13', 'Il faut probablement utiliser la clonidine lors du sevrage et des orages neurovégétatifs.', '2+', null, 'Question 2 (2/3) — Moyens médicamenteux : hypnotiques (Clonidine) [Réf. 13]'),
  ('MG-ANES-000042-R14', 'En administration continue, il faut utiliser la morphine, le fentanyl ou le sufentanil.', '1+', null, 'Question 2 (3/3) — Analgésiques & curares (Morphiniques) [Réf. 14]'),
  ('MG-ANES-000042-R15', 'Si l''on utilise le rémifentanil, il faut évaluer son rapport bénéfice/risque et respecter scrupuleusement les recommandations d''administration.', '1+', null, 'Question 2 (3/3) — Analgésiques & curares (Rémifentanil) [Réf. 15]'),
  ('MG-ANES-000042-R16', 'Pour des gestes douloureux, il faut administrer un bolus du morphinique en cours, en tenant compte de son délai d''action.', '1+', null, 'Question 2 (3/3) — Analgésiques & curares (Gestes douloureux) [Réf. 16]'),
  ('MG-ANES-000042-R17', 'Il ne faut pas faire de bolus de rémifentanil.', '1-', null, 'Question 2 (3/3) — Analgésiques & curares (Rémifentanil) [Réf. 17]'),
  ('MG-ANES-000042-R18', 'Il ne faut pas utiliser les anti-inflammatoires non stéroïdiens (AINS) dans cette indication en réanimation.', '1-', null, 'Question 2 (3/3) — Analgésiques & curares (AINS) [Réf. 18]'),
  ('MG-ANES-000042-R19', 'La kétamine ne doit pas être utilisée seule comme hypnotique.', '1-', null, 'Question 2 (3/3) — Analgésiques & curares (Kétamine) [Réf. 19]'),
  ('MG-ANES-000042-R20', 'Il faut probablement utiliser la kétamine en réanimation pour ses propriétés antihyperalgésiques, son respect de la motricité intestinale et de l''hémodynamique.', '2+', null, 'Question 2 (3/3) — Analgésiques & curares (Kétamine) [Réf. 20]'),
  ('MG-ANES-000042-R21', 'Il faut utiliser l''Emla lors de toute effraction cutanée chez l''enfant.', '1+', 'Pédiatrie', 'Question 2 (3/3) — Analgésiques & curares (Emla [pédiatrie]) [Réf. 21]'),
  ('MG-ANES-000042-R22', 'Le protoxyde d''azote peut être utilisé pour la sédation-analgésie au cours des soins douloureux.', 'AE', null, 'Question 2 (3/3) — Analgésiques & curares (Protoxyde d''azote) [Réf. 22]'),
  ('MG-ANES-000042-R23', 'Il ne faut pas administrer les curares stéroïdiens en continu.', '1-', null, 'Question 2 (3/3) — Analgésiques & curares (Curares stéroïdiens) [Réf. 23]'),
  ('MG-ANES-000042-R24', 'En perfusion continue, il faut probablement utiliser le cisatracurium.', '2+', null, 'Question 2 (3/3) — Analgésiques & curares (Cisatracurium) [Réf. 24]'),
  ('MG-ANES-000042-R25', 'Il faut évaluer la sédation-analgésie du patient en réanimation, définir les besoins en analgésiques et sédatifs, s''assurer de l''adéquation entre la réponse au traitement et les besoins prédéfinis, et réévaluer régulièrement les besoins.', '1+', null, 'Question 3 — Outils et impact de l''évaluation (Principe) [Réf. 25]'),
  ('MG-ANES-000042-R26', 'Il faut au moins évaluer l''analgésie et la conscience (l''évaluation complète couvre aussi le confort, l''anxiété, l''agitation et l''adaptation au ventilateur).', '1+', null, 'Question 3 — Outils et impact de l''évaluation (Champ couvert) [Réf. 26]'),
  ('MG-ANES-000042-R27', 'Il faut assurer la traçabilité de l''évaluation et élaborer une procédure d''évaluation en concertation multiprofessionnelle, réalisée à intervalles réguliers, après toute modification du traitement et lors des stimulations douloureuses.', '1+', null, 'Question 3 — Outils et impact de l''évaluation (Traçabilité) [Réf. 27]'),
  ('MG-ANES-000042-R28', 'Chez le patient vigile et coopérant, et l''enfant de plus de 5-6 ans, il faut utiliser l''EVA (échelle visuelle analogique).', '1+', null, 'Question 3 — Outils et impact de l''évaluation (Douleur — patient vigile) [Réf. 28]'),
  ('MG-ANES-000042-R29', 'Chez le patient inconscient ou incapable de communiquer, il faut utiliser l''échelle BPS (Behavioral Pain Scale) ou l''échelle ATICE ; chez l''enfant, l''échelle COMFORT B.', '1+', null, 'Question 3 — Outils et impact de l''évaluation (Douleur — patient inconscient) [Réf. 29]'),
  ('MG-ANES-000042-R30', 'Pour l''évaluation de la conscience, il faut utiliser l''une des échelles suivantes : Ramsay, RASS ou ATICE ; chez l''enfant, COMFORT B.', '1+', null, 'Question 3 — Outils et impact de l''évaluation (Conscience) [Réf. 30]'),
  ('MG-ANES-000042-R31', 'Il est proposé d''évaluer la profondeur de la sédation par l''analyse de l''index bispectral quand les échelles ne peuvent plus détecter une sédation inadaptée (curarisation, coma barbiturique).', 'AE', null, 'Question 3 — Outils et impact de l''évaluation (Index bispectral (BIS)) [Réf. 31]'),
  ('MG-ANES-000042-R32', 'Si une curarisation est utilisée, il faut surveiller régulièrement sa profondeur par la réponse au train de quatre du muscle sourcilier (objectif : deux réponses), à l''état stable et après toute modification de dose.', '1+', null, 'Question 3 — Outils et impact de l''évaluation (Curarisation) [Réf. 32]'),
  ('MG-ANES-000042-R33', 'Il faut évaluer la profondeur de la sédation-analgésie pendant toute la durée de la curarisation, au cours d''une fenêtre quotidienne de décurarisation.', '1+', null, 'Question 3 — Outils et impact de l''évaluation (Curarisation) [Réf. 33]'),
  ('MG-ANES-000042-R34', 'Si l''évaluation par fenêtre quotidienne de décurarisation est impossible, il est proposé d''utiliser l''index bispectral.', 'AE', null, 'Question 3 — Outils et impact de l''évaluation (Curarisation) [Réf. 34]'),
  ('MG-ANES-000042-R35', 'Il faut rechercher les facteurs de risque de syndrome de sevrage et dépister la survenue d''un état confuso-délirant.', '1+', null, 'Question 3 — Outils et impact de l''évaluation (Sevrage / confusion) [Réf. 35]'),
  ('MG-ANES-000042-R36', 'Il faut probablement recueillir l''avis du patient au décours du séjour en réanimation et dépister le syndrome de stress post-traumatique.', '2+', null, 'Question 3 — Outils et impact de l''évaluation (Suivi post-réanimation) [Réf. 36]'),
  ('MG-ANES-000042-R37', 'Il faut que les objectifs de sédation-analgésie soient constamment adaptés à l''évolution de la pathologie causale ; lorsque la situation est contrôlée voire résolue, il faut systématiquement envisager l''allègement progressif puis l''arrêt de la sédation-analgésie.', '1+', null, 'Question 4 — Arrêt de la sédation-analgésie & syndrome de sevrage (Quand arrêter) [Réf. 37]'),
  ('MG-ANES-000042-R38', 'Il faut une surveillance accrue lors de la décroissance de la sédation-analgésie, avec prise en compte des caractéristiques pharmacocinétiques des médicaments utilisés.', '1+', null, 'Question 4 — Arrêt de la sédation-analgésie & syndrome de sevrage (Comment arrêter) [Réf. 38]'),
  ('MG-ANES-000042-R39', 'Il faut probablement diminuer de façon progressive les posologies des morphiniques et des hypnotiques, plutôt que de les arrêter brutalement.', '2+', null, 'Question 4 — Arrêt de la sédation-analgésie & syndrome de sevrage (Comment arrêter) [Réf. 39]'),
  ('MG-ANES-000042-R40', 'Il faut que la curarisation soit la plus courte possible et que son arrêt soit envisagé dès son instauration.', '1+', null, 'Question 4 — Arrêt de la sédation-analgésie & syndrome de sevrage (Curarisation) [Réf. 40]'),
  ('MG-ANES-000042-R41', 'Il faut que le syndrome de sevrage soit prévenu, diagnostiqué et traité — à différencier de toute cause organique classique d''agitation aiguë. Son traitement fait appel à la réintroduction de la molécule estimée responsable, ainsi qu''aux neuroleptiques et/ou aux alpha-agonistes.', '1+', null, 'Question 4 — Arrêt de la sédation-analgésie & syndrome de sevrage (Syndrome de sevrage) [Réf. 41]'),
  ('MG-ANES-000042-R42', 'Chez l''enfant, il faut rechercher des signes de syndrome de sevrage.', '1+', 'Pédiatrie', 'Question 4 — Arrêt de la sédation-analgésie & syndrome de sevrage (Sevrage [pédiatrie]) [Réf. 42]'),
  ('MG-ANES-000042-R43', 'La substitution par méthadone est probablement une alternative à la réintroduction du morphinique dans le cadre de la prise en charge du syndrome de sevrage.', 'AE', 'Pédiatrie', 'Question 4 — Arrêt de la sédation-analgésie & syndrome de sevrage (Sevrage [pédiatrie]) [Réf. 43]'),
  ('MG-ANES-000042-R44', 'Il faut une procédure écrite prévoyant l''évaluation et l''adaptation des doses de sédation-analgésie.', '1+', null, 'Question 5 — Conduite pratique de la sédation-analgésie (Procédure écrite) [Réf. 44]'),
  ('MG-ANES-000042-R45', 'Il faut définir pour chaque patient les objectifs de sédation-analgésie.', '1+', null, 'Question 5 — Conduite pratique de la sédation-analgésie (Objectifs individualisés) [Réf. 45]')) as v(code, statement, grade, population, source_section)
where d.source_url = 'https://sfar.org/sedation-et-analgesie-en-reanimation-nouveau-ne-exclu/'
on conflict (recommendation_code) do nothing;
