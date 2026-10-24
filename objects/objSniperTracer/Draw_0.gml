if (!instance_exists(objLightController)) {
    // Сохраняем цвет и альфу
    var _prev_color = draw_get_color();
    var _prev_alpha = draw_get_alpha();
    
    draw_set_alpha(alpha);
    draw_set_color(c_white); // Белый цвет
    draw_line_width(x, y, target_x, target_y, 2);
    
    // Восстанавливаем
    draw_set_color(_prev_color);
    draw_set_alpha(_prev_alpha);
}