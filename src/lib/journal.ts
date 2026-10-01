import "server-only";
import { createAdminClient } from "@/lib/supabase/admin";

// Journal d'administration (table audit_log) pour les décisions prises par
// le site avec la clé serveur (les autres sont journalisées par la base,
// migration 20261001090000). Ne bloque jamais l'action : un échec
// d'écriture est seulement signalé dans les journaux du serveur.
export async function journaliser(
  actorId: string,
  action: string,
  entite: string,
  entiteId: string | null,
  details: Record<string, unknown> = {},
) {
  const { error } = await createAdminClient()
    .from("audit_log")
    .insert({ actor_id: actorId, action, entity_type: entite, entity_id: entiteId, after: details });
  if (error) console.error("Journal d'administration", error);
}
