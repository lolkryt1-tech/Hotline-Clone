
/// @function scrEditorWorkspaceApplyTile(_cell_x, _cell_y, _action)
/// @description Рисует или стирает тайл в указанной клетке активного слоя.

function scrEditorWorkspaceApplyTile(_cell_x, _cell_y, _action)
{
    if (_action != "DRAW" && _action != "ERASE") return false;

    // === ПРОВЕРКА РАБОЧЕЙ ОБЛАСТИ ===

    var _cols = floor(floor_width / grid_cell_size);
    var _rows = floor(floor_height / grid_cell_size);

    if (_cell_x < 0 || _cell_y < 0 || _cell_x >= _cols || _cell_y >= _rows)
        return false;

    // === ПОЛУЧЕНИЕ ASSET BROWSER ===

    var _browser = instance_find(objEditorAssetBrowser, 0);

    if (_browser == noone) return false;

    var _editor_open = false;
    var _active_tab = "";

    with (objLevelEditor)
    {
        _editor_open = editor_ui.asset_browser.is_open;
        _active_tab = editor_ui.asset_browser.active_tab;
    }

    if (!_editor_open || _active_tab != "BUILD")
        return false;

    // === АКТИВНЫЙ СЛОЙ ===

    var _layer_index = _browser.active_layer;

    if (_layer_index < 0 || _layer_index >= array_length(_browser.tile_layers))
        return false;

    var _layer = _browser.tile_layers[_layer_index];

    if (_layer.locked || !_layer.visible)
        return false;

    // === ПОДГОТОВКА ИЗМЕНЕНИЯ ===

    var _tilemap_count = array_length(_layer.tilemaps);
    var _tilemap_index = -1;
    var _tile_index = -1;

    if (_action == "DRAW")
    {
        // === ПРОВЕРКА ВЫБРАННОГО ТАЙЛА ===

        if (_browser.build_type != "TILES") return false;
        if (_browser.selected_tile_index < 0) return false;
        if (_browser.selected_tileset_index < 0) return false;

        switch (_browser.selected_tileset_index)
        {
            case 0: _tilemap_index = 2; break; // RUGS
            case 1: _tilemap_index = 1; break; // TILES
            case 2: _tilemap_index = 0; break; // FLOORS
        }

        if (_tilemap_index < 0 || _tilemap_index >= _tilemap_count)
            return false;

        var _sprite = _browser.selected_tileset_sprite;

        if (_sprite < 0) return false;

        var _tile_width = _browser.tileset_info.tile_width;

        if (_tile_width <= 0) return false;

        var _columns = floor(sprite_get_width(_sprite) / _tile_width);

        if (_columns <= 0) return false;

        _tile_index = _browser.selected_tile_index + _columns;
    }

    // === ПРОВЕРКА НАЛИЧИЯ ИЗМЕНЕНИЙ ===

    var _before = scrEditorHistoryCaptureTileCell(
        _layer_index,
        _cell_x,
        _cell_y
    );

    if (is_undefined(_before))
        return false;

    var _changed = false;

    if (_action == "ERASE")
    {
        for (var i = 0; i < _tilemap_count; i++)
        {
            if (_before.tile_data[i] != 0)
            {
                _changed = true;
                break;
            }
        }
    }
    else
    {
        for (var i = 0; i < _tilemap_count; i++)
        {
            var _new_data = 0;

            if (i == _tilemap_index)
            {
                _new_data = tile_set_index(
                    _before.tile_data[i],
                    _tile_index
                );
            }

            if (_before.tile_data[i] != _new_data)
            {
                _changed = true;
                break;
            }
        }
    }

    if (!_changed)
        return false;

    // === СОХРАНЕНИЕ ИСХОДНОГО СОСТОЯНИЯ ===

    if (tile_history_active)
    {
        if (tile_history_layer != _layer_index)
            return false;

        scrEditorHistoryTileOperationCapture(_cell_x, _cell_y);
    }

    // === СТИРАНИЕ ===

    if (_action == "ERASE")
    {
        for (var i = 0; i < _tilemap_count; i++)
        {
            var _map = _layer.tilemaps[i].tilemap_id;
            tilemap_set(_map, 0, _cell_x, _cell_y);
        }
    }
    else
    {
        // === ОЧИСТКА ОСТАЛЬНЫХ TILEMAP ===

        for (var i = 0; i < _tilemap_count; i++)
        {
            if (i == _tilemap_index) continue;

            var _other_map = _layer.tilemaps[i].tilemap_id;
            tilemap_set(_other_map, 0, _cell_x, _cell_y);
        }

        // === УСТАНОВКА ТАЙЛА ===

        var _target_map = _layer.tilemaps[_tilemap_index].tilemap_id;

        var _tile_data = tilemap_get(_target_map, _cell_x, _cell_y);
        _tile_data = tile_set_index(_tile_data, _tile_index);

        tilemap_set(_target_map, _tile_data, _cell_x, _cell_y);
    }

    return true;
}
