-- Migration : Antibiothérapie probabiliste des états septiques graves — SFAR, Conférence
-- d'experts, texte court 2004 (travail réalisé 2001-2003)
-- Source : rfe-sfar-website/build/content_antibiotherapie_probabiliste.json (37
-- recommandations atomiques : 12 tableaux "Situation clinique | Antibiothérapie
-- probabiliste proposée", un par site infectieux, sections 4.1 à 4.12).
--
-- AUCUN GRADE — disclosure déjà faite par le contenu construit lui-même : le texte source
-- imprime un tableau méthodologique général des "niveaux de preuve en médecine factuelle"
-- (Niveau I à V), mais une lecture exhaustive du corps du texte (sections 4.1 à 4.12) ne
-- montre AUCUN renvoi explicite d'une proposition individuelle à l'un de ces niveaux — à la
-- différence, par exemple, de la conférence de consensus "Corticothérapie" de la même année
-- (déjà relevé par le contenu construit). grade et evidence_level sont donc laissés NULL
-- sur les 37 lignes : pas une valeur par défaut, une absence réelle documentée dans la
-- source et déjà signalée par le contenu construit — encore plus radical que
-- allergie_prevention (0006), qui conservait au moins des citations NP ponctuelles.
--
-- Le dernier tableau du document ("Principaux antibiotiques prescrits — posologie de la
-- première injection", 24 lignes Famille/Antibiotique/Posologie/Voie) N'EST PAS migré comme
-- recommandations : c'est un tableau de référence posologique générique (comme les
-- Tableaux 3-4 de allergie_prevention ou le Tableau de pharmacologie AAP de aap_urgence),
-- pas des recommandations situationnelles — chaque situation clinique concrète et son choix
-- d'antibiothérapie associé est déjà couvert par les 37 lignes migrées ci-dessous.
--
-- À VÉRIFIER (disclosure, pas une invention) :
-- 1. Ce document est historiquement une "Conférence d'experts" (texte court 2004, travail
--    2001-2003), pas formellement une "RFE" au sens où le terme est employé pour les
--    documents plus récents de ce corpus — `library_final.json` le classe néanmoins comme
--    `exact_type: "RFE"` (catégorisation large et cohérente avec le reste de l'index) ;
--    doc_type ci-dessous reprend 'RFE' pour cohérence avec library_final.json, le libellé
--    historique exact ("Conférence d'experts") est conservé dans grading_system.
-- 2. Les 4 sociétés co-organisatrices citées par le contenu construit sous leur nom complet
--    ("Société de réanimation de langue française", "Société de pathologie infectieuse de
--    langue française", "Société française de médecine d'urgence") correspondent
--    respectivement à SRLF, SPILF et SFMU du seed Annexe B — toutes les 3 liées ci-dessous
--    en plus de SFAR (contrairement à la plupart des migrations précédentes, où un seul
--    co-signataire figurait dans le seed). "Société de microbiologie", "Médecine
--    militaire" et "Société française de pédiatrie" (co-auteurs également cités) ne
--    figurent pas dans le seed Annexe B — non liées.
-- 3. Document de 2004 (21 ans à la date de cette migration) : `freshness_status` ci-dessous
--    reste 'a_jour' par défaut faute d'information de retrait/mise à jour dans
--    `library_final.json` (`status: "en vigueur"`), mais un relecteur humain devrait
--    vérifier l'existence d'une version plus récente avant publication (l'antibiothérapie
--    probabiliste est un domaine où l'écologie bactérienne évolue vite) — disclosure
--    volontaire, pas une vérification que cette routine peut faire elle-même.

insert into public.documents (title, doc_type, original_language, publication_date, source_url, pdf_url, grading_system, freshness_status)
values (
  'Antibiothérapie probabiliste des états septiques graves',
  'RFE', 'fr', '2004-01-01',
  'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Antibiotherapie-probabiliste-des-etats-septiques-graves.pdf',
  'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Antibiotherapie-probabiliste-des-etats-septiques-graves.pdf',
  'Conférence d''experts (texte court 2004, travail réalisé 2001-2003) — tableau méthodologique général de "niveaux de preuve en médecine factuelle" (I à V) imprimé par la source, mais AUCUNE proposition individuelle n''y renvoie explicitement (vérifié par lecture exhaustive du corps du texte) : document non coté item par item.',
  'a_jour'
)
on conflict (source_url) do nothing;

insert into public.document_societies (document_id, society_id)
select d.id, s.id from public.documents d, public.societies s
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Antibiotherapie-probabiliste-des-etats-septiques-graves.pdf'
  and s.acronym in ('SFAR', 'SRLF', 'SPILF', 'SFMU') and s.country_or_region = 'France'
on conflict do nothing;

insert into public.document_specialties (document_id, specialty_id)
select d.id, s.id from public.documents d, public.specialties s
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Antibiotherapie-probabiliste-des-etats-septiques-graves.pdf'
  and s.slug in ('anesthesie_reanimation', 'medecine_intensive_reanimation', 'infectiologie_maladies_infectieuses_et_tropicales', 'medecine_d_urgence')
on conflict do nothing;

insert into public.recommendations (recommendation_code, document_id, statement, condition_topic, source_section, source_url, status)
select v.code, d.id, v.statement, v.condition_topic, v.source_section,
  'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Antibiotherapie-probabiliste-des-etats-septiques-graves.pdf',
  'draft'
from public.documents d, (values
  ('MG-ANES-000010-R01', 'C3G (céfotaxime ou ceftriaxone) IV immédiat.', 'Purpura fulminans', '4.1 Méningites communautaires'),
  ('MG-ANES-000010-R02', 'C3G + vancomycine, puis TDM cérébrale et PL.', 'Signes neurologiques de localisation', '4.1 Méningites communautaires'),
  ('MG-ANES-000010-R03', 'C3G + vancomycine (40 à 60 mg/kg/jour).', 'Examen direct du LCR positif — Cg + (pneumocoque)', '4.1 Méningites communautaires'),
  ('MG-ANES-000010-R04', 'C3G ou amoxicilline.', 'Examen direct du LCR positif — Cg – (méningocoque)', '4.1 Méningites communautaires'),
  ('MG-ANES-000010-R05', 'Amoxicilline (200 mg/kg/jour) + gentamicine (3 à 5 mg/kg/jour).', 'Examen direct du LCR positif — Bg + (listéria)', '4.1 Méningites communautaires'),
  ('MG-ANES-000010-R06', 'C3G (céfotaxime 200 à 300 mg/kg/jour).', 'Examen direct du LCR positif — Bg – (Haemophilus influenzae)', '4.1 Méningites communautaires'),
  ('MG-ANES-000010-R07', 'C3G + vancomycine.', 'Examen direct négatif — liquide trouble (PNN), glycorachie basse', '4.1 Méningites communautaires'),
  ('MG-ANES-000010-R08', 'Amoxicilline + gentamicine + antibiothérapie antituberculeuse.', 'Examen direct négatif — LCR clair lymphocytaire, glycorachie basse', '4.1 Méningites communautaires'),
  ('MG-ANES-000010-R09', 'Aciclovir.', 'Examen direct négatif — LCR lymphocytaire, glycorachie normale', '4.1 Méningites communautaires'),
  ('MG-ANES-000010-R10', 'Examen bactériologique du LCR systématique avant toute antibiothérapie. Céfotaxime + fosfomycine en première intention ; selon la bactérie suspectée : ceftazidime, imipénème, fluoroquinolones ou vancomycine.', 'Méningites postopératoires', '4.2 Méningites nosocomiales et abcès cérébraux postopératoires'),
  ('MG-ANES-000010-R11', 'Amoxicilline.', 'Méningites post-traumatiques', '4.2 Méningites nosocomiales et abcès cérébraux postopératoires'),
  ('MG-ANES-000010-R12', 'Amoxicilline–acide clavulanique (2 g/8 h) ou céfotaxime (2 g/8 h) ou ceftriaxone (2 g/jour) + érythromycine (1 g/8 h) ou ofloxacine (200 mg × 2) ou lévofloxacine (500 mg × 2).', 'Schéma standard', '4.3 Pneumopathies communautaires'),
  ('MG-ANES-000010-R13', 'Glycopeptide + ofloxacine.', 'Allergie prouvée aux pénicillines et aux C3G', '4.3 Pneumopathies communautaires'),
  ('MG-ANES-000010-R14', 'Bêtalactamine antipseudomonas + ciprofloxacine (400 mg/8 h).', 'Risque de P. aeruginosa (antibiothérapie fréquente, DDB, corticothérapie au long cours)', '4.3 Pneumopathies communautaires'),
  ('MG-ANES-000010-R15', 'Bêtalactamine sans activité anti-P. aeruginosa en monothérapie : céfotaxime ou ceftriaxone ou amoxicilline–acide clavulanique.', 'PAVM précoce (< 7 jours de ventilation), sans antibiothérapie ni hospitalisation antérieure dans un service à risque', '4.4 Pneumopathies nosocomiales (PAVM)'),
  ('MG-ANES-000010-R16', 'Bêtalactamine à activité anti-P. aeruginosa + amikacine ou ciprofloxacine ; associer la vancomycine s''il existe des facteurs de risque de SDMR ; prendre en compte legionella si facteurs de risque et/ou antigènes urinaires positifs. Retour à l''antibiothérapie la plus simple efficace dès que possible, sur prélèvements fiables réalisés avant tout traitement et antibiogramme dès que la culture est positive.', 'PAVM tardive (≥ 7 jours), ou précoce avec antibiothérapie préalable ou hospitalisation antérieure dans un service à risque', '4.4 Pneumopathies nosocomiales (PAVM)'),
  ('MG-ANES-000010-R17', 'Fluoroquinolones (ofloxacine ou ciprofloxacine) ou C3G (céfotaxime ou ceftriaxone). Bithérapie dans les formes graves avec hypotension : C3G + fluoroquinolones ou aminoside (nétilmicine ou gentamicine) ; ou fluoroquinolones + aminoside en cas d''allergie aux bêtalactamines. Pendant la grossesse, les fluoroquinolones sont contre-indiquées : amoxicilline–acide clavulanique + aminoside (surtout si entérocoque suspecté).', 'IU communautaires', '4.5 Infections urinaires communautaires et nosocomiales'),
  ('MG-ANES-000010-R18', 'Discussion au cas par cas selon la colonisation du patient, l''écologie du service et l''examen direct de l''ECBU. Chez l''homme, en cas d''infection prostatique, privilégier les molécules à forte diffusion prostatique : fluoroquinolones ou cotrimoxazole.', 'IU nosocomiales', '4.5 Infections urinaires communautaires et nosocomiales'),
  ('MG-ANES-000010-R19', 'Amoxicilline–acide clavulanique (2 g × 3/jour) + aminoside (gentamicine ou nétilmicine 5 mg/kg) ; ou ticarcilline–acide clavulanique (5 g × 3/jour) + aminoside ; ou céfotaxime/ceftriaxone + aminoside. Entérocoque : rôle pathogène reconnu, pas de consensus pour le traitement.', 'Péritonites communautaires', '4.6 Infections intra-abdominales communautaires et nosocomiales'),
  ('MG-ANES-000010-R20', 'Pipéracilline–tazobactam (4,5 g × 4/jour) + amikacine (20 mg/kg × 1/jour) ; ou imipénème (1 g × 3/jour) + amikacine (20 mg/kg) ; ± vancomycine (15 mg/kg) si SAMR ou entérocoque résistant à l''amoxicilline ; ± fluconazole (800 mg/jour).', 'Péritonites nosocomiales et postopératoires', '4.6 Infections intra-abdominales communautaires et nosocomiales'),
  ('MG-ANES-000010-R21', 'Amoxicilline–acide clavulanique (1,2 g/6 h) ou céfotaxime (2 g/8 h) ou ceftriaxone (2 g/jour).', 'Péritonites primaires du cirrhotique', '4.6 Infections intra-abdominales communautaires et nosocomiales'),
  ('MG-ANES-000010-R22', 'Imipénème, ou fluoroquinolones, ou association céfotaxime + métronidazole.', 'Sans antibiothérapie préalable', '4.7 Pancréatites'),
  ('MG-ANES-000010-R23', 'Association imipénème + vancomycine + fluconazole.', 'Antibiothérapie préalable, hospitalisation prolongée, manœuvres endoscopiques ou nécrosectomie antérieure', '4.7 Pancréatites'),
  ('MG-ANES-000010-R24', 'Amoxicilline–acide clavulanique + gentamicine ou nétilmicine ; ou ticarcilline–acide clavulanique ; ou pipéracilline + métronidazole ; ou céfoxitine ; ou céfotaxime/ceftriaxone + métronidazole. Si signes de gravité : associer gentamicine ou nétilmicine.', 'Angiocholite aiguë communautaire', '4.8 Angiocholites aiguës'),
  ('MG-ANES-000010-R25', 'Pipéracilline–tazobactam + amikacine ; ou imipénème + amikacine ; ou ceftazidime + métronidazole + amikacine.', 'Angiocholite nosocomiale ou post-CPRE (facteur de risque identifié d''infection à entérocoque)', '4.8 Angiocholites aiguës'),
  ('MG-ANES-000010-R26', 'Amoxicilline–acide clavulanique (2 g × 3/jour) + gentamicine ou nétilmicine (5 mg/kg/jour).', 'Atteinte des membres et de la région cervicofaciale', '4.9 Infections cutanées et des tissus mous — gangrène et cellulite'),
  ('MG-ANES-000010-R27', 'Céfotaxime/ceftriaxone + métronidazole, ou amoxicilline–acide clavulanique, associés à gentamicine ou nétilmicine.', 'Gangrène périnéale communautaire', '4.9 Infections cutanées et des tissus mous — gangrène et cellulite'),
  ('MG-ANES-000010-R28', 'Pipéracilline–tazobactam (16 g/jour) ou imipénème (1 g × 3/jour) + amikacine (20 mg/kg/jour).', 'Gangrène postopératoire', '4.9 Infections cutanées et des tissus mous — gangrène et cellulite'),
  ('MG-ANES-000010-R29', 'Cloxacilline (2 g/4 h) + gentamicine (1,5 mg/kg/12 h) ou nétilmicine (3 mg/kg/12 h).', 'Valve native — suspicion de staphylocoque communautaire', '4.10 Endocardites'),
  ('MG-ANES-000010-R30', 'Amoxicilline–acide clavulanique (2 g/4 h) + gentamicine (1,5 mg/kg/12 h) ou nétilmicine (3 mg/kg/12 h).', 'Valve native — sans élément d''orientation', '4.10 Endocardites'),
  ('MG-ANES-000010-R31', 'Vancomycine (15 mg/kg/12 h) + gentamicine (1,5 mg/kg/12 h) ou nétilmicine (3 mg/kg/12 h).', 'Valve native — allergie vraie aux pénicillines', '4.10 Endocardites'),
  ('MG-ANES-000010-R32', 'Vancomycine (15 mg/kg/12 h) + rifampicine (600 mg/12 h) + gentamicine (1,5 mg/kg/12 h) ou nétilmicine (3 mg/kg/12 h).', 'Valve prothétique, quelle que soit l''ancienneté de la chirurgie — cas général', '4.10 Endocardites'),
  ('MG-ANES-000010-R33', 'Vancomycine (15 mg/kg/12 h) + ceftazidime (2 g/8 h) + gentamicine (1,5 mg/kg/12 h) ou nétilmicine (3 mg/kg/12 h).', 'Valve prothétique — si échec ou contexte particulier', '4.10 Endocardites'),
  ('MG-ANES-000010-R34', 'Vancomycine (15 mg/kg × 2) + céfépime (2 g × 2) + gentamicine ; ou vancomycine (15 mg/kg × 2) + ceftazidime + amikacine ; ou vancomycine + imipénème + amikacine.', 'Schémas proposés', '4.11 Infection sur cathéter'),
  ('MG-ANES-000010-R35', 'Discussion de l''amphotéricine B.', 'Facteurs de risque d''infection à levures', '4.11 Infection sur cathéter'),
  ('MG-ANES-000010-R36', 'C3G (céfotaxime ou ceftriaxone) + gentamicine ou nétilmicine + métronidazole.', 'Infection communautaire', '4.12 Sepsis sans porte d''entrée suspectée'),
  ('MG-ANES-000010-R37', 'Imipénème ou ceftazidime ou céfépime + amikacine + vancomycine ± métronidazole (inutile si imipénème).', 'Infection nosocomiale (y compris patients en institution ou hospitalisés dans les 30 jours précédents)', '4.12 Sepsis sans porte d''entrée suspectée')
) as v(code, statement, condition_topic, source_section)
where d.source_url = 'https://sfar.org/wp-content/uploads/2015/10/2_AFAR_Antibiotherapie-probabiliste-des-etats-septiques-graves.pdf'
on conflict (recommendation_code) do nothing;
