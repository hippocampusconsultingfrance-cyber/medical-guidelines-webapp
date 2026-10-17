"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import type { EmailOtpType } from "@supabase/supabase-js";
import { useLangue } from "@/i18n/client";
import { chemin, type Langue } from "@/lib/langues";
import { createClient } from "@/lib/supabase/client";
import type { TextesRetour } from "../../textes-auth";

// Page de retour des liens envoyés par email (inscription, mot de passe
// oublié). Trois formes de lien sont acceptées :
//
// 1. ?token_hash=...&type=... (modèles d'email recommandés) : le jeton n'est
//    consommé qu'au clic sur le bouton de cette page. Un lien ouvert deux fois,
//    ou pré-chargé par une messagerie, reste donc utilisable.
// 2. #access_token=...&refresh_token=... (flux implicite, lien par défaut de
//    Supabase qui passe par GoTrue /verify) : la session est dans le fragment.
// 3. ?code=... (flux PKCE).
//
// Un lien de réinitialisation (type=recovery) mène à /nouveau-mot-de-passe,
// un lien d'inscription à /finaliser-compte.

type Status = "loading" | "confirm" | "error";

function isRecovery(type: string | null) {
  return type === "recovery";
}

function destination(langue: Langue, type: string | null) {
  return chemin(langue, isRecovery(type) ? "/nouveau-mot-de-passe" : "/finaliser-compte");
}

export default function RetourLien({ t }: { t: TextesRetour }) {
  const router = useRouter();
  const langue = useLangue();
  const lien = (p: string) => chemin(langue, p);
  const [status, setStatus] = useState<Status>("loading");
  const [detail, setDetail] = useState<string | null>(null);
  const [linkType, setLinkType] = useState<string | null>(null);
  const [tokenHash, setTokenHash] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    let settled = false;

    async function run() {
      const supabase = createClient();
      const hashParams = new URLSearchParams(window.location.hash.slice(1));
      const queryParams = new URLSearchParams(window.location.search);
      const type = hashParams.get("type") || queryParams.get("type");
      setLinkType(type);

      const hash = queryParams.get("token_hash");
      if (hash) {
        setTokenHash(hash);
        setStatus("confirm");
        return;
      }

      const linkError =
        hashParams.get("error_description") || queryParams.get("error_description");
      if (linkError) {
        // Lien déjà utilisé : si la première ouverture a bien ouvert une
        // session, on continue simplement le parcours.
        const { data } = await supabase.auth.getSession();
        if (data.session && isRecovery(type)) {
          router.replace(destination(langue, type));
          return;
        }
        setDetail(decodeURIComponent(linkError.replace(/\+/g, " ")));
        setStatus("error");
        return;
      }

      const accessToken = hashParams.get("access_token");
      const refreshToken = hashParams.get("refresh_token");
      const code = queryParams.get("code");

      try {
        if (accessToken && refreshToken) {
          const { error } = await supabase.auth.setSession({
            access_token: accessToken,
            refresh_token: refreshToken,
          });
          if (error) throw error;
        } else if (code) {
          const { error } = await supabase.auth.exchangeCodeForSession(code);
          if (error) throw error;
        } else {
          const { data } = await supabase.auth.getSession();
          if (!data.session) {
            throw new Error(t.aucunJeton);
          }
        }
        if (!settled) {
          settled = true;
          router.replace(destination(langue, type));
        }
      } catch (err) {
        if (!settled) {
          settled = true;
          setDetail(err instanceof Error ? err.message : String(err));
          setStatus("error");
        }
      }
    }

    run();
  }, [router, langue, t.aucunJeton]);

  async function handleConfirm() {
    if (!tokenHash) return;
    setBusy(true);
    const supabase = createClient();
    const { error } = await supabase.auth.verifyOtp({
      token_hash: tokenHash,
      type: (linkType ?? "email") as EmailOtpType,
    });
    if (error) {
      // Lien déjà utilisé dans ce navigateur : la session ouverte la première
      // fois suffit pour continuer le parcours.
      const { data } = await supabase.auth.getSession();
      if (data.session) {
        router.replace(destination(langue, linkType));
        return;
      }
      setBusy(false);
      setDetail(error.message);
      setStatus("error");
      return;
    }
    router.replace(destination(langue, linkType));
  }

  if (status === "confirm") {
    const recovery = isRecovery(linkType);
    return (
      <div className="flex flex-col text-center">
        <h1 className="text-2xl font-bold text-[#0E3A78]">
          {recovery ? t.titreOublie : t.titreConfirmation}
        </h1>
        <p className="mt-4 text-slate-600">
          {recovery ? t.texteOublie : t.texteConfirmation}
        </p>
        <button
          type="button"
          onClick={handleConfirm}
          disabled={busy}
          className="mt-6 w-full rounded-lg bg-[#0E3A78] px-4 py-3 text-sm font-semibold text-white shadow-sm hover:bg-[#0B2F63] disabled:opacity-50"
        >
          {busy ? t.verification : recovery ? t.boutonOublie : t.boutonConfirmation}
        </button>
      </div>
    );
  }

  if (status === "error") {
    const recovery = isRecovery(linkType);
    return (
      <div className="flex flex-col text-center">
        <p className="text-red-600">
          {t.expire} {recovery ? t.expireOublie : t.expireInscription}
        </p>
        <div className="mt-6 flex flex-col gap-3 text-sm">
          {recovery ? (
            <Link href={lien("/mot-de-passe-oublie")} className="text-[#1A74A6] underline">
              {t.nouveauLien}
            </Link>
          ) : (
            <Link href={lien("/inscription")} className="text-[#1A74A6] underline">
              {t.recommencer}
            </Link>
          )}
          <Link href={lien("/connexion")} className="text-[#1A74A6] underline">
            {t.connexion}
          </Link>
        </div>
        {detail && (
          <p className="mt-6 break-words text-xs text-slate-400">{detail}</p>
        )}
      </div>
    );
  }

  return (
    <div className="flex flex-col text-center">
      <p className="text-slate-600">{t.enCours}</p>
    </div>
  );
}
