"use server";

import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

const UUID = /^[0-9a-f-]{36}$/i;

// Relecture d'une traduction : droits vérifiés par la base
// (review_translation, relecteur ou plus).
export async function reviewTranslation(formData: FormData) {
  const id = String(formData.get("id") ?? "");
  if (!UUID.test(id)) redirect("/bibliotheque/traductions");
  const relue = formData.get("relue") === "1";
  const notes = String(formData.get("notes") ?? "").slice(0, 4000);
  if (relue && formData.get("confirme") !== "1") redirect(`/bibliotheque/${id}/en?r=confirmation#relecture`);

  const supabase = await createClient();
  const { data, error } = await supabase.rpc("review_translation", {
    doc_id: id,
    target_lang: "en",
    relue,
    notes,
  });
  redirect(`/bibliotheque/${id}/en?r=${error || !data ? "erreur" : relue ? "relue" : "brouillon"}#relecture`);
}
