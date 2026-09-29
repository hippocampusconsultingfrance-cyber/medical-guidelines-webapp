import { unsubscribeByToken } from "@/lib/desinscription";

// Désinscription « en un clic » demandée par la messagerie du membre
// (en-têtes List-Unsubscribe et List-Unsubscribe-Post des e-mails d'alerte).
export async function POST(request: Request) {
  const token = new URL(request.url).searchParams.get("t") ?? "";
  const ok = await unsubscribeByToken(token);
  return Response.json({ desinscrit: ok }, { status: ok ? 200 : 400 });
}
