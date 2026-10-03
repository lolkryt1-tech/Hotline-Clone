/// @desc scrMoveCollideAndBounce(_hspd, _vspd)
/// @param {Real} _hspd Горизонтальная скорость
/// @param {Real} _vspd Вертикальная скорость
/// @return {Bool} Возвращает true, если был удар о стену

function scrMoveCollideAndBounce(_hspd, _vspd)
{
    // Запоминаем координаты ДО движения, чтобы понять, по какой оси нас остановило
    var _old_x = x;
    var _old_y = y;

    // Вызываем встроенную функцию. 
    // Четвертый параметр (0) отключает встроенное скольжение, чтобы мы могли рассчитать чистый отскок.
    var _collisions = move_and_collide(_hspd, _vspd, objSolidTall, 4, 0, 0);
    
    // Если столкновений не было — возвращаем false
    if (array_length(_collisions) == 0) 
    {
        return false;
    }

    // Проверяем, какая ось заблокирована (сравниваем пройденное расстояние с целевым)
    var _moved_x = x - _old_x;
    var _moved_y = y - _old_y;

    // 1. Если объект не смог пройти по X столько, сколько планировал — это вертикальная стена
    if (abs(_moved_x) < abs(_hspd))
    {
        direction = 180 - direction;
    }

    // 2. Если объект не смог пройти по Y столько, сколько планировал — это пол или потолок
    if (abs(_moved_y) < abs(_vspd))
    {
        direction = 360 - direction;
    }

    return true;
}
