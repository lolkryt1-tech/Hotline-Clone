// ... твой старый код рассвета (fade_darkness) остаётся без изменений ...
if (fade_darkness > 0) 
{
    shader_reset();
    gpu_set_colorwriteenable(true, true, true, true);
    gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha);
    draw_set_color(c_black);
    draw_set_alpha(fade_darkness);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    gpu_set_blendmode(bm_normal);
}

// === ОТРИСОВКА ШТОРКИ С НАСТРОЙКОЙ РАСТЯЖЕНИЯ ===
if (state == CAMSTATES.LEVEL_END) 
{
    var _gui_w = display_get_gui_width();
    
    shader_reset();
    gpu_set_colorwriteenable(true, true, true, true);
    gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha); // Включаем прозрачность
    
    // НАСТРОЙКИ: Цвет и дополнительное растяжение хвоста по вертикали
    var _curtain_color = c_black; 
    var _stretch_y = 2.5;
    
    // Вычисляем финальную высоту градиента с учетом растяжения
    var _final_fade_height = sprite_get_height(sprScreenCurtain) * _stretch_y;
    
    // 1. Рисуем верхнюю плотную плиту под цвет занавески (черный)
    draw_set_color(_curtain_color);
    draw_set_alpha(1.0);
    draw_rectangle(0, 0, _gui_w, curtain_y, false);
    
    // 2. Рисуем наш белый спрайт-градиент, окрашивая его на лету в c_black и растягивая по осям
    draw_sprite_stretched_ext(
        sprScreenCurtain, 0,           // Спрайт и кадр
        0, curtain_y,            // Координаты X и Y (стык с плитой)
        _gui_w, _final_fade_height, // Растягиваем по ширине экрана и кастомно по высоте
        _curtain_color, 1.0      // Окрашиваем в черный, альфа 1.0
    );
    
    // СБРОС НАСТРОЕК ГРАФИКИ
    draw_set_alpha(1);
    draw_set_color(c_white);
    gpu_set_blendmode(bm_normal);
}
