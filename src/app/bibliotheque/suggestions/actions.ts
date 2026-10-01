"use server";

import { redirect } from "next/navigation";
import { journaliser } from "@/lib/journal";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

const UUID = /^[0-9a-f-]{36}$/i;

// Statut d'une suggestion (administrateur), avec une note facultative.
export async function deciderSuggestion(formData: FormData) {
  const id = String(formData.get("id") ?? "");
  const status = String(formData.get("status") ?? "");
  const note = String(formData.get("note") ?? "").trim().slice(0, 1000) || null;
  if (!UUID.test(id) || !["traite", "rejete", "nouveau"].includes(status)) redirect("/bibliotheque/suggestions");

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");

  const { error } = await createAdminClient()
    .from("site_suggestions")
    .update({ status, admin_note: note, treated_at: status === "nouveau" ? null : new Date().toISOString() })
    .eq("id", id);
  if (!error) await journaliser(user.id, `suggestion_${status}`, "site_suggestions", id);
  redirect(`/bibliotheque/suggestions?r=${error ? "erreur" : "ok"}`);
}
