import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import LogoutButton from "./logout-button";
import AccueilPublic from "./accueil-public";
import Logo from "./logo";

export const metadata: Metadata = {
  title: "medical-guidelines.net — Recommandations médicales et paramédicales en fiches",
  description:
    "Les recommandations des sociétés savantes en fiches claires et sourcées, grades conservés, pour les médecins et les professionnels paramédicaux. 5 fiches gratuites.",
};

export default async function Home() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return <AccueilPublic />;
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select("nom, prenom, profession, setup_completed, editorial_role")
    .eq("id", user.id)
    .single();

  if (profile && !profile.setup_completed) {
    redirect("/finaliser-compte");
  }

  // Bascule automatique : dès qu'au moins une fiche est publiée pour la
  // spécialité du membre, la nouvelle bibliothèque devient l'accès principal
  // (les relecteurs y voient aussi les brouillons).
  const { count: visibles } = await supabase
    .from("documents")
    .select("id", { count: "exact", head: true });
  const bibliotheque = Boolean(profile?.editorial_role) || (visibles ?? 0) > 0;

  return (
    <div className="mx-auto min-h-screen max-w-3xl px-6 py-10">
      <div className="flex items-center justify-between gap-3">
        <Logo />
        <div className="flex items-center gap-3">
          <Link
            href="/compte"
            className="text-sm text-slate-700 underline hover:text-slate-900"
          >
            Mon compte
          </Link>
          <LogoutButton />
        </div>
      </div>
      <h1 className="mt-10 text-2xl font-bold text-[#0E3A78]">
        Bienvenue{profile?.prenom ? `, ${profile.prenom}` : ""}
      </h1>
      {profile?.profession && <p className="mt-1 text-slate-600">{profile.profession}</p>}
      {bibliotheque ? (
        <Link
          href="/bibliotheque"
          className="mt-8 inline-block rounded-lg bg-[#0E3A78] px-6 py-3 font-semibold text-white hover:bg-[#0B2F63]"
        >
          Accéder à la bibliothèque des fiches →
        </Link>
      ) : (
        <a
          href="/fiches/index.html"
          className="mt-8 inline-block rounded-lg bg-[#0E3A78] px-6 py-3 font-semibold text-white hover:bg-[#0B2F63]"
        >
          Accéder aux fiches de synthèse →
        </a>
      )}
      {profile?.editorial_role && (
        <p className="mt-4 text-sm text-slate-600">
          Compte relecteur : la bibliothèque affiche aussi les brouillons, avec
          le bouton de publication.{" "}
          <a href="/fiches/index.html" className="text-[#1C7FB6] underline">
            Ancienne page des fiches
          </a>
        </p>
      )}
    </div>
  );
}
