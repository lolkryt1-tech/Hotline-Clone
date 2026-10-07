/// @desc Ищет доступную точку вокруг заблокированной цели, которая НАХОДИТСЯ С НЕЙ В ОДНОЙ КОМНАТЕ
function scrFindNearestFreeTarget(_tx, _ty, _step)
{
    // === 1. АНТИ-КРАСНАЯ ЗОНА: Выталкивание самого врага из стен ===
    var _grid_cell_x = floor(x / 16);
    var _grid_cell_y = floor(y / 16);
    if (mp_grid_get_cell(global.mp_grid, _grid_cell_x, _grid_cell_y) == -1)
    {
        var _wall_right = place_meeting(x + 8, y, objSolid);
        var _wall_left  = place_meeting(x - 8, y, objSolid);
        var _wall_down  = place_meeting(x, y + 8, objSolid);
        var _wall_up    = place_meeting(x, y - 8, objSolid);
        
        var _move_x = 0; _move_y = 0;
        if (_wall_right) _move_x -= 1;
        if (_wall_left)  _move_x += 1;
        if (_wall_down)  _move_y -= 1;
        if (_wall_up)    _move_y += 1;
        
        if (_move_x != 0 || _move_y != 0)
        {
            var _length = point_distance(0, 0, _move_x, _move_y);
            var _vel_x = (_move_x / _length) * max_speed;
            var _vel_y = (_move_y / _length) * max_speed;
            
            move_and_collide(_vel_x, _vel_y, objSolid);
            my_angle = point_direction(x, y, _vel_x, _vel_y);
        }
    }

    // === 2. МНОГОУРОВНЕВЫЙ ПОИСК ТОЧКИ ВОКРУГ ЦЕЛИ (Радиус увеличиваем до 128px, чтобы найти выход из-за стены) ===
    for (var _r = _step; _r <= 128; _r += _step)
    {
        var _offsets = [
            [_r, 0],   // Справа
            [-_r, 0],  // Слева
            [0, _r],   // Снизу
            [0, -_r],  // Сверху
            [_r, _r],  // Диагонали
            [-_r, -_r],
            [_r, -_r],
            [-_r, _r]
        ];

        for (var i = 0; i < array_length(_offsets); i++)
        {
            var _check_x = _tx + _offsets[i][0];
            var _check_y = _ty + _offsets[i][1];

            // 1. Проверяем, свободна ли ячейка в mp_grid
            var _g_x = floor(_check_x / 16);
            var _g_y = floor(_check_y / 16);
            
            if (mp_grid_get_cell(global.mp_grid, _g_x, _g_y) == 0) 
            {
                // 2. Проверяем, что в самой точке нет физического объекта стены
                if (!position_meeting(_check_x, _check_y, objSolid))
                {
                    // 3. ЖЕСТКИЙ ФИЛЬТР (ТО, ЧТО ТЫ ПРОСИЛ): 
                    // Проверяем линию видимости строго ОТ ИГРОКА (_tx, _ty) до проверяемой точки (_check_x, _check_y).
                    // Если между игроком и точкой ЕСТЬ стена — точка бракуется нахуй!
                    if (!collision_line(_tx, _ty, _check_x, _check_y, objSolid, false, true))
                    {
                        return [_check_x, _check_y]; // Точка идеальна: она свободна и находится в одном проходе с игроком!
                    }
                }
            }
        }
    }

    return noone; 
}
