import type { SupabaseClient } from "@supabase/supabase-js";

// Journal public des corrections (cahier des charges §9.4) : date, fiche,
// criticité, résumé. Aucune donnée personnelle (ni l'auteur, ni le
// déclarant du signalement d'origine) : la base n'expose que ces colonnes.

export const CRITICITES: Record<string, string> = {
  mineure: "Mineure",
  majeure: "Majeure",
  critique: "Critique",
};

export type Correction = {
  id: string;
  document_id: string;
  corrected_at: string;
  criticite: string;
  resume: string;
  documents: { title: string; fiche_key: string | null; card_json: { title?: string } | null } | null;
};

export async function chargerCorrections(supabase: SupabaseClient, documentId?: string, limit = 200) {
  let q = supabase
    .from("corrections_log")
    .select("id, document_id, corrected_at, criticite, resume, documents(title, fiche_key, card_json)")
    .order("corrected_at", { ascending: false })
    .limit(limit);
  if (documentId) q = q.eq("document_id", documentId);
  const { data, error } = await q;
  if (error) return [];
  return (data ?? []) as unknown as Correction[];
}

export const dateCorrection = (v: string, locale = "fr-FR") =>
  new Date(`${v}T00:00:00Z`).toLocaleDateString(locale, { day: "numeric", month: "long", year: "numeric", timeZone: "UTC" });
