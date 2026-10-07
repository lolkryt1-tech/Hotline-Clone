function scrDrawTextStyled(_x, _y, _text, _font, _color)
{
    // 1. Запоминаем старые настройки
    var _old_font  = draw_get_font();
    var _old_color = draw_get_color();
    
    // 2. Применяем нужные параметры
    draw_set_font(_font);
    draw_set_color(_color);
    
    // 3. Рисуем текст
    draw_text(_x, _y, _text);
    
    // 4. Сразу же возвращаем настройки назад
    draw_set_font(_old_font);
    draw_set_color(_old_color);
}