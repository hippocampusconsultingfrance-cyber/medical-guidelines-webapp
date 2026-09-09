-- Migration : Recommandations sur la réanimation du choc hémorragique — SFAR/SRLF/SFMU/GEHT,
-- RFE 2014/2015
-- Source : rfe-sfar-website/build/content_choc_hemorragique.json (29 recommandations
-- atomiques, tableaux "Réf. | Recommandation | Grade", méthodologie GRADE).
--
-- Grade : reproduit tel quel depuis le chip source (1+/1-/2+/2-/AE). evidence_level laissé
-- NULL : pas de système de niveau de preuve distinct de la force GRADE dans ce document.
--
-- DIVERGENCE DE DÉCOMPTE (disclosure, pas une invention) : le contenu construit annonce
-- "24 recommandations gradées". Un décompte direct des lignes du tableau en donne 29 : 4
-- numéros de référence source (1, 11, 15, 18) portent CHACUN plusieurs lignes à grades
-- DIFFÉRENTS et à contenu clinique distinct (ex. réf. 15 : trois lignes, une pour le
-- traumatisé "1+", une pour le non-traumatisé "2+", une négative "ne pas initier au-delà de
-- la 3e heure" "1-") — ce ne sont pas des doublons ni des répétitions d'une même
-- recommandation, donc PAS fusionnées ici (les fusionner créerait exactement le grade
-- composite que le safety net de ce projet est censé empêcher). Chaque ligne est migrée
-- individuellement avec un suffixe de désambiguïsation (1a/1b, 11a/11b, 15a/15b/15c,
-- 18a/18b) dans `source_section` — le nombre exact de recommandations formelles de la RFE
-- (24 selon son propre décompte, vs. 29 lignes gradées distinctement ici) reste à confirmer
-- par un relecteur humain ayant accès au texte intégral.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SFAR, SRLF ET SFMU sont toutes trois liées en document_societies (toutes dans le seed
--    Annexe B). GEHT (Groupe d'Études sur l'Hémostase et la Thrombose), co-auteur, n'y
--    figure pas — non lié.
-- 2. Cette fiche renvoie elle-même vers `anticoagulants` (0012, RFE SFAR/GIHP 2026) pour la
--    prise en charge détaillée des anticoagulants en péri-procédure programmée — hors champ
--    de cette RFE-ci (hémorragie/choc, pas gestion péri-procédurale programmée).
-- 3. Champ explicitement exclu par la source elle-même : hémorragie digestive et hémorragie
--    obstétricale (RFE dédiées, non couvertes ici).

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Recommandations sur la réanimation du choc hémorragique',
  'RFE', 'fr', '2015-02-02',
  'https://sfar.org/wp-content/uploads/2015/09/2_AFAR_Recommandations-sur-la-reanimation-du-choc-hemorragique.pdf',
  'https://sfar.org/wp-content/uploads/2015/09/2_AFAR_Recommandations-sur-la-reanimation-du-choc-hemorragique.pdf',
  'GRADE : qualité des preuves (haute/modérée/basse/très basse) ; force de recommandation forte (1+/1-) ou faible (2+/2-) via GRADE Grid.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/09/2_AFAR_Recommandations-sur-la-reanimation-du-choc-hemorragique.pdf'
  and s.acronym in ('SFAR', 'SRLF', 'SFMU') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/09/2_AFAR_Recommandations-sur-la-reanimation-du-choc-hemorragique.pdf'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'medecine_d_urgence')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/wp-content/uploads/2015/09/2_AFAR_Recommandations-sur-la-reanimation-du-choc-hemorragique.pdf',
  'draft'
from public.documents d, (values
  ('MG-ANES-000014-R01', 'Tant que le saignement n''est pas contrôlé : tolérer une hypotension permissive, objectif PAS 80-90 mmHg (PAM 60-65 mmHg), en l''absence de traumatisme crânien grave.', '2+', 'Objectifs de pression artérielle et monitorage (1a)'),
  ('MG-ANES-000014-R02', 'Traumatisme crânien grave (Glasgow ≤ 8) associé : objectif PAM ≥ 80 mmHg avant monitorage cérébral, malgré le risque d''aggravation du saignement.', '1+', 'Objectifs de pression artérielle et monitorage (1b)'),
  ('MG-ANES-000014-R03', 'Tant que le saignement n''est pas contrôlé, limiter le remplissage au strict maintien des objectifs de pression artérielle.', '1+', 'Objectifs de pression artérielle et monitorage (2)'),
  ('MG-ANES-000014-R04', 'Suivre l''évolution de la concentration du lactate artériel pour apprécier le degré d''hypoperfusion et d''hypoxie tissulaire.', '1+', 'Objectifs de pression artérielle et monitorage (3)'),
  ('MG-ANES-000014-R05', 'La pose d''un cathéter veineux central ne doit pas retarder le traitement étiologique et la stabilisation hémodynamique (remplissage vasculaire et vasopresseur) si des voies veineuses périphériques sont disponibles rapidement.', '1+', 'Voies d''abord vasculaire (11a)'),
  ('MG-ANES-000014-R06', 'Noradrénaline recommandée sur voie veineuse centrale ; dans un contexte d''urgence et dans l''attente d''un accès central, utiliser une voie périphérique dédiée (éviter les bolus).', '1+', 'Voies d''abord vasculaire (11b)'),
  ('MG-ANES-000014-R07', 'En préhospitalier, privilégier l''accès intra-osseux au cathéter veineux central lorsqu''un abord veineux périphérique de bon calibre est impossible.', '2+', 'Voies d''abord vasculaire (12)'),
  ('MG-ANES-000014-R08', 'Utiliser en première intention les solutés cristalloïdes lors de la prise en charge initiale.', '1+', 'Choix du soluté de remplissage (4)'),
  ('MG-ANES-000014-R09', 'Ne pas utiliser de solutés hypotoniques lors de la prise en charge initiale d''un patient avec traumatisme crânien grave.', '1-', 'Choix du soluté de remplissage (5)'),
  ('MG-ANES-000014-R10', 'Solutés à base d''hydroxyéthylamidons (HEA) : à envisager seulement si les cristalloïdes seuls sont insuffisants pour maintenir la volémie et en l''absence de contre-indication. Dose la plus faible possible, durée la plus courte possible. Il n''existe pas assez d''études de bonne qualité pour savoir si cette recommandation doit s''étendre aux autres colloïdes semi-synthétiques (ex. gélatines).', '1+', 'Choix du soluté de remplissage (6)'),
  ('MG-ANES-000014-R11', 'Ne pas utiliser l''albumine lors de la prise en charge initiale.', '1+', 'Choix du soluté de remplissage (7)'),
  ('MG-ANES-000014-R12', 'Après avoir débuté un remplissage vasculaire, administrer probablement un vasopresseur en cas de persistance d''une hypotension artérielle (PAS < 80 mmHg).', '2+', 'Vasopresseurs (9)'),
  ('MG-ANES-000014-R13', 'Administrer probablement la noradrénaline en première intention.', '2+', 'Vasopresseurs (10)'),
  ('MG-ANES-000014-R14', 'Objectif d''hémoglobine probablement entre 7 et 9 g/dL.', '2+', 'Transfusion — objectifs & organisation (8)'),
  ('MG-ANES-000014-R15', 'Effectuer sans retard le diagnostic et le traitement des troubles de l''hémostase (bilan minimal : TP, fibrinogène, numération plaquettaire ; tests viscoélastiques ROTEM/TEG utiles pour un diagnostic rapide).', '1+', 'Transfusion — objectifs & organisation (13)'),
  ('MG-ANES-000014-R16', 'Une procédure locale de gestion de l''hémorragie massive doit être élaborée dans chaque structure médico-chirurgicale, avec approche multidisciplinaire (packs hémostatiques CGR/plasma/plaquettes).', '1+', 'Transfusion — objectifs & organisation (14)'),
  ('MG-ANES-000014-R17', 'Administrer de l''acide tranexamique dès que possible chez le patient traumatisé : 1 g en bolus IV en 10 min, suivi de 1 g perfusé sur 8 h.', '1+', 'Acide tranexamique (15a)'),
  ('MG-ANES-000014-R18', 'Administrer probablement l''acide tranexamique selon le même schéma chez le patient non traumatisé en choc hémorragique.', '2+', 'Acide tranexamique (15b)'),
  ('MG-ANES-000014-R19', 'Ne pas initier l''administration d''acide tranexamique au-delà de la 3ème heure suivant un traumatisme avec choc hémorragique.', '1-', 'Acide tranexamique (15c)'),
  ('MG-ANES-000014-R20', 'Débuter la transfusion de plasma rapidement, idéalement en même temps que celle des CGR.', '1+', 'Produits sanguins labiles — plasma, plaquettes, fibrinogène (16)'),
  ('MG-ANES-000014-R21', 'Transfuser probablement le plasma frais congelé en association aux CGR, ratio PFC:CGR entre 1/2 et 1/1.', '2+', 'Produits sanguins labiles — plasma, plaquettes, fibrinogène (17)'),
  ('MG-ANES-000014-R22', 'Transfusion plaquettaire précoce (généralement à la 2ème prescription transfusionnelle) pour maintenir la numération plaquettaire au-dessus de 50 G/L.', '1+', 'Produits sanguins labiles — plasma, plaquettes, fibrinogène (18a)'),
  ('MG-ANES-000014-R23', 'Ce seuil doit probablement être porté à 100 G/L en cas de traumatisme crânien associé ou de persistance du saignement.', '2+', 'Produits sanguins labiles — plasma, plaquettes, fibrinogène (18b)'),
  ('MG-ANES-000014-R24', 'Transfuser probablement des plaquettes chez les patients présentant une hémorragie sévère et/ou intracrânienne traités par ticagrélor ou prasugrel.', '2+', 'Produits sanguins labiles — plasma, plaquettes, fibrinogène (19)'),
  ('MG-ANES-000014-R25', 'Concentrés de fibrinogène probablement recommandés si fibrinogénémie < 1,5 g/L, ou déficit fonctionnel en fibrinogène aux paramètres thromboélastographiques. Dose initiale suggérée : 3 g chez un adulte de 70 kg.', '2+', 'Produits sanguins labiles — plasma, plaquettes, fibrinogène (20)'),
  ('MG-ANES-000014-R26', 'Monitorer la concentration de calcium ionisé en cas de transfusion massive pour la maintenir > 0,9 mmol/L (apport de chlorure de calcium sur voie indépendante de la transfusion).', '1+', 'Produits sanguins labiles — plasma, plaquettes, fibrinogène (21)'),
  ('MG-ANES-000014-R27', 'Le rFVIIa ne doit pas être utilisé en 1ère intention. À envisager seulement si le saignement ne peut être contrôlé malgré hémostase mécanique (chirurgie/endoscopie/embolisation), acide tranexamique, transfusion de PSL, fibrinogène, et correction d''une hypothermie/acidose sévère. Posologie initiale : 80 µg/kg (200 µg/kg en traumatologie).', '1-', 'Facteur VII activé recombinant (rFVIIa) (22)'),
  ('MG-ANES-000014-R28', 'Patient sous AVK : administrer sans délai des concentrés de complexe prothrombinique (CCP/PPSB) à la dose de 25 UI/kg (ou adaptée à l''INR), associés à 10 mg de vitamine K. Objectif INR < 1,5 en quelques minutes ; contrôle INR à 30 min, réadministration de CCP si INR > 1,5.', '1+', 'Choc hémorragique chez un patient anticoagulé (23)'),
  ('MG-ANES-000014-R29', 'Patient sous AOD (dabigatran, rivaroxaban, apixaban) : tenter probablement une neutralisation immédiate par FEIBA 30-50 UI/kg ou CCP 50 UI/kg, éventuellement renouvelés une fois à 8h d''intervalle. Mesurer l''anticoagulant par un test spécifique pour vérifier son imputabilité.', '2+', 'Choc hémorragique chez un patient anticoagulé (24)')) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/09/2_AFAR_Recommandations-sur-la-reanimation-du-choc-hemorragique.pdf'
on conflict (recommendation_code) do nothing;
