// 1. Если скорость сброшена, спавним оружие на полу
if (speed <= 0) 
{
    var _falled_weapon = instance_create_layer(x, y, "Instances", objWeapon);
    _falled_weapon.image_index = image_index;
    _falled_weapon.depth       = depth;
    _falled_weapon.speed       = 0;
    _falled_weapon.my_angle    = my_angle;
    _falled_weapon.weapon      = weapon;
    _falled_weapon.ammo        = ammo;
    instance_destroy();
    exit;
}

my_angle = direction; 

// Вычисляем шаг движения на этом кадре
var _hspd = lengthdir_x(speed, direction);
var _vspd = lengthdir_y(speed, direction);
var _next_x = x + _hspd;
var _next_y = y + _vspd;

// ИСПРАВЛЕНИЕ: Ищем столкновение ЛУЧОМ и со стеной, и с дверью (теперь ничего не пролетит насквозь)
var _hit_wall = collision_line(x, y, _next_x, _next_y, objSolidTall, false, true);
var _hit_door = collision_line(x, y, _next_x, _next_y, objDoor, false, true);

// 2. ЛОГИКА СТОЛКНОВЕНИЯ
if (_hit_wall != noone || _hit_door != noone)
{
    // ОПРЕДЕЛЯЕМ ТОЧКУ КОНТАКТА С ПРЕПЯТСТВИЕМ
    var _failsafe = 0;
    while (true)
    {
        var _next_point_x = x + lengthdir_x(1, direction);
        var _next_point_y = y + lengthdir_y(1, direction);
        
        if (position_meeting(_next_point_x, _next_point_y, objSolidTall) || 
            (_hit_door != noone && position_meeting(_next_point_x, _next_point_y, _hit_door)))
        {
            break; 
        }
        
        x = _next_point_x;
        y = _next_point_y;
        
        _failsafe++;
        if (_failsafe > 100) break; 
    }

    // === ЕСЛИ ПОПАЛИ В ДВЕРЬ — ТОЛЬКО ЗВУКИ И ОСКОЛКИ ДЕРЕВА ===
    if (_hit_door != noone && instance_exists(_hit_door))
    {
        // Воспроизводим случайный звук удара по дереву
        audio_play_sound(choose(sndBulletWoodImpact, sndBulletWoodImpact2, sndBulletWoodImpact3), 10, false);

        // Спавним дым в точке удара (отлетает назад)
        var _smoke = instance_create_layer(x, y, "Instances", objSmokeHit);
        _smoke.image_angle = direction;
        var _random_deviation = random_range(-15, 15);
        _smoke.direction = (direction - 180) + _random_deviation;
        _smoke.speed = random(1);

        var _amount = random(0.5);
        _smoke.color1 = merge_color(c_gray, c_dkgray, _amount);
        _smoke.color2 = merge_color(c_dkgray, c_black, _amount);

        // Спавним 4 деревянных (коричневых) осколка
        repeat (4)
        {
            var _debris = instance_create_layer(x, y, "Instances", objWallDebris);
            _debris.direction = direction - 140 - random(80);
            _debris.speed     = random(4);
            _debris.is_white_wall = false;
            
            var _col_brown_light = make_color_rgb(115, 30, 0);  
            var _col_brown_dark  = make_color_rgb(92, 51, 23);   
            _debris.image_blend  = merge_color(_col_brown_light, _col_brown_dark, random(1));
        }
    }
    else
    {
        // Если попали в обычную стену, играет стандартный глухой стук
        audio_play_sound(sndKnock, 1, false);
    }

    // СБРОС СКОРОСТИ И СПАВН ЗАСТРЯВШЕГО НОЖА
    speed = 0; 
    
    var _stuck = instance_create_layer(x, y, "Instances", objStuckTrowable);
    _stuck.sprite_index = sprite_index;
    _stuck.image_index  = image_index;
    _stuck.depth        = depth;
    _stuck.my_angle     = my_angle;
    _stuck.weapon       = weapon;
    _stuck.ammo         = ammo;
    
    if (_hit_door != noone && instance_exists(_hit_door))
    {
        _stuck.attached_door    = _hit_door;
        _stuck.is_stuck_in_door = true;
        
        _stuck.rel_angle = my_angle - _hit_door.image_angle;
        _stuck.rel_dist  = point_distance(_hit_door.x, _hit_door.y, x, y);
        _stuck.rel_dir   = point_direction(_hit_door.x, _hit_door.y, x, y) - _hit_door.image_angle;
    }
    
    instance_destroy();
    exit;
}
