/// @function scrEditorAssetBrowserDeleteLayer(_index)
/// @description Удаляет логический слой вместе со всеми тремя Tilemap.

function scrEditorAssetBrowserDeleteLayer(_index)
{
    var _count = array_length(tile_layers);

    if (_index < 0 || _index >= _count) return;

    // === УДАЛЯЕМ ТРИ ФИЗИЧЕСКИХ СЛОЯ ===
    var _tilemaps = tile_layers[_index].tilemaps;

    for (var i = 0; i < array_length(_tilemaps); i++)
    {
        var _layer_id = _tilemaps[i].layer_id;

        if (layer_exists(_layer_id))
        {
            layer_destroy(_layer_id);
        }
    }

    // === УДАЛЯЕМ ЛОГИЧЕСКИЙ СЛОЙ ===
    array_delete(tile_layers, _index, 1);

    var _new_count = array_length(tile_layers);

    // === ОБНОВЛЯЕМ АКТИВНЫЙ СЛОЙ ===
    if (_new_count <= 0)
    {
        active_layer = -1;
        layers_scroll = 0;
    }
    else
    {
        active_layer = clamp(_index, 0, _new_count - 1);

        layers_scroll = clamp(
            layers_scroll,
            0,
            max(_new_count - layers_visible_count, 0)
        );

        if (active_layer < layers_scroll)
        {
            layers_scroll = active_layer;
        }
        else if (active_layer >= layers_scroll + layers_visible_count)
        {
            layers_scroll = active_layer - layers_visible_count + 1;
        }
    }

    // === ОБНОВЛЯЕМ ГЛУБИНУ ОСТАВШИХСЯ СЛОЁВ ===
    for (var i = 0; i < _new_count; i++)
    {
        var _base_depth = -101 - i * 4;
        var _remaining_tilemaps = tile_layers[i].tilemaps;

        for (var j = 0; j < array_length(_remaining_tilemaps); j++)
        {
            var _remaining_layer_id = _remaining_tilemaps[j].layer_id;

            if (layer_exists(_remaining_layer_id))
            {
                layer_depth(_remaining_layer_id, _base_depth - j);
            }
        }
    }

    // === СБРОС СОСТОЯНИЙ ===
    last_layer_click = -1;
    rename_active = false;
    rename_layer_index = -1;
}