import { type EmailOtpType } from "@supabase/supabase-js";
import { type NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// Route ciblée par le lien envoyé dans l'email de confirmation
// (emailRedirectTo dans signInWithOtp). Vérifie le token puis redirige
// vers la finalisation du compte (choix identifiant + mot de passe).
export async function GET(request: NextRequest) {
  const { searchParams, origin } = new URL(request.url);
  const token_hash = searchParams.get("token_hash");
  const type = searchParams.get("type") as EmailOtpType | null;

  if (token_hash && type) {
    const supabase = await createClient();
    const { error } = await supabase.auth.verifyOtp({ type, token_hash });
    if (!error) {
      return NextResponse.redirect(`${origin}/finaliser-compte`);
    }
  }

  return NextResponse.redirect(`${origin}/connexion?erreur=lien-invalide`);
}
