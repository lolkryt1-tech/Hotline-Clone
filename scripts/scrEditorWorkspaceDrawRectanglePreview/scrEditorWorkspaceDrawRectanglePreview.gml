/// @function scrEditorWorkspaceDrawRectanglePreview()
/// @description Отрисовывает предпросмотр рисования прямоугольником.

function scrEditorWorkspaceDrawRectanglePreview()
{
    if (!rectangle_active || rectangle_action != "DRAW")
        return;

    var _browser = instance_find(objEditorAssetBrowser, 0);

    if (_browser == noone) return;

    if (_browser.selected_tile_index < 0)
        return;

    if (_browser.selected_tileset_index < 0)
        return;

    var _sprite = _browser.selected_tileset_sprite;

    if (_sprite < 0) return;

    var _tile_w = _browser.tileset_info.tile_width;
    var _tile_h = _browser.tileset_info.tile_height;

    if (_tile_w <= 0 || _tile_h <= 0) return;

    // === ГРАНИЦЫ ВЫДЕЛЕНИЯ ===

    var _cols = floor(floor_width / grid_cell_size);
    var _rows = floor(floor_height / grid_cell_size);

    var _min_x = min(rectangle_start_x, rectangle_end_x);
    var _max_x = max(rectangle_start_x, rectangle_end_x);

    var _min_y = min(rectangle_start_y, rectangle_end_y);
    var _max_y = max(rectangle_start_y, rectangle_end_y);

    // Проверяем пересечение с рабочей областью
    if (_max_x < 0 || _min_x >= _cols) return;
    if (_max_y < 0 || _min_y >= _rows) return;

    // Обрезаем область предпросмотра
    _min_x = clamp(_min_x, 0, _cols - 1);
    _max_x = clamp(_max_x, 0, _cols - 1);

    _min_y = clamp(_min_y, 0, _rows - 1);
    _max_y = clamp(_max_y, 0, _rows - 1);

    // === ИСТОЧНИК ТАЙЛА ===

    var _source_x = _browser.selected_tile_x * _tile_w;
    var _source_y = (_browser.selected_tile_y + 1) * _tile_h;

    // === ОТРИСОВКА ТАЙЛОВ ===

    for (var _x = _min_x; _x <= _max_x; _x++)
    {
        for (var _y = _min_y; _y <= _max_y; _y++)
        {
            var _draw_x = floor_x + _x * grid_cell_size;
            var _draw_y = floor_y + _y * grid_cell_size;

            draw_sprite_part_ext(
                _sprite,
                0,
                _source_x,
                _source_y,
                _tile_w,
                _tile_h,
                _draw_x,
                _draw_y,
                1,
                1,
                c_white,
                1
            );
        }
    }

    // === ГРАНИЦА ВЫДЕЛЕНИЯ ===

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