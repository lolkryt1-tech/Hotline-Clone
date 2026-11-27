
/// @function scrEditorHistoryCaptureTileCell(_layer_index, _cell_x, _cell_y)
/// @description Сохраняет состояние всех Tilemap в указанной клетке.

function scrEditorHistoryCaptureTileCell(_layer_index, _cell_x, _cell_y)
{
    var _browser = instance_find(objEditorAssetBrowser, 0);

    if (_browser == noone) return undefined;
    if (_layer_index < 0 || _layer_index >= array_length(_browser.tile_layers))
        return undefined;

    var _layer = _browser.tile_layers[_layer_index];
    var _tilemap_count = array_length(_layer.tilemaps);

    var _tile_data = array_create(_tilemap_count, 0);

    for (var i = 0; i < _tilemap_count; i++)
    {
        var _map = _layer.tilemaps[i].tilemap_id;
        _tile_data[i] = tilemap_get(_map, _cell_x, _cell_y);
    }

    return {
        x: _cell_x,
        y: _cell_y,
        tile_data: _tile_data
    };
}
