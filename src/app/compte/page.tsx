import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import CompteForm from "./compte-form";

// Exercice des droits RGPD promis par la Politique de confidentialité :
// rectification, retrait du consentement partenaires, export, suppression.
export default async function ComptePage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    redirect("/connexion");
  }

  const [{ data: profile }, { data: consents }] = await Promise.all([
    supabase
      .from("profiles")
      .select(
        "nom, prenom, telephone, profession, profession_autre, username, consent_partners, specialty:specialties(name_i18n)",
      )
      .eq("id", user.id)
      .single(),
    supabase
      .from("consent_log")
      .select("consent_type, value, recorded_at")
      .order("recorded_at", { ascending: false }),
  ]);

  return (
    <div className="mx-auto min-h-screen max-w-2xl px-6 py-12">
      <p className="text-sm">
        <Link href="/" className="text-teal-700 underline">
          ← Retour aux fiches
        </Link>
      </p>
      <h1 className="mt-4 text-2xl font-semibold text-slate-900">Mon compte</h1>
      <p className="mt-2 text-sm text-slate-600">
        Adresse email : <strong>{user.email}</strong>
      </p>

      {profile ? (
        <CompteForm
          email={user.email ?? ""}
          profile={profile}
          consents={consents ?? []}
        />
      ) : (
        <p className="mt-8 text-sm text-red-600">
          Votre profil n&apos;a pas pu être chargé. Réessayez dans quelques
          instants.
        </p>
      )}
    </div>
  );
}
