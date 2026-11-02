# Instalación local preparada — Agenda Comunitaria

## Estado del equipo

WordPress está extraído en `C:\xampp\htdocs\agenda`; PHP CLI 8.5.12 está instalado en `C:\xampp\php`. El tema y el plugin están copiados en sus carpetas de WordPress. No se han iniciado Apache ni el MySQL incluido en XAMPP. El motor MariaDB portátil del proyecto ya ocupa el puerto 3306, por lo que no se debe iniciar el MySQL/MariaDB de XAMPP en ese puerto.

## Terminar la instalación

1. Desde el panel de XAMPP, inicia **Apache**. No inicies el componente MySQL de XAMPP mientras MariaDB portátil use el puerto 3306.
2. Abre `http://localhost/agenda` y completa el instalador de WordPress. Usa una base WordPress separada llamada `wordpress_agenda` en la instancia MariaDB existente; no importes `database.sql` sobre esa base, pues ese script reinicializa `agenda_comunitaria`.
3. En **Plugins**, activa **Agenda API**. En **Apariencia**, activa **Agenda Comunitaria**.
4. Importa `C:\api\wordpress-content\agenda-pages.xml` con el importador WordPress. Configura Inicio como página estática.
5. Define `AGENDA_API_BASE_URL` como `http://127.0.0.1:3000` en `wp-config.php` y abre Consumo de API. Comprueba que aparecen los diez eventos.
6. Revisa las páginas y navegación; inserta el video propio en Inicio cuando lo hayas grabado.

## Entrega de evidencias

Captura el panel con Apache activo, instalador y escritorio WordPress, las cuatro páginas, la tabla de eventos y la vista móvil. Exporta la base WordPress y comprime la carpeta del sitio para el backup. No incluyas contraseñas en las capturas ni en el repositorio.
