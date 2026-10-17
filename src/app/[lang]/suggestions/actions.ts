"use server";

import { redirect } from "next/navigation";
import { langueDuFormulaire } from "@/i18n/serveur";
import { CATEGORIES_SUGGESTION } from "@/lib/instructions";
import { chemin } from "@/lib/langues";
import { createClient } from "@/lib/supabase/server";

// Envoi d'une suggestion par un membre connecté. L'auteur, le statut
// initial et la limite de 10 par 24 h sont imposés par la base.
export async function envoyerSuggestion(formData: FormData) {
  const categorie = String(formData.get("categorie") ?? "");
  const message = String(formData.get("message") ?? "").trim().slice(0, 3000);
  const brut = String(formData.get("page") ?? "");
  const page = /^\/[\w\-/.?=&%]*$/.test(brut) ? brut.slice(0, 300) : null;
  const retour = chemin(langueDuFormulaire(formData), `/suggestions${page ? `?page=${encodeURIComponent(page)}&` : "?"}`);
  if (!(categorie in CATEGORIES_SUGGESTION)) redirect(`${retour}r=invalide`);
  if (message.length < 5) redirect(`${retour}r=vide`);

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");

  const { error } = await supabase.from("site_suggestions").insert({ user_id: user.id, categorie, page, message });
  redirect(`${retour}r=${error ? (error.code === "54000" ? "limite" : "erreur") : "merci"}`);
}
