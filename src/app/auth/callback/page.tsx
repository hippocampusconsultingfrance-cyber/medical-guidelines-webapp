"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import type { EmailOtpType } from "@supabase/supabase-js";
import { createClient } from "@/lib/supabase/client";

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

export default function AuthCallbackPage() {
  const router = useRouter();
  const [status, setStatus] = useState<Status>("loading");
  const [detail, setDetail] = useState<string | null>(null);
  const [linkType, setLinkType] = useState<string | null>(null);
  const [tokenHash, setTokenHash] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  function destination(type: string | null) {
    return isRecovery(type) ? "/nouveau-mot-de-passe" : "/finaliser-compte";
  }

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
          router.replace(destination(type));
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
            throw new Error(
              "Aucun jeton de session trouvé dans le lien (ni fragment, ni code).",
            );
          }
        }
        if (!settled) {
          settled = true;
          router.replace(destination(type));
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
  }, [router]);

  async function handleConfirm() {
    if (!tokenHash) return;
    setBusy(true);
    const supabase = createClient();
    const { error } = await supabase.auth.verifyOtp({
      token_hash: tokenHash,
      type: (linkType ?? "email") as EmailOtpType,
    });
    if (error) {
      setBusy(false);
      setDetail(error.message);
      setStatus("error");
      return;
    }
    router.replace(destination(linkType));
  }

  if (status === "confirm") {
    const recovery = isRecovery(linkType);
    return (
      <div className="mx-auto flex min-h-screen max-w-md flex-col justify-center px-6 text-center">
        <h1 className="text-2xl font-semibold text-slate-900">
          {recovery ? "Mot de passe oublié" : "Confirmation de votre email"}
        </h1>
        <p className="mt-4 text-slate-600">
          {recovery
            ? "Cliquez sur le bouton pour choisir un nouveau mot de passe."
            : "Cliquez sur le bouton pour confirmer votre adresse email."}
        </p>
        <button
          type="button"
          onClick={handleConfirm}
          disabled={busy}
          className="mt-6 w-full rounded-md bg-teal-700 px-4 py-2.5 text-sm font-medium text-white hover:bg-teal-800 disabled:opacity-50"
        >
          {busy
            ? "Vérification…"
            : recovery
              ? "Choisir un nouveau mot de passe"
              : "Confirmer mon adresse email"}
        </button>
      </div>
    );
  }

  if (status === "error") {
    const recovery = isRecovery(linkType);
    return (
      <div className="mx-auto flex min-h-screen max-w-md flex-col justify-center px-6 text-center">
        <p className="text-red-600">
          Ce lien a déjà été utilisé ou a expiré.{" "}
          {recovery
            ? "Faites une nouvelle demande de réinitialisation."
            : "Connectez-vous, ou recommencez l'inscription."}
        </p>
        <div className="mt-6 flex flex-col gap-3 text-sm">
          {recovery ? (
            <Link href="/mot-de-passe-oublie" className="text-teal-700 underline">
              Recevoir un nouveau lien
            </Link>
          ) : (
            <Link href="/inscription" className="text-teal-700 underline">
              Recommencer l&apos;inscription
            </Link>
          )}
          <Link href="/connexion" className="text-teal-700 underline">
            Aller à la connexion
          </Link>
        </div>
        {detail && (
          <p className="mt-6 break-words text-xs text-slate-400">{detail}</p>
        )}
      </div>
    );
  }

  return (
    <div className="mx-auto flex min-h-screen max-w-md flex-col justify-center px-6 text-center">
      <p className="text-slate-600">Validation du lien en cours…</p>
    </div>
  );
}
