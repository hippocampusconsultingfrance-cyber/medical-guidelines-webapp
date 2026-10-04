"use server";

import { redirect } from "next/navigation";
import { journaliser } from "@/lib/journal";
import { STATUTS_CANDIDATURE } from "@/lib/relecteurs";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

const UUID = /^[0-9a-f-]{36}$/i;

// Statut d'une candidature de médecin relecteur (administrateur), avec une
// note facultative. L'accès offert est attribué à part.
export async function deciderCandidature(formData: FormData) {
  const id = String(formData.get("id") ?? "");
  const status = String(formData.get("status") ?? "");
  const note = String(formData.get("note") ?? "").trim().slice(0, 1000) || null;
  if (!UUID.test(id) || !(status in STATUTS_CANDIDATURE)) redirect("/bibliotheque/relecteurs");

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");

  const { error } = await createAdminClient()
    .from("candidatures_relecteurs")
    .update({ status, admin_note: note, decided_at: status === "nouvelle" ? null : new Date().toISOString() })
    .eq("id", id);
  if (!error) await journaliser(user.id, `candidature_relecteur_${status}`, "candidatures_relecteurs", id);
  redirect(`/bibliotheque/relecteurs?r=${error ? "erreur" : "ok"}`);
}
