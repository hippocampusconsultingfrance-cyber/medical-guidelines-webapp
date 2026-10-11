-- Fiche « Intubation en urgence hors bloc & hors soins critiques » : la note
-- d'introduction des algorithmes d'échec d'intubation ne parle plus de
-- « reproduction » des figures de la RFE (elles sont présentées en tableaux).
-- Rejouable : le passage n'est remplacé que s'il apparaît exactement une fois.
-- Déjà appliqué en production le 2026-10-10.
do $do$
declare
  o constant text := 'Reproduction fidèle des 2 algorithmes de la RFE (Figures 3 et 4) — ils diffèrent à l''étape 1.';
  n constant text := 'Les 2 algorithmes de la RFE (Figures 3 et 4), présentés sous forme de tableaux — ils diffèrent à l''étape 1.';
  t text;
  k int;
begin
  select d.presentation_json::text into t from public.documents d where d.fiche_key = 'intubation_urgence';
  if t is null then raise exception 'Fiche absente : intubation_urgence'; end if;
  k := (length(t) - length(replace(t, o, ''))) / length(o);
  if k = 0 and position(n in t) > 0 then
    null;
  elsif k = 1 then
    update public.documents d set presentation_json = replace(t, o, n)::jsonb where d.fiche_key = 'intubation_urgence';
  else
    raise exception 'Passage trouvé % fois au lieu de 1, rien n''est appliqué', k;
  end if;
end $do$;
