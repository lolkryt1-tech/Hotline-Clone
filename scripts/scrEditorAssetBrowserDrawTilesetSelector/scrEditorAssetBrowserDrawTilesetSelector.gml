
/// @function scrEditorAssetBrowserDrawTilesetSelector()
/// @description Отрисовка выбора Tile Set и выпадающего списка.

function scrEditorAssetBrowserDrawTilesetSelector(
    _x,
    _tileset_w,
    _bottom_y,
    _color_text,
    _color_panel,
    _color_border,
    _color_hover
)
{
    // === TILESET ===
    draw_set_color(_color_text);
    draw_set_halign(fa_left);
    draw_text(_x, _bottom_y, "TILESET");

    var _tileset_button_y = _bottom_y + 18;

    draw_set_color(_color_panel);
    draw_rectangle(
        _x,
        _tileset_button_y,
        _x + _tileset_w,
        _tileset_button_y + 28,
        false
    );

    draw_set_color(_color_border);
    draw_rectangle(
        _x,
        _tileset_button_y,
        _x + _tileset_w,
        _tileset_button_y + 28,
        true
    );

    draw_set_color(_color_text);
    draw_set_valign(fa_middle);
    draw_set_halign(fa_left);

    draw_text(
        _x + 8,
        _tileset_button_y + 14,
        selected_tileset == "" ? "No Tile Sets" : selected_tileset
    );

    draw_set_halign(fa_right);
    draw_text(
        _x + _tileset_w - 8,
        _tileset_button_y + 14,
        tileset_dropdown_open ? "▲" : "▼"
    );

    // === TILESET: РАСКРЫТЫЙ СПИСОК ===
    if (tileset_dropdown_open)
    {
        var _option_y = _tileset_button_y + 28;

        for (var i = 0; i < array_length(tileset_names); i++)
        {
            var _option_hover = point_in_rectangle(
                device_mouse_x_to_gui(0),
                device_mouse_y_to_gui(0),
                _x,
                _option_y + i * 24,
                _x + _tileset_w,
                _option_y + (i + 1) * 24
            );

            draw_set_color(_option_hover ? _color_hover : _color_panel);

            draw_rectangle(
                _x,
                _option_y + i * 24,
                _x + _tileset_w,
                _option_y + (i + 1) * 24,
                false
            );

            draw_set_color(_color_border);

            draw_rectangle(
                _x,
                _option_y + i * 24,
                _x + _tileset_w,
                _option_y + (i + 1) * 24,
                true
            );

            draw_set_color(_color_text);
            draw_set_halign(fa_left);

            draw_text(
                _x + 8,
                _option_y + i * 24 + 12,
                tileset_names[i]
            );
        }
    }

    // === ВОССТАНОВЛЕНИЕ НАСТРОЕК ===
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_alpha(1);
}
