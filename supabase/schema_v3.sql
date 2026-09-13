-- Medical Guidelines — schéma V3 (accès par spécialité + moteur de
-- tarification/promotion)
-- Réfère : Cahier des charges medical-guidelines.net V4.0 (fourni par le
-- porteur de projet le 2026-09-13 — fusion V2.1 + V3.3 + nouvelles
-- exigences), notamment §5.6 (accès au contenu par spécialité), §9.2,
-- §11 (abonnement/tarification/promotions) et Annexe D (moteur de
-- tarification détaillé). Complète schema.sql + schema_v2.sql — à exécuter
-- après les deux, dans l'ordre schema.sql -> schema_v2.sql -> schema_v3.sql.
--
-- Toutes les instructions sont idempotentes, comme schema_v2.sql.

-- =========================================================================
-- 1. Défaut interim de specialty_id (§5.6, §2.4) — DÉCISION À RÉÉVALUER
-- =========================================================================
-- À VÉRIFIER / décision interim explicite, pas une invention silencieuse :
-- le référentiel `specialties` (schema_v2.sql, Annexe A) et la liste de
-- professions utilisée à l'inscription (src/lib/professions.ts, V1, texte
-- libre, ~55 intitulés) ne sont reliés par AUCUNE table de correspondance.
-- profiles.specialty_id (ajouté par schema_v2.sql) n'est donc renseigné par
-- AUCUN flux existant aujourd'hui. Construire une correspondance fiable
-- profession-libre -> specialty_id pour ~55 intitulés contre 51 spécialités
-- serait un travail de référentiel à part entière (même rigueur que le
-- reste du projet : pas de correspondance devinée), hors périmètre de cette
-- migration.
--
-- Décision interim retenue ici, à réévaluer EXPLICITEMENT à la Phase 4
-- (§15 — ouverture d'une 2e spécialité) : tant que le catalogue ne contient
-- QUE de l'anesthésie-réanimation (§2.4 — vrai pour la totalité des 72
-- documents migrés au 2026-09-13, à 2 exceptions près listées plus bas),
-- assigner specialty_id = 'anesthesie_reanimation' par défaut à la création
-- de compte n'écarte aucun profil paramédical ou d'une autre spécialité
-- d'un contenu qui ne existe pas encore pour eux de toute façon — c'est le
-- mécanisme d'accès qui est activé ici, pas un choix éditorial arbitraire.
-- Ce défaut DEVRA être remplacé par une vraie correspondance avant la
-- Phase 4, sans quoi tout nouveau compte resterait à tort cantonné à
-- l'anesthésie-réanimation même une fois une 2e spécialité ouverte.
-- PostgreSQL interdit une sous-requête directement dans un DEFAULT de
-- colonne ("cannot use subquery in DEFAULT expression") : le défaut passe
-- par une petite fonction stable plutôt que par une expression inline.
create or replace function public.default_specialty_id()
returns uuid
language sql
stable
as $$
  select id from public.specialties where slug = 'anesthesie_reanimation';
$$;

alter table public.profiles alter column specialty_id
  set default public.default_specialty_id();

-- Pas de backfill générique ici ("where specialty_id is null" -> défaut) :
-- ça écraserait à tort les profils "Autre" que le résolveur de la section 7
-- laisse délibérément à NULL (file de revue). Le backfill réel, basé sur
-- profession_specialty_map plutôt qu'un défaut aveugle, est fait en fin de
-- section 7 — seul endroit du fichier qui connaît la bonne règle pour
-- chaque profil.

-- Le DEFAULT de colonne ci-dessus ne couvre que le cas générique (ex. un
-- insert manuel qui omet specialty_id) : handle_new_user() (schema.sql),
-- qui gère la vraie création de compte, est mis à jour plus bas (section 7)
-- pour résoudre specialty_id via la table de correspondance
-- profession_specialty_map plutôt que ce défaut unique — inutile de le
-- redéfinir ici pour ensuite le re-remplacer.

