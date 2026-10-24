if (fade_darkness > 0) 
{
    // Принудительно сбрасываем всё, что могло сломаться
    shader_reset();
    gpu_set_colorwriteenable(true, true, true, true);
    
    // Включаем правильное смешивание для прозрачности
    gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha);
    
    draw_set_color(c_black);
    draw_set_alpha(fade_darkness);
    
    // Рисуем прямоугольник на весь экран
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    
    // СБРОС
    draw_set_alpha(1);
    draw_set_color(c_white);
    gpu_set_blendmode(bm_normal);
}