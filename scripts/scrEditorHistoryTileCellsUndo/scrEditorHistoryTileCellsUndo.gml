
/// @function scrEditorHistoryTileCellsUndo(_data)
/// @description Отменяет изменение клеток Tilemap.

function scrEditorHistoryTileCellsUndo(_data)
{
    return scrEditorHistoryApplyTileCells(
        _data.layer_index,
        _data.before
    );
}
