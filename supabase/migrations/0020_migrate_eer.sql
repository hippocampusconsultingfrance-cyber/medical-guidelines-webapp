-- Migration : Épuration extrarénale en réanimation adulte et pédiatrique — Recommandations
-- Formalisées d'Experts sous l'égide de la SRLF, avec la participation de la SFAR, du GFRUP
-- (pédiatrie) et de la SFD (Société francophone de dialyse). Réanimation 2014,
-- doi:10.1007/s13546-014-0917-6. 18 experts, coordination C. Vinsonneau.
-- Source : rfe-sfar-website/build/content_eer.json (78 recommandations numérotées, 4 champs).
--
-- MÉTHODOLOGIE DE COTATION — encore une convention distincte de ce corpus (ni GRADE 1+/2+,
-- ni le RAND/UCLA "Accord fort/faible" n'y est un synonyme de GRADE) : analyse de la
-- littérature selon la méthode GRADE, mais COTATION COLLECTIVE selon la méthode RAND/UCLA :
-- chaque expert cote de 1 (désaccord complet) à 9 (accord complet) sur 2 tours ; médiane
-- 1-3 = désaccord, 4-6 = indécision, 7-9 = accord ; qualifié de « Fort » si l'intervalle de
-- confiance des cotations reste dans une seule des 3 zones, « Faible » s'il empiète sur deux
-- zones. Aucun tag GRADE numérique n'est jamais imprimé à côté d'un item individuel dans
-- cette source (même particularité que la fiche « nutrition » de ce corpus, encore à
-- migrer). Convention retenue ici, disclosure explicite : `grade` reproduit tel quel le chip
-- source ('Fort' / 'Faible'), PAS de conversion vers la notation GRADE 1+/2+/AE utilisée
-- ailleurs dans ce corpus — ce serait inventer une équivalence que la source ne donne pas.
-- `evidence_level` laissé NULL : pas de second axe de cotation distinct dans ce document. La
-- mention « (Avis d'experts) », quand elle est imprimée par la source (littérature
-- insuffisante pour une analyse graduée), est conservée verbatim dans le texte du
-- `statement` — ce n'est PAS un niveau de preuve séparé à extraire, juste une précision
-- textuelle que la source elle-même appose à certaines recommandations tout en leur donnant
-- quand même un tag Fort/Faible.
--
-- COMPTAGE — RECONCILIÉ EXACTEMENT : le contenu construit annonce lui-même "78
-- recommandations numérotées au total sur les 4 champs" et "les 78 recommandations
-- numérotées (1.1-1.5, 2.1.1-2.4.1, 3.1.1-3.4.10, 4.1.1-4.3.3.3)". Le tableau
-- "Réf. | Recommandation | Accord" classique ne couvre que 63 lignes numérotées (jusqu'à
-- 4.2.7) : le champ 4.3 (numéroté 4.3.1-4.3.3.3 dans la source d'après la plage de couverture
-- annoncée) est rendu par le contenu construit sous forme d'un tableau "Étape |
-- Recommandations" à 3 lignes (Au branchement / Pendant la séance / Au débranchement), texte
-- à puces (7+5+3 = 15 items), SANS reproduire les repères Rx.y.z individuels de la source
-- pour ce champ précis — seule la mention "(*Accord faible)" repère les 3 items à accord
-- faible, tous les autres étant Fort par défaut d'après l'en-tête de ce tableau
-- ("Recommandations (toutes Accord fort sauf *)"). 63 + 15 = 78 : reconciliation EXACTE avec
-- le chiffre que la source annonce elle-même — aucune ligne manquante ni surnuméraire.
-- Les 15 items du champ 4.3 sont migrés en R64-R78 ci-dessous, un par item de la liste à
-- puces, avec un `source_section` disant explicitement "numérotation Rx.y.z propre à la
-- source non préservée par le contenu construit" — car je n'ai AUCUN moyen de savoir quel
-- item correspond exactement à quel repère 4.3.1/4.3.2/4.3.3.1/4.3.3.2/4.3.3.3 de la source
-- (le contenu construit ne le dit pas) : disclosure plutôt qu'invention d'une correspondance
-- que je ne peux pas vérifier.
--
-- NORMALISATION GRAMMATICALE (disclosure, pas un ajout de contenu) : les 15 items du champ
-- 4.3 sont, dans la source telle que rendue par le contenu construit, des fragments
-- télégraphiques séparés par « • » (ex. "deux personnes pour réaliser le branchement des
-- lignes"), sans le "Il faut..." utilisé par toutes les autres recommandations du même
-- document. Reformulés en phrases déclaratives complètes commençant par "Il faut..." /
-- "Il faut probablement..." pour rester cohérents avec le style du reste du document — sans
-- ajouter ni retrancher aucune information de fond, uniquement une complétion grammaticale.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. **Collision d'acronyme SFD** : la source cite comme co-participante « la SFD (Société
--    francophone de dialyse) ». Le seed Annexe B de schema_v2.sql contient déjà un acronyme
--    'SFD' ('France') — mais SANS `full_name` renseigné (colonne volontairement NULL,
--    vetting_status='a_valider', cf. commentaire schema_v2.sql section 14). Il est
--    hautement probable que ce 'SFD' du seed désigne une société complètement différente
--    (le champ de spécialités de ce corpus jusqu'ici est dominé par l'anesthésie-réanimation
--    ; le sigle SFD y est plus couramment associé à la Société Française de Diabétologie
--    qu'à une société de dialyse). PAR PRUDENCE, la SFD de cette source n'est PAS liée au
--    'SFD' du seed dans cette migration — collision d'acronyme non résolue silencieusement,
--    à trancher par un relecteur humain disposant du `full_name` réel des deux entités
--    avant toute liaison. GFRUP non plus dans le seed (déjà noté absent pour d'autres
--    documents de ce corpus, ex. curares/anesthésie pédiatrique). Seules SRLF et SFAR sont
--    liées en document_societies pour ce document.
-- 2. **Titre divergent dans library_final.json** : l'entrée `library_final.json` pour ce
--    PDF (`direct_pdf_url` identique) porte le titre « Epuration extrarénale continue en
--    réanimation (à l'exclusion de la dialyse péritonéale) » — alors que le document source
--    réellement lu (titre imprimé par la source elle-même, section "Sources et
--    traçabilité" du contenu construit) est « Épuration extrarénale en réanimation adulte
--    et pédiatrique », et couvre explicitement À LA FOIS l'EER continue ET intermittente,
--    ET un champ dédié à la dialyse péritonéale (3.2, R37-R39 ci-dessous) — donc plus large
--    que ce que le titre de library_final.json laisse penser, et incluant précisément ce
--    que ce titre dit exclure. Le titre du document ci-dessous suit la source elle-même
--    (comme pour les autres migrations de ce corpus, jamais le titre de library_final.json
--    quand il diverge du texte source) — divergence disclosée ici, à vérifier par un
--    relecteur humain.
-- 3. Champ 4.3.3.3 spécifique pédiatrique (R78, nourrisson <15 kg) : seuil "probablement
--    ≤2 mL/kg/min" reproduit tel quel, y compris son caractère "probablement" (Accord
--    faible) — pas de simplification en directive ferme.

insert into public.documents (title, doc_type, original_language, publication_date, doi, source_url, pdf_url, grading_system, freshness_status)
values (
  'Épuration extrarénale en réanimation adulte et pédiatrique',
  'RFE', 'fr', '2014-01-01',
  '10.1007/s13546-014-0917-6',
  'https://sfar.org/wp-content/uploads/2015/10/2_REANIMATION_epuration-extrarenale-en-reanimation-adulte-et-pediatrique.pdf',
  'https://sfar.org/wp-content/uploads/2015/10/2_REANIMATION_epuration-extrarenale-en-reanimation-adulte-et-pediatrique.pdf',
  'Analyse de la littérature selon la méthode GRADE, mais cotation collective selon la méthode RAND/UCLA (2 tours, cotation 1-9 par expert) : chip « Fort » ou « Faible » selon que l''intervalle de confiance des cotations reste dans une seule zone (désaccord/indécision/accord) ou empiète sur deux. Aucun tag GRADE numérique (1+/1-/2+/2-) imprimé par la source. La mention « (Avis d''experts) », quand imprimée, signale une littérature insuffisante pour une analyse graduée mais ne constitue pas un axe de cotation séparé.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/10/2_REANIMATION_epuration-extrarenale-en-reanimation-adulte-et-pediatrique.pdf'
  and s.acronym in ('SRLF', 'SFAR') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/10/2_REANIMATION_epuration-extrarenale-en-reanimation-adulte-et-pediatrique.pdf'
  and s.slug in ('medecine_intensive_reanimation', 'nephrologie', 'anesthesie_reanimation', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.source_section,
  'https://sfar.org/wp-content/uploads/2015/10/2_REANIMATION_epuration-extrarenale-en-reanimation-adulte-et-pediatrique.pdf',
  'draft'
from public.documents d, (values
  ('MG-ANES-000020-R01', 'Il faut initier sans délai l''EER dans les situations mettant en jeu le pronostic vital (hyperkaliémie, acidose métabolique, syndrome de lyse, œdème pulmonaire réfractaire au traitement médical). (Avis d''experts)', 'Fort', null, 'Champ 1 — Critères d''initiation de l''EER (Réf. 1.1)'),
  ('MG-ANES-000020-R02', 'Les données disponibles sont insuffisantes pour définir le délai optimal avant instauration de l''EER en dehors des situations mettant en jeu le pronostic vital. (Avis d''experts)', 'Fort', null, 'Champ 1 — Critères d''initiation de l''EER (Réf. 1.2)'),
  ('MG-ANES-000020-R03', 'Chez l''enfant, il faut probablement considérer la surcharge hydrosodée de plus de 10 % et très probablement de plus de 20 % parmi les critères d''instauration d''une EER. (Avis d''experts)', 'Faible', 'Pédiatrie / nouveau-né', 'Champ 1 — Critères d''initiation de l''EER (Réf. 1.3)'),
  ('MG-ANES-000020-R04', 'Il faut considérer « précoce » l''initiation d''une EER, au stade KDIGO 2 ou dans les 24 heures suivant l''apparition d''une IRA dont la réversibilité semble peu probable. (Avis d''experts)', 'Faible', null, 'Champ 1 — Critères d''initiation de l''EER (Réf. 1.4)'),
  ('MG-ANES-000020-R05', 'Il faut considérer « tardive » l''initiation de l''EER à plus de 48 heures de la survenue d''une IRA KDIGO 3 ou lors de l''apparition d''une situation mettant en jeu le pronostic vital et en rapport avec l''IRA. (Avis d''experts)', 'Faible', null, 'Champ 1 — Critères d''initiation de l''EER (Réf. 1.5)'),
  ('MG-ANES-000020-R06', 'Il faut éviter le recours au site sous-clavier. (Avis d''experts)', 'Fort', null, 'Champ 2.1 — Voies d''abord vasculaire (Réf. 2.1.1)'),
  ('MG-ANES-000020-R07', 'Il faut considérer les sites veineux fémoraux et jugulaires internes droits comme équivalents en termes de complications infectieuses.', 'Fort', null, 'Champ 2.1 — Voies d''abord vasculaire (Réf. 2.1.2)'),
  ('MG-ANES-000020-R08', 'Il faut probablement utiliser le site jugulaire interne pour diminuer le risque infectieux lié au cathéter pour les patients avec un IMC >28 kg/m².', 'Fort', null, 'Champ 2.1 — Voies d''abord vasculaire (Réf. 2.1.3)'),
  ('MG-ANES-000020-R09', 'Il faut considérer les sites veineux fémoraux et jugulaires internes droits comme équivalents en termes de risque de dysfonction de cathéter.', 'Faible', null, 'Champ 2.1 — Voies d''abord vasculaire (Réf. 2.1.4)'),
  ('MG-ANES-000020-R10', 'Il faut probablement réserver le site jugulaire interne gauche comme troisième choix.', 'Fort', null, 'Champ 2.1 — Voies d''abord vasculaire (Réf. 2.1.5)'),
  ('MG-ANES-000020-R11', 'Chez l''enfant, il faut probablement préférer l''abord jugulaire interne droit à l''abord fémoral pour l''enfant de moins de 20 kg (ou si le cathéter est <10F).', 'Faible', 'Pédiatrie / nouveau-né', 'Champ 2.1 — Voies d''abord vasculaire (Réf. 2.1.6)'),
  ('MG-ANES-000020-R12', 'Il faut adapter la taille des cathéters à la morphologie et au poids de l''enfant : 3-6 kg → 6,5-7 F ; 6-10 kg → 8 F ; 10-20 kg → 8-10 F ; 20-30 kg → 10 F ; >30 kg → 11-13 F. (Avis d''experts)', 'Fort', null, 'Champ 2.1 — Voies d''abord vasculaire (Réf. 2.1.7)'),
  ('MG-ANES-000020-R13', 'En site fémoral, il faut utiliser des cathéters de diamètre >12 F et de longueur ≥24 cm. (Avis d''experts)', 'Fort', null, 'Champ 2.1 — Voies d''abord vasculaire (Réf. 2.1.8)'),
  ('MG-ANES-000020-R14', 'Il faut utiliser l''échoguidage pour la mise en place des cathéters d''EER par voie jugulaire interne.', 'Fort', null, 'Champ 2.1 — Voies d''abord vasculaire (Réf. 2.1.9)'),
  ('MG-ANES-000020-R15', 'Il faut probablement utiliser l''échoguidage pour la mise en place des cathéters d''EER par voie fémorale.', 'Faible', null, 'Champ 2.1 — Voies d''abord vasculaire (Réf. 2.1.10)'),
  ('MG-ANES-000020-R16', 'Il faut procéder à l''ablation des cathéters d''EER dès que ceux-ci ne sont plus nécessaires. (Avis d''experts)', 'Fort', null, 'Champ 2.1 — Voies d''abord vasculaire (Réf. 2.1.11)'),
  ('MG-ANES-000020-R17', 'Il ne faut pas utiliser les fistules artérioveineuses en l''absence d''expertise dans le domaine. (Avis d''experts)', 'Fort', null, 'Champ 2.1 — Voies d''abord vasculaire (Réf. 2.1.12)'),
  ('MG-ANES-000020-R18', 'Il ne faut probablement pas utiliser de membranes en cellulose non modifiée (cuprophane) pour la prise en charge des patients en IRA.', 'Fort', null, 'Champ 2.2 — Membranes (Réf. 2.2.1)'),
  ('MG-ANES-000020-R19', 'Il faut utiliser des membranes à haute perméabilité hydraulique (coefficient d''ultrafiltration élevé) pour des techniques convectives d''épuration (hémofiltration). (Avis d''experts)', 'Fort', null, 'Champ 2.2 — Membranes (Réf. 2.2.2)'),
  ('MG-ANES-000020-R20', 'En hémodialyse intermittente, il ne faut pas utiliser des membranes à haute perméabilité hydraulique en l''absence de dialysat ultrapure. (Avis d''experts)', 'Fort', null, 'Champ 2.2 — Membranes (Réf. 2.2.3)'),
  ('MG-ANES-000020-R21', 'Il ne semble pas utile d''utiliser une membrane à haute porosité (cut-off élevé) ou à forte capacité d''adsorption pour le traitement du choc septique.', 'Fort', null, 'Champ 2.2 — Membranes (Réf. 2.2.4)'),
  ('MG-ANES-000020-R22', 'Il ne faut probablement pas utiliser de membrane couverte par l''héparine ou captant l''héparine dans le but de diminuer l''anticoagulation du circuit.', 'Fort', null, 'Champ 2.2 — Membranes (Réf. 2.2.5)'),
  ('MG-ANES-000020-R23', 'En épuration intermittente, il faut probablement ne pas faire d''anticoagulation systémique.', 'Faible', null, 'Champ 2.3.1 — Anticoagulation (épuration continue vs intermittente, principe général) (Réf. 2.3.1.1)'),
  ('MG-ANES-000020-R24', 'En épuration continue, il faut probablement privilégier, sauf contre-indication, le recours à l''anticoagulation régionale au citrate par rapport à l''absence d''anticoagulation.', 'Fort', null, 'Champ 2.3.1 — Anticoagulation (épuration continue vs intermittente, principe général) (Réf. 2.3.1.2)'),
  ('MG-ANES-000020-R25', 'En épuration continue, il faut probablement privilégier l''absence d''anticoagulation s''il existe une contre-indication au citrate. (Avis d''experts)', 'Faible', null, 'Champ 2.3.1 — Anticoagulation (épuration continue vs intermittente, principe général) (Réf. 2.3.1.3)'),
  ('MG-ANES-000020-R26', 'Chez l''enfant, il est possible de réaliser l''EER continue sans anticoagulation ou par anticoagulation régionale au citrate, le choix étant guidé par l''expérience de l''équipe. (Avis d''experts)', 'Fort', 'Pédiatrie / nouveau-né', 'Champ 2.3.1 — Anticoagulation (épuration continue vs intermittente, principe général) (Réf. 2.3.1.4)'),
  ('MG-ANES-000020-R27', 'En épuration intermittente, il faut probablement privilégier l''héparine non fractionnée ou de bas poids moléculaire par rapport à d''autres anticoagulants systémiques. (Avis d''experts)', 'Fort', null, 'Champ 2.3.2 — Anticoagulation (choix de l''agent) (Réf. 2.3.2.1)'),
  ('MG-ANES-000020-R28', 'En épuration continue, chez l''adulte, il faut probablement privilégier, sauf contre-indication, l''anticoagulation régionale au citrate, dans le but de prolonger la durée de vie du circuit.', 'Faible', null, 'Champ 2.3.2 — Anticoagulation (choix de l''agent) (Réf. 2.3.2.2)'),
  ('MG-ANES-000020-R29', 'En épuration continue, en présence d''une contre-indication au citrate, il faut probablement privilégier le recours à une anticoagulation par héparine non fractionnée. (Avis d''experts)', 'Fort', null, 'Champ 2.3.2 — Anticoagulation (choix de l''agent) (Réf. 2.3.2.3)'),
  ('MG-ANES-000020-R30', 'Chez l''enfant, en EER continue, il faut utiliser une anticoagulation soit par citrate soit par héparine non fractionnée, le choix étant guidé par l''expérience de l''équipe.', 'Fort', 'Pédiatrie / nouveau-né', 'Champ 2.3.2 — Anticoagulation (choix de l''agent) (Réf. 2.3.2.4)'),
  ('MG-ANES-000020-R31', 'Il faut probablement privilégier l''anticoagulation systémique par héparine aux autres anticoagulants. (Avis d''experts)', 'Fort', null, 'Champ 2.3.3 — Anticoagulation (cas particuliers) (Réf. 2.3.3.1)'),
  ('MG-ANES-000020-R32', 'Chez les patients avec thrombopénie induite à l''héparine (TIH) suspectée ou avérée, en plus de l''interruption du traitement par héparine, il est possible d''utiliser une anticoagulation régionale au citrate en complément de l''anticoagulation de la TIH. (Avis d''experts)', 'Fort', null, 'Champ 2.3.3 — Anticoagulation (cas particuliers) (Réf. 2.3.3.2)'),
  ('MG-ANES-000020-R33', 'Il faut élaborer une démarche qualité pour la surveillance de l''eau osmosée dans le respect des normes réglementaires. (Avis d''experts)', 'Fort', null, 'Champ 2.4 — Eau osmosée (Réf. 2.4.1)'),
  ('MG-ANES-000020-R34', 'Les techniques d''EER continues et intermittentes peuvent être utilisées indifféremment, mais en tenant compte de la disponibilité de la technique et de l''expérience de l''équipe.', 'Fort', null, 'Champ 3.1 — Choix de la méthode d''EER (Réf. 3.1.1)'),
  ('MG-ANES-000020-R35', 'Les techniques d''EER diffusives ou convectives peuvent être utilisées indifféremment, mais en tenant compte de la disponibilité de la technique et de l''expérience de l''équipe.', 'Fort', null, 'Champ 3.1 — Choix de la méthode d''EER (Réf. 3.1.2)'),
  ('MG-ANES-000020-R36', 'Chez les patients cérébrolésés à risque d''hypertension intracrânienne, il faut probablement préférer une technique d''épuration continue ou prolongée à faible clairance (SLED). (Avis d''experts)', 'Fort', null, 'Champ 3.1 — Choix de la méthode d''EER (Réf. 3.1.3)'),
  ('MG-ANES-000020-R37', 'En pédiatrie et chez le nouveau-né, il est possible de faire de la dialyse péritonéale, en particulier en période postopératoire de chirurgie cardiaque à but de déplétion, en raison de sa facilité d''utilisation.', 'Faible', 'Pédiatrie / nouveau-né', 'Champ 3.2 — Dialyse péritonéale (Réf. 3.2.1)'),
  ('MG-ANES-000020-R38', 'En pédiatrie et chez le nouveau-né, il est possible de faire de la dialyse péritonéale à but d''épuration lors d''une IRA sans critère de dialyse en urgence absolue.', 'Faible', 'Pédiatrie / nouveau-né', 'Champ 3.2 — Dialyse péritonéale (Réf. 3.2.2)'),
  ('MG-ANES-000020-R39', 'Chez l''adulte, il ne faut probablement pas recourir à la dialyse péritonéale en première intention.', 'Fort', null, 'Champ 3.2 — Dialyse péritonéale (Réf. 3.2.3)'),
  ('MG-ANES-000020-R40', 'En EER intermittente, il faut probablement que la dose de dialyse minimale délivrée soit de : 1) trois séances par semaine de 4h au moins avec un débit sang >200 mL/min et un débit dialysat >500 mL/min, ou 2) l''obtention d''un Kt/V >3,9 par semaine, ou 3) le maintien d''une urée prédialytique de 20-25 mmol/L.', 'Fort', null, 'Champ 3.3 — Dose de dialyse (Réf. 3.3.1)'),
  ('MG-ANES-000020-R41', 'En EER continue, il faut probablement que la dose de dialyse minimale délivrée soit de 20-25 mL/kg/h d''effluent, obtenus par filtration et/ou diffusion.', 'Fort', null, 'Champ 3.3 — Dose de dialyse (Réf. 3.3.2)'),
  ('MG-ANES-000020-R42', 'Il faut adapter la dose de dialyse délivrée aux besoins du patient en termes de contrôle du métabolisme, d''équilibre électrolytique et acido-basique. Il faut prévenir la survenue d''une hypokaliémie et/ou d''une hypophosphatémie. Il faut adapter la posologie des médicaments éliminés par EER à la dose délivrée. (Avis d''experts)', 'Fort', null, 'Champ 3.3 — Dose de dialyse (Réf. 3.3.3)'),
  ('MG-ANES-000020-R43', 'En EER intermittente, il faut probablement augmenter la durée et/ou la fréquence des séances en cas d''hypercatabolisme et/ou de désordre métabolique sévère et/ou d''une indication à une déplétion hydrosodée. (Avis d''experts)', 'Fort', null, 'Champ 3.3 — Dose de dialyse (Réf. 3.3.4)'),
  ('MG-ANES-000020-R44', 'En EER continue, il ne faut pas, sur la seule présence d''un sepsis, intensifier la dose d''épuration.', 'Fort', null, 'Champ 3.3 — Dose de dialyse (Réf. 3.3.5)'),
  ('MG-ANES-000020-R45', 'Il ne semble pas nécessaire d''utiliser d''héparine pour le rinçage des circuits d''EER. (Avis d''experts)', 'Faible', null, 'Champ 3.4 — Réglages (Réf. 3.4.1)'),
  ('MG-ANES-000020-R46', 'Il ne faut pas réduire les apports nutritionnels chez les patients en EER. (Avis d''experts)', 'Fort', null, 'Champ 3.4 — Réglages (Réf. 3.4.2)'),
  ('MG-ANES-000020-R47', 'En hémofiltration réalisée en post-dilution, il faut ajuster le débit sanguin de façon à garder une fraction de filtration <25 %. (Avis d''experts)', 'Fort', null, 'Champ 3.4 — Réglages (Réf. 3.4.3)'),
  ('MG-ANES-000020-R48', 'En hémodialyse intermittente d''une durée <6h, le débit sanguin doit être entre 200 et 300 mL/min et le débit dialysat ≥500 mL/min pour la plupart des patients. (Avis d''experts)', 'Fort', null, 'Champ 3.4 — Réglages (Réf. 3.4.4)'),
  ('MG-ANES-000020-R49', 'Chez l''enfant, en hémodialyse intermittente d''une durée <6h, le débit sanguin doit débuter à 3 mL/kg/min pour atteindre 5 mL/kg/min lors des sessions suivantes, et le débit de dialysat doit être au minimum de 300 mL/min jusqu''à deux fois le débit sanguin. (Avis d''experts)', 'Fort', 'Pédiatrie / nouveau-né', 'Champ 3.4 — Réglages (Réf. 3.4.5)'),
  ('MG-ANES-000020-R50', 'En hémodialyse intermittente prolongée à faible clairance (SLED), il faut utiliser des débits sang et dialysat inférieurs. (Avis d''experts)', 'Fort', null, 'Champ 3.4 — Réglages (Réf. 3.4.6)'),
  ('MG-ANES-000020-R51', 'Il faut que le branchement des lignes artérielles et veineuses soit réalisé de façon simultanée pour éviter la déplétion volémique. (Avis d''experts)', 'Fort', null, 'Champ 3.4 — Réglages (Réf. 3.4.7)'),
  ('MG-ANES-000020-R52', 'En hémodialyse intermittente, il faut probablement recommander la baisse de la température dans le dialysat pour améliorer la tolérance hémodynamique.', 'Fort', null, 'Champ 3.4 — Réglages (Réf. 3.4.8)'),
  ('MG-ANES-000020-R53', 'En hémodialyse intermittente, il faut probablement augmenter la concentration en sodium dans le dialysat (conductivité) >145 mmol/L pour améliorer la tolérance hémodynamique ou lorsque l''urée est très élevée.', 'Fort', null, 'Champ 3.4 — Réglages (Réf. 3.4.9)'),
  ('MG-ANES-000020-R54', 'En hémodialyse intermittente, il faut probablement utiliser un tampon bicarbonate.', 'Fort', null, 'Champ 3.4 — Réglages (Réf. 3.4.10)'),
  ('MG-ANES-000020-R55', 'La réalisation d''une séance d''EER doit être fondée sur une procédure interne au service comprenant au minimum une prescription et une surveillance spécifiques, la description de la réalisation technique de la séance et des mesures d''hygiène (manipulations, désinfection des moniteurs/générateurs). (Avis d''experts)', 'Fort', null, 'Champ 4.1-4.2 — Procédure de service & cathéters (Réf. 4.1.1)'),
  ('MG-ANES-000020-R56', 'Les équipes médicales et paramédicales doivent être formées, en accord avec les référentiels métiers, pour acquérir les compétences nécessaires à l''utilisation des moniteurs/générateurs, à la prévention et au traitement des complications, et à la traçabilité des événements et procédures d''hygiène. (Avis d''experts)', 'Fort', null, 'Champ 4.1-4.2 — Procédure de service & cathéters (Réf. 4.1.2)'),
  ('MG-ANES-000020-R57', 'Il faut réserver l''utilisation d''un cathéter de dialyse à l''EER. (Avis d''experts)', 'Fort', null, 'Champ 4.1-4.2 — Procédure de service & cathéters (Réf. 4.2.1)'),
  ('MG-ANES-000020-R58', 'Il faut gérer les cathéters d''EER suivant les mêmes recommandations que celles des cathéters veineux centraux. (Avis d''experts)', 'Fort', null, 'Champ 4.1-4.2 — Procédure de service & cathéters (Réf. 4.2.2)'),
  ('MG-ANES-000020-R59', 'Il faut probablement considérer comme critère de dysfonction du cathéter l''impossibilité d''atteindre ou de maintenir un débit de pompe sang nécessaire et suffisant pour délivrer une dose adéquate de traitement. (Avis d''experts)', 'Fort', null, 'Champ 4.1-4.2 — Procédure de service & cathéters (Réf. 4.2.3)'),
  ('MG-ANES-000020-R60', 'Il faut éliminer une hypovolémie en présence d''une dysfonction de cathéter. (Avis d''experts)', 'Fort', null, 'Champ 4.1-4.2 — Procédure de service & cathéters (Réf. 4.2.4)'),
  ('MG-ANES-000020-R61', 'Il faut éliminer une thrombose en présence d''une dysfonction de cathéter non liée à une hypovolémie. (Avis d''experts)', 'Fort', null, 'Champ 4.1-4.2 — Procédure de service & cathéters (Réf. 4.2.5)'),
  ('MG-ANES-000020-R62', 'En hémodialyse intermittente, chez l''adulte, il faut changer le cathéter dès que possible s''il y a eu nécessité d''inverser les lignes, en l''absence d''hypovolémie. (Avis d''experts)', 'Fort', null, 'Champ 4.1-4.2 — Procédure de service & cathéters (Réf. 4.2.6)'),
  ('MG-ANES-000020-R63', 'Il n''est pas possible de recommander un type de verrou plutôt qu''un autre (sérum physiologique, héparine, citrate…). (Avis d''experts)', 'Faible', null, 'Champ 4.1-4.2 — Procédure de service & cathéters (Réf. 4.2.7)'),
  ('MG-ANES-000020-R64', 'Il faut vérifier la perméabilité de l''abord vasculaire avant le branchement.', 'Fort', null, 'Champ 4.3 — Sécurisation, étape « Au branchement » (item 1/7 du bullet-point source ; numérotation Rx.y.z propre à la source non préservée par le contenu construit)'),
  ('MG-ANES-000020-R65', 'Il faut être deux personnes pour réaliser le branchement des lignes.', 'Fort', null, 'Champ 4.3 — Sécurisation, étape « Au branchement » (item 2/7 du bullet-point source ; numérotation Rx.y.z propre à la source non préservée par le contenu construit)'),
  ('MG-ANES-000020-R66', 'Il faut rincer le circuit de façon à ce qu''il y reste le moins d''air possible.', 'Fort', null, 'Champ 4.3 — Sécurisation, étape « Au branchement » (item 3/7 du bullet-point source ; numérotation Rx.y.z propre à la source non préservée par le contenu construit)'),
  ('MG-ANES-000020-R67', 'Il faut garder la connectique visible pendant la séance.', 'Fort', null, 'Champ 4.3 — Sécurisation, étape « Au branchement » (item 4/7 du bullet-point source ; numérotation Rx.y.z propre à la source non préservée par le contenu construit)'),
  ('MG-ANES-000020-R68', 'Il faut prévenir l''agitation du patient.', 'Fort', null, 'Champ 4.3 — Sécurisation, étape « Au branchement » (item 5/7 du bullet-point source ; numérotation Rx.y.z propre à la source non préservée par le contenu construit)'),
  ('MG-ANES-000020-R69', 'Il faut augmenter progressivement le débit sanguin pour vérifier la perméabilité et l''étanchéité du circuit.', 'Fort', null, 'Champ 4.3 — Sécurisation, étape « Au branchement » (item 6/7 du bullet-point source ; numérotation Rx.y.z propre à la source non préservée par le contenu construit)'),
  ('MG-ANES-000020-R70', 'En hémofiltration, il faut démarrer la convection une fois le débit cible atteint.', 'Fort', null, 'Champ 4.3 — Sécurisation, étape « Au branchement » (item 7/7 du bullet-point source ; numérotation Rx.y.z propre à la source non préservée par le contenu construit)'),
  ('MG-ANES-000020-R71', 'Il faut surveiller étroitement les pressions du circuit (artérielle, veineuse, transmembranaire) et la perte de charge.', 'Fort', null, 'Champ 4.3 — Sécurisation, étape « Pendant la séance » (item 1/5 du bullet-point source ; numérotation Rx.y.z propre à la source non préservée par le contenu construit)'),
  ('MG-ANES-000020-R72', 'Il faut fixer les lignes pour éviter toute plicature.', 'Fort', null, 'Champ 4.3 — Sécurisation, étape « Pendant la séance » (item 2/5 du bullet-point source ; numérotation Rx.y.z propre à la source non préservée par le contenu construit)'),
  ('MG-ANES-000020-R73', 'Il faut probablement réduire le débit de la pompe et interrompre la convection lors des mobilisations du patient.', 'Faible', null, 'Champ 4.3 — Sécurisation, étape « Pendant la séance » (item 3/5 du bullet-point source ; numérotation Rx.y.z propre à la source non préservée par le contenu construit)'),
  ('MG-ANES-000020-R74', 'Il faut respecter l''asepsie et éviter toute entrée d''air lors des prélèvements dans le circuit.', 'Fort', null, 'Champ 4.3 — Sécurisation, étape « Pendant la séance » (item 4/5 du bullet-point source ; numérotation Rx.y.z propre à la source non préservée par le contenu construit)'),
  ('MG-ANES-000020-R75', 'Il faut maintenir un haut niveau de sang dans le piège à bulles.', 'Fort', null, 'Champ 4.3 — Sécurisation, étape « Pendant la séance » (item 5/5 du bullet-point source ; numérotation Rx.y.z propre à la source non préservée par le contenu construit)'),
  ('MG-ANES-000020-R76', 'Il faut restituer le sang du circuit au patient au sérum physiologique.', 'Fort', null, 'Champ 4.3 — Sécurisation, étape « Au débranchement » (item 1/3 du bullet-point source ; numérotation Rx.y.z propre à la source non préservée par le contenu construit)'),
  ('MG-ANES-000020-R77', 'Il faut probablement installer le patient en décubitus dorsal pour réduire le risque d''embolie gazeuse.', 'Faible', null, 'Champ 4.3 — Sécurisation, étape « Au débranchement » (item 2/3 du bullet-point source ; numérotation Rx.y.z propre à la source non préservée par le contenu construit)'),
  ('MG-ANES-000020-R78', 'Chez le nourrisson de moins de 15 kg, le débit de restitution doit probablement être inférieur ou égal à 2 mL/kg/min.', 'Faible', 'Pédiatrie / nouveau-né', 'Champ 4.3 — Sécurisation, étape « Au débranchement » (item 3/3 du bullet-point source ; numérotation Rx.y.z propre à la source non préservée par le contenu construit)')
) as v(code, statement, grade, population, source_section)
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/10/2_REANIMATION_epuration-extrarenale-en-reanimation-adulte-et-pediatrique.pdf'
on conflict (recommendation_code) do nothing;
