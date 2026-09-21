-- Migration : Prise en charge des nausées et vomissements postopératoires (NVPO) — Conférence
-- d'experts, texte court, SFAR. Coordonnateur : P. Diemunsch (Strasbourg). 10 chapitres
-- (« Questions ») rédigés par un panel international (France, Belgique, Suisse, Allemagne,
-- Finlande, États-Unis). Ann Fr Anesth Réanim 2008;27:866-878, doi:10.1016/j.annfar.2008.09.004.
-- Champ : adulte ET enfant. Source : rfe-sfar-website/build/content_nvpo.json
-- (53 recommandations graduées, 10 questions).
--
-- MÉTHODOLOGIE — CONVENTION PROPRE À CE DOCUMENT : GRADE pondéré par la balance
-- bénéfices/risques (G1+ « il faut faire », G2+ « il faut probablement faire », G1- « il ne
-- faut pas faire », G2- « il ne faut probablement pas faire ») — PAS de catégorie « avis
-- d'experts » distincte : lorsque les données sont insuffisantes, le panel déclare
-- explicitement ne pas être en mesure de formuler de recommandation (4 occurrences,
-- disclosées ci-dessous, jamais migrées comme lignes graduées). `grade` reproduit tel quel
-- le chip source. `evidence_level` laissé NULL.
--
-- COMPTAGE : la source ne publie pas de chiffre-résumé agrégé du type « N recommandations » —
-- comptage direct des 53 lignes des tableaux "Thème | Recommandation | Grade" des 10
-- questions, aucun écart à signaler faute de total officiel à comparer. Répartition
-- vérifiée : 15×1+, 6×1-, 22×2+, 10×2- = 53.
--
-- PÉRIMÈTRE — volontairement pas migrés :
-- 1. Les 4 items « Pas de recommandation possible » (données insuffisantes), disclosés
--    explicitement par la source elle-même dans les mêmes termes pour chacune de 4
--    substances (dixyrazine, éphédrine, et 2 autres) — cohérent avec le principe de ce
--    projet de ne jamais migrer une absence de recommandation comme une ligne graduée.
-- 2. Les 4 tableaux de référence (Tableau 1 — scores Apfel/Koivuranta de prédiction du
--    risque ; Tableau 2 — pharmacocinétique/posologies des AR-5HT3 adulte ; Tableau 3 —
--    facteurs de risque de NVPO chez l'enfant ; Tableau 4 — posologies des antiémétiques en
--    pédiatrie) et la figure de stratégie "Niveau de risque | Prophylaxie | Traitement de
--    secours" — AUCUN de ces 5 tableaux/figure ne porte de colonne Grade/Accord : ce sont
--    des données de référence (scores, pharmacocinétique, posologies, synthèse stratifiée
--    par niveau de risque), pas des recommandations individuellement graduées par le panel.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Seule la SFAR est société organisatrice de cette conférence d'experts (panel
--    international d'auteurs individuels, pas de co-signataires institutionnels multiples
--    comme pour d'autres documents de ce corpus) — liée seule en document_societies.

