
/// @function scrEditorHistoryTileOperationFinish()
/// @description Завершает операцию и записывает реальные изменения в историю.

function scrEditorHistoryTileOperationFinish()
{
    var _workspace = instance_find(objEditorWorkspace, 0);
    var _browser = instance_find(objEditorAssetBrowser, 0);

    if (_workspace == noone || _browser == noone)
        return false;

    if (!_workspace.tile_history_active)
        return false;

    var _layer_index = _workspace.tile_history_layer;

    if (_layer_index < 0 || _layer_index >= array_length(_browser.tile_layers))
    {
        _workspace.tile_history_active = false;
        _workspace.tile_history_layer = -1;
        _workspace.tile_history_cells = [];

        return false;
    }

    var _before_cells = [];
    var _after_cells = [];

    // === СРАВНЕНИЕ СОСТОЯНИЙ ===

    for (var i = 0; i < array_length(_workspace.tile_history_cells); i++)
    {
        var _entry = _workspace.tile_history_cells[i];

        var _snapshot = scrEditorHistoryCaptureTileCell(
            _layer_index,
            _entry.x,
            _entry.y
        );

        if (is_undefined(_snapshot))
            continue;

        var _before = _entry.before;
        var _after = _snapshot.tile_data;

        if (array_length(_before) != array_length(_after))
            continue;

        var _changed = false;

        for (var j = 0; j < array_length(_before); j++)
        {
            if (_before[j] != _after[j])
            {
                _changed = true;
                break;
            }
        }

        if (!_changed)
            continue;

        array_push(_before_cells, {
            x: _entry.x,
            y: _entry.y,
            tile_data: _before
        });

        array_push(_after_cells, {
            x: _entry.x,
            y: _entry.y,
            tile_data: _after
        });
    }

    // === ЗАПИСЬ В ИСТОРИЮ ===

    var _result = true;

    if (array_length(_before_cells) > 0)
    {
        _result = scrEditorHistoryPush("TILE_CELLS", {
            layer_index: _layer_index,
            before: _before_cells,
            after: _after_cells
        });
    }

    // === СБРОС ОПЕРАЦИИ ===

    _workspace.tile_history_active = false;
    _workspace.tile_history_layer = -1;
    _workspace.tile_history_cells = [];

    return _result;
}
