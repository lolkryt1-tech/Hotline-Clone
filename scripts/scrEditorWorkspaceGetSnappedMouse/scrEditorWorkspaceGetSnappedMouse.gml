/// @function scrEditorWorkspaceGetSnappedMouse()
/// @description Возвращает мировые координаты курсора с учётом привязки к сетке.

function scrEditorWorkspaceGetSnappedMouse()
{
    var _mouse = scrEditorWorkspaceGetMouseWorld();

    if (snap_enabled)
    {
        _mouse.x = floor((_mouse.x - floor_x) / snap_cell_size) * snap_cell_size + floor_x;
        _mouse.y = floor((_mouse.y - floor_y) / snap_cell_size) * snap_cell_size + floor_y;
    }

    return _mouse;
}