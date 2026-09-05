import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import LogoutButton from "./logout-button";

export default async function Home() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect("/connexion");
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select("nom, prenom, profession, setup_completed")
    .eq("id", user.id)
    .single();

  if (profile && !profile.setup_completed) {
    redirect("/finaliser-compte");
  }

  return (
    <div className="mx-auto min-h-screen max-w-3xl px-6 py-16">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold text-slate-900">
          Medical Guidelines
        </h1>
        <LogoutButton />
      </div>
      <p className="mt-4 text-slate-600">
        Bienvenue{profile ? `, ${profile.prenom}` : ""}
        {profile?.profession ? ` (${profile.profession})` : ""}.
      </p>
      <p className="mt-2 text-sm text-slate-500">
        Les fiches de synthèse seront bientôt disponibles ici.
      </p>
    </div>
  );
}
