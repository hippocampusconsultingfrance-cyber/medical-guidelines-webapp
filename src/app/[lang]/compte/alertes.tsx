import Link from "next/link";
import type { SupabaseClient } from "@supabase/supabase-js";
import { riche } from "@/i18n/format";
import { textes } from "@/i18n/serveur";
import { setEmailAlerts, unfollowSociety } from "../actions";
import { COMPTE } from "./textes";

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
  const { t: tout, langue, lien } = await textes(COMPTE);
  const t = tout.alertes;
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
  const message = t.messages[r];

  return (
    <section id="alertes" className="mt-8 scroll-mt-6 rounded-md border border-slate-200 p-4">
      <h2 className="text-lg font-semibold text-slate-900">{t.titre}</h2>
      {message && (
        <p role="status" className="mt-2 rounded-md bg-[#EEF6FB] px-3 py-2 text-sm text-[#0E3A78]">
          {message}
        </p>
      )}
      <p className="mt-1 text-sm text-slate-600">
        {t.texte}
        {!eligible &&
          riche(t.premium, {
            abonnement: (c) => (
              <Link href={lien("/abonnement")} className="text-[#1A74A6] underline">
                {c}
              </Link>
            ),
          })}
      </p>
      <form action={setEmailAlerts} className="mt-3 flex flex-wrap items-center gap-3">
        <input type="hidden" name="retour" value="/compte" />
        <input type="hidden" name="langue" value={langue} />
        <input type="hidden" name="actif" value={on ? "0" : "1"} />
        <span className="text-sm text-slate-800">
          {t.etat} <strong>{on ? t.activees : t.desactivees}</strong>
        </span>
        <button className="rounded-md border border-slate-300 px-4 py-2 text-sm text-slate-800 hover:bg-slate-50">
          {on ? t.desactiver : t.activer}
        </button>
      </form>

      <h3 className="mt-5 text-sm font-semibold text-slate-800">{t.suivies}</h3>
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
                  <input type="hidden" name="langue" value={langue} />
                  <button className="text-sm text-red-700 underline hover:text-red-900">{t.nePlusSuivre}</button>
                </form>
              </li>
            ))}
        </ul>
      ) : (
        <p className="mt-1 text-sm text-slate-600">
          {t.aucune}{" "}
          {eligible ? (
            <Link href={lien("/#alertes")} className="text-[#1A74A6] underline">
              {t.choisir}
            </Link>
          ) : null}
        </p>
      )}
    </section>
  );
}
