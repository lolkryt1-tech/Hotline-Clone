
/// @function scrEditorWorkspacePreviewRectangleErase(_x0, _y0, _x1, _y1)
/// @description Временно очищает выделенную область для предпросмотра стирания.

function scrEditorWorkspacePreviewRectangleErase(_x0, _y0, _x1, _y1)
{
    // Сначала восстанавливаем предыдущую область предпросмотра
    scrEditorWorkspaceRestoreRectanglePreview();

    var _browser = instance_find(objEditorAssetBrowser, 0);

    if (_browser == noone) return;

    var _layer_index = tile_history_layer;

    if (!tile_history_active) return;

    if (_layer_index < 0 || _layer_index >= array_length(_browser.tile_layers))
        return;

    var _layer = _browser.tile_layers[_layer_index];

    if (_layer.locked || !_layer.visible)
        return;

    // === ГРАНИЦЫ ПРЯМОУГОЛЬНИКА ===

    var _cols = floor(floor_width / grid_cell_size);
    var _rows = floor(floor_height / grid_cell_size);

    var _min_x = min(_x0, _x1);
    var _max_x = max(_x0, _x1);

    var _min_y = min(_y0, _y1);
    var _max_y = max(_y0, _y1);

    if (_max_x < 0 || _min_x >= _cols) return;
    if (_max_y < 0 || _min_y >= _rows) return;

    _min_x = clamp(_min_x, 0, _cols - 1);
    _max_x = clamp(_max_x, 0, _cols - 1);

    _min_y = clamp(_min_y, 0, _rows - 1);
    _max_y = clamp(_max_y, 0, _rows - 1);

    rectangle_preview_layer = _layer_index;

    var _tilemap_count = array_length(_layer.tilemaps);

    // === СОХРАНЕНИЕ И ВРЕМЕННОЕ СТИРАНИЕ ===

    for (var _x = _min_x; _x <= _max_x; _x++)
    {
        for (var _y = _min_y; _y <= _max_y; _y++)
        {
            // Сохраняем исходное состояние для Undo
            scrEditorHistoryTileOperationCapture(_x, _y);

            var _tile_data = array_create(_tilemap_count, 0);

            for (var i = 0; i < _tilemap_count; i++)
            {
                var _map = _layer.tilemaps[i].tilemap_id;

                _tile_data[i] = tilemap_get(_map, _x, _y);

                tilemap_set(_map, 0, _x, _y);
            }

            array_push(rectangle_preview_cells, {
                x: _x,
                y: _y,
                tile_data: _tile_data
            });
        }
    }
}
