import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import AccueilPublic from "./accueil-public";
import { loadPublicFiches } from "./recommandations/data";
import EspaceMembre from "./espace-membre";
import { INDEXABLE, SITE_URL } from "@/lib/seo";

const TITRE = "medical-guidelines.net — Recommandations médicales et paramédicales en fiches";
const DESCRIPTION =
  "Les recommandations des sociétés savantes en fiches claires et sourcées, grades conservés, pour les médecins et les professionnels paramédicaux. 5 fiches gratuites.";

export const metadata: Metadata = {
  title: TITRE,
  description: DESCRIPTION,
  alternates: { canonical: SITE_URL },
  robots: { index: INDEXABLE, follow: INDEXABLE },
  openGraph: { title: TITRE, description: DESCRIPTION, url: SITE_URL, siteName: "medical-guidelines.net", locale: "fr_FR", type: "website" },
  twitter: { card: "summary_large_image" },
};

export default async function Home({ searchParams }: PageProps<"/">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    // Les plus récentes d'abord (ordre de loadPublicFiches).
    const recentes = await loadPublicFiches(supabase, undefined, 4);
    return <AccueilPublic recentes={recentes} />;
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select("prenom, profession, setup_completed")
    .eq("id", user.id)
    .single();

  if (profile && !profile.setup_completed) {
    redirect("/finaliser-compte");
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
