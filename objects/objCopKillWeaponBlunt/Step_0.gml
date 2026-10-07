if (weapon == WEAPONS.SHOTGUN) { sprite_index = sprCopKillShotgun }

if (enemy_skin == SKIN.COLOMBIANREGULAR)	{ enemy_sprite = sprColombianDieCop; }
if (enemy_skin == SKIN.COLOMBIANVEST)		{ enemy_sprite = sprColombianVestDieCop; }

// 1. Увеличенная скорость прироста кадров игрока
image_index += 0.25;

// 2. ИСПРАВЛЕНО: Синхронизированная анимация врага ПОСЛЕ наступления hurt_index
if (image_index >= hurt_index) 
{ 
    if (enemy_image_index < enemy_max_image_index) { 
        // При шаге игрока 0.25, шаг врага 0.75 идеально доведёт его до 3-го кадра к финалу
        enemy_image_index += 0.75; 
    } else {
        enemy_image_index = enemy_max_image_index; // Фиксируем на максимальном кадре (3)
    }
}

// 3. Надежная проверка момента удара (вызовется ровно 1 раз на кадре 7)
if (image_index >= hurt_index && !triggered_hurt)
{
    triggered_hurt = true; 
    
    // === ВОСПРОИЗВЕДЕНИЕ ЗВУКА СТРОГО 1 РАЗ В МОМЕНТ УДАРA ===
    var _played_sound = audio_play_sound(sndHit3, 1, false);
    if (_played_sound != -1)
    {
        audio_sound_pitch(_played_sound, random_range(0.9, 1.1));
    }
    
    objEffector.shake = 5;
    
    // ИСПРАВЛЕНО: Сдвинули сквирт поближе к голове (с 30 до 20)
    var _dist = 20; 
    var _head_offset_x = x + lengthdir_x(_dist, my_angle);
    var _head_offset_y = y + lengthdir_y(_dist, my_angle);
    
    // Струя 1 (Прямо)
    repeat(3)
    {
        var _random_direction = my_angle + irandom_range(-15, 15);
        var _squirt = instance_create_layer(_head_offset_x, _head_offset_y, "Instances", objBloodSquirt);
        _squirt.image_angle = _random_direction;
        _squirt.direction = _random_direction;
    }
    
    // === ИСПРАВЛЕНО: Струя 2 (Влево и чуть вверх, до 2 сквиртов) ===
    var _spawn_left_count = irandom_range(1, 2); // Случайно выбираем 1 или 2 сквирта
    repeat(_spawn_left_count)
    {
        var _bx = _head_offset_x + irandom_range(-3, 3);
        var _by = _head_offset_y + irandom_range(-3, 3);
        var _squirt = instance_create_layer(_bx, _by, "Instances", objBloodSquirt);
        
        // Смещаем угол влево и чуть больше вверх (-45 градусов вместо -30)
        var _dir_left_up = (my_angle - 45) + irandom_range(-5, 5);
        _squirt.image_angle = _dir_left_up;
        _squirt.direction = _dir_left_up;
    }
    
    // Струя 3 (Вправо)
    repeat(3)
    {
        var _cx = _head_offset_x + irandom_range(-3, 3);
        var _cy = _head_offset_y + irandom_range(-3, 3);
        var _squirt = instance_create_layer(_cx, _cy, "Instances", objBloodSquirt);
        _squirt.image_angle = my_angle + 30;
        _squirt.direction = my_angle + 30;
    }

    // === ДОБАВЛЕНО: Спавним 4 облака дыма крови ===
    repeat (4)
    {
        var _smoke_id = instance_create_layer(_head_offset_x, _head_offset_y, "Instances", objBloodSmoke);
        var _smoke_direction = my_angle + irandom_range(-90, 90); 
        _smoke_id.direction = _smoke_direction;
        _smoke_id.image_angle = _smoke_id.direction;
        _smoke_id.speed = random(2);
    }
}

// 4. Финал анимации
if (image_index >= finish_index)
{
    var _body = instance_create_layer(x, y, "Instances", objDeadBody);
    _body.sprite_index = enemy_sprite;
    _body.image_index = _body.image_number - 1; 
    _body.my_angle = my_angle;
    _body.isExecuted = true;
	
	_body.blood_pool_forward_offset = 24; 
    
    var _player = instance_create_layer(x, y, "Instances", objPlayer);
    
    _player.ammo = ammo;
    _player.weapon = weapon;
    
    _player.my_sprites = scrPlayerGetWeaponSprite(CHARACTER.COP, weapon); 
    
    _player.current_weapon = _player.weapon;
    _player.isRange_weapon = _player.my_sprites.is_ranged;
    _player.sprite_index   = _player.my_sprites.walk;
    _player.image_index    = 0;
    
	scrEnemyUpdateTargetID(id, _player); 
    instance_destroy();
}
