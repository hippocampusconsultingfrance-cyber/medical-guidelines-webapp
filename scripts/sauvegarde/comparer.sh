#!/usr/bin/env bash
# Compare la production et sa restauration (.github/workflows/sauvegarde.yml).
# Entrée : lignes « mesure production restauration » (scripts/sauvegarde/comptes.sql).
# Échec si :
#   - une table manque, ou perd plus de 1 % de ses lignes (une table non vide
#     en production doit l'être aussi) ;
#   - une règle de sécurité diffère : sécurité par ligne, nombre de règles
#     d'accès d'une table, nombre de fonctions.
# Quelques lignes de plus (inscription pendant la sauvegarde) sont seulement
# signalées.
set -euo pipefail
awk '
  $1 ~ /^lignes:/ {
    t = substr($1, 8)
    if ($3 < 0) { print "::error::" t " non restaurée"; bad = 1 }
    else if (($2 > 0 && $3 == 0) || $3 < $2 * 0.99) { print "::error::" t " : " $2 " en production, " $3 " restaurées (perte de plus de 1 %)"; bad = 1 }
    else if ($2 != $3) print "::warning::" t " : " $2 " en production, " $3 " restaurées"
    next
  }
  $2 != $3 { print "::error::sécurité, " $1 " : " $2 " en production, " $3 " restaurées"; bad = 1 }
  END { exit bad }
' "$1"
