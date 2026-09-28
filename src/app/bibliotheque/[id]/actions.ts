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

// Publication ou dépublication d'une fiche. Le droit (validateur ou admin)
// est vérifié par la base (publish_document).
export async function setPublication(formData: FormData) {
  const id = String(formData.get("id") ?? "");
  if (!UUID.test(id)) redirect("/bibliotheque");
  const publier = formData.get("publier") === "1";
  if (publier && formData.get("confirme") !== "1") {
    redirect(`/bibliotheque/${id}?r=confirmation_requise`);
  }

  const supabase = await createClient();
  const { error } = await supabase.rpc("publish_document", { doc_id: id, publier });
  const status = error ? "publication_erreur" : publier ? "publiee" : "depubliee";
  redirect(`/bibliotheque/${id}?r=${status}`);
}

// Mise en ligne de toutes les fiches mises en page (administrateur,
// vérifié par la base).
export async function publishAll(formData: FormData) {
  if (formData.get("confirme") !== "1") redirect("/bibliotheque?r=confirmation_requise");
  const supabase = await createClient();
  const { data, error } = await supabase.rpc("publish_all_documents");
  redirect(`/bibliotheque?r=${error ? "publication_erreur" : `toutes_publiees_${Number(data ?? 0)}`}`);
}