insert into public.documents (title, doc_type, original_language, publication_date, doi, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge des nausées et vomissements postopératoires (NVPO)',
  'CE', 'fr', '2008-10-25',
  '10.1016/j.annfar.2008.09.004',
  'https://sfar.org/prise-en-charge-des-nausees-et-vomissements-postoperatoires/',
  'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Prise-en-charge-des-nausees-et-vomissements-postoperatoires.pdf',
  'GRADE, convention de cotation propre au document : G1+ (il faut faire) / G2+ (il faut probablement faire) / G1- (il ne faut pas faire) / G2- (il ne faut probablement pas faire), pondérée par la balance bénéfices/risques. Pas de catégorie « avis d''experts » distincte : items sans recommandation possible déclarés explicitement comme tels par le panel (4 occurrences, non migrées).',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-en-charge-des-nausees-et-vomissements-postoperatoires/'
  and s.acronym = 'SFAR' and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-en-charge-des-nausees-et-vomissements-postoperatoires/'
  and s.slug in ('anesthesie_reanimation', 'pediatrie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.population, v.source_section,
  'https://sfar.org/prise-en-charge-des-nausees-et-vomissements-postoperatoires/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000035-R01', 'Utiliser des scores de prédiction simplifiés pour estimer le risque de NVPO d''un patient donné.', '1+', null, 'Q2 — Facteurs de risque des NVPO chez l''adulte — Thème : Scores de prédiction'),
  ('MG-ANES-000035-R02', 'L''administration prophylactique systématique d''AR-5HT3 n''est pas recommandée.', '1-', null, 'Q3 — Les antagonistes du récepteur 5HT3 (AR-5HT3, « sétrons ») — Thème : Prophylaxie systématique'),
  ('MG-ANES-000035-R03', 'L''administration prophylactique d''un AR-5HT3 est recommandée en fin d''intervention chez les patients à risque.', '1+', null, 'Q3 — Les antagonistes du récepteur 5HT3 (AR-5HT3, « sétrons ») — Thème : Prophylaxie ciblée'),
  ('MG-ANES-000035-R04', 'L''usage d''AR-5HT3 est recommandé dans le cadre de l''approche multimodale des NVPO.', '1+', null, 'Q3 — Les antagonistes du récepteur 5HT3 (AR-5HT3, « sétrons ») — Thème : Approche multimodale'),
  ('MG-ANES-000035-R05', 'L''usage d''AR-5HT3 est recommandé dans le traitement curatif de première intention des NVPO.', '1+', null, 'Q3 — Les antagonistes du récepteur 5HT3 (AR-5HT3, « sétrons ») — Thème : Traitement curatif'),
  ('MG-ANES-000035-R06', 'La dexaméthasone est recommandée dans la prévention des NVPO des patients à risque ; chez les patients à risque élevé, l''association à un AR-5HT3 et/ou au dropéridol est recommandée.', '1+', null, 'Q4 — Corticostéroïdes (dexaméthasone) et dropéridol — Thème : Dexa — prophylaxie'),
  ('MG-ANES-000035-R07', 'Dans l''état actuel des connaissances, la dexaméthasone administrée en peropératoire n''est pas suffisante pour se substituer à l''ajout de dropéridol dans la prévention des NV induits par la morphine en ACP.', '2+', null, 'Q4 — Corticostéroïdes (dexaméthasone) et dropéridol — Thème : Dexa — ACP'),
  ('MG-ANES-000035-R08', 'La dexaméthasone ne doit pas être utilisée seule dans le traitement curatif de NVPO.', '2-', null, 'Q4 — Corticostéroïdes (dexaméthasone) et dropéridol — Thème : Dexa — traitement'),
  ('MG-ANES-000035-R09', 'La dose intraveineuse recommandée de dexaméthasone est comprise entre 4 et 8 mg, administrée à l''induction de l''anesthésie.', '1+', null, 'Q4 — Corticostéroïdes (dexaméthasone) et dropéridol — Thème : Dexa — dose'),
  ('MG-ANES-000035-R10', 'L''administration répétée de dexaméthasone n''a pas été évaluée dans cette indication et ne peut de ce fait pas être recommandée.', '2-', null, 'Q4 — Corticostéroïdes (dexaméthasone) et dropéridol — Thème : Dexa — itération'),
  ('MG-ANES-000035-R11', 'Le dropéridol est recommandé dans la prophylaxie des NVPO chez les patients à risque.', '1+', null, 'Q4 — Corticostéroïdes (dexaméthasone) et dropéridol — Thème : Dropéridol — prophylaxie'),
  ('MG-ANES-000035-R12', 'Le dropéridol est recommandé pour le traitement des NVPO.', '2+', null, 'Q4 — Corticostéroïdes (dexaméthasone) et dropéridol — Thème : Dropéridol — traitement'),
  ('MG-ANES-000035-R13', 'Chez les patients à haut risque, l''association du dropéridol à un AR-5HT3 et/ou à la dexaméthasone peut être recommandée ; le dropéridol est recommandé dans la prévention des NV induits par la morphine en ACP.', '1+', null, 'Q4 — Corticostéroïdes (dexaméthasone) et dropéridol — Thème : Dropéridol — haut risque'),
  ('MG-ANES-000035-R14', 'Le dropéridol devrait être évité dans les syndromes du QT long congénitaux ou acquis.', '2-', null, 'Q4 — Corticostéroïdes (dexaméthasone) et dropéridol — Thème : Dropéridol — QT long'),
  ('MG-ANES-000035-R15', 'Il est recommandé d''utiliser la dose minimale efficace de dropéridol (0,625 à 1,25 mg IV) ; en cas de nécessité, il pourrait être réadministré au bout de 6 heures.', '2+', null, 'Q4 — Corticostéroïdes (dexaméthasone) et dropéridol — Thème : Dropéridol — dose/itération'),
  ('MG-ANES-000035-R16', 'L''aprépitant (40 mg per os, 1 à 3 heures avant l''intervention) peut être utilisé pour la prévention des NVPO.', '2+', null, 'Q5 — Antagonistes du récepteur NK1 (AR-NK1) — Thème : Aprépitant'),
  ('MG-ANES-000035-R17', 'La tolérance et l''efficacité n''ayant pas été établies chez l''enfant et l''adolescent, l''utilisation chez les patients de moins de 18 ans n''est pas recommandée.', '1-', null, 'Q5 — Antagonistes du récepteur NK1 (AR-NK1) — Thème : Enfant/ adolescent'),
  ('MG-ANES-000035-R18', 'Chez les patients à risque opposés à une prophylaxie pharmacologique recherchant des alternatives, une technique par stimulation de points d''acupuncture (point P6) peut être considérée.', '2+', null, 'Q6 — Autres traitements (hors sétrons, dropéridol, stéroïdes, AR-NK1) — Thème : Acupuncture'),
  ('MG-ANES-000035-R19', 'Ni la relaxation, ni l''hypnose ne peuvent être recommandées pour la prise en charge des NVPO.', '2-', null, 'Q6 — Autres traitements (hors sétrons, dropéridol, stéroïdes, AR-NK1) — Thème : Relaxation/ hypnose'),
  ('MG-ANES-000035-R20', 'Les cannabinoïdes ne doivent pas être utilisés pour le contrôle des NVPO.', '1-', null, 'Q6 — Autres traitements (hors sétrons, dropéridol, stéroïdes, AR-NK1) — Thème : Cannabinoïdes'),
  ('MG-ANES-000035-R21', 'L''aromathérapie ne peut être recommandée pour le contrôle des NVPO.', '2-', null, 'Q6 — Autres traitements (hors sétrons, dropéridol, stéroïdes, AR-NK1) — Thème : Aromathérapie'),
  ('MG-ANES-000035-R22', 'La supplémentation en oxygène ne peut être recommandée en tant que mesure de contrôle des NVPO réalisée en peropératoire.', '1-', null, 'Q6 — Autres traitements (hors sétrons, dropéridol, stéroïdes, AR-NK1) — Thème : Oxygène — péropératoire'),
  ('MG-ANES-000035-R23', 'La supplémentation en oxygène ne peut être recommandée en tant que mesure de contrôle des NVPO réalisée en postopératoire.', '2-', null, 'Q6 — Autres traitements (hors sétrons, dropéridol, stéroïdes, AR-NK1) — Thème : Oxygène — postopératoire'),
  ('MG-ANES-000035-R24', 'La période de jeûne doit être compensée par l''administration d''une quantité adéquate de fluide.', '1+', null, 'Q6 — Autres traitements (hors sétrons, dropéridol, stéroïdes, AR-NK1) — Thème : Soluté de remplissage'),
  ('MG-ANES-000035-R25', 'En raison d''une activité antiémétique modeste aux doses faibles et du risque accru d''effets indésirables aux doses élevées, le métoclopramide ne peut être recommandé en antiémétique de première ligne.', '1-', null, 'Q6 — Autres traitements (hors sétrons, dropéridol, stéroïdes, AR-NK1) — Thème : Métoclo- pramide'),
  ('MG-ANES-000035-R26', 'L''halopéridol à petites doses peut être utilisé comme antiémétique pour le contrôle des NVPO.', '2+', null, 'Q6 — Autres traitements (hors sétrons, dropéridol, stéroïdes, AR-NK1) — Thème : Halopéridol — utilisation'),
  ('MG-ANES-000035-R27', 'L''halopéridol ne peut pas être considéré comme un médicament de première ligne dans cette indication.', '2-', null, 'Q6 — Autres traitements (hors sétrons, dropéridol, stéroïdes, AR-NK1) — Thème : Halopéridol — 1ère ligne'),
  ('MG-ANES-000035-R28', 'En l''absence de contre-indication, la scopolamine transdermique peut être considérée en tant qu''antiémétique pour la prévention des NVPO.', '2+', null, 'Q6 — Autres traitements (hors sétrons, dropéridol, stéroïdes, AR-NK1) — Thème : Scopolamine transdermique'),
  ('MG-ANES-000035-R29', 'Les anesthésistes peuvent envisager le recours à la prométhazine ou au dimenhydrinate lorsque les autres antiémétiques dont l''effet est mieux établi ne sont pas disponibles.', '2+', null, 'Q6 — Autres traitements (hors sétrons, dropéridol, stéroïdes, AR-NK1) — Thème : AR-H1 (prométhazine…)'),
  ('MG-ANES-000035-R30', 'Pour la prévention ou le traitement des NVPO, les AR-H2 ne peuvent être recommandés.', '2-', null, 'Q6 — Autres traitements (hors sétrons, dropéridol, stéroïdes, AR-NK1) — Thème : AR-H2'),
  ('MG-ANES-000035-R31', 'Du fait de l''absence de données validées suffisantes, le groupe ne peut recommander le gingembre pour le contrôle des NVPO.', '2-', null, 'Q6 — Autres traitements (hors sétrons, dropéridol, stéroïdes, AR-NK1) — Thème : Gingembre'),
  ('MG-ANES-000035-R32', 'Les anesthésistes peuvent considérer le midazolam en tant qu''alternative lorsque d''autres antiémétiques dont l''effet est mieux établi ne sont pas disponibles.', '2+', null, 'Q6 — Autres traitements (hors sétrons, dropéridol, stéroïdes, AR-NK1) — Thème : Midazolam'),
  ('MG-ANES-000035-R33', 'Pour le contrôle des NVPO établis résistant à d''autres traitements, on peut envisager la perfusion de propofol à petites doses subanesthésiques, sous surveillance par du personnel médical qualifié dans une structure adaptée.', '2+', null, 'Q6 — Autres traitements (hors sétrons, dropéridol, stéroïdes, AR-NK1) — Thème : Propofol à petites doses'),
  ('MG-ANES-000035-R34', 'La prévention antiémétique par un seul agent n''est recommandée que chez des patients à faible risque de NVPO, et seulement si un traitement de secours rapidement efficace peut être assuré sans délai.', '2+', null, 'Q7 — Stratégies de prise en charge des NVPO — Thème : Monothérapie'),
  ('MG-ANES-000035-R35', 'Une combinaison de deux agents antiémétiques au moins doit être utilisée pour la prévention des NVPO chez les patients présentant des risques modérés ou élevés.', '1+', null, 'Q7 — Stratégies de prise en charge des NVPO — Thème : Combinaison'),
  ('MG-ANES-000035-R36', 'Les patients à haut risque doivent bénéficier d''une approche multimodale de prévention des NVPO.', '1+', null, 'Q7 — Stratégies de prise en charge des NVPO — Thème : Multimodal haut risque'),
  ('MG-ANES-000035-R37', 'En l''absence de prophylaxie, les AR-5HT3 sont recommandés pour le traitement de première intention des NVPO.', '1+', null, 'Q7 — Stratégies de prise en charge des NVPO — Thème : Secours — 1ère intention'),
  ('MG-ANES-000035-R38', 'Si une prophylaxie a échoué dans les six heures suivant son administration, il est recommandé d''utiliser pour le traitement de secours un antiémétique d''une autre classe que celle qui a été choisie pour la prophylaxie ; une association d''antiémétiques est raisonnable pour assurer un traitement curatif et une prophylaxie secondaire efficaces.', '2+', null, 'Q7 — Stratégies de prise en charge des NVPO — Thème : Secours — échec prophylaxie'),
  ('MG-ANES-000035-R39', 'Il est recommandé d''utiliser un algorithme pour la prise en charge des NVPO, et d''adapter cette prise en charge aux situations locales ou particulières.', '1+', null, 'Q8 — Intégration des situations locales ou particulières — Thème : Algorithme'),
  ('MG-ANES-000035-R40', 'Cette démarche peut s''inscrire dans le cadre général d''un programme qualité institutionnel.', '2+', null, 'Q8 — Intégration des situations locales ou particulières — Thème : Programme qualité'),
  ('MG-ANES-000035-R41', 'Au-delà des facteurs de risque reconnus, il est recommandé de prendre en compte les situations où les vomissements entraînent un risque particulier pour le patient, de considérer les contraintes locales périopératoires, et de tenir compte des désirs exprimés par le patient.', '1+', null, 'Q8 — Intégration des situations locales ou particulières — Thème : Facteurs suppl.'),
  ('MG-ANES-000035-R42', 'L''identification des facteurs de risque est souhaitable pour établir une stratégie de prise en charge préventive des VPO de l''enfant.', '2+', 'Pédiatrie', 'Q9 — Particularités en chirurgie pédiatrique — Thème : Dépistage'),
  ('MG-ANES-000035-R43', 'Chez les enfants à faible risque, l''administration prophylactique d''antiémétique n''est pas indiquée.', '1-', 'Pédiatrie', 'Q9 — Particularités en chirurgie pédiatrique — Thème : Faible risque'),
  ('MG-ANES-000035-R44', 'Il est recommandé de réduire autant que possible le risque de base, en proposant une technique anesthésique la moins émétisante possible.', '2+', 'Pédiatrie', 'Q9 — Particularités en chirurgie pédiatrique — Thème : Risque de base'),
  ('MG-ANES-000035-R45', 'Il est recommandé d''utiliser une stratégie préventive privilégiant les associations d''antiémétiques, supérieures aux monothérapies, en tenant compte de l''efficacité, des effets secondaires et du coût.', '2+', 'Pédiatrie', 'Q9 — Particularités en chirurgie pédiatrique — Thème : Risque modéré/ élevé'),
  ('MG-ANES-000035-R46', 'L''association thérapeutique préconisée en première intention combine un AR-5HT3 à la dexaméthasone.', '2+', 'Pédiatrie', 'Q9 — Particularités en chirurgie pédiatrique — Thème : 1ère intention'),
  ('MG-ANES-000035-R47', 'Le traitement des NVPO établis ou de leur récidive est extrapolé de celui de l''adulte.', '2+', 'Pédiatrie', 'Q9 — Particularités en chirurgie pédiatrique — Thème : Traitement établi'),
  ('MG-ANES-000035-R48', 'En cas d''échec d''une prophylaxie, il est recommandé d''utiliser une autre classe antiémétique que celle déjà mise en œuvre.', '2+', 'Pédiatrie', 'Q9 — Particularités en chirurgie pédiatrique — Thème : Échec prophylaxie'),
  ('MG-ANES-000035-R49', 'Il est éventuellement possible de réadministrer le même antiémétique après une durée de six heures.', '2+', 'Pédiatrie', 'Q9 — Particularités en chirurgie pédiatrique — Thème : Réadmin. antiémétique'),
  ('MG-ANES-000035-R50', 'Il est recommandé de ne pas réadministrer la dexaméthasone.', '2-', 'Pédiatrie', 'Q9 — Particularités en chirurgie pédiatrique — Thème : Réadmin. dexaméthasone'),
  ('MG-ANES-000035-R51', 'Il est recommandé de n''utiliser le dropéridol qu''en cas d''échec des autres classes et seulement si le patient est hospitalisé.', '2+', 'Pédiatrie', 'Q9 — Particularités en chirurgie pédiatrique — Thème : Dropéridol — usage restreint'),
  ('MG-ANES-000035-R52', 'Il est recommandé d''adopter une stratégie antiémétique prophylactique multimodale chez les patients ambulatoires identifiés à haut risque de NVPO.', '1+', null, 'Q10 — Particularités en chirurgie ambulatoire — Thème : Haut risque ambulatoire'),
  ('MG-ANES-000035-R53', 'Le traitement des NVPO survenant après la sortie repose sur la prescription d''antiémétiques validés en prophylaxie, en changeant de classe et sous une forme galénique adaptée.', '2+', null, 'Q10 — Particularités en chirurgie ambulatoire — Thème : Après la sortie')
) as v(code, statement, grade, population, source_section)
where d.source_url = 'https://sfar.org/prise-en-charge-des-nausees-et-vomissements-postoperatoires/'
on conflict (recommendation_code) do nothing;
