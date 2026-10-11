import { createClient } from "@supabase/supabase-js";

// Client Supabase sans session (clé publique), pour les pages publiques mises
// en cache : il ne lit pas les cookies du visiteur et ne voit donc que ce que
// la base autorise à tout le monde (règles d'accès « anon »).
export function createPublicClient() {
  return createClient(process.env.NEXT_PUBLIC_SUPABASE_URL!, process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
}
