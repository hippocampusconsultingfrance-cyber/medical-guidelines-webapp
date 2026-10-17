// Traduction d'information de la politique de confidentialité
// (contenu-fr.tsx fait seul foi).
export default function ConfidentialiteEn() {
  const h2 = "mt-8 text-lg font-semibold text-slate-900";
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">Privacy Policy</h1>
      <p className="mt-2 text-slate-500">
        Last updated: 17 October 2026. Compliant with the General Data Protection Regulation (GDPR).
      </p>

      <div className="mt-6 rounded-md border-s-4 border-[#2BB5A6] bg-[#EEF6FB] p-4">
        <p className="font-medium text-slate-900">In short</p>
        <ul className="mt-2 list-disc space-y-1 ps-5">
          <li>We collect your last name, first name, phone, email and profession to create and secure your account.</li>
          <li>
            These data are <strong>never</strong> shared with commercial partners, unless you explicitly and
            separately tick the corresponding box when registering (or later from the “My account” page).
          </li>
          <li>You can view, correct, export or have your data deleted at any time.</li>
        </ul>
      </div>

      <h2 className={h2}>1. Data controller</h2>
      <p className="mt-2">
        The controller of the data collected on this site is Hippocampus Consulting, SARL with a share capital of
        €1,000, 6 rue d&apos;Armaillé, 75017 Paris, France (SIREN 999 259 252), reachable at
        contact@medical-guidelines.net. See also the{" "}
        <a href="/en/mentions-legales" className="underline">
          legal notice
        </a>
        .
      </p>

      <h2 className={h2}>2. Data collected</h2>
      <p className="mt-2">
        At registration: last name, first name, phone number, email address, profession (specified if “Other”),
        specialty read, then a username and a password (stored encrypted, never in plain text) when the account is
        completed.
      </p>
      <p className="mt-2">
        During use: summaries unlocked, summaries added to favourites, history of summaries read, societies followed
        and email alert preference, as well as the list of alerts sent. For a PREMIUM subscription: status and dates of
        the subscription, date of acceptance of the terms of sale and of the waiver of the right of withdrawal, Stripe
        customer and subscription identifiers. Bank card data are entered at Stripe and are never passed on to us.
        These data are used to display your personal space (resume reading, favourites, updates to your summaries) and
        to send you alerts. The “most read” ranking relies only on aggregated reader counts: it never shows what a
        person has read.
      </p>
      <p className="mt-2">
        Content security: each opening of a summary is logged (account, summary, date and time) for 30 days, in order
        to detect automated extraction; an abnormal rate temporarily suspends reading and notifies an administrator.
        Legal basis: the publisher&apos;s legitimate interest in protecting the site&apos;s content against copying
        (article 6.1.f GDPR); the log is erased automatically every night beyond 30 days. Rate for professionals in
        training: the proof uploaded is viewed only by an administrator and is deleted as soon as a decision is made;
        only the declared status, the academic year and the decision are kept.
      </p>
      <p className="mt-2">
        Application as a physician reviewer (
        <a href="/en/relecteurs" className="underline">
          Physician reviewers
        </a>{" "}
        page, without an account): last name, first name, phone number, email address, profession, specialty whose
        summaries you would like to correct and an optional message. These data are used only to contact you about this
        proposal; only an administrator has access to them. Legal basis: your consent (article 6.1.a GDPR), which can
        be withdrawn at any time by writing to contact@medical-guidelines.net.
      </p>

      <h2 className={h2}>3. Purposes and legal bases</h2>
      <p className="mt-2">
        <strong>3.1. Operation of the account (required).</strong> Your data are used to create your account,
        authenticate you, ensure the security of the site and, where applicable, manage your subscription. Legal basis:
        performance of the contract between you and Medical Guidelines when you create an account (article 6.1.b GDPR).
      </p>
      <p className="mt-2">
        <strong>3.2. Sharing with commercial partners (optional).</strong> If — and only if — you ticked the dedicated
        box at registration, your data (name, email, profession) may be passed on to the following partner, which
        offers products or services related to your professional activity: LASKA CORPORATE SAS. Any new partner will be
        added to this list and your consent will be requested again before any transfer. Legal basis: explicit consent
        (article 6.1.a GDPR), collected separately from acceptance of the Terms of Use, never pre-ticked, and which can
        be withdrawn at any time without affecting your access to the service.
      </p>
      <p className="mt-2">
        <strong>3.3. Anonymous statistics shared with authors.</strong> We may share with medical societies and the
        authors of guidelines anonymous, aggregated statistics on the reading of their guidelines (number of readers
        per summary, per month and per specialty), only above 10 readers, and never a member&apos;s identity or browsing
        history. Legal basis: the publisher&apos;s legitimate interest in reporting to authors on the dissemination of
        their guidelines (article 6.1.f GDPR).
      </p>

      <h2 className={h2}>4. Retention period</h2>
      <p className="mt-2">
        Your data are kept as long as your account is active. They are erased immediately when you delete your account,
        and at the latest after 3 years of inactivity (account without sign-in for 3 years, excluding a current
        subscription), unless a legal obligation requires otherwise. Invoices and payment records are kept for 10
        years (accounting obligation, article L123-22 of the French Commercial Code).
      </p>
      <p className="mt-2">
        Physician reviewer applications are erased 6 months after a refusal, and at the latest 3 years after being
        sent.
      </p>

      <h2 className={h2}>5. Your rights</h2>
      <p className="mt-2">
        Under the GDPR, you have the right of access, rectification, erasure, restriction, portability and objection
        regarding your data, as well as the right to withdraw at any time your consent to sharing with partners
        (without retroactive effect and without impact on access to the service). You can exercise these rights from
        the{" "}
        <a href="/en/compte" className="underline">
          My account
        </a>{" "}
        page (changing your information, withdrawing consent, exporting your data, deleting the account) or by
        contacting the site&apos;s publisher (contact@medical-guidelines.net). We reply within one month. You also have
        the right to lodge a complaint with the CNIL, the French data protection authority (www.cnil.fr).
      </p>

      <h2 className={h2}>6. Security</h2>
      <p className="mt-2">
        Passwords are hashed and never stored in plain text. Access to data is restricted by security rules at the
        database level (each user can only see their own profile).
      </p>

      <h2 className={h2}>7. Hosting</h2>
      <p className="mt-2">
        The database (accounts and profiles) is hosted by Supabase Inc. in the European Union (Frankfurt, Germany). The
        site is served by Vercel Inc. through its global distribution network. These two providers are companies
        established in the United States, which act as processors and govern any transfers outside the European Union
        through the European Commission&apos;s standard contractual clauses and/or the EU–US Data Privacy Framework.
      </p>
      <p className="mt-2">
        PREMIUM subscription payments are processed by Stripe Payments Europe, Ltd. (Dublin, Ireland), a payment service
        provider, which receives your email address, your billing address and your payment data, and issues the
        invoices.
      </p>
      <p className="mt-2">
        Service emails (registration confirmation, forgotten password) and email alerts (new guidelines from the
        societies followed, updates to your summaries, for PREMIUM subscribers who have turned them on), as well as the
        monthly monitoring letter sent to PREMIUM subscribers who have turned on alerts, are sent by Resend (Resend,
        Inc., United States), which acts as a processor under the same conditions. Each alert includes an unsubscribe
        link; alerts can also be turned off from the “My account” page.
      </p>
      <p className="mt-2">
        Two follow-up emails may also be sent to you, once each: a reminder if your registration has not been completed
        after 24 hours, and information about the subscription when your free credits are used up. They include an
        unsubscribe link, which also turns off alerts.
      </p>
      <p className="mt-2">
        Site traffic is measured by Vercel Web Analytics, without cookies or a persistent identifier: only aggregated
        statistics (page views, country, device type, referring site) are produced. Fonts are hosted by the site
        itself.
      </p>
      <p className="mt-2">
        Technical errors on the site are sent to Sentry (Functional Software, Inc.), hosted in the European Union
        (Germany), which acts as a processor: error message, page concerned and browser type, without IP address,
        cookies, identity or summary content. These data are used solely to fix malfunctions and are kept for 90 days
        at most.
      </p>
      <p className="mt-2">
        <b>Members&apos; suggestions.</b> When you send a suggestion (“An idea?” button), we keep your message, its
        type, the page it was sent from, its date and the link with your account, in order to process it and tell you
        what happened to it. Only the administration team has access to it. The message is deleted with your account.
        Do not include any data about a patient.
      </p>
      <p className="mt-2">
        <b>Research assistant (beta).</b> When you use it, your question and extracts from the summaries are sent to
        Anthropic (Anthropic PBC, United States), which acts as a processor to produce the answer, with transfers
        governed by the European Commission&apos;s standard contractual clauses. Neither the question nor the answer is
        kept by the site: only the date and the number of extracts are recorded, to apply the daily limit. Do not enter
        any data that could identify a patient: a question containing an email address, a phone or social security
        number, a date of birth or a patient identifier is blocked by the site and is not sent.
      </p>
      <p className="mt-2">
        Every change in your consent to sharing with partners is time-stamped and kept in a history that can be viewed
        from the “My account” page.
      </p>

      <h2 className={h2}>8. Cookies</h2>
      <p className="mt-2">
        The site only sets cookies that are strictly necessary for it to work: session cookies that keep you signed in
        and secure your account, and a cookie that remembers for one year the site language you use. No advertising,
        audience measurement or social network cookie is used; as these cookies are exempt from consent, no banner is
        displayed.
      </p>
    </div>
  );
}
