import { createBrowserClient } from "@supabase/ssr";

// flowType "implicit" : le lien de confirmation email doit pouvoir être
// ouvert sur un autre appareil/navigateur que celui de l'inscription (ex.
// formulaire rempli sur ordinateur, email consulté sur téléphone). Le flux
// PKCE (par défaut) stocke un secret local au moment de l'inscription et
// échoue dans ce cas très courant ("PKCE code verifier not found in
// storage") ; le flux implicite met directement le jeton de session dans
// le lien, sans secret local à retrouver.
export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!,
    {
      auth: {
        flowType: "implicit",
      },
    },
  );
}
