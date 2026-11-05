if (curtain_active) 
{
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    
    shader_reset();
    gpu_set_colorwriteenable(true, true, true, true);
    gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha);
    
    var _curtain_color = c_black; 
    
    // НАСТРОЙКА: Дополнительное растяжение хвоста шторки. 
    // 1.0 = родные 128 пикселей, 2.0 = 256 пикселей и т.д.
    var _stretch_x = 2.0; 
    
    // Вычисляем итоговую ширину шторки
    var _curtain_width = sprite_get_width(sprScreenCurtainHor) * _stretch_x;
    
    // 1. Рисуем левую плотную плиту (от 0 до curtain_x)
    draw_set_color(_curtain_color);
    draw_set_alpha(1.0);
    draw_rectangle(0, 0, curtain_x, _gui_h, false);
    
    // 2. Рисуем шторку фиксированной ширины впереди плиты
    if (curtain_x < _gui_w)
    {
        draw_sprite_stretched_ext(
            sprScreenCurtainHor, 0,
            curtain_x, 0,             // Начинается строго на стыке с плитой
            _curtain_width, _gui_h,   // Имеет стабильную ширину и растянута по высоте GUI
            _curtain_color, 1.0       // Перекрашиваем белый спрайт в черный
        );
    }
    
    // СБРОС НАСТРОЕК ГРАФИКИ
    draw_set_alpha(1);
    draw_set_color(c_white);
    gpu_set_blendmode(bm_normal);
}
