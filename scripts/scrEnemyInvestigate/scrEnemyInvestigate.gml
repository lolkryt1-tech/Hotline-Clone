function scrEnemyInvestigate()
{
// 1. ПОСТОЯННО БДИМ: если враг по пути заметил игрока — мгновенно бросаем расследование и бежим атаковать
	scrEnemyTryGetTarget();
	
	if (my_target != noone)
	{
		path_end(); // Сбрасываем путь расследования шума
		if (isRange_weapon == true) { state = STATES.ATTACKRANGE; exit; }
		else { state = STATES.CHASE; exit; }
	}
	
	// Включаем нужные параметры движения и анимацию
	sprite_index = my_sprites.sprites.walk;
	target_speed = max_speed;

	// 2. ФАЗА ИНИЦИАЛИЗАЦИИ И ПОИСКА ПУТИ К ШУМУ
	// Если путь еще не запущен (path_index == -1), значит мы только что услышали звук
	if (path_index == -1)
	{
		var _target_x = noise_x;
		var _target_y = noise_y;
			
		// Проверяем путь через вашу глобальную сетку mp_grid
		var _path_found = mp_grid_path(global.mp_grid, my_path, x, y, _target_x, _target_y, true);

		// Если точка шума оказалась внутри стены (например, игрок выстрелил в упор к углу)
		if (!_path_found) 
		{
			// Вызываем вашу функцию перебора с шагом 32 пикселя
			var _free_point = scrFindNearestFreeTarget(noise_x, noise_y, 32);
			
			// If свободная точка рядом найдена — перестраиваем маршрут на нее
			if (is_array(_free_point)) 
			{
				_target_x = _free_point[0]; 
				_target_y = _free_point[1]; 
				
				_path_found = mp_grid_path(global.mp_grid, my_path, x, y, _target_x, _target_y, true);
			}
		}
			
		// Если путь успешно проложен — стартуем движение по mp_grid
		if (_path_found) 
		{ 
			current_speed = max_speed; 
			path_start(my_path, current_speed, path_action_stop, false);
		}
		else
		{
			// Защита: если путь проложить вообще никак невозможно, сбрасываем состояние
			state = STATES.STEP;
			exit;
		}
	}
	
	// 3. ПРОВЕРКА ДОСТИЖЕНИЯ ТОЧКИ ШУМА
	// Как только путь завершился и path_index сбросился в -1 — значит враг успешно прибежал на место
	if (path_index == -1)
	{
		target_speed = 0;
		current_speed = 0;
		
		// Возвращаем врага в обычный режим, чтобы он продолжил патруль или встал на пост
		state = STATES.STEP; 
	}
}