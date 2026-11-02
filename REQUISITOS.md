# Matriz de cumplimiento del Taller Integrador

Estados: **Listo localmente**, **Preparado**, **Pendiente externo**. “Preparado” significa que existen los archivos y pasos, pero falta validarlos dentro de una instancia WordPress real. No se presentan URLs ni evidencias inventadas.

## Fase 1 — Base de datos

| Requisito | Estado | Evidencia |
|---|---|---|
| Cinco tablas relacionadas con PK | Listo localmente | `database.sql`: persona, categoria, lugar, evento, inscripcion |
| FK con acciones de borrado/actualización | Listo localmente | ON DELETE RESTRICT / ON UPDATE CASCADE |
| Restricciones UNIQUE | Listo localmente | cédula, correo, categoría, lugar y par de inscripción |
| Normalización 1FN–3FN justificada | Listo | `README.md`, apartado Modelo y relaciones |
| Diez filas por tabla | Listo localmente | 10 personas, categorías, lugares y eventos; 15 inscripciones |
| Finalidad de tablas y relaciones | Listo | `README.md` y comentarios SQL |
| Script de estructura e inserción | Listo | `database.sql` |
| Scripts ejecutados y consultas JOIN verificadas | Listo localmente | Importados en MariaDB; conteos y dos JOIN correctos |
| Instancia cloud y acceso remoto externo | Pendiente externo | Hace falta crear/configurar cuenta e instancia y probar conexión remota |

## Fase 2 — API REST

| Requisito | Estado | Evidencia |
|---|---|---|
| Node, Express, MySQL con estructura MVC | Listo localmente | `index.js` y `src/{config,models,controllers,routes}` |
| CRUD para las cinco tablas | Listo localmente | Rutas genéricas `/api/{recurso}`; CRUD probado para los cinco recursos |
| JSON consistente y estados HTTP | Listo localmente | 200, 201, 400, 404, 409 y 500 |
| Credenciales por variables de entorno | Listo localmente | `.env.example`; `.env` excluido en `.gitignore` |
| Validación y errores de datos/relaciones | Listo localmente | Casos 400, 404, UNIQUE 409 y FK 409 probados |
| README de instalación y endpoints | Listo | `README.md` |
| Conexión a DB cloud y API pública | Pendiente externo | Requiere host/credenciales de DB y servicio de publicación |
| Código fuente publicado en GitHub | Listo | Repositorio público `hmnoscarrillo/agenda-comunitaria-api`; snapshot sanitizado publicado |

## Fase 3 — Postman / Insomnia

| Requisito | Estado | Evidencia |
|---|---|---|
| Tabla principal y justificación | Listo | Se eligió `evento`: dos FK y relación con inscripciones; explicado en README |
| CRUD, lista, individuo, error y verificación tras borrar | Preparado | `postman/Agenda Comunitaria.postman_collection.json` tiene 7 solicitudes encadenadas |
| Exportación JSON importable | Listo | Colección validada como JSON |
| Respuestas ejecutadas en Postman/Insomnia | Pendiente externo | Se probaron los mismos flujos HTTP localmente; falta ejecutar y capturar desde la aplicación elegida |
| Capturas organizadas | Pendiente externo | Requieren capturas del equipo/cliente de pruebas |

## Fase 4 — WordPress

| Requisito | Estado | Evidencia |
|---|---|---|
| Instalación local y acceso al administrador | Parcial | XAMPP/PHP 8.5.12 y WordPress copiado en `C:\xampp\htdocs\agenda`; tema/plugin copiados. Falta iniciar Apache y completar asistente/importación |
| Cuatro páginas y navegación | Preparado | Tema `wordpress-theme/agenda-comunitaria/` y WXR `wordpress-content/agenda-pages.xml` |
| Plugin y consumo de datos reales | Preparado | `wordpress-plugin/agenda-api/`; shortcode `[agenda_eventos]` consume `/api/eventos` |
| Tabla responsive | Implementada en código | CSS cambia filas a tarjetas en pantallas pequeñas; falta QA visual en WordPress |
| Banner e imágenes | Preparado | Tema SVG incluido y WXR con páginas |
| Video en Inicio y evidencias de instalación | Pendiente externo | La página incluye el espacio; el equipo debe insertar video propio y tomar capturas |
| Backup final de WordPress (carpeta y BD) | Pendiente externo | Depende de instalar/importar el sitio y exportar su BD/carpeta real |

## Fase 5 — Video

| Requisito | Estado | Evidencia |
|---|---|---|
| Guion con secciones y demostraciones de 15+ minutos | Preparado | `wordpress-content/guion-video.md`, plan de 16–18 minutos |
| Grabación con cámara activa y entrega | Pendiente externo | Debe grabarla y personalizarla el estudiante; no se genera evidencia personal falsa |

## Comprobaciones realizadas

- MariaDB local cargó sin errores; cada tabla tiene al menos diez registros.
- `/health` devolvió API y base disponibles; GET `/api/eventos` devolvió diez filas.
- CRUD probado por HTTP para persona, categoría, lugar, evento e inscripción.
- Casos probados: validación 400, inexistente 404, UNIQUE 409 y FK 409.
- Sintaxis JavaScript y JSON/XML de la colección, WXR y paquete validados.
- No se añadió `.env` ni `node_modules` al paquete comprimido.


