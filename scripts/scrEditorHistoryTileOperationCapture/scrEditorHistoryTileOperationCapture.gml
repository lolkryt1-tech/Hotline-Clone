
/// @function scrEditorHistoryTileOperationCapture(_cell_x, _cell_y)
/// @description Сохраняет исходное состояние клетки один раз.

function scrEditorHistoryTileOperationCapture(_cell_x, _cell_y)
{
    var _workspace = instance_find(objEditorWorkspace, 0);
    var _browser = instance_find(objEditorAssetBrowser, 0);

    if (_workspace == noone || _browser == noone)
        return false;

    if (!_workspace.tile_history_active)
        return false;

    var _layer_index = _workspace.tile_history_layer;

    if (_layer_index < 0 || _layer_index >= array_length(_browser.tile_layers))
        return false;

    // Проверяем, не захватывали ли клетку ранее
    for (var i = 0; i < array_length(_workspace.tile_history_cells); i++)
    {
        var _cell = _workspace.tile_history_cells[i];

        if (_cell.x == _cell_x && _cell.y == _cell_y)
            return true;
    }

    var _snapshot = scrEditorHistoryCaptureTileCell(
        _layer_index,
        _cell_x,
        _cell_y
    );

    if (is_undefined(_snapshot))
        return false;

    array_push(_workspace.tile_history_cells, {
        x: _cell_x,
        y: _cell_y,
        before: _snapshot.tile_data,
        after: []
    });

    return true;
}
