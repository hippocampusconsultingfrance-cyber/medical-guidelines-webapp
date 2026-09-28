import { type NextRequest } from "next/server";
import { createClient } from "@/lib/supabase/server";

const STATUSES = new Set(["nouveau", "valide", "rejete"]);

// Décision d'un administrateur sur un signalement. La base refuse la
// modification à tout utilisateur qui n'est pas administrateur (RLS).
export async function PATCH(
  request: NextRequest,
  ctx: RouteContext<"/api/signalements/[id]">,
) {
  const { id } = await ctx.params;
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return Response.json({ error: "Non connecté" }, { status: 401 });
  }

  const body = await request.json().catch(() => null);
  const status = body?.status;
  if (typeof status !== "string" || !STATUSES.has(status)) {
    return Response.json({ error: "Statut invalide" }, { status: 400 });
  }

  const { data, error } = await supabase
    .from("error_reports")
    .update({
      status,
      decided_at: new Date().toISOString(),
      decided_by: user.id,
    })
    .eq("id", id)
    .select("id")
    .maybeSingle();
  if (error) {
    return Response.json({ error: "Modification impossible" }, { status: 500 });
  }
  if (!data) {
    return Response.json({ error: "Accès refusé" }, { status: 403 });
  }

  return Response.json({ id: data.id, status });
}
