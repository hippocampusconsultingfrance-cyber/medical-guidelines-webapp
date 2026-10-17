import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { CRITICITES } from "@/lib/corrections";
import { instructionSignalement } from "@/lib/instructions";
import { createClient } from "@/lib/supabase/server";
import { decideReport } from "../[id]/actions";
import { loadLibrary } from "../data";
import Instruction from "../instruction";
import Shell from "../shell";
import { publierCorrection } from "./actions";

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
const MESSAGES: Record<string, string> = {
  correction_publiee: "Correction publiée au journal public ; signalement validé.",
  correction_incomplete: "Choisissez la criticité et résumez la correction (5 caractères au moins).",
  correction_erreur: "La correction n'a pas pu être publiée (migration du journal appliquée ?).",
};

export default async function SignalementsPage({ searchParams }: PageProps<"/[lang]/bibliotheque/signalements">) {
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
  const UUID = /^[0-9a-f-]{36}$/i;
  const ids = [...new Set(reports.map((r) => r.doc).filter((d) => UUID.test(d)))];
  const { data: sources } = ids.length
    ? await supabase.from("documents").select("id, source_url").in("id", ids)
    : { data: [] };
  const sourceDe = new Map((sources ?? []).map((d) => [d.id as string, d.source_url as string | null]));
  const pending = reports.filter((r) => r.status === "nouveau").length;
  const r0 = (await searchParams).r;
  const message = typeof r0 === "string" ? MESSAGES[r0] : undefined;

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
      {message && (
        <div className="credit-strip" role="status" id="corrections">
          <b>{message}</b>
        </div>
      )}
      <p className="block-p is-note">
        Une erreur confirmée et corrigée se publie au{" "}
        <Link href="/corrections">journal public des corrections</Link> (date, fiche, criticité,
        résumé ; jamais le nom du déclarant).
      </p>
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
            {r.status !== "rejete" && r.status !== "resolu" && (
              <Instruction
                texte={instructionSignalement({
                  doc_title: r.doc_title,
                  section: r.section,
                  description: r.description,
                  source_url: sourceDe.get(r.doc) ?? null,
                  doc_id: UUID.test(r.doc) ? r.doc : null,
                })}
              />
            )}
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
            {/^[0-9a-f-]{36}$/i.test(r.doc) && (
              <details style={{ marginTop: 10 }}>
                <summary style={{ cursor: "pointer", fontWeight: 600 }}>Corrigé : publier au journal public</summary>
                <form action={publierCorrection} style={{ marginTop: 10 }}>
                  <input type="hidden" name="document_id" value={r.doc} />
                  <input type="hidden" name="report_id" value={r.id} />
                  <div className="field">
                    <label htmlFor={`crit-${r.id}`}>Criticité</label>
                    <select id={`crit-${r.id}`} name="criticite" required defaultValue="">
                      <option value="" disabled>
                        Choisir…
                      </option>
                      {Object.entries(CRITICITES).map(([v, l]) => (
                        <option key={v} value={v}>
                          {l}
                        </option>
                      ))}
                    </select>
                  </div>
                  <div className="field">
                    <label htmlFor={`res-${r.id}`}>Résumé public de la correction</label>
                    <textarea id={`res-${r.id}`} name="resume" required minLength={5} maxLength={1000} />
                  </div>
                  <button className="btn btn-primary btn-sm">Publier la correction</button>
                </form>
              </details>
            )}
          </div>
        ))
      )}
    </Shell>
  );
}
