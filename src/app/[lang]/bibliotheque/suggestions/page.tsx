import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { CATEGORIES_SUGGESTION, instructionSuggestion } from "@/lib/instructions";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import { loadLibrary } from "../data";
import Instruction from "../instruction";
import Shell from "../shell";
import { deciderSuggestion } from "./actions";

export const metadata: Metadata = {
  title: "Suggestions des membres — medical-guidelines.net",
};

const STATUT: Record<string, string> = { nouveau: "Nouveau", traite: "Traité", rejete: "Non retenu" };

type Suggestion = {
  id: string;
  categorie: string;
  page: string | null;
  message: string;
  status: string;
  admin_note: string | null;
  created_at: string;
};

// Suggestions envoyées par les membres (bouton « Une idée ? ») : chacune
// avec une instruction prête à copier pour la corriger. Administrateur ;
// l'auteur n'est pas affiché (inutile pour traiter la demande).
export default async function SuggestionsAdminPage({ searchParams }: PageProps<"/[lang]/bibliotheque/suggestions">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const [lib, { data: isAdmin }] = await Promise.all([loadLibrary(supabase, user.id), supabase.rpc("is_admin")]);
  if (!isAdmin) redirect("/bibliotheque");

  const params = await searchParams;
  const filtre = params.voir === "tout" ? "tout" : "nouveau";
  let q = createAdminClient()
    .from("site_suggestions")
    .select("id, categorie, page, message, status, admin_note, created_at")
    .order("created_at", { ascending: false })
    .limit(200);
  if (filtre === "nouveau") q = q.eq("status", "nouveau");
  const { data, error } = await q;
  const suggestions = (data ?? []) as Suggestion[];

  return (
    <Shell lib={lib}>
      <div className="doc-header">
        <div className="doc-header__eyebrow">Administration</div>
        <h1>Suggestions des membres</h1>
        <div className="doc-header__meta">
          <span>
            {filtre === "nouveau" ? (
              <>
                <b>{suggestions.length}</b> à traiter · <a href="?voir=tout">Tout afficher</a>
              </>
            ) : (
              <>
                {suggestions.length} au total · <a href="?">Seulement les nouvelles</a>
              </>
            )}
          </span>
        </div>
      </div>
      {params.r === "erreur" && (
        <div className="credit-strip" role="status">
          <b>L&apos;enregistrement n&apos;a pas abouti.</b>
        </div>
      )}
      {error ? (
        <div className="empty-state">Migration des suggestions pas encore appliquée dans Supabase.</div>
      ) : suggestions.length === 0 ? (
        <div className="empty-state">Aucune suggestion à traiter.</div>
      ) : (
        suggestions.map((s) => (
          <div key={s.id} className="report-card">
            <div className="report-card__top">
              <div>
                <div className="report-card__where">
                  {CATEGORIES_SUGGESTION[s.categorie] ?? s.categorie}
                  {s.page ? (
                    <>
                      {" · "}
                      <a href={s.page}>{s.page}</a>
                    </>
                  ) : null}
                </div>
                <div className="report-card__date">
                  {new Date(s.created_at).toLocaleString("fr-FR", { timeZone: "Europe/Paris" })}
                </div>
              </div>
              <span className={`status-pill status-${s.status === "traite" ? "resolu" : s.status}`}>
                {STATUT[s.status] ?? s.status}
              </span>
            </div>
            <div className="report-card__desc">{s.message}</div>
            {s.admin_note && <p className="block-p is-note">Note : {s.admin_note}</p>}
            {s.status === "nouveau" && <Instruction texte={instructionSuggestion(s)} />}
            <form action={deciderSuggestion} className="report-card__actions" style={{ flexWrap: "wrap" }}>
              <input type="hidden" name="id" value={s.id} />
              <input name="note" maxLength={1000} placeholder="Note (facultatif)" defaultValue={s.admin_note ?? ""} />
              {s.status !== "traite" && (
                <button name="status" value="traite" className="btn btn-ghost btn-sm">
                  Traité
                </button>
              )}
              {s.status !== "rejete" && (
                <button name="status" value="rejete" className="btn btn-ghost btn-sm">
                  Non retenu
                </button>
              )}
              {s.status !== "nouveau" && (
                <button name="status" value="nouveau" className="btn btn-ghost btn-sm">
                  Rouvrir
                </button>
              )}
            </form>
          </div>
        ))
      )}
    </Shell>
  );
}
