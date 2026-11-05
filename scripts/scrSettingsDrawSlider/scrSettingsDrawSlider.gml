/// @function scrSettingsDrawSlider(_x, _y, _width, _height, _value, _selected)
/// @description Отрисовывает ползунок громкости.

function scrSettingsDrawSlider(_x, _y, _width, _height, _value, _selected)
{
    // Цвет заполненной части
    var _color = _selected ? make_color_rgb(255, 210, 60) : c_white;

    // === ОСНОВА ===

    draw_set_color(make_color_rgb(65, 65, 65));

    draw_rectangle(_x, _y - _height * 0.5, _x + _width, _y + _height * 0.5, false);

    // === ЗАПОЛНЕНИЕ ===

    draw_set_color(_color);

    draw_rectangle(_x, _y - _height * 0.5, _x + _width * _value, _y + _height * 0.5, false);
}