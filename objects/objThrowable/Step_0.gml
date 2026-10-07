// 1. Если оружие изначально без скорости, сразу спавним обычное и выходим
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
    exit;
}

my_angle = direction; 

var _hspd = lengthdir_x(speed, direction);
var _vspd = lengthdir_y(speed, direction);
var _is_hit = false;

var _blocks = [objSolidTall, objDoor];

// Заранее ищем дверь по курсу полета снаряда (до сдвига и сброса скорости)
var _hit_door = instance_place(x + _hspd, y + _vspd, objDoor);

// 3. Проверка удара по горизонтали
if (place_meeting(x + _hspd, y, _blocks))
{
    var _failsafe_x = 0;
    while (!place_meeting(x + sign(_hspd), y, _blocks) && sign(_hspd) != 0) {
        x += sign(_hspd);
        _failsafe_x++;
        if (_failsafe_x > 1000) { break; }
    }
    _is_hit = true;
}

// 4. Проверка удара по вертикали
if (place_meeting(x, y + _vspd, _blocks))
{
    var _failsafe_y = 0;
    while (!place_meeting(x, y + sign(_vspd), _blocks) && sign(_vspd) != 0) {
        y += sign(_vspd);
        _failsafe_y++;
        if (_failsafe_y > 1000) { break; }
    }
    _is_hit = true;
}

// 5. Логика втыкания в стену или дверь
if (_is_hit)
{
	audio_play_sound(sndKnock, 1, false);
	speed = 0; 
	
	// Спавним специальный застрявший нож
    var _stuck = instance_create_layer(x, y, "Instances", objStuckTrowable);
    _stuck.sprite_index = sprite_index;
    _stuck.image_index  = image_index;
	_stuck.depth	    = depth;
	_stuck.my_angle     = my_angle;
	_stuck.weapon	    = weapon;
	_stuck.ammo		    = ammo;
    
    // Если дверь была найдена по курсу полета — привязываем к ней нож
    if (_hit_door != noone && instance_exists(_hit_door))
    {
        _stuck.attached_door    = _hit_door;
        _stuck.is_stuck_in_door = true;
        
        // Запоминаем изначальную разницу в углах между ножом и дверью
        _stuck.rel_angle = my_angle - _hit_door.image_angle;
        
        // Запоминаем точное расстояние от центра петли двери до текущей точки втыкания ножа
        _stuck.rel_dist = point_distance(_hit_door.x, _hit_door.y, x, y);
        
        // Запоминаем локальный угол направления от центра петли двери до ножа
        _stuck.rel_dir = point_direction(_hit_door.x, _hit_door.y, x, y) - _hit_door.image_angle;
    }
    
    instance_destroy();
}
