// Рисуем только если альфа больше нуля
if (darken_alpha > 0.001)
{
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    
    // === 1. ЗАТЕМНЕНИЕ С ЛЕРПОМ ===
    draw_set_color(c_black);
    draw_set_alpha(darken_alpha * 0.7);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1.0);
    
    // === 2. ЦЕНТРИРОВАНИЕ ТЕКСТА ===
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // === 3. СМЕЩЕНИЕ ПУНКТОВ ПРИ ВЪЕЗДЕ ===
    var _slide_offset = (1 - items_slide) * 60;   // сдвиг вниз на 60px при открытии
    
    // === 4. ЗАГОЛОВОК PAUSE ===
    var _title_y = _gui_h / 2 - 120 + _slide_offset;
    
    draw_set_color(c_black);
    draw_set_alpha(darken_alpha);
    draw_text(_gui_w / 2 + 2, _title_y + 2, "PAUSE");
    
    draw_set_color(c_white);
    draw_text(_gui_w / 2, _title_y, "PAUSE");
    
    // === 5. ПУНКТЫ МЕНЮ ===
    for (var i = 0; i < array_length(menu_items); i++)
    {
        var _y = _gui_h / 2 + (i * 50) + _slide_offset;
        
        if (i == selected_index)
        {
            // Выбранный: жёлтый + пульсация
            var _pulse = 0.7 + 0.3 * sin(current_time * 0.005);
            
            // Тень
            draw_set_color(c_black);
            draw_set_alpha(darken_alpha);
            draw_text(_gui_w / 2 + 2, _y + 2, "> " + menu_items[i] + " <");
            
            // Основной текст
            draw_set_color(make_color_rgb(255, 210, 60));
            draw_set_alpha(darken_alpha * _pulse);
            draw_text(_gui_w / 2, _y, "> " + menu_items[i] + " <");
        }
        else
        {
            // Не выбранный: серый
            draw_set_color(c_gray);
            draw_set_alpha(darken_alpha);
            draw_text(_gui_w / 2, _y, menu_items[i]);
        }
    }
    
    // === 6. СБРОС ===
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}