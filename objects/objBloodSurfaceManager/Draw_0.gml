// Проверяем, существует ли поверхность в видеопамяти
if (!surface_exists(global.surf_blood)) 
{
    // Создаем поверхность под размеры ТЕКУЩЕЙ комнаты с запасом х4
    global.surf_blood = surface_create(room_width * 2, room_height * 2);
    
    // Обязательно очищаем её от «мусора» видеокарты
    surface_set_target(global.surf_blood);
    draw_clear_alpha(c_black, 0);
    surface_reset_target();
}

// Отрисовываем кровь, сжимая ее обратно (0.25) для субпиксельного сглаживания
draw_surface_ext(global.surf_blood, 0, 0, 0.5, 0.5, 0, c_white, 1);
