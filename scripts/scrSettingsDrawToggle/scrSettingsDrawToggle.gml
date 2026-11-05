/// @function scrSettingsDrawToggle(_x, _y, _width, _value, _selected)
/// @description Отрисовывает переключатель ON/OFF.

function scrSettingsDrawToggle(_x, _y, _width, _value, _selected)
{
    var _text = _value ? "ON" : "OFF";

    draw_set_color(_selected ? make_color_rgb(255, 210, 60) : c_white);

    draw_set_halign(fa_right);
    draw_text(_x + _width, _y, _text);
    draw_set_halign(fa_left);
}