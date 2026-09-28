import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { formatDate, FREE_QUOTA } from "@/lib/fiches";
import { cardTitle, docState, loadLibrary } from "./data";
import Shell from "./shell";

export const metadata: Metadata = {
  title: "Bibliothèque — Medical Guidelines",
};

const STATE_LABEL = { lock: "🔒 Bloquée", open: "Débloquée", draft: "Brouillon" };
const STATE_CLASS = { lock: "state-lock", open: "state-open", draft: "state-draft" };

// Catalogue des fiches de la spécialité du compte, de la plus récente à la
// plus ancienne, avec le design de l'ancienne page. Toutes les fiches sont
// bloquées par défaut : un compte gratuit dispose de 5 crédits de
// déblocage, un compte PREMIUM ouvre tout.
export default async function BibliothequePage({
  searchParams,
}: PageProps<"/bibliotheque">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");

  const lib = await loadLibrary(supabase, user.id);
  const q = (await searchParams).q;
  const query = typeof q === "string" ? q.trim().slice(0, 100) : "";
  const needle = normalize(query);
  const docs = needle
    ? lib.docs.filter((d) =>
        normalize(`${d.title} ${d.card_json?.title ?? ""} ${d.card_json?.short ?? ""}`).includes(needle),
      )
    : lib.docs;

  const used = lib.unlocked.size;
  const remaining = Math.max(FREE_QUOTA - used, 0);

  return (
    <Shell lib={lib}>
      <div className="hero">
        <div className="hero__eyebrow">Anesthésie-réanimation</div>
        <h1>Les recommandations, enfin lisibles.</h1>
        <p>
          Synthèses fidèles des recommandations des sociétés savantes — grades
          conservés, sources tracées, pensées pour être lues en quelques
          minutes au moment de la décision clinique.
        </p>
      </div>

      <div className="credit-strip">
        {lib.isEditor ? (
          <span>
            <b>Vue relecteur</b> : toutes les fiches sont lisibles, brouillons compris.
          </span>
        ) : lib.premium ? (
          <span>
            <b>PREMIUM</b> : toutes les fiches de votre spécialité sont ouvertes.
          </span>
        ) : (
          <>
            <span className="credit-dots" aria-hidden="true">
              {Array.from({ length: FREE_QUOTA }, (_, i) => (
                <span key={i} className={`credit-dot${i < used ? " is-used" : ""}`} />
              ))}
            </span>
            <span>
              <b>
                {remaining} crédit{remaining > 1 ? "s" : ""} restant{remaining > 1 ? "s" : ""}
              </b>{" "}
              sur {FREE_QUOTA}. Un crédit débloque une fiche, définitivement.
            </span>
          </>
        )}
      </div>

      <form className="lib-toolbar" role="search" style={{ marginTop: 22 }}>
        <label className="lib-search">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden="true">
            <circle cx="11" cy="11" r="7" />
            <path d="m20 20-3.5-3.5" />
          </svg>
          <span className="sr-only">Rechercher une fiche</span>
          <input name="q" type="search" defaultValue={query} placeholder="Rechercher une fiche…" />
        </label>
      </form>

      {docs.length === 0 ? (
        <div className="lib-empty">
          {query
            ? "Aucune fiche ne correspond à cette recherche."
            : "Aucune fiche n'est encore publiée. Les fiches seront disponibles ici au fil de leur validation."}
        </div>
      ) : (
        <div className="doc-grid">
          {docs.map((d) => {
            const state = docState(lib, d.id);
            const c = d.card_json;
            const date = formatDate(d.publication_date);
            return (
              <Link key={d.id} href={`/bibliotheque/${d.id}`} className="doc-card">
                <span className="doc-card__top">
                  <span className="doc-card__badge">{c?.badge ?? d.doc_type ?? "Recommandation"}</span>
                  <span className={`state-pill ${STATE_CLASS[state]}`}>{STATE_LABEL[state]}</span>
                </span>
                <h2>{cardTitle(d)}</h2>
                {c?.short ? <p>{c.short}</p> : null}
                <span className="doc-card__meta">
                  <span>{c?.society ?? [d.doc_type, date].filter(Boolean).join(" — ")}</span>
                  {c?.pages ? <span>{c.pages} pages</span> : null}
                </span>
              </Link>
            );
          })}
        </div>
      )}
    </Shell>
  );
}

function normalize(s: string) {
  return s
    .toLowerCase()
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "");
}
