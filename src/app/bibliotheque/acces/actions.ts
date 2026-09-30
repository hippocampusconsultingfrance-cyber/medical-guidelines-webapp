"use server";

import { redirect } from "next/navigation";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

// Lève une suspension de lecture (administrateurs) : le compte relit
// immédiatement. La trace reste dans access_blocks (lifted_by, lifted_at).
export async function leverSuspension(formData: FormData) {
  const id = Number(formData.get("id"));
  if (!Number.isInteger(id) || id <= 0) redirect("/bibliotheque/acces");

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");

  const now = new Date().toISOString();
  const { error } = await createAdminClient()
    .from("access_blocks")
    .update({ blocked_until: now, lifted_by: user.id, lifted_at: now })
    .eq("id", id)
    .gt("blocked_until", now);
  redirect(`/bibliotheque/acces?r=${error ? "erreur" : "levee"}`);
}
