-- Migration : Anesthésie Loco-Régionale périnerveuse (ALR-PN) — RFE SFAR,
-- validée par le CA de la SFAR le 18/11/2016, publiée Anesth Reanim
-- 2019;5:208-217 (Open Access CC BY 4.0). Met à jour la RPC-ALR 2003 de la
-- SFAR SANS la remplacer (toujours valide pour les données anatomocliniques
-- et techniques de base) — périmètre volontairement limité aux 24 premières
-- heures postopératoires.
-- Source : rfe-sfar-website/build/content_alr_perinerveuse.json (4 groupes
-- de travail — médicaments R1.1-R1.3, écueils liés au terrain R2.1-R2.3,
-- stratégies d'utilisation R3.1-R4.2, hygiène et sécurité R5.1-R5.2 —
-- chaque énoncé numéroté est déjà atomique).
--
-- ⚠️ DISCLOSURE — INCOHÉRENCE INTERNE AU DOCUMENT SOURCE (reproduite du
-- contenu construit lui-même) : le paragraphe méthodologique contient un
-- texte manifestement non finalisé — "XX recommandations ont été
-- formalisées" (XX littéralement non renseigné) — avec une répartition
-- annoncée (4 fortes/5 faibles/5 avis d'experts = 14) qui ne correspond pas
-- au compte direct des recommandations réellement présentes dans le texte
-- (12, R1.1-R5.2 : 2 Grade 1 [1×1+, 1×1-], 5 Grade 2 [3×2+, 2×2-], 5 avis
-- d'experts). Le contenu construit qualifie cela de "très probablement un
-- paragraphe-modèle d'un autre document RFE resté non adapté avant
-- publication" — hypothèse non vérifiable, non retenue comme un fait établi
-- ici. Cette migration retient 12 (le compte vérifiable par énumération
-- directe des lignes R1.1-R5.2), ni "XX" ni 14.
--
-- Éléments explicitement NON formalisés en recommandation numérotée (donc
-- non migrés) mais disclosed dans le contenu construit : clonidine en
-- adjuvant (balance bénéfice-risque au cas par cas, non formalisée),
-- dexaméthasone (jugée prématurée par le groupe de travail), place
-- respective ALR-PN/infiltrations (littérature contradictoire), indications
-- par type de chirurgie (explicitement non proposées par la source), et le
-- point d'actualisation "Relecture RPC 2003 — complications neurologiques"
-- (conduite à tenir, hors recommandation numérotée gradée).
--
-- MÉTHODOLOGIE — GRADE standard : qualité des preuves en 4 catégories
-- (Haute/Modérée/Basse/Très basse, non détaillée par recommandation dans le
-- contenu reproduit), force binaire forte (1+/1-) ou faible (2+/2-),
-- validée par vote Delphi GRADE Grid — seuls les ECR permettent une
-- recommandation forte (Grade 1), sauf question à implication vitale
-- majeure où l'allocation randomisée serait contraire à l'éthique ; un avis
-- d'experts (AE) n'est validé qu'en cas d'accord fort (>70%). Toutes les
-- recommandations du texte sont à Accord fort (pas de colonne dédiée à ce
-- tag dans le schéma, disclosed seulement — même limite que `protection_
-- oculaire`/0076 et `tenue_vestimentaire`/0079). `evidence_level` laissé
-- NULL sur les 12 lignes — aucune catégorie de qualité des preuves n'est
-- indiquée individuellement par recommandation dans le contenu construit.
--
-- SOURCE_URL / PDF_URL / publication_date : `library_final.json` (recherche
-- "périnerveuse" — exactement 1 correspondance) donne `href`,
-- `direct_pdf_url` (identique à l'"URL source" du contenu construit) et
-- `exact_date` (2016-12-02, cohérente avec la validation CA SFAR du
-- 18/11/2016 citée par le contenu construit).
--
-- `specialties` : `anesthesie_reanimation` uniquement.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Anesthésie Loco-Régionale périnerveuse (ALR-PN)',
  'RFE', 'fr', '2016-12-02',
  'https://sfar.org/anesthesie-loco-regionale-perinerveuse/',
  'https://sfar.org/wp-content/uploads/2019/10/rfe-anesthesie-loco-regionale-perinerveuse.pdf',
  'GRADE standard : qualité des preuves en 4 catégories (non détaillée par recommandation dans le contenu reproduit), force binaire forte (1+/1-) ou faible (2+/2-), avis d''experts (AE) validé si accord fort >70%, vote Delphi GRADE Grid. 12 recommandations reproduites (comptage exhaustif direct : 2 Grade 1, 5 Grade 2, 5 AE), toutes à Accord fort. Le paragraphe de méthodologie de la source contient un texte non finalisé ("XX recommandations", répartition annoncée 4/5/5=14) incompatible avec le compte direct de 12 — incohérence interne disclosed, non résolue, voir commentaire de migration. Met à jour (ne remplace pas) la RPC-ALR 2003 SFAR.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/anesthesie-loco-regionale-perinerveuse/'
  and (s.acronym, s.country_or_region) in (('SFAR', 'France'))
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/anesthesie-loco-regionale-perinerveuse/'
  and s.slug in ('anesthesie_reanimation')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.condition_topic, v.source_section,
  'https://sfar.org/anesthesie-loco-regionale-perinerveuse/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000080-R01', 'Les mélanges d''AL (longue durée d''action + courte durée d''action) ne sont probablement pas recommandés si l''objectif est la réduction de la toxicité des AL.', '2-', 'Mélanges d''anesthésiques locaux — toxicité', 'Groupe 1 — Médicaments, R1.1'),
  ('MG-ANES-000080-R02', 'Il est recommandé d''utiliser l''échoguidage pour la réalisation d''une ALR périnerveuse, dans le but d''obtenir, pour une efficacité équivalente ou supérieure aux autres techniques, une réduction de la dose (volume et concentration) d''AL utilisés et donc du risque de toxicité systémique.', '1+', 'Échoguidage — réduction de dose d''anesthésiques locaux', 'Groupe 1 — Médicaments, R1.2'),
  ('MG-ANES-000080-R03', 'Il n''est pas recommandé d''associer aux AL en périnerveux les agonistes morphiniques, le tramadol, la naloxone ou le magnésium, du fait de l''absence de bénéfice clinique significatif en termes de durée ou d''efficacité.', '1-', 'Adjuvants péri-nerveux non recommandés', 'Groupe 1 — Médicaments, R1.3'),
  ('MG-ANES-000080-R04', 'Il faut probablement administrer des émulsions lipidiques intraveineuses au cours d''une intoxication systémique aux anesthésiques locaux, en complément des mesures de réanimation.', 'AE', 'Intoxication systémique aux anesthésiques locaux — émulsions lipidiques', 'Groupe 2 — Écueils liés au terrain, R2.1'),
  ('MG-ANES-000080-R05', 'Il n''existe aucune contre-indication à la réalisation d''une ALR périnerveuse chez le patient septique, à la condition de ne pas ponctionner directement au niveau de la zone infectée.', 'AE', 'ALR périnerveuse chez le patient septique', 'Groupe 2 — Écueils liés au terrain, R2.2'),
  ('MG-ANES-000080-R06', 'Chez un patient traité par anticoagulant oral direct (AOD) à dose curative et en dehors de l''urgence, il est probablement recommandé de respecter un intervalle d''arrêt de 3 jours avant l''ALR-PN (dernière prise à J-3), sauf dabigatran pour lequel une dernière prise à J-4 ou J-5 est préférable.', 'AE', 'ALR-PN sous anticoagulant oral direct — délai d''arrêt', 'Groupe 2 — Écueils liés au terrain, R2.3'),
  ('MG-ANES-000080-R07', 'Il n''est probablement pas recommandé de réaliser systématiquement une ALR périnerveuse (bloc fémoral, bloc ilio-fascial ou bloc du plexus lombaire par voie postérieure) pour le contrôle de la douleur postopératoire en chirurgie programmée de la hanche.', '2-', 'ALR périnerveuse en chirurgie programmée de la hanche', 'Groupe 3 — Stratégies d''utilisation, R3.1'),
  ('MG-ANES-000080-R08', 'Pour la chirurgie du membre supérieur, il est probablement recommandé de réaliser une ALR périnerveuse par bloc des branches du plexus brachial comme seule technique anesthésique, pour un bénéfice sur les NVPO, l''épargne morphinique et la durée de séjour en SSPI.', '2+', 'ALR périnerveuse en chirurgie du membre supérieur', 'Groupe 3 — Stratégies d''utilisation, R3.2'),
  ('MG-ANES-000080-R09', 'Pour la chirurgie de la carotide, la réalisation d''un bloc du plexus cervical superficiel est probablement recommandée en alternative ou associée à l''AG, pour la réalisation de la chirurgie et un meilleur contrôle de la douleur postopératoire immédiate.', '2+', 'Bloc du plexus cervical superficiel en chirurgie carotidienne', 'Groupe 3 — Stratégies d''utilisation, R4.1'),
  ('MG-ANES-000080-R10', 'Pour la chirurgie de la thyroïde, la réalisation d''un bloc cervical superficiel bilatéral, associé à l''AG, est probablement recommandée pour réduire les doses d''agents anesthésiques peropératoires et contrôler la douleur postopératoire immédiate.', '2+', 'Bloc cervical superficiel bilatéral en chirurgie thyroïdienne', 'Groupe 3 — Stratégies d''utilisation, R4.2'),
  ('MG-ANES-000080-R11', 'Lorsqu''un bloc périphérique est réalisé seul, il est recommandé de réaliser une durée de surveillance (clinique + monitorage) d''au moins 30 minutes après une ALR du membre supérieur et 60 minutes après une ALR du membre inférieur (réalisée sans autre anesthésie : sédation, AG ou ALR périmédullaire).', 'AE', 'Durée de surveillance post-ALR périnerveuse', 'Groupe 4 — Hygiène et sécurité, R5.1'),
  ('MG-ANES-000080-R12', 'Il est probablement recommandé en première intention de réaliser une ALR chez un patient éveillé ou légèrement sédaté, calme et coopérant. Après discussion avec le patient, un bloc associé à une anesthésie (générale ou régionale) ou une sédation profonde reste possible s''il existe un bénéfice — traçabilité du choix importante ; l''échoguidage apporte alors probablement une sécurité supplémentaire.', 'AE', 'État de vigilance du patient lors de la réalisation de l''ALR', 'Groupe 4 — Hygiène et sécurité, R5.2')
) as v(code, statement, grade, condition_topic, source_section)
where d.source_url = 'https://sfar.org/anesthesie-loco-regionale-perinerveuse/'
on conflict (recommendation_code) do nothing;
