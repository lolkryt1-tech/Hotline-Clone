/// @function scrEditorWorkspaceApplyRectangle(_x0, _y0, _x1, _y1, _action)
/// @description Применяет рисование или стирание ко всей прямоугольной области.

function scrEditorWorkspaceApplyRectangle(_x0, _y0, _x1, _y1, _action)
{
    var _min_x = min(_x0, _x1);
    var _max_x = max(_x0, _x1);

    var _min_y = min(_y0, _y1);
    var _max_y = max(_y0, _y1);

    var _cols = floor(floor_width / grid_cell_size);
    var _rows = floor(floor_height / grid_cell_size);

    // Проверяем пересечение с рабочей областью
    if (_max_x < 0 || _min_x >= _cols) return;
    if (_max_y < 0 || _min_y >= _rows) return;

    // Ограничиваем область размерами рабочего пространства
    _min_x = clamp(_min_x, 0, _cols - 1);
    _max_x = clamp(_max_x, 0, _cols - 1);

    _min_y = clamp(_min_y, 0, _rows - 1);
    _max_y = clamp(_max_y, 0, _rows - 1);

    for (var _x = _min_x; _x <= _max_x; _x++)
    {
        for (var _y = _min_y; _y <= _max_y; _y++)
        {
            scrEditorWorkspaceApplyTile(_x, _y, _action);
        }
    }
}