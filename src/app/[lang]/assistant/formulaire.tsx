"use client";

import Link from "next/link";
import { useActionState } from "react";
import { useLien } from "@/i18n/client";
import { fmt, plur } from "@/i18n/format";
import { poserQuestion, type EtatAssistant } from "./actions";
import type { TextesFormulaireAssistant } from "./textes";

const INITIAL: EtatAssistant = { question: "", reponse: null };

// Messages et introduction rédigés par le site, dans la langue de la page.
export default function Formulaire({ t, quota, locale }: { t: TextesFormulaireAssistant; quota: number; locale: string }) {
  const [etat, action, enCours] = useActionState(poserQuestion, INITIAL);
  const lien = useLien();
  const r = etat.reponse;
  const titres = r?.etat === "ok" ? [...new Set(r.extraits.map((e) => e.titre))] : [];
  return (
    <>
      <form action={action} className="mt-6 space-y-3">
        <label className="block text-sm text-slate-700">
          {t.question}
          <textarea
            name="question"
            required
            minLength={5}
            maxLength={500}
            rows={3}
            defaultValue={etat.question}
            placeholder={t.placeholder}
            className="mt-1 block w-full rounded-md border border-slate-300 px-3 py-2"
          />
        </label>
        <button disabled={enCours} className="w-full rounded-lg bg-[#0E3A78] px-4 py-3 text-sm font-semibold text-white shadow-sm disabled:opacity-50">
          {enCours ? t.enCours : t.rechercher}
        </button>
      </form>

      {r && (
        <section className="mt-8" aria-live="polite">
          {r.etat === "erreur" && (
            <p className="rounded-lg bg-amber-50 p-3 text-sm text-amber-900">{fmt(t.erreurs[r.code] ?? r.code, { quota })}</p>
          )}
          {r.etat === "refus" && <p className="rounded-lg bg-amber-50 p-3 text-sm text-amber-900">{t.refus[r.motif]}</p>}
          {r.etat === "identifiantes" && (
            <p className="rounded-lg bg-amber-50 p-3 text-sm text-amber-900">
              {fmt(t.identifiantes, { donnees: r.donnees.map((d) => t.donnees[d] ?? d).join(", ") })}
            </p>
          )}
          {r.etat === "vide" && <p className="rounded-lg bg-slate-50 p-3 text-sm text-slate-700">{t.vide}</p>}
          {r.etat === "ok" && (
            <>
              <p className="text-sm text-slate-600">
                {plur(locale, r.extraits.length, t.introduction, {
                  fiches: titres.length > 1 ? fmt(t.fiches, { n: titres.length }) : t.laFiche,
                  titres: titres.map((titre) => fmt(t.titre, { titre })).join(", "),
                })}
              </p>
              <ul className="mt-4 space-y-3">
                {r.extraits.map((e, i) => (
                  <li key={i} className="rounded-lg border border-slate-200 p-4">
                    <blockquote className="border-s-4 border-[#2BB5A6] ps-3 text-slate-800">« {e.citation} »</blockquote>
                    <p className="mt-2 text-xs text-slate-500">
                      <Link href={lien(`/bibliotheque/${e.docId}`)} className="font-semibold text-[#1A74A6] underline">
                        {e.titre}
                      </Link>{" "}
                      · {e.section}
                      {e.source && (
                        <>
                          {" · "}
                          <a href={e.source} target="_blank" rel="noopener noreferrer" className="underline">
                            {t.sourceOfficielle}
                          </a>
                        </>
                      )}
                    </p>
                  </li>
                ))}
              </ul>
            </>
          )}
        </section>
      )}
    </>
  );
}
