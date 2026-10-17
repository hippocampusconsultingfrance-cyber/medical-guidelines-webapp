"use client";

import { useEffect } from "react";
import Link from "next/link";
import { useLangue } from "@/i18n/client";
import { COMMUN } from "@/i18n/commun";
import { riche } from "@/i18n/format";
import { chemin } from "@/lib/langues";

// Erreur inattendue dans une page : message dans la langue de la page,
// nouvel essai, et remontée à Sentry (l'erreur interceptée ici n'atteint pas
// le navigateur).
export default function Erreur({ error, retry }: { error: Error & { digest?: string }; retry: () => void }) {
  const langue = useLangue();
  const t = COMMUN[langue].erreur;
  useEffect(() => {
    // Chargé seulement en cas d'erreur : rien de plus à télécharger sinon.
    import("@/lib/sentry-capture").then((m) => m.signalerErreur(error)).catch(() => {});
  }, [error]);

  return (
    <main className="mx-auto flex min-h-[70vh] max-w-xl flex-col items-center justify-center px-4 py-16 text-center">
      <p className="font-mono text-sm font-semibold uppercase tracking-wider text-[#177E73]">{t.surtitre}</p>
      <h1 className="mt-2 text-3xl font-bold text-[#0E3A78]">{t.titre}</h1>
      <p className="mt-4 text-slate-600">
        {riche(t.texte, {
          mail: (c) => (
            <a href={`mailto:${c}`} className="underline">
              {c}
            </a>
          ),
        })}
        {error.digest ? t.reference.replace("{ref}", error.digest) : ""}.
      </p>
      <div className="mt-8 flex flex-col gap-3 sm:flex-row">
        <button
          onClick={() => retry()}
          className="rounded-lg bg-[#0E3A78] px-6 py-3 font-semibold text-white hover:bg-[#0B2F63]"
        >
          {t.reessayer}
        </button>
        <Link
          href={chemin(langue, "/")}
          className="rounded-lg border border-slate-300 bg-white px-6 py-3 font-semibold text-slate-800 hover:bg-slate-50"
        >
          {t.accueil}
        </Link>
      </div>
    </main>
  );
}
