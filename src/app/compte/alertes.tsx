import Link from "next/link";
import type { SupabaseClient } from "@supabase/supabase-js";
import { setEmailAlerts, unfollowSociety } from "../actions";

const MESSAGES: Record<string, string> = {
  alertes_on: "Alertes e-mail activées.",
  alertes_off: "Alertes e-mail désactivées : vous ne recevrez plus aucun e-mail d'alerte.",
  alertes_erreur: "La modification n'a pas pu être enregistrée. Réessayez dans un instant.",
  suivi_retire: "Vous ne suivez plus cette société.",
  desinscrit: "Vous êtes désinscrit des alertes e-mail.",
};

// Alertes e-mail (cahier des charges §8 : « l'e-mail … est désactivable
// depuis Mon compte ») : interrupteur général et sociétés suivies. Section
// séparée du formulaire du profil : si la migration 20260929140000 n'est pas
// encore appliquée, seule cette section est masquée.
export default async function AlertesSection({
  supabase,
  userId,
  r,
}: {
  supabase: SupabaseClient;
  userId: string;
  r: string;
}) {
  const [{ data: prefs, error }, { data: follows }, { data: premium }, { data: role }] = await Promise.all([
    supabase.from("profiles").select("email_alerts").eq("id", userId).maybeSingle(),
    supabase
      .from("notification_preferences")
      .select("societies(acronym, full_name)")
      .eq("user_id", userId)
      .not("society_id", "is", null),
    supabase.rpc("has_premium"),
    supabase.from("profiles").select("editorial_role").eq("id", userId).maybeSingle(),
  ]);
  if (error || !prefs) return null;

  const on = Boolean((prefs as { email_alerts: boolean }).email_alerts);
  const eligible = Boolean(premium) || Boolean((role as { editorial_role: string | null } | null)?.editorial_role);
  type Society = { acronym: string; full_name: string | null };
  const societies = new Map<string, string | null>();
  for (const f of (follows ?? []) as { societies: Society | Society[] | null }[]) {
    for (const s of Array.isArray(f.societies) ? f.societies : f.societies ? [f.societies] : []) {
      societies.set(s.acronym, s.full_name);
    }
  }
  const message = MESSAGES[r];

  return (
    <section id="alertes" className="mt-8 scroll-mt-6 rounded-md border border-slate-200 p-4">
      <h2 className="text-lg font-semibold text-slate-900">Alertes e-mail</h2>
      {message && (
        <p role="status" className="mt-2 rounded-md bg-teal-50 px-3 py-2 text-sm text-teal-800">
          {message}
        </p>
      )}
      <p className="mt-1 text-sm text-slate-600">
        Un e-mail par jour au plus, quand une société que vous suivez publie une recommandation
        dans votre spécialité ou qu&apos;une fiche que vous avez débloquée, mise en favori ou
        consultée est mise à jour.
        {!eligible && (
          <>
            {" "}
            Les alertes sont incluses dans{" "}
            <Link href="/abonnement" className="text-teal-700 underline">
              l&apos;abonnement PREMIUM
            </Link>
            .
          </>
        )}
      </p>
      <form action={setEmailAlerts} className="mt-3 flex flex-wrap items-center gap-3">
        <input type="hidden" name="retour" value="/compte" />
        <input type="hidden" name="actif" value={on ? "0" : "1"} />
        <span className="text-sm text-slate-800">
          État : <strong>{on ? "activées" : "désactivées"}</strong>
        </span>
        <button className="rounded-md border border-slate-300 px-4 py-2 text-sm text-slate-800 hover:bg-slate-50">
          {on ? "Désactiver les alertes e-mail" : "Activer les alertes e-mail"}
        </button>
      </form>

      <h3 className="mt-5 text-sm font-semibold text-slate-800">Sociétés suivies</h3>
      {societies.size ? (
        <ul className="mt-2 space-y-2">
          {[...societies.entries()]
            .sort(([a], [b]) => a.localeCompare(b))
            .map(([acronym, name]) => (
              <li key={acronym} className="flex items-center justify-between gap-3 text-sm">
                <span>
                  <strong>{acronym}</strong>
                  {name ? <span className="text-slate-600"> — {name}</span> : null}
                </span>
                <form action={unfollowSociety}>
                  <input type="hidden" name="societe" value={acronym} />
                  <input type="hidden" name="retour" value="/compte" />
                  <button className="text-sm text-red-700 underline hover:text-red-900">Ne plus suivre</button>
                </form>
              </li>
            ))}
        </ul>
      ) : (
        <p className="mt-1 text-sm text-slate-600">
          Aucune.{" "}
          {eligible ? (
            <Link href="/#alertes" className="text-teal-700 underline">
              Choisir des sociétés depuis l&apos;accueil
            </Link>
          ) : null}
        </p>
      )}
    </section>
  );
}
