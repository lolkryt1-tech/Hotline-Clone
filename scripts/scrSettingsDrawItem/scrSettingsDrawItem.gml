/// @function scrSettingsDrawItem(_x, _y, _text, _selected)
/// @description Отрисовывает пункт меню с учётом выделения.

function scrSettingsDrawItem(_x, _y, _text, _selected)
{
    draw_set_color(_selected ? make_color_rgb(255, 210, 60) : c_white);

    if (_selected) _text = "> " + _text;

    draw_text(_x, _y, _text);
}