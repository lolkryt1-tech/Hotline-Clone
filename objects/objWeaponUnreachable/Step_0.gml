hover_timer += hover_speed;

my_angle += speed * 4; 

var _hspd = lengthdir_x(speed, direction);
var _vspd = lengthdir_y(speed, direction);
var _is_hit = false;

// 3. Проверка удара по горизонтали (вертикальная стена)
if (place_meeting(x + _hspd, y, objSolidTall))
{
    var _failsafe_x = 0;
    while (!place_meeting(x + sign(_hspd), y, [objSolidTall, objDoor]) && sign(_hspd) != 0) {
        x += sign(_hspd);
        
        _failsafe_x++;
        if (_failsafe_x > 1000) { break; } // Защита от намертво вешающего фриза
    }
    direction = 180 - direction; 
    _is_hit = true;
}

// 4. Проверка удара по вертикали (горизонтальный пол/потолок)
if (place_meeting(x, y + _vspd, [objSolidTall, objDoor]))
{
    var _failsafe_y = 0;
    while (!place_meeting(x, y + sign(_vspd), objSolidTall) && sign(_vspd) != 0) {
        y += sign(_vspd);
        
        _failsafe_y++;
        if (_failsafe_y > 1000) { break; } // Защита от намертво вешающего фриза
    }
    direction = 360 - direction; 
    _is_hit = true;
}