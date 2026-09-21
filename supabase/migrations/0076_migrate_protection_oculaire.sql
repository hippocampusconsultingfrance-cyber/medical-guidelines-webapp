-- Migration : Protection oculaire en anesthésie et réanimation (RFE commune
-- SFAR, Société française d'ophtalmologie [SFO], SRLF, 2016 ; Anesth Reanim.
-- 2016, ANREA-135, doi 10.1016/j.anrea.2016.05.002 ; texte validé par le
-- Conseil d'administration de la SFAR le 14/03/2016).
-- Source : rfe-sfar-website/build/content_protection_oculaire.json (12
-- recommandations atomiques : R1.1-R1.6 chapitre 1 "lésions cornéennes en
-- anesthésie", R2.1-R2.2 chapitre 2 "lésions cornéennes en réanimation",
-- R3.1-R3.4 chapitre 3 "lésions rétiniennes [OACR/NOIA]" — chaque ligne du
-- contenu source est déjà une unité "Réf. | Recommandation | Grade" à un
-- seul sujet et un seul grade ; aucune fragmentation ni fusion supplémentaire
-- n'a été nécessaire au-delà de la structure déjà atomique du document. Le
-- contenu intro/méthodologie/légende et le panneau "Sources et traçabilité"
-- ne sont PAS eux-mêmes migrés en recommandations distinctes : ce sont des
-- panneaux de contexte/disclosure, sans énoncé "il faut/il est recommandé"
-- propre — le document se déclare lui-même porteur de "12 recommandations",
-- nombre confirmé par recomptage exhaustif du corps du texte (voir
-- disclosure méthodologique ci-dessous), donc 12 est le périmètre retenu.
--
-- ⚠️ PROVENANCE — KNOWN DRIFT, DISCLOSURE OBLIGATOIRE (même statut que
-- `examens_preinterventionnels`/0065 et `tih_2002`/0072) : `content_
-- protection_oculaire.json` a été récupéré depuis l'Artifact publié en
-- ligne (session du 2026-09-13, commit `71d3d9f` de rfe-sfar-website —
-- "Add fiche 64 ... + recover protection_oculaire drift") — AUCUN
-- `fiche_protection_oculaire.py` ni PDF source n'a jamais été committé
-- dans ce dépôt. Ce contenu N'A PAS suivi le pipeline de triple-lecture +
-- audit indépendant normalement exigé par ce projet (build → QA visuelle
-- page par page → audit indépendant en aveugle) et N'A PAS été re-vérifié
-- contre le PDF source par cette migration : le PDF source n'a pas été
-- téléchargé ni lu dans le cadre de ce travail. Le commit qui a recouvré
-- ce contenu déclare EXPLICITEMENT que la décision de "publier tel quel
-- ou tenir en réserve pour une reconstruction depuis le PDF source" reste
-- OUVERTE et pendante d'une décision du porteur de projet — voir la PR
-- ouverte sur rfe-sfar-website évoquée dans ce commit. Cette migration ne
-- préjuge PAS de cette décision : le statut `draft` (jamais `active`
-- directement) garantit qu'aucune ligne ci-dessous n'est visible/publiée
-- sans relecture humaine explicite, exactement comme toute autre ligne de
-- ce système — migrer en `draft` est sans risque et n'équivaut PAS à
-- trancher la question de publication du contenu recouvré.
--
-- SOURCE_URL — le contenu construit lui-même (content_protection_
-- oculaire.json) ne cite AUCUNE URL (ni dans son panneau "Document
-- source", ni ailleurs) : seuls un titre, des auteurs, une référence de
-- revue et un DOI sont donnés. L'URL utilisée ci-dessous vient de
-- `rfe-sfar-website/build/library_final.json` (recherche "oculaire" —
-- exactement 1 correspondance) : titre "Protection oculaire en
-- Anesthésie et Réanimation", exact_date 2016-03-21, status "en vigueur"
-- (pas d'obsolescence signalée dans l'index), href et direct_pdf_url
-- utilisés respectivement comme documents.source_url et documents.pdf_url
-- ci-dessous. Titre, sujet et année correspondent exactement au contenu
-- construit — correspondance jugée fiable, mais PAS vérifiée contre la
-- page 1 du PDF source lui-même (non téléchargé, cf. disclosure ci-
-- dessus) : à re-confirmer lors d'une reconstruction depuis le PDF.
--
-- MÉTHODOLOGIE — GRADE® : force 1+ ("il faut faire") / 2+ ("il faut
-- probablement faire") ou avis d'experts (AE) quand aucune méta-analyse
-- ne permettait d'appliquer GRADE en totalité (revue systématique puis
-- vote Delphi, validé si ≥ 70 % d'accord). Sur les 12 recommandations :
-- 1× grade 1+ (R1.1), 2× grade 2+ (R1.6, R2.2), 9× avis d'experts (AE).
-- `grade` reproduit tel quel le chip source ('1+', '2+' ou 'AE') ;
-- `evidence_level` laissé NULL sur les 12 lignes — aucun système de
-- niveau de preuve distinct de ce grade n'est identifié dans le contenu
-- construit.
--
-- ⚠️ DISCLOSURE — INCOHÉRENCE INTERNE AU DOCUMENT SOURCE (reproduite du
-- contenu construit lui-même, pas une observation nouvelle de cette
-- migration) : le paragraphe de méthodologie du contenu construit
-- affirme un total de "10 recommandations", mais sa propre répartition
-- annoncée dans la même phrase (1 forte + 2 faibles + 9 avis d'experts)
-- totalise 12 — et le recomptage exhaustif du corps du texte confirme
-- exactement 12 recommandations numérotées (R1.1 à R3.4). Les deux
-- chiffres ("10" vs "12") sont disclosés tels quels ici ; aucun n'est
-- deviné "le bon". Cette migration retient 12 (le compte vérifiable par
-- énumération directe des lignes R1.1-R3.4), pas le "10" d'ouverture.
--
-- ⚠️ DISCLOSURE — "Accord FORT" du vote Delphi : le contenu construit
-- indique que ce tag n'est imprimé individuellement qu'à côté des 3
-- recommandations gradées GRADE (R1.1, R1.6, R2.2), jamais réimprimé
-- individuellement à côté des 9 avis d'experts, bien qu'un paragraphe de
-- synthèse affirme globalement "un accord fort [...] pour la totalité des
-- recommandations". Le schéma `recommendations` n'a pas de colonne dédiée
-- à ce tag de consensus Delphi (distincte de `grade`) : cette nuance
-- n'est donc PAS portée par une colonne séparée ci-dessous, uniquement
-- disclosed ici — aucune valeur n'est inventée pour la simuler.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Sur les 9 recommandations taguées "avis d'experts" (AE) ci-dessous,
--    6 emploient dans leur énoncé la formule "il est probablement
--    recommandé"/"il faut probablement" (R1.4, R1.6-style, R2.1, R3.1,
--    R3.2, R3.3, R3.4) — formule que le paragraphe méthodologique du
--    contenu construit associe explicitement au grade GRADE 2+ ("force
--    1+/2+ [« il faut/probablement faire »] ou avis d'experts"). Ce
--    chevauchement de formulation entre grade GRADE 2+ et avis d'experts
--    (AE) peut refléter un choix rédactionnel volontaire de la source
--    (un avis d'experts peut légitimement s'exprimer avec une prudence
--    "probable" sans que cela implique un grade GRADE formel) OU un
--    artefact de la récupération recouvrée sans PDF source. Le chip
--    explicite du contenu construit (AE) est reproduit tel quel dans
--    `grade` ci-dessous dans les deux cas — AUCUN grade n'est réattribué
--    à '2+' par déduction de la formulation ; à confirmer contre le PDF
--    source lors d'une reconstruction complète.
-- 2. SFO (Société française d'ophtalmologie), co-autrice de cette RFE au
--    même titre que SFAR et SRLF (citée explicitement par le contenu
--    construit et par la RFE elle-même), ne figure PAS dans le seed
--    Annexe B (`public.societies`) : seules SFAR et SRLF (toutes deux
--    dans le seed) sont liées en `document_societies` ci-dessous — même
--    cas de figure que `allergie_prevention`/0006 (SFA absente) et
--    `tih_2002`/0072 (GEHT absent).
-- 3. `population` n'est renseigné que pour R2.1/R2.2 (sous-groupe de
--    patients de réanimation explicitement nommé par la source) ; les
--    contextes chirurgicaux cités par R1.4/R1.5/R3.1-R3.4 ("chirurgies à
--    risque", "chirurgie du rachis en décubitus ventral") sont portés
--    par `condition_topic`, pas par `population` — ce ne sont pas des
--    sous-groupes démographiques/cliniques de patients mais des contextes
--    procéduraux, par cohérence avec l'usage de ces deux colonnes dans le
--    reste du corpus déjà migré (ex. `aap_programmee`/0005).
-- 4. `specialties` liées ci-dessous : `anesthesie_reanimation` (chapitres
--    1 et 3) et `medecine_intensive_reanimation` (chapitre 2, dépistage/
--    lubrification explicitement en réanimation), plus `ophtalmologie`
--    (sujet transversal aux 3 chapitres, RFE co-écrite par la SFO). Pas
--    de spécialité chirurgicale ajoutée (ex. neurochirurgie/orthopédie
--    pour la chirurgie du rachis en décubitus ventral, chapitre 3) : ce
--    n'est qu'un contexte d'exposition au risque cité par la source, pas
--    le sujet chirurgical propre du document.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Protection oculaire en Anesthésie et Réanimation',
  'RFE', 'fr', '2016-03-21',
  'https://sfar.org/protection-oculaire-en-anesthesie-et-reanimation/',
  'https://sfar.org/wp-content/uploads/2016/03/Protection-oculaire-en-Anesthesie-et-Reanimation-1.pdf',
  'GRADE® : force 1+ ("il faut faire") / 2+ ("il faut probablement faire") ou avis d''experts (AE) quand aucune méta-analyse ne permettait d''appliquer GRADE en totalité (revue systématique puis vote Delphi, validé si >= 70% d''accord). 12 recommandations reproduites (1 grade 1+, 2 grade 2+, 9 avis d''experts) ; le paragraphe de méthodologie de la source annonce lui-même "10 recommandations" mais sa propre répartition et le recomptage direct du corps du texte donnent 12 — incohérence interne disclosed, non résolue. "Accord FORT" du vote Delphi imprimé individuellement uniquement pour les 3 items gradés GRADE (R1.1, R1.6, R2.2), affirmé globalement pour l''ensemble des 12 par un paragraphe de synthèse. CONTENU RECOUVRÉ (KNOWN DRIFT) : extrait de l''Artifact publié en ligne, sans fiche_*.py ni PDF source committé, jamais audité contre le PDF original — voir disclosure de migration.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/protection-oculaire-en-anesthesie-et-reanimation/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'), ('SRLF', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/protection-oculaire-en-anesthesie-et-reanimation/'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'ophtalmologie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.population, v.source_section,
  'https://sfar.org/protection-oculaire-en-anesthesie-et-reanimation/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000076-R01', 'Pour prévenir les lésions cornéennes lors d''une anesthésie générale, une occlusion palpébrale systématique par bandes adhésives seules est recommandée — supérieure ou équivalente aux autres méthodes (pommades, lubrifiants aqueux type méthylcellulose ou gel visqueux, lunettes de protection, lentilles hydrophiles, suture palpébrale, pansements hydrogel ou bio-occlusifs), avec moins d''effets indésirables. La simple fermeture manuelle de l''œil s''accompagne d''une incidence plus élevée de lésions cornéennes (10 % sur 300 « yeux », dont 90 % dans le groupe fermeture manuelle contre 6,6 % dans le groupe bandes adhésives).', '1+', 'Occlusion palpébrale — méthode de référence', null, 'Chapitre 1 — Prévention des lésions cornéennes en anesthésie'),
  ('MG-ANES-000076-R02', 'En dehors d''une induction en séquence rapide, l''occlusion palpébrale est recommandée dès la perte du réflexe ciliaire et avant l''intubation trachéale, afin de réduire le risque de lésions traumatiques de la cornée par un traumatisme direct (montres, badges, stéthoscopes, laryngoscope).', 'AE', 'Moment de l''occlusion palpébrale', null, 'Chapitre 1 — Prévention des lésions cornéennes en anesthésie'),
  ('MG-ANES-000076-R03', 'Il est recommandé d''obtenir l''occlusion complète de l''œil en apposant jointivement la paupière supérieure et inférieure et de vérifier régulièrement l''efficacité de cette occlusion — une formation obligatoire sur ce point a permis de diviser par 3 l''incidence des lésions de cornée dans une étude de cohorte avant/après.', 'AE', 'Technique et vérification de l''occlusion complète', null, 'Chapitre 1 — Prévention des lésions cornéennes en anesthésie'),
  ('MG-ANES-000076-R04', 'Pour les chirurgies à risque (tête et cou, procédure en position ventrale ou latérale), il est probablement recommandé d''utiliser des lubrifiants aqueux sans conservateur et en unidose (méthylcellulose ou gel visqueux) en association à l''occlusion par bandes adhésives — alternative : pansements bio-occlusifs transparents sans lubrifiant.', 'AE', 'Lubrification pour chirurgies à risque', null, 'Chapitre 1 — Prévention des lésions cornéennes en anesthésie'),
  ('MG-ANES-000076-R05', 'Pour les chirurgies à risque, il est recommandé de ne pas utiliser les pommades grasses — la méthylcellulose produit moins d''effets indésirables que les pommades à base de paraffine. Les positions ventrale/latérale et les chirurgies céphaliques/cervicales sont des facteurs de risque ; la durée d''anesthésie n''en est pas un, indépendamment.', 'AE', 'Contre-indication des pommades grasses', null, 'Chapitre 1 — Prévention des lésions cornéennes en anesthésie'),
  ('MG-ANES-000076-R06', 'La mise en place, au sein des structures, d''un programme de formation et d''un protocole de prévention est probablement recommandée pour réduire l''incidence des lésions cornéennes sous anesthésie générale.', '2+', 'Programme de formation et protocole institutionnel', null, 'Chapitre 1 — Prévention des lésions cornéennes en anesthésie'),
  ('MG-ANES-000076-R07', 'Chez les patients à risque (intubés-ventilés, sédatés ou à faible niveau de conscience), il faut probablement dépister les lésions cornéennes par un test à la fluorescéine (ophtalmoscope à lumière bleu-cobalt) — la majorité des lésions sont punctiformes, invisibles à l''œil nu, mais peuvent évoluer vers un ulcère de cornée avec séquelles visuelles. Incidence en réanimation : 8,6 % à 60 % selon les études, pic dans la première semaine d''admission. La sensibilité du dépistage par des réanimateurs formés est proche de celle des ophtalmologistes.', 'AE', 'Dépistage par test à la fluorescéine', 'Patients de réanimation à risque (intubés-ventilés, sédatés ou à faible niveau de conscience)', 'Chapitre 2 — Prévention des lésions cornéennes en réanimation'),
  ('MG-ANES-000076-R08', 'Chez les patients de réanimation intubés-ventilés, il faut probablement utiliser du gel aqueux ou des chambres humides plutôt que des larmes artificielles — une méta-analyse de 7 études prospectives randomisées (n = 343 à 701 selon l''unité d''analyse) montre une réduction du risque de lésions avec la chambre humide par rapport aux larmes artificielles (RR 0,13 ; IC95 % 0,05-0,35), mais la chambre humide n''est pas supérieure au gel (RR 0,81 ; IC95 % 0,51-1,29). Données insuffisantes sur l''occlusion palpébrale, associée ou non à une lubrification.', '2+', 'Lubrification en réanimation — gel aqueux ou chambre humide', 'Patients de réanimation intubés-ventilés', 'Chapitre 2 — Prévention des lésions cornéennes en réanimation'),
  ('MG-ANES-000076-R09', 'Pour prévenir la compression directe du globe oculaire et les OACR en chirurgie du rachis en décubitus ventral (d''autant plus que la durée est longue), il est probablement recommandé d''utiliser des têtières adaptées garantissant l''absence de compression directe du globe (tête en position neutre, têtière à prise osseuse directe type Mayfield, ou coussin spécialement découpé permettant de contrôler les globes sans contact ni manipulation du patient).', 'AE', 'Têtières adaptées — chirurgie du rachis en décubitus ventral', null, 'Chapitre 3 — Prévention des lésions rétiniennes (OACR et NOIA)'),
  ('MG-ANES-000076-R10', 'Il est probablement recommandé de contrôler l''absence de toute compression extrinsèque de la sphère oculaire tout au long de l''intervention. Dans le registre ASA des pertes de vision peropératoires, toutes les OACR (n = 10) étaient unilatérales, aucune n''avait eu de cadre de Mayfield et 70 % présentaient les stigmates d''un traumatisme externe du globe — les têtières « en fer à cheval » peuvent, en cas de déplacement, contribuer à une compression oculaire et une OACR.', 'AE', 'Contrôle continu de l''absence de compression extrinsèque', null, 'Chapitre 3 — Prévention des lésions rétiniennes (OACR et NOIA)'),
  ('MG-ANES-000076-R11', 'Dans la chirurgie de longue durée en décubitus ventral, il est probablement recommandé de préférer un léger proclive à une position de Trendelenburg, pour limiter la pression intraoculaire — le décubitus ventral majore le risque de compression en augmentant la PIO, d''autant plus marqué si associé à un Trendelenburg ; une inclinaison proclive de 10° réduit ce risque.', 'AE', 'Positionnement — proclive plutôt que Trendelenburg', null, 'Chapitre 3 — Prévention des lésions rétiniennes (OACR et NOIA)'),
  ('MG-ANES-000076-R12', 'En chirurgie du rachis hémorragique de longue durée, pour prévenir les NOIA, il est probablement recommandé de limiter l''hypotension artérielle, l''anémie sévère et l''hypovolémie, d''autant plus que le patient est à risque (obésité, sexe masculin, HTA, facteur de risque vasculaire) — le nerf optique ne dispose pas d''une autorégulation aussi efficace que le cerveau ; dans le registre ASA, au moins un facteur de risque vasculaire était présent dans 82 % des cas malgré des patients souvent ASA 1. Facteurs de risque indépendants confirmés en chirurgie du rachis : sexe masculin, obésité, cadre de Wilson (compression abdominale), durée d''intervention longue, faible pourcentage de colloïde dans le remplissage.', 'AE', 'Prévention des NOIA — hémodynamique peropératoire', null, 'Chapitre 3 — Prévention des lésions rétiniennes (OACR et NOIA)')
) as v(code, statement, grade, condition_topic, population, source_section)
where d.source_url = 'https://sfar.org/protection-oculaire-en-anesthesie-et-reanimation/'
on conflict (recommendation_code) do nothing;
