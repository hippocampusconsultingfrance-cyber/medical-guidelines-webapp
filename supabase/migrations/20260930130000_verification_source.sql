-- Dernière vérification de la source (cahier des charges V4.5, §4.3 ;
-- checklist 2.2 « Dernière et prochaine vérification affichées ») : date à
-- laquelle un validateur a reconfirmé la source (bloc « Veille » de la
-- fiche, ou routine de veille mensuelle). Tant qu'elle est vide, la date de
-- publication de la fiche en tient lieu (la source est vérifiée avant toute
-- publication). La prochaine vérification est prévue à la fin du mois
-- suivant (calculée par le site). Lecture comme les autres métadonnées ;
-- écriture par les rôles éditoriaux (règles existantes). Idempotent.

alter table public.documents add column if not exists source_verified_at date;
grant select (source_verified_at) on public.documents to anon, authenticated;
