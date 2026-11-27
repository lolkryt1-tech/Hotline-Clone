/// @function scrEditorAssetBrowserHandleTileset()
/// @description Обрабатывает выбор тайлов, прокрутку и перемещение Tile Set.

function scrEditorAssetBrowserHandleTileset(
    _browser,
    _mouse_x,
    _mouse_y,
    _left_pressed,
    _middle_pressed,
    _middle_down,
    _middle_released,
    _wheel
)
{
    if (_browser.active_tab != "BUILD") return;
    if (build_type != "TILES") return;

    // === РАЗМЕРЫ ПАЛИТРЫ ===
    var _palette_x = window_x + 12;
    var _palette_y = window_y + header_height + tabs_height + 40;
    var _palette_w = window_width - 24;
    var _palette_h = window_y + window_height - 132 - _palette_y;

    var _mouse_over_palette =
        _mouse_x >= _palette_x && _mouse_x <= _palette_x + _palette_w
        && _mouse_y >= _palette_y && _mouse_y <= _palette_y + _palette_h;

    // === TILESET: ОПРЕДЕЛЕНИЕ ТАЙЛА ПОД КУРСОРОМ ===
    hover_tile_x = -1;
    hover_tile_y = -1;

    if (_mouse_over_palette
    && selected_tileset_sprite != -1
    && !is_undefined(tileset_info))
    {
        var _tile_w = tileset_info.tile_width * tileset_display_scale;
        var _tile_h = tileset_info.tile_height * tileset_display_scale;

        var _sprite_w = sprite_get_width(selected_tileset_sprite) * tileset_display_scale;
        var _sprite_h = (sprite_get_height(selected_tileset_sprite) - 16) * tileset_display_scale;

        var _grid_x = _palette_x + 1 + tileset_scroll_x;
        var _grid_y = _palette_y + 1 + tileset_scroll_y;

        var _local_x = _mouse_x - _grid_x;
        var _local_y = _mouse_y - _grid_y;

        if (_tile_w > 0 && _tile_h > 0
        && _local_x >= 0 && _local_y >= 0
        && _local_x < _sprite_w && _local_y < _sprite_h)
        {
            hover_tile_x = floor(_local_x / _tile_w);
            hover_tile_y = floor(_local_y / _tile_h);
        }

        // === ВЫБОР ТАЙЛА ===
        if (_left_pressed && hover_tile_x >= 0 && hover_tile_y >= 0)
        {
            selected_tile_x = hover_tile_x;
            selected_tile_y = hover_tile_y;

            var _columns = floor(_sprite_w / _tile_w);
            selected_tile_index = selected_tile_y * _columns + selected_tile_x;
        }
    }

    // === ПРОКРУТКА TILESET ===
    if (_wheel != 0 && _mouse_over_palette)
    {
        if (keyboard_check(vk_shift))
            tileset_scroll_x += _wheel * 32;
        else
            tileset_scroll_y += _wheel * 32;
    }

    // === НАЧАЛО ПЕРЕТАСКИВАНИЯ TILESET ===
    if (_middle_pressed && _mouse_over_palette)
    {
        tileset_pan_dragging = true;

        tileset_pan_start_x = _mouse_x;
        tileset_pan_start_y = _mouse_y;

        tileset_pan_start_scroll_x = tileset_scroll_x;
        tileset_pan_start_scroll_y = tileset_scroll_y;
    }

    // === ПЕРЕТАСКИВАНИЕ TILESET ===
    if (tileset_pan_dragging && _middle_down)
    {
        tileset_scroll_x = tileset_pan_start_scroll_x + (_mouse_x - tileset_pan_start_x);
        tileset_scroll_y = tileset_pan_start_scroll_y + (_mouse_y - tileset_pan_start_y);
    }

    if (_middle_released)
        tileset_pan_dragging = false;

    // === ОГРАНИЧЕНИЕ ПРОКРУТКИ TILESET ===
    if (selected_tileset_sprite != -1)
    {
        var _sprite_w = sprite_get_width(selected_tileset_sprite) * tileset_display_scale;
        var _sprite_h = (sprite_get_height(selected_tileset_sprite) - 16) * tileset_display_scale;

        var _min_scroll_x = min(0, _palette_w - _sprite_w);
        var _min_scroll_y = min(0, _palette_h - _sprite_h);

        tileset_scroll_x = clamp(tileset_scroll_x, _min_scroll_x, 0);
        tileset_scroll_y = clamp(tileset_scroll_y, _min_scroll_y, 0);
    }

    // === TILESET: РАСКРЫТИЕ СПИСКА ===
    var _margin = 12;

    var _tileset_x = window_x + _margin;
    var _tileset_y = window_y + window_height - 112;
    var _tileset_w = (window_width - 24) * 0.38;

    var _tileset_button_y = _tileset_y + 18;
    var _tileset_button_h = 28;
    var _tileset_option_h = 24;

    if (_left_pressed
    && _mouse_x >= _tileset_x && _mouse_x <= _tileset_x + _tileset_w
    && _mouse_y >= _tileset_button_y && _mouse_y <= _tileset_button_y + _tileset_button_h)
    {
        tileset_dropdown_open = !tileset_dropdown_open;
    }
    else if (_left_pressed && tileset_dropdown_open)
    {
        var _option_index = floor(
            (_mouse_y - (_tileset_button_y + _tileset_button_h)) / _tileset_option_h
        );

        if (_mouse_x >= _tileset_x && _mouse_x <= _tileset_x + _tileset_w
        && _option_index >= 0
        && _option_index < array_length(tileset_names))
        {
            // === ВЫБОР TILESET ===
            selected_tileset_index = _option_index;
            selected_tileset = tileset_names[selected_tileset_index];
            selected_tileset_sprite = tileset_sprite_ids[selected_tileset_index];

            tileset_scroll_x = 0;
            tileset_scroll_y = 0;

            // Сбрасываем выбор тайла
            hover_tile_x = -1;
            hover_tile_y = -1;

            selected_tile_x = -1;
            selected_tile_y = -1;
            selected_tile_index = -1;

            tileset_index = tileset_ids[selected_tileset_index];
            tileset_info = tileset_get_info(tileset_index);

            tileset_dropdown_open = false;
        }
        else
        {
            tileset_dropdown_open = false;
        }
    }
}