-- Carte de présentation des fiches (catalogue de la bibliothèque).
--
-- card_json porte uniquement ce qui s'affiche sur la carte d'une fiche
-- bloquée : badge, titre court, résumé d'une phrase, société, version,
-- méthodologie, nombre de pages. Il est lisible par tous, comme le titre.
-- Le contenu de la fiche (presentation_json, recommandations) reste
-- protégé par la migration 20260928220000. Idempotent.

alter table public.documents add column if not exists card_json jsonb;

-- La lecture de documents est accordée colonne par colonne : une nouvelle
-- colonne doit l'être explicitement.
grant select (card_json) on public.documents to anon, authenticated;
