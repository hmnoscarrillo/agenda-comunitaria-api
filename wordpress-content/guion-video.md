# Guion de exposición — Agenda Comunitaria

Duración objetivo: **16 a 18 minutos**. Mantén la cámara activa durante toda la grabación. Este guion es una base: personaliza el saludo, explica con tus propias palabras y completa los campos entre corchetes con tus URLs, versión y capturas reales. No afirmes que un servicio está desplegado si todavía no lo publicaste.

## 0:00–1:15 — Presentación

**En pantalla:** portada del sitio WordPress y cámara visible.

“Hola, soy [nombre]. Presento la Agenda Comunitaria, un proyecto integrador que conecta una base de datos relacional, una API REST desarrollada con Node.js y Express, y un sitio web en WordPress. El objetivo es organizar actividades del barrio, mostrar dónde y cuándo ocurren y relacionarlas con las personas que se inscriben. Durante la exposición voy a recorrer el modelo, comprobar datos, ejecutar operaciones de la API, mostrar la integración en WordPress y cerrar con los aprendizajes.”

## 1:15–2:00 — Tema y alcance

**En pantalla:** página Inicio y navegación.

“El tema elegido es una agenda comunitaria. Definí este alcance porque requiere representar personas, actividades, categorías, lugares y las inscripciones que conectan personas con eventos. El usuario puede consultar una actividad y conocer su categoría y sede. La API también permite crear, leer, actualizar y eliminar cada tipo de registro.”

## 2:00–6:00 — Base de datos y normalización

**En pantalla:** diagrama E-R del README, cliente MySQL conectado al host cloud; luego tablas y consultas.

“El modelo tiene cinco tablas. `persona` guarda participantes y sus datos de contacto. `categoria` clasifica las actividades. `lugar` guarda la sede, la ciudad, la dirección y la capacidad. `evento` conecta una categoría y un lugar con título, descripción, horario y estado. `inscripcion` resuelve la relación muchos a muchos entre personas y eventos y guarda fecha y estado de inscripción.”

“Cada tabla tiene una clave primaria. Cédula y correo son únicos para una persona; el nombre de categoría también es único; el lugar evita duplicar el mismo nombre y dirección; y la pareja persona-evento no se puede repetir. Las claves foráneas actualizan sus referencias en cascada y restringen borrar una fila que siga siendo usada. Voy a mostrar las restricciones en el esquema.”

“El diseño cumple primera forma normal porque cada campo guarda un valor atómico. Cumple segunda forma normal porque las tablas tienen claves simples y cada atributo depende de la clave de su tabla. Cumple tercera forma normal porque los datos de categoría, sede y persona se guardan una sola vez en sus respectivas tablas; evento conserva referencias y no copia sus descripciones. `inscripcion` representa la relación muchos a muchos y sus datos dependen de la inscripción.”

“En el cliente conectado a la instancia cloud voy a ejecutar los conteos por tabla. La evidencia debe mostrar al menos diez registros por tabla. Después mostraré dos consultas JOIN: una combina eventos con categorías y lugares; la otra combina inscripciones con personas y eventos. La conexión remota se prueba desde este cliente, no solamente desde la máquina que aloja la base.”

**Demostración:** ejecuta `SELECT tabla, COUNT(*) ...` y las dos consultas JOIN de `database.sql`. Muestra el host remoto ocultando contraseña.

## 6:00–9:30 — Arquitectura y API

**En pantalla:** editor con carpetas `src/config`, `src/models`, `src/controllers`, `src/routes`; `.env.example`; variables del servicio cloud sin mostrar secretos.

“La aplicación usa la estructura MVC del curso. La configuración de base de datos lee variables de entorno. El modelo concentra las consultas parametrizadas. El controlador valida los datos y define los códigos HTTP. Las rutas exponen las operaciones REST. El archivo `.env` contiene credenciales locales y no se publica; el repositorio solo trae un ejemplo sin contraseña.”

