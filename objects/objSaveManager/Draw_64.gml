/*
if (fade_alpha > 0.005) 
{
    draw_set_color(c_black);
    draw_set_alpha(fade_alpha);
    
    // Рисуем на всю область GUI
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    
    // Обязательно сбрасываем альфу в 1, чтобы остальной интерфейс не стал прозрачным
    draw_set_alpha(1.0);
}
