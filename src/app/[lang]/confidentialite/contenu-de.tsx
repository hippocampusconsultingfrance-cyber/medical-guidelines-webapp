// Traduction d'information de la politique de confidentialité
// (contenu-fr.tsx fait seul foi).
export default function ConfidentialiteDe() {
  const h2 = "mt-8 text-lg font-semibold text-slate-900";
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">Datenschutzerklärung</h1>
      <p className="mt-2 text-slate-500">
        Letzte Aktualisierung: 17. Oktober 2026. Im Einklang mit der Datenschutz-Grundverordnung (DSGVO).
      </p>

      <div className="mt-6 rounded-md border-s-4 border-[#2BB5A6] bg-[#EEF6FB] p-4">
        <p className="font-medium text-slate-900">Kurz gesagt</p>
        <ul className="mt-2 list-disc space-y-1 ps-5">
          <li>Wir erheben Ihren Nachnamen, Vornamen, Ihre Telefonnummer, E-Mail-Adresse und Ihren Beruf, um Ihr Konto zu erstellen und zu schützen.</li>
          <li>
            Diese Daten werden <strong>niemals</strong> an kommerzielle Partner weitergegeben, es sei denn, Sie kreuzen
            bei der Registrierung (oder später auf der Seite „Mein Konto“) ausdrücklich und gesondert das entsprechende
            Kästchen an.
          </li>
          <li>Sie können Ihre Daten jederzeit einsehen, berichtigen, exportieren oder löschen lassen.</li>
        </ul>
      </div>

      <h2 className={h2}>1. Verantwortlicher</h2>
      <p className="mt-2">
        Verantwortlich für die auf dieser Website erhobenen Daten ist Hippocampus Consulting, SARL mit einem
        Stammkapital von 1.000 €, 6 rue d&apos;Armaillé, 75017 Paris, Frankreich (SIREN 999 259 252), erreichbar unter
        contact@medical-guidelines.net. Siehe auch das{" "}
        <a href="/de/mentions-legales" className="underline">
          Impressum
        </a>
        .
      </p>

      <h2 className={h2}>2. Erhobene Daten</h2>
      <p className="mt-2">
        Bei der Registrierung: Nachname, Vorname, Telefonnummer, E-Mail-Adresse, Beruf (bei „Sonstiges“ präzisiert),
        gelesenes Fachgebiet und bei Vervollständigung des Kontos ein Benutzername und ein Passwort (verschlüsselt
        gespeichert, nie im Klartext).
      </p>
      <p className="mt-2">
        Während der Nutzung: freigeschaltete Zusammenfassungen, zu Favoriten hinzugefügte Zusammenfassungen, Verlauf der
        gelesenen Zusammenfassungen, abonnierte Fachgesellschaften und Präferenz für E-Mail-Benachrichtigungen sowie die
        Liste der gesendeten Benachrichtigungen. Bei einem PREMIUM-Abonnement: Status und Daten des Abonnements, Datum der
        Annahme der Verkaufsbedingungen und des Verzichts auf das Widerrufsrecht, Stripe-Kunden- und
        Abonnementkennungen. Die Bankkartendaten werden bei Stripe eingegeben und uns nie übermittelt. Diese Daten dienen
        dazu, Ihren persönlichen Bereich anzuzeigen (Weiterlesen, Favoriten, Aktualisierungen Ihrer Zusammenfassungen) und
        Ihnen die Benachrichtigungen zu senden. Die Rangliste „Meistgelesen“ beruht ausschließlich auf aggregierten
        Leserzahlen: Sie zeigt nie, was eine Person gelesen hat.
      </p>
      <p className="mt-2">
        Schutz der Inhalte: Jedes Öffnen einer Zusammenfassung wird 30 Tage lang protokolliert (Konto, Zusammenfassung,
        Datum und Uhrzeit), um automatisierte Entnahmen zu erkennen; ein ungewöhnliches Tempo setzt das Lesen
        vorübergehend aus und benachrichtigt einen Administrator. Rechtsgrundlage: das berechtigte Interesse des
        Herausgebers, die Inhalte der Website vor dem Kopieren zu schützen (Art. 6 Abs. 1 lit. f DSGVO); das Protokoll
        wird jede Nacht über 30 Tage hinaus automatisch gelöscht. Tarif für Fachpersonen in Ausbildung: Der hochgeladene
        Nachweis wird nur von einem Administrator eingesehen und gelöscht, sobald die Entscheidung getroffen ist;
        aufbewahrt werden nur der angegebene Status, das Studienjahr und die Entscheidung.
      </p>
      <p className="mt-2">
        Bewerbung als ärztlicher Gutachter (Seite{" "}
        <a href="/de/relecteurs" className="underline">
          Ärztliche Gutachter
        </a>
        , ohne Konto): Nachname, Vorname, Telefonnummer, E-Mail-Adresse, Beruf, Fachgebiet, dessen Zusammenfassungen Sie
        korrigieren möchten, und eine optionale Nachricht. Diese Daten dienen ausschließlich dazu, Sie zu diesem Angebot
        zu kontaktieren; nur ein Administrator hat Zugriff darauf. Rechtsgrundlage: Ihre Einwilligung (Art. 6 Abs. 1 lit.
        a DSGVO), die Sie jederzeit durch eine Nachricht an contact@medical-guidelines.net widerrufen können.
      </p>

      <h2 className={h2}>3. Zwecke und Rechtsgrundlagen</h2>
      <p className="mt-2">
        <strong>3.1. Betrieb des Kontos (erforderlich).</strong> Ihre Daten dienen dazu, Ihr Konto zu erstellen, Sie zu
        authentifizieren, die Sicherheit der Website zu gewährleisten und gegebenenfalls Ihr Abonnement zu verwalten.
        Rechtsgrundlage: die Erfüllung des Vertrags zwischen Ihnen und Medical Guidelines bei der Erstellung eines Kontos
        (Art. 6 Abs. 1 lit. b DSGVO).
      </p>
      <p className="mt-2">
        <strong>3.2. Weitergabe an kommerzielle Partner (freiwillig).</strong> Wenn — und nur wenn — Sie bei der
        Registrierung das dafür vorgesehene Kästchen angekreuzt haben, können Ihre Daten (Name, E-Mail, Beruf) an den
        folgenden Partner weitergegeben werden, der Produkte oder Dienstleistungen im Zusammenhang mit Ihrer beruflichen
        Tätigkeit anbietet: LASKA CORPORATE SAS. Jeder neue Partner wird in diese Liste aufgenommen, und Ihre
        Einwilligung wird vor jeder Übermittlung erneut eingeholt. Rechtsgrundlage: die ausdrückliche Einwilligung (Art.
        6 Abs. 1 lit. a DSGVO), getrennt von der Annahme der Nutzungsbedingungen eingeholt, nie vorausgewählt und
        jederzeit widerrufbar, ohne Auswirkung auf Ihren Zugang zum Dienst.
      </p>
      <p className="mt-2">
        <strong>3.3. Anonyme Statistiken für die Autoren.</strong> Wir können Fachgesellschaften und Autoren von
        Leitlinien anonyme, aggregierte Statistiken über das Lesen ihrer Leitlinien mitteilen (Anzahl der Leser pro
        Zusammenfassung, pro Monat und pro Fachgebiet), nur ab 10 Lesern und nie mit der Identität oder dem Verlauf eines
        Mitglieds. Rechtsgrundlage: das berechtigte Interesse des Herausgebers, den Autoren über die Verbreitung ihrer
        Leitlinien zu berichten (Art. 6 Abs. 1 lit. f DSGVO).
      </p>

      <h2 className={h2}>4. Speicherdauer</h2>
      <p className="mt-2">
        Ihre Daten werden aufbewahrt, solange Ihr Konto aktiv ist. Sie werden sofort gelöscht, wenn Sie Ihr Konto
        löschen, spätestens jedoch nach 3 Jahren Inaktivität (Konto ohne Anmeldung seit 3 Jahren, außer bei laufendem
        Abonnement), sofern keine gesetzliche Pflicht entgegensteht. Rechnungen und Zahlungsbelege werden 10 Jahre
        aufbewahrt (Buchhaltungspflicht, Artikel L123-22 des französischen Handelsgesetzbuchs).
      </p>
      <p className="mt-2">
        Bewerbungen als ärztlicher Gutachter werden 6 Monate nach einer Ablehnung und spätestens 3 Jahre nach ihrem
        Eingang gelöscht.
      </p>

      <h2 className={h2}>5. Ihre Rechte</h2>
      <p className="mt-2">
        Gemäß der DSGVO haben Sie ein Recht auf Auskunft, Berichtigung, Löschung, Einschränkung, Datenübertragbarkeit und
        Widerspruch in Bezug auf Ihre Daten sowie das Recht, Ihre Einwilligung in die Weitergabe an Partner jederzeit zu
        widerrufen (ohne Rückwirkung und ohne Auswirkung auf den Zugang zum Dienst). Sie können diese Rechte auf der Seite{" "}
        <a href="/de/compte" className="underline">
          Mein Konto
        </a>{" "}
        ausüben (Angaben ändern, Einwilligung widerrufen, Daten exportieren, Konto löschen) oder indem Sie sich an den
        Herausgeber der Website wenden (contact@medical-guidelines.net). Wir antworten innerhalb eines Monats. Sie haben
        außerdem das Recht, Beschwerde bei der CNIL, der französischen Datenschutzbehörde, einzulegen (www.cnil.fr).
      </p>

      <h2 className={h2}>6. Sicherheit</h2>
      <p className="mt-2">
        Passwörter werden gehasht und nie im Klartext gespeichert. Der Zugriff auf die Daten ist durch Sicherheitsregeln
        auf Ebene der Datenbank beschränkt (jeder Nutzer kann nur sein eigenes Profil sehen).
      </p>

      <h2 className={h2}>7. Hosting</h2>
      <p className="mt-2">
        Die Datenbank (Konten und Profile) wird von Supabase Inc. in der Europäischen Union (Frankfurt, Deutschland)
        gehostet. Die Website wird von Vercel Inc. über sein weltweites Verteilnetz bereitgestellt. Diese beiden
        Dienstleister sind in den Vereinigten Staaten ansässige Unternehmen, die als Auftragsverarbeiter handeln und
        etwaige Übermittlungen außerhalb der Europäischen Union durch die Standardvertragsklauseln der Europäischen
        Kommission und/oder das EU-US Data Privacy Framework absichern.
      </p>
      <p className="mt-2">
        Die Zahlungen für das PREMIUM-Abonnement werden von Stripe Payments Europe, Ltd. (Dublin, Irland), einem
        Zahlungsdienstleister, abgewickelt, der Ihre E-Mail-Adresse, Ihre Rechnungsadresse und Ihre Zahlungsdaten erhält
        und die Rechnungen ausstellt.
      </p>
      <p className="mt-2">
        Die Service-E-Mails (Bestätigung der Registrierung, Passwort vergessen) und die E-Mail-Benachrichtigungen (neue
        Leitlinien der abonnierten Fachgesellschaften, Aktualisierungen Ihrer Zusammenfassungen, für PREMIUM-Abonnenten,
        die sie aktiviert haben) sowie der monatliche Informationsbrief an PREMIUM-Abonnenten mit aktivierten
        Benachrichtigungen werden von Resend (Resend, Inc., Vereinigte Staaten) versandt, das unter denselben Bedingungen
        als Auftragsverarbeiter handelt. Jede Benachrichtigung enthält einen Abmeldelink; die Benachrichtigungen können
        auch auf der Seite „Mein Konto“ deaktiviert werden.
      </p>
      <p className="mt-2">
        Außerdem können Ihnen zwei Erinnerungs-E-Mails jeweils einmal gesendet werden: eine Erinnerung, wenn Ihre
        Registrierung nach 24 Stunden nicht abgeschlossen ist, und eine Information zum Abonnement, wenn Ihre kostenlosen
        Guthaben aufgebraucht sind. Sie enthalten einen Abmeldelink, der auch die Benachrichtigungen deaktiviert.
      </p>
      <p className="mt-2">
        Die Nutzung der Website wird mit Vercel Web Analytics gemessen, ohne Cookies und ohne dauerhafte Kennung: Es
        werden nur aggregierte Statistiken erstellt (Seitenaufrufe, Land, Gerätetyp, verweisende Website). Die
        Schriftarten werden von der Website selbst bereitgestellt.
      </p>
      <p className="mt-2">
        Technische Fehler der Website werden an Sentry (Functional Software, Inc.) gesendet, gehostet in der Europäischen
        Union (Deutschland), das als Auftragsverarbeiter handelt: Fehlermeldung, betroffene Seite und Browsertyp, ohne
        IP-Adresse, Cookies, Identität oder Inhalt der Zusammenfassungen. Diese Daten dienen ausschließlich der Behebung
        von Störungen und werden höchstens 90 Tage aufbewahrt.
      </p>
      <p className="mt-2">
        <b>Vorschläge der Mitglieder.</b> Wenn Sie einen Vorschlag senden (Schaltfläche „Eine Idee?“), speichern wir Ihre
        Nachricht, ihre Art, die Seite, von der sie gesendet wurde, ihr Datum und die Verknüpfung mit Ihrem Konto, um sie
        zu bearbeiten und Ihnen das Ergebnis mitzuteilen. Nur das Verwaltungsteam hat Zugriff darauf. Die Nachricht wird
        mit Ihrem Konto gelöscht. Geben Sie keine Daten zu Patienten an.
      </p>
      <p className="mt-2">
        <b>Suchassistent (Beta).</b> Wenn Sie ihn nutzen, werden Ihre Frage und Auszüge aus den Zusammenfassungen an
        Anthropic (Anthropic PBC, Vereinigte Staaten) gesendet, das als Auftragsverarbeiter die Antwort erstellt; die
        Übermittlungen sind durch die Standardvertragsklauseln der Europäischen Kommission abgesichert. Weder die Frage
        noch die Antwort werden von der Website gespeichert: Erfasst werden nur das Datum und die Anzahl der Auszüge, um
        das Tageslimit anzuwenden. Geben Sie keine Daten ein, die einen Patienten identifizieren könnten: Eine Frage mit
        E-Mail-Adresse, Telefon- oder Sozialversicherungsnummer, Geburtsdatum oder Patientenkennung wird von der Website
        blockiert und nicht gesendet.
      </p>
      <p className="mt-2">
        Jede Änderung Ihrer Einwilligung in die Weitergabe an Partner wird mit Zeitstempel versehen und in einem Verlauf
        gespeichert, der auf der Seite „Mein Konto“ eingesehen werden kann.
      </p>

      <h2 className={h2}>8. Cookies</h2>
      <p className="mt-2">
        Die Website setzt nur Cookies, die für ihren Betrieb unbedingt erforderlich sind: Sitzungscookies, die Ihre
        Anmeldung aufrechterhalten und Ihr Konto schützen, sowie ein Cookie, das sich ein Jahr lang die von Ihnen
        verwendete Sprache der Website merkt. Es werden keine Werbe-, Reichweitenmessungs- oder Social-Media-Cookies
        verwendet; da diese Cookies von der Einwilligung befreit sind, wird kein Banner angezeigt.
      </p>
    </div>
  );
}
