-- Migration : Intubation en urgence d'un adulte hors bloc opératoire et hors unité des soins
-- critiques — Recommandations Formalisées d'Experts (RFE) commune SFAR (coord. Thomas
-- Clavier) et SFMU. Texte validé par les Comités des Référentiels Cliniques SFAR/SFMU le
-- 25/10/2024, CA SFAR le 03/12/2024, CA SFMU le 21/11/2024. Champ : intubation trachéale de
-- l'adulte en situation d'urgence, hors bloc opératoire et hors unité de soins critiques
-- (préhospitalier, urgences, services conventionnels) — complète, sans s'y substituer, les
-- RFE « Intubation difficile et extubation en anesthésie » (0027) et « Intubation et
-- extubation du patient de réanimation » (0028) de ce même corpus. Source :
-- rfe-sfar-website/build/content_intubation_urgence.json.
--
-- MÉTHODOLOGIE : GRADE classique (1+/1-/2+/2-, avis d'experts AE). `grade` reproduit tel
-- quel le chip source. `evidence_level` laissé NULL.
--
-- COMPTAGE — RECONCILIÉ EXACTEMENT, ÉCART EXPLIQUÉ (pas une ligne manquante) : la source
-- annonce elle-même "32 recommandations : 5 GRADE 1, 12 GRADE 2, 15 avis d'experts". Le
-- tableau "Réf. | Recommandation | Grade" classique (champs 1, 2, 3, 4.1-4.2, 5) ne compte
-- que 28 lignes numérotées (1.1 à 5.2) : 5×1+, 8×2+ + 4×2- = 12 Grade 2, 11×AE — soit
-- 5+12+11=28. L'écart de 4 recommandations "avis d'experts" (11 trouvées vs 15 annoncées)
-- correspond EXACTEMENT à la sous-section "Conduite à tenir en cas d'échec d'intubation
-- (R4.3.1 à R4.3.4, avis d'experts, accord fort)" du champ 4 — 4 recommandations
-- individuellement numérotées et gradées par la source, mais rendues par le contenu
-- construit sous forme de DEUX algorithmes-organigrammes parallèles (Figure 3
-- extrahospitalier, Figure 4 intrahospitalier, ~6 étapes chacun) SANS qu'aucune des 6 étapes
-- de chaque algorithme ne soit explicitement rattachée à l'un des 4 repères R4.3.1-R4.3.4 —
-- le contenu construit ne fournit donc aucune correspondance étape→repère récupérable sans
-- deviner laquelle des ~12 étapes combinées correspond à quel R4.3.x. 28 (individuellement
-- gradées et repérées) + 4 (R4.3.1-R4.3.4, algorithme, non décomposé individuellement par le
-- contenu construit) = 32, reconciliation EXACTE avec le total annoncé par la source
-- (5+12+15=32 également vérifié : 5 Grade1 + [8+4]=12 Grade2 + [11+4]=15 AE). Aucune ligne
-- inventée pour combler cet écart — les 4 recommandations R4.3.1-R4.3.4 ne sont PAS migrées
-- individuellement (voir PÉRIMÈTRE ci-dessous), disclosure plutôt qu'invention d'une
-- correspondance étape/repère non vérifiable.
--
-- PÉRIMÈTRE — volontairement pas migrés :
-- 1. R4.3.1 à R4.3.4 (conduite à tenir en cas d'échec d'intubation, avis d'experts, accord
--    fort) — voir disclosure de comptage ci-dessus : ces 4 recommandations existent bien
--    dans la source avec leurs propres repères Rx.y, mais leur contenu individuel n'est pas
--    récupérable depuis le contenu construit (qui ne fournit que les 2 algorithmes complets,
--    Figures 3 et 4, sans rattachement étape→repère). Reproduites intégralement dans la
--    fiche de synthèse elle-même sous forme des deux algorithmes, simplement pas migrées
--    comme 4 lignes `recommendations` individuelles distinctes.
-- 2. 4 questions « sans recommandation possible » (littérature insuffisante), explicitement
--    disclosées par la source : indication de l'intubation en cas d'obstruction des VAS ;
--    usage systématique d'une check-list/aides cognitives ; vidéolaryngoscopie vs
--    laryngoscopie directe en préhospitalier ; optimisation hémodynamique isolée avant
--    induction — cohérent avec le principe de ce projet de ne jamais migrer une absence de
--    recommandation comme une ligne graduée.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SFAR et SFMU (toutes deux dans le seed Annexe B) sont les deux sociétés
--    co-organisatrices — toutes deux liées en document_societies.
-- 2. RFE très récente (validée fin 2024, publiée 2025) — `freshness_status` = 'a_jour',
--    cohérent avec `library_final.json` (`"status": "en vigueur"`), aucune divergence
--    détectée pour ce document.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Intubation en urgence d''un adulte hors bloc opératoire et hors unité des soins critiques',
  'RFE', 'fr', '2025-03-29',
  'https://sfar.org/intubation-en-urgence-dun-adulte-hors-bloc-operatoire-et-hors-unite-des-soins-critiques/',
  'https://sfar.org/download/intubation-en-urgence-dun-adulte-hors-bloc-operatoire-et-hors-unite-des-soins-critiques/?wpdmdl=103152',
  'GRADE® : force forte (1+ recommandé / 1- non recommandé) ou faible (2+ proposé / 2- proposé de ne pas faire) ; avis d''experts (AE). 32 recommandations au total (5 Grade1, 12 Grade2, 15 AE) d''après la source ; 28 individuellement numérotées et gradées dans un tableau Réf./Recommandation/Grade classique, 4 supplémentaires (R4.3.1-R4.3.4, conduite à tenir en cas d''échec d''intubation, AE, accord fort) intégrées dans 2 algorithmes-organigrammes sans repère individuel récupérable. 4 questions sans recommandation possible, faute de littérature suffisante.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/intubation-en-urgence-dun-adulte-hors-bloc-operatoire-et-hors-unite-des-soins-critiques/'
  and s.acronym in ('SFAR', 'SFMU') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/intubation-en-urgence-dun-adulte-hors-bloc-operatoire-et-hors-unite-des-soins-critiques/'
  and s.slug in ('anesthesie_reanimation', 'medecine_d_urgence', 'medecine_intensive_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/intubation-en-urgence-dun-adulte-hors-bloc-operatoire-et-hors-unite-des-soins-critiques/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000029-R01', 'Réaliser une intubation trachéale en 1ère intention plutôt qu''un dispositif supra-glottique pour le contrôle des VAS.', '2+', 'Champ 1 — Indications de l''intubation trachéale en urgence (Réf. 1.1)'),
  ('MG-ANES-000029-R02', 'Au cours de la RCP spécialisée de l''arrêt cardiaque : réaliser une intubation trachéale plutôt qu''un dispositif supra-glottique ou une ventilation au masque.', 'AE', 'Champ 1 — Indications de l''intubation trachéale en urgence (Réf. 1.2.1)'),
  ('MG-ANES-000029-R03', 'Dans l''attente de l''intubation trachéale au cours de l''arrêt cardiaque : ventiler au masque facial + BAVU relié à une source d''oxygène.', 'AE', 'Champ 1 — Indications de l''intubation trachéale en urgence (Réf. 1.2.2)'),
  ('MG-ANES-000029-R04', 'Traumatisme crânien grave : réaliser une intubation trachéale.', '2+', 'Champ 1 — Indications de l''intubation trachéale en urgence (Réf. 1.3.1)'),
  ('MG-ANES-000029-R05', 'Traumatisme crânien grave : intubation/ventilation par un opérateur entraîné, en maintenant PAS constamment > 110 mmHg et EtCO2 entre 35 et 45 mmHg.', 'AE', 'Champ 1 — Indications de l''intubation trachéale en urgence (Réf. 1.3.2)'),
  ('MG-ANES-000029-R06', 'Obstruction des voies aériennes supérieures et/ou du plan glottique : prioriser la libération des VAS et l''oxygénation.', '1+', 'Champ 1 — Indications de l''intubation trachéale en urgence (Réf. 1.4)'),
  ('MG-ANES-000029-R07', 'Traumatisme thoracique pénétrant : ne pas recourir à l''intubation trachéale systématique.', 'AE', 'Champ 1 — Indications de l''intubation trachéale en urgence (Réf. 1.5.1)'),
  ('MG-ANES-000029-R08', 'Traumatisme thoracique pénétrant nécessitant l''intubation : éliminer un pneumothorax à exsuffler/drainer avec les moyens disponibles.', 'AE', 'Champ 1 — Indications de l''intubation trachéale en urgence (Réf. 1.5.2)'),
  ('MG-ANES-000029-R09', 'Choc hémorragique : ne pas intuber sur la seule indication du choc en l''absence d''autre indication formelle (neuro/respiratoire), même si chirurgie sous AG à courte échéance.', '2-', 'Champ 1 — Indications de l''intubation trachéale en urgence (Réf. 1.6)'),
  ('MG-ANES-000029-R10', 'Avoir immédiatement disponible (fonctionnel, vérifié) : masques faciaux (T3-5), BAVU, aspiration + canule gros calibre, source d''O2, canules oropharyngées (T3-4), sondes d''intubation (T5-8), laryngoscope direct Macintosh (lames 3-4), vidéolaryngoscope, capnographe, stylet rigide, mandrin long béquillé, pince de Magill, dispositif supra-glottique permettant l''intubation, kit de cricothyroïdotomie (scalpel + mandrin long béquillé + sonde — technique SMS).', 'AE', 'Champ 2 — Check-list, matériel, formation (Réf. 2.2.1)'),
  ('MG-ANES-000029-R11', 'Avoir à disposition immédiate le matériel d''intubation difficile.', 'AE', 'Champ 2 — Check-list, matériel, formation (Réf. 2.2.2)'),
  ('MG-ANES-000029-R12', 'Considérer d''emblée toute intubation trachéale en urgence hors bloc/soins critiques comme potentiellement difficile.', '2+', 'Champ 2 — Check-list, matériel, formation (Réf. 2.3.1)'),
  ('MG-ANES-000029-R13', 'Ne pas utiliser systématiquement les scores prédictifs d''intubation difficile développés pour l''urgence (LEMON, HEAVEN, PreDAIT…).', '2-', 'Champ 2 — Check-list, matériel, formation (Réf. 2.3.2)'),
  ('MG-ANES-000029-R14', 'Si laryngoscopie directe : expérience minimale de l''opérateur en 1ère ligne ≥ 50 laryngoscopies directes réussies.', '2+', 'Champ 2 — Check-list, matériel, formation (Réf. 2.4.1)'),
  ('MG-ANES-000029-R15', 'Si vidéolaryngoscopie : expérience minimale de l''opérateur en 1ère ligne ≥ 15 vidéolaryngoscopies réussies.', 'AE', 'Champ 2 — Check-list, matériel, formation (Réf. 2.4.2)'),
  ('MG-ANES-000029-R16', 'Procéder systématiquement à une pré-oxygénation avant intubation trachéale en urgence.', '1+', 'Champ 3 — Optimisation de la procédure d''intubation (Réf. 3.1.1)'),
  ('MG-ANES-000029-R17', 'Utiliser une pré-oxygénation par VNI (en l''absence de contre-indication).', '1+', 'Champ 3 — Optimisation de la procédure d''intubation (Réf. 3.1.2)'),
  ('MG-ANES-000029-R18', 'Ne pas utiliser d''oxygénation apnéique après l''induction et avant la laryngoscopie.', '2-', 'Champ 3 — Optimisation de la procédure d''intubation (Réf. 3.2.1)'),
  ('MG-ANES-000029-R19', 'Désaturation après induction et avant laryngoscopie (ou patient hypoxémique avant induction) : ventilation manuelle au masque, FiO2 100 %, bas volume/basse pression.', 'AE', 'Champ 3 — Optimisation de la procédure d''intubation (Réf. 3.2.2)'),
  ('MG-ANES-000029-R20', 'Ne pas réaliser de pression cricoïdienne lors de l''intubation trachéale en urgence.', '2-', 'Champ 3 — Optimisation de la procédure d''intubation (Réf. 3.3)'),
  ('MG-ANES-000029-R21', 'Calculer le shock-index avant le geste (seuil > 0,9 = risque accru de collapsus cardiovasculaire au décours de l''intubation).', '2+', 'Champ 3 — Optimisation de la procédure d''intubation (Réf. 3.4.1)'),
  ('MG-ANES-000029-R22', 'Patient à risque de collapsus au décours de l''intubation : éviter le propofol par mesure de prudence.', 'AE', 'Champ 3 — Optimisation de la procédure d''intubation (Réf. 3.4.2)'),
  ('MG-ANES-000029-R23', 'Sauf arrêt cardiaque : associer systématiquement un hypnotique puis un curare (agents à délai d''action court, bonne tolérance hémodynamique) pour faciliter l''intubation.', '2+', 'Champ 3 — Optimisation de la procédure d''intubation (Réf. 3.5)'),
  ('MG-ANES-000029-R24', 'Utiliser systématiquement en 1ère intention un dispositif guide (stylet malléable ou mandrin long béquillé) pour la sonde d''intubation.', '2+', 'Champ 4 — Procédure d''intubation trachéale (Réf. 4.1)'),
  ('MG-ANES-000029-R25', 'En intrahospitalier : utiliser le vidéolaryngoscope en 1ère intention pour l''intubation trachéale.', '1+', 'Champ 4 — Procédure d''intubation trachéale (Réf. 4.2)'),
  ('MG-ANES-000029-R26', 'Utiliser systématiquement la capnographie pour confirmer le bon positionnement de la sonde (ou du dispositif supra-glottique / abord trachéal direct).', '1+', 'Champ 5 — Prise en charge après intubation trachéale (Réf. 5.1.1)'),
  ('MG-ANES-000029-R27', 'Si la confirmation par capnographie est impossible : utiliser l''échographie trans-trachéale et pulmonaire pour vérifier le bon positionnement.', '2+', 'Champ 5 — Prise en charge après intubation trachéale (Réf. 5.1.2)'),
  ('MG-ANES-000029-R28', 'Associer un hypnotique et un morphinique pour la sédation d''un patient intubé en situation d''urgence.', 'AE', 'Champ 5 — Prise en charge après intubation trachéale (Réf. 5.2)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/intubation-en-urgence-dun-adulte-hors-bloc-operatoire-et-hors-unite-des-soins-critiques/'
on conflict (recommendation_code) do nothing;
