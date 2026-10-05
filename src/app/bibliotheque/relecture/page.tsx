import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { cardTitle, loadLibrary } from "../data";
import Shell from "../shell";
import { signerEquipe } from "./actions";
import ToutCocher from "./tout-cocher";

export const metadata: Metadata = {
  title: "Relecture des fiches — medical-guidelines.net",
};

const MESSAGES: Record<string, [string, boolean]> = {
  attestation: ["Cochez l'attestation avant de signer.", false],
  aucune: ["Aucune fiche cochée.", false],
  erreur: ["La signature n'a pas abouti (droits de validateur, double authentification ?).", false],
};

// Fiches publiées sans relecture signée, ou signées puis corrigées depuis.
// Un validateur atteste, pour les
// fiches qu'il coche, leur relecture par l'équipe médicale interne : chaque
// fiche affiche alors « Relue par Équipe médicale interne, le … ».
export default async function RelecturePage({ searchParams }: PageProps<"/bibliotheque/relecture">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const lib = await loadLibrary(supabase, user.id);
  if (!lib.canPublish) redirect("/bibliotheque");

  const { data: signatures } = await supabase.from("documents").select("id, relue_par_nom, relue_le");
  const signee = new Map((signatures ?? []).map((s) => [s.id as string, s.relue_par_nom as string | null]));
  const aRelire = lib.docs.filter((d) => lib.published.has(d.id) && !signee.get(d.id));
  const relues = lib.docs.filter((d) => signee.get(d.id)).length;
  // Fiches signées « Équipe médicale interne » puis corrigées : à relire et
  // signer à nouveau (liste calculée par la base, validateurs seulement).
  const { data: corrigeesIds } = await supabase.rpc("fiches_corrigees_apres_signature");
  const corrigeesSet = new Set(((corrigeesIds as string[] | null) ?? []).map(String));
  const corrigees = lib.docs.filter((d) => corrigeesSet.has(d.id));

  const r = (await searchParams).r;
  const message =
    typeof r === "string" && r.startsWith("ok_")
      ? ([`${r.slice(3)} fiche(s) signée(s) « Relue par Équipe médicale interne ».`, true] as [string, boolean])
      : typeof r === "string"
        ? MESSAGES[r]
        : undefined;

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">Validation médicale</div>
        <h1>Relecture des fiches</h1>
        <div className="doc-header__meta">
          <span>
            {relues} fiche(s) signée(s) · {aRelire.length} fiche(s) publiée(s) sans relecture signée ·{" "}
            {corrigees.length} fiche(s) corrigée(s) depuis leur signature
          </span>
        </div>
      </div>

      {message && (
        <div className={`panel${message[1] ? "" : " crit"}`} role="status">
          {message[0]}
        </div>
      )}

      {aRelire.length === 0 && corrigees.length === 0 ? (
        <div className="lib-empty">Toutes les fiches publiées portent une relecture signée.</div>
      ) : (
        <form action={signerEquipe} className="unlock-box" style={{ marginTop: 18 }}>
          <h2>Signer « Équipe médicale interne »</h2>
          <p>
            Cochez les fiches relues par l&apos;équipe médicale interne. Chacune affichera « Relue par Équipe médicale
            interne » avec la date du jour ; votre compte est inscrit au journal comme auteur de l&apos;attestation. Une
            fiche déjà signée nominativement n&apos;est jamais modifiée.
          </p>
          <ToutCocher />
          {corrigees.length > 0 && (
            <>
              <h3 style={{ margin: "14px 0 4px", fontSize: "0.95rem" }}>Fiches corrigées depuis leur signature</h3>
              <p style={{ margin: 0, fontSize: "0.85rem", color: "var(--ink-muted)" }}>
                Signées « Équipe médicale interne » avant une correction inscrite au{" "}
                <a href="/corrections">journal des corrections</a>. Relisez les corrections avant de signer à nouveau.
              </p>
              <ul style={{ listStyle: "none", padding: 0, margin: "8px 0 12px", maxHeight: 420, overflowY: "auto", border: "1px solid var(--border)", borderRadius: 8 }}>
                {corrigees.map((d) => (
                  <li key={d.id} style={{ borderBottom: "1px solid var(--border)", padding: "6px 10px" }}>
                    <label style={{ display: "flex", gap: 8, alignItems: "flex-start", fontSize: "0.88rem" }}>
                      <input type="checkbox" name="ids" value={d.id} style={{ marginTop: 3 }} />
                      <span>
                        {cardTitle(d)}
                        <span style={{ color: "var(--ink-muted)" }}> · {d.card_json?.society ?? d.doc_type ?? ""}</span>
                      </span>
                    </label>
                  </li>
                ))}
              </ul>
            </>
          )}
          {aRelire.length > 0 && corrigees.length > 0 && (
            <h3 style={{ margin: "14px 0 4px", fontSize: "0.95rem" }}>Fiches jamais signées</h3>
          )}
          {aRelire.length > 0 && (
          <ul style={{ listStyle: "none", padding: 0, margin: "12px 0", maxHeight: 420, overflowY: "auto", border: "1px solid var(--border)", borderRadius: 8 }}>
            {aRelire.map((d) => (
              <li key={d.id} style={{ borderBottom: "1px solid var(--border)", padding: "6px 10px" }}>
                <label style={{ display: "flex", gap: 8, alignItems: "flex-start", fontSize: "0.88rem" }}>
                  <input type="checkbox" name="ids" value={d.id} style={{ marginTop: 3 }} />
                  <span>
                    {cardTitle(d)}
                    <span style={{ color: "var(--ink-muted)" }}> · {d.card_json?.society ?? d.doc_type ?? ""}</span>
                  </span>
                </label>
              </li>
            ))}
          </ul>
          )}
          <label style={{ display: "flex", gap: 8, alignItems: "flex-start", fontSize: "0.88rem", margin: "4px 0 12px" }}>
            <input type="checkbox" name="atteste" value="1" required style={{ marginTop: 3 }} />
            <span>
              J&apos;atteste que les fiches cochées ont été relues et validées par l&apos;équipe médicale interne, sous ma
              responsabilité de validateur.
            </span>
          </label>
          <button className="btn btn-primary">Signer les fiches cochées</button>
        </form>
      )}
    </Shell>
  );
}
