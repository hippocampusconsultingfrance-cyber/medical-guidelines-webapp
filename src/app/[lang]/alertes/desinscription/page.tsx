import type { Metadata } from "next";
import Link from "next/link";
import { riche } from "@/i18n/format";
import { textes } from "@/i18n/serveur";
import Logo from "../../logo";
import { confirmUnsubscribe } from "./actions";
import { DESINSCRIPTION } from "./textes";

export async function generateMetadata(): Promise<Metadata> {
  const { t } = await textes(DESINSCRIPTION);
  return { title: t.titreMeta };
}

// Lien de désinscription des e-mails d'alerte. La désinscription demande un
// clic de confirmation : les logiciels qui ouvrent les liens des e-mails
// (antivirus, aperçus) ne désinscrivent donc personne à son insu.
export default async function DesinscriptionPage({ searchParams }: PageProps<"/[lang]/alertes/desinscription">) {
  const { t: jeton, r } = await searchParams;
  const { t, langue, lien } = await textes(DESINSCRIPTION);
  const token = typeof jeton === "string" ? jeton : "";
  const compte = (c: string) => (
    <Link href={lien("/compte#alertes")} className="text-[#1A74A6] underline">
      {c}
    </Link>
  );

  return (
    <div className="mx-auto min-h-screen max-w-xl px-6 py-10">
      <Link href={lien("/")}>
        <Logo />
      </Link>
      <h1 className="mt-10 text-2xl font-bold text-[#0E3A78]">{t.titre}</h1>
      {r === "ok" ? (
        <p role="status" className="mt-4 text-slate-700">
          {riche(t.fait, { compte })}
        </p>
      ) : r === "erreur" || !token ? (
        <p role="alert" className="mt-4 text-slate-700">
          {riche(t.invalide, { compte })}
        </p>
      ) : (
        <form action={confirmUnsubscribe} className="mt-4">
          <p className="text-slate-700">{t.texte}</p>
          <input type="hidden" name="t" value={token} />
          <input type="hidden" name="langue" value={langue} />
          <button className="mt-5 rounded-lg bg-[#0E3A78] px-5 py-2.5 font-semibold text-white hover:bg-[#0B2F63]">
            {t.bouton}
          </button>
        </form>
      )}
    </div>
  );
}
