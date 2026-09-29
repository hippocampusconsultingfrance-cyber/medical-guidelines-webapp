import "server-only";
import type { SupabaseClient } from "@supabase/supabase-js";

// Le compte connecté fait-il partie de l'équipe éditoriale (relecteur,
// validateur ou administrateur) ? Lu sur son propre profil (RLS).
export async function isEditorialAccount(supabase: SupabaseClient, userId: string) {
  const { data } = await supabase.from("profiles").select("editorial_role").eq("id", userId).maybeSingle();
  return Boolean(data?.editorial_role);
}

export async function isAdminAccount(supabase: SupabaseClient, userId: string) {
  const { data } = await supabase.from("profiles").select("editorial_role").eq("id", userId).maybeSingle();
  return data?.editorial_role === "admin";
}
