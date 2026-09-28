-- Migration : Anesthésie du sujet âgé : l'exemple de fracture de
-- l'extrémité supérieure du fémur (FESF) (SFAR/SOFCOT/SFGG/SFPC, RFE 2017)
-- Source : rfe-sfar-website/build/content_sujet_age_esf.json (26
-- recommandations numérotées R1.1-R8.2, réparties sur 8 questions).
--
-- MÉTHODOLOGIE GRADE® — deux axes indépendants imprimés côte à côte : (1)
-- la force (1+/1-/2+/2- ou avis d'experts "AE") — `grade` reproduit ce tag
-- littéralement ; (2) l'accord du vote Delphi/GRADE Grid ("accord fort" par
-- défaut ≥ 70 %, "accord faible" pour 2 items sur 26 seulement — R1.4 et
-- R5.1). `evidence_level` laissé NULL : aucun niveau de preuve distinct
-- (haute/modérée/basse/très basse) n'est imprimé individuellement à côté de
-- chaque recommandation dans la source, seul le tag de force l'est (même
-- convention que `sepsis`/0044). La mention "(accord faible)" est
-- conservée en citation inline dans `statement` pour les 2 items concernés
-- (même convention que `anticoagulants`/0012), jamais encodée comme un
-- second grade distinct.
--
-- DISCLOSURE DÉJÀ FAITE PAR LA FICHE SOURCE (reproduite ici, PAS résolue
-- silencieusement) :
-- 1. Bug d'extraction PDF corrigé par le pipeline rfe-sfar-website : le
--    texte brut du PDF affiche "GRADE 2S"/"GRADE 1S" pour R5.1, R6.1, R8.1
--    (artefact de police substituant "S" à "−"), vérifié par rendu visuel à
--    200 dpi et corrigé en "2−"/"1−" — reproduit ici déjà corrigé (grade
--    '2-'/'1-' ci-dessous), PAS le texte brut fautif du PDF.
-- 2. Incohérence interne au document source (vérifiée par rendu visuel,
--    PAS une erreur d'extraction) : R3.3 et R3.4 sont formulées
--    négativement ("il ne faut probablement pas…") mais imprimées "GRADE
--    2+" par la source elle-même, alors que sa propre Méthodologie définit
--    2+ = "il faut probablement faire" et 2- = "il faut probablement ne
--    pas faire". Le tag imprimé fait foi (chippé '2+' tel quel ci-dessous) ;
--    l'incohérence n'est pas corrigée silencieusement.
--
-- NOUVELLE DISCLOSURE (trouvée à la lecture de cette migration, PAS
-- signalée par la fiche source elle-même ni par son panneau méthodologique)
-- : R5.4 présente EXACTEMENT LE MÊME type d'incohérence que R3.3/R3.4 —
-- formulée négativement ("il ne faut probablement pas utiliser en routine
-- […] un monitorage de l'oxygénation cérébrale…") mais imprimée "GRADE 2+
-- (ACCORD FORT)" à la fois dans le texte source brut
-- (`rfe-sfar-website/sources/anesthesie_sujet_age.txt`, ligne 846, vérifié
-- directement contre le texte source par cette migration) ET dans le JSON
-- construit (chip "2+"). Le tag imprimé "2+" fait foi ci-dessous (R5.4),
-- exactement comme pour R3.3/R3.4 — À VÉRIFIER par un relecteur humain, et
-- à reporter dans la disclosure méthodologique de la fiche
-- rfe-sfar-website elle-même (qui ne mentionne actuellement que R3.3/R3.4),
-- hors périmètre de ce script de migration SQL.
--
-- PÉRIMÈTRE — volontairement pas migré (disclosure, pas un oubli) :
-- le "TABLEAU I — Délai d'intervention des FESF" (8 références
-- bibliographiques avec leur proportion de patients opérés dans les 24h) :
-- donnée épidémiologique de contexte appuyant R4.1, pas une proposition
-- clinique distincte.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SOFCOT (orthogériatrie), SFGG et SFPC, co-auteurs de cette RFE au même
--    titre que la SFAR, ne figurent pas dans le seed Annexe B — seule la
--    SFAR est liée en `document_societies`, même traitement que
--    `ecbu`/0002, `aap_endoprotheses_coronaires`/0062 et
--    `bris_dentaires`/0063.
-- 2. `population` laissé NULL sur les 26 lignes : le document entier cible
--    une population unique (sujet âgé, modèle FESF), déjà dans le titre.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Anesthésie du sujet âgé : l''exemple de fracture de l''extrémité supérieure du fémur',
  'RFE', 'fr', '2017-09-22',
  'https://sfar.org/anesthesie-du-sujet-age-lexemple-de-fracture-de-lextremite-superieure-du-femur/',
  'https://sfar.org/wp-content/uploads/2019/10/rfe-anesthesie-du-sujet-age.pdf',
  'GRADE® — force 1+/1-/2+/2- ou avis d''experts (AE), et accord du vote Delphi/GRADE Grid (fort >= 70% par défaut, faible pour R1.4/R5.1 seulement) imprimés côte à côte. Bug d''extraction PDF corrigé (GRADE "2S"/"1S" -> "2-"/"1-" pour R5.1/R6.1/R8.1, vérifié par rendu visuel 200dpi). Incohérence interne disclosée par la source pour R3.3/R3.4 (formulation négative, tag imprimé "2+") ; incohérence du même type trouvée par cette migration pour R5.4 (non signalée par la fiche source elle-même), vérifiée directement contre le texte source brut.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/anesthesie-du-sujet-age-lexemple-de-fracture-de-lextremite-superieure-du-femur/'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/anesthesie-du-sujet-age-lexemple-de-fracture-de-lextremite-superieure-du-femur/'
  and s.slug in ('anesthesie_reanimation', 'geriatrie', 'chirurgie_orthopedique_et_traumatologique')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/anesthesie-du-sujet-age-lexemple-de-fracture-de-lextremite-superieure-du-femur/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000064-R01', 'Il faut réaliser un score de Lee classique pour évaluer le risque cardiovasculaire. Sa VPN reste > 98 % quel que soit l''âge pour les patients peu à risque (RCRI = 1, 63 % des patients de plus de 85 ans dans une étude danoise de 257 342 patients) — pas d''examen complémentaire inutile chez eux ; sa VPP pour prédire une complication cardiaque postopératoire augmente avec l''âge (jusqu''à 6,5 % si > 85 ans et RCRI > 1).', '1+', 'Q1 — Risque cardiovasculaire, fonctions cognitives, fonction rénale'),
  ('MG-ANES-000064-R02', 'Pour un score de Lee de classe I, l''ECG est suffisant. Pour une classe > I, chirurgie à risque majeur et capacité à l''effort difficilement évaluable par l''interrogatoire : il faut probablement affiner le risque postopératoire par le dosage de biomarqueurs et/ou un test cardiopulmonaire.', '2+', 'Q1 — Risque cardiovasculaire, fonctions cognitives, fonction rénale'),
  ('MG-ANES-000064-R03', 'Évaluer le risque de confusion ou de troubles cognitifs postopératoires en repérant en préopératoire une plainte cognitive, des troubles de l''humeur et/ou une maladie neurodégénérative (interrogatoire ciblé ; le 6-CIT, rapide [3 min], a une bonne sensibilité/spécificité comparé au MMSE [15 min]).', 'AE', 'Q1 — Risque cardiovasculaire, fonctions cognitives, fonction rénale'),
  ('MG-ANES-000064-R04', 'Évaluer probablement la fonction rénale en préopératoire selon 2 situations : situation stable et chirurgie programmée (RFE 2012 examens préinterventionnels) ; insuffisance rénale aiguë (RFE 2015 IRA périopératoire). Interrompre les antihypertenseurs au long cours 48-72 h autour de la chirurgie pour éviter une hypovolémie source d''IRA iatrogène. (accord faible)', '2+', 'Q1 — Risque cardiovasculaire, fonctions cognitives, fonction rénale'),
  ('MG-ANES-000064-R05', 'Prise en charge multidisciplinaire spécialisée périopératoire associant urgentistes, anesthésistes-réanimateurs, chirurgiens, gériatres, pharmaciens et soignants, afin d''améliorer le devenir postopératoire des patients âgés opérés en chirurgie orthopédique — 46/58 (79 %) des études d''évaluation orthogériatrique rapportent un bénéfice ; plusieurs recommandations internationales (NICE, AAOS, AAGBI, New Zealand Guidelines, SIGN, Clinical Excellence Commission australienne) convergent vers ce modèle.', '1+', 'Q2 — Programme spécifique & chirurgie ambulatoire'),
  ('MG-ANES-000064-R06', 'Privilégier la chirurgie ambulatoire chez le patient âgé quel que soit son âge — semble ne pas augmenter, voire diminuer, les complications postopératoires (dysfonction cognitive, morbidité cardiorespiratoire), à condition d''optimiser la période peropératoire (hémodynamique, respiratoire, thermorégulation) ; surveillance postopératoire du globe vésical et de la douleur particulièrement importante.', 'AE', 'Q2 — Programme spécifique & chirurgie ambulatoire'),
  ('MG-ANES-000064-R07', 'Identifier les médicaments à risque de confusion postopératoire (benzodiazépines à demi-vie longue, antidépresseurs tricycliques et IMAO B, antihistaminiques, neuroleptiques, morphiniques — mépéridine et tramadol notamment) et alléger les traitements anticholinergiques et sédatifs, si possible via une conciliation médicamenteuse. Ne pas prescrire de novo un de ces produits devant un trouble dysthymique/psycho-comportemental ; préférer alors une benzodiazépine à demi-vie courte ou un IRS/IRS-NA. Ne pas sevrer brutalement un traitement chronique.', '1+', 'Q3 — Gestion des traitements pouvant engendrer une confusion postopératoire'),
  ('MG-ANES-000064-R08', 'Utiliser probablement une échelle objective et validée — Amsterdam Preoperative Anxiety and Information Scale (APAIS, 6 items) ou Hospital Anxiety and Depression Scale (HADS) — pour mesurer l''anxiété préopératoire : l''hétéro-évaluation par le soignant est peu efficiente (chirurgiens et anesthésistes surestiment notablement l''anxiété du patient).', '2+', 'Q3 — Évaluation et prise en charge de l''anxiété préopératoire'),
  ('MG-ANES-000064-R09', 'Pour l''anxiolyse, il ne faut probablement pas utiliser d''agent médicamenteux — nombreuses approches non pharmacologiques efficaces (information/éducation, hypnose, écoute musicale).', '2+', 'Q3 — Évaluation et prise en charge de l''anxiété préopératoire (incohérence source disclosée : formulation négative, tag imprimé "2+")'),
  ('MG-ANES-000064-R10', 'Lorsqu''une prémédication pharmacologique est envisagée, il ne faut probablement pas administrer d''hydroxyzine (ANSM : risques anticholinergiques — confusion, tachycardie, hypotension, rétention urinaire), de gabapentine ni de prégabaline (données insuffisantes pour conclure).', '2+', 'Q3 — Évaluation et prise en charge de l''anxiété préopératoire (incohérence source disclosée : formulation négative, tag imprimé "2+")'),
  ('MG-ANES-000064-R11', 'Si une prémédication médicamenteuse est requise, il faut probablement privilégier une benzodiazépine ou apparenté à demi-vie courte — l''âge > 60 ans et/ou une prémédication majorent le risque de complications respiratoires postopératoires ; poursuivre un traitement chronique par benzodiazépine pour éviter un syndrome de sevrage.', '2+', 'Q3 — Évaluation et prise en charge de l''anxiété préopératoire'),
  ('MG-ANES-000064-R12', 'Réaliser la chirurgie d''une FESF dans les 48 heures suivant l''admission du patient afin de réduire la mortalité postopératoire — une méta-analyse de 35 études (191 873 patients) montre qu''une chirurgie précoce réduit la mortalité (OR 0,74 [0,67 ; 0,81]) ; retarder la chirurgie reste prudent pour les patients ayant des situations pathologiques instables.', '1+', 'Q4 — Délai d''intervention de la FESF'),
  ('MG-ANES-000064-R13', 'Il ne faut probablement pas réaliser de monitorage systématique du débit cardiaque pour diriger le remplissage vasculaire peropératoire chez les patients âgés présentant une FESF — une méta-analyse Cochrane récente conclut à l''absence de preuve d''amélioration du devenir avec ces stratégies d''optimisation. Chez les patients à risque accru de complications de par leurs comorbidités, il reste recommandé de titrer le remplissage en se guidant sur le volume d''éjection systolique (RFE SFAR 2013). (accord faible)', '2-', 'Q5 — Monitorage hémodynamique, pression artérielle, oxygénation cérébrale'),
  ('MG-ANES-000064-R14', 'Maintenir probablement la pression artérielle moyenne peropératoire au-dessus d''un seuil correspondant à 70 % de la PAM de référence mesurée avant l''intervention, d''autant plus que le patient présente des facteurs de risque de complications postopératoires — plus de 50 définitions de l''hypotension existent dans la littérature, sans seuil commun établi ; le seuil de PAM est préféré à la PAS (moins sujette aux distorsions de mesure).', '2+', 'Q5 — Monitorage hémodynamique, pression artérielle, oxygénation cérébrale'),
  ('MG-ANES-000064-R15', 'Traiter probablement sans délai toute hypotension peropératoire chez le sujet âgé afin de limiter le risque de complications rénales ou myocardiques.', '2+', 'Q5 — Monitorage hémodynamique, pression artérielle, oxygénation cérébrale'),
  ('MG-ANES-000064-R16', 'Il ne faut probablement pas utiliser en routine, chez le sujet âgé, un monitorage de l''oxygénation cérébrale (spectroscopie proche infrarouge, rSO2) pour des chirurgies ne présentant pas de risque neurologique spécifique — littérature de (très) faible qualité, essentiellement observationnelle, méthodologies hétérogènes.', '2+', 'Q5 — Monitorage hémodynamique, pression artérielle, oxygénation cérébrale (NOUVELLE incohérence source trouvée par cette migration : formulation négative, tag imprimé "2+" — voir commentaire de tête)'),
  ('MG-ANES-000064-R17', 'Monitorer la température centrale de tout sujet âgé opéré afin de détecter et prévenir les conséquences de l''hypothermie — vasoconstriction et frissons moins efficaces avec le vieillissement, seuil vasoconstricteur abaissé d''environ 1 °C entre 60-80 ans vs 30-50 ans ; les recommandations générales sur l''hypothermie périopératoire de l''adulte s''appliquent tout particulièrement au sujet âgé.', '1+', 'Q5 — Monitorage de la température centrale'),
  ('MG-ANES-000064-R18', 'Il ne faut pas privilégier une technique d''anesthésie (AG vs ALR) pour diminuer la mortalité après chirurgie de la FESF — aucune étude prospective randomisée ne permet de trancher ; études rétrospectives contradictoires ; la mortalité postopératoire est probablement multifactorielle, l''anesthésie jouant un rôle à court terme mais pas à moyen/long terme.', '1-', 'Q6 — Techniques et agents anesthésiques'),
  ('MG-ANES-000064-R19', 'Lors d''une anesthésie générale, effectuer une titration avec des agents anesthésiques de courte durée d''action, à des doses adaptées à la pharmacologie du patient âgé et à un monitorage de la profondeur de l''anesthésie — pharmacocinétique/pharmacodynamique des hypnotiques et morphiniques modifiées par le vieillissement (pas les curares) ; induction progressive par titration (propofol ~1 mg/kg lentement, ou AIVOC modèle de Schnider) ; seul l''étomidate prévient avec certitude l''hypotension à l''induction ; rémifentanil particulièrement utile (clairance réduite, sensibilité aux morphiniques augmentée) ; sugammadex peut éviter l''anticholinergique après rocuronium ; protoxyde d''azote souvent mal toléré, à éviter.', 'AE', 'Q6 — Techniques et agents anesthésiques'),
  ('MG-ANES-000064-R20', 'Réduire, ou titrer, les doses d''anesthésiques locaux lors d''une rachianesthésie pour réduire les hypotensions peropératoires — pharmacocinétique et pharmacodynamique des anesthésiques locaux modifiées par le vieillissement ; une rachianesthésie titrée (cathéter) réduit les épisodes hypotensifs versus une injection unique ; monitorer la profondeur de la sédation associée pour éviter une sédation trop profonde.', '1+', 'Q6 — Techniques et agents anesthésiques'),
  ('MG-ANES-000064-R21', 'Mettre probablement en place un programme de prévention non médicamenteuse de la confusion postopératoire, favorisant la ré-afférentation sensorielle, l''orientation temporo-spatiale, le rythme veille-sommeil, et contrôlant hydratation, douleur et iatrogénie — le programme non pharmacologique « Elder Life Program » (ELP) diminue l''incidence (15,5 % vs 9,9 %) et la durée du syndrome confusionnel en médecine ; une consultation gériatrique dans les 48 h préop ou 24 h postop réduit l''incidence (50 % vs 32 %) et l''intensité des épisodes chez les patients de plus de 65 ans.', '1+', 'Q7 — Décompensations cognitives postopératoires'),
  ('MG-ANES-000064-R22', 'En cas de confusion, identifier probablement les facteurs favorisants, rechercher et traiter une cause directe pour en limiter l''intensité et la durée — traitement associant prise en charge de la cause directe, mesures de prévention, et usage minimum de psychotropes sédatifs (uniquement en cas de trouble du comportement mettant en danger le patient et/ou son entourage).', '2+', 'Q7 — Décompensations cognitives postopératoires'),
  ('MG-ANES-000064-R23', 'Administrer probablement une benzodiazépine à demi-vie courte ou un neuroleptique de dernière génération en cas d''anxiété majeure ou de trouble du comportement, pour limiter le danger induit pour le patient et/ou son entourage.', '2+', 'Q7 — Décompensations cognitives postopératoires'),
  ('MG-ANES-000064-R24', 'N''utiliser la contention physique qu''en dernier recours et pour une durée la plus courte possible, réévaluée à court terme.', 'AE', 'Q7 — Décompensations cognitives postopératoires'),
  ('MG-ANES-000064-R25', 'Il ne faut probablement pas infiltrer en intra-articulaire et/ou en sous-cutané avec des anesthésiques locaux en cas de chirurgie après fracture du col fémoral et/ou d''arthroplastie de hanche — analgésie obtenue inconstante, dépendante de la technique ; une méta-analyse (756 patients d''arthroplastie de hanche) ne montre pas d''effet analgésique en période postopératoire immédiate en cas de stratégie multimodale associée.', '2-', 'Q8 — Analgésie postopératoire'),
  ('MG-ANES-000064-R26', 'Réaliser probablement un bloc fémoral ou iliofascial pour assurer l''analgésie en cas de FESF — une revue Cochrane (17 études, 888 patients) montre une diminution des scores de douleur et de la consommation d''antalgiques de secours, sans complication majeure ni surrisque d''événement indésirable ; le bénéfice est plus net lors de la mobilisation de la hanche qu''au repos, et le taux de confusion postopératoire est atténué chez les patients à risque moyen (pas chez les patients à risque élevé).', '2+', 'Q8 — Analgésie postopératoire')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/anesthesie-du-sujet-age-lexemple-de-fracture-de-lextremite-superieure-du-femur/'
on conflict (recommendation_code) do nothing;
