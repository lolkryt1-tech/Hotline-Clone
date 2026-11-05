var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// === ПОДГОТОВКА ===

draw_set_font(fntMainMenu);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

// === ФОН ===

draw_set_color(c_black);
draw_set_alpha(0.95);
draw_rectangle(0, 0, _gui_w, _gui_h, false);

// === СТРАНИЦА ===

if (transition_active)
{
    // Во время перехода рисуем обе страницы
    scrSettingsDrawHome(id, _gui_w);
    scrSettingsDrawPage(id, _gui_w, _gui_h);
}
else if (current_page == SETTINGS_PAGE.HOME)
{
    scrSettingsDrawHome(id, _gui_w);
}
else
{
    scrSettingsDrawPage(id, _gui_w, _gui_h);
}


// === СБРОС ===

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);