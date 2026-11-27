
/// @function scrEditorAssetBrowserDrawToolTooltip()
/// @description Отрисовка подсказок инструментов.

function scrEditorAssetBrowserDrawToolTooltip()
{
    if (tooltip_target == "" || tooltip_timer < tooltip_delay) return;

    var _text = "PENCIL (D)";
    if (tooltip_target == "RECTANGLE") _text = "RECTANGLE (R)";

    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);

    var _padding = 6;
    var _w = string_width(_text) + _padding * 2;
    var _h = 22;

    var _x = _mouse_x + 12;
    var _y = _mouse_y + 12;

    _x = clamp(_x, window_x + 6, window_x + window_width - _w - 6);
    _y = clamp(_y, window_y + 6, window_y + window_height - _h - 6);

    draw_set_alpha(tooltip_alpha);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    draw_set_color(make_color_rgb(35, 35, 40));
    draw_roundrect(_x, _y, _x + _w, _y + _h, false);

    draw_set_color(make_color_rgb(75, 75, 82));
    draw_roundrect(_x, _y, _x + _w, _y + _h, true);

    draw_set_color(make_color_rgb(230, 230, 235));
    draw_text(_x + _padding, _y + _h * 0.5, _text);

    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
