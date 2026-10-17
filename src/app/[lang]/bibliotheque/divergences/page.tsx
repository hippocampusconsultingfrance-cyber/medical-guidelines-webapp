import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { cardTitle, loadLibrary } from "../data";
import Shell from "../shell";
import { creerDivergence, supprimerDivergence } from "./actions";

export const metadata: Metadata = {
  title: "Recommandations divergentes — medical-guidelines.net",
};

const MESSAGES: Record<string, string> = {
  creee: "Divergence enregistrée : l'encadré apparaît sur chaque fiche concernée.",
  supprimee: "Divergence supprimée.",
  question: "Indiquez la question clinique (5 caractères au moins).",
  positions: "Renseignez au moins deux positions, chacune sur une fiche différente.",
  erreur: "L'enregistrement n'a pas abouti (migration appliquée ?).",
};

type Divergence = {
  id: string;
  question: string;
  avertissement: string | null;
  divergence_positions: { document_id: string; position: string; grade: string | null }[];
};

// Recommandations divergentes (cahier des charges §4.4) : l'équipe relie
// les fiches de sociétés qui divergent sur une même question clinique ;
// chaque fiche affiche alors l'encadré, positions côte à côte.
export default async function DivergencesPage({ searchParams }: PageProps<"/[lang]/bibliotheque/divergences">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const lib = await loadLibrary(supabase, user.id);
  if (!lib.canPublish) redirect("/bibliotheque");

  const { data, error } = await supabase
    .from("divergences")
    .select("id, question, avertissement, divergence_positions(document_id, position, grade)")
    .order("created_at", { ascending: false });
  const divergences = (data ?? []) as Divergence[];
  const titre = new Map(lib.docs.map((d) => [d.id, cardTitle(d)]));
  const fiches = [...lib.docs].sort((a, b) => cardTitle(a).localeCompare(cardTitle(b), "fr"));
  const r = (await searchParams).r;
  const message = typeof r === "string" ? MESSAGES[r] : undefined;

  const position = (i: number) => (
    <fieldset key={i} className="unlock-box" style={{ marginTop: 12 }}>
      <legend style={{ fontWeight: 700 }}>
        Position {i + 1}
        {i >= 2 ? " (facultative)" : ""}
      </legend>
      <div className="field">
        <label htmlFor={`doc_${i}`}>Fiche (société savante)</label>
        <select id={`doc_${i}`} name={`doc_${i}`} required={i < 2} defaultValue="">
          <option value="">Choisir…</option>
          {fiches.map((d) => (
            <option key={d.id} value={d.id}>
              {cardTitle(d)}
              {d.publication_date ? ` (${d.publication_date.slice(0, 4)})` : ""}
            </option>
          ))}
        </select>
      </div>
      <div className="field">
        <label htmlFor={`position_${i}`}>Position de la société</label>
        <textarea id={`position_${i}`} name={`position_${i}`} required={i < 2} maxLength={1500} />
      </div>
      <div className="field">
        <label htmlFor={`population_${i}`}>Population</label>
        <input id={`population_${i}`} name={`population_${i}`} maxLength={300} />
      </div>
      <div style={{ display: "flex", gap: 12, flexWrap: "wrap" }}>
        <div className="field" style={{ flex: 1, minWidth: 140 }}>
          <label htmlFor={`grade_${i}`}>Grade (tel quel dans la source)</label>
          <input id={`grade_${i}`} name={`grade_${i}`} maxLength={100} placeholder="non indiqué" />
        </div>
        <div className="field" style={{ flex: 1, minWidth: 140 }}>
          <label htmlFor={`niveau_${i}`}>Niveau de preuve</label>
          <input id={`niveau_${i}`} name={`niveau_${i}`} maxLength={100} placeholder="non indiqué" />
        </div>
      </div>
    </fieldset>
  );

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">Équipe éditoriale</div>
        <h1>Recommandations divergentes</h1>
        <div className="doc-header__meta">
          <span>
            Positions présentées côte à côte, sans hiérarchie, avec leur date, population, grade et niveau de
            preuve (cahier des charges §4.4).
          </span>
        </div>
      </div>
      {message && (
        <div className="credit-strip" role="status">
          <b>{message}</b>
        </div>
      )}
      {error && <div className="panel warn">Migration des divergences pas encore appliquée dans Supabase.</div>}

      <h2 className="block-section" style={{ marginTop: 20 }}>
        Divergences enregistrées ({divergences.length})
      </h2>
      {divergences.length === 0 ? (
        <div className="lib-empty">Aucune divergence enregistrée.</div>
      ) : (
        divergences.map((d) => (
          <div key={d.id} className="report-card">
            <b>{d.question}</b>
            <ul style={{ margin: "6px 0", paddingLeft: 18, fontSize: "0.9rem" }}>
              {d.divergence_positions.map((p) => (
                <li key={p.document_id}>
                  <Link href={`/bibliotheque/${p.document_id}`}>{titre.get(p.document_id) ?? "Fiche"}</Link> :{" "}
                  {p.position.slice(0, 160)}
                  {p.position.length > 160 ? "…" : ""}
                </li>
              ))}
            </ul>
            <form action={supprimerDivergence}>
              <input type="hidden" name="id" value={d.id} />
              <button className="btn btn-ghost btn-sm">Supprimer</button>
            </form>
          </div>
        ))
      )}

      <form action={creerDivergence} style={{ marginTop: 28 }}>
        <h2 className="block-section">Nouvelle divergence</h2>
        <div className="field">
          <label htmlFor="question">Question clinique</label>
          <input id="question" name="question" required minLength={5} maxLength={300} />
        </div>
        <div className="field">
          <label htmlFor="avertissement">
            Avertissement (différences de population ou de système de gradation qui limitent la comparaison)
          </label>
          <textarea id="avertissement" name="avertissement" maxLength={1000} />
        </div>
        {[0, 1, 2, 3].map(position)}
        <button className="btn btn-primary" style={{ marginTop: 14 }}>
          Enregistrer la divergence
        </button>
      </form>
    </Shell>
  );
}
