// --- ОТРИСОВКА НЕОНОВОЙ НАДПИСИ "GO TO CAR" ---
if (go_to_car_alpha > 0)
{
    // 1. Запоминаем текущие настройки холста
    var _old_m_font   = draw_get_font();
    var _old_m_color  = draw_get_color();
    var _old_m_halign = draw_get_halign();
    var _old_m_valign = draw_get_valign();
    var _old_m_alpha  = draw_get_alpha();

    // 2. Настраиваем шрифт и выравнивание строго ПО ЦЕНТРУ
    draw_set_font(fntCombo); 
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Применяем плавную альфу менеджера
    draw_set_alpha(go_to_car_alpha);

    // Вычисляем координаты (центр экрана, нижняя треть)
    var _text_x = display_get_gui_width() / 2;
    var _text_y = display_get_gui_height() - 100; 
    
    var _go_text = "GO TO CAR";

    // 3. Рисуем ЖИРНУЮ ЧЁРНУЮ ОБВОДКУ (толщина 2 пикселя)
    draw_set_color(c_black);
    draw_text(_text_x - 2, _text_y,     _go_text);
    draw_text(_text_x + 2, _text_y,     _go_text);
    draw_text(_text_x,     _text_y - 2, _go_text);
    draw_text(_text_x,     _text_y + 2, _go_text);
    draw_text(_text_x - 1, _text_y - 1, _go_text);
    draw_text(_text_x + 1, _text_y - 1, _go_text);
    draw_text(_text_x - 1, _text_y + 1, _go_text);
    draw_text(_text_x + 1, _text_y + 1, _go_text);

    // 4. Рисуем ОСНОВНОЙ НЕОНОВЫЙ ТЕКСТ (Ярко-розовый)
    var _neon_pink = make_color_rgb(255, 0, 128); 
    draw_set_color(_neon_pink);
    draw_text(_text_x, _text_y, _go_text);

    // 5. Полностью возвращаем настройки холста назад
    draw_set_font(_old_m_font);
    draw_set_color(_old_m_color);
    draw_set_halign(_old_m_halign);
    draw_set_valign(_old_m_valign);
    draw_set_alpha(_old_m_alpha);
}