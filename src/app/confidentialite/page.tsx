export default function ConfidentialitePage() {
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-semibold text-slate-900">
        Politique de Confidentialité
      </h1>
      <p className="mt-2 text-slate-500">
        Dernière mise à jour : 2026. Conforme au Règlement Général sur la
        Protection des Données (RGPD).
      </p>

      <div className="mt-6 rounded-md border-l-4 border-teal-600 bg-teal-50 p-4">
        <p className="font-medium text-slate-900">En résumé</p>
        <ul className="mt-2 list-disc space-y-1 pl-5">
          <li>
            Nous collectons votre nom, prénom, téléphone, email et profession
            pour créer et sécuriser votre compte.
          </li>
          <li>
            Ces données ne sont <strong>jamais</strong> partagées avec des
            partenaires commerciaux, sauf si vous cochez explicitement et
            séparément la case correspondante lors de l&apos;inscription (ou
            plus tard dans vos paramètres).
          </li>
          <li>
            Vous pouvez à tout moment consulter, corriger, exporter ou faire
            supprimer vos données.
          </li>
        </ul>
      </div>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        1. Responsable du traitement
      </h2>
      <p className="mt-2">
        Le responsable du traitement des données collectées sur ce site est
        l&apos;éditeur de Medical Guidelines.
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        2. Données collectées
      </h2>
      <p className="mt-2">À l&apos;inscription : nom, prénom, numéro de téléphone, adresse
        email, profession (et spécialité si &laquo;&nbsp;Autre&nbsp;&raquo;),
        puis un identifiant et un mot de passe (stocké de façon chiffrée,
        jamais en clair) lors de la finalisation du compte.
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        3. Finalités et bases légales — deux finalités bien distinctes
      </h2>
      <p className="mt-2">
        <strong>3.1. Fonctionnement du compte (obligatoire).</strong> Vos
        données sont utilisées pour créer votre compte, vous authentifier,
        assurer la sécurité du site et, le cas échéant, gérer votre
        abonnement. Base légale : exécution du contrat qui vous lie à
        Medical Guidelines lorsque vous créez un compte (article 6.1.b du
        RGPD).
      </p>
      <p className="mt-2">
        <strong>3.2. Partage avec des partenaires commerciaux (facultatif).</strong>{" "}
        Si — et seulement si — vous avez coché la case dédiée lors de
        l&apos;inscription, vos données (nom, email, profession) peuvent être
        transmises à des entreprises partenaires proposant des produits ou
        services liés à votre activité professionnelle. Base légale :
        consentement explicite (article 6.1.a du RGPD), recueilli
        séparément de l&apos;acceptation des CGU, jamais pré-coché, et
        retirable à tout moment sans affecter votre accès au service.
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        4. Durée de conservation
      </h2>
      <p className="mt-2">
        Vos données sont conservées tant que votre compte est actif, puis
        supprimées dans un délai de 12 mois après suppression du compte ou
        après 3 ans d&apos;inactivité, sauf obligation légale contraire.
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        5. Vos droits
      </h2>
      <p className="mt-2">
        Conformément au RGPD, vous disposez d&apos;un droit d&apos;accès, de
        rectification, d&apos;effacement, de limitation, de portabilité et
        d&apos;opposition sur vos données, ainsi que du droit de retirer à
        tout moment votre consentement au partage avec des partenaires
        (sans effet rétroactif et sans impact sur l&apos;accès au service).
        Vous pouvez exercer ces droits depuis les paramètres de votre compte
        ou en contactant l&apos;éditeur du site. Vous disposez également du
        droit d&apos;introduire une réclamation auprès de la CNIL
        (www.cnil.fr).
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        6. Sécurité
      </h2>
      <p className="mt-2">
        Les mots de passe sont hachés et jamais stockés en clair. Les accès
        aux données sont restreints par des règles de sécurité au niveau de
        la base de données (chaque utilisateur ne peut voir que son propre
        profil).
      </p>

      <h2 className="mt-8 text-lg font-semibold text-slate-900">
        7. Hébergement
      </h2>
      <p className="mt-2">
        Les données sont hébergées au sein de l&apos;Union Européenne.
      </p>
    </div>
  );
}
