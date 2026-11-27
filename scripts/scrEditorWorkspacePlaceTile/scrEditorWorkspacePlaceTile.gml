
/// @function scrEditorWorkspacePlaceTile(_left_pressed, _over_browser)
/// @description Размещает выбранный тайл на активном слое.

function scrEditorWorkspacePlaceTile(_left_pressed, _over_browser)
{
    if (!_left_pressed) return;
    if (_over_browser) return;

    // === ПРОВЕРКА ASSET BROWSER ===
    var _browser = instance_find(objEditorAssetBrowser, 0);

    if (_browser == noone) return;

    var _browser_open = false;
    var _active_tab = "";

    with (objLevelEditor)
    {
        _browser_open = editor_ui.asset_browser.is_open;
        _active_tab = editor_ui.asset_browser.active_tab;
    }

    if (!_browser_open || _active_tab != "BUILD") return;
    if (_browser.build_type != "TILES") return;

    // === ПРОВЕРКА ВЫБРАННОГО ТАЙЛА ===
    if (_browser.selected_tile_index < 0) return;
    if (_browser.selected_tileset_index < 0) return;

    // === ПРОВЕРКА АКТИВНОГО СЛОЯ ===
    var _layer_index = _browser.active_layer;

    if (_layer_index < 0 || _layer_index >= array_length(_browser.tile_layers))
        return;

    var _layer = _browser.tile_layers[_layer_index];

    if (_layer.locked || !_layer.visible) return;

    // === ВЫБОР TILEMAP ===
    var _tilemap_index = 0;

    switch (_browser.selected_tileset_index)
    {
        case 0: _tilemap_index = 2; break; // RUGS
        case 1: _tilemap_index = 1; break; // TILES
        case 2: _tilemap_index = 0; break; // FLOORS
        default: return;
    }

    var _tilemap = _layer.tilemaps[_tilemap_index].tilemap_id;

    // === КООРДИНАТЫ МЫШИ В ROOM ===
    var _mouse_x = mouse_x;
    var _mouse_y = mouse_y;

    if (_mouse_x < floor_x || _mouse_x >= floor_x + floor_width) return;
    if (_mouse_y < floor_y || _mouse_y >= floor_y + floor_height) return;

    // === КООРДИНАТЫ ЯЧЕЙКИ ===
    var _cell_x = floor((_mouse_x - floor_x) / 16);
    var _cell_y = floor((_mouse_y - floor_y) / 16);

    // === ОЧИСТКА КЛЕТКИ В ОСТАЛЬНЫХ TILEMAP ===
    for (var i = 0; i < array_length(_layer.tilemaps); i++)
    {
        if (i == _tilemap_index) continue;

        var _other_tilemap = _layer.tilemaps[i].tilemap_id;

        tilemap_set(
            _other_tilemap,
            0,
            _cell_x,
            _cell_y
        );
    }

    // === РАЗМЕЩЕНИЕ ===
    var _tile_data = tilemap_get(_tilemap, _cell_x, _cell_y);

    var _columns = floor(
        sprite_get_width(_browser.selected_tileset_sprite)
        / _browser.tileset_info.tile_width
    );

    var _tile_index = _browser.selected_tile_index + _columns;

    _tile_data = tile_set_index(_tile_data, _tile_index);

    // ВАЖНО: сначала tiledata, затем координаты!
    var _placed = tilemap_set(
        _tilemap,
        _tile_data,
        _cell_x,
        _cell_y
    );
}
