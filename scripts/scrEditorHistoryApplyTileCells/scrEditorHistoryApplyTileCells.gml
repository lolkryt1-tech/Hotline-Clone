
/// @function scrEditorHistoryApplyTileCells(_layer_index, _cells)
/// @description Восстанавливает состояние Tilemap для массива клеток.

function scrEditorHistoryApplyTileCells(_layer_index, _cells)
{
    var _browser = instance_find(objEditorAssetBrowser, 0);

    if (_browser == noone) return false;
    if (_layer_index < 0 || _layer_index >= array_length(_browser.tile_layers))
        return false;

    var _layer = _browser.tile_layers[_layer_index];
    var _tilemap_count = array_length(_layer.tilemaps);

    // Проверяем совместимость сохранённых данных
    for (var i = 0; i < array_length(_cells); i++)
    {
        if (array_length(_cells[i].tile_data) != _tilemap_count)
            return false;
    }

    // Восстанавливаем все клетки
    for (var i = 0; i < array_length(_cells); i++)
    {
        var _cell = _cells[i];

        for (var j = 0; j < _tilemap_count; j++)
        {
            var _map = _layer.tilemaps[j].tilemap_id;

            tilemap_set(
                _map,
                _cell.tile_data[j],
                _cell.x,
                _cell.y
            );
        }
    }

    return true;
}
