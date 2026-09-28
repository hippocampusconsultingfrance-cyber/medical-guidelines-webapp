-- Migration : Tenue vestimentaire au bloc opératoire (RPP commune SFAR-SF2H,
-- avec validation de l'Association Française de Chirurgie [AFC] et du
-- Collectif EcoResponsabilité En Santé [CERES]). Texte validé par le Comité
-- des Référentiels Cliniques de la SFAR (05/05/2021), le CA de la SFAR
-- (19/05/2021), le Conseil Scientifique de la SF2H (06/05/2021) et le CA de
-- l'AFC/CERES (28/05/2021).
-- Source : rfe-sfar-website/build/content_tenue_vestimentaire.json (4
-- champs thématiques — tenue de bloc R1.1-R1.5, articles coiffants
-- R2.1-R2.2, masques R3.1-R3.2, chaussures/sur-chaussures R4.1-R4.2 —
-- chaque énoncé numéroté est déjà atomique, un seul sujet et un seul grade
-- ; aucune fragmentation/fusion supplémentaire nécessaire).
--
-- ⚠️ DISCLOSURE — INCOHÉRENCE INTERNE AU DOCUMENT SOURCE (reproduite du
-- contenu construit lui-même) : le paragraphe méthodologique annonce "13
-- recommandations", mais le compte direct des énoncés individuellement
-- tagués "Avis d'expert (Accord Fort)" donne 16 — aucun regroupement
-- évident par numéro parent (ex. R1.1.1+R1.1.2 sous "R1.1") ne réconcilie
-- exactement ce chiffre avec 13. Les deux chiffres sont disclosed tels
-- quels ; cette migration retient 16, le compte vérifiable par énumération
-- directe des 16 lignes gradées R1.1.1-R4.2 (numérotation native complète
-- de la source, conservée telle quelle dans les `recommendation_code`).
--
-- MÉTHODOLOGIE — GRADE annoncé mais non intégralement applicable (majorité
-- des questions relevant d'un avis d'expert plutôt que d'un niveau de
-- preuve gradable) : formulation uniforme "les experts suggèrent de
-- faire/de ne pas faire", cotation Delphi GRADE grid. Toutes les
-- recommandations sont à `grade` = 'AE' (avis d'expert), Accord fort à
-- 100% selon la source (le schéma n'a pas de colonne dédiée à ce tag de
-- consensus Delphi distincte de `grade` — même limite que `protection_
-- oculaire`/0076 — donc non porté par une colonne séparée, disclosed ici
-- seulement). `evidence_level` laissé NULL sur les 16 lignes : aucun niveau
-- de preuve gradable distinct n'est identifié (GRADE non intégralement
-- applicable, cf. ci-dessus).
--
-- SF2H (co-autrice à parité avec SFAR), AFC et CERES (validateurs), ne
-- figurent PAS dans le seed Annexe B (`public.societies`) : seule SFAR
-- (dans le seed) est liée en `document_societies` ci-dessous — même cas de
-- figure que `allergie_prevention`/0006, `tih_2002`/0072 et `protection_
-- oculaire`/0076 (co-sociétés absentes du seed).
--
-- SOURCE_URL / PDF_URL / `publication_date` : `library_final.json`
-- (recherche "tenue vestimentaire" — exactement 1 correspondance) donne
-- `href`, `direct_pdf_url` (identique à l'"URL source" du contenu
-- construit) et `exact_date` (2021-09-25, date de publication du texte
-- final — distincte des 4 dates de validation par comité/CA de mai 2021
-- citées par le contenu construit, disclosed séparément ici, non
-- confondues). `doc_type` = 'RPP' (Recommandation pour la Pratique
-- Professionnelle), format explicite de la source (pas une RFE).
--
-- `specialties` : `anesthesie_reanimation` uniquement — sujet
-- transversal à tout le personnel de bloc opératoire (pas seulement
-- anesthésique), mais pas de spécialité "bloc opératoire"/"hygiène
-- hospitalière" générique dans le seed Annexe B à ce jour ; même choix que
-- `protection_oculaire`/0076 pour un contexte procédural transversal sans
-- spécialité dédiée disponible.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Tenue vestimentaire au bloc opératoire',
  'RPP', 'fr', '2021-09-25',
  'https://sfar.org/tenue-vestimentaire-au-bloc-operatoire/',
  'https://sfar.org/download/tenue-vestimentaire-au-bloc-operatoire/?wpdmdl=35399',
  'GRADE annoncé mais non intégralement applicable (avis d''expert majoritaire) : formulation uniforme "les experts suggèrent de faire/de ne pas faire" (grade AE), cotation Delphi GRADE grid, Accord fort à 100% selon la source sur les 16 recommandations reproduites. La source annonce elle-même "13 recommandations" mais le compte direct des énoncés individuellement gradés donne 16 — incohérence interne disclosed, non résolue (voir commentaire de migration). Validé par le Comité des Référentiels Cliniques SFAR (05/05/2021), le CA SFAR (19/05/2021), le Conseil Scientifique SF2H (06/05/2021) et le CA AFC/CERES (28/05/2021).',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/tenue-vestimentaire-au-bloc-operatoire/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/tenue-vestimentaire-au-bloc-operatoire/'
  and s.slug in ('anesthesie_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.source_section,
  'https://sfar.org/tenue-vestimentaire-au-bloc-operatoire/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000079-R01', 'Le personnel de bloc opératoire porte une tenue dédiée au bloc opératoire, indifféremment à usage unique ou réutilisable, pour prévenir le risque infectieux pour le patient.', 'AE', 'Tenue de bloc opératoire', 'Champ 1 — Tenue de bloc opératoire, R1.1.1'),
  ('MG-ANES-000079-R02', 'Le personnel porte une tenue réutilisable plutôt qu''une tenue à usage unique, pour diminuer l''impact environnemental.', 'AE', 'Tenue de bloc opératoire — réutilisable vs usage unique', 'Champ 1 — Tenue de bloc opératoire, R1.1.2'),
  ('MG-ANES-000079-R03', 'Réaliser un essai sur le terrain des différents produits sélectionnés (efficacité, coût environnemental) auprès du personnel qui les utilisera, pour en apprécier les caractéristiques d''usage.', 'AE', 'Essai terrain des produits sélectionnés', 'Champ 1 — Tenue de bloc opératoire, R1.2'),
  ('MG-ANES-000079-R04', 'En cas de souhait de se protéger du froid, le personnel porte par-dessus sa tenue une veste à manches longues, indifféremment à usage unique ou réutilisable.', 'AE', 'Protection du froid — veste à manches longues', 'Champ 1 — Tenue de bloc opératoire, R1.3.1'),
  ('MG-ANES-000079-R05', 'Le personnel qui souhaite se protéger du froid n''utilise pas une casaque chirurgicale stérile dans cette indication (surcoût, risque de contamination de la tenue si la casaque traîne au sol).', 'AE', 'Protection du froid — contre-indication de la casaque stérile', 'Champ 1 — Tenue de bloc opératoire, R1.3.2'),
  ('MG-ANES-000079-R06', 'Le personnel ne quitte pas le bloc opératoire avec sa tenue de bloc, pour en limiter la contamination.', 'AE', 'Sortie du bloc opératoire avec la tenue de bloc', 'Champ 1 — Tenue de bloc opératoire, R1.4.1'),
  ('MG-ANES-000079-R07', 'Si le personnel doit, à titre exceptionnel, répondre à un motif impérieux et quitter le bloc avec sa tenue, il en change à son retour.', 'AE', 'Sortie exceptionnelle — changement de tenue au retour', 'Champ 1 — Tenue de bloc opératoire, R1.4.2'),
  ('MG-ANES-000079-R08', 'En cas de sortie courte (quelques minutes), une alternative possible est de couvrir sa tenue de bloc par une blouse fermée.', 'AE', 'Sortie courte — alternative de la blouse fermée', 'Champ 1 — Tenue de bloc opératoire, R1.4.3'),
  ('MG-ANES-000079-R09', 'Le personnel change de tenue de bloc en cas de souillures, et au minimum à la fin de chaque journée de travail.', 'AE', 'Fréquence de changement de la tenue de bloc', 'Champ 1 — Tenue de bloc opératoire, R1.5'),
  ('MG-ANES-000079-R10', 'Le personnel porte un article coiffant, indifféremment à usage unique ou réutilisable, lors de sa présence dans l''enceinte du bloc opératoire, pour prévenir le risque infectieux.', 'AE', 'Port d''un article coiffant', 'Champ 2 — Articles coiffants, R2.1.1'),
  ('MG-ANES-000079-R11', 'Le personnel porte un article coiffant réutilisable soumis à un entretien régulier plutôt qu''un article à usage unique, pour diminuer l''impact environnemental.', 'AE', 'Article coiffant — réutilisable vs usage unique', 'Champ 2 — Articles coiffants, R2.1.2'),
  ('MG-ANES-000079-R12', 'Le personnel porte un article coiffant recouvrant toute la chevelure — indifféremment une charlotte, un calot ou une cagoule, aucun type n''ayant démontré de supériorité pour prévenir le risque infectieux.', 'AE', 'Type d''article coiffant — absence de supériorité démontrée', 'Champ 2 — Articles coiffants, R2.2'),
  ('MG-ANES-000079-R13', 'Le personnel non-chirurgical de bloc opératoire porte un masque à usage médical de type II ou IIR (norme NF EN 14683:2019) en salle d''intervention, pour diminuer le risque de transmission de micro-organismes à partir de l''oropharynx et du nez.', 'AE', 'Masque du personnel non-chirurgical en salle', 'Champ 3 — Masques, R3.1'),
  ('MG-ANES-000079-R14', 'Le personnel change de masque chirurgical quand celui-ci devient humide ou présente des traces de projections de liquides biologiques, pour diminuer le risque de transmission de micro-organismes.', 'AE', 'Fréquence de changement du masque chirurgical', 'Champ 3 — Masques, R3.2'),
  ('MG-ANES-000079-R15', 'Pour réduire la contamination de l''environnement du bloc opératoire, le personnel porte des chaussures réservées exclusivement à l''enceinte du bloc (norme EN ISO 20347:2012), changées au minimum quotidiennement (et plus en cas de souillures visibles), lavées régulièrement en machine.', 'AE', 'Chaussures dédiées au bloc opératoire', 'Champ 4 — Chaussures / sur-chaussures, R4.1'),
  ('MG-ANES-000079-R16', 'Le personnel ne porte pas de sur-chaussures en plus des chaussures dédiées — le port de sur-chaussures n''est pas plus efficace pour réduire la contamination de l''environnement, et s''accompagne d''un risque de contamination des mains. Exception : port possible à titre exceptionnel, par-dessus les chaussures dédiées, en cas de risque élevé de projection de sang et/ou de liquides biologiques en grande quantité — désinfection des mains obligatoire après la pose et le retrait des sur-chaussures.', 'AE', 'Sur-chaussures — non-recommandation et exception', 'Champ 4 — Chaussures / sur-chaussures, R4.2')
) as v(code, statement, grade, condition_topic, source_section)
where d.source_url = 'https://sfar.org/tenue-vestimentaire-au-bloc-operatoire/'
on conflict (recommendation_code) do nothing;
