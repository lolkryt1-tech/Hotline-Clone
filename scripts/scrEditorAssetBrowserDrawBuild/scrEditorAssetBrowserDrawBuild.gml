
/// @function scrEditorAssetBrowserDrawBuild()
/// @description Отрисовка интерфейса BUILD.

function scrEditorAssetBrowserDrawBuild()
{
    // === ЦВЕТА ===
    var _color_text = make_color_rgb(230, 230, 235);
    var _color_inactive = make_color_rgb(155, 155, 165);
    var _color_panel = make_color_rgb(35, 35, 40);
    var _color_border = make_color_rgb(67, 67, 75);
    var _color_active = make_color_rgb(75, 99, 137);
    var _color_hover = make_color_rgb(58, 58, 65);
    var _color_scroll = make_color_rgb(95, 95, 105);

    var _margin = 12;
    var _x = window_x + _margin;
    var _w = window_width - _margin * 2;
    var _content_top = window_y + header_height + tabs_height;

    // === TYPE ===
    var _type_y = _content_top + 8;
    var _button_w = 58;
    var _button_h = 22;

    var _tiles_x = window_x + window_width - _button_w * 2 - 20;
    var _walls_x = window_x + window_width - _button_w - _margin;

    draw_set_color(build_type == "TILES" ? _color_active : _color_panel);
    draw_roundrect(_tiles_x, _type_y, _tiles_x + _button_w, _type_y + _button_h, false);

    draw_set_color(build_type == "WALLS" ? _color_active : _color_panel);
    draw_roundrect(_walls_x, _type_y, _walls_x + _button_w, _type_y + _button_h, false);

    draw_set_color(_color_text);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_tiles_x + _button_w * 0.5, _type_y + _button_h * 0.5, "TILES");
    draw_text(_walls_x + _button_w * 0.5, _type_y + _button_h * 0.5, "WALLS");

    // === ИНСТРУМЕНТЫ ===

    var _workspace = instance_find(objEditorWorkspace, 0);
    var _active_tool = "PENCIL";

    if (_workspace != noone) _active_tool = _workspace.active_tool;

    var _tool_size = 22;
    var _tool_gap = 5;
    var _tool_y = _type_y;

    var _pencil_x = _x;
    var _rectangle_x = _pencil_x + _tool_size + _tool_gap;

    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);

    // === PENCIL ===

    var _pencil_hover = point_in_rectangle(
        _mouse_gui_x, _mouse_gui_y,
        _pencil_x, _tool_y,
        _pencil_x + _tool_size, _tool_y + _tool_size
    );

    var _pencil_color = _color_panel;
    if (_active_tool == "PENCIL") _pencil_color = _color_active;
    else if (_pencil_hover) _pencil_color = _color_hover;

    draw_set_color(_pencil_color);
    draw_roundrect(_pencil_x, _tool_y, _pencil_x + _tool_size, _tool_y + _tool_size, false);

    draw_set_color(_color_border);
    draw_roundrect(_pencil_x, _tool_y, _pencil_x + _tool_size, _tool_y + _tool_size, true);

    // Центрируем спрайт независимо от его origin
    draw_sprite(
        sprPencil,
        0,
        _pencil_x + (_tool_size - 19) * 0.5 + sprite_get_xoffset(sprPencil),
        _tool_y + (_tool_size - 18) * 0.5 + sprite_get_yoffset(sprPencil)
    );

    // === RECTANGLE ===

    var _rectangle_hover = point_in_rectangle(
        _mouse_gui_x, _mouse_gui_y,
        _rectangle_x, _tool_y,
        _rectangle_x + _tool_size, _tool_y + _tool_size
    );

    var _rectangle_color = _color_panel;
    if (_active_tool == "RECTANGLE") _rectangle_color = _color_active;
    else if (_rectangle_hover) _rectangle_color = _color_hover;

    draw_set_color(_rectangle_color);
    draw_roundrect(_rectangle_x, _tool_y, _rectangle_x + _tool_size, _tool_y + _tool_size, false);

    draw_set_color(_color_border);
    draw_roundrect(_rectangle_x, _tool_y, _rectangle_x + _tool_size, _tool_y + _tool_size, true);

    // Полностью залитый белый квадрат
    draw_set_color(c_white);
    draw_rectangle(
        _rectangle_x + 6,
        _tool_y + 6,
        _rectangle_x + 16,
        _tool_y + 16,
        false
    );

    // === ПАЛИТРА ТАЙЛОВ ===
    var _palette_x = _x;
    var _palette_y = _content_top + 40;
    var _palette_w = _w;
    var _palette_h = window_y + window_height - 132 - _palette_y;

    scrEditorAssetBrowserDrawTilesetPalette(
        _palette_x,
        _palette_y,
        _palette_w,
        _palette_h,
        _color_panel,
        _color_border
    );

    // === НИЖНИЕ ПАНЕЛИ ===
    var _bottom_y = window_y + window_height - 112;
    var _tileset_w = _w * 0.38;
    var _layers_x = _x + _tileset_w + 10;
    var _layers_w = _w - _tileset_w - 10;

    // === TILESET SELECTOR ===
    scrEditorAssetBrowserDrawTilesetSelector(
        _x,
        _tileset_w,
        _bottom_y,
        _color_text,
        _color_panel,
        _color_border,
        _color_hover
    );

    // === TILE LAYERS ===
    scrEditorAssetBrowserDrawTileLayers(
        _layers_x,
        _layers_w,
        _bottom_y,
        _color_text,
        _color_inactive,
        _color_panel,
        _color_border,
        _color_active,
        _color_scroll
    );

    // === ВОССТАНОВЛЕНИЕ НАСТРОЕК ===
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_alpha(1);
}
