-- Migration : Prise en charge des traumatisés pelviens graves à la phase
-- précoce (24 premières heures) — Recommandations Formalisées d'Experts
-- communes SFMU-SFAR, en collaboration avec la SFR, le SSA, l'AFU, la
-- SOFCOT et la SFCD. Anesth Reanim. 2019;5:427-442. Comité de 22 experts,
-- coordination P. Incagnoli (SFAR), A. Puidupin (SFMU). Texte validé par
-- le CA SFMU et le CA SFAR le 29/06/2017. Source :
-- rfe-sfar-website/build/content_traumatisme_pelvien.json (22
-- recommandations réparties en préhospitalier et hospitalier). Le
-- traitement du choc hémorragique (RFE dédiée) est explicitement exclu du
-- champ.
--
-- MÉTHODOLOGIE : GRADE®, tags « (GRADE X+/-) ACCORD FORT » imprimés
-- littéralement. `grade` reproduit tel quel le chip source. `evidence_level`
-- laissé NULL.
--
-- COMPTAGE — EXACTEMENT RECONCILIÉ (cas propre, aucun mismatch) : le
-- résumé officiel annonce "22 recommandations (5 préhospitalières, 17
-- hospitalières) ; 11 GRADE1, 11 GRADE2". Inventaire direct : R1.1-R1.5
-- (5 préhospitalières) + R2.1-R2.17 (17 hospitalières) = 22, avec 11×GRADE1
-- (R1.1, R1.3, R1.5, R2.4, R2.8, R2.9, R2.10, R2.13, R2.14, R2.15, R2.17,
-- tous 1+) et 11×GRADE2 (R1.2, R1.4, R2.1, R2.3, R2.6, R2.7, R2.12, R2.16
-- en 2+ ; R2.2, R2.5, R2.11 en 2-) — exactement reconcilié sur les deux
-- axes.
--
-- DISCLOSURE MÉTHODOLOGIQUE PARTICULIÈRE DE LA SOURCE ELLE-MÊME, REPRODUITE
-- SANS INVENTION : « Pour 9 questions posées, la méthode GRADE ne pouvait
-- pas s'appliquer par manque de littérature et n'aurait pu produire qu'un
-- avis d'experts — ces 9 questions n'ont délibérément pas été retenues pour
-- la rédaction du document source lui-même » — contrairement à la
-- quasi-totalité du corpus, ce document ne contient donc AUCUN panneau
-- « Absence de recommandation » ni item avis d'experts résiduel : les 9
-- questions exclues n'apparaissent nulle part dans le texte publié et ne
-- sont donc pas reproductibles ici (rien à migrer, rien à disclosurer
-- au-delà de cette mention).
--
-- PÉRIMÈTRE — volontairement pas migrés : les 2 classifications
-- anatomoradiologiques (Young-Burgess, Tile — planches anatomiques
-- illustrées dans la source, non reproduites par le contenu construit
-- lui-même ; leur contenu clinique de référence — mécanisme lésionnel et
-- catégories de stabilité — est résumé en tableau texte, associé à la
-- seule recommandation graduée R2.7 qui, elle, est migrée).
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. SFMU et SFAR (toutes deux dans le seed Annexe B) liées en
--    document_societies ; SFR, SSA, AFU, SOFCOT et SFCD (co-auteurs) hors
--    seed, non liées.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Prise en charge des traumatisés pelviens graves à la phase précoce (24 premières heures)',
  'RFE', 'fr', '2017-09-22',
  'https://sfar.org/prise-charges-traumatises-pelviens-graves-a-phase-precoce-24-premieres-heures/',
  'https://sfar.org/wp-content/uploads/2019/10/rfe-prise-en-charge-des-traumatises-pelviens-graves-a-la-phase-precoce.pdf',
  'GRADE® : force forte (1+ recommandé / 1- non recommandé) ou faible (2+ probablement recommandé / 2- probablement non recommandé). Comptage source ("22 recommandations : 11 GRADE1, 11 GRADE2") exactement reconcilié, aucun écart. Particularité disclosée par la source elle-même : 9 questions n''ayant pu aboutir qu''à un avis d''experts (littérature insuffisante) ont été délibérément exclues du document publié — aucun avis d''experts ni "absence de recommandation" dans ce texte.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/prise-charges-traumatises-pelviens-graves-a-phase-precoce-24-premieres-heures/'
  and s.acronym in ('SFMU', 'SFAR') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/prise-charges-traumatises-pelviens-graves-a-phase-precoce-24-premieres-heures/'
  and s.slug in ('medecine_d_urgence', 'anesthesie_reanimation', 'medecine_intensive_reanimation', 'chirurgie_orthopedique_et_traumatologique', 'urologie', 'radiologie_et_imagerie_medicale', 'chirurgie_digestive_et_viscerale')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, grade, source_section, source_url, status)
