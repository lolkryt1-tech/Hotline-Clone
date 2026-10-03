if (is_paused) {
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    
    // 1. Рисуем затемнение
    draw_set_color(c_black);
    draw_set_alpha(0.4);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    
    // 2. Настраиваем и рисуем текст паузы
    draw_set_color(c_white);
    draw_set_alpha(1.0);
    draw_set_halign(fa_center); // Включаем центрирование
    draw_set_valign(fa_middle);
    
    draw_text(_gui_w / 2, _gui_h / 2, "PAUSE");
    
    // 3. СБРОС НАСТРОЕК (ВАЖНО!)
    // Возвращаем стандартное выравнивание: по левому краю и по верхнему краю
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}