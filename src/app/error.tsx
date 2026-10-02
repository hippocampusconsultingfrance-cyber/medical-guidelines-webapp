"use client";

import { useEffect } from "react";
import Link from "next/link";

// Erreur inattendue dans une page : message en français, nouvel essai, et
// remontée à Sentry (l'erreur interceptée ici n'atteint pas le navigateur).
export default function Erreur({ error, retry }: { error: Error & { digest?: string }; retry: () => void }) {
  useEffect(() => {
    // Chargé seulement en cas d'erreur : rien de plus à télécharger sinon.
    import("@/lib/sentry-capture").then((m) => m.signalerErreur(error)).catch(() => {});
  }, [error]);

  return (
    <main className="mx-auto flex min-h-[70vh] max-w-xl flex-col items-center justify-center px-4 py-16 text-center">
      <p className="font-mono text-sm font-semibold uppercase tracking-wider text-[#2BB5A6]">Erreur</p>
      <h1 className="mt-2 text-3xl font-bold text-[#0E3A78]">Un problème est survenu</h1>
      <p className="mt-4 text-slate-600">
        La page n&apos;a pas pu s&apos;afficher. Réessayez dans un instant ; si le problème continue, écrivez-nous à{" "}
        <a href="mailto:contact@medical-guidelines.net" className="underline">
          contact@medical-guidelines.net
        </a>
        {error.digest ? ` (référence ${error.digest})` : ""}.
      </p>
      <div className="mt-8 flex flex-col gap-3 sm:flex-row">
        <button
          onClick={() => retry()}
          className="rounded-lg bg-[#0E3A78] px-6 py-3 font-semibold text-white hover:bg-[#0B2F63]"
        >
          Réessayer
        </button>
        <Link
          href="/"
          className="rounded-lg border border-slate-300 bg-white px-6 py-3 font-semibold text-slate-800 hover:bg-slate-50"
        >
          Retour à l&apos;accueil
        </Link>
      </div>
    </main>
  );
}
