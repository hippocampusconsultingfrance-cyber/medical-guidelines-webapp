"use server";

import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

// Suivi des sociétés savantes et alertes e-mail, depuis l'espace membre ou
// « Mon compte ». Les règles d'accès limitent chaque compte à ses propres
// suivis et à sa propre préférence (notification_preferences_own, droit
// UPDATE sur profiles.email_alerts uniquement).

const RETOURS = new Set(["/", "/compte"]);

function back(formData: FormData, r: string): never {
  const retour = String(formData.get("retour") ?? "/");
  redirect(`${RETOURS.has(retour) ? retour : "/"}?r=${r}#alertes`);
}

async function currentUser() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  return { supabase, user };
}

// Une même société peut exister sous plusieurs lignes (pays différents) :
// on suit toutes celles qui portent le sigle.
async function societyIds(supabase: Awaited<ReturnType<typeof createClient>>, acronym: string) {
  if (!acronym) return [];
  const { data } = await supabase.from("societies").select("id").eq("acronym", acronym.slice(0, 40));
  return ((data ?? []) as { id: string }[]).map((s) => s.id);
}

export async function followSociety(formData: FormData) {
  const { supabase, user } = await currentUser();
  const ids = await societyIds(supabase, String(formData.get("societe") ?? "").trim());
  if (!ids.length) back(formData, "suivi_erreur");
  const { error } = await supabase
    .from("notification_preferences")
    .insert(ids.map((society_id) => ({ user_id: user.id, society_id })));
  // 23505 : société déjà suivie.
  back(formData, error && error.code !== "23505" ? "suivi_erreur" : "suivi");
}

export async function unfollowSociety(formData: FormData) {
  const { supabase, user } = await currentUser();
  const ids = await societyIds(supabase, String(formData.get("societe") ?? "").trim());
  if (ids.length) {
    await supabase.from("notification_preferences").delete().eq("user_id", user.id).in("society_id", ids);
  }
  back(formData, "suivi_retire");
}

export async function setEmailAlerts(formData: FormData) {
  const { supabase, user } = await currentUser();
  const on = formData.get("actif") === "1";
  const { error } = await supabase.from("profiles").update({ email_alerts: on }).eq("id", user.id);
  back(formData, error ? "alertes_erreur" : on ? "alertes_on" : "alertes_off");
}

// Déconnexion côté serveur : les cookies de session sont effacés par le
// client Supabase du serveur, sans charger supabase-js dans le navigateur.
export async function seDeconnecter() {
  const supabase = await createClient();
  await supabase.auth.signOut();
  redirect("/connexion");
}
