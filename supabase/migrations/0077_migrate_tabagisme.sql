-- Migration : Recommandations sur la prise en charge du tabagisme en période
-- périopératoire (RFE SFAR 2016, avec Société Française de Tabacologie [SFT],
-- Comité National Contre le Tabagisme [CNCT], SOFCOT, CNP Chirurgie Plastique,
-- CNP Chirurgie Thoracique et Cardio-vasculaire — actualisation de la
-- conférence d'experts OFT/SFAR/AFC de 2005).
-- Source : rfe-sfar-website/build/content_tabagisme.json (document très
-- court et déjà entièrement atomique : un tableau "N° | Recommandation |
-- Grade" de 4 lignes R1-R4, chacune un seul énoncé "il faut/il est
-- recommandé" avec un seul grade — aucune fragmentation ni fusion
-- nécessaire). Le contenu source lui-même annonce "4 recommandations au
-- total, toutes Grade 1+", confirmé par recomptage direct (aucune
-- incohérence à disclosed ici, contrairement à `protection_oculaire`/0076).
--
-- Question 5 (cigarette électronique) N'EST PAS migrée en recommandation :
-- le contenu source dit explicitement "Aucune recommandation n'a pu être
-- formulée" (seuil de consensus GRADE Grid — ≥50% pour / <20% contre — non
-- atteint sur les deux propositions soumises au vote). Ce n'est pas un
-- énoncé "il faut faire X", donc hors périmètre du modèle `recommendations`
-- (même traitement que les panneaux de contexte/méthodologie des autres
-- fiches déjà migrées, ex. `protection_oculaire`/0076).
--
-- SOURCE_URL / PDF_URL : `library_final.json` (recherche "tabagisme" —
-- exactement 1 correspondance) donne `href` (utilisé ci-dessous comme
-- documents.source_url) et `direct_pdf_url`, qui coïncide exactement avec
-- l'"URL source" citée par le contenu construit lui-même
-- (sfar.org/wp-content/uploads/2016/08/2-SFAR-RFE-tabac_proposition-CRC.pdf)
-- — correspondance confirmée, pas seulement supposée. `exact_date`
-- (2016-09-01) de l'index utilisé comme publication_date ; le contenu
-- construit dit seulement "Version : 2016" sans jour/mois précis.
--
-- MÉTHODOLOGIE — GRADE standard (pas de variante bespoke ici, contrairement
-- à `protection_oculaire`/0076) : qualité des preuves en 4 catégories
-- (Haute/Modérée/Basse/Très basse — non reproduites individuellement par
-- recommandation dans le contenu construit, seul le chip de force de
-- recommandation l'est), force binaire forte (1+/1-) ou faible (2+/2-),
-- validée par vote GRADE Grid (≥50% favorables et <20% contraires).
-- `grade` reproduit le chip source ('1+' sur les 4 lignes) ; `evidence_level`
-- laissé NULL — aucune catégorie de qualité des preuves n'est indiquée
-- individuellement par recommandation dans le contenu construit.
--
-- SFT/CNCT/SOFCOT/CNP Chirurgie Plastique/CNP Chirurgie Thoracique et
-- Cardio-vasculaire, co-auteurs explicitement cités par le contenu
-- construit, ne figurent PAS dans le seed Annexe B (`public.societies`) :
-- seule SFAR (dans le seed) est liée en `document_societies` ci-dessous —
-- même cas de figure que `allergie_prevention`/0006, `tih_2002`/0072 et
-- `protection_oculaire`/0076 (co-sociétés absentes du seed).
--
-- `specialties` : `anesthesie_reanimation` uniquement — sujet
-- transversal (sevrage tabagique périopératoire, tous types de chirurgie
-- confondus dans la source), pas de spécialité chirurgicale ou de
-- tabacologie/pneumologie dans le seed Annexe B à ce jour.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Recommandations sur la prise en charge du tabagisme en période périopératoire',
  'RFE', 'fr', '2016-09-01',
  'https://sfar.org/recommandations-sur-la-prise-en-charge-du-tabagisme-en-periode-perioperatoire/',
  'https://sfar.org/wp-content/uploads/2016/08/2-SFAR-RFE-tabac_proposition-CRC.pdf',
  'GRADE standard : qualité des preuves en 4 catégories (Haute/Modérée/Basse/Très basse, non détaillée par recommandation dans le contenu reproduit), force binaire forte (1+/1-, "il est recommandé de faire/ne pas faire") ou faible (2+/2-, "il est probablement recommandé"), validée par vote GRADE Grid (>=50% experts favorables et <20% contraires). 4 recommandations reproduites, toutes grade 1+. Question 5 (cigarette électronique) : aucune recommandation formulée, seuil de consensus non atteint — non migrée en recommandation (disclosure intégrale en base, voir commentaire de migration).',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/recommandations-sur-la-prise-en-charge-du-tabagisme-en-periode-perioperatoire/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/recommandations-sur-la-prise-en-charge-du-tabagisme-en-periode-perioperatoire/'
  and s.slug in ('anesthesie_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, population, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.population, v.source_section,
  'https://sfar.org/recommandations-sur-la-prise-en-charge-du-tabagisme-en-periode-perioperatoire/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000077-R01', 'Offrir une prise en charge comportementale et la prescription d''une substitution nicotinique pour l''arrêt du tabac avant toute intervention chirurgicale programmée — une intervention comportementale intensive (consultation dédiée, suivi 4 semaines, substituts nicotiniques) multiplie par 10 le taux de sevrage préopératoire et réduit les complications de 60% vs absence d''intervention ; les substituts nicotiniques n''augmentent pas la douleur postopératoire ni la consommation d''opiacés.', '1+', 'Prise en charge comportementale et substitution nicotinique avant chirurgie programmée', null, 'Question 1 — Recommandation R1'),
  ('MG-ANES-000077-R02', 'Recommander systématiquement l''arrêt préopératoire du tabac, indépendamment de la date d''intervention. Seuils de délai : arrêt > 8 semaines avant l''intervention → environ -50% de complications respiratoires vs fumeur actif ; arrêt > 4 semaines → environ -25% ; arrêt entre 2 et 4 semaines → pas de réduction démontrée des complications respiratoires ; aucun effet délétère respiratoire démontré pour un arrêt < 2 semaines avant la chirurgie. Bénéfice sur la cicatrisation démontré après 3-4 semaines d''arrêt. Le bénéfice augmente proportionnellement à la durée du sevrage, quel que soit le délai par rapport à l''intervention.', '1+', 'Arrêt préopératoire du tabac, indépendamment de la date d''intervention', null, 'Question 2 — Recommandation R2'),
  ('MG-ANES-000077-R03', 'Tous les professionnels du parcours de soins (chirurgiens, anesthésistes-réanimateurs, soignants) doivent informer les fumeurs des effets positifs de l''arrêt du tabac et leur proposer une prise en charge dédiée et un suivi personnalisé — un conseil bref (<20 min, ≤1 visite de suivi) augmente l''abstinence à 6 mois de 60%, un conseil intensif (>20 min, >1 visite, brochure) l''augmente de plus de 80% (conseil intensif supérieur au conseil bref en comparaison directe).', '1+', 'Information et suivi personnalisé par les professionnels du parcours de soins', null, 'Question 3 — Recommandation R3'),
  ('MG-ANES-000077-R04', 'Recommander l''arrêt du tabagisme parental ou l''éviction de l''enfant de tout environnement tabagique, le plus en amont possible de l''intervention — le tabagisme passif chez l''enfant multiplie par 2 le risque d''effets indésirables périopératoires lors d''une anesthésie générale (toux, laryngospasme, bronchospasme, désaturation). Aucune étude n''a établi le délai nécessaire entre l''arrêt du tabac parental et la réduction du risque chez l''enfant.', '1+', 'Éviction tabagique parentale/environnementale chez l''enfant', 'Enfant exposé au tabagisme parental/environnemental', 'Question 4 — Recommandation R4')
) as v(code, statement, grade, condition_topic, population, source_section)
where d.source_url = 'https://sfar.org/recommandations-sur-la-prise-en-charge-du-tabagisme-en-periode-perioperatoire/'
on conflict (recommendation_code) do nothing;
