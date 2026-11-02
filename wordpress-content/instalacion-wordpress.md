# Instalación y configuración del sitio WordPress

Este equipo no tenía WordPress, XAMPP, Laragon ni LocalWP instalados cuando se preparó el material. Por eso esta guía y los archivos de sitio quedan listos para importar, pero la instalación local y sus capturas todavía deben hacerse en el equipo del estudiante.

## Preparar el sitio local

1. Instala una herramienta local aceptada por el curso (XAMPP, Laragon, LocalWP o WampServer). Registra el nombre y la versión exacta que aparezcan en su instalador/panel; no inventes una versión en el informe.
2. Inicia Apache y MySQL/MariaDB desde el panel de la herramienta.
3. Crea la base de WordPress en phpMyAdmin, por ejemplo `wordpress_agenda`, con cotejamiento `utf8mb4_unicode_ci`.
4. Instala WordPress en una carpeta del servidor local (por ejemplo `htdocs/agenda-wp`), crea `wp-config.php` apuntando a `wordpress_agenda` y termina el asistente web.
5. Captura el panel de servicios, la base vacía de WordPress, el formulario de configuración inicial y el acceso al escritorio de administración. Oculta contraseñas.
6. En **Apariencia → Temas**, sube/activa `agenda-comunitaria.zip` (contenido de `wordpress-theme/agenda-comunitaria`).
7. En **Plugins → Añadir nuevo → Subir plugin**, sube/activa `agenda-api.zip` (contenido de `wordpress-plugin/agenda-api`).
8. Importa `wordpress-content/agenda-pages.xml` desde **Herramientas → Importar → WordPress**. Si solicita instalar WordPress Importer, instálalo desde el panel.
9. En **Ajustes → Lectura**, usa una página estática como portada y selecciona **Inicio**. El tema ofrece navegación automática a Inicio, Proyecto, Actividades y Consumo de API; también puedes crear un menú en **Apariencia → Menús** y asignarlo a Navegación principal.
10. En `wp-config.php`, define la URL de API accesible desde el servidor WordPress:

```php
define('AGENDA_API_BASE_URL', 'https://TU-API-PUBLICA');
```

Para una prueba en el mismo equipo puedes usar `http://localhost:3000`; si WordPress está en otro contenedor/VM, usa el host accesible desde esa instancia, no `localhost`.

11. Abre la página **Consumo de API** y verifica que aparezcan los 10 eventos. Si no, comprueba `/health`, `/api/eventos` y la URL configurada. El shortcode es `[agenda_eventos]`.
12. Graba el video de exposición, súbelo a **Medios**, edita Inicio y reemplaza la nota “Video de presentación” por un bloque Video. Prueba reproducción con sonido y en móvil.

## Capturas requeridas

- Herramienta local y versión instalada.
- Servicios Apache/MySQL iniciados y base local de WordPress.
- Asistente y escritorio de administración.
- Las cuatro páginas en navegador y menú de navegación.
- Ajuste de la URL del API/plugin, tabla con datos reales y respuesta móvil.
- Pruebas Postman con respuestas, incluidos error y confirmación 404 posterior al DELETE.
- Cliente conectado a MySQL cloud con host (sin contraseña), conteos y dos JOIN.
- API pública respondiendo y URL visible.

El archivo WXR crea contenido y páginas, no lleva credenciales ni una copia de base WordPress ya instalada. Para el backup final usa las herramientas export/import de tu entorno local y entrega el dump de WordPress junto con la carpeta comprimida del sitio y el proyecto.
