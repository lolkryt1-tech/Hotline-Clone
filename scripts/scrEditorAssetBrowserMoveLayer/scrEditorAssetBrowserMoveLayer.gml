
/// @function scrEditorAssetBrowserMoveLayer(_from, _to)
/// @description Перемещает логический слой вместе со всеми его Tilemap.

function scrEditorAssetBrowserMoveLayer(_from, _to)
{
    var _count = array_length(tile_layers);

    if (_from < 0 || _from >= _count) return;
    if (_to < 0 || _to >= _count) return;
    if (_from == _to) return;

    // === МЕНЯЕМ МЕСТАМИ СЛОИ ===
    var _temp = tile_layers[_from];

    tile_layers[_from] = tile_layers[_to];
    tile_layers[_to] = _temp;

    // === ОБНОВЛЯЕМ ГЛУБИНУ ФИЗИЧЕСКИХ СЛОЁВ ===
    for (var i = 0; i < _count; i++)
    {
        var _base_depth = -101 - i * 4;
        var _tilemaps = tile_layers[i].tilemaps;

        for (var j = 0; j < array_length(_tilemaps); j++)
        {
            var _layer_id = _tilemaps[j].layer_id;

            if (layer_exists(_layer_id))
            {
                layer_depth(_layer_id, _base_depth - j);
            }
        }
    }

    // === ОБНОВЛЯЕМ АКТИВНЫЙ СЛОЙ ===
    active_layer = _to;

    // Сбрасываем двойной клик
    last_layer_click = -1;

    // Держим активный слой в видимой области
    if (active_layer < layers_scroll)
    {
        layers_scroll = active_layer;
    }
    else if (active_layer >= layers_scroll + layers_visible_count)
    {
        layers_scroll = active_layer - layers_visible_count + 1;
    }
}
