-- Demandes d'accord : le courriel type demande aussi l'autorisation de
-- traduire les fiches (anglais, espagnol, allemand, arabe, chinois),
-- paragraphe ajouté après la demande d'autorisation de reprise. Sans effet si
-- le modèle a déjà été modifié dans l'outil (repère absent) ou s'il contient
-- déjà la demande. Idempotent.

update public.demandes_accord_modele
set corps = replace(
      corps,
      E'la référence complète et le lien vers votre site.\n\n',
      E'la référence complète et le lien vers votre site.\n\n'
        || $t$Nous sollicitons également votre autorisation de traduire ces fiches en anglais, espagnol, allemand, arabe et chinois, afin de les rendre accessibles aux professionnels de santé non francophones ; chaque version traduite citera votre société, renverra au texte officiel et précisera que la version française et le texte officiel font foi.$t$
        || E'\n\n'),
    modifie_le = now()
where id = 1
  and corps not like '%autorisation de traduire%';
