"use server";

import { redirect } from "next/navigation";
import { PROFESSION_GROUPS } from "@/lib/professions";
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
  // La case « J'ai relu cette fiche » vaut relecture : mention affichée sur la fiche.
  if (!error && publier) await signerRelecture(supabase, id);
  const status = error
    ? /juridique/.test(error.message)
      ? "publication_juridique"
      : /Date/.test(error.message)
        ? "publication_date"
        : /URL/.test(error.message)
          ? "publication_source"
          : "publication_erreur"
    : publier
      ? "publiee"
      : "depubliee";
  redirect(`/bibliotheque/${id}?r=${status}`);
}

// Titre « Dr » pour les médecins, chirurgiens-dentistes et pharmaciens.
const DOCTEURS = new Set(
  PROFESSION_GROUPS.filter((g) => g.label === "Médecins" || g.label === "Odontologie et pharmacie").flatMap((g) => g.options),
);

async function signerRelecture(supabase: Awaited<ReturnType<typeof createClient>>, id: string) {
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return { error: { message: "non connecté" } };
  const { data: profil } = await supabase.from("profiles").select("profession").eq("id", user.id).maybeSingle();
  return supabase.rpc("marquer_relue", { doc_id: id, docteur: DOCTEURS.has((profil?.profession as string | null) ?? "") });
}

// Relecture d'une fiche déjà en ligne (validateur) : met à jour la mention
// « Relue par Dr …, le … ».
export async function marquerRelue(formData: FormData) {
  const id = String(formData.get("id") ?? "");
  if (!UUID.test(id)) redirect("/bibliotheque");
  if (formData.get("confirme") !== "1") redirect(`/bibliotheque/${id}?r=confirmation_requise`);
  const supabase = await createClient();
  const { error } = await signerRelecture(supabase, id);
  redirect(`/bibliotheque/${id}?r=${error ? (/Nom/.test(error.message) ? "relue_nom" : "relue_erreur") : "relue"}`);
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

const FRESHNESS = ["a_jour", "revision_detectee", "remplacee", "retiree"];

// Veille (cahier des charges §5.4 et §7.3) : statut de fraîcheur de la fiche
// et, s'il y a lieu, enregistrement d'une nouvelle version de la
// recommandation source. Droits vérifiés par la base (RLS : validateur ou
// administrateur pour la fiche, relecteur ou plus pour les versions). Une
// version publiée déclenche les alertes aux membres qui suivent la fiche.
export async function setFreshness(formData: FormData) {
  const id = String(formData.get("id") ?? "");
  if (!UUID.test(id)) redirect("/bibliotheque");
  const back = (r: string) => redirect(`/bibliotheque/${id}?r=${r}#veille`);

  const status = String(formData.get("statut") ?? "");
  const replacement = String(formData.get("remplacee_par") ?? "");
  const label = String(formData.get("version") ?? "").trim().slice(0, 100);
  const changeType = String(formData.get("type") ?? "");
  const summary = String(formData.get("resume") ?? "").trim().slice(0, 2000) || null;
  const publishVersion = formData.get("publier_version") === "1";
  if (!FRESHNESS.includes(status)) back("veille_invalide");
  if (status === "remplacee" && (!UUID.test(replacement) || replacement === id)) back("veille_remplacement");
  if (label && !["majeure", "mineure"].includes(changeType)) back("veille_invalide");
  if (status === "retiree" && formData.get("confirme_retrait") !== "1") back("veille_retrait");

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");

  if (label) {
    const { error } = await supabase.from("document_versions").insert({
      document_id: id,
      version_label: label,
      change_type: changeType,
      diff_summary: summary,
      published_at: publishVersion ? new Date().toISOString() : null,
      created_by: user.id,
    });
    if (error) back(error.code === "23505" ? "veille_version_existe" : "veille_erreur");
  }

  const { data, error } = await supabase
    .from("documents")
    .update({
      freshness_status: status,
      superseded_by_document_id: status === "remplacee" ? replacement : null,
    })
    .eq("id", id)
    .select("id");
  // Passage de veille : la source est vérifiée ce jour (sans effet tant que
  // la migration 20260930130000 n'est pas appliquée).
  if (!error && data?.length) {
    await supabase.from("documents").update({ source_verified_at: new Date().toISOString().slice(0, 10) }).eq("id", id);
  }
  back(error || !data?.length ? "veille_erreur" : label ? "veille_version" : "veille_ok");
}
