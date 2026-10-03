// === 1. ОБРАБОТКА БУФЕРА ВВОДА (ПРОБЕЛ) ===
if (keyboard_check_pressed(vk_space))
{
	input_buffer = true;
	input_buffer_time = 10;
}

if (input_buffer_time > 0)
{
	input_buffer_time--;
	if (input_buffer_time <= 0) input_buffer = false;
}

// === 2. КРУТИМ АНИМАЦИЮ ИГРОКА ===
image_index += 0.25; 

// === 3. МОМЕНТ ВЫСТРЕЛА (Индекс 11 копа) ===
if (floor(image_index) == 11 && !triggered_hurt)
{
	triggered_hurt = true;
	hit_count++; // Засчитываем выстрел (1, 2 или 3)
	
	// Мгновенный импульс тела в момент выстрела (убираем опоздание)
	if (hit_count == 1) enemy_image_index = 1; 
	if (hit_count == 2) enemy_image_index = 5; 
	if (hit_count == 3) enemy_image_index = 9; 
	
	var _played_sound_shot = audio_play_sound(snd9mmShot, 1, false); 
	if (_played_sound_shot != -1) audio_sound_pitch(_played_sound_shot, random_range(0.9, 1.1));
	
	var _played_sound_hit = audio_play_sound(sndBulletHit1, 1, false); 
	if (_played_sound_hit != -1) audio_sound_pitch(_played_sound_hit, random_range(0.9, 1.1));
	objEffector.shake = 5;
	
	var _dist = 20; 
	var _head_offset_x = x + lengthdir_x(_dist, my_angle);
	var _head_offset_y = y + lengthdir_y(_dist, my_angle);

	// === СПАВН ГИЛЬЗЫ ===
	var _shell = instance_create_layer(_head_offset_x, _head_offset_y, "Instances", objShell);
	_shell.direction   = (my_angle - 90) + irandom_range(-25, 25); 
	_shell.image_angle = irandom(360); 
	_shell.speed       = random_range(2, 4); 
	if (variable_instance_exists(_shell, "image_index")) { _shell.image_index = 0; }
	
	// =========================================================================
	// ===              СПАВН КРОВИ (СЛУЧАЙНЫЕ НАПРАВЛЕНИЯ)                  ===
	// =========================================================================
	// Струя 1 (Прямо — теперь с большим случайным разбросом углов)
	repeat(2)
	{
		var _random_direction = my_angle + irandom_range(-35, 35); // Увеличили разброс для сочности
		var _squirt = instance_create_layer(_head_offset_x, _head_offset_y, "Instances", objBloodSquirt);
		_squirt.image_angle = _random_direction;
		_squirt.direction = _random_direction;
	}
    
	// Струя 2 (Влево и вверх — случайный угол в секторе)
	var _bx = _head_offset_x + irandom_range(-2, 2);
	var _by = _head_offset_y + irandom_range(-2, 2);
	var _squirt_left = instance_create_layer(_bx, _by, "Instances", objBloodSquirt);
	var _dir_left_up = (my_angle - irandom_range(30, 60)); // Рандомный сектор от -30 до -60 градусов
	_squirt_left.image_angle = _dir_left_up;
	_squirt_left.direction = _dir_left_up;
    
	// Струя 3 (Вправо — случайный угол в секторе)
	var _cx = _head_offset_x + irandom_range(-2, 2);
	var _cy = _head_offset_y + irandom_range(-2, 2);
	var _squirt_right = instance_create_layer(_cx, _cy, "Instances", objBloodSquirt);
	var _r_dir = my_angle + irandom_range(15, 45); // Рандомный сектор от +15 до +45 градусов
	_squirt_right.image_angle = _r_dir;
	_squirt_right.direction = _r_dir;

	// Кровавые облака дыма (полностью случайное направление во все стороны)
	repeat (2)
	{
		var _smoke_id = instance_create_layer(_head_offset_x, _head_offset_y, "Instances", objBloodSmoke);
		var _smoke_direction = irandom(360); // ИСПРАВЛЕНО: Теперь облака тумана летят абсолютно куда угодно
		_smoke_id.direction = _smoke_direction;
		_smoke_id.image_angle = _smoke_direction;
		_smoke_id.speed = random_range(0.5, 1.5);
	}
	// =========================================================================
	
	// Отдача копа назад
	if ((keyboard_check(vk_space) || input_buffer) && hit_count < 3)
	{
		image_index = 8;			// ЗАДЕРЖКА МЕЖДУ ВЫСТРЕЛАМИ
		input_buffer = false; 
	}
}

if (floor(image_index) != 11)
{
	triggered_hurt = false;
}

// === 4. ЧЕСТНОЕ ЗАТИХАНИЕ ИНЕРЦИИ ТЕЛА ВРАГА (ШАГ 0.2) ===
var _target_enemy_max = 0; 
if (hit_count == 1) _target_enemy_max = 4;  
if (hit_count == 2) _target_enemy_max = 8;  
if (hit_count >= 3) _target_enemy_max = 11; 

if (hit_count == 0)
{
	enemy_image_index = 0; 
}
else 
{
	if (enemy_image_index < _target_enemy_max) 
	{
		enemy_image_index += 0.2; 
	}
	if (enemy_image_index > _target_enemy_max) 
	{
		enemy_image_index = _target_enemy_max; 
	}
}

// === 5. ТОЧКА ПРОВЕРКИ И ВЫХОДА ИЗ КАЗНИ (Индекс 13 копа) ===
if (floor(image_index) == 13)
{
	if ((keyboard_check(vk_space) || input_buffer) && hit_count < 3)
	{
		image_index = 7; 
		input_buffer = false; 
	}
	else 
	{
		var _body = instance_create_layer(x, y, "Instances", objDeadBody);
		_body.sprite_index = enemy_sprite;
		
		_body.image_speed  = 0; 
		_body.image_index  = floor(enemy_image_index); 
		
		_body.my_angle     = my_angle;
		_body.isExecuted   = true;
		_body.hit_type     = HIT_TYPE.BULLET; 
		_body.go_splat     = false;
		_body.class        = enemy_class;
		
		var _player = instance_create_layer(x, y, "Instances", objPlayer);
		_player.ammo           = ammo;
		_player.current_weapon = weapon; 
		
		_player.my_sprites     = scrPlayerGetWeaponSprite(CHARACTER.COP, weapon); 
		_player.isRange_weapon = _player.my_sprites.is_ranged;
		_player.sprite_index   = _player.my_sprites.walk;
		_player.image_index    = 0;
		
		instance_destroy();
		exit;
	}
}
