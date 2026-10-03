	// @desc Ищет путь до текущей цели врага (my_target) через mp_grid
	/// @param {Bool} update_position True — погоня (обновлять путь), False — идти к точке last_seen (построить путь 1 раз)
	function scrEnemyPathfinding(update_position, target_x, target_y)
	{
	// =========================================================================
	// СЦЕНАРИЙ 1: ВРАГ ВИДИТ ЦЕЛЬ (update_position = true)
	// =========================================================================
	if (update_position)
	{
		if (path_index == -1) path_delay_timer = 0;
		
		target_speed = max_speed; 
		
	    path_delay_timer--;
	    if (path_delay_timer > 0) return; 
		
		// Частота перестройки пути
	    path_delay_timer = 10; 
		 
	    // Пытаемся построить путь
	    if (mp_grid_path(global.mp_grid, my_path, x, y, my_target.x, my_target.y, true))
	    {
	        path_start(my_path, current_speed, path_action_stop, false);
			
	        return; 
	    }
		
		// Невозможно дойти до точки включаем рандомное движение
	    //scrEnemyRandomStep();
	    return; 
	}
    
	// =========================================================================
	// СЦЕНАРИЙ 2: ВРАГ ПОТЕРЯЛ ЦЕЛЬ ИЗ ВИДУ (update_position = false)
	// =========================================================================
	else 
    {
		target_speed = max_speed; 
	
		searching_path_delay_timer--;
		if (searching_path_delay_timer > 0) return;
	
		if (walk_on_trail == 2) return;
        
		var _target_x = my_target.x;
		var _target_y = my_target.y;
		
		// 1. Попытка построить путь напрямую до последней точки цели
		var _path_found = mp_grid_path(global.mp_grid, my_path, x, y, _target_x, _target_y, true);
		
		// 2. Если прямой путь заблокирован (игрок забежал за стену / в тупик)
		if (!_path_found)
		{
			// Ищем ближайшую доступную точку вокруг игрока (радиус 64px, шаг 16px)
			var _free_point = scrFindNearestFreeTarget(_target_x, _target_y, 16);
			
			// Если обходной путь рядом с целью найден
			if (is_array(_free_point))
			{
				_target_x = _free_point[0]; // Извлекаем X
				_target_y = _free_point[1]; // Извлекаем Y
				
				// Строим путь до этой свободной точки
				_path_found = mp_grid_path(global.mp_grid, my_path, x, y, _target_x, _target_y, true);
			}
		}
		
		// 3. Запуск движения, если путь (прямой или обходной) успешно найден
	    if (_path_found)
	    {
			walk_on_trail++;
			searching_path_delay_timer = 15;
		
		    path_start(my_path, current_speed, path_action_stop, false);
		    return;
		}
		// 4. Если даже вокруг цели в радиусе 64 пикселей всё наглухо заблокировано
		else
		{
			impossible_to_path++;
			
			// Важно: ставим задержку, чтобы враг не спамил проверками пути каждый кадр
			searching_path_delay_timer = 30; 
			
	        scrEnemyRandomStep();
	        return;
		}
    }
	}