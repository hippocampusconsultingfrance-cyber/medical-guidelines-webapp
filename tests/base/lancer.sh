#!/usr/bin/env bash
# Tests des règles du parcours membre, appliquées par la base : construit une
# base vide (schéma, migrations, contenu), puis joue tests/base/parcours.sql.
# Usage : tests/base/lancer.sh postgres://utilisateur:motdepasse@hote:5432/base
# (la base doit être vide ; l'utilisateur doit être superutilisateur).
set -euo pipefail
cd "$(dirname "$0")/../.."
URL="$1"
export PGOPTIONS="-c client_min_messages=warning"
run() { psql "$URL" -X -q -v ON_ERROR_STOP=1 -f "$1" > /dev/null || { echo "Échec : $1"; exit 1; }; }

run tests/base/supabase-minimal.sql
run supabase/schema.sql
run supabase/migrations/20260928120000_audit_securite_rgpd.sql
run supabase/schema_v2.sql
run supabase/schema_v3.sql
for f in $(ls supabase/migrations/*.sql | sort | grep -v 20260928120000_audit_securite_rgpd); do run "$f"; done
for f in $(ls supabase/content/00*.sql | sort) supabase/content/0200_fiches_atelier.sql supabase/content/0201_*.sql supabase/content/0202_*.sql supabase/content/0210_*.sql; do run "$f"; done
echo "Base construite."
psql "$URL" -X -q -v ON_ERROR_STOP=1 -f tests/base/parcours.sql
