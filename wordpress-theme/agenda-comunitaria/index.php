<?php get_header(); ?>
<?php if (have_posts()) : while (have_posts()) : the_post(); ?>
<section class="content-shell"><article <?php post_class(); ?>><h1 class="page-title"><?php the_title(); ?></h1><?php the_content(); ?></article></section>
<?php endwhile; else : ?><section class="content-shell"><h1>No encontramos esa página</h1></section><?php endif; ?>
<?php get_footer(); ?>
