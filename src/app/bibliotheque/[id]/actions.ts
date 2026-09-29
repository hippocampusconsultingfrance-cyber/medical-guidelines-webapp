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

// Ajout ou retrait d'une fiche des favoris (RLS : chacun ne gère que les
// siens). Un double envoi bute sur la contrainte d'unicité, sans effet.
export async function toggleFavorite(formData: FormData) {
  const id = String(formData.get("id") ?? "");
  if (!UUID.test(id)) redirect("/bibliotheque");

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  if (formData.get("favori") === "1") {
    await supabase.from("favorites").insert({ user_id: user.id, document_id: id });
  } else {
    await supabase.from("favorites").delete().eq("user_id", user.id).eq("document_id", id);
  }
  redirect(`/bibliotheque/${id}`);
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

// Signalement d'une erreur depuis une fiche. La base impose l'auteur (le
// membre connecté) et le statut initial « nouveau » (RLS).
export async function reportError(formData: FormData) {
  const id = String(formData.get("id") ?? "");
  if (!UUID.test(id)) redirect("/bibliotheque");
  const description = String(formData.get("description") ?? "").trim().slice(0, 4000);
  const section = String(formData.get("section") ?? "").trim().slice(0, 300) || null;
  const title = String(formData.get("title") ?? "").trim().slice(0, 300) || null;
  if (description.length < 5) redirect(`/bibliotheque/${id}?r=signalement_vide#signaler`);

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { error } = await supabase
    .from("error_reports")
    .insert({ user_id: user.id, doc: id, doc_title: title, section, description });
  redirect(`/bibliotheque/${id}?r=${error ? "signalement_erreur" : "signalement_envoye"}#signaler`);
}

// Décision de l'administrateur sur un signalement (RLS : administrateurs).
export async function decideReport(formData: FormData) {
  const id = String(formData.get("id") ?? "");
  const status = String(formData.get("status") ?? "");
  if (!UUID.test(id) || !["valide", "rejete", "nouveau"].includes(status)) {
    redirect("/bibliotheque/signalements");
  }
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  await supabase
    .from("error_reports")
    .update({ status, decided_at: new Date().toISOString(), decided_by: user.id })
    .eq("id", id);
  redirect("/bibliotheque/signalements");
}
