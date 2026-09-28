-- Migration : Prévention et prise en charge des effets indésirables pouvant
-- survenir après une ponction lombaire (Haute Autorité de Santé, fiche
-- mémo, juin 2019 — source: https://www.has-sante.fr/upload/docs/
-- application/pdf/2019-07/fm_ponction_lombaire.pdf, direct_pdf_url == href
-- dans build/library_final.json, exact_date "2019-06-12", exact_type
-- "Autre")
-- Source : rfe-sfar-website/build/content_ponction_lombaire.json (72
-- recommandations atomiques identifiées à la lecture complète du fichier —
-- 559 lignes, 4 sections : messages clés/indications/contre-indications,
-- modalités de réalisation, effets indésirables/blood-patch, pédiatrie).
--
-- MÉTHODOLOGIE — PREMIER DOCUMENT DU CORPUS SANS AUCUN SYSTÈME DE
-- GRADE/ACCORD (disclosure explicite du contenu construit, reproduite
-- ici) : il s'agit d'une "fiche mémo" HAS — une SYNTHÈSE DE LA
-- LITTÉRATURE, pas une RFE/RBP à vote gradué. Le contenu source ne
-- comporte ni tag GRADE (1+/1-/2+/2-), ni cotation d'accord (fort/faible),
-- ni AE : aucune notion de force n'existe à extraire. `grade` et
-- `evidence_level` sont donc SQL NULL sur les 72 lignes ci-dessous, sans
-- aucune exception — même traitement que `tih_2002`/0072, seul autre
-- document de ce corpus sans grade formel (voir son commentaire de
-- migration pour le précédent). La fiche source remplace la colonne de
-- force habituelle par une colonne "Thème" pour ses 3 tableaux (contre-
-- indications, modalités, effets indésirables, pédiatrie) — reproduite
-- ici dans `condition_topic`.
--
-- STRUCTURE DES DONNÉES — décisions éditoriales explicites (pas des
-- oublis) :
-- 1. Les 10 puces du panneau "Messages clés" (R02-R11) sont migrées comme
--    des lignes atomiques à part entière, MÊME lorsqu'un thème voisin est
--    détaillé ailleurs (ex. aiguille atraumatique, formation, blood-patch),
--    car la fiche source les présente elle-même comme sa distillation
--    volontaire des points clés — les supprimer aurait risqué de perdre
--    des formulations que la source elle-même juge suffisamment
--    importantes pour les répéter en tête de document (ex. R10 "repos
--    forcé au lit et hyperhydratation n'ont pas d'indication" n'apparaît
--    NULLE PART ailleurs dans le texte pour l'adulte — seule la variante
--    pédiatrique équivalente est redétaillée plus loin, R71).
-- 2. Le panneau "Méthodologie" du document source (qui annonce lui-même
--    l'absence de système GRADE) n'est PAS repris comme ligne de
--    recommandation : c'est une note sur la méthode de la fiche, pas un
--    énoncé clinique. Sa substance est reportée dans `documents.
--    grading_system` ci-dessous.
-- 3. La note "Outre le refus explicite ou présumé du patient, les
--    contre-indications formelles sont les suivantes" (introduction du
--    tableau des contre-indications) et la section finale "Sources et
--    traçabilité" + le panneau "Avertissement" ne sont PAS des
--    recommandations cliniques distinctes (texte de liaison / mentions
--    légales déjà portées par les métadonnées `documents` de cette
--    migration) — non migrées comme lignes, par choix éditorial et non
--    par omission.
-- 4. Chaque ligne de tableau source (contre-indications, modalités,
--    effets indésirables, pédiatrie) devient une ligne atomique unique,
--    `condition_topic` reproduisant exactement le libellé de la colonne
--    "Thème" de la source.
--
-- Safety net (aucun chip composite n'existe dans ce document — vérifié) :
-- grep -n '"[12][+-]/[12][+-]' sur ce fichier retourne 0 résultat.
--
-- Sociétés : HAS est seule société citée par la source et par
-- build/library_final.json pour ce document (pas de co-publication
-- constatée) — HAS ('HAS','France') est présente dans le seed Annexe B de
-- schema_v2.sql, donc aucune disclosure de société manquante n'est
-- nécessaire ici (contrairement à tih_2002/0072 et son GEHT absent du
-- seed).
--
-- Spécialités : anesthesie_reanimation (acte réalisé par tout médecin,
-- indication rachianesthésie), neurologie (la quasi-totalité des
-- indications diagnostiques et des complications décrites sont
-- neurologiques : méningite, céphalée, SEP, Guillain-Barré, hydrocéphalie,
-- hématome périmédullaire/intracrânien, etc.), pediatrie (section dédiée
-- "Spécificités pédiatriques", R62-R72). Les trois slugs existent dans le
-- seed Annexe B de schema_v2.sql.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. `documents.doc_type` renseigné 'fiche_memo' (le format que la fiche
--    source se donne explicitement elle-même : "Fiche mémo, Haute Autorité
--    de Santé (HAS)") plutôt que 'Autre', qui est la valeur brute portée
--    par `build/library_final.json` (`exact_type`) — 'Autre' est moins
--    informatif et n'est pas un vocabulaire propre à HAS ; à confirmer si
--    le porteur de projet préfère reproduire `exact_type` littéralement.
-- 2. `documents.publication_date` renseigné '2019-06-12' d'après
--    `build/library_final.json` (`exact_date`) ; le panneau "Sources et
--    traçabilité" du contenu construit ne donne que "Juin 2019" (mois
--    seul, sans jour) — les deux sont cohérents, mais la précision au jour
--    provient uniquement de l'index, pas du texte de la fiche source
--    elle-même.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prévention et prise en charge des effets indésirables pouvant survenir après une ponction lombaire',
  'fiche_memo', 'fr', '2019-06-12',
  'https://www.has-sante.fr/upload/docs/application/pdf/2019-07/fm_ponction_lombaire.pdf',
  'https://www.has-sante.fr/upload/docs/application/pdf/2019-07/fm_ponction_lombaire.pdf',
  'Aucun système de grade ni de cotation d''accord — la fiche source le dit explicitement : il s''agit d''une "fiche mémo" HAS, synthèse de la littérature (aucun tag GRADE 1+/1-/2+/2-, aucune mention d''accord fort/faible/AE dans le texte source). Recommandations restituées sous forme de messages clés et de recommandations narratives ; les 3 tableaux thématiques du document utilisent une colonne "Thème" (reproduite dans condition_topic) au lieu d''une colonne de force.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://www.has-sante.fr/upload/docs/application/pdf/2019-07/fm_ponction_lombaire.pdf'
  and (s.acronym, s.country_or_region) in (('HAS', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://www.has-sante.fr/upload/docs/application/pdf/2019-07/fm_ponction_lombaire.pdf'
  and s.slug in ('anesthesie_reanimation', 'neurologie', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, population, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.population, v.condition_topic, v.source_section,
  'https://www.has-sante.fr/upload/docs/application/pdf/2019-07/fm_ponction_lombaire.pdf',
  'draft'
from public.documents d, (values
  ('MG-ANES-000075-R01', 'Champ : prévention et prise en charge des effets indésirables de la ponction lombaire (PL), acte diagnostique ou thérapeutique fréquent, invasif, réalisable par tout médecin. La PL est à risque d''événements indésirables (exceptionnellement graves) et d''échecs dont la majorité serait évitable — d''où l''importance de connaître l''anatomie, les contre-indications, la technique, le matériel et la prévention de ces effets indésirables.', null, 'Champ d''application', 'Champ d''application'),
  ('MG-ANES-000075-R02', 'La PL est un acte médical indispensable et très fréquent.', null, 'Fréquence et caractère indispensable', 'Messages clés'),
  ('MG-ANES-000075-R03', 'Le refus explicite ou présumé du patient et les contre-indications formelles (hypertension intracrânienne, infections au point de ponction, thrombopénie sévère) doivent être pris en considération avant toute PL.', null, 'Refus du patient et contre-indications formelles', 'Messages clés'),
  ('MG-ANES-000075-R04', 'Les complications graves de la PL sont exceptionnelles.', null, 'Rareté des complications graves', 'Messages clés'),
  ('MG-ANES-000075-R05', 'Le syndrome post-PL est l''effet indésirable le plus fréquent. S''il n''est habituellement pas grave, il est invalidant et engendre des coûts personnel, social et financier.', null, 'Fréquence et retentissement du syndrome post-PL', 'Messages clés'),
  ('MG-ANES-000075-R06', 'Il est recommandé d''utiliser une aiguille atraumatique « à extrémité non tranchante », avec introducteur, quelle que soit l''indication de la PL réalisée, chez l''adulte comme en pédiatrie.', null, 'Aiguille atraumatique', 'Messages clés'),
  ('MG-ANES-000075-R07', 'Il est recommandé aux médecins de se former à la pratique du geste de la PL, ainsi qu''à l''utilisation des aiguilles atraumatiques avec introducteur, et de se faire accompagner pour la réalisation des premières PL sur le patient, aussi souvent que nécessaire.', null, 'Formation et accompagnement', 'Messages clés'),
  ('MG-ANES-000075-R08', 'Le respect des règles de procédure et l''utilisation des aiguilles atraumatiques diminuent significativement l''incidence des effets indésirables et le recours au blood-patch.', null, 'Effet de la procédure sur l''incidence et le recours au blood-patch', 'Messages clés'),
  ('MG-ANES-000075-R09', 'Le blood-patch est le traitement le plus performant du syndrome post-PL, mais c''est un acte invasif qui peut être responsable de complications iatrogènes, exceptionnellement graves.', null, 'Blood-patch — efficacité et risques', 'Messages clés'),
  ('MG-ANES-000075-R10', 'Le repos forcé au lit et l''hyperhydratation n''ont pas d''indication.', null, 'Repos au lit et hyperhydratation', 'Messages clés'),
  ('MG-ANES-000075-R11', 'La PL et le blood-patch sont des gestes invasifs avec risque d''accident d''exposition au sang : les aiguilles doivent être collectées dans un conteneur prévu à cet effet.', null, 'Prévention des accidents d''exposition au sang', 'Messages clés'),
  ('MG-ANES-000075-R12', 'Les indications de la ponction lombaire évoluent constamment avec le développement des connaissances et des techniques ; les indications listées ci-dessous le sont à titre indicatif et de manière non exhaustive.', null, 'Portée et actualisation des indications', 'Indications diagnostiques et thérapeutiques'),
  ('MG-ANES-000075-R13', 'Indication diagnostique de la PL : suspicion d''infection du système nerveux central (bactérienne, virale, parasitaire).', null, 'Suspicion d''infection du système nerveux central', 'Indications diagnostiques'),
  ('MG-ANES-000075-R14', 'Indication diagnostique de la PL : survenue d''une céphalée brutale et/ou atypique (hémorragie méningée, thrombophlébite, dissection vasculaire, etc.).', null, 'Céphalée brutale et/ou atypique', 'Indications diagnostiques'),
  ('MG-ANES-000075-R15', 'Indication diagnostique de la PL : suspicion d''une méningite carcinomateuse ou d''un syndrome paranéoplasique.', null, 'Suspicion de méningite carcinomateuse ou de syndrome paranéoplasique', 'Indications diagnostiques'),
  ('MG-ANES-000075-R16', 'Indication diagnostique de la PL : bilan de maladies inflammatoires affectant le système nerveux central (sclérose en plaques, sarcoïdose, vascularite, encéphalite auto-immune, etc.).', null, 'Bilan de maladie inflammatoire du système nerveux central', 'Indications diagnostiques'),
  ('MG-ANES-000075-R17', 'Indication diagnostique de la PL : bilan d''une neuropathie aiguë ou chronique (syndrome de Guillain-Barré, neuropathie périphérique, etc.).', null, 'Bilan de neuropathie aiguë ou chronique', 'Indications diagnostiques'),
  ('MG-ANES-000075-R18', 'Indication diagnostique de la PL : maladies neurodégénératives (maladie d''Alzheimer, sclérose latérale amyotrophique, maladie à corps de Lewy, etc.).', null, 'Maladie neurodégénérative', 'Indications diagnostiques'),
  ('MG-ANES-000075-R19', 'Indication diagnostique de la PL : mesure de la pression du liquide cérébro-spinal (LCS) en cas de suspicion de troubles de la cinétique du LCS (hydrocéphalie à pression normale, hypertension intracrânienne idiopathique).', null, 'Mesure de la pression du LCS', 'Indications diagnostiques'),
  ('MG-ANES-000075-R20', 'Indication thérapeutique de la PL : ponction lombaire évacuatrice (hydrocéphalie à pression normale, après interventions neurochirurgicales).', null, 'Ponction lombaire évacuatrice', 'Indications thérapeutiques'),
  ('MG-ANES-000075-R21', 'Indication thérapeutique de la PL : rachianesthésie.', null, 'Rachianesthésie', 'Indications thérapeutiques'),
  ('MG-ANES-000075-R22', 'Indication thérapeutique de la PL : recherche clinique.', null, 'Recherche clinique', 'Indications thérapeutiques'),
  ('MG-ANES-000075-R23', 'Hypertension intracrânienne : contre-indication formelle à la PL, en raison du risque d''engagement cérébral (processus expansif intracrânien, malformation d''Arnold-Chiari) — la normalité d''un examen neurologique minutieux permet de se passer de l''imagerie.', null, 'Hypertension intracrânienne', 'Contre-indications formelles'),
  ('MG-ANES-000075-R24', 'Infections au point de ponction : contre-indication formelle à la PL.', null, 'Infections au point de ponction', 'Contre-indications formelles'),
  ('MG-ANES-000075-R25', 'Thrombopénie sévère (nombre de plaquettes inférieur à 50 G/L, soit 50 000/mm³) : contre-indication formelle à la PL. Pour certaines pathologies (thrombopénie gestationnelle, purpura thrombopénique immunologique), une thrombopénie stable supérieure ou égale à 30 G/L peut être tolérée ; à l''inverse, une thrombopénie évolutive non stabilisée nécessite une évaluation pluridisciplinaire du rapport bénéfice/risque.', null, 'Thrombopénie sévère', 'Contre-indications formelles'),
  ('MG-ANES-000075-R26', 'Troubles de la coagulation ou traitements modifiant l''hémostase : l''hématome péridural ou sous-arachnoïdien après une PL est exceptionnel, presque toujours lié à un ou plusieurs facteurs de risque (traitement anticoagulant à dose thérapeutique ou antiplaquettaire sauf aspirine et AINS, trouble congénital ou acquis de la coagulation/hémostase primaire, ponction difficile/traumatique ou rachis pathologique tel qu''une spondylarthrite ankylosante). En urgence : antagoniser le traitement anticoagulant si possible, ou substituer le déficit en facteurs de coagulation si nécessaire.', null, 'Troubles de la coagulation ou traitements modifiant l''hémostase', 'Contre-indications formelles'),
  ('MG-ANES-000075-R27', 'La PL doit être réalisée dans le cadre d''une hospitalisation ; sa réalisation ne justifie pas, à elle seule, une hospitalisation de plus de 24 heures.', null, 'Cadre d''hospitalisation', 'Modalités de réalisation'),
  ('MG-ANES-000075-R28', 'Le choix de la position assise ou allongée pour la réalisation de la PL est laissé à l''appréciation du médecin et du patient.', null, 'Installation du patient', 'Modalités de réalisation'),
  ('MG-ANES-000075-R29', 'Niveaux corrects pour la ponction : espaces interépineux L3-L4, L4-L5 et L5-S1. Il est recommandé de ponctionner en dessous de la ligne horizontale tracée entre les crêtes iliaques (la détermination de l''espace à ponctionner est en pratique plus difficile que classiquement décrit). En cas de difficulté, la PL peut être réalisée sous imagerie (radioscopie, échographie).', null, 'Détermination du point de ponction', 'Modalités de réalisation'),
  ('MG-ANES-000075-R30', 'Les règles d''asepsie chirurgicale doivent être respectées absolument : pour le patient, désinfection cutanée en deux temps (antiseptique alcoolique) puis champ stérile ; pour le médecin, désinfection des mains (solution hydro-alcoolique), masque facial, gants stériles.', null, 'Asepsie', 'Modalités de réalisation'),
  ('MG-ANES-000075-R31', 'Un patch d''anesthésique local peut être proposé en dehors de l''urgence (délai d''1 heure). Dans les cas prévisibles de ponction difficile, une anesthésie locale peut être envisagée.', null, 'Anesthésie locale', 'Modalités de réalisation'),
  ('MG-ANES-000075-R32', 'Quelle que soit l''indication, la technique de la PL reste identique. Il est recommandé d''utiliser une aiguille atraumatique « à extrémité non tranchante », de diamètre maximal 22 Gauge (code couleur noir — plus la Gauge est élevée, plus l''aiguille est fine). L''introducteur fourni avec l''aiguille est indispensable pour franchir la peau ; il est recommandé aux médecins de se former à son utilisation.', null, 'Réalisation de la ponction', 'Modalités de réalisation'),
  ('MG-ANES-000075-R33', 'Il est recommandé de réintroduire complètement le mandrin dans l''aiguille avant de la retirer.', null, 'Réintroduction du mandrin', 'Modalités de réalisation'),
  ('MG-ANES-000075-R34', 'L''incidence des syndromes post-PL immédiats augmente pour un volume prélevé supérieur à 30 mL.', null, 'Prélèvements', 'Modalités de réalisation'),
  ('MG-ANES-000075-R35', 'La PL est un geste invasif avec risque d''accident d''exposition au sang : les aiguilles doivent être collectées dans un conteneur à disposition et prévu à cet effet.', null, 'Prévention des accidents d''exposition au sang', 'Modalités de réalisation'),
  ('MG-ANES-000075-R36', 'La PL nécessite une bonne connaissance de l''anatomie mais aussi de la pratique du geste ; la formation pratique par simulation est recommandée.', null, 'Formation pratique par simulation', 'Formation'),
  ('MG-ANES-000075-R37', 'La formation pratique par simulation à la PL est recommandée avant tout premier geste (formation généralement assurée pendant les études médicales sur les plateformes de simulation universitaires).', null, 'Avant tout premier geste', 'Formation'),
  ('MG-ANES-000075-R38', 'La formation pratique par simulation à la PL est recommandée pour tout médecin, dans le cadre de la mise à jour des conditions de pratique.', null, 'Mise à jour des conditions de pratique', 'Formation'),
  ('MG-ANES-000075-R39', 'La formation pratique par simulation à la PL est recommandée pour tout médecin ayant réalisé peu ou pas de PL.', null, 'Médecin ayant réalisé peu ou pas de PL', 'Formation'),
  ('MG-ANES-000075-R40', 'La formation pratique par simulation à la PL est recommandée dans le cadre de l''accréditation des médecins et des équipes.', null, 'Accréditation des médecins et des équipes', 'Formation'),
  ('MG-ANES-000075-R41', 'Après formation par simulation, il est recommandé que le médecin soit accompagné pour la réalisation des premières PL sur le patient, aussi souvent que nécessaire.', null, 'Accompagnement des premières PL', 'Formation'),
  ('MG-ANES-000075-R42', 'La PL est parfois responsable d''effets indésirables : syndrome post-PL (syndrome d''hypotension intracrânienne), hématomes, infections, douleurs lombaires, voire, de manière très exceptionnelle, paraplégie ou décès.', null, 'Panorama des effets indésirables', 'Effets indésirables'),
  ('MG-ANES-000075-R43', 'Le syndrome post-PL est secondaire à une fuite persistante de liquide cérébro-spinal (LCS) et se caractérise par une céphalée orthostatique.', null, 'Mécanisme et définition', 'Syndrome post-PL'),
  ('MG-ANES-000075-R44', 'Le syndrome post-PL apparaît habituellement dans les 2 à 4 jours après une PL (mais parfois plus tardivement) ; il est apyrétique et partiellement ou totalement soulagé par le décubitus dorsal.', null, 'Délai de survenue et évolution', 'Syndrome post-PL'),
  ('MG-ANES-000075-R45', 'La céphalée du syndrome post-PL est classiquement bilatérale, occipitale, occipito-frontale ou diffuse, irradiant dans la nuque, le dos et parfois aux épaules.', null, 'Description clinique de la céphalée', 'Syndrome post-PL'),
  ('MG-ANES-000075-R46', 'Le syndrome post-PL peut être isolé ou accompagné d''un cortège variable de signes : nausées et vomissements ; signes auditifs ou visuels (hypoacousie, rarement hyperacousie, diplopie par atteinte de la VIe paire, photophobie).', null, 'Signes associés', 'Syndrome post-PL'),
  ('MG-ANES-000075-R47', 'Un syndrome post-PL atypique, ou dont la symptomatologie se modifie, nécessite un avis spécialisé. Il existe des cas exceptionnels de syndrome post-PL sans céphalée (par exemple vertiges ou troubles auditifs isolés).', null, 'Formes atypiques et cas exceptionnels', 'Syndrome post-PL'),
  ('MG-ANES-000075-R48', 'L''incidence du syndrome post-PL peut être minorée par des mesures simples : l''utilisation d''aiguilles atraumatiques la diminue significativement en incidence et en intensité (incidence inférieure à 10 % avec aiguilles atraumatiques, contre jusqu''à 35 % avec des aiguilles traumatiques).', null, 'Prévention de l''incidence par aiguille atraumatique', 'Syndrome post-PL'),
  ('MG-ANES-000075-R49', 'Après une PL, l''apparition d''une fièvre est un signe d''alerte de complication grave et doit conduire à une prise en charge diagnostique et thérapeutique en urgence.', null, 'Fièvre', 'Signes d''alerte de complications graves'),
  ('MG-ANES-000075-R50', 'Après une PL, l''apparition d''un signe neurologique nouveau (syndrome complet ou incomplet de la queue-de-cheval, diplopie, déficit sensitif et/ou moteur, trouble de conscience, confusion, crise d''épilepsie, coma, etc.) est un signe d''alerte de complication grave et doit conduire à une prise en charge diagnostique et thérapeutique en urgence.', null, 'Signe neurologique', 'Signes d''alerte de complications graves'),
  ('MG-ANES-000075-R51', 'Après une PL, une modification du caractère postural de la céphalée post-PL est un signe d''alerte de complication grave et doit conduire à une prise en charge diagnostique et thérapeutique en urgence.', null, 'Modification du caractère postural de la céphalée', 'Signes d''alerte de complications graves'),
  ('MG-ANES-000075-R52', 'La baisse de l''acuité visuelle après une PL doit faire évoquer une autre étiologie, car il s''agit d''une complication exceptionnelle.', null, 'Baisse de l''acuité visuelle', 'Signes d''alerte de complications graves'),
  ('MG-ANES-000075-R53', 'Les hématomes après PL sont très exceptionnels, périmédullaires ou intracrâniens, favorisés par les troubles de la coagulation, les traitements modifiant l''hémostase et les ponctions multiples. Quelle que soit leur localisation, il s''agit d''une urgence diagnostique et thérapeutique nécessitant une imagerie et un avis spécialisé.', null, 'Hématomes', 'Effets indésirables'),
  ('MG-ANES-000075-R54', 'Les infections après PL sont exceptionnelles, liées au non-respect des règles d''asepsie : méningite, abcès au point de ponction, spondylodiscite, etc.', null, 'Infections', 'Effets indésirables'),
  ('MG-ANES-000075-R55', 'Des douleurs lombaires sont possibles après une PL, habituellement banales.', null, 'Douleurs lombaires', 'Effets indésirables'),
  ('MG-ANES-000075-R56', 'Le blood-patch consiste en l''injection de sang autologue (du patient lui-même) dans l''espace péridural pour colmater la brèche méningée. Il s''agit du traitement le plus efficace en cas de non-guérison spontanée du syndrome post-PL dans les 48 à 72 heures.', null, 'Définition et efficacité', 'Blood-patch'),
  ('MG-ANES-000075-R57', 'Le blood-patch doit être envisagé après échec des traitements non invasifs et réalisé dans des conditions d''asepsie chirurgicale, par un médecin expérimenté.', null, 'Conditions d''asepsie et opérateur', 'Blood-patch'),
  ('MG-ANES-000075-R58', 'Le blood-patch est réalisé au cours d''une hospitalisation ; sa réalisation ne justifie pas, à elle seule, une hospitalisation de plus de 24 heures.', null, 'Cadre d''hospitalisation', 'Blood-patch'),
  ('MG-ANES-000075-R59', 'Le blood-patch peut possiblement être réalisé en hôpital de jour, en garantissant un temps de surveillance et de décubitus pour le patient d''au moins 2 heures.', null, 'Modalités en hôpital de jour', 'Blood-patch'),
  ('MG-ANES-000075-R60', 'En cas d''inefficacité immédiate du blood-patch ou de récidive à distance, un 2e blood-patch est possible ; en revanche, un 3e blood-patch ne doit pas être réalisé sans imagerie (IRM et avis spécialisé).', null, '2e et 3e blood-patch', 'Blood-patch'),
  ('MG-ANES-000075-R61', 'Comme la PL, le blood-patch est un geste invasif avec risque d''accident d''exposition au sang : les aiguilles doivent être collectées dans un conteneur prévu à cet effet.', null, 'Prévention des accidents d''exposition au sang', 'Blood-patch'),
  ('MG-ANES-000075-R62', 'Le syndrome post-PL existe chez l''enfant et doit faire l''objet d''une prévention. Le taux de succès de la PL chez l''enfant est lié à plusieurs facteurs : positionnement de l''enfant, choix de l''aiguille, analgésie.', 'Pédiatrie', 'Syndrome post-PL chez l''enfant — généralités', 'Spécificités pédiatriques'),
  ('MG-ANES-000075-R63', 'Chez le nourrisson, la position assise sans flexion de hanche ni flexion de nuque dégage le plus large espace intervertébral avec la meilleure tolérance hémodynamique. Chez l''enfant, la position assise ou allongée est possible, comme chez l''adulte.', 'Pédiatrie', 'Installation', 'Spécificités pédiatriques'),
  ('MG-ANES-000075-R64', 'Les aiguilles atraumatiques « à extrémité non tranchante », de 22 à 27 Gauge, sont recommandées en 1ère intention chez l''enfant (certaines s''utilisent sans introducteur — 22, 24, 25 G — d''autres avec introducteur — 22, 25, 27 G) ; une formation à l''utilisation des aiguilles atraumatiques avec introducteur est recommandée. L''usage des aiguilles traumatiques à biseau tranchant doit rester exceptionnel.', 'Pédiatrie', 'Choix de l''aiguille', 'Spécificités pédiatriques'),
  ('MG-ANES-000075-R65', 'Chez l''enfant, l''angle permettant d''accéder le plus efficacement au LCS est compris entre 50° et 60°. Un repérage échographique, lorsqu''il est disponible, permet un taux de succès plus important.', 'Pédiatrie', 'Angle de pénétration', 'Spécificités pédiatriques'),
  ('MG-ANES-000075-R66', 'L''analgésie est un point clé de la réussite du geste chez l''enfant. Options disponibles : crème anesthésiante lidocaïne + prilocaïne à appliquer 1 heure avant (hors urgence), quel que soit l''âge sauf prématuré de moins de 37 SA d''âge post-conceptionnel ; sérum glucosé à 30 % per os chez le nourrisson jusqu''à 6 mois ; inhalation d''un mélange équimolaire oxygène/protoxyde d''azote (MEOPA), à tout âge ; traitements anxiolytiques et antalgiques intra-rectaux ou morphiniques per os pour une PL programmée ou des antécédents de vécu douloureux.', 'Pédiatrie', 'Analgésie', 'Spécificités pédiatriques'),
  ('MG-ANES-000075-R67', 'Chez l''enfant, la présentation clinique du syndrome post-PL est identique à celle de l''adulte, avec une incidence de 2 à 15 % selon les études. Chez le nourrisson, le diagnostic reste difficile en l''absence de critère diagnostique spécifique.', 'Pédiatrie', 'Syndrome post-PL chez l''enfant — présentation et incidence', 'Spécificités pédiatriques'),
  ('MG-ANES-000075-R68', 'L''utilisation d''aiguilles atraumatiques chez l''enfant diminue l''incidence du syndrome post-PL, mais nécessite une formation des médecins.', 'Pédiatrie', 'Prévention du syndrome post-PL — aiguilles atraumatiques', 'Spécificités pédiatriques'),
  ('MG-ANES-000075-R69', 'En cas d''utilisation d''aiguilles traumatiques chez l''enfant, les éléments suivants sont associés à un risque moindre de syndrome post-PL : aiguille de petit diamètre (22 Gauge et plus) ; position du biseau parallèle à l''axe du rachis ; réintroduction du mandrin avant retrait de l''aiguille.', 'Pédiatrie', 'Prévention du syndrome post-PL — aiguilles traumatiques', 'Spécificités pédiatriques'),
  ('MG-ANES-000075-R70', 'Il n''y a pas d''indication à l''alitement strict après la PL chez l''enfant.', 'Pédiatrie', 'Alitement après la PL', 'Spécificités pédiatriques'),
  ('MG-ANES-000075-R71', 'En cas de syndrome post-PL avéré chez l''enfant, le traitement conservateur (antalgiques) est recommandé en première intention. Le repos au lit n''est pas obligatoire ; l''efficacité de l''hyperhydratation n''est pas prouvée.', 'Pédiatrie', 'Prise en charge du syndrome post-PL — traitement conservateur', 'Spécificités pédiatriques'),
  ('MG-ANES-000075-R72', 'Comme chez l''adulte, le seul traitement ayant montré son efficacité en cas de syndrome post-PL persistant et/ou sévère chez l''enfant est le blood-patch ; les indications du blood-patch chez l''enfant restent rares.', 'Pédiatrie', 'Prise en charge du syndrome post-PL — blood-patch', 'Spécificités pédiatriques')
) as v(code, statement, population, condition_topic, source_section)
where d.source_url = 'https://www.has-sante.fr/upload/docs/application/pdf/2019-07/fm_ponction_lombaire.pdf'
on conflict (recommendation_code) do nothing;
