/// @function scrEditorWorkspaceDrawToolPreview()
/// @description Отрисовывает предпросмотр активного инструмента.

function scrEditorWorkspaceDrawToolPreview()
{
    // ==================================================
    // ПРЯМОУГОЛЬНИК
    // ==================================================

    if (active_tool == "RECTANGLE")
    {
        // Обычный предпросмотр тайла
        if (!rectangle_active)
        {
            scrEditorWorkspaceDrawTilePreview();
            return;
        }

        // Предпросмотр рисования
        if (rectangle_action == "DRAW")
        {
            scrEditorWorkspaceDrawRectanglePreview();
        }

        // Предпросмотр стирания
        else if (rectangle_action == "ERASE")
        {
            var _cols = floor(floor_width / grid_cell_size);
            var _rows = floor(floor_height / grid_cell_size);

            var _min_x = min(rectangle_start_x, rectangle_end_x);
            var _max_x = max(rectangle_start_x, rectangle_end_x);

            var _min_y = min(rectangle_start_y, rectangle_end_y);
            var _max_y = max(rectangle_start_y, rectangle_end_y);

            // Проверяем пересечение с рабочей областью
            if (_max_x < 0 || _min_x >= _cols) return;
            if (_max_y < 0 || _min_y >= _rows) return;

            // Обрезаем только область отрисовки
            _min_x = clamp(_min_x, 0, _cols - 1);
            _max_x = clamp(_max_x, 0, _cols - 1);

            _min_y = clamp(_min_y, 0, _rows - 1);
            _max_y = clamp(_max_y, 0, _rows - 1);

            var _left = floor_x + _min_x * grid_cell_size;
            var _top = floor_y + _min_y * grid_cell_size;

            var _right = floor_x + (_max_x + 1) * grid_cell_size;
            var _bottom = floor_y + (_max_y + 1) * grid_cell_size;

            draw_set_color(c_yellow);
            draw_set_alpha(1);
            draw_rectangle(_left, _top, _right, _bottom, true);

            draw_set_color(c_white);
            draw_set_alpha(1);
        }

        return;
    }

    // ==================================================
    // КАРАНДАШ
    // ==================================================

    if (active_tool == "PENCIL")
    {
        scrEditorWorkspaceDrawTilePreview();
    }
}