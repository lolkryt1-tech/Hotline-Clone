if enemy_skin == SKIN.COLOMBIANREGULAR { enemy_sprite = sprColombianDieStomp; }
if enemy_skin == SKIN.COLOMBIANVEST	   { enemy_sprite = sprColombianVestDieStomp; }

// 1. Прирост кадров копа
image_index += 0.15;

// 2. ИДЕАЛЬНАЯ СИНХРОНИЗАЦИЯ: Враг начинает анимацию строго ПОСЛЕ hurt_index с шагом 0.25
if (image_index >= hurt_index) 
{ 
    if (enemy_image_index < 3) 
	{
        enemy_image_index += 0.25; // С шагом 0.25 он дойдет ровно до 3-го кадра к финалу
    } 
	else 
	{
        enemy_image_index = 3; // Фиксируем на финальном кадре смерти
    }
}

// === 3. НАДЕЖНЫЙ МОМЕНТ НАНЕСЕНИЯ УДАРА (Сработает ровно 1 раз на hurt_index) ===
if (image_index >= hurt_index && !triggered_hurt)
{
	triggered_hurt = true; // Фиксируем удар, чтобы код не спамил на кадрах 8.25, 8.5 и т.д.

	// Воспроизведение случайного звука
	var _played_sound = audio_play_sound(sndHit3, 1, false);
	if (_played_sound != -1)
	{
		audio_sound_pitch(_played_sound, random_range(0.9, 1.1));
	}

	// Тряска экрана при ударе
	objEffector.shake = 3.5; 

	// Расстояние от центра (Origin) персонажа до его головы
	var _dist = 30; 
	
	// Жесткая фиксация точки головы
	var _head_offset_x = x + lengthdir_x(_dist, my_angle);
	var _head_offset_y = y + lengthdir_y(_dist, my_angle); 
	
	// Струя 1: Прямо вперед
	repeat(3)
	{
		var _random_direction = my_angle + irandom_range(-15, 15);
	    var _squirt = instance_create_layer(_head_offset_x + irandom_range(-1, 1), _head_offset_y + irandom_range(-1, 1), "Instances", objBloodSquirt);
	    _squirt.image_angle = _random_direction;
	    _squirt.direction = _random_direction;
	}
	
	// Струя 2: Влево под углом 30
	repeat(3)
	{
	    var _squirt = instance_create_layer(_head_offset_x + irandom_range(-2, 2), _head_offset_y + irandom_range(-2, 2), "Instances", objBloodSquirt);
	    _squirt.image_angle = my_angle - 30;
	    _squirt.direction = my_angle - 30;
	}
	
	// Струя 3: Вправо под углом 30
	repeat(3)
	{
	    var _squirt = instance_create_layer(_head_offset_x + irandom_range(-2, 2), _head_offset_y + irandom_range(-2, 2), "Instances", objBloodSquirt);
	    _squirt.image_angle = my_angle + 30;
	    _squirt.direction = my_angle + 30;
	}

	// Спавн 4 облаков дыма крови
	repeat (4)
	{
	    var _smoke_id = instance_create_layer(_head_offset_x, _head_offset_y, "Instances", objBloodSmoke);
	    var _smoke_direction = my_angle + irandom_range(-90, 90); 
	    _smoke_id.direction = _smoke_direction;
	    _smoke_id.image_angle = _smoke_id.direction;
	    _smoke_id.speed = random(2);
	}
}

// === 4. ФИНАЛ АНИМАЦИИ (ВРАГ МЕРТВ, ИГРОК ВОЗВРАЩАЕТСЯ) ===
if (image_index >= finish_index)
{
    var _player = instance_create_layer(x, y, "Instances", objPlayer);
    _player.character      = CHARACTER.COP; 
    
    if (variable_instance_exists(id, "ammo")) _player.ammo = ammo;
	
    _player.my_sprites     = scrPlayerGetWeaponSprite(_player.character, _player.current_weapon);
    _player.sprite_index   = _player.my_sprites.walk; 
    _player.image_index    = 0;
    
    // Создаем статичный труп на полу
    var _body = instance_create_layer(x, y, "Instances", objDeadBody);
    _body.sprite_index = enemy_sprite;
    _body.image_index  = _body.image_number - 1;
    _body.my_angle     = my_angle;
	_body.isExecuted   = true;
    
	scrEnemyUpdateTargetID(id, _player); 
    instance_destroy();
}
