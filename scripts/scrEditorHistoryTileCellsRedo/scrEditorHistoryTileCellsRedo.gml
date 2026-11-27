
/// @function scrEditorHistoryTileCellsRedo(_data)
/// @description Повторяет изменение клеток Tilemap.

function scrEditorHistoryTileCellsRedo(_data)
{
    return scrEditorHistoryApplyTileCells(
        _data.layer_index,
        _data.after
    );
}
