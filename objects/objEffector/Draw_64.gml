if (fade_darkness > 0) {
    draw_set_alpha(1);
    draw_set_color(c_red);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
}