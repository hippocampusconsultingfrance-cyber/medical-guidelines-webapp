import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { cardTitle, loadLibrary } from "../data";
import Shell from "../shell";

export const metadata: Metadata = {
  title: "Traductions — medical-guidelines.net",
};

const STATUS_LABEL: Record<string, string> = {
  brouillon: "Brouillon",
  relue: "Relue",
  publiee: "Publiée",
};

type Row = {
  document_id: string;
  lang: string;
  status: string;
  fr_a_jour: boolean;
  a_verifier: string[] | null;
  reviewed_at: string | null;
  imported_at: string;
};

// Traductions anglaises des fiches (équipe éditoriale) : brouillons de
// l'atelier à relire. Aucune n'est visible des membres.
export default async function TraductionsPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const lib = await loadLibrary(supabase, user.id);
  if (!lib.isEditor) redirect("/bibliotheque");

  const { data } = await supabase
    .from("document_translations")
    .select("document_id, lang, status, fr_a_jour, a_verifier, reviewed_at, imported_at")
    .order("imported_at", { ascending: false });
  const rows = (data ?? []) as Row[];
  const byId = new Map(lib.docs.map((d) => [d.id, d]));

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">Équipe éditoriale</div>
        <h1>Traductions anglaises</h1>
        <p className="block-p">
          Brouillons préparés par l&apos;atelier, à relire par un relecteur médical maîtrisant
          l&apos;anglais. Ils ne sont visibles d&apos;aucun membre ; leur publication viendra dans une
          étape ultérieure, après relecture et accord sur le droit de traduire chaque source.
        </p>
      </div>
      {rows.length === 0 ? (
        <div className="lib-empty">Aucune traduction importée pour l&apos;instant.</div>
      ) : (
        <div className="table-scroll">
          <table className="rfe">
            <thead>
              <tr>
                <th>Fiche</th>
                <th>État</th>
                <th>À vérifier</th>
                <th>Français</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((r) => {
                const doc = byId.get(r.document_id);
                return (
                  <tr key={`${r.document_id}-${r.lang}`}>
                    <td>
                      <Link href={`/bibliotheque/${r.document_id}/en`}>{doc ? cardTitle(doc) : r.document_id}</Link>
                    </td>
                    <td>
                      <span className={`state-pill ${r.status === "relue" ? "state-open" : "state-draft"}`}>
                        {STATUS_LABEL[r.status] ?? r.status}
                      </span>
                    </td>
                    <td className="align-c">{r.a_verifier?.length ?? 0}</td>
                    <td>{r.fr_a_jour ? "à jour" : "⚠ fiche française modifiée depuis"}</td>
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
