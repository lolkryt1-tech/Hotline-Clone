
/// @function scrEditorWorkspaceRestoreRectanglePreview()
/// @description Восстанавливает тайлы, временно удалённые предпросмотром прямоугольника.

function scrEditorWorkspaceRestoreRectanglePreview()
{
    if (array_length(rectangle_preview_cells) <= 0)
    {
        rectangle_preview_layer = -1;
        return;
    }

    var _browser = instance_find(objEditorAssetBrowser, 0);

    if (_browser == noone)
    {
        rectangle_preview_cells = [];
        rectangle_preview_layer = -1;
        return;
    }

    var _layer_index = rectangle_preview_layer;

    if (_layer_index < 0 || _layer_index >= array_length(_browser.tile_layers))
    {
        rectangle_preview_cells = [];
        rectangle_preview_layer = -1;
        return;
    }

    var _layer = _browser.tile_layers[_layer_index];
    var _tilemap_count = array_length(_layer.tilemaps);

    // === ВОССТАНОВЛЕНИЕ TILEMAP ===

    for (var i = 0; i < array_length(rectangle_preview_cells); i++)
    {
        var _cell = rectangle_preview_cells[i];

        var _restore_count = min(
            _tilemap_count,
            array_length(_cell.tile_data)
        );

        for (var j = 0; j < _restore_count; j++)
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

    rectangle_preview_cells = [];
    rectangle_preview_layer = -1;
}
