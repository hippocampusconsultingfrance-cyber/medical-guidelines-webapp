import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { cardTitle, loadLibrary } from "../data";
import Shell from "../shell";
import { deciderPointsCles, validerTousPointsCles } from "./actions";

export const metadata: Metadata = {
  title: "Points clés à valider — medical-guidelines.net",
};

const MESSAGES: Record<string, string> = {
  ok: "Points clés validés : ils s'affichent en tête de la fiche.",
  ok_relue: "Points clés validés et relecture signée : la fiche affiche « Relue par … ».",
  points_invalides: "Il faut 3 à 5 points (une ligne par point, 400 caractères au plus) : rien n'a été enregistré.",
  introuvable: "Proposition déjà traitée.",
  relue_nom: "Points clés validés, mais la relecture n'a pas été signée : renseignez votre prénom et votre nom dans Mon compte.",
  relue_erreur: "Points clés validés, mais la relecture n'a pas pu être signée.",
  erreur: "L'enregistrement n'a pas abouti (droits de validateur ; migration appliquée ?).",
  confirmation: "Cochez la case de confirmation avant la validation groupée.",
};

type Proposition = { document_id: string; fiche_key: string; points: string[]; status: string };

// Points clés en tête de fiche (recette 2.2-1) : propositions rédigées à
// partir du contenu de chaque fiche, validées (ou retouchées) par un médecin
// avant tout affichage. La relecture de la fiche peut être signée en même
// temps.
export default async function PointsClesPage({ searchParams }: PageProps<"/[lang]/bibliotheque/points-cles">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const lib = await loadLibrary(supabase, user.id);
  if (!lib.canPublish) redirect("/bibliotheque");

  const params = await searchParams;
  const { data, error } = await supabase
    .from("points_cles_propositions")
    .select("document_id, fiche_key, points, status")
    .order("fiche_key");
  const propositions = (data ?? []) as Proposition[];
  const titres = new Map(lib.docs.map((d) => [d.id, cardTitle(d)]));
  const titre = (p: Proposition) => titres.get(p.document_id) ?? p.fiche_key;
  const restantes = propositions.filter((p) => p.status === "proposee");
  const demandee = typeof params.fiche === "string" ? propositions.find((p) => p.document_id === params.fiche) : undefined;
  // Après une décision, passer à la fiche suivante encore à valider.
  const courante =
    demandee && (demandee.status === "proposee" || !(typeof params.r === "string" && params.r.startsWith("ok")))
      ? demandee
      : restantes[0];
  const groupe = typeof params.r === "string" ? /^groupe_(\d+)$/.exec(params.r) : null;
  const message = groupe
    ? `${groupe[1]} fiche(s) : points clés validés et affichés.`
    : typeof params.r === "string"
      ? MESSAGES[params.r]
      : undefined;

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">Contenu</div>
        <h1>Points clés à valider</h1>
        <div className="doc-header__meta">
          <span>
            3 à 5 points clés par fiche, rédigés à partir de son contenu. Vérifiez-les en regard de la fiche, retouchez si
            besoin (une ligne par point), puis validez : ils s&apos;affichent alors en tête de la fiche. Rien ne s&apos;affiche
            sans votre décision.
          </span>
        </div>
      </div>
      {message && (
        <div className="credit-strip" role="status">
          <b>{message}</b>
        </div>
      )}
      {error ? (
        <div className="empty-state">Migration des points clés pas encore appliquée dans Supabase.</div>
      ) : (
        <>
          <div className="credit-strip">
            <span>
              <b>
                {propositions.length - restantes.length} / {propositions.length}
              </b>{" "}
              fiches traitées.
            </span>
          </div>

          <form method="get" style={{ display: "flex", gap: 8, flexWrap: "wrap", margin: "12px 0" }}>
            <select name="fiche" defaultValue={courante?.document_id} aria-label="Choisir une fiche" style={{ flex: "1 1 240px", minWidth: 0 }}>
              {propositions.map((p) => (
                <option key={p.document_id} value={p.document_id}>
                  {p.status === "proposee" ? "• " : p.status === "validee" ? "✓ " : "✗ "}
                  {titre(p)}
                </option>
              ))}
            </select>
            <button className="btn btn-ghost btn-sm">Ouvrir</button>
          </form>

          {!courante ? (
            <div className="empty-state">Toutes les propositions ont été traitées.</div>
          ) : (
            <div className="report-card">
              <h2 style={{ margin: "0 0 4px", fontSize: "1.05rem" }}>{titre(courante)}</h2>
              <p style={{ margin: "0 0 12px", fontSize: "0.86rem" }}>
                <Link href={`/bibliotheque/${courante.document_id}`} target="_blank">
                  Ouvrir la fiche pour comparer ↗
                </Link>
              </p>
              {courante.status === "proposee" ? (
                <form action={deciderPointsCles}>
                  <input type="hidden" name="id" value={courante.document_id} />
                  <label className="field" style={{ display: "block" }}>
                    <span style={{ fontSize: "0.82rem", color: "var(--ink-muted)" }}>Points clés proposés (un par ligne, modifiables)</span>
                    <textarea name="points" defaultValue={courante.points.join("\n")} rows={9} maxLength={3000} required />
                  </label>
                  <label style={{ display: "flex", gap: 8, alignItems: "flex-start", fontSize: "0.86rem", margin: "8px 0 12px" }}>
                    <input type="checkbox" name="relue" value="1" style={{ marginTop: 3 }} />
                    <span>J&apos;ai aussi relu toute la fiche aujourd&apos;hui : signer la relecture (« Relue par Dr …, le … »).</span>
                  </label>
                  <div className="report-card__actions">
                    <button name="decision" value="valider" className="btn btn-primary btn-sm">
                      Valider les points clés
                    </button>
                    <button name="decision" value="refuser" className="btn btn-ghost btn-sm" formNoValidate>
                      Écarter la proposition
                    </button>
                  </div>
                </form>
              ) : (
                <>
                  <p className={`state-pill ${courante.status === "validee" ? "state-open" : "state-draft"}`} style={{ width: "fit-content" }}>
                    {courante.status === "validee" ? "Validés et affichés" : "Proposition écartée"}
                  </p>
                  {courante.status === "validee" && (
                    <ul style={{ margin: "8px 0 0", paddingLeft: 20 }}>
                      {courante.points.map((p, i) => (
                        <li key={i}>{p}</li>
                      ))}
                    </ul>
                  )}
                </>
              )}
            </div>
          )}

          {restantes.length > 1 && (
            <form action={validerTousPointsCles} className="unlock-box" style={{ marginTop: 20 }}>
              <h2 style={{ marginTop: 0 }}>Validation groupée</h2>
              <p style={{ fontSize: "0.86rem" }}>
                Valide telles quelles les {restantes.length} propositions restantes, sans retouche ni signature de relecture.
                Seule votre relecture garantit le sens des points clés.
              </p>
              <label style={{ display: "flex", gap: 8, alignItems: "flex-start", fontSize: "0.86rem", margin: "4px 0 12px" }}>
                <input type="checkbox" name="confirme" value="1" required style={{ marginTop: 3 }} />
                <span>J&apos;ai relu ces points clés et je valide leur affichage en tête des fiches.</span>
              </label>
              <button className="btn btn-ghost btn-sm">Valider les {restantes.length} propositions restantes</button>
            </form>
          )}
        </>
      )}
    </Shell>
  );
}
