import { CGU_VERSION } from "@/lib/legal";
import { MediationTraduite } from "../mediation";

// Traduction d'information des CGU (contenu-fr.tsx fait seul foi).
export default function CguEs() {
  const h2 = "mt-8 text-lg font-semibold text-slate-900";
  return (
    <div className="mx-auto max-w-3xl px-6 py-12 text-sm leading-6 text-slate-700">
      <h1 className="text-2xl font-bold text-[#0E3A78]">Condiciones de uso</h1>
      <p className="mt-2 text-slate-500">Versión del {CGU_VERSION.split("-").reverse().join("/")}.</p>

      <h2 className={h2}>1. Objeto y acceso al servicio</h2>
      <p className="mt-2">
        Medical Guidelines es un sitio de resúmenes de guías profesionales francesas en varias especialidades
        (anestesiología y reanimación, medicina intensiva, medicina de urgencias, pediatría…). El acceso al contenido está
        reservado a los profesionales sanitarios y a los estudiantes de medicina y de ciencias de la salud, previa
        creación de una cuenta. La cuenta gratuita da acceso a 5 resúmenes completos en total, para siempre, sin tarjeta
        bancaria, elegidos en la especialidad indicada al registrarse o, mientras el catálogo cubra aún poco esa
        especialidad (menos de 20 resúmenes publicados), entre todos los resúmenes publicados. La suscripción PREMIUM
        (todos los resúmenes de la especialidad elegida), ofrecida para las especialidades cubiertas por el catálogo,
        cuesta 50 € IVA incluido al año, pagaderos anualmente por adelantado; se renueva automáticamente en su fecha de
        aniversario y puede cancelarse en cualquier momento, manteniéndose el acceso hasta el final del año pagado. El
        precio del año en curso está garantizado; cualquier subida solo se aplica en la renovación, previo aviso con al
        menos 30 días de antelación y con un enlace de cancelación. Las condiciones de la suscripción (descuentos,
        derecho de desistimiento, facturación) se establecen en las condiciones de venta, distintas de estas condiciones
        y aceptadas en cada suscripción.
      </p>

      <h2 className={h2}>2. Naturaleza del servicio y del contenido — sin valor médico vinculante</h2>
      <p className="mt-2">
        Medical Guidelines es un servicio que ayuda a utilizar las guías profesionales: permite encontrarlas, leerlas en
        forma de resúmenes redactados por el editor y revisados por su equipo médico (la fecha de revisión figura en cada
        resumen), compararlas y recibir alertas de sus actualizaciones. Los documentos oficiales de las guías no se venden
        ni se distribuyen en el sitio: siguen siendo obra y propiedad de sus autores, de libre acceso en sus webs, a las
        que remite cada resumen. La suscripción remunera el servicio: redacción y revisión médica de los resúmenes,
        herramientas de búsqueda, alertas y alojamiento.
      </p>
      <p className="mt-2">
        Los resúmenes publicados son resúmenes independientes, elaborados como ayuda para la memoria, a partir de los
        documentos publicados por las sociedades científicas. No sustituyen a la lectura del texto completo de las guías
        oficiales y no comprometen la responsabilidad de las sociedades afectadas. En este sitio no se reproduce ningún
        logotipo, marca ni elemento protegido de una sociedad científica. En caso de duda clínica, el usuario debe
        remitirse al texto completo de la guía o a una opinión especializada.
      </p>
      <p className="mt-2">
        <b>Traducciones.</b> Algunos resúmenes pueden ofrecerse en otros idiomas (inglés, español, alemán, árabe,
        chino), solo cuando los autores de la guía lo han autorizado por escrito. Estas traducciones las realiza la
        inteligencia artificial a partir del resumen francés revisado por un médico y se controlan automáticamente
        (dosis, unidades, umbrales, grados); salvo indicación contraria en el resumen, no las revisa un médico en el
        idioma de traducción, como indica cada resumen traducido. Solo la versión francesa del resumen y el texto
        oficial de la guía son auténticos.
      </p>

      <h2 className={h2}>3. Propiedad intelectual y uso autorizado</h2>
      <p className="mt-2">
        Las guías citadas (formulación, grados, tablas, figuras) pertenecen a sus autores y editores; los resúmenes las
        citan con su referencia y el enlace al texto oficial. Los resúmenes, su selección, su organización, la base de
        datos y el software del sitio pertenecen al editor (artículos L341-1 y siguientes del Código de la Propiedad
        Intelectual francés en lo que respecta a la base de datos).
      </p>
      <p className="mt-2">
        La cuenta confiere un derecho de acceso personal, para un uso profesional. Quedan prohibidos: la copia o la
        extracción sistemática de los resúmenes, incluso mediante un robot o un programa; la reventa o la difusión del
        contenido; la elusión de las medidas de protección del sitio. Si la lectura se produce a un ritmo anómalo, se
        suspende automáticamente durante un tiempo limitado y se avisa a un administrador (véase la{" "}
        <a href="/es/confidentialite" className="underline">
          política de privacidad
        </a>
        ).
      </p>

      <h2 className={h2}>4. Cuenta de usuario</h2>
      <p className="mt-2">
        La creación de una cuenta requiere facilitar datos de identificación (apellidos, nombre, teléfono, correo
        electrónico, profesión) y confirmar la dirección de correo. La cuenta es personal: sus credenciales no deben
        compartirse ni prestarse. El usuario es responsable de la confidencialidad de su contraseña y de cualquier
        actividad realizada desde su cuenta.
      </p>

      <h2 className={h2}>5. Datos personales</h2>
      <p className="mt-2">
        El tratamiento de los datos personales se describe íntegramente en nuestra{" "}
        <a href="/es/confidentialite" className="underline">
          Política de privacidad
        </a>
        , documento distinto que le invitamos a consultar antes de registrarse. El consentimiento para la cesión de datos
        a socios comerciales es independiente de la aceptación de estas Condiciones de uso y nunca se exige para crear
        una cuenta.
      </p>

      <h2 className={h2}>6. Eliminación, suspensión y cierre de la cuenta</h2>
      <p className="mt-2">
        El usuario puede eliminar su cuenta en cualquier momento desde la página «Mi cuenta»; sus datos personales se
        borran entonces de inmediato, sin perjuicio de las obligaciones legales de conservación (documentos contables).
      </p>
      <p className="mt-2">
        El editor puede suspender el acceso a una cuenta, tras avisar al usuario por correo electrónico e invitarle a
        dar explicaciones, en caso de incumplimiento de estas condiciones: extracción o copia sistemática del contenido,
        uso compartido o préstamo de las credenciales, elusión de las medidas de protección, declaración falsa de la
        condición profesional. En caso de incumplimiento grave o reiterado, la cuenta puede cerrarse; la suscripción en
        curso se reembolsa entonces en proporción al periodo restante, salvo en caso de fraude. La suspensión automática
        y temporal de la lectura en caso de ritmo anómalo (artículo 3) no constituye una sanción.
      </p>

      <h2 className={h2}>7. Responsabilidad y disponibilidad</h2>
      <p className="mt-2">
        Los resúmenes y el asistente de búsqueda son ayudas a la lectura destinadas a los profesionales sanitarios. No
        sustituyen ni al texto oficial de las guías, ni a la exploración del paciente, ni al juicio clínico: toda
        decisión diagnóstica o terapéutica es responsabilidad exclusiva del profesional que la toma. El editor pone el
        máximo cuidado en la fidelidad de los resúmenes a sus fuentes y corrige cualquier error notificado (registro
        público de correcciones), sin garantizar la ausencia de errores ni la exhaustividad del contenido.
      </p>
      <p className="mt-2">
        El editor se esfuerza por mantener el sitio accesible en todo momento, sin obligación de resultado: pueden
        producirse interrupciones por mantenimiento, actualizaciones o incidencias técnicas. Los enlaces a las webs de las
        sociedades científicas y a otros sitios son responsabilidad de sus respectivos editores.
      </p>

      <h2 className={h2}>8. Asistente de búsqueda (inteligencia artificial)</h2>
      <p className="mt-2">
        El asistente de búsqueda, reservado a los suscriptores PREMIUM, utiliza un modelo de inteligencia artificial
        para encontrar los pasajes de los resúmenes que responden a una pregunta. Sus respuestas se generan
        automáticamente: pueden contener errores u omisiones, y cada pasaje debe comprobarse en el resumen y en la
        fuente oficial citada antes de cualquier decisión. El asistente no da ninguna opinión sobre un paciente. Está
        prohibido introducir cualquier dato que permita identificar a un paciente. El sitio no conserva las preguntas;
        su tratamiento se describe en la política de privacidad.
      </p>

      <h2 className={h2}>9. Modificación de las condiciones</h2>
      <p className="mt-2">
        El editor puede modificar estas condiciones, en particular para adaptarlas a la evolución del servicio o de la
        normativa. Cualquier modificación sustancial se notifica por correo electrónico al menos 30 días antes de su
        entrada en vigor. El usuario que no la acepte puede eliminar su cuenta antes de esa fecha; seguir utilizando el
        sitio después de esa fecha supone su aceptación. La versión aceptada al registrarse queda registrada.
      </p>

      <h2 className={h2}>10. Derecho aplicable, litigios y mediación</h2>
      <p className="mt-2">
        Estas Condiciones de uso se rigen por el derecho francés. En caso de litigio, se invita al usuario a dirigirse
        primero al editor en contact@medical-guidelines.net. A falta de solución amistosa, el litigio se somete a los
        tribunales competentes de París cuando el usuario actúa en calidad de profesional; el usuario consumidor puede
        acudir al tribunal de su elección en las condiciones previstas por la ley y recurrir gratuitamente a la mediación
        de consumo:
      </p>
      <MediationTraduite langue="es" />
    </div>
  );
}
