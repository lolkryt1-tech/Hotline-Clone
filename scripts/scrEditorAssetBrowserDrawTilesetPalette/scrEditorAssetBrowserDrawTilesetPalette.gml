
/// @function scrEditorAssetBrowserDrawTilesetPalette(_palette_x, _palette_y, _palette_w, _palette_h, _color_panel, _color_border)
/// @description Отрисовка палитры Tile Set.

function scrEditorAssetBrowserDrawTilesetPalette(
    _palette_x,
    _palette_y,
    _palette_w,
    _palette_h,
    _color_panel,
    _color_border
)
{
    // === ФОН ПАЛИТРЫ ===
    draw_set_color(_color_panel);
    draw_rectangle(
        _palette_x,
        _palette_y,
        _palette_x + _palette_w,
        _palette_y + _palette_h,
        false
    );

    draw_set_color(_color_border);
    draw_rectangle(
        _palette_x,
        _palette_y,
        _palette_x + _palette_w,
        _palette_y + _palette_h,
        true
    );

    if (build_type != "TILES") return;
    if (selected_tileset_sprite == -1) return;

    // === ОТОБРАЖЕНИЕ TILE SET ===
    draw_set_color(c_white);
    draw_set_alpha(1);

    // === ОГРАНИЧЕНИЕ ОБЛАСТИ ОТРИСОВКИ ===
    var _old_scissor = gpu_get_scissor();

    // Переводим координаты GUI в координаты окна
    var _scale_x = window_get_width() / display_get_gui_width();
    var _scale_y = window_get_height() / display_get_gui_height();

    // Границы палитры
    var _clip_x = floor(_palette_x * _scale_x);
    var _clip_y = floor(_palette_y * _scale_y);
    var _clip_right = ceil((_palette_x + _palette_w) * _scale_x);
    var _clip_bottom = ceil((_palette_y + _palette_h) * _scale_y);

    // Учитываем уже существующую область отсечения
    _clip_x = max(_clip_x, _old_scissor.x);
    _clip_y = max(_clip_y, _old_scissor.y);

    _clip_right = min(_clip_right, _old_scissor.x + _old_scissor.w);
    _clip_bottom = min(_clip_bottom, _old_scissor.y + _old_scissor.h);

    gpu_set_scissor(
        _clip_x,
        _clip_y,
        max(0, _clip_right - _clip_x),
        max(0, _clip_bottom - _clip_y)
    );

    // === ОТРИСОВКА TILE SET ===
    var _grid_x = _palette_x + 1 + tileset_scroll_x;
    var _grid_y = _palette_y + 1 + tileset_scroll_y;

    draw_sprite_part_ext(
        selected_tileset_sprite,
        0,
        0,
        16,
        sprite_get_width(selected_tileset_sprite),
        sprite_get_height(selected_tileset_sprite) - 16,
        _grid_x,
        _grid_y,
        tileset_display_scale,
        tileset_display_scale,
        c_white,
        1
    );

    // === РАЗМЕРЫ СЕТКИ ===
    var _sprite_w = sprite_get_width(selected_tileset_sprite) * tileset_display_scale;
    var _sprite_h = (sprite_get_height(selected_tileset_sprite) - 16) * tileset_display_scale;

    var _tile_w = tileset_info.tile_width * tileset_display_scale;
    var _tile_h = tileset_info.tile_height * tileset_display_scale;

    var _columns = floor(_sprite_w / _tile_w);
    var _rows = floor(_sprite_h / _tile_h);

    // === ПОДСВЕТКА ВЫБРАННОГО ТАЙЛА ===
    if (selected_tile_x >= 0 && selected_tile_x < _columns
    && selected_tile_y >= 0 && selected_tile_y < _rows)
    {
        var _selected_x = _grid_x + selected_tile_x * _tile_w;
        var _selected_y = _grid_y + selected_tile_y * _tile_h;

        draw_set_color(make_color_rgb(255, 190, 65));
        draw_set_alpha(0.25);

        draw_rectangle(
            _selected_x,
            _selected_y,
            _selected_x + _tile_w,
            _selected_y + _tile_h,
            false
        );
    }

    // === ПОДСВЕТКА ТАЙЛА ПОД КУРСОРОМ ===
    if (hover_tile_x >= 0 && hover_tile_x < _columns
    && hover_tile_y >= 0 && hover_tile_y < _rows
    && (hover_tile_x != selected_tile_x || hover_tile_y != selected_tile_y))
    {
        var _hover_x = _grid_x + hover_tile_x * _tile_w;
        var _hover_y = _grid_y + hover_tile_y * _tile_h;

        draw_set_color(make_color_rgb(100, 170, 255));
        draw_set_alpha(0.25);

        draw_rectangle(
            _hover_x,
            _hover_y,
            _hover_x + _tile_w,
            _hover_y + _tile_h,
            false
        );
    }

    // === СЕТКА TILE SET ===
    draw_set_color(c_white);
    draw_set_alpha(0.35);

    // Вертикальные линии
    for (var i = 0; i <= _columns; i++)
    {
        var _line_x = _grid_x + i * _tile_w;
        draw_line(_line_x, _grid_y, _line_x, _grid_y + _sprite_h);
    }

    // Горизонтальные линии
    for (var i = 0; i <= _rows; i++)
    {
        var _line_y = _grid_y + i * _tile_h;
        draw_line(_grid_x, _line_y, _grid_x + _sprite_w, _line_y);
    }

    // === РАМКА ВЫБРАННОГО ТАЙЛА ===
    if (selected_tile_x >= 0 && selected_tile_x < _columns
    && selected_tile_y >= 0 && selected_tile_y < _rows)
    {
        var _selected_x = _grid_x + selected_tile_x * _tile_w;
        var _selected_y = _grid_y + selected_tile_y * _tile_h;

        draw_set_color(make_color_rgb(255, 190, 65));
        draw_set_alpha(1);

        draw_rectangle(
            _selected_x,
            _selected_y,
            _selected_x + _tile_w,
            _selected_y + _tile_h,
            true
        );
    }

    // === РАМКА ТАЙЛА ПОД КУРСОРОМ ===
    if (hover_tile_x >= 0 && hover_tile_x < _columns
    && hover_tile_y >= 0 && hover_tile_y < _rows)
    {
        var _hover_x = _grid_x + hover_tile_x * _tile_w;
        var _hover_y = _grid_y + hover_tile_y * _tile_h;

        draw_set_color(c_white);
        draw_set_alpha(1);

        draw_rectangle(
            _hover_x,
            _hover_y,
            _hover_x + _tile_w,
            _hover_y + _tile_h,
            true
        );
    }

    // === ВОССТАНОВЛЕНИЕ ОБЛАСТИ ОТРИСОВКИ ===
    gpu_set_scissor(_old_scissor);

    draw_set_alpha(1);
    draw_set_color(c_white);
}
