image_index += 0.25;
enemy_image_index += 0.25;

// === 1. МОМЕНТ НАНЕСЕНИЯ УДАРА СТРОГО НА HURT_INDEX ===
if (image_index == hurt_index)
{
	triggered_hurt = true;
	
	// === ВОСПРОИЗВЕДЕНИЕ СЛУЧАЙНОГО ЗВУКА СТРОГО 1 РАЗ ===
	var _played_sound = audio_play_sound(sndHit3, 1, false);
	if (_played_sound != -1)
	{
		audio_sound_pitch(_played_sound, random_range(0.9, 1.1));
	}

	// === ТРЯСКА ЭКРАНА ПРИ УДАРЕ ===
	objEffector.shake = 3.5; 

	// Расстояние от центра (Origin) персонажа до его головы
	var _dist = -6; 
	
	// Направление в сторону игрока (разворот на 180 градусов от направления стены)
	var _blood_base_dir = my_angle - 180;
	
	// ЖЕСТКАЯ ФИКСАЦИЯ ТОЧКИ ГОЛОВЫ БЕЗ ЛИШНИХ СМЕЩЕНИЙ
	var _head_offset_x = x + lengthdir_x(_dist, my_angle);
	var _head_offset_y = y + lengthdir_y(_dist, my_angle); 
	
	// Струя 1: Прямо в игрока
	repeat(3)
	{
		var _random_direction = _blood_base_dir + irandom_range(-15, 15);
		
		// Добавляем микро-отклонение для капель прямо в параметры спавна
	    var _squirt = instance_create_layer(_head_offset_x + irandom_range(-1, 1), _head_offset_y + irandom_range(-1, 1), "Instances", objBloodSquirt);
	    _squirt.image_angle = _random_direction;
	    _squirt.direction = _random_direction;
	}
	
	// Струя 2: Чуть левее игрока (на 30 градусов)
	repeat(3)
	{
	    var _squirt = instance_create_layer(_head_offset_x + irandom_range(-2, 2), _head_offset_y + irandom_range(-2, 2), "Instances", objBloodSquirt);
	    _squirt.image_angle = _blood_base_dir - 30;
	    _squirt.direction = _blood_base_dir - 30;
	}
	
	// Струя 3: Чуть правее игрока (на 30 градусов)
	repeat(3)
	{
	    var _squirt = instance_create_layer(_head_offset_x + irandom_range(-2, 2), _head_offset_y + irandom_range(-2, 2), "Instances", objBloodSquirt);
	    _squirt.image_angle = _blood_base_dir + 30;
	    _squirt.direction = _blood_base_dir + 30;
	}

	// Струя 4: Прямо в игрока с небольшим рассеиванием для плотности
	repeat(3)
	{
		var _dense_direction = _blood_base_dir + irandom_range(-10, 10);
		
	    var _squirt = instance_create_layer(_head_offset_x + irandom_range(-2, 2), _head_offset_y + irandom_range(-2, 2), "Instances", objBloodSquirt);
	    _squirt.image_angle = _dense_direction;
	    _squirt.direction = _dense_direction;
	}

	// === ДОБАВЛЕНО: СПАВН 4 ОБЛАКОВ ДЫМА КРОВИ В СТОРОНУ ИГРОКА ===
	repeat (4)
	{
		// Используем те же зафиксированные координаты без рандомизации основы
	    var _smoke_id = instance_create_layer(_head_offset_x, _head_offset_y, "Instances", objBloodSmoke);
		
		// Веер разброса в 180 градусов направлен строго от стены на копа
	    var _smoke_direction = _blood_base_dir + irandom_range(-90, 90);
	    _smoke_id.direction = _smoke_direction;
	    _smoke_id.image_angle = _smoke_id.direction;
	    _smoke_id.speed = random(2);
	}
}

// === 2. ФИНАЛ АНИМАЦИИ (ВРАГ МЕРТВ, ИГРОК ВОЗВРАЩАЕТСЯ) ===
if (image_index >= finish_index)
{
    // Спавним копа на сохраненных безопасных координатах (вне коллизии стены!)
    var _player = instance_create_layer(return_x, return_y, "Instances", objPlayer);
    _player.character      = CHARACTER.COP;
    _player.weapon         = WEAPONS.UNARMED; 
    _player.current_weapon = _player.weapon;
    
    // Пересобираем и выставляем спрайты ходьбы
    _player.my_sprites     = scrPlayerGetWeaponSprite(_player.character, _player.current_weapon);
    _player.sprite_index   = _player.my_sprites.walk;
    _player.image_index    = 0;
    
    // Создаем труп врага на месте стены (в точке x и y объекта казни)
    var _body = instance_create_layer(x, y, "Instances", objDeadBody);
    _body.sprite_index = enemy_sprite;
    _body.image_index  = _body.image_number - 1;
    _body.my_angle     = my_angle;
	_body.isExecuted   = true;
	_body.hit_type     = HIT_TYPE.STOMP;
    
	scrEnemyUpdateTargetID(id, _player); 
    instance_destroy();
}
