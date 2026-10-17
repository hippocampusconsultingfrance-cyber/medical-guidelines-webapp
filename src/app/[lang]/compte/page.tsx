import type { Metadata } from "next";
import Link from "next/link";
import { redirect } from "next/navigation";
import { textes } from "@/i18n/serveur";
import { nomProfession, nomSpecialite } from "@/i18n/specialites";
import { createClient } from "@/lib/supabase/server";
import AlertesSection from "./alertes";
import CompteForm from "./compte-form";
import { COMPTE } from "./textes";

export async function generateMetadata(): Promise<Metadata> {
  const { t } = await textes(COMPTE);
  return { title: t.titreMeta };
}

// Exercice des droits RGPD promis par la Politique de confidentialité :
// rectification, retrait du consentement partenaires, export, suppression ;
// et réglage des alertes e-mail.
export default async function ComptePage({ searchParams }: PageProps<"/[lang]/compte">) {
  const { t, langue, lien } = await textes(COMPTE);
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    redirect(lien("/connexion"));
  }

  const [{ data: profile }, { data: consents }] = await Promise.all([
    supabase
      .from("profiles")
      .select(
        "nom, prenom, telephone, profession, profession_autre, username, consent_partners, specialty:specialties(slug, name_i18n)",
      )
      .eq("id", user.id)
      .single(),
    supabase
      .from("consent_log")
      .select("consent_type, value, recorded_at")
      .order("recorded_at", { ascending: false }),
  ]);
  const { r } = await searchParams;
  type Specialite = { slug: string; name_i18n: { fr?: string } | null };
  const spec = profile?.specialty as Specialite | Specialite[] | null | undefined;
  const specialite = Array.isArray(spec) ? spec[0] : spec;
  const nomSpec = specialite?.name_i18n?.fr ? nomSpecialite(specialite.slug, specialite.name_i18n.fr, langue) : null;

  return (
    <div className="mx-auto max-w-2xl px-6 py-10">
      <h1 className="text-2xl font-bold text-[#0E3A78]">{t.titre}</h1>
      <p className="mt-2 text-sm text-slate-600">
        {t.email} <strong>{user.email}</strong>
      </p>

      <p className="mt-4 rounded-lg border border-slate-200 p-3 text-sm">
        🔒{" "}
        <Link href={lien("/compte/securite")} className="font-semibold text-[#1A74A6] underline">
          {t.doubleAuth}
        </Link>
        {t.doubleAuthTexte}
      </p>
      <p className="mt-3 rounded-lg border border-slate-200 p-3 text-sm">
        💡{" "}
        <Link href={lien("/suggestions?page=%2Fcompte")} className="font-semibold text-[#1A74A6] underline">
          {t.idee}
        </Link>
        {t.ideeTexte}
      </p>

      <AlertesSection supabase={supabase} userId={user.id} r={typeof r === "string" ? r : ""} />

      {profile ? (
        <CompteForm
          email={user.email ?? ""}
          profile={profile}
          profession={profile.profession ? nomProfession(profile.profession, langue) : ""}
          specialite={nomSpec}
          consents={consents ?? []}
          t={t.formulaire}
        />
      ) : (
        <p className="mt-8 text-sm text-red-600">{t.profilIndisponible}</p>
      )}
    </div>
  );
}
