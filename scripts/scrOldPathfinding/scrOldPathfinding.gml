function scrOldPathfinding()
{
	/// @desc Ищет путь до текущей цели врага (my_target) через mp_grid
/// @param {Bool} update_position True — погоня (обновлять путь), False — идти к точке last_seen (построить путь 1 раз)
function scrEnemyPathfinding(update_position, target_x, target_y)
{
    // =========================================================================
    // БЛОК 0: ПРОВЕРКА НА ЗАСТРЕВАНИЕ (ВЫСШИЙ ПРИОРИТЕТ)
    // =========================================================================
    var cell_size = 8;
    var current_cell_x = x div cell_size;
    var current_cell_y = y div cell_size;
    
    // Проверяем, находится ли центр юнита в заблокированной ячейке сетки
    i_am_stuck = (mp_grid_get_cell(global.mp_grid, current_cell_x, current_cell_y) == -1);

    if (i_am_stuck) 
    {
        i_am_stuck_ticks++;
        #region Находим ближайшую свободную (зеленую) ячейку
        var target_escape_x = x;
        var target_escape_y = y;
        var found_green = false;

        for (var xx = -1; xx <= 1; xx++) 
        {
            for (var yy = -1; yy <= 1; yy++) 
            {
                if (mp_grid_get_cell(global.mp_grid, current_cell_x + xx, current_cell_y + yy) == 0) 
                {
                    target_escape_x = ((current_cell_x + xx) * cell_size) + (cell_size / 2);
                    target_escape_y = ((current_cell_y + yy) * cell_size) + (cell_size / 2);
                    found_green = true;
                    break; 
                }
            }
            if (found_green) break; 
        }
        #endregion
        
        if (found_green) 
        {
            // Мягко выталкиваем врага в свободную зону
            move_towards_point(target_escape_x, target_escape_y, current_speed);
            safe_x = target_escape_x;
            safe_y = target_escape_y;
        }
        
        show_debug_message("Юнит застрял в сетке! Вытаскиваем...");
        return; // Выходим из скрипта на этом кадре, чтобы дать ему сместиться
    }

    // =========================================================================
    // СЦЕНАРИЙ 1: ВРАГ ВИДИТ ЦЕЛЬ (update_position = true)
    // =========================================================================
    if (update_position)
    {
        path_delay_timer--;
    
        // Если таймер тикает, просто выходим
        if (path_delay_timer > 0) return; 
    
        // Таймер упал до нуля — сбрасываем его
        path_delay_timer = 10; 
        
        // Переводим глобальный контроллер в режим активного движения
        target_speed = max_speed; 
        
        // ВАЖНО: Сбрасываем старый путь перед тем, как строить новый до движущейся цели
        if (path_index == my_path) path_end(); 
        
        // Пытаемся построить путь
        if (mp_grid_path(global.mp_grid, my_path, x, y, my_target.x, my_target.y, true))
        {
            path_start(my_path, current_speed, path_action_stop, false);
            return; 
        }
        
        // --- ЕСЛИ ПУТЬ ПО СЕТКЕ НЕ НАЙДЕН (например, цель вне сетки или заблокирована) ---
        if (collision_line(x, y, my_target.x, my_target.y, objSolid, false, false))
        {
            show_debug_message("Путь заблокирован стеной, но юнит не застрял.");
            return;
        }
		
		/*
        // Прямое скольжение вдоль стен
        var _direction = point_direction(x, y, my_target.x, my_target.y);
        var next_x = x + lengthdir_x(current_speed, _direction);
        var next_y = y + lengthdir_y(current_speed, _direction);
            
        if (!place_meeting(next_x, next_y, objSolid))
        {
            mp_linear_step(my_target.x, my_target.y, current_speed, false);
            return;
        }
            
        if (!place_meeting(next_x, y, objSolid)) 
        {
            x = next_x;
        }
        else if (!place_meeting(x, next_y, objSolid))
        {
            y = next_y;
        }
		*/
        
        return; 
    }
    
    // =========================================================================
    // СЦЕНАРИЙ 2: ВРАГ ПОТЕРЯЛ ЦЕЛЬ ИЗ ВИДУ (update_position = false)
    // =========================================================================
    else 
    {
		
		var _last_seen_x = target_x + my_target.hor_velocity;
		var _last_seen_y = target_y + my_target.ver_velocity;
		
        // Если уже пришли в последнюю точку — останавливаемся
        if (point_distance(x, y, target_x, target_y) <= 4)
        {
            target_speed = 0; 
            if (path_index == my_path) path_end(); 
            return;
        }
        
        // Удерживаем запрос на движение
        target_speed = max_speed; 
            
        // ИСПРАВЛЕНО: Проверяем, назначен ли путь И движется ли объект по нему прямо сейчас.
        // Если объект уже выполняет 'my_path' и ещё не дошёл до конца (position < 1), 
        // то мы просто выходим и не насилуем mp_grid_path каждый кадр.
        if (path_index == my_path && path_position < 1) return;
        
        // Сюда код попадет только если путь еще не был построен, ИЛИ если старый путь уже завершился
        if (mp_grid_path(global.mp_grid, my_path, x, y, target_x, target_y, true))
        {
			path_update_count++;
            path_start(my_path, current_speed, path_action_stop, false);
            return;
        }
                
        // Обходной код скольжения, если путь до last_seen заблокирован в сетке
		/*
        var _dir_lost = point_direction(x, y, last_seen_x, last_seen_y);
        var next_lost_x = x + lengthdir_x(current_speed, _dir_lost);
        var next_lost_y = y + lengthdir_y(current_speed, _dir_lost);
                    
        if (!place_meeting(next_lost_x, next_lost_y, objSolid))
        {
            mp_linear_step(last_seen_x, last_seen_y, current_speed, false);
            return;
        }
                    
        if (!place_meeting(next_lost_x, y, objWall)) 
        {
            x = next_lost_x;
        }
        else if (!place_meeting(x, next_lost_y, objWall)) 
        {
            y = next_lost_y;
        }
		*/
    }
}
}

/*
function scrEnemyPathfindingSearch(my_target)
{
	target_speed = max_speed; 
	
    if (path_index != -1) return;
        
    // Сюда код попадет только если путь еще не был построен, ИЛИ если старый путь уже завершился
    if (mp_grid_path(global.mp_grid, my_path, x, y, my_target.x, my_target.y, true))
    {
		path_update_count++;
        path_start(my_path, current_speed, path_action_stop, false);
        return;
    }
}