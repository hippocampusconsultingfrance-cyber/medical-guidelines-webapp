import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { fmt } from "@/i18n/format";
import { textes } from "@/i18n/serveur";
import { ASSISTANT_QUOTA, assistantOuvertAuxMembres } from "@/lib/assistant";
import { createClient } from "@/lib/supabase/server";
import Formulaire from "./formulaire";
import { ASSISTANT } from "./textes";

export async function generateMetadata(): Promise<Metadata> {
  const { t } = await textes(ASSISTANT);
  return { title: t.titreMeta };
}

// Assistant de recherche (bêta) : retrouve des passages exacts des fiches.
export default async function AssistantPage() {
  const { t, lien, locale } = await textes(ASSISTANT);
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect(lien("/connexion"));
  const [{ data: equipe }, { data: premium }] = await Promise.all([
    supabase.rpc("has_editorial_role", { min_role: "relecteur" }),
    supabase.rpc("has_premium"),
  ]);
  const acces = Boolean(equipe) || (Boolean(premium) && assistantOuvertAuxMembres());

  return (
    <div className="mx-auto min-h-screen max-w-2xl px-6 py-12">
      <p className="text-sm">
        <Link href={lien("/bibliotheque")} className="text-[#1A74A6] underline">
          {t.retour}
        </Link>
      </p>
      <h1 className="mt-4 text-2xl font-semibold text-slate-900">
        {t.titre} <span className="text-sm font-normal text-slate-500">{t.beta}</span>
      </h1>
      <div role="note" className="mt-4 rounded-lg border border-amber-300 bg-amber-50 p-4 text-sm text-amber-950">
        <p className="font-semibold">{t.iaTitre}</p>
        <ul className="mt-2 list-disc space-y-1 ps-5">
          {t.ia.map((x) => (
            <li key={x}>{x}</li>
          ))}
        </ul>
      </div>
      <p className="mt-4 text-sm text-slate-600">{t.intro}</p>
      {t.enFrancais && <p className="mt-2 text-sm font-medium text-slate-700">{t.enFrancais}</p>}
      <p className="mt-2 text-xs text-slate-500">{fmt(t.details, { quota: ASSISTANT_QUOTA })}</p>
      {acces ? (
        <>
          {Boolean(equipe) && !assistantOuvertAuxMembres() && (
            <p className="mt-4 rounded-lg bg-sky-50 p-3 text-sm text-sky-900">
              {t.phaseTest}
            </p>
          )}
          <Formulaire t={t.formulaire} quota={ASSISTANT_QUOTA} locale={locale} />
        </>
      ) : (
        <p className="mt-6 rounded-lg bg-slate-50 p-4 text-sm text-slate-700">
          {assistantOuvertAuxMembres() ? (
            <>
              {t.reservePremium}{" "}
              <Link href={lien("/abonnement")} className="font-semibold text-[#1A74A6] underline">
                {t.decouvrir}
              </Link>
            </>
          ) : (
            t.bientot
          )}
        </p>
      )}
    </div>
  );
}
