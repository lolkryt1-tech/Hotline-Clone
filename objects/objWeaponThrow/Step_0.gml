// 1. Если оружие изначально без скорости, сразу спавним его на месте и выходим
if (speed <= 0) 
{
    var _falled_weapon = instance_create_layer(x, y, "Instances", objWeapon);
    _falled_weapon.image_index = image_index;
	_falled_weapon.depth	   = depth;
	_falled_weapon.speed       = 0;
	
    _falled_weapon.my_angle    = my_angle;
	_falled_weapon.weapon	   = weapon;
	_falled_weapon.ammo		   = ammo;
    
    instance_destroy();
    exit; // Ранний выход
}

// 2. Вращение и расчет шага полёта
my_angle += speed * 4; 

var _hspd = lengthdir_x(speed, direction);
var _vspd = lengthdir_y(speed, direction);
var _is_hit = false;

// === ИСПРАВЛЕНО: Массив объектов, от которых оружие должно отскакивать ===
var _blocks = [objSolidTall, objDoor];

// 3. Проверка удара по горизонтали (вертикальные стены и двери)
if (place_meeting(x + _hspd, y, _blocks))
{
    var _failsafe_x = 0;
    while (!place_meeting(x + sign(_hspd), y, _blocks) && sign(_hspd) != 0) {
        x += sign(_hspd);
        
        _failsafe_x++;
        if (_failsafe_x > 1000) { break; } // Защита от намертво вешающего фриза
    }
    direction = 180 - direction; 
    _is_hit = true;
}

// 4. Проверка удара по вертикали (горизонтальный пол/потолок и двери)
if (place_meeting(x, y + _vspd, _blocks))
{
    var _failsafe_y = 0;
    while (!place_meeting(x, y + sign(_vspd), _blocks) && sign(_vspd) != 0) {
        y += sign(_vspd);
        
        _failsafe_y++;
        if (_failsafe_y > 1000) { break; } // Защита от намертво вешающего фриза
    }
    direction = 360 - direction; 
    _is_hit = true;
}

// 5. Если был удар, спавним оружие с отскоком и уничтожаем этот объект
if (_is_hit)
{
	audio_play_sound(sndKnock, 1, false);
	
    var _falled_weapon = instance_create_layer(x, y, "Instances", objWeapon);
    _falled_weapon.image_index = image_index;
    _falled_weapon.direction   = direction; 
	_falled_weapon.depth	   = depth;
    _falled_weapon.speed       = 4;
	
	_falled_weapon.my_angle    = my_angle;
	_falled_weapon.weapon	   = weapon;
	_falled_weapon.ammo		   = ammo;
    
    instance_destroy();
}
