import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { chargerPropositions } from "@/lib/actualisations";
import { createClient } from "@/lib/supabase/server";
import { loadLibrary } from "../data";
import Shell from "../shell";
import { deciderActualisation } from "./actions";

export const metadata: Metadata = {
  title: "Actualisations à valider — medical-guidelines.net",
};

const MESSAGES: Record<string, string> = {
  validee: "Remplacement validé : l'ancienne fiche affiche un lien vers la nouvelle.",
  ecartee: "Proposition écartée : elle ne sera plus présentée.",
  erreur: "L'enregistrement n'a pas abouti (droits de validateur ; migration appliquée ?).",
};

// Fiches probablement remplacées par une version plus récente (même sujet,
// sociétés communes, au moins deux ans d'écart) : le validateur confirme ou
// écarte. Rien n'est appliqué sans décision humaine.
export default async function ActualisationsPage({ searchParams }: PageProps<"/bibliotheque/actualisations">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const lib = await loadLibrary(supabase, user.id);
  if (!lib.canPublish) redirect("/bibliotheque");

  const propositions = await chargerPropositions(supabase);
  const r = (await searchParams).r;
  const message = typeof r === "string" ? MESSAGES[r] : undefined;
  const an = (d: string | null) => (d ? d.slice(0, 4) : "?");

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">Veille</div>
        <h1>Actualisations à valider</h1>
        <div className="doc-header__meta">
          <span>
            Fiches probablement remplacées par une recommandation plus récente sur le même sujet. Validez pour
            afficher sur l&apos;ancienne fiche un lien vers la nouvelle ; écartez si ce n&apos;est pas le cas.
          </span>
        </div>
      </div>
      {message && (
        <div className="credit-strip" role="status">
          <b>{message}</b>
        </div>
      )}
      {propositions.length === 0 ? (
        <div className="lib-empty">Aucune actualisation à valider.</div>
      ) : (
        <div style={{ display: "grid", gap: 12, marginTop: 16 }}>
          {propositions.map((p) => (
            <div key={`${p.ancienne.id}:${p.nouvelle.id}`} className="report-card">
              <div style={{ fontSize: "0.9rem" }}>
                <Link href={`/bibliotheque/${p.ancienne.id}`}>
                  <b>{p.ancienne.titre}</b>
                </Link>{" "}
                ({an(p.ancienne.date)}, {p.ancienne.societes.join("/") || "—"})
              </div>
              <div style={{ fontSize: "0.9rem", margin: "4px 0 10px" }}>
                → remplacée par{" "}
                <Link href={`/bibliotheque/${p.nouvelle.id}`}>
                  <b>{p.nouvelle.titre}</b>
                </Link>{" "}
                ({an(p.nouvelle.date)}, {p.nouvelle.societes.join("/") || "—"})
              </div>
              <form action={deciderActualisation} style={{ display: "flex", gap: 10, flexWrap: "wrap" }}>
                <input type="hidden" name="ancienne" value={p.ancienne.id} />
                <input type="hidden" name="nouvelle" value={p.nouvelle.id} />
                <button className="btn btn-primary btn-sm" name="decision" value="valider">
                  Valider le remplacement
                </button>
                <button className="btn btn-ghost btn-sm" name="decision" value="ecarter">
                  Écarter
                </button>
              </form>
            </div>
          ))}
        </div>
      )}
    </Shell>
  );
}
