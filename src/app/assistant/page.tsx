import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { ASSISTANT_QUOTA, assistantOuvertAuxMembres } from "@/lib/assistant";
import { createClient } from "@/lib/supabase/server";
import Formulaire from "./formulaire";

export const metadata: Metadata = {
  title: "Assistant de recherche — medical-guidelines.net",
};

// Assistant de recherche (bêta) : retrouve des passages exacts des fiches.
export default async function AssistantPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/connexion");
  const [{ data: equipe }, { data: premium }] = await Promise.all([
    supabase.rpc("has_editorial_role", { min_role: "relecteur" }),
    supabase.rpc("has_premium"),
  ]);
  const acces = Boolean(equipe) || (Boolean(premium) && assistantOuvertAuxMembres());

  return (
    <div className="mx-auto min-h-screen max-w-2xl px-6 py-12">
      <p className="text-sm">
        <Link href="/bibliotheque" className="text-[#1A74A6] underline">
          ← Retour aux fiches
        </Link>
      </p>
      <h1 className="mt-4 text-2xl font-semibold text-slate-900">
        Assistant de recherche <span className="text-sm font-normal text-slate-500">(bêta)</span>
      </h1>
      <p className="mt-2 text-sm text-slate-600">
        Posez une question en langage courant : l&apos;assistant retrouve dans vos fiches les passages exacts qui y
        répondent, avec le lien vers la fiche et la source officielle. Il ne rédige pas de réponse et ne donne aucun
        avis sur un patient : la décision relève de votre jugement clinique.
      </p>
      <p className="mt-2 text-xs text-slate-500">
        Outil d&apos;aide à la recherche utilisant une intelligence artificielle ; chaque extrait est revérifié mot pour
        mot dans la fiche. Ne saisissez aucune donnée permettant d&apos;identifier un patient. {ASSISTANT_QUOTA} questions
        par 24 heures ; vos questions ne sont pas conservées.
      </p>
      {acces ? (
        <>
          {Boolean(equipe) && !assistantOuvertAuxMembres() && (
            <p className="mt-4 rounded-lg bg-sky-50 p-3 text-sm text-sky-900">
              Phase de test : réservé à l&apos;équipe éditoriale tant qu&apos;ASSISTANT_PUBLIC n&apos;est pas activé.
            </p>
          )}
          <Formulaire />
        </>
      ) : (
        <p className="mt-6 rounded-lg bg-slate-50 p-4 text-sm text-slate-700">
          {assistantOuvertAuxMembres() ? (
            <>
              L&apos;assistant est réservé aux abonnés PREMIUM.{" "}
              <Link href="/abonnement" className="font-semibold text-[#1A74A6] underline">
                Découvrir l&apos;abonnement
              </Link>
            </>
          ) : (
            "L'assistant de recherche sera bientôt disponible pour les abonnés PREMIUM."
          )}
        </p>
      )}
    </div>
  );
}
