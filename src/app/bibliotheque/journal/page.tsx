import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import { loadLibrary } from "../data";
import Shell from "../shell";

export const metadata: Metadata = {
  title: "Journal d'administration — medical-guidelines.net",
};

type Ligne = {
  id: string;
  actor_id: string | null;
  action: string;
  entity_type: string;
  entity_id: string | null;
  before: Record<string, unknown> | null;
  after: Record<string, unknown> | null;
  created_at: string;
};

const LIBELLES: Record<string, string> = {
  "update:documents": "Fiche modifiée",
  "insert:document_versions": "Version de fiche enregistrée",
  "update:document_versions": "Version de fiche modifiée",
  "delete:document_versions": "Version de fiche supprimée",
  "update:error_reports": "Signalement traité",
  "update:profiles": "Rôle d'équipe modifié",
  "update:document_translations": "Traduction relue",
  justificatif_valide: "Justificatif validé",
  justificatif_refuse: "Justificatif refusé",
  suspension_levee: "Suspension levée",
  correction_publiee: "Correction publiée",
  recette_verifiee: "Critère de recette vérifié",
  recette_annulee: "Critère de recette annulé",
  actualisation_ecartee: "Actualisation écartée",
  divergence_creee: "Divergence créée",
  divergence_supprimee: "Divergence supprimée",
  lettre_envoyee: "Lettre de veille envoyée",
};

const resume = (v: Record<string, unknown> | null) =>
  v
    ? Object.entries(v)
        .map(([k, x]) => `${k} : ${typeof x === "object" ? JSON.stringify(x) : String(x)}`)
        .join(" · ")
        .slice(0, 300)
    : "";

// Journal d'administration (administrateurs) : 300 dernières actions de
// l'équipe, avec leur auteur. Un rôle d'équipe modifié est toujours
// journalisé, même hors du site (événement de sécurité).
export default async function JournalPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");

  const lib = await loadLibrary(supabase, user.id);
  const admin = createAdminClient();
  const { data } = await admin
    .from("audit_log")
    .select("id, actor_id, action, entity_type, entity_id, before, after, created_at")
    .order("created_at", { ascending: false })
    .limit(300);
  const lignes = (data ?? []) as Ligne[];
  const ids = [...new Set(lignes.map((l) => l.actor_id).filter(Boolean))] as string[];
  const { data: profils } = ids.length ? await admin.from("profiles").select("id, prenom, nom").in("id", ids) : { data: [] };
  const nom = new Map(
    ((profils ?? []) as { id: string; prenom: string | null; nom: string | null }[]).map((p) => [
      p.id,
      [p.prenom, p.nom].filter(Boolean).join(" ") || "Compte",
    ]),
  );
  const titre = new Map(lib.docs.map((d) => [d.id, d.card_json?.title ?? d.title]));

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">Administration</div>
        <h1>Journal d&apos;administration</h1>
        <div className="doc-header__meta">
          <span>Qui a fait quoi, et quand : 300 dernières actions de l&apos;équipe.</span>
        </div>
      </div>
      {lignes.length === 0 ? (
        <div className="lib-empty">Aucune action journalisée pour l&apos;instant.</div>
      ) : (
        <div className="table-scroll">
          <table className="rfe">
            <thead>
              <tr>
                <th>Date</th>
                <th>Auteur</th>
                <th>Action</th>
                <th>Détail</th>
              </tr>
            </thead>
            <tbody>
              {lignes.map((l) => {
                const cle = LIBELLES[l.action] ? l.action : `${l.action}:${l.entity_type}`;
                const fiche = l.entity_type === "documents" || l.entity_type === "document_translations" ? l.entity_id : null;
                return (
                  <tr key={l.id}>
                    <td style={{ whiteSpace: "nowrap" }}>
                      {new Date(l.created_at).toLocaleString("fr-FR", { timeZone: "Europe/Paris", dateStyle: "short", timeStyle: "short" })}
                    </td>
                    <td>{l.actor_id ? (nom.get(l.actor_id) ?? "Compte supprimé") : "Système (hors site)"}</td>
                    <td>
                      {LIBELLES[cle] ?? cle}
                      {fiche && titre.get(fiche) && (
                        <>
                          {" — "}
                          <Link href={`/bibliotheque/${fiche}`}>{titre.get(fiche)}</Link>
                        </>
                      )}
                    </td>
                    <td style={{ fontSize: "0.8rem" }}>
                      {l.before && <div>avant : {resume(l.before)}</div>}
                      {l.after && <div>{l.before ? "après : " : ""}{resume(l.after)}</div>}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      )}
    </Shell>
  );
}
