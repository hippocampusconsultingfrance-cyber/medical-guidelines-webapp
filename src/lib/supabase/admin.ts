import "server-only";
import { createClient } from "@supabase/supabase-js";

// Client Supabase avec la clé service_role, qui contourne les règles
// d'accès : réservé au serveur (webhook Stripe). Variable d'environnement
// SUPABASE_SERVICE_ROLE_KEY (Vercel), jamais exposée au navigateur.
export function createAdminClient() {
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!key) throw new Error("SUPABASE_SERVICE_ROLE_KEY manquant");
  return createClient(process.env.NEXT_PUBLIC_SUPABASE_URL!, key, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
}
