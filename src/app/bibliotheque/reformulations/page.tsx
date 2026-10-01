import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { loadLibrary } from "../data";
import Shell from "../shell";
import { deciderReformulation, validerToutes } from "./actions";

export const metadata: Metadata = {
  title: "Reformulations à valider — medical-guidelines.net",
};

const MESSAGES: Record<string, string> = {
  ok: "Enregistré.",
  fiche_modifiee: "La fiche a été modifiée depuis la proposition : rien n'a été changé.",
  texte_invalide: "Texte vide ou trop long : rien n'a été changé.",
  introuvable: "Proposition déjà traitée.",
  erreur: "L'enregistrement n'a pas abouti (droits de validateur ; migration appliquée ?).",
  confirmation: "Cochez la case de confirmation avant la validation groupée.",
};

type Ligne = {
  id: string;
  fiche_key: string;
  document_id: string | null;
  original_html: string;
  proposition_html: string;
  texte_applique: string | null;
  status: string;
};

const sansBalises = (h: string) => h.replace(/<[^>]+>/g, "").replace(/&nbsp;/g, " ");

// Reformulation des libellés recopiés de la source (audit juridique,
// option C) : le médecin valide, retouche ou refuse chaque proposition ;
// rien n'est modifié dans une fiche sans sa décision.
export default async function ReformulationsPage({ searchParams }: PageProps<"/bibliotheque/reformulations">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const lib = await loadLibrary(supabase, user.id);
  if (!lib.canPublish) redirect("/bibliotheque");

  const params = await searchParams;
  const { data, error } = await supabase
    .from("libelles_reformulation")
    .select("id, fiche_key, document_id, original_html, proposition_html, texte_applique, status")
    .order("fiche_key")
    .order("chemin");
  const lignes = (data ?? []) as Ligne[];
  const titres = new Map(lib.docs.map((d) => [d.id, d.card_json?.title ?? d.title]));
  const fiches = [...new Set(lignes.map((l) => l.fiche_key))];
  const restantes = (k: string) => lignes.filter((l) => l.fiche_key === k && l.status === "proposee").length;
  const choisie = typeof params.fiche === "string" && fiches.includes(params.fiche) ? params.fiche : fiches.find((k) => restantes(k) > 0);
  const groupe = typeof params.r === "string" ? /^groupe_(\d+)_(\d+)$/.exec(params.r) : null;
  const message = groupe
    ? `${groupe[1]} libellé(s) remplacé(s) dans les fiches${Number(groupe[2]) ? ` ; ${groupe[2]} non appliqué(s) (fiche modifiée entre-temps)` : ""}.`
    : typeof params.r === "string"
      ? MESSAGES[params.r]
      : undefined;
  const restantTotal = lignes.filter((l) => l.status === "proposee").length;
  const total = lignes.length;
  const faites = lignes.filter((l) => l.status !== "proposee").length;

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">Conformité</div>
        <h1>Reformulations à valider</h1>
        <div className="doc-header__meta">
          <span>
            Libellés recopiés presque mot pour mot de la source (hors SFAR et HAS) : une reformulation est proposée,
            avec les mêmes chiffres, doses, grades et la même force de recommandation. Vérifiez le sens, retouchez si
            besoin, puis validez : le libellé est alors remplacé dans la fiche. Rien ne change sans votre décision.
          </span>
        </div>
      </div>
      {message && (
        <div className="credit-strip" role="status">
          <b>{message}</b>
        </div>
      )}
      {error ? (
        <div className="empty-state">Migration des reformulations pas encore appliquée dans Supabase.</div>
      ) : (
        <>
          <div className="credit-strip">
            <span>
              <b>
                {faites} / {total}
              </b>{" "}
              propositions traitées.
            </span>
          </div>
          <div style={{ display: "flex", flexWrap: "wrap", gap: 6, margin: "12px 0" }}>
            {fiches.map((k) => {
              const doc = lignes.find((l) => l.fiche_key === k)?.document_id;
              return (
                <Link
                  key={k}
                  href={`/bibliotheque/reformulations?fiche=${encodeURIComponent(k)}`}
                  className={`soc-chip${k === choisie ? " is-active" : ""}`}
                >
                  {(doc && titres.get(doc)) || k} <span>{restantes(k)}</span>
                </Link>
              );
            })}
          </div>
          {choisie && restantes(choisie) > 0 && (
            <form action={validerToutes} className="unlock-box" style={{ marginBottom: 16 }}>
              <input type="hidden" name="fiche" value={choisie} />
              <h2 style={{ marginTop: 0 }}>Validation groupée</h2>
              <p style={{ fontSize: "0.86rem" }}>
                Applique telles quelles les propositions restantes, sans retouche. Les chiffres, doses, grades et la force
                des recommandations ont été contrôlés automatiquement, mais seule votre relecture garantit le sens.
              </p>
              <label style={{ display: "flex", gap: 8, alignItems: "flex-start", fontSize: "0.86rem", margin: "4px 0 12px" }}>
                <input type="checkbox" name="confirme" value="1" required style={{ marginTop: 3 }} />
                <span>J&apos;ai relu les propositions et je valide leur remplacement dans les fiches.</span>
              </label>
              <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
                <button name="portee" value="fiche" className="btn btn-primary btn-sm">
                  Valider les {restantes(choisie)} propositions de cette fiche
                </button>
                <button name="portee" value="toutes" className="btn btn-ghost btn-sm">
                  Valider toutes les fiches ({restantTotal} propositions)
                </button>
              </div>
            </form>
          )}
          {!choisie ? (
            <div className="empty-state">Toutes les propositions ont été traitées.</div>
          ) : (
            lignes
              .filter((l) => l.fiche_key === choisie)
              .map((l) => (
                <div key={l.id} id={l.id} className="report-card">
                  <p style={{ fontSize: "0.82rem", color: "var(--ink-muted)", margin: 0 }}>Texte actuel (proche de la source)</p>
                  <p style={{ margin: "4px 0 10px" }}>{sansBalises(l.original_html)}</p>
                  {l.status === "proposee" ? (
                    <form action={deciderReformulation}>
                      <input type="hidden" name="id" value={l.id} />
                      <input type="hidden" name="fiche" value={l.fiche_key} />
                      <label className="field" style={{ display: "block" }}>
                        <span style={{ fontSize: "0.82rem", color: "var(--ink-muted)" }}>Proposition (modifiable)</span>
                        <textarea name="texte" defaultValue={l.proposition_html} rows={4} maxLength={4000} required />
                      </label>
                      <div className="report-card__actions">
                        <button name="decision" value="valider" className="btn btn-primary btn-sm">
                          Valider et remplacer dans la fiche
                        </button>
                        <button name="decision" value="refuser" className="btn btn-ghost btn-sm" formNoValidate>
                          Garder le texte actuel
                        </button>
                      </div>
                    </form>
                  ) : (
                    <p className={`state-pill ${l.status === "appliquee" ? "state-open" : "state-draft"}`} style={{ width: "fit-content" }}>
                      {l.status === "appliquee" ? `Appliquée : ${sansBalises(l.texte_applique ?? "")}` : "Texte actuel conservé"}
                    </p>
                  )}
                </div>
              ))
          )}
          {choisie && (
            <p className="block-p is-note">
              {(() => {
                const doc = lignes.find((l) => l.fiche_key === choisie)?.document_id;
                return doc ? <Link href={`/bibliotheque/${doc}`}>Voir la fiche</Link> : null;
              })()}
            </p>
          )}
        </>
      )}
    </Shell>
  );
}
