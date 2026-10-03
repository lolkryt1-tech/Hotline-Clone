/// @param {Id.Instance} target_weapon Ссылка на конкретный экземпляр оружия (id)
function scrEnemyTryGetWeapon(target_weapon)
{	
	if (my_target == noone)
	{
		hasTriedToGetWeapon = false;
		try_get_weapon_timer = 80;
	}
	
	// 1. ФАЗА ИНИЦИАЛИЗАЦИИ И ПОИСКА ПУТИ
	if (hasTriedToGetWeapon == false)
	{
		hasTriedToGetWeapon = true;
		
		var _weapon_x = target_weapon.x;
		var _weapon_y = target_weapon.y;
			
		// Проверяем прямой путь до центра оружия
		var _path_found = mp_grid_path(global.mp_grid, my_path, x, y, _weapon_x, _weapon_y, true);

		// Если прямой путь заблокирован сеткой mp_grid (оружие лежит в стене)
		if (!_path_found) 
		{
			// Вызываем функцию перебора с шагом 32 пикселя
			var _free_point = scrFindNearestFreeTarget(target_weapon.x, target_weapon.y, 32);
			
			// Если свободная точка рядом найдена и подтверждена сеткой
			if (is_array(_free_point)) 
			{
				_weapon_x = _free_point[0]; // Извлекаем X из массива
				_weapon_y = _free_point[1]; // Извлекаем Y из массива
				
				// Строим окончательный рабочий путь до найденного обхода
				_path_found = mp_grid_path(global.mp_grid, my_path, x, y, _weapon_x, _weapon_y, true);
			}
		}
			
		// Если путь (прямой или в обход) успешно проложен — стартуем движение
		if (_path_found) 
		{ 
			target_speed = max_speed;
			current_speed = max_speed; 
			try_get_weapon_timer = 20;
			path_start(my_path, current_speed, path_action_stop, false);
		}
	} // <- КОНЕЦ блока инициализации пути
	
	// 2. ФАЗА ФИЗИЧЕСКОЙ ДОТЯЖКИ ЧЕРЕЗ MOVE_AND_COLLIDE
	// Включается, когда путь по mp_grid завершился (дошли до точки), либо если пути вообще не было
	if (path_index == -1 && hasTriedToGetWeapon == true) 
	{
		if (try_get_weapon_timer > 0)
		{
			try_get_weapon_timer--;
			target_speed = max_speed;
			
			// ИСПРАВЛЕНО: Рассчитываем чистый ВЕКТОР скорости (направление движения к оружию)
			var _dir_to_weap = point_direction(x, y, target_weapon.x, target_weapon.y);
			var _vel_x = lengthdir_x(target_speed, _dir_to_weap);
			var _vel_y = lengthdir_y(target_speed, _dir_to_weap);
			
			// Прямой вызов встроенной низкоуровневой функции от YoYo Games на C++
			move_and_collide(_vel_x, _vel_y, objSolid);
			
			// Подстраховка угла: если my_target существует, поворачиваемся к нему
			if (my_target != noone && instance_exists(my_target))
			{
				desired_angle = point_direction(x, y, my_target.x, my_target.y);
			}
			
			if (try_get_weapon_timer <= 5) { pickup_distance = 32; }
			return; // Прерываем скрипт, продолжаем физическое скольжение в следующем кадре
		}
	}
	
	// Если враг всё ещё движется по встроенному пути mp_grid — просто ждем окончания
	if (path_index != -1) return;
	
	// 3. ФИНАЛЬНЫЙ КРАХ (Время вышло, дойти не удалось, делаем оружие недоступным)
	var _invalid_weapon = instance_create_layer(target_weapon.x, target_weapon.y, "Instances", objWeaponUnreachable);
	_invalid_weapon.my_angle = target_weapon.my_angle;
	_invalid_weapon.weapon = target_weapon.weapon;
	_invalid_weapon.hover_timer = target_weapon.hover_timer;
		
	_invalid_weapon.image_index = target_weapon.image_index;
	_invalid_weapon.sprite_index = sprColombianAttackM16;
	_invalid_weapon.depth = target_weapon.depth;
	
	hasTriedToGetWeapon = false;
	try_get_weapon_timer = 80;
	instance_destroy(target_weapon); 
	my_target = noone;
}
