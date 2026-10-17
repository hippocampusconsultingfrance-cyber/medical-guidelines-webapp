import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { textes } from "@/i18n/serveur";
import { createClient } from "@/lib/supabase/server";
import AccueilPublic from "../accueil-public";
import { loadPublicFiches } from "../recommandations/data";
import EspaceMembre from "../espace-membre";
import { ESPACE } from "../textes-espace";

export async function generateMetadata(): Promise<Metadata> {
  const { t } = await textes(ESPACE);
  return { title: t.titreMeta, robots: { index: false, follow: false } };
}

// Accueil d'un membre connecté. Le proxy (src/proxy.ts) sert cette page à
// l'adresse « / » quand le navigateur a un cookie de session ; l'accueil
// public (src/app/page.tsx) reste ainsi en cache pour tous les visiteurs.
// Session expirée ou invalide : version publique, rendue ici à la volée.
export default async function Espace({ searchParams }: PageProps<"/[lang]/espace">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) return <AccueilPublic recentes={await loadPublicFiches(undefined, 4)} />;

  const { data: profile } = await supabase
    .from("profiles")
    .select("prenom, profession, setup_completed")
    .eq("id", user.id)
    .single();

  if (profile && !profile.setup_completed) {
    redirect((await textes(ESPACE)).lien("/finaliser-compte"));
  }

  const { societe, r } = await searchParams;
  return (
    <EspaceMembre
      supabase={supabase}
      user={user}
      profile={profile}
      societe={typeof societe === "string" ? societe : ""}
      r={typeof r === "string" ? r : ""}
    />
  );
}
