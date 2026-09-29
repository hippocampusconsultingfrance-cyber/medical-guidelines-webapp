import { createClient } from "@supabase/supabase-js";

// Page de santé, appelée par la surveillance (.github/workflows/surveillance.yml).
// Vérifie que le site répond et que la base est joignable, avec la clé
// publique : aucune donnée n'est renvoyée, seulement l'état et le délai.
export async function GET(request: Request) {
  void request;
  const started = Date.now();
  const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!,
    { auth: { persistSession: false, autoRefreshToken: false } },
  );
  const { error } = await supabase.from("societies").select("id", { head: true, count: "exact" });
  const base_ms = Date.now() - started;
  if (error) {
    console.error("Santé : base injoignable", error);
    return Response.json({ ok: false, base: "erreur", base_ms }, { status: 503, headers: { "cache-control": "no-store" } });
  }
  return Response.json({ ok: true, base: "ok", base_ms }, { headers: { "cache-control": "no-store" } });
}