-- =========================================================================
-- 2. Accès au contenu par spécialité (§5.6) — comptes authentifiés
-- =========================================================================
-- Portée délibérément limitée aux utilisateurs AUTHENTIFIÉS : la consigne
-- porte sur "chaque COMPTE" ("chaque compte donne un accès pour la
-- spécialité choisie") — elle ne tranche pas le comportement des visiteurs
-- anonymes, question déjà "À VÉRIFIER" séparément dans schema_v2.sql
-- (profondeur Gratuit/Pro d'une recommandation active). Les deux questions
-- ne sont pas mélangées ici : le comportement anonyme actuel reste
-- inchangé par cette migration.
create or replace function public.has_specialty_access(target_specialty_id uuid)
returns boolean
language sql
stable
as $$
  select auth.uid() is not null and exists (
    select 1 from public.profiles p
    where p.id = auth.uid() and p.specialty_id = target_specialty_id
  );
$$;
-- Pas de "security definer" ici : profiles_select_own (schema.sql)
-- autorise déjà chaque utilisateur à lire sa PROPRE ligne (auth.uid() =
-- id) — aucun contournement de RLS n'est nécessaire, contrairement à
-- is_admin()/has_editorial_role() qui doivent lire le rôle d'un profil
-- AUTRE que l'appelant.

drop policy if exists documents_select_public on public.documents;
create policy documents_select_public on public.documents for select
  using (
    public.has_editorial_role('relecteur')
    or (
      (freshness_status <> 'retiree' and public.document_has_active_recommendation(documents.id))
      and (
        auth.uid() is null -- visiteur anonyme : comportement V2 inchangé (À VÉRIFIER séparé, ci-dessus)
        or exists (
          select 1 from public.document_specialties ds
          where ds.document_id = documents.id and public.has_specialty_access(ds.specialty_id)
        )
      )
    )
  );

drop policy if exists recommendations_select_public on public.recommendations;
create policy recommendations_select_public on public.recommendations for select
  using (
    public.has_editorial_role('relecteur')
    or (
      status = 'active' and public.document_is_visible(recommendations.document_id)
      and (
        auth.uid() is null
        or exists (
          select 1 from public.document_specialties ds
          where ds.document_id = recommendations.document_id and public.has_specialty_access(ds.specialty_id)
        )
      )
    )
  );
-- Effet réel connu et volontaire au 2026-09-13 : 2 des 72 documents migrés
-- (asthme_aigu_grave, corticotherapie — SRLF, non tagués
-- anesthesie_reanimation dans document_specialties, cf. leurs migrations)
-- deviennent invisibles à un compte anesthésie-réanimation dès l'activation
-- de cette policy. Ce n'est pas une régression : ces deux documents ne
-- relèvent pas de la spécialité pilote (ils sont tagués
-- medecine_intensive_reanimation/pneumologie/etc. exclusivement) — c'est
-- exactement l'effet recherché par §5.6, rendu visible dès maintenant sur
-- 2 documents plutôt qu'invisible jusqu'à la Phase 4.

-- =========================================================================
-- 3. Tarifs par offre, administrables (§11.4, §11.7)
-- =========================================================================
-- "Le back-office doit permettre à l'administrateur de définir ou modifier
-- le tarif [...]. Une modification tarifaire ne doit cependant pas modifier
-- rétroactivement une facture déjà émise" (§11.4) — d'où une table de tarifs
-- COURANTS séparée des lignes subscriptions, qui snapshotent leur propre
-- reference_price_cents/current_price_cents au moment voulu (section 4).
create table if not exists public.plan_prices (
  plan text primary key check (plan in ('professional', 'essential', 'paramedical')),
  price_cents integer not null check (price_cents >= 0),
  currency text not null default 'EUR',
  updated_by uuid references public.profiles(id) on delete set null,
  updated_at timestamptz not null default now()
);

alter table public.plan_prices enable row level security;
drop policy if exists plan_prices_select_all on public.plan_prices;
create policy plan_prices_select_all on public.plan_prices for select using (true); -- page tarifs publique
drop policy if exists plan_prices_write_admin on public.plan_prices;
create policy plan_prices_write_admin on public.plan_prices for all
  using (public.is_admin()) with check (public.is_admin());

drop trigger if exists set_plan_prices_updated_at on public.plan_prices;
create trigger set_plan_prices_updated_at
  before update on public.plan_prices
  for each row execute function public.set_updated_at();

-- Tarifs de lancement (§11.1).
insert into public.plan_prices (plan, price_cents) values
  ('professional', 1290), ('essential', 590), ('paramedical', 790)
on conflict (plan) do nothing;

-- =========================================================================
-- 4. Abonnements — nouveau modèle de plans + essai + promotion (§11.1-11.9)
-- =========================================================================
-- CORRECTIF DE MODÈLE (V4 §0, arbitrage documenté) : schema_v2.sql (V2.1)
-- modélisait plan in ('gratuit','pro','etudiant_interne','institution').
-- Le cahier des charges V4 remplace ce modèle par 3 offres fermes
-- (PROFESSIONAL/ESSENTIAL/PARAMEDICAL, §11.1) + institution (Phase 6, §18).
-- Migration de valeur avant de resserrer la contrainte (idempotent, sûre
-- même si des lignes de test existent déjà — cette base n'est, comme
-- schema_v2.sql, jamais exécutée en production) :
update public.subscriptions set plan = 'essential' where plan in ('gratuit', 'etudiant_interne');
update public.subscriptions set plan = 'professional' where plan = 'pro';

alter table public.subscriptions drop constraint if exists subscriptions_plan_check;
alter table public.subscriptions add constraint subscriptions_plan_check
  check (plan in ('professional', 'essential', 'paramedical', 'institution'));

-- Essai (§11.1 : "Essai gratuit : 15 jours" + "passage automatique à un
-- abonnement payant si l'utilisateur ne résilie pas").
alter table public.subscriptions add column if not exists trial_ends_at timestamptz;

-- §11.5 : "Pour chaque abonnement, le système doit conserver : le tarif de
-- référence au moment de la souscription [...] le montant effectivement
-- facturé chaque mois [...] le tarif applicable après expiration de la
-- promotion." reference_price_cents fige plan_prices au jour J (jamais
-- réécrit par une modification tarifaire ultérieure, §11.4) ;
-- current_price_cents est le montant réellement facturé CE mois-ci (varie
-- entre période promo/post-promo) ; post_promo_price_cents est nullable et
-- rempli par l'application à/près de la fin de promo (§11.4 : le tarif du
-- 13e mois n'est PAS figé à la souscription, donc pas dérivable ici par un
-- simple calcul at-signup).
alter table public.subscriptions add column if not exists reference_price_cents integer;
alter table public.subscriptions add column if not exists current_price_cents integer;
alter table public.subscriptions add column if not exists post_promo_price_cents integer;

-- §11.2-11.5 : code promo utilisé + snapshot de la réduction (le code peut
-- changer/expirer après coup — la ligne d'abonnement doit rester exacte
-- indépendamment de l'état futur de promotion_codes).
alter table public.subscriptions add column if not exists promotion_code_id uuid;
alter table public.subscriptions add column if not exists promo_discount_type text
  check (promo_discount_type is null or promo_discount_type in ('percentage', 'fixed_amount'));
alter table public.subscriptions add column if not exists promo_discount_value numeric;
alter table public.subscriptions add column if not exists promo_started_at timestamptz;
alter table public.subscriptions add column if not exists promo_ends_at timestamptz; -- §11.3 : début + 12 mois

-- =========================================================================
-- 5. Codes promotionnels et traçabilité des rédemptions (Annexe D)
-- =========================================================================
create table if not exists public.promotion_codes (
  id uuid primary key default gen_random_uuid(),
  code text unique not null,
  name text not null,
  description text,
  discount_type text not null check (discount_type in ('percentage', 'fixed_amount')),
  discount_value numeric not null check (discount_value > 0),
  currency text not null default 'EUR',
  starts_at timestamptz,
  ends_at timestamptz,
  is_active boolean not null default true,
  max_redemptions int check (max_redemptions is null or max_redemptions > 0),
  max_redemptions_per_user int not null default 1 check (max_redemptions_per_user > 0),
  first_subscription_only boolean not null default false,
  applies_to_professional boolean not null default true,
  applies_to_essential boolean not null default true,
  applies_to_paramedical boolean not null default true,
  promotion_duration_months int not null default 12, -- §11.3 : "pour le modèle actuel, = 12"
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (discount_type <> 'percentage' or discount_value <= 100)
);

do $$
begin
  if not exists (select 1 from pg_constraint where conname = 'subscriptions_promotion_code_id_fkey') then
    alter table public.subscriptions
      add constraint subscriptions_promotion_code_id_fkey
      foreign key (promotion_code_id) references public.promotion_codes(id) on delete set null;
  end if;
end;
$$;

drop trigger if exists set_promotion_codes_updated_at on public.promotion_codes;
create trigger set_promotion_codes_updated_at
  before update on public.promotion_codes
  for each row execute function public.set_updated_at();

alter table public.promotion_codes enable row level security;
-- Pas de lecture publique de la table complète : un catalogue de codes
-- lisible par tous permettrait de les découvrir/scraper sans jamais les
-- utiliser via le flux prévu. Seule la fonction check_promotion_code()
-- ci-dessous, volontairement étroite, expose la validité d'UN code précis
-- pour UNE offre précise (cohérent avec §11.11 : "le frontend ne constitue
-- jamais la source de vérité pour le prix").
drop policy if exists promotion_codes_admin_only on public.promotion_codes;
create policy promotion_codes_admin_only on public.promotion_codes for all
  using (public.is_admin()) with check (public.is_admin());

create table if not exists public.promotion_redemptions (
  id uuid primary key default gen_random_uuid(),
  promotion_code_id uuid not null references public.promotion_codes(id) on delete restrict,
  user_id uuid not null references public.profiles(id) on delete cascade,
  subscription_id uuid not null references public.subscriptions(id) on delete cascade,
  discount_type text not null check (discount_type in ('percentage', 'fixed_amount')),
  discount_value numeric not null,
  original_amount_cents integer not null,
  discount_amount_cents integer not null,
  final_amount_cents integer not null,
  promotion_start_at timestamptz not null,
  promotion_end_at timestamptz not null,
  redeemed_at timestamptz not null default now(),
  stripe_invoice_id text,
  stripe_subscription_id text,
  created_at timestamptz not null default now()
);
create index if not exists promotion_redemptions_promotion_code_id_idx on public.promotion_redemptions(promotion_code_id);
create index if not exists promotion_redemptions_user_id_idx on public.promotion_redemptions(user_id);

alter table public.promotion_redemptions enable row level security;
drop policy if exists promotion_redemptions_select_own_or_admin on public.promotion_redemptions;
create policy promotion_redemptions_select_own_or_admin on public.promotion_redemptions for select
  using (user_id = auth.uid() or public.is_admin());
-- Écriture réservée au contexte privilégié (service_role côté Stripe
-- webhook) ou admin — jamais au client, cohérent avec §11.11 (le backend
-- transmet à Stripe et enregistre le résultat, le frontend n'écrit rien).
drop policy if exists promotion_redemptions_write_privileged on public.promotion_redemptions;
create policy promotion_redemptions_write_privileged on public.promotion_redemptions for all
  using (public.is_privileged_context() or public.is_admin())
  with check (public.is_privileged_context() or public.is_admin());

-- =========================================================================
-- 6. Vérification d'un code promo (§11.2, §11.11) — surface minimale
-- =========================================================================
-- Renvoie la réduction applicable pour (code, offre) sans jamais exposer la
-- table promotion_codes entière côté client. N'incrémente rien : la
-- rédemption réelle (promotion_redemptions) est écrite par le backend au
-- moment du paiement Stripe réussi, pas ici.
create or replace function public.check_promotion_code(p_code text, p_plan text)
returns table (
  valid boolean,
  reason text,
  discount_type text,
  discount_value numeric,
  promotion_duration_months int
)
language plpgsql
security definer
set search_path = public
stable
as $$
declare
  -- Typée sur promotion_codes%rowtype (pas "record") : un "record" non
  -- typé, si le SELECT INTO ne trouve aucune ligne, ne connaît pas sa
  -- propre structure et lève "record ... is not assigned yet" au premier
  -- accès de champ ci-dessous — %rowtype garde une structure connue avec
  -- tous les champs à NULL dans ce cas.
  pc public.promotion_codes%rowtype;
begin
  if p_plan not in ('professional', 'essential', 'paramedical') then
    return query select false, 'offre_invalide', null::text, null::numeric, null::int;
    return;
  end if;

  select * into pc from public.promotion_codes where code = p_code;

  if pc.id is null then
    return query select false, 'code_inconnu', null::text, null::numeric, null::int;
    return;
  end if;
  if not pc.is_active then
    return query select false, 'code_inactif', null::text, null::numeric, null::int;
    return;
  end if;
  if pc.starts_at is not null and now() < pc.starts_at then
    return query select false, 'pas_encore_valide', null::text, null::numeric, null::int;
    return;
  end if;
  if pc.ends_at is not null and now() > pc.ends_at then
    return query select false, 'expire', null::text, null::numeric, null::int;
    return;
  end if;
  if (p_plan = 'professional' and not pc.applies_to_professional)
     or (p_plan = 'essential' and not pc.applies_to_essential)
     or (p_plan = 'paramedical' and not pc.applies_to_paramedical) then
    return query select false, 'offre_non_eligible', null::text, null::numeric, null::int;
    return;
  end if;
  if pc.max_redemptions is not null and (
    select count(*) from public.promotion_redemptions r where r.promotion_code_id = pc.id
  ) >= pc.max_redemptions then
    return query select false, 'plafond_global_atteint', null::text, null::numeric, null::int;
    return;
  end if;
  if auth.uid() is not null and (
    select count(*) from public.promotion_redemptions r
    where r.promotion_code_id = pc.id and r.user_id = auth.uid()
  ) >= pc.max_redemptions_per_user then
    return query select false, 'plafond_utilisateur_atteint', null::text, null::numeric, null::int;
    return;
  end if;
  if pc.first_subscription_only and auth.uid() is not null and exists (
    select 1 from public.subscriptions s where s.user_id = auth.uid()
  ) then
    return query select false, 'reserve_nouveaux_abonnes', null::text, null::numeric, null::int;
    return;
  end if;

  return query select true, null::text, pc.discount_type, pc.discount_value, pc.promotion_duration_months;
end;
$$;

-- =========================================================================
-- 7. Correspondance profession (src/lib/professions.ts, V1, texte libre)
--    <-> specialties (schema_v2.sql, Annexe A) — comble le manque signalé
--    en tête de fichier (section 1)
-- =========================================================================
-- src/lib/professions.ts propose ~55 intitulés à l'inscription, regroupés
-- par le formulaire (Médecins / Odontologie et pharmacie / Professions
-- paramédicales / Étudiants / Autre), sans AUCUN lien avec les 51+2
-- entrées de `specialties` (Annexe A). Table de correspondance explicite
-- plutôt qu'une résolution devinée à la volée : chaque ligne est un choix
-- audité un par un ci-dessous, avec ses cas non triviaux commentés (aucune
-- correspondance n'est laissée implicite).
create table if not exists public.profession_specialty_map (
  profession text primary key, -- valeur exacte de src/lib/professions.ts
  specialty_id uuid not null references public.specialties(id),
  notes text, -- disclosure : pourquoi ce choix quand la correspondance n'est pas 1:1 évidente
  created_at timestamptz not null default now()
);

alter table public.profession_specialty_map enable row level security;
drop policy if exists profession_specialty_map_select_all on public.profession_specialty_map;
create policy profession_specialty_map_select_all on public.profession_specialty_map for select using (true);
drop policy if exists profession_specialty_map_write_admin on public.profession_specialty_map;
create policy profession_specialty_map_write_admin on public.profession_specialty_map for all
  using (public.is_admin()) with check (public.is_admin());

-- GAP DE RÉFÉRENTIEL : l'Annexe A du cahier des charges donne un "Autre
-- (champ libre)" pour la liste PARAMÉDICALE uniquement (déjà seedé,
-- schema_v2.sql : 'autre_paramedical') — pas pour la liste MÉDICALE.
-- Plusieurs intitulés médicaux de professions.ts (voir plus bas :
-- "Médecin biologiste", "Interne en médecine", "Étudiant(e) en médecine")
-- n'ont pourtant aucune spécialité médicale correspondante dans l'Annexe A.
-- Ajout, par symétrie avec l'existant plutôt qu'une invention isolée, d'un
-- "Autre" côté médical — À CONFIRMER avec le porteur de projet, ce n'est
-- pas dans le texte original de l'Annexe A.
insert into public.specialties (slug, category, is_other, name_i18n) values
  ('autre_medicale', 'medicale', true, '{"fr": "Autre (champ libre)"}')
on conflict (slug) do nothing;

insert into public.profession_specialty_map (profession, specialty_id, notes)
select v.profession, s.id, v.notes
from (values
  -- --- Médecins ---
  ('Anesthésiste-réanimateur', 'anesthesie_reanimation', null),
  ('Médecin généraliste', 'medecine_generale_medecine_de_famille', null),
  ('Médecin urgentiste', 'medecine_d_urgence', null),
  ('Réanimateur médical', 'medecine_intensive_reanimation', null),
  ('Chirurgien général', 'chirurgie_digestive_et_viscerale',
    'Annexe A n''a pas de "chirurgie générale" distincte (DES fusionné avec digestive/viscérale en France) — rapprochement, pas une équivalence exacte.'),
  ('Chirurgien orthopédiste', 'chirurgie_orthopedique_et_traumatologique', null),
  ('Chirurgien cardiaque / thoracique', 'chirurgie_cardiaque',
    'professions.ts fusionne 2 intitulés que l''Annexe A distingue (chirurgie_cardiaque / chirurgie_thoracique) : un seul choix scalaire possible ici, cardiaque retenu arbitrairement — À VÉRIFIER si les deux devraient être proposées séparément côté formulaire.'),
  ('Chirurgien vasculaire', 'chirurgie_vasculaire', null),
  ('Chirurgien viscéral / digestif', 'chirurgie_digestive_et_viscerale', null),
  ('Chirurgien pédiatrique', 'chirurgie_pediatrique', null),
  ('Chirurgien plastique', 'chirurgie_plastique_reconstructrice_et_esthetique', null),
  ('Chirurgien ORL', 'orl_et_chirurgie_cervico_faciale', null),
  ('Chirurgien maxillo-facial', 'chirurgie_maxillo_faciale', null),
  ('Chirurgien urologue', 'chirurgie_urologique', null),
  ('Neurochirurgien', 'neurochirurgie', null),
  ('Gynécologue-obstétricien', 'gynecologie_obstetrique', null),
  ('Pédiatre', 'pediatrie', null),
  ('Cardiologue', 'cardiologie', null),
  ('Pneumologue', 'pneumologie', null),
  ('Néphrologue', 'nephrologie', null),
  ('Hépato-gastro-entérologue', 'gastro_enterologie_et_hepatologie', null),
  ('Endocrinologue', 'endocrinologie_diabetologie_maladies_metaboliques', null),
  ('Neurologue', 'neurologie', null),
  ('Hématologue', 'hematologie', null),
  ('Oncologue', 'oncologie_medicale', null),
  ('Infectiologue', 'infectiologie_maladies_infectieuses_et_tropicales', null),
  ('Radiologue', 'radiologie_et_imagerie_medicale', null),
  ('Médecin biologiste', 'autre_medicale',
    'Aucune spécialité "biologie médicale" dans l''Annexe A — GAP DE RÉFÉRENTIEL, pas une invention : à ajouter à l''Annexe A si le volume d''inscrits le justifie.'),
  ('Médecin du travail', 'medecine_du_travail', null),
  ('Médecin légiste', 'medecine_legale', null),
  ('Gériatre', 'geriatrie', null),
  ('Psychiatre', 'psychiatrie', null),
  ('Interne en médecine', 'autre_medicale',
    'Intitulé générique sans spécialité déterminée (l''internat couvre toutes les spécialités) — non résolu par la file de revue Autre puisque ce n''est pas l''option "Autre" du formulaire ; classé Autre-médicale ici pour rester honnête plutôt que de deviner une spécialité.'),
  -- --- Odontologie et pharmacie ---
  ('Chirurgien-dentiste', 'odontologie_chirurgie_dentaire', null),
  ('Pharmacien hospitalier', 'pharmacienne', null),
  ('Pharmacien d''officine', 'pharmacienne', null),
  ('Préparateur en pharmacie', 'preparateurrice_en_pharmacie', null),
  -- --- Professions paramédicales ---
  ('Infirmier(ère) diplômé(e) d''État (IDE)', 'infirmierere_soins_generaux', null),
  ('Infirmier(ère) anesthésiste (IADE)', 'infirmierere_anesthesiste_iade', null),
  ('Infirmier(ère) de bloc opératoire (IBODE)', 'infirmierere_de_bloc_operatoire_ibode', null),
  ('Infirmier(ère) en pratique avancée (IPA)', 'infirmierere_en_pratique_avancee_ipa', null),
  ('Infirmier(ère) de réanimation', 'infirmierere_soins_generaux',
    '"IDE de réanimation" n''est pas une spécialité IDE officielle distincte (contrairement à IADE/IBODE/IPA) — rapprochement vers soins généraux, pas une équivalence exacte.'),
  ('Sage-femme / Maïeuticien', 'sage_femme_maieuticienne', null),
  ('Aide-soignant(e)', 'aide_soignante', null),
  ('Auxiliaire de puériculture', 'auxiliaire_de_puericulture', null),
  ('Kinésithérapeute', 'kinesitherapeute_physiotherapeute', null),
  ('Ergothérapeute', 'ergotherapeute', null),
  ('Psychomotricien(ne)', 'psychomotricienne', null),
  ('Orthophoniste', 'orthophoniste', null),
  ('Orthoptiste', 'orthoptiste', null),
  ('Diététicien(ne)', 'dieteticienne_nutritionniste', null),
  ('Manipulateur(trice) en électroradiologie médicale', 'manipulateurrice_en_electroradiologie_medicale', null),
  ('Technicien(ne) de laboratoire médical', 'technicienne_de_laboratoire_medical', null),
  ('Perfusionniste', 'perfusionniste', null),
  ('Ambulancier(ère)', 'ambulancierere', null),
  ('Podologue', 'podologue', null),
  ('Opticien(ne)', 'opticienne', null),
  ('Audioprothésiste', 'audioprothesiste', null),
  ('Psychologue', 'autre_paramedical',
    'GAP DE RÉFÉRENTIEL : "Psychologue" figure dans professions.ts (V1) mais pas dans l''Annexe A du cahier des charges (V2.1/V4) — à ajouter à l''Annexe A si confirmé, pas une invention de spécialité.'),
  -- --- Étudiants (générique par nature ; rapprochement de filière quand direct) ---
  ('Étudiant(e) en médecine', 'autre_medicale', 'Aucune spécialité déterminée à ce stade du cursus.'),
  ('Étudiant(e) en soins infirmiers', 'infirmierere_soins_generaux', null),
  ('Étudiant(e) sage-femme', 'sage_femme_maieuticienne', null),
  ('Étudiant(e) en pharmacie', 'pharmacienne', null),
  ('Étudiant(e) en odontologie', 'odontologie_chirurgie_dentaire', null),
  ('Étudiant(e) paramédical (autre filière)', 'autre_paramedical', 'Filière non précisée par cet intitulé.')
) as v(profession, specialty_slug, notes)
join public.specialties s on s.slug = v.specialty_slug
on conflict (profession) do update set specialty_id = excluded.specialty_id, notes = excluded.notes;
-- ('Autre' — dernière option du formulaire — est délibérément ABSENTE de
-- cette table : c'est un texte libre (profession_autre), donc sans
-- correspondance déductible. resolve_specialty_id() ci-dessous la laisse
-- à NULL, pour traitement par la file de revue déjà prévue en schema_v2.sql
-- ("file de revue du référentiel", profiles_profession_autre_idx) plutôt
-- que par une spécialité devinée.

-- Résolveur utilisé par handle_new_user() (et réutilisable pour un
-- back-office de ré-affectation manuelle des cas "Autre"/gaps ci-dessus).
-- Ne retombe PLUS sur l'ancien défaut inconditionnel anesthesie_reanimation
-- (section 1) que pour une profession totalement absente des deux listes
-- ci-dessus ET absente de professions.ts (ne devrait pas arriver en usage
-- normal ; filet de sécurité seulement, pas une politique délibérée).
create or replace function public.resolve_specialty_id(p_profession text)
returns uuid
language sql
stable
as $$
  select coalesce(
    (select specialty_id from public.profession_specialty_map where profession = p_profession),
    case when p_profession = 'Autre' then null else public.default_specialty_id() end
  );
$$;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (
    id, nom, prenom, telephone, profession, profession_autre,
    consent_service, consent_partners, consent_recorded_at, specialty_id
  )
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'nom', ''),
    coalesce(new.raw_user_meta_data ->> 'prenom', ''),
    coalesce(new.raw_user_meta_data ->> 'telephone', ''),
    coalesce(new.raw_user_meta_data ->> 'profession', ''),
    new.raw_user_meta_data ->> 'profession_autre',
    coalesce((new.raw_user_meta_data ->> 'consent_service')::boolean, true),
    coalesce((new.raw_user_meta_data ->> 'consent_partners')::boolean, false),
    now(),
    public.resolve_specialty_id(coalesce(new.raw_user_meta_data ->> 'profession', ''))
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

-- Backfill des profils déjà créés (idempotent : ne change que les lignes
-- dont la spécialité recalculée diffère de l'actuelle).
update public.profiles p
set specialty_id = public.resolve_specialty_id(p.profession)
where p.specialty_id is distinct from public.resolve_specialty_id(p.profession);
