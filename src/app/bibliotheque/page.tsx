import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { formatDate, FREE_QUOTA } from "@/lib/fiches";

export const metadata: Metadata = {
  title: "Bibliothèque — Medical Guidelines",
};

// Catalogue des fiches de la spécialité du compte, de la plus récente à la
// plus ancienne. Les droits (spécialité, publication) sont appliqués par la
// base : un compte ne reçoit que les fiches qu'il a le droit de voir.
export default async function BibliothequePage({
  searchParams,
}: PageProps<"/bibliotheque">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");

  const q = (await searchParams).q;
  const query = typeof q === "string" ? q.trim().slice(0, 100) : "";

  let docs = supabase
    .from("documents")
    .select("id, title, doc_type, publication_date")
    .order("publication_date", { ascending: false, nullsFirst: false })
    .order("title");
  if (query) docs = docs.ilike("title", `%${query.replace(/[%_\\]/g, "")}%`);

  const [{ data: documents }, { data: unlocks }, { data: premium }, { data: profile }] =
    await Promise.all([
      docs,
      supabase.from("document_unlocks").select("document_id"),
      supabase.rpc("has_premium"),
      supabase.from("profiles").select("editorial_role").eq("id", user.id).single(),
    ]);

  const unlocked = new Set((unlocks ?? []).map((u) => u.document_id));
  const isEditor = Boolean(profile?.editorial_role);

  // Pour un relecteur, repérer les fiches encore en brouillon.
  let published = new Set<string>();
  if (isEditor) {
    const { data: active } = await supabase
      .from("recommendations")
      .select("document_id")
      .eq("status", "active");
    published = new Set((active ?? []).map((r) => r.document_id));
  }

  return (
    <div className="mx-auto max-w-3xl px-6 py-12">
      <p className="text-sm">
        <Link href="/" className="text-teal-700 underline">
          ← Accueil
        </Link>
      </p>
      <h1 className="mt-4 text-2xl font-semibold text-slate-900">Bibliothèque</h1>

      <p className="mt-2 text-sm text-slate-600">
        {premium
          ? "Abonnement PREMIUM : toutes les fiches de votre spécialité sont accessibles."
          : `Compte gratuit : ${unlocked.size}/${FREE_QUOTA} fiches débloquées.`}
        {isEditor && " Vue relecteur : les brouillons sont affichés."}
      </p>

      <form className="mt-6 flex gap-2" role="search">
        <label htmlFor="q" className="sr-only">
          Rechercher une fiche
        </label>
        <input
          id="q"
          name="q"
          type="search"
          defaultValue={query}
          placeholder="Rechercher par titre…"
          className="w-full rounded-md border border-slate-300 px-3 py-2 text-sm"
        />
        <button className="rounded-md bg-teal-700 px-4 py-2 text-sm font-medium text-white hover:bg-teal-800">
          Rechercher
        </button>
      </form>

      {!documents?.length ? (
        <p className="mt-8 text-sm text-slate-600">
          {query
            ? "Aucune fiche ne correspond à cette recherche."
            : "Aucune fiche n'est encore publiée. Les fiches seront disponibles ici au fil de leur validation."}
        </p>
      ) : (
        <ul className="mt-6 divide-y divide-slate-200 border-y border-slate-200">
          {documents.map((d) => (
            <li key={d.id}>
              <Link
                href={`/bibliotheque/${d.id}`}
                className="flex items-start justify-between gap-4 py-3 hover:bg-slate-50"
              >
                <span>
                  <span className="block text-sm font-medium text-slate-900">
                    {d.title}
                  </span>
                  <span className="block text-xs text-slate-500">
                    {[d.doc_type, formatDate(d.publication_date)].filter(Boolean).join(" · ")}
                  </span>
                </span>
                <span className="shrink-0 text-xs">
                  {isEditor && !published.has(d.id) ? (
                    <span className="rounded bg-amber-100 px-2 py-0.5 text-amber-800">
                      Brouillon
                    </span>
                  ) : unlocked.has(d.id) ? (
                    <span className="rounded bg-teal-50 px-2 py-0.5 text-teal-800">
                      Débloquée
                    </span>
                  ) : null}
                </span>
              </Link>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
