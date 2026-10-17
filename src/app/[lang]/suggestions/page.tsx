import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { fmt } from "@/i18n/format";
import { textes } from "@/i18n/serveur";
import { createClient } from "@/lib/supabase/server";
import { envoyerSuggestion } from "./actions";
import { SUGGESTIONS } from "./textes";

export async function generateMetadata(): Promise<Metadata> {
  const { t } = await textes(SUGGESTIONS);
  return { title: t.titreMeta };
}

// Suggestions des membres : un problème sur le site, une idée, une remarque
// sur une fiche. Accessible à tout moment depuis le bouton « Une idée ? ».
export default async function SuggestionsPage({ searchParams }: PageProps<"/[lang]/suggestions">) {
  const { t, langue, lien, locale } = await textes(SUGGESTIONS);
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect(lien("/connexion"));

  const params = await searchParams;
  const page = typeof params.page === "string" && params.page.startsWith("/") ? params.page.slice(0, 300) : "";
  const r =
    typeof params.r === "string" && params.r in t.messages ? ([t.messages[params.r], params.r === "merci"] as const) : undefined;
  const { data: miennes } = await supabase
    .from("site_suggestions")
    .select("id, categorie, message, status, created_at")
    .eq("user_id", user.id)
    .order("created_at", { ascending: false })
    .limit(10);

  return (
    <div className="mx-auto min-h-screen max-w-2xl px-6 py-12">
      <p className="text-sm">
        <Link href={page || lien("/bibliotheque")} className="text-[#1A74A6] underline">
          {t.retour}
        </Link>
      </p>
      <h1 className="mt-4 text-2xl font-semibold text-slate-900">{t.titre}</h1>
      <p className="mt-2 text-sm text-slate-600">{t.intro}</p>
      {r && (
        <p
          role="status"
          className={`mt-4 rounded-lg p-3 text-sm ${r[1] ? "bg-emerald-50 text-emerald-900" : "bg-amber-50 text-amber-900"}`}
        >
          {r[0]}
        </p>
      )}
      <form action={envoyerSuggestion} className="mt-6 space-y-4">
        <input type="hidden" name="page" value={page} />
        <input type="hidden" name="langue" value={langue} />
        <label className="block text-sm text-slate-700">
          {t.type}
          <select name="categorie" required defaultValue="" className="mt-1 block w-full rounded-md border border-slate-300 px-3 py-2">
            <option value="" disabled>
              {t.choisir}
            </option>
            {Object.entries(t.categories).map(([v, l]) => (
              <option key={v} value={v}>
                {l}
              </option>
            ))}
          </select>
        </label>
        <label className="block text-sm text-slate-700">
          {t.message}
          <textarea
            name="message"
            required
            minLength={5}
            maxLength={3000}
            rows={6}
            placeholder={t.placeholder}
            className="mt-1 block w-full rounded-md border border-slate-300 px-3 py-2"
          />
        </label>
        {page && <p className="text-xs text-slate-500">{fmt(t.page, { page })}</p>}
        <p className="text-xs text-slate-500">{t.patient}</p>
        <button className="w-full rounded-lg bg-[#0E3A78] px-4 py-3 text-sm font-semibold text-white shadow-sm">{t.envoyer}</button>
      </form>

      {miennes && miennes.length > 0 && (
        <section className="mt-10">
          <h2 className="text-lg font-semibold text-slate-900">{t.derniers}</h2>
          <ul className="mt-3 space-y-2 text-sm">
            {miennes.map((m) => (
              <li key={m.id} className="rounded-lg border border-slate-200 p-3">
                <span className="text-xs text-slate-500">
                  {new Date(m.created_at).toLocaleDateString(locale, { timeZone: "Europe/Paris" })} ·{" "}
                  {t.categories[m.categorie] ?? m.categorie} · <b>{t.statuts[m.status] ?? m.status}</b>
                </span>
                <p className="mt-1 text-slate-700">{m.message}</p>
              </li>
            ))}
          </ul>
        </section>
      )}
    </div>
  );
}
