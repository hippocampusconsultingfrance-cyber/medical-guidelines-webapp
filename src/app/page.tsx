import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import AccueilPublic from "./accueil-public";
import EspaceMembre from "./espace-membre";

export const metadata: Metadata = {
  title: "medical-guidelines.net — Recommandations médicales et paramédicales en fiches",
  description:
    "Les recommandations des sociétés savantes en fiches claires et sourcées, grades conservés, pour les médecins et les professionnels paramédicaux. 5 fiches gratuites.",
};

export default async function Home({ searchParams }: PageProps<"/">) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return <AccueilPublic />;
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select("prenom, profession, setup_completed")
    .eq("id", user.id)
    .single();

  if (profile && !profile.setup_completed) {
    redirect("/finaliser-compte");
  }

  const { societe } = await searchParams;
  return (
    <EspaceMembre
      supabase={supabase}
      user={user}
      profile={profile}
      societe={typeof societe === "string" ? societe : ""}
    />
  );
}
