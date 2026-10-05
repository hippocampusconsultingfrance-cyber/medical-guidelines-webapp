import { createAdminClient } from "@/lib/supabase/admin";

// Vérification hebdomadaire des liens « Document source officiel » (tâche
// planifiée, vercel.json). Chaque adresse est demandée une fois (sans le
// fragment #…) : réponse 2xx → « ok » ; 404 ou 410 → « rompu ». Toute autre
// réponse (403 anti-robot, 5xx, délai dépassé) ne change pas le statut, pour
// ne jamais signaler à tort une source qui n'est qu'indisponible un moment ;
// seule la date de vérification est mise à jour. Vercel appelle cette
// adresse avec « Authorization: Bearer CRON_SECRET ».
export const maxDuration = 300;

const DELAI_MS = 15_000;
const EN_PARALLELE = 8;

async function verifier(url: string): Promise<"ok" | "rompu" | null> {
  try {
    const reponse = await fetch(url, {
      redirect: "follow",
      signal: AbortSignal.timeout(DELAI_MS),
      headers: { "User-Agent": "medical-guidelines.net (verification des liens sources)" },
    });
    await reponse.body?.cancel();
    if (reponse.ok) return "ok";
    if (reponse.status === 404 || reponse.status === 410) return "rompu";
    return null;
  } catch {
    return null;
  }
}

export async function GET(request: Request) {
  const secret = process.env.CRON_SECRET;
  if (!secret || request.headers.get("authorization") !== `Bearer ${secret}`) {
    return Response.json({ error: "Non autorisé" }, { status: 401 });
  }
  const admin = createAdminClient();
  const { data, error } = await admin.from("documents").select("id, source_url").not("source_url", "is", null);
  if (error) {
    console.error("Vérification des liens", error);
    return Response.json({ error: "Lecture impossible" }, { status: 500 });
  }

  const parAdresse = new Map<string, string[]>();
  for (const d of data ?? []) {
    const url = String(d.source_url).split("#")[0];
    if (!/^https?:\/\//.test(url)) continue;
    parAdresse.set(url, [...(parAdresse.get(url) ?? []), d.id as string]);
  }

  const adresses = [...parAdresse.keys()];
  const resultats = new Map<string, "ok" | "rompu" | null>();
  for (let i = 0; i < adresses.length; i += EN_PARALLELE) {
    const lot = adresses.slice(i, i + EN_PARALLELE);
    const statuts = await Promise.all(lot.map(verifier));
    lot.forEach((url, j) => resultats.set(url, statuts[j]));
  }

  const maintenant = new Date().toISOString();
  const bilan = { ok: 0, rompu: 0, indetermine: 0 };
  for (const statut of ["ok", "rompu", null] as const) {
    const ids = adresses.filter((u) => resultats.get(u) === statut).flatMap((u) => parAdresse.get(u) ?? []);
    if (!ids.length) continue;
    const champs = statut ? { link_status: statut, link_last_checked_at: maintenant } : { link_last_checked_at: maintenant };
    const { error: e } = await admin.from("documents").update(champs).in("id", ids);
    if (e) console.error("Vérification des liens : mise à jour", e);
    bilan[statut ?? "indetermine"] += ids.length;
  }
  return Response.json({ adresses: adresses.length, fiches: bilan });
}
