<!doctype html>
<html <?php language_attributes(); ?>>
<head><meta charset="<?php bloginfo('charset'); ?>"><meta name="viewport" content="width=device-width, initial-scale=1"><?php wp_head(); ?></head>
<body <?php body_class(); ?>><?php wp_body_open(); ?>
<header class="site-header"><div class="nav-shell"><a class="brand" href="<?php echo esc_url(home_url('/')); ?>">Agenda Comunitaria</a><nav aria-label="Navegación principal"><?php if (has_nav_menu('primary')) { wp_nav_menu(array('theme_location'=>'primary','container'=>false,'menu_class'=>'nav-links','fallback_cb'=>'agenda_fallback_menu')); } else { agenda_fallback_menu(); } ?></nav></div></header>
<main id="contenido">
