import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { CATEGORIES_SUGGESTION } from "@/lib/instructions";
import { createClient } from "@/lib/supabase/server";
import { envoyerSuggestion } from "./actions";

export const metadata: Metadata = {
  title: "Améliorer le site — medical-guidelines.net",
};

const MESSAGES: Record<string, [string, boolean]> = {
  merci: ["Merci ! Votre message a bien été envoyé : il sera lu et traité.", true],
  vide: ["Décrivez votre suggestion en quelques mots (5 caractères au moins).", false],
  invalide: ["Choisissez le type de message.", false],
  limite: ["Vous avez déjà envoyé 10 messages en 24 heures : merci de réessayer demain.", false],
  erreur: ["L'envoi n'a pas abouti. Réessayez dans un instant.", false],
};

const STATUT: Record<string, string> = { nouveau: "Reçu", traite: "Traité", rejete: "Non retenu" };

// Suggestions des membres : un problème sur le site, une idée, une remarque
// sur une fiche. Accessible à tout moment depuis le bouton « Une idée ? ».
export default async function SuggestionsPage({ searchParams }: PageProps<"/suggestions">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");

  const params = await searchParams;
  const page = typeof params.page === "string" && params.page.startsWith("/") ? params.page.slice(0, 300) : "";
  const r = typeof params.r === "string" ? MESSAGES[params.r] : undefined;
  const { data: miennes } = await supabase
    .from("site_suggestions")
    .select("id, categorie, message, status, created_at")
    .eq("user_id", user.id)
    .order("created_at", { ascending: false })
    .limit(10);

  return (
    <div className="mx-auto min-h-screen max-w-2xl px-6 py-12">
      <p className="text-sm">
        <Link href={page || "/bibliotheque"} className="text-[#1C7FB6] underline">
          ← Retour
        </Link>
      </p>
      <h1 className="mt-4 text-2xl font-semibold text-slate-900">Améliorer le site</h1>
      <p className="mt-2 text-sm text-slate-600">
        Un problème, une idée, une remarque ? Chaque message est lu par l&apos;équipe. Pour une erreur dans le
        contenu d&apos;une fiche, vous pouvez aussi utiliser « Signaler une erreur » en bas de la fiche.
      </p>
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
        <label className="block text-sm text-slate-700">
          Type de message
          <select name="categorie" required defaultValue="" className="mt-1 block w-full rounded-md border border-slate-300 px-3 py-2">
            <option value="" disabled>
              Choisir…
            </option>
            {Object.entries(CATEGORIES_SUGGESTION).map(([v, l]) => (
              <option key={v} value={v}>
                {l}
              </option>
            ))}
          </select>
        </label>
        <label className="block text-sm text-slate-700">
          Votre message
          <textarea
            name="message"
            required
            minLength={5}
            maxLength={3000}
            rows={6}
            placeholder="Décrivez ce que vous avez constaté ou ce que vous proposez…"
            className="mt-1 block w-full rounded-md border border-slate-300 px-3 py-2"
          />
        </label>
        {page && <p className="text-xs text-slate-500">Page concernée : {page}</p>}
        <p className="text-xs text-slate-500">
          N&apos;indiquez aucune donnée concernant un patient.
        </p>
        <button className="w-full rounded-lg bg-[#0E3A78] px-4 py-3 text-sm font-semibold text-white shadow-sm">Envoyer</button>
      </form>

      {miennes && miennes.length > 0 && (
        <section className="mt-10">
          <h2 className="text-lg font-semibold text-slate-900">Vos derniers messages</h2>
          <ul className="mt-3 space-y-2 text-sm">
            {miennes.map((m) => (
              <li key={m.id} className="rounded-lg border border-slate-200 p-3">
                <span className="text-xs text-slate-500">
                  {new Date(m.created_at).toLocaleDateString("fr-FR", { timeZone: "Europe/Paris" })} ·{" "}
                  {CATEGORIES_SUGGESTION[m.categorie] ?? m.categorie} · <b>{STATUT[m.status] ?? m.status}</b>
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