select v.code, d.id, v.statement, v.grade, v.source_section,
  'https://sfar.org/prise-charges-traumatises-pelviens-graves-a-phase-precoce-24-premieres-heures/',
  'draft'
from public.documents d, (values
  ('MG-ANES-000054-R01', 'Il est recommandé de considérer la douleur spontanée du pelvis chez un patient conscient comme un signe évocateur de fracture du bassin. Lorsque le patient est inconscient ou choqué, il doit être considéré systématiquement comme suspect d''un traumatisme pelvien.', '1+', 'Prise en charge préhospitalière (Réf. R1.1)'),
  ('MG-ANES-000054-R02', 'Il est probablement recommandé de considérer comme critères cliniques de gravité d''un traumatisme pelvien : un traumatisme pelvien ouvert, l''association avec une autre lésion traumatique grave, ou des signes cliniques de gravité d''hémorragie.', '2+', 'Prise en charge préhospitalière (Réf. R1.2)'),
  ('MG-ANES-000054-R03', 'Il est recommandé de mettre en place le plus tôt possible une contention externe du bassin chez tout patient suspect d''un traumatisme pelvien grave.', '1+', 'Prise en charge préhospitalière (Réf. R1.3)'),
  ('MG-ANES-000054-R04', 'Il est probablement recommandé d''utiliser comme contention externe du bassin une ceinture pelvienne, sans qu''un type particulier ne soit recommandé (à l''exclusion de draps noués). Pour avoir une efficacité comparable au C-clamp chirurgical elle doit être positionnée à hauteur des grands trochanters.', '2+', 'Prise en charge préhospitalière (Réf. R1.4)'),
  ('MG-ANES-000054-R05', 'Il est recommandé de transférer par transport médicalisé tous les patients présentant un traumatisme pelvien grave vers un centre de référence disposant d''un plateau technique spécialisé en première intention.', '1+', 'Prise en charge préhospitalière (Réf. R1.5)'),
  ('MG-ANES-000054-R06', 'Il est probablement recommandé de réaliser une radiographie de bassin de face dès l''admission si le patient est instable sur le plan hémodynamique ou nécessite des thérapeutiques urgentes pour contrôler les fonctions vitales.', '2+', 'Imagerie initiale (Réf. R2.1)'),
  ('MG-ANES-000054-R07', 'Il n''est probablement pas recommandé de réaliser une radiographie de bassin de face en dehors d''une instabilité hémodynamique à l''arrivée en salle d''accueil des détresses vitales, la réalisation rapide d''une tomodensitométrie thoraco-abdomino-pelvienne avec injection de produit de contraste pour bilan vasculaire et osseux complet du pelvis étant alors préférée.', '2-', 'Imagerie initiale (Réf. R2.2)'),
  ('MG-ANES-000054-R08', 'Il est probablement recommandé de réaliser une eFAST échographie chez tous les patients présentant un traumatisme sévère lors de la prise en charge d''un patient suspect d''un traumatisme grave du bassin.', '2+', 'Imagerie initiale (Réf. R2.3)'),
  ('MG-ANES-000054-R09', 'Il est recommandé de réaliser une tomodensitométrie thoraco-abdomino-pelvienne avec injection de produit de contraste avant la réalisation d''une artériographie à visée thérapeutique chez un patient victime d''un traumatisme pelvien grave si son état hémodynamique le permet.', '1+', 'Imagerie initiale (Réf. R2.4)'),
  ('MG-ANES-000054-R10', 'Il n''est probablement pas recommandé de réaliser à titre systématique une imagerie dédiée pour le bas appareil urinaire (opacification de l''urètre et de la vessie) chez un patient traumatisé pelvien grave.', '2-', 'Imagerie initiale (Réf. R2.5)'),
  ('MG-ANES-000054-R11', 'Il est probablement recommandé de réaliser une opacification rétrograde de l''urètre et de la vessie, couplée idéalement à une TDM pelvienne chez un patient traumatisé pelvien grave présentant des symptômes évocateurs de traumatisme de la vessie (impossibilité d''uriner, hématurie, empâtement sus-pubien douloureux, vessie sur le trajet d''une plaie pénétrante), en particulier avant tout sondage chez l''homme.', '2+', 'Imagerie initiale (Réf. R2.6)'),
  ('MG-ANES-000054-R12', 'Il est probablement recommandé de considérer comme critères anatomoradiologiques de traumatisme pelvien grave : une fracture du pelvis instable selon les classifications de Young-Burgess et de Tile, en particulier les fractures dites « open book » et les ruptures de l''anneau pelvien avec atteinte postérieure ; l''existence d''une extravasation de produit de contraste au temps artériel observée sur une angioscanographie ou une tomodensitométrie.', '2+', 'Critères de gravité anatomoradiologiques (Réf. R2.7)'),
  ('MG-ANES-000054-R13', 'Il est recommandé de réaliser un geste d''hémostase le plus rapidement possible en cas d''hémorragie active en lien avec un traumatisme pelvien grave. Le geste d''hémostase peut être une artériographie avec embolisation ou un tamponnement chirurgical pelvien pré-péritonéal de sauvetage réalisé par une équipe entraînée.', '1+', 'Délai et modalités d''hémostase (Réf. R2.8)'),
  ('MG-ANES-000054-R14', 'Il est recommandé que le délai entre l''admission hospitalière et le geste d''hémostase ne dépasse pas 60 minutes, quelle que soit la technique utilisée.', '1+', 'Délai et modalités d''hémostase (Réf. R2.9)'),
  ('MG-ANES-000054-R15', 'Les experts recommandent de réaliser une embolisation non sélective par un abord fémoral commun chez les patients instables, chez les patients stables présentant de nombreuses cibles identifiées en TDM ou à l''angiographie et en cas d''échec de l''embolisation sélective.', '1+', 'Embolisation (Réf. R2.10)'),
  ('MG-ANES-000054-R16', 'Il n''est probablement pas recommandé de réaliser un contrôle artériographique systématique chez tous les patients ayant bénéficié d''une artério-embolisation à la phase initiale de prise en charge d''un traumatisme pelvien grave.', '2-', 'Embolisation (Réf. R2.11)'),
  ('MG-ANES-000054-R17', 'Il est probablement recommandé d''avoir recours à un tamponnement pelvien pré-péritonéal chirurgical en association avec une fixation externe du bassin en cas d''instabilité hémodynamique majeure rendant impossible le transfert du patient au scanner et/ou en embolisation, ou la réalisation d''une artériographie-embolisation dans un délai de 60 minutes à partir du diagnostic.', '2+', 'Tamponnement pelvien et fixation externe (Réf. R2.12)'),
  ('MG-ANES-000054-R18', 'Il est recommandé de réaliser une fixation externe précoce du bassin chez les patients présentant un traumatisme pelvien grave avec instabilité hémodynamique pour limiter l''expansion de l''hématome pelvien. La fixation externe peut être réalisée par un Clamp de Ganz ou un fixateur externe antérieur.', '1+', 'Tamponnement pelvien et fixation externe (Réf. R2.13)'),
  ('MG-ANES-000054-R19', 'Il est recommandé d''utiliser un clamp de Ganz pour les fractures Tile C essentiellement, après traction lourde du membre ascensionné (15 % du poids corporel). Il peut être placé en salle d''urgence par des opérateurs entraînés.', '1+', 'Tamponnement pelvien et fixation externe (Réf. R2.14)'),
  ('MG-ANES-000054-R20', 'Il est recommandé d''utiliser un fixateur externe pour stabiliser les bassins dans les fractures Tile C et pour les refermer dans les fractures Tile B1 et B3. Il doit être placé en antéro-inférieur de façon à permettre la réalisation d''une laparotomie.', '1+', 'Tamponnement pelvien et fixation externe (Réf. R2.15)'),
  ('MG-ANES-000054-R21', 'Il est probablement recommandé d''assurer la prise en charge des traumatismes pelviens graves ouverts dans les centres de référence car les lésions pelviennes ouvertes sont rares, leur prise en charge est complexe et fait appel à des équipes multidisciplinaires.', '2+', 'Traumatisme pelvien grave ouvert (Réf. R2.16)'),
  ('MG-ANES-000054-R22', 'Il est recommandé de considérer comme objectifs initiaux de la prise en charge des traumatismes pelviens graves ouverts le contrôle de l''hémorragie et de la contamination périnéale.', '1+', 'Traumatisme pelvien grave ouvert (Réf. R2.17)')
) as v(code, statement, grade, source_section)
where d.source_url = 'https://sfar.org/prise-charges-traumatises-pelviens-graves-a-phase-precoce-24-premieres-heures/'
on conflict (recommendation_code) do nothing;
