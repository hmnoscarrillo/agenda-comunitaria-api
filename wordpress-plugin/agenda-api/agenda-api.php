<?php
/**
 * Plugin Name: Agenda Comunitaria API
 * Description: Muestra eventos reales de la API Agenda Comunitaria mediante [agenda_eventos].
 * Version: 1.0.0
 * Requires PHP: 7.4
 */

if (!defined('ABSPATH')) { exit; }

function agenda_api_events_shortcode() {
    $base = defined('AGENDA_API_BASE_URL') ? untrailingslashit(AGENDA_API_BASE_URL) : 'http://127.0.0.1:3000';
    $url = $base . '/api/eventos';

    $context = stream_context_create(array(
        'http' => array(
            'method'  => 'GET',
            'header'  => "Accept: application/json\r\nConnection: close\r\n",
            'timeout' => 5
        )
    ));

    $body = @file_get_contents($url, false, $context);

    if ($body === false) {
        // Alternativa con wp_remote_get
        $response = wp_remote_get($url, array('timeout' => 5));
        if (is_wp_error($response)) {
            return '<p class="agenda-api-message" role="status">No se pudo conectar con la agenda. Inténtalo más tarde.</p>';
        }
        $body = wp_remote_retrieve_body($response);
    }

    $payload = json_decode($body, true);
    if (empty($payload['success']) || !isset($payload['data']) || !is_array($payload['data'])) {
        return '<p class="agenda-api-message" role="status">La agenda no está disponible en este momento.</p>';
    }
    if (!$payload['data']) { return '<p class="agenda-api-message">Aún no hay eventos publicados.</p>'; }

    $html = '<div class="agenda-api-wrap"><table class="agenda-api-table"><caption>Eventos comunitarios programados</caption><thead><tr><th>Evento</th><th>Categoría</th><th>Lugar</th><th>Fecha</th><th>Estado</th></tr></thead><tbody>';
    foreach ($payload['data'] as $event) {
        $date = !empty($event['fecha_inicio']) ? wp_date('d/m/Y H:i', strtotime($event['fecha_inicio'])) : '';
        $html .= '<tr><td data-label="Evento">' . esc_html($event['titulo'] ?? '') . '</td>';
        $html .= '<td data-label="Categoría">' . esc_html($event['categoria'] ?? '') . '</td>';
        $html .= '<td data-label="Lugar">' . esc_html($event['lugar'] ?? '') . '</td>';
        $html .= '<td data-label="Fecha">' . esc_html($date) . '</td>';
        $html .= '<td data-label="Estado">' . esc_html($event['estado'] ?? '') . '</td></tr>';
    }
    return $html . '</tbody></table></div>';
}
add_shortcode('agenda_eventos', 'agenda_api_events_shortcode');

function agenda_api_register_styles() {
    wp_register_style('agenda-api', plugin_dir_url(__FILE__) . 'agenda-api.css', array(), '1.0.0');
    wp_enqueue_style('agenda-api');
}
add_action('wp_enqueue_scripts', 'agenda_api_register_styles');
