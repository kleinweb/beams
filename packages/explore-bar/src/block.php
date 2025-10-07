<?php
/**
 * Block Name: Explore Bar
 */

add_action('init', kleinweb_beams_explore_bar_register_block(...));
function kleinweb_beams_explore_bar_register_block(): void
{
    register_block_type(__DIR__);
}
