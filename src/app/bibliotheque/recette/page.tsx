import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { RECETTE } from "@/lib/recette";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import { loadLibrary } from "../data";
import Shell from "../shell";
import { cocherCritere } from "./actions";

export const metadata: Metadata = {
  title: "Recette — medical-guidelines.net",
};

type Validation = { code: string; validated_at: string; validated_by: string | null; note: string | null };

// Checklist de recette (document 3/3 du cahier des charges) : chaque critère
// est coché, daté et signé par le porteur de projet avant l'ouverture
// commerciale.
export default async function RecettePage({ searchParams }: PageProps<"/bibliotheque/recette">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const { data: isAdmin } = await supabase.rpc("is_admin");
  if (!isAdmin) redirect("/bibliotheque");

  const lib = await loadLibrary(supabase, user.id);
  const admin = createAdminClient();
  const { data, error } = await admin.from("recette_validations").select("code, validated_at, validated_by, note");
  const faites = new Map(((data ?? []) as Validation[]).map((v) => [v.code, v]));
  const auteurs = [...new Set([...faites.values()].map((v) => v.validated_by).filter(Boolean))] as string[];
  const { data: profils } = auteurs.length
    ? await admin.from("profiles").select("id, prenom, nom").in("id", auteurs)
    : { data: [] };
  const nom = new Map(
    ((profils ?? []) as { id: string; prenom: string | null; nom: string | null }[]).map((p) => [
      p.id,
      [p.prenom, p.nom].filter(Boolean).join(" ") || "Administrateur",
    ]),
  );
  const rubriques = [...new Set(RECETTE.map((c) => c.rubrique))];
  const total = RECETTE.length;
  const n = RECETTE.filter((c) => faites.has(c.code)).length;
  const r = (await searchParams).r;

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">Administration</div>
        <h1>Recette avant ouverture commerciale</h1>
        <div className="doc-header__meta">
          <span>
            <b>
              {n} / {total}
            </b>{" "}
            critères vérifiés. Chaque critère coché est daté et signé à votre nom.
          </span>
        </div>
      </div>
      {error && <div className="panel warn">Migration de la recette pas encore appliquée dans Supabase.</div>}
      {r === "erreur" && <div className="panel warn">L&apos;enregistrement n&apos;a pas abouti.</div>}
      <div style={{ height: 8, background: "var(--border)", borderRadius: 4, margin: "12px 0 20px" }}>
        <div style={{ width: `${Math.round((100 * n) / total)}%`, height: 8, background: "#2BB5A6", borderRadius: 4 }} />
      </div>

      {rubriques.map((rub) => (
        <section key={rub} style={{ marginBottom: 22 }}>
          <h2 className="block-section">{rub}</h2>
          <div style={{ display: "grid", gap: 8 }}>
            {RECETTE.filter((c) => c.rubrique === rub).map((c) => {
              const v = faites.get(c.code);
              return (
                <div key={c.code} id={`c-${c.code}`} className="report-card" style={{ borderLeft: `4px solid ${v ? "#2BB5A6" : "var(--border)"}` }}>
                  <b style={{ fontSize: "0.92rem" }}>{c.critere}</b>
                  <div style={{ fontSize: "0.82rem", color: "var(--ink-muted)", margin: "4px 0 8px" }}>Comment vérifier : {c.verif}</div>
                  {v ? (
                    <form action={cocherCritere} style={{ display: "flex", gap: 10, alignItems: "center", flexWrap: "wrap" }}>
                      <span className="state-pill state-open">
                        ✓ Vérifié le{" "}
                        {new Date(v.validated_at).toLocaleDateString("fr-FR", { timeZone: "Europe/Paris" })} par{" "}
                        {nom.get(v.validated_by ?? "") ?? "Administrateur"}
                      </span>
                      {v.note && <span style={{ fontSize: "0.82rem" }}>{v.note}</span>}
                      <input type="hidden" name="code" value={c.code} />
                      <input type="hidden" name="verifie" value="0" />
                      <button className="btn btn-ghost btn-sm">Annuler</button>
                    </form>
                  ) : (
                    <form action={cocherCritere} style={{ display: "flex", gap: 8, alignItems: "center", flexWrap: "wrap" }}>
                      <input type="hidden" name="code" value={c.code} />
                      <input type="hidden" name="verifie" value="1" />
                      <input name="note" maxLength={500} placeholder="Remarque (facultatif)" style={{ flex: 1, minWidth: 160 }} />
                      <button className="btn btn-primary btn-sm">Vérifié</button>
                    </form>
                  )}
                </div>
              );
            })}
          </div>
        </section>
      ))}
    </Shell>
  );
}
