"use server";

import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

const UUID = /^[0-9a-f-]{36}$/i;

// Le quota est vérifié et décompté par la base (unlock_document) : cette
// action ne fait que transmettre la demande confirmée par l'utilisateur.
export async function unlockDocument(formData: FormData) {
  const id = String(formData.get("id") ?? "");
  if (!UUID.test(id)) redirect("/bibliotheque");

  const supabase = await createClient();
  const { data, error } = await supabase.rpc("unlock_document", { doc_id: id });
  const status = error ? "erreur" : (data as { status?: string } | null)?.status ?? "erreur";
  redirect(`/bibliotheque/${id}?r=${encodeURIComponent(status)}`);
}
