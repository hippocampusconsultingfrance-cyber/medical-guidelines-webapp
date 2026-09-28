-- Migration : Transfusion de plasma thérapeutique : produits, indications
-- — Recommandations HAS/ANSM, actualisation 2012 des recommandations de
-- 2002. Suite à l'abrogation de l'arrêté du 3 décembre 1991, ce document
-- constitue depuis le 13 juillet 2011 l'UNIQUE référence officielle pour la
-- prescription du plasma en France. Source :
-- rfe-sfar-website/build/content_transfusion_plasma.json (40 énoncés
-- répartis en 6 sections thématiques ; adulte, nouveau-né, enfant).
--
-- NATURE DU DOCUMENT — disclosure importante : contrairement à la quasi-
-- totalité du corpus, ce n'est PAS un document SFAR (RFE/CC/CE) mais une
-- recommandation nationale ANSM/HAS, simplement hébergée en copie sur
-- sfar.org — la SFAR n'est ni auteure ni co-signataire de ce texte.
-- `library_final.json` classe pourtant ce document `"exact_type": "RFE"`
-- comme les autres — divergence disclosée, non résolue. `doc_type =
-- 'Recommandations ANSM/HAS'` retenu, conforme à la nature réelle du
-- document. **SFAR volontairement NON liée en document_societies pour
-- cette raison précise** (cas unique dans ce corpus à ce jour).
--
-- MÉTHODOLOGIE — GRADES HAS/ANAES (A/B/C) + « ACCORD PROFESSIONNEL »,
-- DIFFÉRENT DE GRADE : Grade A = preuve scientifique établie ; Grade B =
-- présomption scientifique ; Grade C = faible niveau de preuve ; « accord
-- professionnel » (AP) = absence de preuve, avis du groupe de travail après
-- consultation de groupes de lecture. **Vérifié exhaustivement par le
-- contenu construit : 33 énoncés tagués — 6 Grade B, 11 Grade C, 16 AP,
-- AUCUN Grade A** — exactement reconcilié par inventaire direct. `grade`
-- reproduit tel quel ('B'/'C'/'AP'). `evidence_level` laissé NULL (axe
-- unique).
--
-- **7 ÉNONCÉS CLINIQUEMENT SUBSTANTIELS SANS TAG EXPLICITE** (disclosure
-- de la source elle-même, déjà signalée en tête du contenu construit :
-- "plusieurs énoncés cliniquement importants ne portent aucun tag
-- explicite dans la source") — ce ne sont PAS des items "sans
-- recommandation possible" (contrairement au '?' de sepsis/0044) mais des
-- indications/non-indications cliniques réelles, simplement non gradées
-- par la source elle-même — migrées ici avec `grade = NULL` (jamais un
-- grade inventé), même traitement que les "non cotés" de
-- securisation_proc/0041. TOTAL migré = 40 (33 gradés + 7 non gradés),
-- cohérent avec le comptage exhaustif du contenu construit.
--
-- POPULATION : les 6 énoncés de la section "Néonatologie et pédiatrie"
-- taggés `population = 'Pédiatrie'` ; les 3 énoncés préfixés "Obstétrique"
-- (section chirurgie/traumatologie/obstétrique) taggés `population =
-- 'Grossesse'` ; le reste (adulte par défaut) laissé NULL.
--
-- PÉRIMÈTRE — volontairement pas migrés (référence produit/pharmacologique/
-- procédurale, jamais un chip de grade individuel) : le tableau des 4
-- plasmas thérapeutiques homologues (PFC-SD/PFC-IA/PFC-Se/PLYO —
-- caractéristiques, volumes, conservation) ; les modalités de
-- décongélation, transformations, compatibilité ABO, contre-indications
-- et précautions d'emploi (prose narrative, informations produit) ; les
-- tests biologiques (Quick, INR, biologie délocalisée) ; les posologies/
-- modalités de la vitamine K en prophylaxie néonatale.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Seule la HAS (dans le seed Annexe B, 2e utilisation dans ce corpus
--    après sepsis/0044) liée en document_societies. ANSM (co-auteure)
--    hors seed, non liée. SFAR délibérément non liée (cf. disclosure
--    "Nature du document" ci-dessus).
-- 2. Un document distinct et plus récent existe dans `library_final.json`
--    — "Indications de transfusion de plasmas lyophilisés (PLYO)..."
--    (SFAR, RPP 2020, périmètre restreint au PLYO en choc hémorragique) —
--    non confondu (href/contenu distincts), non couvert par le contenu
--    construit de cette migration-ci.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Transfusion de plasma thérapeutique : produits, indications',
  'Recommandations ANSM/HAS', 'fr', '2012-06-01',
  'https://sfar.org/transfusion-de-plasma-therapeutique-produits-indications/',
  'https://sfar.org/wp-content/uploads/2015/10/2_HAS_Texte-court-ransfusion-de-plasma-therapeutique-Produits-indications.pdf',
  'Grades HAS/ANAES (A/B/C) + « accord professionnel » (AP), différent de GRADE. A = preuve établie, B = présomption scientifique, C = faible niveau de preuve, AP = avis du groupe de travail (absence de preuve). 33 énoncés gradés (6B, 11C, 16AP, aucun A) exactement reconciliés par inventaire direct, + 7 énoncés cliniquement substantiels sans tag explicite dans la source (grade NULL, pas "aucune recommandation possible").',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/transfusion-de-plasma-therapeutique-produits-indications/'
  and s.acronym in ('HAS') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/transfusion-de-plasma-therapeutique-produits-indications/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'gynecologie_obstetrique', 'pediatrie', 'hematologie', 'chirurgie_cardiaque')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.source_section,
  'https://sfar.org/transfusion-de-plasma-therapeutique-produits-indications/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000049-R01', 'Ne pas utiliser le plasma thérapeutique comme soluté de remplissage.', 'C', null, 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R02', 'Administration prophylactique avant la survenue du saignement, chez un patient à facteurs normaux ou modérément altérés : non indiquée.', 'AP', null, 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R03', 'Hémorragie modérée/peu évolutive/contrôlée : administration guidée en priorité par les tests de laboratoire, réalisée seulement si ratio Quick patient/témoin > 1,5 (TP ≈ 40 %).', 'C', null, 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R04', 'Volume initial de plasma à prescrire : 10 à 15 mL/kg ; pas d''argument pour transfuser plus précocement ou plus massivement dans cette indication.', 'AP', null, 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R05', 'Choc hémorragique/transfusion massive (> 5 CGR en 3h) : transfuser le plasma en association aux CGR, ratio PFC:CGR entre 1:2 et 1:1.', 'C', null, 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R06', 'La transfusion de plasma doit débuter au plus vite, idéalement en même temps que les concentrés de globules rouges.', 'C', null, 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R07', 'Transfusion plaquettaire précoce, généralement dès la 2e prescription transfusionnelle.', 'C', null, 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R08', 'Mise en place de protocoles de transfusion massive dans les centres prenant en charge des hémorragies massives (réduction des délais : coursiers, décongélation sur appel SAMU).', 'C', null, 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R09', 'Surveiller l''évolution du fibrinogène, objectif 1,5-2 g/L au cours de la prise en charge transfusionnelle.', 'C', null, 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R10', 'Obstétrique : plasma recommandé dans la coagulopathie obstétricale si le traitement étiologique ne contrôle pas rapidement l''hémorragie.', 'AP', 'Grossesse', 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R11', 'Obstétrique : fibrinogène mesuré précocement pour prédire la gravité de l''hémorragie.', 'C', 'Grossesse', 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R12', 'Obstétrique : décider de la stratégie transfusionnelle pour maintenir le fibrinogène ≥ 2 g/L ; monitorage répété au moins toutes les 2-3h.', 'AP', 'Grossesse', 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R13', 'Neurochirurgie, sans hémorragie massive : plasma indiqué si TP < 50 % (surveillance d''un traumatisé crânien grave) ou < 60 % (pose d''un capteur de pression intracrânienne).', 'AP', null, 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R14', 'Chirurgie cardiaque : indication seulement si saignement microvasculaire persistant ET déficit en facteurs (TP ≤ 40 % ou TCA > 1,8/témoin, temps de thrombine normal, ou facteurs ≤ 40 %).', 'AP', null, 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R15', 'Chirurgie cardiaque, en l''absence de saignement : pas d''indication au plasma (prescription prophylactique non justifiée, aucun bénéfice, risques transfusionnels accrus).', 'AP', null, 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R16', 'Chaque centre de chirurgie cardiaque doit établir son propre algorithme décisionnel (réduit la consommation de PSL, les complications post-opératoires et la durée de séjour).', 'B', null, 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R17', 'Chirurgie cardiaque : posologie initiale 15 mL/kg, répétée selon réévaluation clinico-biologique.', 'AP', null, 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R18', 'Rupture d''anévrysme de l''aorte abdominale : prise en charge intensive et précoce avec ratio PFC:CGR augmenté jusqu''à 1:1 en peropératoire, associée à une amélioration de la survie.', 'C', null, 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R19', 'Insuffisance hépatocellulaire chronique, sans saignement : transfusion de PFC non recommandée.', 'AP', null, 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R20', 'Insuffisance hépatique aiguë sévère, sujet ne saignant pas et non exposé à un geste vulnérant : transfusion systématique/préventive non recommandée dans le seul but de corriger l''hémostase (aucune preuve de bénéfice, perturbe la valeur pronostique pour la décision de transplantation). Exception : peut être envisagée, parmi d''autres traitements hémostatiques et selon les anomalies prédominantes de la coagulation, avant la pose d''un capteur de pression intracrânienne et après décision de transplantation hépatique.', 'AP', null, 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R21', 'Brûlures : plasma comme soluté de remplissage, non justifié.', 'AP', null, 'Indications — Chirurgie, traumatologie et obstétrique'),
  ('MG-ANES-000049-R22', 'CIVD avec effondrement des facteurs (TP < 35-40 %), associée à une hémorragie active ou potentielle (acte invasif) : transfusion de 10 à 15 mL/kg.', 'B', null, 'Indications en médecine'),
  ('MG-ANES-000049-R23', 'Déficit en un facteur pour lequel une préparation purifiée existe mais n''est pas rapidement disponible : apport de plasma (10-15 mL/kg) licite en situation d''urgence hémorragique.', 'AP', null, 'Indications en médecine'),
  ('MG-ANES-000049-R24', 'Micro-angiopathie thrombotique (PTT, SHU grave) : effet thérapeutique reconnu à 40-60 mL/kg (1 à 1,5 masse plasmatique), préférentiellement par échanges plasmatiques quotidiens jusqu''à disparition des défaillances d''organe et plaquettes > 150 G/L pendant ≥ 48h.', 'B', null, 'Indications en médecine'),
  ('MG-ANES-000049-R25', 'Traitements immunomodulateurs associés : peuvent diminuer la durée du traitement chez les patients en réponse sub-optimale.', 'B', null, 'Indications en médecine'),
  ('MG-ANES-000049-R26', 'Plasmathérapie au long cours : peut être nécessaire dans les PTT héréditaires récurrents.', 'AP', null, 'Indications en médecine'),
  ('MG-ANES-000049-R27', 'SHU atypique : les échanges plasmatiques constituent le traitement de 1re ligne (ne repose pas sur des essais thérapeutiques).', 'AP', null, 'Indications en médecine'),
  ('MG-ANES-000049-R28', 'Échanges plasmatiques aux colloïdes, patient sans risque hémorragique : maintenir le fibrinogène ≥ 1 g/L (plasma en fin de séance, 10-20 mL/kg). Risque hémorragique lié à la pathologie : plasma plus précoce et à plus forte dose (30 mL/kg).', null, null, 'Indications en médecine'),
  ('MG-ANES-000049-R29', 'Avant une intervention chirurgicale à fort risque hémorragique à court terme : utiliser du PFC (et non un colloïde) lors des échanges plasmatiques.', 'AP', null, 'Indications en médecine'),
  ('MG-ANES-000049-R30', 'Œdème angioneurotique héréditaire : le plasma n''est pas le traitement des poussées aiguës (C1-INH IV ou icatibant SC en 1re ligne) ; envisageable seulement en l''absence de disponibilité immédiate des traitements spécifiques.', null, null, 'Indications en médecine'),
  ('MG-ANES-000049-R31', 'Utilisation similaire à l''adulte (CIVD, hémorragie massive, insuffisance hépatique).', null, 'Pédiatrie', 'Néonatologie et pédiatrie'),
  ('MG-ANES-000049-R32', 'CIVD avec syndrome hémorragique grave : transfusion à 10-20 mL/kg, parallèlement au traitement de la cause.', null, 'Pédiatrie', 'Néonatologie et pédiatrie'),
  ('MG-ANES-000049-R33', 'Circulation extra-corporelle (CEC) : utiliser du sang reconstitué avec du plasma thérapeutique pour l''amorçage des circuits.', 'B', 'Pédiatrie', 'Néonatologie et pédiatrie'),
  ('MG-ANES-000049-R34', 'Grand prématuré < 29 SA en détresse vitale : transfusion fréquemment utilisée si facteurs de coagulation < 20 %, même en l''absence de syndrome hémorragique clinique.', 'C', 'Pédiatrie', 'Néonatologie et pédiatrie'),
  ('MG-ANES-000049-R35', 'Syndrome hémorragique sévère dans l''attente de l''effet de la vitamine K (maladie hémorragique du nouveau-né) : recours au PFC possible.', 'C', 'Pédiatrie', 'Néonatologie et pédiatrie'),
  ('MG-ANES-000049-R36', 'Non indiqué chez l''enfant/nouveau-né : SHU typique post-diarrhéique (STEC+) sans critère de gravité ; infection néonatale sans CIVD (adjuvant à l''antibiothérapie) ; hypovolémie sans syndrome hémorragique ni trouble de l''hémostase ; prévention des hémorragies intraventriculaires du prématuré sans coagulopathie ; nouveau-né sain avant chirurgie.', null, 'Pédiatrie', 'Néonatologie et pédiatrie'),
  ('MG-ANES-000049-R37', 'Absence de disponibilité de CCP pour antagoniser les AVK en cas d''hémorragie grave.', 'B', null, 'Antidote au surdosage en AVK'),
  ('MG-ANES-000049-R38', 'Absence de disponibilité de CCP ne contenant pas d''héparine, chez un patient aux antécédents de thrombopénie induite par l''héparine (TIH).', null, null, 'Antidote au surdosage en AVK'),
  ('MG-ANES-000049-R39', 'Aucune étude ne définit les indications du plasma autologue. Si aucune perte volémique importante n''est attendue (recours au plasma non envisagé) : le prélèvement pour transfusion autologue peut se faire par érythrocytaphérèse (ne fournit pas de plasma autologue).', 'AP', null, 'Plasma autologue — indications'),
  ('MG-ANES-000049-R40', 'Lorsque le plasma autologue est disponible, le choix entre son emploi et les cristalloïdes/colloïdes doit être pesé au cas par cas (risques relatifs comparables) : l''emploi systématique comme produit de remplissage ne peut être recommandé.', null, null, 'Plasma autologue — indications')) as v(code, statement, grade, population, source_section)
where d.source_url = 'https://sfar.org/transfusion-de-plasma-therapeutique-produits-indications/'
on conflict (recommendation_code) do nothing;
