
/// @function scrEditorWorkspaceDrawGrid()
/// @description Рисует сетку внутри этажа с учётом текущего масштаба камеры.

function scrEditorWorkspaceDrawGrid()
{
    if (!grid_enabled) return;

    // === ВИДИМАЯ ОБЛАСТЬ ===

    var _view_w = camera_get_view_width(camera_id);
    var _view_h = camera_get_view_height(camera_id);

    var _left = max(floor_x, camera_x);
    var _top = max(floor_y, camera_y);

    var _right = min(floor_x + floor_width, camera_x + _view_w);
    var _bottom = min(floor_y + floor_height, camera_y + _view_h);

    if (_left >= _right || _top >= _bottom) return;


    // === ВЫБОР ШАГА СЕТКИ ===

    var _minor_step = grid_cell_size;
    var _major_step = grid_major_size;

    var _show_minor = (_minor_step * zoom >= grid_min_spacing);


    // === КРУПНАЯ СЕТКА ===

    draw_set_color(make_color_rgb(65, 65, 72));

    var _start_x = floor((_left - floor_x) / _major_step) * _major_step + floor_x;
    var _start_y = floor((_top - floor_y) / _major_step) * _major_step + floor_y;

    for (var _x = _start_x; _x <= _right; _x += _major_step)
    {
        draw_line(_x, _top, _x, _bottom);
    }

    for (var _y = _start_y; _y <= _bottom; _y += _major_step)
    {
        draw_line(_left, _y, _right, _y);
    }


    // === МЕЛКАЯ СЕТКА ===

    if (_show_minor)
    {
        draw_set_color(make_color_rgb(49, 49, 54));

        _start_x = floor((_left - floor_x) / _minor_step) * _minor_step + floor_x;
        _start_y = floor((_top - floor_y) / _minor_step) * _minor_step + floor_y;

        for (var _x = _start_x; _x <= _right; _x += _minor_step)
        {
            if ((_x - floor_x) mod _major_step != 0)
                draw_line(_x, _top, _x, _bottom);
        }

        for (var _y = _start_y; _y <= _bottom; _y += _minor_step)
        {
            if ((_y - floor_y) mod _major_step != 0)
                draw_line(_left, _y, _right, _y);
        }
    }

    draw_set_color(c_white);
}
