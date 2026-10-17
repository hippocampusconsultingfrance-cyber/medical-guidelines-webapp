-- Demandes d'accord aux sociétés savantes (outil d'envoi, administrateurs) :
-- une ligne par société de l'atelier (societes/<slug>/ACCORD.md), avec les
-- adresses relevées sur son site, le courriel personnalisé, sa pièce jointe
-- et le suivi (envoi, relance, réponse, accord, refus).
--
--   - demandes_accord : lecture par les administrateurs ; aucune écriture
--     directe (actions serveur avec la clé service_role, après contrôle du
--     compte administrateur) ;
--   - demandes_accord_journal : chaque action (relevé, validation, envoi,
--     réponse…) ;
--   - demandes_accord_modele : une seule ligne, le courriel type et sa
--     relance, le paragraphe d'exemple et la pièce jointe par défaut ;
--   - bucket privé « demandes-accord » : pièces jointes (PDF), écrites et
--     lues par le serveur seulement (dépôt par lien signé).
-- Idempotent.

create table if not exists public.demandes_accord (
  id uuid primary key default gen_random_uuid(),
  societe_slug text not null unique check (societe_slug ~ '^[a-z0-9][a-z0-9-]*$'),
  sigle text not null,
  nom text,
  type text,
  specialite text,
  site text,
  priorite integer,
  nb_fiches integer not null default 0,
  nb_porteuse integer not null default 0,
  -- [{"adresse": "...", "nature": "...", "page": "https://..."}]
  adresses jsonb not null default '[]'::jsonb check (jsonb_typeof(adresses) = 'array'),
  destinataires text[] not null default '{}',
  designation text,
  formule_appel text,
  exemple text,
  revues text,
  paragraphe_specifique text,
  objet text,
  corps text,
  piece_jointe_chemin text,
  piece_jointe_nom text,
  etat text not null default 'a_preparer' check (etat in (
    'a_preparer', 'pret', 'valide', 'envoi_en_cours', 'envoye', 'relance',
    'reponse', 'accord', 'refus', 'ne_pas_contacter', 'erreur')),
  envoye_le timestamptz,
  envoi_id text,
  nb_envois integer not null default 0,
  relance_le timestamptz,
  reponse_le timestamptz,
  erreur text,
  notes text,
  releve_le timestamptz,
  cree_le timestamptz not null default now(),
  modifie_le timestamptz not null default now()
);
create index if not exists demandes_accord_etat_idx on public.demandes_accord (etat);
create index if not exists demandes_accord_envoye_idx on public.demandes_accord (envoye_le) where envoye_le is not null;

create table if not exists public.demandes_accord_journal (
  id bigint generated always as identity primary key,
  demande_id uuid not null references public.demandes_accord(id) on delete cascade,
  evenement text not null,
  detail text,
  auteur uuid references public.profiles(id) on delete set null,
  cree_le timestamptz not null default now()
);
create index if not exists demandes_accord_journal_demande_idx on public.demandes_accord_journal (demande_id, cree_le desc);
create index if not exists demandes_accord_journal_envoi_idx on public.demandes_accord_journal (cree_le) where evenement in ('envoi', 'relance');

create table if not exists public.demandes_accord_modele (
  id smallint primary key default 1 check (id = 1),
  objet text not null,
  corps text not null,
  exemple_defaut text not null,
  relance_objet text not null,
  relance_corps text not null,
  piece_jointe_chemin text,
  piece_jointe_nom text,
  modifie_le timestamptz not null default now()
);

alter table public.demandes_accord enable row level security;
alter table public.demandes_accord_journal enable row level security;
alter table public.demandes_accord_modele enable row level security;
revoke all on public.demandes_accord, public.demandes_accord_journal, public.demandes_accord_modele from anon, authenticated;
grant select on public.demandes_accord, public.demandes_accord_journal, public.demandes_accord_modele to authenticated;

drop policy if exists demandes_accord_select_admin on public.demandes_accord;
create policy demandes_accord_select_admin on public.demandes_accord for select
  to authenticated using (public.is_admin());
drop policy if exists demandes_accord_journal_select_admin on public.demandes_accord_journal;
create policy demandes_accord_journal_select_admin on public.demandes_accord_journal for select
  to authenticated using (public.is_admin());
drop policy if exists demandes_accord_modele_select_admin on public.demandes_accord_modele;
create policy demandes_accord_modele_select_admin on public.demandes_accord_modele for select
  to authenticated using (public.is_admin());

