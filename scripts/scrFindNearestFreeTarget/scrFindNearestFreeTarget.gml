/// @desc Ищет точку вокруг цели по 4 направлениям с заданным шагом через collision_line
/// @param {Real} _tx Координата X цели (игрока или оружия)
/// @param {Real} _ty Координата Y цели (игрока или оружия)
/// @param {Real} _step Дальность смещения в пикселях (например, 32)
/// @return {Array} Возвращает массив [x, y], если точка найдена, или noone
function scrFindNearestFreeTarget(_tx, _ty, _step)
{
    // 1. Проверяем Справа
    if (collision_line(x, y, _tx + _step, _ty, objSolidTall, false, true) == noone)
    {
        if (mp_grid_path(global.mp_grid, my_path, x, y, _tx + _step, _ty, false)) 
        {
            return [_tx + _step, _ty]; // Сразу возвращаем координаты и выходим
        }
    }
            
    // 2. Проверяем Слева
    if (collision_line(x, y, _tx - _step, _ty, objSolidTall, false, true) == noone)
    {
        if (mp_grid_path(global.mp_grid, my_path, x, y, _tx - _step, _ty, false)) 
        {
            return [_tx - _step, _ty];
        }
    }
            
    // 3. Проверяем Снизу
    if (collision_line(x, y, _tx, _ty + _step, objSolidTall, false, true) == noone)
    {
        if (mp_grid_path(global.mp_grid, my_path, x, y, _tx, _ty + _step, false)) 
        {
            return [_tx, _ty + _step];
        }
    }
            
    // 4. Проверяем Сверху
    if (collision_line(x, y, _tx, _ty - _step, objSolidTall, false, true) == noone)
    {
        if (mp_grid_path(global.mp_grid, my_path, x, y, _tx, _ty - _step, false)) 
        {
            return [_tx, _ty - _step];
        }
    }

    return noone; // Если ни одна сторона не подошла
}