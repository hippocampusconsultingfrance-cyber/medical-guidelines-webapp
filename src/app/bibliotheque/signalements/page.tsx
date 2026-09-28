import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { decideReport } from "../[id]/actions";
import { loadLibrary } from "../data";
import Shell from "../shell";

export const metadata: Metadata = {
  title: "Signalements — Medical Guidelines",
};

const STATUS_LABEL: Record<string, string> = {
  nouveau: "Nouveau",
  valide: "Validé",
  rejete: "Rejeté",
  en_cours: "En cours",
  resolu: "Résolu",
};

type Report = {
  id: string;
  doc: string;
  doc_title: string | null;
  section: string | null;
  description: string;
  status: string;
  created_at: string;
};

// Tableau de bord des signalements d'erreurs (administrateur). La base ne
// renvoie à un membre que ses propres signalements (RLS).
export default async function SignalementsPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");

  const [lib, { data: isAdmin }, { data: rows }] = await Promise.all([
    loadLibrary(supabase, user.id),
    supabase.rpc("is_admin"),
    supabase
      .from("error_reports")
      .select("id, doc, doc_title, section, description, status, created_at")
      .order("created_at", { ascending: false })
      .limit(300),
  ]);
  if (!isAdmin) redirect("/bibliotheque");
  const reports = (rows ?? []) as Report[];
  const pending = reports.filter((r) => r.status === "nouveau").length;

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">Administration</div>
        <h1>Signalements d&apos;erreurs</h1>
        <div className="doc-header__meta">
          <span>
            <b>{pending}</b> nouveau{pending > 1 ? "x" : ""} · {reports.length} au total
          </span>
        </div>
      </div>
      {reports.length === 0 ? (
        <div className="empty-state">Aucun signalement pour le moment.</div>
      ) : (
        reports.map((r) => (
          <div key={r.id} className="report-card">
            <div className="report-card__top">
              <div>
                <div className="report-card__where">
                  {/^[0-9a-f-]{36}$/i.test(r.doc) ? (
                    <Link href={`/bibliotheque/${r.doc}`}>{r.doc_title ?? "Fiche"}</Link>
                  ) : (
                    (r.doc_title ?? r.doc)
                  )}
                  {r.section ? ` · ${r.section}` : ""}
                </div>
                <div className="report-card__date">
                  {new Date(r.created_at).toLocaleString("fr-FR", { timeZone: "Europe/Paris" })}
                </div>
              </div>
              <span className={`status-pill status-${r.status}`}>{STATUS_LABEL[r.status] ?? r.status}</span>
            </div>
            <div className="report-card__desc">{r.description}</div>
            <div className="report-card__actions">
              {(["valide", "rejete"] as const)
                .filter((s) => s !== r.status)
                .map((s) => (
                  <form key={s} action={decideReport}>
                    <input type="hidden" name="id" value={r.id} />
                    <input type="hidden" name="status" value={s} />
                    <button className="btn btn-ghost btn-sm">{s === "valide" ? "Valider" : "Rejeter"}</button>
                  </form>
                ))}
            </div>
          </div>
        ))
      )}
    </Shell>
  );
}
