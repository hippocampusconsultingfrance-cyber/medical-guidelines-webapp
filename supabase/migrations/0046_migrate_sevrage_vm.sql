-- Migration : Sevrage de la ventilation mécanique (à l'exclusion du
-- nouveau-né et du réveil d'anesthésie) — XXIe Conférence de Consensus en
-- Réanimation et Médecine d'Urgence de la SRLF, avec la participation de la
-- SFAR, de la Société de Pneumologie de Langue Française et du GFRUP. Lyon,
-- 11 octobre 2001. Texte publié in Réanimation 2001;10:697-8. Source :
-- rfe-sfar-website/build/content_sevrage_vm.json.
--
-- CAS PARTICULIER DE CE CORPUS — MÉTHODOLOGIE À CROCHETS AMBIGUS, SANS
-- CHIP DE GRADE NULLE PART DANS LE DOCUMENT : le jury utilise le Society of
-- Critical Care Medicine Rating System (1997, distinct de GRADE, même
-- principe que civd/0015) — lettre de niveau de preuve (a>b>c>d) et,
-- parfois, un chiffre de niveau de recommandation (1>2>3), imprimés entre
-- crochets à la suite de chaque énoncé. **MAIS le texte source mêle, dans
-- les mêmes crochets, ces cotations preuve/force ET de simples renvois
-- bibliographiques numérotés SANS lettre** (32 occurrences sur 101 crochets
-- au total, vérifié par extraction exhaustive du contenu construit) —
-- rien ne permet de distinguer avec certitude un crochet numérique nu
-- ("[2]", "[3]") d'un renvoi bibliographique ordinaire ou d'une cotation de
-- niveau non accompagnée de sa lettre. **Le contenu construit a fait le
-- choix explicite de ne JAMAIS convertir aucun crochet en grade_chip et de
-- tous les reproduire tels quels, en texte inline, pour ne fabriquer
-- aucune cotation absente de la source** — cette migration respecte
-- INTÉGRALEMENT ce choix méthodologique déjà arbitré par le contenu
-- construit : `grade` et `evidence_level` laissés NULL sur TOUTES les
-- lignes migrées, sans tenter d'extraire sélectivement certains crochets
-- (ex. "[a, 1]" pour la VACI) qui semblent moins ambigus que d'autres — un
-- tri sélectif aurait réintroduit, de façon incohérente, l'interprétation
-- que le contenu construit a précisément choisi d'éviter pour l'ensemble
-- du document. Les crochets restent visibles, reproduits verbatim, à
-- l'intérieur du texte de chaque `statement` migré (ex. "...[c, 3]...").
--
-- ATOMISATION — PÉRIMÈTRE RESTREINT AUX 4 TABLEAUX THÉMATIQUES SOURCE,
-- DISCLOSURE EXPLICITE (pas une conversion mécanique, principe du projet) :
-- contrairement à la quasi-totalité du corpus, ce document ne délimite ses
-- positions du jury ni par des repères Rx.y numérotés, ni par des marqueurs
-- directifs systématiques ("il faut"/"il ne faut pas") — les Questions 1,
-- 2, 4 et 5 présentent 17 blocs thématiques structurés en tableaux
-- "Thème | Énoncé | Réf." (colonne Réf. toujours "—", jamais un
-- identifiant réel) ; ce sont ces 17 blocs qui sont migrés ici tels quels,
-- un bloc = une ligne (regroupement thématique déjà choisi par la source
-- elle-même, pas un découpage arbitraire de ma part). **En revanche, la
-- Question 3 (conduite de l'épreuve de VS) et les paragraphes d'ouverture
-- des Questions 1, 4 et 5 sont rédigés en PROSE CONTINUE, sans tableau ni
-- repère individuel** — ils contiennent des directives cliniques
-- individuellement importantes (ex. "la VACI allonge la durée du sevrage
-- et ne doit pas être proposée [a, 1]", "aucune corticothérapie
-- systématique n'est justifiée [a, 1]", durée de l'épreuve de VS,
-- modalités de surveillance) mais AUCUNE de ces phrases n'est délimitée
-- par la source comme un item atomique distinct au même titre que les 17
-- blocs des tableaux — NON migrées séparément ici, pour éviter un
-- découpage arbitraire et incohérent avec le traitement des 17 blocs
-- migrés. Disclosure explicite : une relecture éditoriale future pourrait
-- juger utile d'atomiser cette prose plus finement.
--
-- L'organigramme "Procédure de sevrage" (Figure 1, reconstruit par le
-- contenu construit depuis un rendu visuel à 150dpi, page source sans
-- texte extractible) volontairement pas migré (synthèse visuelle du
-- contenu déjà couvert par les tableaux, sans chip individuel).
--
-- POPULATION : le bloc "Patients pédiatriques" (Question 4) taggé
-- `population = 'Pédiatrie'` ; le reste (adulte par défaut, nouveau-né et
-- réveil d'anesthésie explicitement exclus du champ de la conférence)
-- laissé NULL.
--
-- FRAÎCHEUR — disclosure explicite de la source elle-même, reproduite :
-- « document de 2001... les pratiques de ventilation et de sevrage ont
-- évolué depuis 2001 (essais cliniques ultérieurs sur les protocoles de
-- sevrage automatisés, la VNI post-extubation, les indices prédictifs) » —
-- `freshness_status = 'revision_detectee'` retenu.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SRLF (organisatrice) et SFAR (participante, toutes deux dans le seed
--    Annexe B) liées en document_societies ; Société de Pneumologie de
--    Langue Française et GFRUP hors seed, non liées.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Sevrage de la ventilation mécanique (à l''exclusion du nouveau-né et du réveil d''anesthésie)',
  'CC', 'fr', '2001-10-11',
  'https://sfar.org/sevrage-de-la-ventilation-mecanique-2/',
  'https://sfar.org/wp-content/uploads/2015/10/2_SFAR_Sevrage-de-la-ventilation-mecanique.pdf',
  'Society of Critical Care Medicine Rating System (1997, non-GRADE) : lettre de niveau de preuve (a>b>c>d) et chiffre de niveau de recommandation (1>2>3) imprimés entre crochets, MAIS mêlés dans le même texte à de simples renvois bibliographiques numérotés sans lettre (32/101 crochets ambigus, vérifié par extraction exhaustive) — le contenu construit source a choisi de ne JAMAIS convertir aucun crochet en grade, reproduisant tous les crochets verbatim en texte inline. Cette migration respecte ce choix : grade et evidence_level laissés NULL sur toutes les lignes, cohérent avec l''absence de distinction possible entre cotation et référence bibliographique nue.',
  'revision_detectee'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/sevrage-de-la-ventilation-mecanique-2/'
  and s.acronym in ('SFAR', 'SRLF') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/sevrage-de-la-ventilation-mecanique-2/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'pneumologie', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.population, v.source_section,
  'https://sfar.org/sevrage-de-la-ventilation-mecanique-2/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000046-R01', 'Critères généraux de début de sevrage : absence de vasopresseur et d''inotrope, absence de sédation, réponse cohérente aux ordres simples [3]. Relèvent du bon sens clinique mais n''ont pas fait l''objet de travaux spécifiques [c, 3].', null, 'Question 1 — Quand débuter le sevrage de la VM ? (Critères généraux)'),
  ('MG-ANES-000046-R02', 'Critères respiratoires de début de sevrage : FiO2 ≤ 50 % et niveau de PEP ≤ 5 cmH2O [c, 3]. Le médecin peut s''affranchir d''un ou plusieurs de ces critères (généraux ou respiratoires) pour décider de l''épreuve de VS [3].', null, 'Question 1 — Quand débuter le sevrage de la VM ? (Critères respiratoires)'),
  ('MG-ANES-000046-R03', 'Mécanique ventilatoire : les paramètres et indices dérivés (pressions, résistance, compliance, commande ventilatoire) ne sont pas suffisamment discriminants pour en recommander l''usage systématique [c, 3]. Le sevrage réussit dès la première tentative chez environ deux tiers des patients sélectionnés sur les critères ci-dessus [b] ; le taux d''échec qui en découle est jugé acceptable au regard des risques d''une VM prolongée inutilement [3].', null, 'Question 1 — Quand débuter le sevrage de la VM ? (Mécanique ventilatoire)'),
  ('MG-ANES-000046-R04', 'Facteurs généraux de risque de sevrage difficile : durée de VM précédant le sevrage et score de gravité élevé (facteurs indépendants) [b]. BPCO [b] ou maladie neuromusculaire [c] à l''origine de la décompensation initiale : risque au moins doublé. Insuffisance cardiaque gauche et coronaropathie : facteur de risque supplémentaire possible [c]. Anxiété/environnement psychologique défavorable : facteur de risque probable [c]. Âges extrêmes : non retenus comme facteur de risque indépendant [b].', null, 'Question 2 — Peut-on prévoir un sevrage difficile ? (Facteurs généraux de risque)'),
  ('MG-ANES-000046-R05', 'Facteurs respiratoires : rapport fréquence respiratoire/volume courant (f/VT) ≥ 105, mesuré 2 min après passage en VS sur pièce en T, détecterait précocement les patients qui ne toléreront pas l''épreuve [b, 2], mais intérêt discutable (valeur variable selon les études, mesure non standardisée, nécessite un spiromètre) — non recommandé en routine [b, 3]. D''autres indices (pressions, résistance, compliance) sont insuffisamment spécifiques/sensibles [b, 3].', null, 'Question 2 — Peut-on prévoir un sevrage difficile ? (Facteurs respiratoires)'),
  ('MG-ANES-000046-R06', 'Critères prédictifs de l''échec de l''extubation, distincts des critères de sevrage difficile : liés à la pathologie sous-jacente (atteinte neurologique centrale) [b] ou au terrain (enfant, sexe féminin) [b]. Aspiration trachéale nécessaire au moins toutes les 2 heures, ou toux inefficace : difficulté d''extubation largement accrue [b]. Un obstacle laryngo-trachéal peut être recherché par test de fuite (ballonnet dégonflé) ou test d''obstruction de la sonde, techniques non correctement validées [c, 3]. La présence de ces facteurs ne doit pas retarder le sevrage, mais impose une vigilance accrue si l''extubation est décidée.', null, 'Question 2 — Peut-on prévoir un sevrage difficile ? (Critères prédictifs de l''échec de l''extubation)'),
  ('MG-ANES-000046-R07', 'BPCO : facteur de risque de sevrage difficile [b, 2] (déséquilibre charge/capacité des muscles respiratoires, hyperinflation dynamique ; aggravé par une insuffisance ventriculaire gauche associée). Bronchodilatateurs si bronchospasme : augmentent les chances de succès [c, 3] ; intérêt des corticoïdes systémiques non évalué. Critères pré-requis identiques à la population générale [3]. Épreuve de VS en AI ou pièce en T [a, 1] ; seuil de mauvaise tolérance parfois abaissé à SaO2 < 88 % [c, 3] ; durée de 120 min privilégiée du fait du risque de sevrage difficile [c, 3]. En cas d''échec : reprise rapide de la VM en AI + PEP et bronchodilatateurs [b, 2]. VNI proposable en cas d''échec d''extubation [b, 2] ; VNI après extubation délibérée malgré échec de l''épreuve encore en cours d''évaluation, non recommandée actuellement [a] [3].', null, 'Question 4 — Particularités selon le terrain (BPCO)'),
  ('MG-ANES-000046-R08', 'Cardiopathie : le passage en VS augmente le retour veineux et la postcharge ventriculaire gauche, peut induire une insuffisance cardiaque aiguë [b] ; la stimulation catécholaminergique peut causer une ischémie myocardique chez les patients à risque [b]. Pré-requis identique au cas général [3]. En cas de sevrage difficile : évaluation par échocardiographie et/ou cathétérisme cardiaque droit ; réduction de la volémie (diurétiques) et des résistances vasculaires (vasodilatateurs) théoriquement préférable à la stimulation de l''inotropisme [c, 3] ; sevrage progressif logique dans ce contexte [3].', null, 'Question 4 — Particularités selon le terrain (Cardiopathie)'),
  ('MG-ANES-000046-R09', 'Pathologies cérébrales : sevrage envisageable seulement en l''absence d''hypertension intracrânienne [2]. Chances de succès augmentent avec le score de Glasgow [b]. Échecs d''extubation plus fréquents (risque d''encombrement : troubles de déglutition, toux inefficace) [b], recours plus fréquent à la trachéotomie [b, 2].', null, 'Question 4 — Particularités selon le terrain (Neurologique — pathologies cérébrales)'),
  ('MG-ANES-000046-R10', 'Maladies neuromusculaires : évaluation clinique régulière nécessaire. Dans les affections en voie d''amélioration (ex. polyradiculonévrite aiguë) : mesures répétées de la capacité vitale (> 8-10 mL/kg), Pimax (< -20 cmH2O), Pemax (> 40 cmH2O) [c, 3]. Épreuve de VS d''au moins 12 h ; hypercapnie > 45 mmHg = signe de gravité majeure ; toute baisse même modeste de la SaO2 témoigne d''une hypoventilation grave [2]. CV minimale de 15 mL/kg proposée pour l''extubation au cours de la polyradiculonévrite aiguë, en l''absence de trouble de déglutition [c, 3].', null, 'Question 4 — Particularités selon le terrain (Neurologique — maladies neuromusculaires)'),
  ('MG-ANES-000046-R11', 'Maladies dégénératives : au décours de la première décompensation respiratoire, discuter avec le patient et sa famille les choix thérapeutiques futurs pour faciliter les décisions ultérieures (non coté).', null, 'Question 4 — Particularités selon le terrain (Neurologique — maladies dégénératives)'),
  ('MG-ANES-000046-R12', 'Patients chirurgicaux : assimilés à la population générale, hormis une dysfonction diaphragmatique postopératoire transitoire (chirurgie thoracique et abdominale) et la douleur, qui doit être traitée [b, 2]. Taux d''échec d''extubation le plus faible de toutes les catégories [b].', null, 'Question 4 — Particularités selon le terrain (Patients chirurgicaux)'),
  ('MG-ANES-000046-R13', 'Patients pédiatriques : procédure identique à celle de l''adulte [c, 2]. Épreuve de VS en AI ou pièce en T malgré des résistances élevées des tubes de petit diamètre [a, 1]. Incidence de complications laryngées plus importante (ventilation habituellement à fuites), potentiellement prévenue par des corticoïdes 6 à 12 heures avant l''extubation [b]. Indices prédictifs d''échec pas plus discriminants que chez l''adulte [b].', 'Pédiatrie', 'Question 4 — Particularités selon le terrain (Patients pédiatriques)'),
  ('MG-ANES-000046-R14', 'Prise en charge en réanimation en cas d''échec du sevrage : la VNI peut être proposée en cas d''échec du sevrage de la ventilation endotrachéale [b, 2] (jamais évaluée de façon prospective et randomisée dans cette indication précise) ; contre-indiquée en cas de troubles majeurs de la conscience ou de déglutition [b, 2], parfois impossible en cas de fuites importantes ou d''intolérance du masque [c]. La trachéotomie diminue le travail respiratoire [b], facilite la toilette bronchique et améliore le confort [d] (intérêt dans le sevrage jamais démontré) ; proposable en cas de contre-indication ou d''échec de la VNI, sans critère validé pour définir le moment optimal — décision au cas par cas [3].', null, 'Question 5 — Échec du sevrage : que faire ? (Prise en charge en réanimation)'),
  ('MG-ANES-000046-R15', 'Hospitalisation hors réanimation en cas d''échec du sevrage : objectifs de poursuite du sevrage et mise en place d''une réhabilitation (entraînement à l''exercice, assistance nutritionnelle, kinésithérapie, éducation du patient) [b, 2], dans des unités de soins intermédiaires respiratoires, unités de soins de suite spécialisées ou unités de sevrage (équivalent des « weaning centers » nord-américains) [2].', null, 'Question 5 — Échec du sevrage : que faire ? (Hospitalisation hors réanimation)'),
  ('MG-ANES-000046-R16', 'Prise en charge à domicile en cas d''échec du sevrage : très développée en France, envisageable seulement avec l''aide de professionnels entraînés [b, 2]. Pour une dépendance ventilatoire > 16 h/jour : infrastructure dédiée requise (deux ventilateurs avec alarmes haute/basse pression, batterie de secours, humidificateur-réchauffeur, aspiration trachéale avec batteries, source d''oxygène de secours, ballon autogonflable type Ambu® si trachéotomie) et possibilité de contacter un référent médical et technique 24 h/24. Charge particulièrement lourde pour la famille [b, 2].', null, 'Question 5 — Échec du sevrage : que faire ? (Prise en charge à domicile)'),
  ('MG-ANES-000046-R17', 'Limitation de soins à envisager en cas d''échec du sevrage lorsque le recours à la VNI ou à la trachéotomie apparaît comme une obstination déraisonnable, ou lorsque le patient refuse la procédure de sevrage et/ou la poursuite des soins — sans négliger le rôle de la famille [3].', null, 'Question 5 — Échec du sevrage : que faire ? (Limitation de soins)')
) as v(code, statement, population, source_section)
where d.source_url = 'https://sfar.org/sevrage-de-la-ventilation-mecanique-2/'
on conflict (recommendation_code) do nothing;
