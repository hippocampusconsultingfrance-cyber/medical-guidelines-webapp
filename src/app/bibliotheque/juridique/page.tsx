import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { loadLibrary } from "../data";
import Shell from "../shell";
import { enregistrerProfil } from "./actions";
import { CHAMPS, STATUT_LABEL } from "./champs";

export const metadata: Metadata = {
  title: "Registre juridique — medical-guidelines.net",
};

const MESSAGES: Record<string, string> = {
  erreur: "L'enregistrement n'a pas abouti (droits de validateur ; migration appliquée ?).",
  invalide: "Valeur non reconnue : rien n'a été enregistré.",
  vide: "Aucune fiche pour cette société.",
};

type Profil = Record<string, string | null> & { document_id: string };
type Groupe = {
  cle: string;
  nom: string;
  fiches: { id: string; titre: string; enLigne: boolean; profil: Profil | undefined }[];
};

// Registre juridique par source (cahier des charges V4.5 §12.4) : seul le
// statut « Validé » permet de publier une fiche (verrou en base, §9.2). Le
// registre se remplit par société porteuse, en une fois pour toutes ses
// fiches ; une fiche particulière peut ensuite recevoir son propre profil.
export default async function JuridiquePage({ searchParams }: PageProps<"/bibliotheque/juridique">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const lib = await loadLibrary(supabase, user.id);
  if (!lib.canPublish) redirect("/bibliotheque");

  const [{ data: docs }, { data: profils }] = await Promise.all([
    supabase
      .from("documents")
      .select("id, title, card_json, published_at, society_id, societies!documents_society_id_fkey(acronym, full_name)")
      .neq("freshness_status", "retiree"),
    supabase.from("source_legal_profiles").select("*"),
  ]);
  const parFiche = new Map(((profils ?? []) as Profil[]).map((p) => [p.document_id, p]));

  const groupes = new Map<string, Groupe>();
  type Doc = {
    id: string;
    title: string;
    card_json: { title?: string } | null;
    published_at: string | null;
    society_id: string | null;
    societies: { acronym: string; full_name: string | null } | { acronym: string; full_name: string | null }[] | null;
  };
  for (const d of (docs ?? []) as Doc[]) {
    const s = Array.isArray(d.societies) ? d.societies[0] : d.societies;
    const cle = d.society_id ?? "aucune";
    const g =
      groupes.get(cle) ??
      ({ cle, nom: s ? `${s.acronym}${s.full_name ? ` — ${s.full_name}` : ""}` : "Sans société porteuse", fiches: [] } as Groupe);
    g.fiches.push({
      id: d.id,
      titre: d.card_json?.title ?? d.title,
      enLigne: Boolean(d.published_at),
      profil: parFiche.get(d.id),
    });
    groupes.set(cle, g);
  }
  const liste = [...groupes.values()].sort((a, b) => b.fiches.length - a.fiches.length);
  const enLigne = liste.flatMap((g) => g.fiches).filter((f) => f.enLigne);
  const enLigneValidees = enLigne.filter((f) => f.profil?.legal_review_status === "valide").length;

  const r = (await searchParams).r;
  const message =
    typeof r === "string"
      ? r.startsWith("ok_")
        ? `Registre enregistré pour ${r.slice(3)} fiche(s).`
        : MESSAGES[r]
      : undefined;

  // Profil proposé dans le formulaire : celui le plus fréquent dans le groupe.
  const profilType = (g: Groupe) => {
    const compte = new Map<string, { n: number; p: Profil }>();
    for (const f of g.fiches) {
      if (!f.profil) continue;
      const k = JSON.stringify(CHAMPS.map((c) => f.profil?.[c.nom] ?? ""));
      const e = compte.get(k) ?? { n: 0, p: f.profil };
      e.n++;
      compte.set(k, e);
    }
    return [...compte.values()].sort((a, b) => b.n - a.n)[0]?.p;
  };

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">Conformité</div>
        <h1>Registre juridique</h1>
        <div className="doc-header__meta">
          <span>
            Pour chaque source : droit d&apos;auteur, réutilisation commerciale, veille automatisée, traduction,
            autorisation. Seul le statut « Validé » permet de mettre une fiche en ligne. Les fiches déjà en ligne ne
            sont pas retirées.
          </span>
        </div>
      </div>
      {message && (
        <div className="credit-strip" role="status">
          <b>{message}</b>
        </div>
      )}
      <div className="credit-strip">
        <span>
          <b>
            {enLigneValidees} / {enLigne.length}
          </b>{" "}
          fiches en ligne avec un statut juridique validé.
        </span>
      </div>

      <div style={{ display: "grid", gap: 12, marginTop: 16 }}>
        {liste.map((g) => {
          const p = profilType(g);
          const valides = g.fiches.filter((f) => f.profil?.legal_review_status === "valide").length;
          return (
            <details key={g.cle} className="report-card">
              <summary style={{ cursor: "pointer", display: "flex", gap: 10, alignItems: "center", flexWrap: "wrap" }}>
                <b>{g.nom}</b>
                <span className={`state-pill ${valides === g.fiches.length ? "state-open" : "state-draft"}`}>
                  {valides} / {g.fiches.length} validée{valides > 1 ? "s" : ""}
                </span>
              </summary>
              <form action={enregistrerProfil} style={{ display: "grid", gap: 10, marginTop: 12 }}>
                <input type="hidden" name="societe" value={g.cle} />
                <div className="field">
                  <label htmlFor={`fiche-${g.cle}`}>Appliquer à</label>
                  <select id={`fiche-${g.cle}`} name="fiche" defaultValue="">
                    <option value="">Toutes les fiches de cette société ({g.fiches.length})</option>
                    {g.fiches.map((f) => (
                      <option key={f.id} value={f.id}>
                        {f.titre.slice(0, 90)}
                        {f.profil ? ` — ${STATUT_LABEL[f.profil.legal_review_status ?? ""] ?? ""}` : " — non renseigné"}
                      </option>
                    ))}
                  </select>
                </div>
                <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(220px, 1fr))", gap: 10 }}>
                  {CHAMPS.map((c) => (
                    <div key={c.nom} className="field">
                      <label htmlFor={`${c.nom}-${g.cle}`}>{c.label}</label>
                      <select id={`${c.nom}-${g.cle}`} name={c.nom} defaultValue={p?.[c.nom] ?? c.options[0][0]}>
                        {c.options.map(([v, l]) => (
                          <option key={v} value={v}>
                            {l}
                          </option>
                        ))}
                      </select>
                    </div>
                  ))}
                </div>
                <div className="field">
                  <label htmlFor={`notes-${g.cle}`}>Notes (avis juridique, conditions d&apos;usage, lien)</label>
                  <textarea id={`notes-${g.cle}`} name="legal_notes" maxLength={2000} defaultValue={p?.legal_notes ?? ""} />
                </div>
                <button className="btn btn-primary" style={{ width: "fit-content" }}>
                  Enregistrer
                </button>
              </form>
              <ul style={{ marginTop: 12, fontSize: "0.85rem", paddingLeft: 18 }}>
                {g.fiches.map((f) => (
                  <li key={f.id}>
                    <Link href={`/bibliotheque/${f.id}`}>{f.titre}</Link>
                    {f.enLigne ? "" : " (brouillon)"} —{" "}
                    {f.profil ? (STATUT_LABEL[f.profil.legal_review_status ?? ""] ?? "?") : "non renseigné"}
                  </li>
                ))}
              </ul>
            </details>
          );
        })}
      </div>
    </Shell>
  );
}
