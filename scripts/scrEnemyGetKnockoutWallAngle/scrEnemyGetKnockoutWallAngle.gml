/// @param {Real} _x Позиция врага по X
/// @param {Real} _y Позиция врага по Y
/// @param {Real} _direction Направление удара
/// @returns {Real} Угол стены или -1, если подходящей стены нет

function scrEnemyGetKnockoutWallAngle(_x, _y, _direction)
{
    // Ищем стену по направлению удара на расстоянии до 8 пикселей
    var _contact_x = _x;
    var _contact_y = _y;
    var _wall_found = false;

    for (var i = 1; i <= 8; i++)
    {
        var _check_x = _x + lengthdir_x(i, _direction);
        var _check_y = _y + lengthdir_y(i, _direction);

        if (place_meeting(_check_x, _check_y, objSolid))
        {
            // Запоминаем позицию первого контакта со стеной
            _contact_x = _check_x;
            _contact_y = _check_y;
            _wall_found = true;
            break;
        }
    }

    if (!_wall_found) return -1;

    // Проверяем стены по четырем сторонам от точки контакта
    var _wall_right = place_meeting(_contact_x + 3, _contact_y, objSolid);
    var _wall_left  = place_meeting(_contact_x - 3, _contact_y, objSolid);
    var _wall_down  = place_meeting(_contact_x, _contact_y + 3, objSolid);
    var _wall_up    = place_meeting(_contact_x, _contact_y - 3, objSolid);

    var _final_angle = -1;

    if (_wall_right)      _final_angle = 180;
    else if (_wall_left)  _final_angle = 0;
    else if (_wall_down)  _final_angle = 90;
    else if (_wall_up)    _final_angle = 270;

    if (_final_angle == -1) return -1;

    // Проверяем, что удар направлен в сторону стены
    var _angle_diff = abs(angle_difference(_direction - 180, _final_angle));

    if (_angle_diff > 45) return -1;

    // Проверяем наличие стены непосредственно за спиной
    var _back_wall_x = _contact_x + lengthdir_x(4, _final_angle - 180);
    var _back_wall_y = _contact_y + lengthdir_y(4, _final_angle - 180);

    if (!place_meeting(_back_wall_x, _back_wall_y, objSolid)) return -1;

    return _final_angle;
}