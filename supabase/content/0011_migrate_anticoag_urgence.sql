-- Migration : Gestion de l'anticoagulation dans un contexte d'urgence — SFMU/SFAR/GIHP/SFTH,
-- RFE 2024
-- Source : rfe-sfar-website/build/content_anticoag_urgence.json (91 recommandations
-- atomiques, méthodologie GRADE — chips "1+/1-/2+/2-/AE", tableaux "Réf. | Recommandation |
-- Grade" par sous-section, 5 champs).
--
-- Grade : reproduit tel quel depuis le chip source. evidence_level laissé NULL : pas de
-- système de niveau de preuve distinct du grade dans ce document.
--
-- RECONCILIATION DU DÉCOMPTE — vérification directe contre le PDF source (disclosure d'une
-- investigation complémentaire, pas une invention) : le contenu construit et la source
-- citent "102 recommandations (19 GRADE 1, 35 GRADE 2, 48 avis d'experts)" au total, mais
-- seules 91 apparaissent dans les tableaux "Réf. | Recommandation | Grade" du contenu
-- construit, avec des trous de numérotation systématiques (ex. R2.3.1, R2.4.1, R2.5.1,
-- R2.6.1, R4.1.1, R4.2.1, R4.3.1, R5.1.1, R3.1.1 absents). Le PDF source
-- (https://sfar.org/download/gestion-de-lanticoagulation-dans-un-contexte-durgence/?wpdmdl=62045,
-- téléchargé et son texte extrait pour vérifier — pas deviné) montre que ces 9 items
-- existent bien mais sont tous du type "les experts suggèrent d'utiliser l'algorithme
-- suivant (figure N)" : des recommandations-pointeurs vers un algorithme visuel (AVIS
-- D'EXPERTS, accord fort), dont le contenu clinique réel est entièrement décomposé par les
-- items numérotés suivants de la même sous-section (déjà migrés ci-dessous) — même logique
-- d'exclusion que les Figures 1/2 de aap_urgence/aap_programmee (0004/0005), vérifiée ici
-- directement contre le texte source plutôt que déduite du contenu construit. Les 2
-- dernières recommandations manquantes sont : un panneau "Absence de recommandation"
-- explicite (HNF dose curative + AVCi + protamine avant thrombolyse — aucune recommandation
-- réelle à porter, même traitement que les cas déjà rencontrés) et une phrase d'argumentaire
-- ("si seuls les tests standards TP/TCA sont disponibles pour un patient sous AOD, la
-- thrombolyse IV est contre-indiquée") qui, vérification faite dans le PDF source, fait
-- partie du corps de texte explicatif attaché à une recommandation déjà numérotée
-- (concentration AOD/thrombolyse), pas un item Rx.x.x séparé. 91 + 9 + 1 + 1 = 102 :
-- décompte source intégralement reconcilié, aucune recommandation n'est donc réellement
-- "perdue" par cette migration — seulement les 9 pointeurs d'algorithme, déjà couverts par
-- le contenu textuel des items suivants.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Deux lignes du contenu construit portent un repère double ("R4.2.3/8" et "R4.2.7/11") :
--    choix déjà fait par le contenu construit (fusion de deux items source jugés
--    équivalents/redondants) — reproduit tel quel, pas re-tranché ici.
-- 2. GIHP et SFTH (Société Française de Thrombose et d'Hémostase), co-auteurs avec
--    SFAR/SFMU, ne figurent pas dans le seed Annexe B — seules SFAR et SFMU sont liées en
--    document_societies ci-dessous.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Gestion de l''anticoagulation dans un contexte d''urgence',
  'RFE', 'fr', '2024-01-01',
  'https://sfar.org/download/gestion-de-lanticoagulation-dans-un-contexte-durgence/?wpdmdl=62045',
  'https://sfar.org/download/gestion-de-lanticoagulation-dans-un-contexte-durgence/?wpdmdl=62045',
  'GRADE : force forte (1+ recommandé / 1- non recommandé) ou faible (2+ proposé / 2- proposé de ne pas faire) ; avis d''experts (AE). 102 recommandations au total dans la RFE (19 GRADE 1, 35 GRADE 2, 48 avis d''experts), 5 champs, 73 pages.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/download/gestion-de-lanticoagulation-dans-un-contexte-durgence/?wpdmdl=62045'
  and s.acronym in ('SFAR', 'SFMU') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/download/gestion-de-lanticoagulation-dans-un-contexte-durgence/?wpdmdl=62045'
  and s.slug in ('anesthesie_reanimation', 'medecine_d_urgence', 'medecine_intensive_reanimation', 'hematologie')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/download/gestion-de-lanticoagulation-dans-un-contexte-durgence/?wpdmdl=62045',
  'draft'
from public.documents d, (values
  ('MG-ANES-000011-R01', 'Traitement anticoagulant inconnu : évaluer l''activité anti-Xa (HNF/HBPM) et le temps de thrombine (TT) en plus du TP/INR et du TCA, pour exclure ou détecter un anticoagulant circulant.', 'AE', 'Champ 1 — Biologie : dépister un anticoagulant et son niveau (R1.1.1)'),
  ('MG-ANES-000011-R02', 'Traitement connu : AVK → INR (labo ou délocalisé) ; HNF/HBPM/fondaparinux → activité anti-Xa calibrée ; AOD → concentration du médicament.', 'AE', 'Champ 1 — Biologie : dépister un anticoagulant et son niveau (R1.1.2)'),
  ('MG-ANES-000011-R03', 'Ne pas utiliser les tests viscoélastométriques pour dépister un anticoagulant circulant ou en déterminer le niveau.', 'AE', 'Champ 1 — Biologie : dépister un anticoagulant et son niveau (R1.1.3)'),
  ('MG-ANES-000011-R04', 'Hémorragie grave : débuter en urgence l''arrêt de l''anticoagulant, la prise en charge symptomatique/hémostatique/étiologique, la mesure du niveau d''anticoagulation et la réversion.', 'AE', 'Champ 2 — Principes généraux face à une hémorragie sous anticoagulant (R2.1.1)'),
  ('MG-ANES-000011-R05', 'Hémorragie intracrânienne ou choc hémorragique : réverser sans attendre le résultat des tests biologiques, sauf s''il est disponible en quelques minutes.', '1+', 'Champ 2 — Principes généraux face à une hémorragie sous anticoagulant (R2.1.2)'),
  ('MG-ANES-000011-R06', 'Hémorragie non grave : débuter un traitement hémostatique par les moyens usuels quand possible, sans réverser l''anticoagulation.', 'AE', 'Champ 2 — Principes généraux face à une hémorragie sous anticoagulant (R2.1.3)'),
  ('MG-ANES-000011-R07', 'Hémorragie non grave : prise en charge ambulatoire possible si contrôle rapide et environnement médico-social favorable, sans majorer le risque de resaignement.', 'AE', 'Champ 2 — Principes généraux face à une hémorragie sous anticoagulant (R2.1.4)'),
  ('MG-ANES-000011-R08', 'Grave ou non grave : rechercher la cause du saignement et les facteurs de risque de surdosage/accumulation (comédications, insuffisance rénale, contre-indications).', '2+', 'Champ 2 — Principes généraux face à une hémorragie sous anticoagulant (R2.1.5)'),
  ('MG-ANES-000011-R09', 'Formaliser des procédures organisationnelles pluridisciplinaires pour améliorer la rapidité et la qualité de la prise en charge.', '2+', 'Champ 2 — Principes généraux face à une hémorragie sous anticoagulant (R2.1.6)'),
  ('MG-ANES-000011-R10', 'Quelle que soit la gravité de l''hémorragie sous anticoagulant : administrer l''acide tranexamique selon les mêmes indications qu''un patient non anticoagulé.', '1+', 'Champ 2 — Principes généraux face à une hémorragie sous anticoagulant (R2.2.1)'),
  ('MG-ANES-000011-R11', 'Mesurer l''INR (labo ou délocalisé) ; en cas d''hémorragie grave, ne pas retarder le geste hémostatique pour l''obtenir.', '1+', 'Hémorragie sous AVK (R2.3.2)'),
  ('MG-ANES-000011-R12', 'Hémorragie grave, INR > 1,5 (> 1,2 si hémorragie intracrânienne) : arrêter l''AVK et antagoniser en urgence par CCP (dose selon INR/RCP, ou 25 UI/kg si INR non disponible rapidement) + 10 mg de vitamine K (IV ou PO).', '1+', 'Hémorragie sous AVK (R2.3.3)'),
  ('MG-ANES-000011-R13', 'Hémorragie grave : contrôler l''INR entre 30 min et 6-8h, puis à 24h après l''antagonisation, pour décider d''une administration supplémentaire de CCP.', '2+', 'Hémorragie sous AVK (R2.3.4)'),
  ('MG-ANES-000011-R14', 'Hémorragie non grave : rechercher/corriger un surdosage uniquement par vitamine K (sans CCP), traitement symptomatique puis réévaluation.', '2+', 'Hémorragie sous AVK (R2.3.5)'),
  ('MG-ANES-000011-R15', 'Hémorragie grave : mesurer en urgence la concentration plasmatique en dabigatran.', '2+', 'Hémorragie sous dabigatran (R2.4.2)'),
  ('MG-ANES-000011-R16', 'Hémorragie grave, concentration > 50 ng/mL (> 30 ng/mL si intracrânienne), ou mesure non disponible rapidement : antagoniser en urgence par idarucizumab 5 g IVL.', '2+', 'Hémorragie sous dabigatran (R2.4.3)'),
  ('MG-ANES-000011-R17', 'Contrôler la concentration à 12-24h après idarucizumab si concentration initiale > 200 ng/mL (dépister un rebond) — contrôle plus précoce (4-6h) si > 600 ng/mL ou ClCr < 30 mL/min ; discuter une 2ème dose si rebond.', '2+', 'Hémorragie sous dabigatran (R2.4.4)'),
  ('MG-ANES-000011-R18', 'Si idarucizumab non disponible : CCP 25-50 UI/kg (50 UI/kg si hémorragie intracrânienne).', 'AE', 'Hémorragie sous dabigatran (R2.4.5)'),
  ('MG-ANES-000011-R19', 'Hémorragie non grave : traitement symptomatique sans idarucizumab, réévaluer posologie/fonction rénale/comédications.', '2+', 'Hémorragie sous dabigatran (R2.4.6)'),
  ('MG-ANES-000011-R20', 'Hémorragie grave : mesurer en urgence la concentration plasmatique en AOD anti-Xa.', '2+', 'Hémorragie sous AOD anti-Xa — rivaroxaban, apixaban, edoxaban (R2.5.2)'),
  ('MG-ANES-000011-R21', 'Hémorragie grave, concentration > 50 ng/mL (> 30 ng/mL si intracrânienne), ou mesure non disponible rapidement : réverser par CCP (25-50 UI/kg). Sans délai, par CCP 50 UI/kg, si hémorragie intracrânienne ou choc hémorragique.', 'AE', 'Hémorragie sous AOD anti-Xa — rivaroxaban, apixaban, edoxaban (R2.5.3)'),
  ('MG-ANES-000011-R22', 'Hémorragie non grave : traitement symptomatique sans CCP, contrôler les modalités du traitement (posologie, fonction rénale, comédications).', '2+', 'Hémorragie sous AOD anti-Xa — rivaroxaban, apixaban, edoxaban (R2.5.4)'),
  ('MG-ANES-000011-R23', 'HNF dose curative, hémorragie intracrânienne ou choc hémorragique : arrêter et antagoniser en urgence par sulfate de protamine (selon dose/voie/délai d''administration de l''HNF).', '2+', 'Hémorragie sous héparines — HNF / HBPM (R2.6.2)'),
  ('MG-ANES-000011-R24', 'HNF dose curative, hémorragie grave (hors intracrânienne/choc) : arrêter et discuter la protamine.', 'AE', 'Hémorragie sous héparines — HNF / HBPM (R2.6.3)'),
  ('MG-ANES-000011-R25', 'HNF dose curative, hémorragie non grave : traitement symptomatique + vérifier l''absence de surdosage (anti-Xa ou TCA).', 'AE', 'Hémorragie sous héparines — HNF / HBPM (R2.6.4)'),
  ('MG-ANES-000011-R26', 'HBPM, hémorragie grave : mesurer en urgence l''activité anti-Xa.', '2+', 'Hémorragie sous héparines — HNF / HBPM (R2.6.5)'),
  ('MG-ANES-000011-R27', 'HBPM dose curative, hémorragie intracrânienne ou choc hémorragique : arrêter et antagoniser en urgence par protamine (selon type d''HBPM/dose/délai).', '2+', 'Hémorragie sous héparines — HNF / HBPM (R2.6.6)'),
  ('MG-ANES-000011-R28', 'HBPM dose curative, hémorragie grave (hors intracrânienne/choc) : arrêter et discuter la protamine.', 'AE', 'Hémorragie sous héparines — HNF / HBPM (R2.6.7)'),
  ('MG-ANES-000011-R29', 'HBPM dose curative, hémorragie non grave : traitement symptomatique + vérifier l''adaptation au poids/fonction rénale.', 'AE', 'Hémorragie sous héparines — HNF / HBPM (R2.6.8)'),
  ('MG-ANES-000011-R30', 'Ne pas administrer de protamine si l''activité anti-Xa (HNF ou HBPM) est < 0,2 UI/mL.', 'AE', 'Hémorragie sous héparines — HNF / HBPM (R2.6.9)'),
  ('MG-ANES-000011-R31', 'Fondaparinux dose curative, hémorragie grave, réversion décidée : CCP (25-50 UI/kg) ou facteur VII activé recombinant (90 µg/kg).', 'AE', 'Hémorragie sous fondaparinux (R2.7) & reprise post-hémorragie (R2.7.1)'),
  ('MG-ANES-000011-R32', 'Fondaparinux dose curative, hémorragie non grave : traitement symptomatique + vérifier l''adaptation au poids/fonction rénale.', 'AE', 'Hémorragie sous fondaparinux (R2.7) & reprise post-hémorragie (R2.7.2)'),
  ('MG-ANES-000011-R33', 'Après hémorragie grave (hors intracrânienne) : reprendre l''anticoagulation curative après évaluation risque hémorragique/thrombotique (à titre indicatif J2-J7) — d''autant plus précoce qu''un geste hémostatique garantit une faible récidive.', '2+', 'Hémorragie sous fondaparinux (R2.7) & reprise post-hémorragie (R2.8.1)'),
  ('MG-ANES-000011-R34', 'Hémorragie intracrânienne ou situation complexe : décider la reprise en discussion multidisciplinaire.', 'AE', 'Hémorragie sous fondaparinux (R2.7) & reprise post-hémorragie (R2.8.2)'),
  ('MG-ANES-000011-R35', 'Hémorragie grave dans le 1er mois suivant une TVP proximale/EP : discuter un filtre cave optionnel en réunion multidisciplinaire.', '2+', 'Hémorragie sous fondaparinux (R2.7) & reprise post-hémorragie (R2.8.3)'),
  ('MG-ANES-000011-R36', 'Surdosage asymptomatique sous AVK : ne pas administrer de CCP ni de plasma.', '2-', 'Champ 3 — Surdosages asymptomatiques (R3.1.2)'),
  ('MG-ANES-000011-R37', 'Vitamine K PO : INR cible 2,5, si INR ≥ 6 (2 mg entre 6-10, 5 mg si > 10) ; INR cible ≥ 3, si INR > 10 (2 mg).', '2+', 'Champ 3 — Surdosages asymptomatiques (R3.1.3)'),
  ('MG-ANES-000011-R38', 'Prise en charge ambulatoire possible dès la régulation si bonne compréhension/accompagnant, recherche étiologique et suivi INR réalisables, absence de risque hémorragique majoré (thrombopénie < 50 G/L, autre antithrombotique associé sauf aspirine seule, ATCD hémorragie/AVC < 1 mois, lésion évolutive à fort potentiel hémorragique).', 'AE', 'Champ 3 — Surdosages asymptomatiques (R3.1.4)'),
  ('MG-ANES-000011-R39', 'Intoxication massive supposée aux AOD : charbon activé seulement si < 8h.', 'AE', 'Champ 3 — Surdosages asymptomatiques (R3.2.1)'),
  ('MG-ANES-000011-R40', 'Surdosage AOD asymptomatique (> 400 ng/mL) : rechercher la cause, surveillance clinique sans réversion.', '2+', 'Champ 3 — Surdosages asymptomatiques (R3.2.2)'),
  ('MG-ANES-000011-R41', 'Anticoagulant injectable, surdosage asymptomatique : ne pas réverser.', '2-', 'Champ 3 — Surdosages asymptomatiques (R3.3)'),
  ('MG-ANES-000011-R42', 'Procédure à faible risque hémorragique : ne pas arrêter ni antagoniser l''AVK.', '1-', 'AVK (R4.1.2)'),
  ('MG-ANES-000011-R43', 'Procédure à risque élevé : mesurer l''INR avant la procédure.', '1+', 'AVK (R4.1.3)'),
  ('MG-ANES-000011-R44', 'Seuil de sécurité hémostatique : INR ≤ 1,5 (≤ 1,2 pour neurochirurgie intracrânienne ou gestes neuraxiaux).', '2+', 'AVK (R4.1.4)'),
  ('MG-ANES-000011-R45', 'Si l''INR est sous le seuil visé : ne pas antagoniser (ni CCP, ni vitamine K).', '1-', 'AVK (R4.1.5)'),
  ('MG-ANES-000011-R46', 'Procédure sans délai, résultat de l''INR indisponible : CCP 25 UI/kg + 5 mg vitamine K IV, débuter la procédure, contrôler l''INR à 30 min (complément de dose selon RCP si besoin).', '1+', 'AVK (R4.1.6)'),
  ('MG-ANES-000011-R47', 'INR au-dessus du seuil, procédure dans les 12h : CCP à la posologie du RCP + 5 mg vitamine K IV ou PO, contrôle INR à 30 min (idéalement avant le début de la procédure).', '1+', 'AVK (R4.1.7)'),
  ('MG-ANES-000011-R48', 'INR au-dessus du seuil, procédure prévue > 12h : vitamine K 5 mg (IV de préférence), pas de CCP, contrôle INR avant la procédure.', '2+', 'AVK (R4.1.8)'),
  ('MG-ANES-000011-R49', 'Procédure à faible risque hémorragique : ne pas doser l''AOD, ni arrêter ni réverser.', '2+', 'AOD (R4.2.2)'),
  ('MG-ANES-000011-R50', 'Procédure à risque élevé : mesurer la concentration (dabigatran ou AOD anti-Xa) — seuil de sécurité hémostatique 50 ng/mL (30 ng/mL pour neurochirurgie intracrânienne et gestes neuraxiaux).', 'AE', 'AOD (R4.2.3/8)'),
  ('MG-ANES-000011-R51', 'Dabigatran, concentration sous le seuil : ne pas administrer d''idarucizumab ni de CCP avant la procédure.', '2-', 'AOD (R4.2.4)'),
  ('MG-ANES-000011-R52', 'AOD anti-Xa, concentration sous le seuil : réaliser la procédure sans réversion.', '2+', 'AOD (R4.2.9)'),
  ('MG-ANES-000011-R53', 'Dabigatran au-dessus du seuil, procédure non différable : idarucizumab 5 g (dose unique).', '2+', 'AOD (R4.2.5)'),
  ('MG-ANES-000011-R54', 'Concentration initiale > 200 ng/mL : contrôler la concentration à 12-24h post-procédure ; discuter une 2ème dose d''idarucizumab en cas de ré-ascension.', '2+', 'AOD (R4.2.6)'),
  ('MG-ANES-000011-R55', 'Concentration au-dessus du seuil, procédure différable sans perte de chance : attendre la baisse, nouvelle mesure ≥ 12h plus tard ou se baser sur la demi-vie estimée.', '2+', 'AOD (R4.2.7/11)'),
  ('MG-ANES-000011-R56', 'AOD anti-Xa au-dessus du seuil, procédure non différable : CCP 50 UI/kg avant la procédure si hémostase devant être normalisée d''emblée (ex. neurochirurgie) ; ou CCP 25 UI/kg pendant la procédure en cas de saignement anormal (renouvelable 1×).', 'AE', 'AOD (R4.2.10)'),
  ('MG-ANES-000011-R57', 'AOD anti-Xa au-dessus du seuil : ne pas réaliser de geste neuraxial, même après CCP.', '1-', 'AOD (R4.2.12)'),
  ('MG-ANES-000011-R58', 'HNF, procédure à faible risque : réaliser sans arrêter/antagoniser, après vérification de l''absence de surdosage (anti-Xa).', '2+', 'Héparines (R4.3) & fondaparinux (R4.3.2)'),
  ('MG-ANES-000011-R59', 'HNF, procédure à risque élevé non différable : sulfate de protamine (Tableau 4).', '2+', 'Héparines (R4.3) & fondaparinux (R4.3.3)'),
  ('MG-ANES-000011-R60', 'HBPM, procédure à faible risque : réaliser sans mesurer l''anti-Xa, sans arrêter ni réverser.', '1+', 'Héparines (R4.3) & fondaparinux (R4.3.4)'),
  ('MG-ANES-000011-R61', 'HBPM, procédure à risque élevé : mesurer l''activité anti-Xa avant la procédure.', '2+', 'Héparines (R4.3) & fondaparinux (R4.3.5)'),
  ('MG-ANES-000011-R62', 'HBPM, anti-Xa < 0,2 UI/mL : ne pas administrer de protamine, quelle que soit la procédure.', 'AE', 'Héparines (R4.3) & fondaparinux (R4.3.6)'),
  ('MG-ANES-000011-R63', 'HBPM, anti-Xa > 0,2 UI/mL, risque hémorragique non acceptable : si la procédure peut être retardée de quelques heures sans perte de chance, attendre la baisse de l''anti-Xa.', 'AE', 'Héparines (R4.3) & fondaparinux (R4.3.7)'),
  ('MG-ANES-000011-R64', 'HBPM, anti-Xa > 0,2 UI/mL, procédure non différable : neutraliser partiellement par protamine (IVL 10 min).', 'AE', 'Héparines (R4.3) & fondaparinux (R4.3.8)'),
  ('MG-ANES-000011-R65', 'HBPM : pas de geste neuraxial, même après protamine.', '1-', 'Héparines (R4.3) & fondaparinux (R4.3.9)'),
  ('MG-ANES-000011-R66', 'Fondaparinux, procédure à faible risque : réaliser sans mesurer l''anti-Xa, sans arrêter ni réverser.', 'AE', 'Héparines (R4.3) & fondaparinux (R4.4.1)'),
  ('MG-ANES-000011-R67', 'Fondaparinux, procédure à risque élevé : mesurer l''activité anti-Xa fondaparinux avant la procédure pour réduire les complications hémorragiques.', 'AE', 'Héparines (R4.3) & fondaparinux (R4.4.2)'),
  ('MG-ANES-000011-R68', 'Fondaparinux, procédure à risque élevé non différable, réversion décidée : CCP ou facteur VII activé recombinant.', 'AE', 'Héparines (R4.3) & fondaparinux (R4.4.3)'),
  ('MG-ANES-000011-R69', 'Fondaparinux, procédure à risque élevé différable sans perte de chance : attendre la baisse de l''anti-Xa, nouvelle mesure ≥ 12h plus tard ou se baser sur la demi-vie estimée.', 'AE', 'Héparines (R4.3) & fondaparinux (R4.4.4)'),
  ('MG-ANES-000011-R70', 'Fondaparinux : pas de geste neuraxial.', '1-', 'Héparines (R4.3) & fondaparinux (R4.4.5)'),
  ('MG-ANES-000011-R71', 'Fracture de l''extrémité supérieure du fémur : ne pas retarder la chirurgie du fait du traitement anticoagulant (opérer dans les 48h, comme en population générale).', '2-', 'Fracture de l''ESF (R4.5), gestes neuraxiaux en urgence (R4.5.1)'),
  ('MG-ANES-000011-R72', 'Ne pas réaliser de geste neuraxial sous anticoagulant.', '1-', 'Fracture de l''ESF (R4.5), gestes neuraxiaux en urgence (R4.6.1)'),
  ('MG-ANES-000011-R73', 'Geste neuraxial envisageable après réversion complète, selon l''anticoagulant.', 'AE', 'Fracture de l''ESF (R4.5), gestes neuraxiaux en urgence (R4.6.2)'),
  ('MG-ANES-000011-R74', 'AVK, geste indispensable : CCP + vitamine K, vérifier le seuil (INR ≤ 1,2) avant le geste, opérateur expérimenté.', 'AE', 'Fracture de l''ESF (R4.5), gestes neuraxiaux en urgence (R4.6.3)'),
  ('MG-ANES-000011-R75', 'Dabigatran, geste indispensable : idarucizumab avant le geste, opérateur expérimenté. Si indisponible, le CCP ne garantit ni la normalisation ni la réduction du risque — non recommandé dans cette indication.', 'AE', 'Fracture de l''ESF (R4.5), gestes neuraxiaux en urgence (R4.6.4)'),
  ('MG-ANES-000011-R76', 'Apixaban, rivaroxaban, HBPM ou fondaparinux : la réversion (CCP, protamine ou rFVIIa) pour réaliser un geste neuraxial n''est pas recommandée.', '1-', 'Fracture de l''ESF (R4.5), gestes neuraxiaux en urgence (R4.6.5)'),
  ('MG-ANES-000011-R77', 'Après procédure à risque hémorragique élevé : reprendre l''anticoagulation curative dès que l''hémostase chirurgicale le permet (à titre indicatif 24-72h).', '2+', 'Reprise post-procédure (R4.7) & filtre cave (R4.7.1)'),
  ('MG-ANES-000011-R78', 'Dans l''attente de la reprise curative : thromboprophylaxie veineuse médicamenteuse postopératoire quand indiquée.', '1+', 'Reprise post-procédure (R4.7) & filtre cave (R4.7.2)'),
  ('MG-ANES-000011-R79', 'Après procédure à faible risque : reprendre aux horaires habituels, au moins 6h après la fin du geste.', '2+', 'Reprise post-procédure (R4.7) & filtre cave (R4.7.3)'),
  ('MG-ANES-000011-R80', 'Procédure < 1 mois après TVP proximale/EP : discuter un filtre cave optionnel dès que possible (pré- ou postopératoire immédiat).', '2+', 'Reprise post-procédure (R4.7) & filtre cave (R4.8.1)'),
  ('MG-ANES-000011-R81', 'Procédure 1-3 mois après TVP/EP, reprise curative impossible dans les 72h post-op : discuter un filtre cave optionnel.', 'AE', 'Reprise post-procédure (R4.7) & filtre cave (R4.8.2)'),
  ('MG-ANES-000011-R82', 'Retirer le filtre dès que l''anticoagulation curative a pu être reprise sans complication et qu''aucun nouvel arrêt n''est prévu à court terme.', '1+', 'Reprise post-procédure (R4.7) & filtre cave (R4.8.3)'),
  ('MG-ANES-000011-R83', 'AVK, AVCi éligible à thrombolyse IV : thrombolyser si INR < 1,7.', '1+', 'Champ 5 — Thrombolyse d''un AVC ischémique sous anticoagulant (R5.1.2)'),
  ('MG-ANES-000011-R84', 'AVK, INR > 1,7 : ne pas thrombolyser, même après antagonisation.', 'AE', 'Champ 5 — Thrombolyse d''un AVC ischémique sous anticoagulant (R5.1.3)'),
  ('MG-ANES-000011-R85', 'AOD anti-Xa pris dans les 48h : thrombolyser si concentration < 50 ng/mL.', 'AE', 'Champ 5 — Thrombolyse d''un AVC ischémique sous anticoagulant (R5.1.4)'),
  ('MG-ANES-000011-R86', 'AOD anti-Xa ou dabigatran (48h) : ne pas administrer de CCP ni d''andexanet alfa pour permettre une thrombolyse.', 'AE', 'Champ 5 — Thrombolyse d''un AVC ischémique sous anticoagulant (R5.1.5)'),
  ('MG-ANES-000011-R87', 'AOD anti-Xa (48h) : ne pas thrombolyser si concentration ≥ 100 ng/mL.', 'AE', 'Champ 5 — Thrombolyse d''un AVC ischémique sous anticoagulant (R5.1.6)'),
  ('MG-ANES-000011-R88', 'AOD anti-Xa (48h), concentration entre 50 et 100 ng/mL : décision de thrombolyse au cas par cas.', 'AE', 'Champ 5 — Thrombolyse d''un AVC ischémique sous anticoagulant (R5.1.7)'),
  ('MG-ANES-000011-R89', 'Dabigatran (48h) : thrombolyser si concentration < 50 ng/mL (ou TT < 60 s), ou après antagonisation par idarucizumab 5 g IV.', 'AE', 'Champ 5 — Thrombolyse d''un AVC ischémique sous anticoagulant (R5.1.8)'),
  ('MG-ANES-000011-R90', 'HNF, HBPM ou fondaparinux à dose curative : ne pas thrombolyser.', 'AE', 'Champ 5 — Thrombolyse d''un AVC ischémique sous anticoagulant (R5.1.9)'),
  ('MG-ANES-000011-R91', 'Envisager une thrombectomie en cas d''occlusion proximale, que la thrombolyse ait été réalisée ou non.', '1+', 'Champ 5 — Thrombolyse d''un AVC ischémique sous anticoagulant (R5.1.10)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/download/gestion-de-lanticoagulation-dans-un-contexte-durgence/?wpdmdl=62045'
on conflict (recommendation_code) do nothing;
