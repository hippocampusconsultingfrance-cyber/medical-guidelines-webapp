import { type NextRequest } from "next/server";
import { createClient } from "@/lib/supabase/server";

// Signalements d'erreurs envoyés depuis les fiches (public/fiches/index.html,
// via public/fiches/signalements-bridge.js). Les règles d'accès sont portées
// par la base (RLS sur error_reports) : chacun ne lit que ses propres
// signalements, les administrateurs lisent tout.

type ReportRow = {
  id: string;
  doc: string;
  doc_title: string | null;
  section: string | null;
  description: string;
  status: string;
  created_at: string;
  decided_at: string | null;
};

function toClient(row: ReportRow) {
  return {
    id: row.id,
    doc: row.doc,
    docTitle: row.doc_title,
    section: row.section,
    description: row.description,
    status: row.status,
    createdAt: row.created_at,
    decidedAt: row.decided_at,
  };
}

export async function GET() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return Response.json({ error: "Non connecté" }, { status: 401 });
  }

  const [{ data: rows, error }, { data: isAdmin }] = await Promise.all([
    supabase
      .from("error_reports")
      .select("id, doc, doc_title, section, description, status, created_at, decided_at")
      .order("created_at", { ascending: false })
      .limit(200),
    supabase.rpc("is_admin"),
  ]);
  if (error) {
    return Response.json({ error: "Lecture impossible" }, { status: 500 });
  }

  return Response.json({
    isAdmin: isAdmin === true,
    reports: (rows ?? []).map(toClient),
  });
}

export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return Response.json({ error: "Non connecté" }, { status: 401 });
  }

  const body = await request.json().catch(() => null);
  const doc = typeof body?.doc === "string" ? body.doc.trim() : "";
  const description =
    typeof body?.description === "string" ? body.description.trim() : "";
  if (!doc || !description) {
    return Response.json(
      { error: "La fiche et la description sont obligatoires." },
      { status: 400 },
    );
  }

  const { data, error } = await supabase
    .from("error_reports")
    .insert({
      user_id: user.id,
      doc: doc.slice(0, 200),
      doc_title: typeof body.docTitle === "string" ? body.docTitle.slice(0, 500) : null,
      section: typeof body.section === "string" ? body.section.slice(0, 500) : null,
      description: description.slice(0, 5000),
    })
    .select("id, doc, doc_title, section, description, status, created_at, decided_at")
    .single();
  if (error || !data) {
    return Response.json({ error: "Enregistrement impossible" }, { status: 500 });
  }

  return Response.json(toClient(data), { status: 201 });
}