-- Courriel type (modifiable dans l'outil). Repères remplacés pour chaque
-- société : {{formule_appel}}, {{la_societe}}, {{de_la_societe}}, {{paragraphe_place}},
-- {{paragraphe_exemple}}, {{offre_lien}}, {{paragraphe_specifique}},
-- {{paragraphe_revues}} ; un paragraphe dont le repère est vide disparaît.
insert into public.demandes_accord_modele (id, objet, corps, exemple_defaut, relance_objet, relance_corps)
values (
  1,
  'Demande d''autorisation et proposition de partenariat : medical-guidelines.net',
  $modele${{formule_appel}},

Je suis le Dr Ahmed Ben Lallahom, anesthésiste-réanimateur, fondateur d'Hippocampus Consulting, SARL au capital de 1 000 € (6 rue d'Armaillé, 75017 Paris, SIREN 999 259 252). La société conçoit des services numériques destinés aux professionnels de santé.

Elle édite medical-guidelines.net (https://www.medical-guidelines.net), un site qui aide les médecins, les internes et les professionnels paramédicaux à retrouver, lire et appliquer les recommandations professionnelles, sous forme de fiches de synthèse lisibles sur téléphone.

Notre ambition est de rassembler en un même lieu les recommandations du monde entier, en commençant par l'anesthésie-réanimation, notre spécialité pilote. Nous avons déjà recensé plus de 400 sociétés savantes et organisations de la discipline dans le monde. Nous développons aussi un assistant de recherche destiné en priorité aux internes et aux jeunes praticiens. Il les aidera à retrouver une recommandation et à comparer, sans arbitrer, ce que préconisent les différents pays sur une même question, avec un renvoi systématique vers chaque texte officiel. Cet outil reste un outil de recherche documentaire : il ne donne aucun avis sur un patient et ne remplace pas le jugement clinique.

{{paragraphe_place}}

- chaque fiche cite la société auteur et la référence complète du document, conserve la force de chaque recommandation telle qu'elle figure dans le texte et renvoie directement au texte officiel ;
- les recommandations sont présentées sous une forme condensée, propre à la fiche ; nos fiches ne reproduisent ni les argumentaires, ni les figures, ni le logo de la société ;
- chaque fiche est relue par un médecin avant publication, et les erreurs signalées sont corrigées et publiées dans un journal des corrections ;
- le site précise que les fiches sont des synthèses indépendantes, ni éditées ni validées par la société auteur, qui ne remplacent ni le texte officiel ni le jugement clinique.

{{paragraphe_exemple}}

Nous souhaitons établir un partenariat avec {{la_societe}}. Nous pourrions notamment vous proposer :

- un accès gratuit et illimité à l'ensemble du site pour cinq personnes que vous désignerez, comme nous le proposons à toutes les sociétés savantes partenaires ;
- des statistiques anonymes de lecture de vos recommandations, en France et, à terme, à l'étranger, utiles pour suivre leur diffusion ;
- les retours du terrain : erreurs et questions signalées par nos lecteurs sur vos textes ;
- {{offre_lien}}

Le site est édité par une société commerciale, et l'accès complet aux fiches est réservé aux membres inscrits. Afin d'inscrire ce travail dans un cadre clair et respectueux de vos droits, nous sollicitons votre autorisation écrite de reprendre vos recommandations dans les fiches de medical-guidelines.net et dans le cadre de l'activité d'Hippocampus Consulting. Elles y figurent reformulées ou, lorsque la précision l'exige, citées (certains tableaux sont ainsi repris fidèlement), avec leur grade lorsqu'elles en ont un, la référence complète et le lien vers votre site.

{{paragraphe_specifique}}

{{paragraphe_revues}}

Je serais heureux de vous présenter le site et notre projet lors d'un échange, à la date qui vous conviendra.

Je vous prie d'agréer, {{formule_appel}}, l'expression de mes salutations distinguées.

Dr Ahmed Ben Lallahom
Anesthésiste-réanimateur
Fondateur d'Hippocampus Consulting, éditeur de medical-guidelines.net
www.medical-guidelines.net · WhatsApp Business : +33 9 72 15 24 13$modele$,
  $exemple$Pour illustrer notre méthode, je vous joins un exemple réalisé avec la SFAR : notre fiche consacrée aux RFE SFAR–SFMU « Intubation en urgence d'un adulte hors bloc opératoire et hors unité des soins critiques » (2024). Elle est suivie du texte original et d'une comparaison mot à mot des deux documents : 3,1 % des passages de la fiche se retrouvent à l'identique dans le texte original, surtout des termes techniques et quelques fragments d'énoncés courts, tous listés dans la comparaison.$exemple$,
  'Relance : demande d''autorisation et proposition de partenariat (medical-guidelines.net)',
  $relance${{formule_appel}},

Je me permets de revenir vers vous au sujet de mon courriel du {{date_envoi}}, par lequel je sollicitais l'autorisation {{de_la_societe}} de reprendre ses recommandations dans les fiches de medical-guidelines.net, et vous proposais un partenariat. Je vous en joins de nouveau la pièce jointe.

Je reste à votre disposition pour un échange, à la date qui vous conviendra.

Je vous prie d'agréer, {{formule_appel}}, l'expression de mes salutations distinguées.

Dr Ahmed Ben Lallahom
Anesthésiste-réanimateur
Fondateur d'Hippocampus Consulting, éditeur de medical-guidelines.net
www.medical-guidelines.net · WhatsApp Business : +33 9 72 15 24 13$relance$
)
on conflict (id) do nothing;

-- Bucket privé (Supabase Storage), sans règle d'accès pour les membres :
-- seul le serveur y écrit (lien de dépôt signé) et y lit.
do $$
begin
  if to_regclass('storage.buckets') is not null then
    insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
    values ('demandes-accord', 'demandes-accord', false, 15728640, array['application/pdf'])
    on conflict (id) do update
      set public = false,
          file_size_limit = excluded.file_size_limit,
          allowed_mime_types = excluded.allowed_mime_types;
  end if;
end $$;
