-- Vague 0 du plan d'intégration (docs/referentiel/PLAN_INTEGRATION_SOCIETES_SAVANTES.md,
-- section 8) : sociétés françaises hors SFAR, plus la HAS, la SFMU et deux
-- co-signataires de textes SFAR déjà en base (CARORL, ARMPO).
--
--   - sociétés déjà en base (créées sans pays comme co-signataires) :
--     pays « France » et code FR ; site officiel renseigné s'il manque ;
--   - sociétés absentes : créées « à valider », avec le nom et le site du
--     référentiel (docs/referentiel/plan-integration-vagues.csv).
--
-- Un nom, un pays ou un site déjà saisi n'est jamais remplacé. Le statut
-- reste « à valider » : la validation appartient à l'équipe éditoriale.
-- Rien n'est publié. Idempotent.

with v0 (acronym, full_name, website_url) as (values
  ('ADARPEF', 'Association des anesthésistes-réanimateurs pédiatriques d''expression française', 'https://www.adarpef.org/'),
  ('ANARLF', 'Association de neuro-anesthésie réanimation de langue française', 'https://www.anarlf.fr/'),
  ('ARCOTHOVA', 'Association pour la recherche en anesthésie-réanimation cœur-thorax-vaisseaux', 'https://arcothova.com/'),
  ('ARMPO', 'Conseil national professionnel d''anesthésie-réanimation et médecine péri-opératoire', null),
  ('CARO', 'Collège d''anesthésie-réanimation en obstétrique', 'https://caro-college.fr/'),
  ('CARORL', 'Club d''anesthésie-réanimation en ORL', null),
  ('CFAR', 'Collège français des anesthésistes-réanimateurs', 'https://cfar.org/'),
  ('CFRC', 'Conseil français de réanimation cardiovasculaire', 'https://www.cfrc.fr/'),
  ('GFRUP', 'Groupe francophone de réanimation et urgences pédiatriques', 'https://gfrup.sfpediatrie.com/'),
  ('GIHP', 'Groupe d''intérêt en hémostase périopératoire', 'https://www.gihp.org/'),
  ('GRACE', 'Groupe francophone de réhabilitation améliorée après chirurgie', 'https://grace-asso.fr/'),
  ('HAS', 'Haute Autorité de santé', 'https://www.has-sante.fr/'),
  ('SFB', 'Société francophone de brûlologie', 'https://www.sfb-brulure.com/'),
  ('SFMU', 'Société française de médecine d''urgence', 'https://www.sfmu.org/'),
  ('SOFIA', 'Société française des infirmier(e)s anesthésistes', 'https://sofia.medicalistes.fr/'),
  ('SRLF', 'Société de réanimation de langue française', 'https://www.srlf.org/')
),
maj as (
  update public.societies s
     set country_or_region = coalesce(s.country_or_region, 'France'),
         country_code = coalesce(s.country_code, 'FR'),
         website_url = coalesce(s.website_url, v0.website_url)
    from v0
   where s.acronym = v0.acronym
     and coalesce(s.country_or_region, 'France') = 'France'
  returning s.acronym
)
insert into public.societies (acronym, full_name, country_or_region, country_code, website_url)
select v0.acronym, v0.full_name, 'France', 'FR', v0.website_url
  from v0
 where not exists (select 1 from public.societies s where s.acronym = v0.acronym);

-- Rôle : la société porteuse d'un document en est l'auteur (les fiches
-- importées avant le rôle sont co-signées par défaut).
update public.document_societies ds
   set role = 'auteur'
  from public.documents d
 where d.id = ds.document_id
   and d.society_id = ds.society_id
   and ds.role <> 'auteur';

-- Autres sociétés déjà rangées en France : code pays.
update public.societies set country_code = 'FR'
 where country_or_region = 'France' and country_code is null;

-- Décisions du porteur de projet (03/10/2026) : nom officiel du CARO (logo
-- de la société : « Collège », et non « Club ») ; sociétés créées par la
-- vague 0 validées.
update public.societies set full_name = 'Collège d''anesthésie-réanimation en obstétrique'
 where acronym = 'CARO' and full_name = 'Club d''anesthésie-réanimation en obstétrique';
update public.societies set vetting_status = 'valide'
 where acronym in ('ARCOTHOVA', 'CFAR', 'CFRC', 'GRACE', 'SOFIA') and vetting_status = 'a_valider';
update public.societies set full_name = 'Association de neuro-anesthésie réanimation de langue française'
 where acronym = 'ANARLF' and full_name = 'Association des neuro-anesthésistes réanimateurs de langue française';
