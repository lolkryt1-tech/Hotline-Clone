var _hspd = lengthdir_x(speed, direction);
var _vspd = lengthdir_y(speed, direction);

// 1. Вызываем встроенную низкоуровневую функцию перемещения и скольжения.
var _collisions = move_and_collide(_hspd, _vspd, objSolid);

// 2. Если массив не пустой, значит мы обо что-то ударились.
if (array_length(_collisions) > 0)
{
    speed = 0;
}

// === 3. СОЗДАНИЕ ЛУЖИ КРОВИ ПРИ ОСТАНОВКЕ (РАБОТАЕТ ВСЕГДА) ===
if (speed == 0 && create_blood_pool == 0)
{
	create_blood_pool = 1;
	
	// Базовое смещение для стандартных ударов по умолчанию
	var _head_offset = 15; 
	var _pool_min_scale = 0.8;
	var _pool_max_scale = 1.2;
	
	// ДИНАМИЧЕСКИЙ РАСЧЕТ СМЕЩЕНИЯ И МАСШТАБА ОТ ТИПА УДАРA
	switch (hit_type)
	{
		case HIT_TYPE.STOMP: // Растаптывание у стены
			_head_offset    = 0;
			_pool_min_scale = 0.5;
			_pool_max_scale = 0.8;
			break;
			
		case HIT_TYPE.BULLET: // Пулевое ранение в туловище
			_head_offset    = 0;
			_pool_min_scale = 1.2;
			_pool_max_scale = 1.5;
			break;
			
		case HIT_TYPE.CUT: // Порез шеи
			_head_offset    = 7;
			_pool_min_scale = 0.9;
			_pool_max_scale = 1.3;
			break;
			
		case HIT_TYPE.BLUNT: // Обычный удар битой
			_head_offset    = 15;
			_pool_min_scale = 0.8;
			_pool_max_scale = 1.2;
			break;
	}
	
	// ПОДСТРАХОВКА: Если это настенная казнь или сидячий труп — лужа строго в центре x, y
	if (isExecuted == true) _head_offset = 0;
	
	// Рассчитываем итоговую позицию
	var _spawn_x = x + lengthdir_x(_head_offset, my_angle);
	var _spawn_y = y + lengthdir_y(_head_offset, my_angle);
	
	var _pool = instance_create_layer(_spawn_x, _spawn_y, "Instances", objBloodPool);
	
	if (instance_exists(_pool))
	{
		_pool.image_angle  = random(360);
		_pool.image_xscale = random_range(_pool_min_scale, _pool_max_scale);
		_pool.image_yscale = _pool.image_xscale;
	}
}

// =========================================================================
// === 4. ЭФФЕКТЫ КРОВИ ПРИ УДАРЕ БУТАФОРИЕЙ (HIT_TYPE.BLUNT) ===
// =========================================================================
if (hit_type == HIT_TYPE.BLUNT && go_splat == 1)
{
	go_splat = 0;
	
	var _spawn_count_trails = irandom_range(3, 5); 
	var _spawn_count_splats = irandom_range(7, 9);
	var _spawn_count_smudge = irandom_range(3, 5);
    
	// 1. Дым летит веером назад от вектора удара (на игрока)
	repeat(_spawn_count_trails)
	{
		var _blood_smoke = instance_create_layer(x, y, "Instances", objBloodSmoke);
		var _smoke_dir = (my_angle - 180) + random_range(-10, 10);
		_blood_smoke.direction   = _smoke_dir;
		_blood_smoke.image_angle = _smoke_dir;
		_blood_smoke.speed       = random(2);
	}
	
	// 2. Кровавый дым на 360 градусов (рандом во все стороны)
	repeat(4)
	{
		var _rand_smoke = instance_create_layer(x, y, "Instances", objBloodSmoke);
		var _rand_dir = random(360);
		_rand_smoke.direction   = _rand_dir;
		_rand_smoke.image_angle = _rand_dir;
		_rand_smoke.speed       = random_range(0.5, 2);
	}
	
	// Большие пятна крови
	repeat(_spawn_count_splats)
	{
		var _random_x = random_range(-15, 15);
		var _random_y = random_range(-15, 15);
    
		var _random_place_x = x + lengthdir_x(15, direction) + _random_x;
		var _random_place_y = y + lengthdir_y(15, direction) + _random_y;
    
		var _blood = instance_create_layer(_random_place_x, _random_place_y, "Instances", objBloodStain);
		_blood.direction    = irandom(360);
		_blood.image_angle  = _blood.direction;
		_blood.sprite_index = choose(sprBigBlood1, sprBigBlood2);
	}
	
	// Мазки/размазанная кровь
	repeat(_spawn_count_smudge)
	{
		var _blood = instance_create_layer(x, y, "Instances", objBloodSmudge);
		_blood.direction    = irandom(360);
		_blood.image_angle  = _blood.direction;
		_blood.speed        = random_range(1, 3); 
		_blood.sprite_index = choose(sprSmudge1, sprSmudge2, sprSmudge3);
	}
}

