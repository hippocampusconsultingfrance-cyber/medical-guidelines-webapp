-- Traductions des fiches dans les langues du site (src/lib/langues.ts) :
-- anglais, espagnol, allemand, arabe, chinois. Brouillons préparés par
-- l'atelier (build/<langue>/, build/trad_ia.py), importés par
-- scripts/import-atelier.mjs ; lecture réservée à l'équipe éditoriale ;
-- publication toujours soumise au verrou des traductions (registre
-- juridique, migrations 20261001140000 et 20261001160000).
-- Idempotent.

alter table public.document_translations drop constraint if exists document_translations_lang_check;
alter table public.document_translations add constraint document_translations_lang_check
  check (lang in ('en', 'es', 'de', 'ar', 'zh'));
