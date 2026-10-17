var _hspd = lengthdir_x(speed, direction);
var _vspd = lengthdir_y(speed, direction);

// Встроенное перемещение и скольжение на C++ без фризов
var _collisions = move_and_collide(_hspd, _vspd, objSolid);

// Если врезались в стену — останавливаем объект
if (array_length(_collisions) > 0)
{
    speed = 0;
}

// === 3. СОЗДАНИЕ ЛУЖИ КРОВИ ПРИ ОСТАНОВКЕ (УНИВЕРСАЛЬНЫЙ МАСШТАБ) ===
if (speed == 0 && create_blood_pool == 0)
{
	create_blood_pool = 1;
	
	// Средние универсальные настройки лужи для любого типа смерти
	var _head_offset    = 10; 
	var _pool_min_scale = 0.9;
	var _pool_max_scale = 1.3;
	
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
// === 4. ЕДИНЫЕ ЭФФЕКТЫ КРОВИ ПРИ ЛЮБОЙ СМЕРТИ (СТРОГО ПО GO_SPLAT) ===
// =========================================================================
if (go_splat == 1)
{
	go_splat = 0;
	
	// Насыщенное количество брызг для сочности
	var _spawn_count_trails = irandom_range(4, 6); 
	var _spawn_count_splats = irandom_range(8, 11);
	var _spawn_count_smudge = irandom_range(3, 5);
    
	// 1. НАПРАВЛЕННЫЙ КРОВАВЫЙ ДЫМ (Вылетает вперед по ходу движения тела)
	repeat(_spawn_count_trails)
	{
		var _blood_smoke = instance_create_layer(x, y, "Instances", objBloodSmoke);
		var _smoke_dir = direction + random_range(-20, 20);
		_blood_smoke.direction   = _smoke_dir;
		_blood_smoke.image_angle = _smoke_dir;
		_blood_smoke.speed       = random_range(1, 2.5);
	}
	
	// 2. ОБЪЁМНЫЙ КРОВАВЫЙ ДЫМ НА 360 ГРАДУСОВ (Взрывное облако во все стороны в точке удара)
	repeat(5)
	{
		var _rand_smoke = instance_create_layer(x, y, "Instances", objBloodSmoke);
		var _rand_dir = random(360);
		_rand_smoke.direction   = _rand_dir;
		_rand_smoke.image_angle = _rand_dir;
		_rand_smoke.speed       = random_range(0.4, 1.8);
	}
	
	// 3. БОЛЬШИЕ ПЯТНА КРОВИ НА ПОЛУ (Улетают чуть вперед по вектору падения)
	repeat(_spawn_count_splats)
	{
		var _random_x = random_range(-12, 12);
		var _random_y = random_range(-12, 12);
    
		var _random_place_x = x + lengthdir_x(20, direction) + _random_x;
		var _random_place_y = y + lengthdir_y(20, direction) + _random_y;
    
		var _blood = instance_create_layer(_random_place_x, _random_place_y, "Instances", objBloodStain);
		_blood.direction    = irandom(360);
		_blood.image_angle  = _blood.direction;
		_blood.sprite_index = choose(sprBigBlood1, sprBigBlood2);
	}
	
	// 4. РАЗМАЗАННЫЕ МАЗКИ И СЛЕДЫ ЮЗА КРОВИ ОТ ПАДЕНИЯ
	repeat(_spawn_count_smudge)
	{
		var _blood = instance_create_layer(x, y, "Instances", objBloodSmudge);
		_blood.direction    = irandom(360);
		_blood.image_angle  = _blood.direction;
		_blood.speed        = random_range(0.8, 2.5); 
		_blood.sprite_index = choose(sprSmudge1, sprSmudge2, sprSmudge3);
	}
}

// === 5. GUI INTERFACE RESTART ===
// Финальная точка панели на экране по Y (50 пикселей от самого низа)
var _target_y = display_get_gui_height() - 50;

// Плавный выезд снизу вверх через lerp
restart_panel_y = lerp(restart_panel_y, _target_y, 0.12);
