
/// @function scrEditorAssetBrowserHandleLayers()
/// @description Обрабатывает список Tile Layers и создание новых слоёв.

function scrEditorAssetBrowserHandleLayers(
    _browser,
    _mouse_x,
    _mouse_y,
    _left_pressed,
    _left_down,
    _left_released,
    _wheel
)
{
    if (_browser.active_tab != "BUILD") return;

    // === ПЕРЕИМЕНОВАНИЕ ===
    if (rename_active)
    {
        if (keyboard_check_pressed(vk_enter))
        {
            var _new_name = string_trim(keyboard_string);

            if (_new_name != "")
            {
                if (rename_layer_index >= 0
                && rename_layer_index < array_length(tile_layers))
                {
                    tile_layers[rename_layer_index].name = _new_name;
                }

                rename_active = false;
                rename_layer_index = -1;
                keyboard_string = "";
            }
        }

        if (keyboard_check_pressed(vk_escape))
        {
            rename_active = false;
            rename_layer_index = -1;
            keyboard_string = "";
        }

        return;
    }

    // === РАЗМЕРЫ НИЖНЕЙ ПАНЕЛИ ===
    var _bottom_y = window_y + window_height - 112;

    var _tileset_w = (window_width - 24) * 0.38;

    var _layers_x = window_x + 12 + _tileset_w + 10;
    var _layers_y = _bottom_y;
    var _layers_w = (window_width - 24) - _tileset_w - 10;

    // === РАЗМЕРЫ СПИСКА ===
    var _layers_list_y = _layers_y + 18;
    var _layers_list_h = 78;

    var _scrollbar_w = 8;
    var _row_h = layers_row_height;

    var _layers_count = array_length(tile_layers);
    var _max_scroll = max(_layers_count - layers_visible_count, 0);

    layers_scroll = clamp(layers_scroll, 0, _max_scroll);

    var _scrollbar_x = _layers_x + _layers_w - _scrollbar_w;
    var _scrollbar_y = _layers_list_y;

    var _thumb_h = max(
        16,
        _layers_list_h * min(layers_visible_count, _layers_count)
        / max(_layers_count, 1)
    );

    var _thumb_y = _scrollbar_y;

    if (_max_scroll > 0)
    {
        _thumb_y += (_layers_list_h - _thumb_h) * layers_scroll / _max_scroll;
    }

    // === ПОДТВЕРЖДЕНИЕ УДАЛЕНИЯ ===
    if (delete_confirm_active)
    {
        var _dialog_w = 220;
        var _dialog_h = 64;
        var _dialog_x = _layers_x + (_layers_w - _dialog_w) * 0.5;
        var _dialog_y = _layers_list_y + (_layers_list_h - _dialog_h) * 0.5;

        if (keyboard_check_pressed(vk_escape))
        {
            delete_confirm_active = false;
            delete_confirm_index = -1;
            return;
        }

        if (_left_pressed)
        {
            // DELETE
            if (_mouse_x >= _dialog_x + 24
            && _mouse_x <= _dialog_x + 104
            && _mouse_y >= _dialog_y + 34
            && _mouse_y <= _dialog_y + 56)
            {
                var _delete_index = delete_confirm_index;

                delete_confirm_active = false;
                delete_confirm_index = -1;

                scrEditorAssetBrowserDeleteLayer(_delete_index);
                return;
            }

            // CANCEL
            if (_mouse_x >= _dialog_x + 116
            && _mouse_x <= _dialog_x + 196
            && _mouse_y >= _dialog_y + 34
            && _mouse_y <= _dialog_y + 56)
            {
                delete_confirm_active = false;
                delete_confirm_index = -1;
                return;
            }
        }

        return;
    }

    // === УДАЛЕНИЕ АКТИВНОГО СЛОЯ ===
    var _delete_y1 = _layers_y - 2;
    var _delete_y2 = _layers_y + 15;

    if (_left_pressed
    && _mouse_x >= _layers_x + _layers_w - 78
    && _mouse_x <= _layers_x + _layers_w - 62
    && _mouse_y >= _delete_y1
    && _mouse_y <= _delete_y2)
    {
        if (active_layer >= 0
        && active_layer < array_length(tile_layers))
        {
            delete_confirm_active = true;
            delete_confirm_index = active_layer;
            last_layer_click = -1;
        }

        return;
    }

    // === ПЕРЕМЕЩЕНИЕ АКТИВНОГО СЛОЯ СТРЕЛКАМИ ===
    var _move_y = _layers_y - 2;
    var _move_y_end = _layers_y + 15;

    if (_left_pressed
    && _mouse_y >= _move_y && _mouse_y <= _move_y_end)
    {
        // UP
        if (_mouse_x >= _layers_x + _layers_w - 58
        && _mouse_x <= _layers_x + _layers_w - 42)
        {
            if (active_layer > 0)
            {
                scrEditorAssetBrowserMoveLayer(active_layer, active_layer - 1);
            }

            return;
        }

        // DOWN
        if (_mouse_x >= _layers_x + _layers_w - 38
        && _mouse_x <= _layers_x + _layers_w - 22)
        {
            if (active_layer >= 0
            && active_layer < array_length(tile_layers) - 1)
            {
                scrEditorAssetBrowserMoveLayer(active_layer, active_layer + 1);
            }

            return;
        }
    }

    // === ОБЛАСТЬ СПИСКА СЛОЁВ ===
    var _mouse_over_layers =
        _mouse_x >= _layers_x && _mouse_x <= _scrollbar_x
        && _mouse_y >= _layers_list_y
        && _mouse_y <= _layers_list_y + _layers_list_h;

    // === ПРОКРУТКА СПИСКА ===
    // Колёсико работает и во время перетаскивания слоя
    if (_wheel != 0 && _mouse_over_layers)
    {
        layers_scroll = clamp(
            layers_scroll - _wheel,
            0,
            _max_scroll
        );
    }

    // === НАЧАЛО ПЕРЕТАСКИВАНИЯ ПОЛЗУНКА ===
    if (_left_pressed && _max_scroll > 0
    && _mouse_x >= _scrollbar_x
    && _mouse_x <= _scrollbar_x + _scrollbar_w
    && _mouse_y >= _thumb_y
    && _mouse_y <= _thumb_y + _thumb_h)
    {
        layers_scroll_dragging = true;
        layers_scroll_drag_offset = _mouse_y - _thumb_y;
    }

    // === ПЕРЕТАСКИВАНИЕ ПОЛЗУНКА ===
    if (layers_scroll_dragging && _left_down && _max_scroll > 0)
    {
        var _new_thumb_y = clamp(
            _mouse_y - layers_scroll_drag_offset,
            _scrollbar_y,
            _scrollbar_y + _layers_list_h - _thumb_h
        );

        layers_scroll = round(
            (_new_thumb_y - _scrollbar_y)
            / max(_layers_list_h - _thumb_h, 1)
            * _max_scroll
        );
    }

    if (_left_released)
        layers_scroll_dragging = false;

    // === НАЖАТИЕ НА СТРОКУ СЛОЯ ===
    if (_left_pressed
    && _mouse_x >= _layers_x
    && _mouse_x <= _scrollbar_x
    && _mouse_y >= _layers_list_y
    && _mouse_y <= _layers_list_y + _layers_list_h)
    {
        var _row_index = floor(
            (_mouse_y - _layers_list_y) / _row_h
        ) + layers_scroll;

        if (_row_index >= 0 && _row_index < _layers_count)
        {
            var _icon_x = _layers_x + _layers_w - 34;

            if (_mouse_x >= _icon_x)
            {
                // === LOCK ===
                tile_layers[_row_index].locked = !tile_layers[_row_index].locked;
                last_layer_click = -1;
            }
            else if (_mouse_x >= _icon_x - 24)
            {
                // === VISIBILITY ===
                tile_layers[_row_index].visible = !tile_layers[_row_index].visible;

                var _visible = tile_layers[_row_index].visible;
                var _tilemaps = tile_layers[_row_index].tilemaps;

                for (var i = 0; i < array_length(_tilemaps); i++)
                {
                    var _layer_id = _tilemaps[i].layer_id;

                    if (layer_exists(_layer_id))
                    {
                        layer_set_visible(_layer_id, _visible);
                    }
                }

                last_layer_click = -1;
            }
            else
            {
                // === КАНДИДАТ НА ПЕРЕТАСКИВАНИЕ ===
                layer_drag_candidate = _row_index;
                layer_drag_start_x = _mouse_x;
                layer_drag_start_y = _mouse_y;
                layer_drag_mouse_y = _mouse_y;
                layer_drag_target = _row_index;

                layer_dragging = false;
            }
        }
    }

    // === ОБРАБОТКА ПЕРЕТАСКИВАНИЯ ===
    if (layer_drag_candidate >= 0
    && layer_drag_candidate < array_length(tile_layers))
    {
        // Начинаем Drag только после движения мыши
        if (_left_down && !layer_dragging)
        {
            var _drag_distance = point_distance(
                layer_drag_start_x,
                layer_drag_start_y,
                _mouse_x,
                _mouse_y
            );

            if (_drag_distance >= 5)
            {
                layer_dragging = true;
                active_layer = layer_drag_candidate;
                last_layer_click = -1;
            }
        }

        if (layer_dragging && _left_down)
        {
            layer_drag_mouse_y = _mouse_y;

            // === АВТОПРОКРУТКА У КРАЁВ СПИСКА ===
            var _edge_size = 12;

            if (_mouse_x >= _layers_x && _mouse_x <= _scrollbar_x)
            {
                if (_mouse_y >= _layers_list_y
                && _mouse_y <= _layers_list_y + _edge_size
                && layers_scroll > 0)
                {
                    layers_scroll -= 1;
                }
                else if (_mouse_y <= _layers_list_y + _layers_list_h
                && _mouse_y >= _layers_list_y + _layers_list_h - _edge_size
                && layers_scroll < _max_scroll)
                {
                    layers_scroll += 1;
                }
            }

            layers_scroll = clamp(
                layers_scroll,
                0,
                _max_scroll
            );

            // === ВЫЧИСЛЯЕМ ПОЗИЦИЮ ВСТАВКИ ===
            layer_drag_target = -1;

            if (_mouse_x >= _layers_x && _mouse_x <= _scrollbar_x
            && _mouse_y >= _layers_list_y
            && _mouse_y <= _layers_list_y + _layers_list_h)
            {
                var _relative_y = clamp(
                    _mouse_y - _layers_list_y,
                    0,
                    _layers_list_h - 1
                );

                var _visible_row = floor(_relative_y / _row_h);
                var _row_offset = _relative_y mod _row_h;

                var _insert_index = _visible_row + layers_scroll;

                if (_row_offset >= _row_h * 0.5)
                {
                    _insert_index += 1;
                }

                // Переводим позицию вставки в конечный индекс
                var _source_index = layer_drag_candidate;

                if (_insert_index > _source_index)
                {
                    _insert_index -= 1;
                }

                layer_drag_target = clamp(
                    _insert_index,
                    0,
                    array_length(tile_layers) - 1
                );
            }
        }

        // === ЗАВЕРШЕНИЕ ПЕРЕТАСКИВАНИЯ ===
        if (_left_released)
        {
            if (layer_dragging
            && layer_drag_target >= 0
            && layer_drag_target < array_length(tile_layers))
            {
                var _target = layer_drag_target;

                // Перемещаем слой через соседние позиции
                while (active_layer != _target)
                {
                    if (active_layer < _target)
                    {
                        scrEditorAssetBrowserMoveLayer(
                            active_layer,
                            active_layer + 1
                        );
                    }
                    else
                    {
                        scrEditorAssetBrowserMoveLayer(
                            active_layer,
                            active_layer - 1
                        );
                    }
                }
            }
            else if (!layer_dragging)
            {
                // === ОБЫЧНЫЙ КЛИК / ДВОЙНОЙ КЛИК ===
                var _clicked_index = layer_drag_candidate;

                active_layer = _clicked_index;

                var _click_time = current_time;

                if (last_layer_click == _clicked_index
                && _click_time - last_layer_click_time <= rename_double_click_time)
                {
                    rename_active = true;
                    rename_layer_index = _clicked_index;

                    keyboard_string = tile_layers[_clicked_index].name;

                    last_layer_click = -1;
                }
                else
                {
                    last_layer_click = _clicked_index;
                    last_layer_click_time = _click_time;
                }
            }

            layer_dragging = false;
            layer_drag_candidate = -1;
            layer_drag_target = -1;
        }
    }
    else if (_left_released)
    {
        layer_dragging = false;
        layer_drag_candidate = -1;
        layer_drag_target = -1;
    }

    // === ДОБАВЛЕНИЕ СЛОЯ ===
    if (_left_pressed
    && _mouse_x >= _layers_x + _layers_w - 18
    && _mouse_x <= _layers_x + _layers_w
    && _mouse_y >= _layers_y - 1
    && _mouse_y <= _layers_y + 16)
    {
        var _new_index = array_length(tile_layers);
        var _workspace = instance_find(objEditorWorkspace, 0);

        last_layer_click = -1;

        if (_workspace != noone)
        {
            var _map_width = _workspace.floor_width div 16;
            var _map_height = _workspace.floor_height div 16;

            var _floor_origin_x = _workspace.floor_x;
            var _floor_origin_y = _workspace.floor_y;

            var _base_depth = -101 - _new_index * 4;

            // FLOOR
            var _floor_layer = layer_create(
                _base_depth,
                "Editor_TL" + string(_new_index + 1) + "_Floors"
            );

            var _floor_map = layer_tilemap_create(
                _floor_layer,
                _floor_origin_x,
                _floor_origin_y,
                tlFloors,
                _map_width,
                _map_height
            );

            // TILES
            var _tiles_layer = layer_create(
                _base_depth - 1,
                "Editor_TL" + string(_new_index + 1) + "_Tiles"
            );

            var _tiles_map = layer_tilemap_create(
                _tiles_layer,
                _floor_origin_x,
                _floor_origin_y,
                tlTiles,
                _map_width,
                _map_height
            );

            // RUGS
            var _rugs_layer = layer_create(
                _base_depth - 2,
                "Editor_TL" + string(_new_index + 1) + "_Rugs"
            );

            var _rugs_map = layer_tilemap_create(
                _rugs_layer,
                _floor_origin_x,
                _floor_origin_y,
                tlRugs,
                _map_width,
                _map_height
            );

            // СОХРАНЯЕМ TILEMAP В ЛОГИЧЕСКОМ СЛОЕ
            array_push(tile_layers, {
                name: "Tile Layer " + string(_new_index + 1),
                visible: true,
                locked: false,
                tilemaps: [
                    { tileset: tlFloors, layer_id: _floor_layer, tilemap_id: _floor_map },
                    { tileset: tlTiles, layer_id: _tiles_layer, tilemap_id: _tiles_map },
                    { tileset: tlRugs, layer_id: _rugs_layer, tilemap_id: _rugs_map }
                ]
            });

            active_layer = _new_index;
            layers_scroll = max(_new_index - layers_visible_count + 1, 0);
        }
    }
}
