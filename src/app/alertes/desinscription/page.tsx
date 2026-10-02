import type { Metadata } from "next";
import Link from "next/link";
import Logo from "../../logo";
import { confirmUnsubscribe } from "./actions";

export const metadata: Metadata = {
  title: "Désinscription des alertes — medical-guidelines.net",
};

// Lien de désinscription des e-mails d'alerte. La désinscription demande un
// clic de confirmation : les logiciels qui ouvrent les liens des e-mails
// (antivirus, aperçus) ne désinscrivent donc personne à son insu.
export default async function DesinscriptionPage({ searchParams }: PageProps<"/alertes/desinscription">) {
  const { t, r } = await searchParams;
  const token = typeof t === "string" ? t : "";

  return (
    <div className="mx-auto min-h-screen max-w-xl px-6 py-10">
      <Link href="/">
        <Logo />
      </Link>
      <h1 className="mt-10 text-2xl font-bold text-[#0E3A78]">Alertes e-mail</h1>
      {r === "ok" ? (
        <p role="status" className="mt-4 text-slate-700">
          C&apos;est fait : vous ne recevrez plus d&apos;e-mail d&apos;alerte. Vous pouvez les
          réactiver à tout moment depuis{" "}
          <Link href="/compte#alertes" className="text-[#1A74A6] underline">
            Mon compte
          </Link>
          .
        </p>
      ) : r === "erreur" || !token ? (
        <p role="alert" className="mt-4 text-slate-700">
          Ce lien de désinscription n&apos;est pas valide. Vous pouvez désactiver les alertes depuis{" "}
          <Link href="/compte#alertes" className="text-[#1A74A6] underline">
            Mon compte
          </Link>
          .
        </p>
      ) : (
        <form action={confirmUnsubscribe} className="mt-4">
          <p className="text-slate-700">
            Vous ne recevrez plus aucun e-mail d&apos;alerte (nouvelles recommandations des sociétés
            suivies, mises à jour de vos fiches). Votre compte et vos favoris sont conservés.
          </p>
          <input type="hidden" name="t" value={token} />
          <button className="mt-5 rounded-lg bg-[#0E3A78] px-5 py-2.5 font-semibold text-white hover:bg-[#0B2F63]">
            Me désinscrire des alertes e-mail
          </button>
        </form>
      )}
    </div>
  );
}
