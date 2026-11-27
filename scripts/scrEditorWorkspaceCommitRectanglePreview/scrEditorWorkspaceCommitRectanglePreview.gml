/// @function scrEditorWorkspaceCommitRectanglePreview()
/// @description Подтверждает временное стирание прямоугольной области.

function scrEditorWorkspaceCommitRectanglePreview()
{
    // Оставляем Tilemap в текущем очищенном состоянии.
    // Снимок больше не понадобится.
    rectangle_preview_cells = [];
    rectangle_preview_layer = -1;
}