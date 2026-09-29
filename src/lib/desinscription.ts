import "server-only";
import { createAdminClient } from "@/lib/supabase/admin";

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

// Désinscription des alertes e-mail par le jeton personnel du lien (sans
// connexion, comme l'exige un lien de désinscription). Le jeton, aléatoire,
// n'est connu que du membre et de ses e-mails ; il ne permet rien d'autre.
export async function unsubscribeByToken(token: string) {
  if (!UUID.test(token)) return false;
  try {
    const { data, error } = await createAdminClient()
      .from("profiles")
      .update({ email_alerts: false })
      .eq("alerts_token", token)
      .select("id");
    if (error) throw error;
    return (data ?? []).length > 0;
  } catch (e) {
    console.error("Désinscription des alertes", e);
    return false;
  }
}
