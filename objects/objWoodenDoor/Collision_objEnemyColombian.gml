// 1. ЖЕСТКИЙ СЦЕНАРИЙ: Дверь летит на высокой скорости от толчка игрока или пули
if (abs(swingspeed) > 3.5 && (swinger == 1 || swinger == 0)) 
{
	objEffector.shake = 5;
	
    var _owner = other.id;
    var _hit_dir = image_angle + (swingspeed > 0 ? -90 : 90);
    
    var _knocked = instance_create_layer(_owner.x, _owner.y, "Instances", objEnemyKnockedOut);
    _knocked.direction   = _hit_dir - 180; 
    _knocked.speed       = 4;
    _knocked.my_angle    = _hit_dir;
    _knocked.image_index = 1;
    _knocked.faction     = _owner.faction;
    _knocked.class       = _owner.class;
                    
    if (_owner.weapon != WEAPONS.UNARMED)
    {
        var _dropped = instance_create_layer(_owner.x, _owner.y, "Instances", objWeapon);
        _dropped.direction = _hit_dir + irandom_range(-20, 20); 
        _dropped.speed     = 5;
        _dropped.my_angle  = irandom(360);
        _dropped.weapon    = _owner.weapon;
    }
    
    instance_destroy(_owner);
}
// 2. АККУРАТНЫЙ СЦЕНАРИЙ: Враг просто идет и мягко толкает дверь перед собой
else 
{
    // Если дверь уже открывается с достаточной скоростью, не пересчитываем толчок
    if (abs(swingspeed) > 2) exit;
    
    // Ставим отметку, что дверь взаимодействует с врагом
    swinger = 2; 

    // Звук мягкого открытия
    if (abs(swingspeed) < 0.5 && asset_get_index("sndDoorOpen") != -1) 
    {
        audio_play_sound(sndDoorOpen, 0, false);
    }

    // Вычисляем вектор от петли двери до врага
    var _to_enemy_x = other.x - x;
    var _to_enemy_y = other.y - y;

    var _enemy_dir = point_direction(0, 0, _to_enemy_x, _to_enemy_y);
    var _angle_diff = angle_difference(_enemy_dir, image_angle);

    // Увеличили скорость до 6, чтобы преодолеть порог доводчика (3.5) в Step Event.
    // Также принудительно доворачиваем image_angle на 1 градус, чтобы выйти из зоны захлопывания.
    if (_angle_diff > 0) 
    {
        swingspeed = -6; 
        if (image_angle == start_angle) image_angle -= 1;
    } 
    else 
    {
        swingspeed = 6;  
        if (image_angle == start_angle) image_angle += 1;
    }
}
