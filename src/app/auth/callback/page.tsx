"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

// Page de retour du lien de confirmation envoyé par email. Supabase vérifie
// le jeton côté serveur (GoTrue /verify) puis redirige ici soit avec la
// session dans le fragment d'URL (#access_token=...&refresh_token=...,
// flux implicite), soit avec un ?code=... (flux PKCE). On traite les deux
// cas explicitement au lieu de compter sur la seule détection automatique
// du SDK, et on affiche le détail technique en cas d'échec pour pouvoir
// diagnostiquer sans deviner.
export default function AuthCallbackPage() {
  const router = useRouter();
  const [status, setStatus] = useState<"loading" | "error">("loading");
  const [detail, setDetail] = useState<string | null>(null);

  useEffect(() => {
    let settled = false;

    async function run() {
      const supabase = createClient();
      const hashParams = new URLSearchParams(window.location.hash.slice(1));
      const queryParams = new URLSearchParams(window.location.search);

      const oauthError =
        hashParams.get("error_description") || queryParams.get("error_description");
      if (oauthError) {
        setDetail(decodeURIComponent(oauthError.replace(/\+/g, " ")));
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
          router.replace("/finaliser-compte");
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

  if (status === "error") {
    return (
      <div className="mx-auto flex min-h-screen max-w-md flex-col justify-center px-6 text-center">
        <p className="text-red-600">
          Ce lien de confirmation est invalide ou a expiré. Recommencez
          l&apos;inscription.
        </p>
        {detail && (
          <p className="mt-4 break-words text-xs text-slate-400">{detail}</p>
        )}
      </div>
    );
  }

  return (
    <div className="mx-auto flex min-h-screen max-w-md flex-col justify-center px-6 text-center">
      <p className="text-slate-600">Validation de votre email en cours…</p>
    </div>
  );
}
