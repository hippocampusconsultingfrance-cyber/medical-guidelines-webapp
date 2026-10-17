// Traduction d'information de la politique de confidentialité
// (contenu-fr.tsx fait seul foi).
export default function ConfidentialiteEs() {
  const h2 = "mt-8 text-lg font-semibold text-slate-900";
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">Política de privacidad</h1>
      <p className="mt-2 text-slate-500">
        Última actualización: 17 de octubre de 2026. Conforme al Reglamento General de Protección de Datos (RGPD).
      </p>

      <div className="mt-6 rounded-md border-s-4 border-[#2BB5A6] bg-[#EEF6FB] p-4">
        <p className="font-medium text-slate-900">En resumen</p>
        <ul className="mt-2 list-disc space-y-1 ps-5">
          <li>Recogemos sus apellidos, nombre, teléfono, correo electrónico y profesión para crear y proteger su cuenta.</li>
          <li>
            Estos datos <strong>nunca</strong> se comunican a socios comerciales, salvo que marque expresamente y por
            separado la casilla correspondiente al registrarse (o más tarde desde la página «Mi cuenta»).
          </li>
          <li>Puede consultar, corregir, exportar o eliminar sus datos en cualquier momento.</li>
        </ul>
      </div>

      <h2 className={h2}>1. Responsable del tratamiento</h2>
      <p className="mt-2">
        El responsable del tratamiento de los datos recogidos en este sitio es Hippocampus Consulting, SARL con un
        capital de 1000 €, 6 rue d&apos;Armaillé, 75017 París, Francia (SIREN 999 259 252), con quien puede contactar en
        contact@medical-guidelines.net. Véase también el{" "}
        <a href="/es/mentions-legales" className="underline">
          aviso legal
        </a>
        .
      </p>

      <h2 className={h2}>2. Datos recogidos</h2>
      <p className="mt-2">
        Al registrarse: apellidos, nombre, número de teléfono, dirección de correo electrónico, profesión (especificada
        en caso de «Otra»), especialidad consultada y, al completar la cuenta, un nombre de usuario y una contraseña
        (almacenada cifrada, nunca en claro).
      </p>
      <p className="mt-2">
        Durante el uso: resúmenes desbloqueados, resúmenes añadidos a favoritos, historial de resúmenes consultados,
        sociedades seguidas y preferencia de alertas por correo, así como la lista de alertas enviadas. En caso de
        suscripción PREMIUM: estado y fechas de la suscripción, fecha de aceptación de las condiciones de venta y de la
        renuncia al derecho de desistimiento, identificadores de cliente y de suscripción de Stripe. Los datos de la
        tarjeta bancaria se introducen en Stripe y nunca se nos transmiten. Estos datos sirven para mostrar su espacio
        personal (seguir leyendo, favoritos, actualizaciones de sus resúmenes) y para enviarle las alertas. La
        clasificación de «lo más leído» se basa únicamente en recuentos agregados de lectores: nunca muestra lo que ha
        leído una persona.
      </p>
      <p className="mt-2">
        Seguridad del contenido: cada apertura de un resumen se registra (cuenta, resumen, fecha y hora) durante 30 días
        para detectar extracciones automatizadas; un ritmo anómalo suspende temporalmente la lectura y avisa a un
        administrador. Base jurídica: el interés legítimo del editor en proteger el contenido del sitio frente a la copia
        (artículo 6.1.f del RGPD); el registro se borra automáticamente cada noche más allá de 30 días. Tarifa para
        profesionales en formación: el justificante subido solo lo consulta un administrador y se elimina en cuanto se
        toma la decisión; solo se conservan la situación declarada, el curso académico y la decisión.
      </p>
      <p className="mt-2">
        Candidatura como médico revisor (página{" "}
        <a href="/es/relecteurs" className="underline">
          Médicos revisores
        </a>
        , sin cuenta): apellidos, nombre, número de teléfono, dirección de correo electrónico, profesión, especialidad
        cuyos resúmenes desea corregir y un mensaje opcional. Estos datos solo sirven para contactarle en relación con
        esta propuesta; solo un administrador tiene acceso a ellos. Base jurídica: su consentimiento (artículo 6.1.a del
        RGPD), que puede retirar en cualquier momento escribiendo a contact@medical-guidelines.net.
      </p>

      <h2 className={h2}>3. Finalidades y bases jurídicas</h2>
      <p className="mt-2">
        <strong>3.1. Funcionamiento de la cuenta (obligatorio).</strong> Sus datos sirven para crear su cuenta,
        autenticarle, garantizar la seguridad del sitio y, en su caso, gestionar su suscripción. Base jurídica: la
        ejecución del contrato entre usted y Medical Guidelines cuando crea una cuenta (artículo 6.1.b del RGPD).
      </p>
      <p className="mt-2">
        <strong>3.2. Cesión a socios comerciales (opcional).</strong> Si —y solo si— ha marcado la casilla prevista al
        registrarse, sus datos (nombre, correo electrónico, profesión) pueden comunicarse al siguiente socio, que ofrece
        productos o servicios relacionados con su actividad profesional: LASKA CORPORATE SAS. Cualquier nuevo socio se
        añadirá a esta lista y se le volverá a pedir su consentimiento antes de cualquier transmisión. Base jurídica: el
        consentimiento explícito (artículo 6.1.a del RGPD), recogido por separado de la aceptación de las Condiciones de
        uso, nunca premarcado, y que puede retirar en cualquier momento sin afectar a su acceso al servicio.
      </p>
      <p className="mt-2">
        <strong>3.3. Estadísticas anónimas comunicadas a los autores.</strong> Podemos comunicar a las sociedades
        científicas y a los autores de las guías estadísticas anónimas y agregadas sobre la lectura de sus guías (número
        de lectores por resumen, por mes y por especialidad), solo a partir de 10 lectores, y nunca la identidad ni el
        historial de navegación de un miembro. Base jurídica: el interés legítimo del editor en informar a los autores
        sobre la difusión de sus guías (artículo 6.1.f del RGPD).
      </p>

      <h2 className={h2}>4. Plazo de conservación</h2>
      <p className="mt-2">
        Sus datos se conservan mientras su cuenta esté activa. Se borran de inmediato cuando elimina su cuenta y, como
        máximo, tras 3 años de inactividad (cuenta sin inicio de sesión durante 3 años, salvo suscripción en curso),
        salvo obligación legal contraria. Las facturas y los justificantes de pago se conservan 10 años (obligación
        contable, artículo L123-22 del Código de Comercio francés).
      </p>
      <p className="mt-2">
        Las candidaturas de médicos revisores se borran 6 meses después de un rechazo y, como máximo, 3 años después de
        su envío.
      </p>

      <h2 className={h2}>5. Sus derechos</h2>
      <p className="mt-2">
        De conformidad con el RGPD, dispone de los derechos de acceso, rectificación, supresión, limitación,
        portabilidad y oposición respecto a sus datos, así como del derecho a retirar en cualquier momento su
        consentimiento a la cesión a socios (sin efecto retroactivo y sin consecuencias para el acceso al servicio).
        Puede ejercer estos derechos desde la página{" "}
        <a href="/es/compte" className="underline">
          Mi cuenta
        </a>{" "}
        (modificar sus datos, retirar el consentimiento, exportar sus datos, eliminar la cuenta) o contactando con el
        editor del sitio (contact@medical-guidelines.net). Respondemos en el plazo de un mes. También tiene derecho a
        presentar una reclamación ante la CNIL, la autoridad francesa de protección de datos (www.cnil.fr).
      </p>

      <h2 className={h2}>6. Seguridad</h2>
      <p className="mt-2">
        Las contraseñas se almacenan cifradas (hash) y nunca en claro. El acceso a los datos está restringido por reglas
        de seguridad en la base de datos (cada usuario solo puede ver su propio perfil).
      </p>

      <h2 className={h2}>7. Alojamiento</h2>
      <p className="mt-2">
        La base de datos (cuentas y perfiles) está alojada por Supabase Inc. en la Unión Europea (Fráncfort, Alemania). El
        sitio se sirve a través de Vercel Inc. mediante su red de distribución mundial. Estos dos proveedores son
        empresas establecidas en Estados Unidos, que actúan como encargados del tratamiento y regulan las posibles
        transferencias fuera de la Unión Europea mediante las cláusulas contractuales tipo de la Comisión Europea y/o el
        Marco de Privacidad de Datos UE-EE. UU.
      </p>
      <p className="mt-2">
        Los pagos de la suscripción PREMIUM los procesa Stripe Payments Europe, Ltd. (Dublín, Irlanda), proveedor de
        servicios de pago, que recibe su dirección de correo electrónico, su dirección de facturación y sus datos de pago,
        y emite las facturas.
      </p>
      <p className="mt-2">
        Los correos del servicio (confirmación de registro, contraseña olvidada) y las alertas por correo (nuevas guías de
        las sociedades seguidas, actualizaciones de sus resúmenes, para los suscriptores PREMIUM que las han activado),
        así como la carta mensual de seguimiento enviada a los suscriptores PREMIUM que han activado las alertas, los
        envía Resend (Resend, Inc., Estados Unidos), que actúa como encargado del tratamiento en las mismas condiciones.
        Cada alerta incluye un enlace de baja; las alertas también pueden desactivarse desde la página «Mi cuenta».
      </p>
      <p className="mt-2">
        También pueden enviársele dos correos de seguimiento, una sola vez cada uno: un recordatorio si su registro no se
        ha completado tras 24 horas, y una información sobre la suscripción cuando ha agotado sus créditos gratuitos.
        Incluyen un enlace de baja, que también desactiva las alertas.
      </p>
      <p className="mt-2">
        La audiencia del sitio se mide con Vercel Web Analytics, sin cookies ni identificador persistente: solo se
        elaboran estadísticas agregadas (páginas vistas, país, tipo de dispositivo, sitio de procedencia). Las fuentes
        tipográficas están alojadas en el propio sitio.
      </p>
      <p className="mt-2">
        Los errores técnicos del sitio se envían a Sentry (Functional Software, Inc.), alojado en la Unión Europea
        (Alemania), que actúa como encargado del tratamiento: mensaje de error, página afectada y tipo de navegador, sin
        dirección IP, cookies, identidad ni contenido de los resúmenes. Estos datos solo sirven para corregir los fallos
        y se conservan 90 días como máximo.
      </p>
      <p className="mt-2">
        <b>Sugerencias de los miembros.</b> Cuando envía una sugerencia (botón «¿Una idea?»), conservamos su mensaje, su
        tipo, la página desde la que se envió, su fecha y el vínculo con su cuenta, para tramitarla e informarle de su
        resultado. Solo el equipo de administración tiene acceso a ella. El mensaje se elimina con su cuenta. No incluya
        ningún dato relativo a un paciente.
      </p>
      <p className="mt-2">
        <b>Asistente de búsqueda (beta).</b> Cuando lo utiliza, su pregunta y extractos de los resúmenes se envían a
        Anthropic (Anthropic PBC, Estados Unidos), que actúa como encargado del tratamiento para elaborar la respuesta,
        con transferencias reguladas por las cláusulas contractuales tipo de la Comisión Europea. Ni la pregunta ni la
        respuesta se conservan en el sitio: solo se registran la fecha y el número de extractos, para aplicar el límite
        diario. No introduzca ningún dato que permita identificar a un paciente: una pregunta que contenga una dirección
        de correo, un número de teléfono o de seguridad social, una fecha de nacimiento o un identificador de paciente
        queda bloqueada por el sitio y no se envía.
      </p>
      <p className="mt-2">
        Cada cambio de su consentimiento a la cesión a socios queda fechado y se conserva en un historial consultable
        desde la página «Mi cuenta».
      </p>

      <h2 className={h2}>8. Cookies</h2>
      <p className="mt-2">
        El sitio solo instala las cookies estrictamente necesarias para su funcionamiento: cookies de sesión, que
        mantienen su conexión y protegen su cuenta, y una cookie que recuerda durante un año el idioma del sitio que
        utiliza. No se utiliza ninguna cookie publicitaria, de medición de audiencia ni de redes sociales; al estar estas
        cookies exentas de consentimiento, no se muestra ningún banner.
      </p>
    </div>
  );
}
