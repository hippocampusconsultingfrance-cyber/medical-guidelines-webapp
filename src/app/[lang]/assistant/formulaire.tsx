"use client";

import Link from "next/link";
import { useActionState } from "react";
import { poserQuestion, type EtatAssistant } from "./actions";

const INITIAL: EtatAssistant = { question: "", reponse: null };

export default function Formulaire() {
  const [etat, action, enCours] = useActionState(poserQuestion, INITIAL);
  const r = etat.reponse;
  return (
    <>
      <form action={action} className="mt-6 space-y-3">
        <label className="block text-sm text-slate-700">
          Votre question
          <textarea
            name="question"
            required
            minLength={5}
            maxLength={500}
            rows={3}
            defaultValue={etat.question}
            placeholder="Ex. : délai d'arrêt du rivaroxaban avant une chirurgie à haut risque hémorragique"
            className="mt-1 block w-full rounded-md border border-slate-300 px-3 py-2"
          />
        </label>
        <button disabled={enCours} className="w-full rounded-lg bg-[#0E3A78] px-4 py-3 text-sm font-semibold text-white shadow-sm disabled:opacity-50">
          {enCours ? "Recherche en cours…" : "Rechercher dans les fiches"}
        </button>
      </form>

      {r && (
        <section className="mt-8" aria-live="polite">
          {r.etat === "erreur" && <p className="rounded-lg bg-amber-50 p-3 text-sm text-amber-900">{r.message}</p>}
          {r.etat === "refus" && <p className="rounded-lg bg-amber-50 p-3 text-sm text-amber-900">{r.message}</p>}
          {r.etat === "vide" && (
            <p className="rounded-lg bg-slate-50 p-3 text-sm text-slate-700">
              Aucun passage des fiches ne répond précisément à cette question. Essayez d&apos;autres mots, ou utilisez la
              recherche de la bibliothèque.
            </p>
          )}
          {r.etat === "ok" && (
            <>
              <p className="text-sm text-slate-600">{r.introduction}</p>
              <ul className="mt-4 space-y-3">
                {r.extraits.map((e, i) => (
                  <li key={i} className="rounded-lg border border-slate-200 p-4">
                    <blockquote className="border-l-4 border-[#2BB5A6] pl-3 text-slate-800">« {e.citation} »</blockquote>
                    <p className="mt-2 text-xs text-slate-500">
                      <Link href={`/bibliotheque/${e.docId}`} className="font-semibold text-[#1A74A6] underline">
                        {e.titre}
                      </Link>{" "}
                      · {e.section}
                      {e.source && (
                        <>
                          {" · "}
                          <a href={e.source} target="_blank" rel="noopener noreferrer" className="underline">
                            source officielle ↗
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
