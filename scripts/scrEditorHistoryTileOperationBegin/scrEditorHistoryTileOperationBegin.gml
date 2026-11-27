
/// @function scrEditorHistoryTileOperationBegin(_layer_index)
/// @description Начинает общую операцию изменения Tilemap.

function scrEditorHistoryTileOperationBegin(_layer_index)
{
    var _workspace = instance_find(objEditorWorkspace, 0);
    var _browser = instance_find(objEditorAssetBrowser, 0);

    if (_workspace == noone || _browser == noone)
        return false;

    if (_workspace.tile_history_active)
        return false;

    if (_layer_index < 0 || _layer_index >= array_length(_browser.tile_layers))
        return false;

    _workspace.tile_history_active = true;
    _workspace.tile_history_layer = _layer_index;
    _workspace.tile_history_cells = [];

    return true;
}
