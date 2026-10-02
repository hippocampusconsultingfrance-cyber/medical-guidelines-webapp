// Données structurées schema.org (JSON-LD) pour les moteurs de recherche.
// « < » est échappé : le contenu ne peut pas refermer la balise script.
export default function DonneesStructurees({ data }: { data: object }) {
  return (
    <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(data).replace(/</g, "\\u003c") }} />
  );
}
