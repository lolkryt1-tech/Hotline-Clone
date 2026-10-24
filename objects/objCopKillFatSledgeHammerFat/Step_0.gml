// 1. Прирост кадров копа
image_index += 0.2;

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
	var _dist = 16; 
	
	// Жесткая фиксация точки головы
	var _head_offset_x = x + lengthdir_x(_dist, my_angle);
	var _head_offset_y = y + lengthdir_y(_dist, my_angle); 
	
	// Струя 1: Прямо вперед
	repeat(2)
	{
		var _random_direction = my_angle + irandom_range(-15, 15);
	    var _squirt = instance_create_layer(_head_offset_x + irandom_range(-1, 1), _head_offset_y + irandom_range(-1, 1), "Instances", objBloodSmoke);
	    _squirt.image_angle = _random_direction;
	    _squirt.direction = _random_direction;
	}
	
	// Струя 2: Влево под углом 30
	repeat(1)
	{
	    var _squirt = instance_create_layer(_head_offset_x + irandom_range(-2, 2), _head_offset_y + irandom_range(-2, 2), "Instances", objBloodSmoke);
	    _squirt.image_angle = my_angle - 30;
	    _squirt.direction = my_angle - 30;
	}
	
	// Струя 3: Вправо под углом 30
	repeat(3)
	{
	    var _squirt = instance_create_layer(_head_offset_x + irandom_range(-2, 2), _head_offset_y + irandom_range(-2, 2), "Instances", objBloodSmoke);
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
	
    _player.current_weapon = WEAPONS.SLEDGEHAMMER;
    _player.my_sprites     = scrPlayerGetWeaponSprite(_player.character, _player.current_weapon);
    _player.sprite_index   = _player.my_sprites.walk; 
    _player.image_index    = 0;
    
    // === РАСЧЕТ ОФФСЕТА ДЛЯ СПАВНА ТРУПА ===
    var _spawn_offset = 16; // На сколько пикселей сдвинуть труп толстяка вперед
    var _body_x = x + lengthdir_x(_spawn_offset, my_angle);
    var _body_y = y + lengthdir_y(_spawn_offset, my_angle);
    
    // === ВЫЗОВ ОБЪЕКТА С УЧЕТОМ СМЕЩЕНИЯ ===
	// === ВЫБОР СПРАЙТА ТРУПА ПО СКИНУ ===
	var _body_spr = sprColombianFatDeadSledgeHammer; // дефолт для FAT
	switch (enemy_skin)
	{
	    case SKIN.COLOMBIANFAT:     _body_spr = sprColombianFatDeadSledgeHammer;     break;
	    case SKIN.COLOMBIANFATVEST: _body_spr = sprColombianFatVestDeadSledgeHammer; break;
	}

	var _body = instance_create_layer(_body_x, _body_y, "Instances", objAnimatedDeadBody);
	_body.sprite_index = _body_spr;
	_body.image_index  = 0;
	_body.my_angle     = my_angle;
    
    // Передаем параметры стейт-машины
    _body.death_type   = ANIM_DEATH.CONVULSIONS; 
    _body.death_timer  = 360 + irandom(120);      
    
    _body.isExecuted   = true; 
    
    scrEnemyUpdateTargetID(id, _player); 
    instance_destroy();
}
