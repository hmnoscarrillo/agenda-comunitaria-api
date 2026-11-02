<?php
if (!defined('ABSPATH')) { exit; }
function agenda_theme_setup() {
    add_theme_support('title-tag');
    add_theme_support('post-thumbnails');
    add_theme_support('html5', array('search-form', 'comment-form', 'comment-list', 'gallery', 'caption', 'style', 'script'));
    register_nav_menus(array('primary' => __('Navegación principal', 'agenda-comunitaria')));
}
add_action('after_setup_theme', 'agenda_theme_setup');
function agenda_theme_assets() { wp_enqueue_style('agenda-theme', get_stylesheet_uri(), array(), '1.0.0'); }
add_action('wp_enqueue_scripts', 'agenda_theme_assets');
function agenda_fallback_menu() {
    $pages = array('inicio' => 'Inicio', 'proyecto' => 'Proyecto', 'actividades' => 'Actividades', 'api-eventos' => 'Consumo de API');
    echo '<ul class="nav-links">';
    foreach ($pages as $slug => $label) {
        $page = get_page_by_path($slug);
        if ($page) { printf('<li class="%s"><a href="%s">%s</a></li>', is_page($page->ID) ? 'current_page_item' : '', esc_url(get_permalink($page)), esc_html($label)); }
    }
    echo '</ul>';
}