// =========================================================================
// === 5. ЭФФЕКТЫ КРОВИ ПРИ ОГНЕСТРЕЛЕ (HIT_TYPE.BULLET) ===
// =========================================================================
if (hit_type == HIT_TYPE.BULLET && go_splat == 1)
{
	go_splat = 0;
	
	var _spawn_count_trails = irandom_range(4, 6);  
	var _spawn_count_splats = irandom_range(8, 12); 
	var _spawn_count_smudge = irandom_range(2, 4);
    
	repeat(_spawn_count_trails)
	{
		var _blood_smoke = instance_create_layer(x, y, "Instances", objBloodSmoke);
		var _smoke_dir = my_angle + random_range(-25, 25);
		_blood_smoke.direction   = _smoke_dir;
		_blood_smoke.image_angle = _smoke_dir;
		_blood_smoke.speed       = random_range(1, 3); 
	}
	
	repeat(5)
	{
		var _rand_smoke = instance_create_layer(x, y, "Instances", objBloodSmoke);
		var _rand_dir = random(360);
		_rand_smoke.direction   = _rand_dir;
		_rand_smoke.image_angle = _rand_dir;
		_rand_smoke.speed       = random_range(0.3, 1.5);
	}
	
	repeat(_spawn_count_splats)
	{
		var _random_x = random_range(-10, 10);
		var _random_y = random_range(-10, 10);
    
		var _random_place_x = x + lengthdir_x(25, direction) + _random_x;
		var _random_place_y = y + lengthdir_y(25, direction) + _random_y;
    
		var _blood = instance_create_layer(_random_place_x, _random_place_y, "Instances", objBloodStain);
		_blood.direction    = irandom(360);
		_blood.image_angle  = _blood.direction;
		_blood.sprite_index = choose(sprBigBlood1, sprBigBlood2);
	}
	
	repeat(_spawn_count_smudge)
	{
		var _blood = instance_create_layer(x, y, "Instances", objBloodSmudge);
		_blood.direction    = irandom(360);
		_blood.image_angle  = _blood.direction;
		_blood.speed        = random_range(0.5, 2); 
		_blood.sprite_index = choose(sprSmudge1, sprSmudge2, sprSmudge3);
	}
}

if (hit_type == HIT_TYPE.PELLET && go_splat == 1)
{
	go_splat = 0;
	
	var _spawn_count_trails = irandom_range(4, 6);  
	var _spawn_count_splats = irandom_range(8, 12); 
	var _spawn_count_smudge = irandom_range(2, 4);
    
	repeat(_spawn_count_trails)
	{
		var _blood_smoke = instance_create_layer(x, y, "Instances", objBloodSmoke);
		var _smoke_dir = my_angle + random_range(-25, 25);
		_blood_smoke.direction   = _smoke_dir;
		_blood_smoke.image_angle = _smoke_dir;
		_blood_smoke.speed       = random_range(1, 3); 
	}
	
	repeat(5)
	{
		var _rand_smoke = instance_create_layer(x, y, "Instances", objBloodSmoke);
		var _rand_dir = random(360);
		_rand_smoke.direction   = _rand_dir;
		_rand_smoke.image_angle = _rand_dir;
		_rand_smoke.speed       = random_range(0.3, 1.5);
	}
	
	repeat(_spawn_count_splats)
	{
		var _random_x = random_range(-10, 10);
		var _random_y = random_range(-10, 10);
    
		var _random_place_x = x + lengthdir_x(25, direction) + _random_x;
		var _random_place_y = y + lengthdir_y(25, direction) + _random_y;
    
		var _blood = instance_create_layer(_random_place_x, _random_place_y, "Instances", objBloodStain);
		_blood.direction    = irandom(360);
		_blood.image_angle  = _blood.direction;
		_blood.sprite_index = choose(sprBigBlood1, sprBigBlood2);
	}
	
	repeat(_spawn_count_smudge)
	{
		var _blood = instance_create_layer(x, y, "Instances", objBloodSmudge);
		_blood.direction    = irandom(360);
		_blood.image_angle  = _blood.direction;
		_blood.speed        = random_range(0.5, 2); 
		_blood.sprite_index = choose(sprSmudge1, sprSmudge2, sprSmudge3);
	}
}

// === КРИТИЧЕСКИЙ ФИКС: Переносим проверку блокировки в самый конец! ===
// Теперь код успеет и лужу пустить, и веерные брызги go_splat отработать на первом кадре.
if (isExecuted == true) return;
