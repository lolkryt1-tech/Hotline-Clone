
/// @function scrEditorHistoryTileCellsRegister()
/// @description Регистрирует обработчики истории для Tilemap.

function scrEditorHistoryTileCellsRegister()
{
    return scrEditorHistoryRegister(
        "TILE_CELLS",
        scrEditorHistoryTileCellsUndo,
        scrEditorHistoryTileCellsRedo
    );
}
