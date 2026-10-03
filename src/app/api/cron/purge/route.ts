import { createAdminClient } from "@/lib/supabase/admin";

// Durées de conservation de la politique de confidentialité (tâche planifiée
// quotidienne, vercel.json) : journal de lecture au-delà de 30 jours et
// comptes inactifs depuis 3 ans, supprimés par la base
// (purger_donnees_expirees, migration 20261003120000). Vercel appelle cette
// adresse avec « Authorization: Bearer CRON_SECRET » ; sans ce secret, rien
// n'est fait.
export async function GET(request: Request) {
  const secret = process.env.CRON_SECRET;
  if (!secret || request.headers.get("authorization") !== `Bearer ${secret}`) {
    return Response.json({ error: "Non autorisé" }, { status: 401 });
  }
  const { data, error } = await createAdminClient().rpc("purger_donnees_expirees");
  if (error) {
    console.error("Purge de conservation", error);
    return Response.json({ error: "Purge impossible" }, { status: 500 });
  }
  return Response.json(data);
}