“Hay cinco recursos: personas, categorías, lugares, eventos e inscripciones. Cada uno tiene GET de lista, GET por ID, POST, PUT y DELETE. Las respuestas son JSON consistentes. Una entrada inválida produce 400; un registro inexistente, 404; un duplicado o conflicto de relación, 409; y una creación, 201. El endpoint `/health` también comprueba la conexión con la base.”

**Demostración:** muestra `GET /health`, `GET /api/eventos` y una respuesta JSON. Explica que eventos incluye los nombres de categoría y lugar para que la web pueda presentarlos con claridad.

“La API publicada está en [URL pública real]. La URL se prueba desde un navegador o desde Postman en una red externa. La base de datos está alojada en [proveedor real]. En esta presentación no se muestra ninguna contraseña.”

## 9:30–12:30 — Postman / Insomnia

**En pantalla:** colección importada “Agenda Comunitaria API”, variable `baseUrl` y carpeta de eventos.

“Elegí `evento` para la demostración completa porque cada evento tiene dos claves foráneas directas —categoría y lugar— y puede relacionarse con muchas inscripciones. Primero consulto la lista y un evento individual. Después creo un evento indicando una categoría y un lugar existentes. La respuesta 201 incluye el ID creado.”

“Ahora actualizo el título y horario con PUT y compruebo que el servidor responde 200. Intento crear otro evento con una categoría que no existe y recibo 409 porque la clave foránea protege la relación. Finalmente elimino primero la inscripción temporal si existe, elimino el evento de prueba y vuelvo a consultarlo; el API devuelve 404, confirmando el borrado. También muestro un dato inválido que devuelve 400.”

**Demostración:** ejecuta en orden las siete peticiones de la colección, incluyendo el caso FK. Conserva los resultados visibles y captura la colección y respuestas.

## 12:30–15:00 — WordPress y consumo del API

**En pantalla:** panel de WordPress y sitio abierto en otra pestaña.

“Instalé WordPress local con [XAMPP/Laragon/LocalWP y versión]. Creé la base local del sitio, completé la configuración inicial y accedo al panel de administración en [URL local]. El sitio tiene cuatro páginas: Inicio, Proyecto, Actividades y Consumo de API. La navegación se mantiene visible y el contenido está relacionado con el tema.”

“La página Consumo de API usa el plugin Agenda Comunitaria API y el shortcode `[agenda_eventos]`. El servidor WordPress consulta `GET /api/eventos`; la tabla muestra título, categoría, lugar, fecha y estado. Elegí este endpoint porque reúne los datos necesarios para entender y escoger una actividad. La consulta se hace desde el servidor de WordPress para no exponer credenciales de base de datos en el navegador.”

“En una pantalla de computador se ve como tabla; en teléfono cada fila pasa a una tarjeta con etiquetas para que no sea necesario desplazarse horizontalmente. Aquí cambio al ancho móvil y verifico que la información siga legible.”

**Demostración:** navega las cuatro páginas, muestra ajustes del plugin/URL, tabla con filas reales y emulación móvil. Muestra también el banner y reproduce el video de presentación ya grabado e insertado en Inicio.

## 15:00–16:30 — Dificultades y conclusiones

**En pantalla:** página de cierre o portada del proyecto.

“El principal aprendizaje fue diseñar primero las relaciones para evitar duplicar información y después exponer las operaciones con validaciones. También aprendí a separar las credenciales del código y a probar errores, no solo el caso exitoso. Una dificultad fue [describe una dificultad real] y la resolví mediante [solución real].”

“Como mejora futura propondría autenticación para las operaciones de escritura, paginación para listas grandes, límites de cupo en inscripciones y monitoreo de disponibilidad. La agenda demuestra el recorrido completo desde el modelo relacional hasta la presentación de los datos en WordPress. Gracias.”

## Antes de grabar

- Sustituye todos los campos entre corchetes con datos verdaderos.
- Verifica que DB y API cloud estén accesibles desde la red pública.
- Importa y ejecuta la colección; conserva las respuestas de cada petición.
- Importa las páginas, activa el tema y el plugin, y sube tu propio video al Inicio.
- Muestra la cámara activa, revisa audio, duración y resolución antes de entregar.
- No muestres contraseñas, tokens ni credenciales durante la grabación.
