"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

// Page de retour du lien de confirmation envoyé par email (template Supabase
// par défaut, non personnalisable sans SMTP tiers). Supabase vérifie le
// jeton côté serveur puis redirige ici avec la session dans le fragment
// d'URL (#access_token=...) ; le SDK client la détecte automatiquement à
// l'initialisation (detectSessionInUrl). On attend que la session soit
// posée (et donc les cookies écrits, lisibles par le middleware) avant de
// continuer vers la finalisation du compte.
export default function AuthCallbackPage() {
  const router = useRouter();
  const [error, setError] = useState(false);

  useEffect(() => {
    const supabase = createClient();
    let settled = false;

    const { data: listener } = supabase.auth.onAuthStateChange((event, session) => {
      if (settled) return;
      if (session) {
        settled = true;
        router.replace("/finaliser-compte");
      }
    });

    // Au cas où la session était déjà posée avant que le listener s'attache.
    supabase.auth.getSession().then(({ data }) => {
      if (!settled && data.session) {
        settled = true;
        router.replace("/finaliser-compte");
      }
    });

    const timeout = setTimeout(() => {
      if (!settled) {
        settled = true;
        setError(true);
      }
    }, 6000);

    return () => {
      listener.subscription.unsubscribe();
      clearTimeout(timeout);
    };
  }, [router]);

  if (error) {
    return (
      <div className="mx-auto flex min-h-screen max-w-md flex-col justify-center px-6 text-center">
        <p className="text-red-600">
          Ce lien de confirmation est invalide ou a expiré. Recommencez
          l&apos;inscription.
        </p>
      </div>
    );
  }

  return (
    <div className="mx-auto flex min-h-screen max-w-md flex-col justify-center px-6 text-center">
      <p className="text-slate-600">Validation de votre email en cours…</p>
    </div>
  );
}
