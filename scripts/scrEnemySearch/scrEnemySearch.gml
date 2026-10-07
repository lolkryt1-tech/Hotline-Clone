function scrEnemySearch()
{
    if (my_target == noone || !instance_exists(my_target))
    {
        state = STATES.STEP;
        searching_path_delay_timer = 0;
        path_delay_timer = 0;
        walk_on_trail = 0;
        impossible_to_path = 0;
        my_target = noone;
        exit;
    }
	
    target_speed = max_speed;
    var clear_view = scrHasClearView(x, y, my_target.x, my_target.y);
    var _distance = point_distance(x, y, my_target.x, my_target.y);
	
    if (clear_view && _distance <= 300)
    {
        last_seen_x = my_target.x;
        last_seen_y = my_target.y;

        if (isRange_weapon == false) { state = STATES.CHASE; sprite_index = my_sprites.sprites.walk; }
        if (isRange_weapon == true) { state = STATES.ATTACKRANGE; sprite_index = my_sprites.sprites.walk; }
        searching_path_delay_timer = 0;
        path_delay_timer = 0;
        walk_on_trail = 0;
        impossible_to_path = 0;
        exit;
    }
	
    // Запускаем расчет пути (он будет циклически перестраиваться по таймеру)
    scrEnemyPathfinding(false, my_target.x, my_target.y);
	
    // === ПЛАН «Б»: НАПРЯМУЮ К LAST SEEN ЕСЛИ ПУТЬ СЛОМАН ===
    if (impossible_to_path > 0 && walk_on_trail != 1)
    {
        if (path_index != -1) path_end();

        var _dist_to_last_seen = point_distance(x, y, last_seen_x, last_seen_y);

        if (_dist_to_last_seen > 32)
        {
            var _dir_to_point = point_direction(x, y, last_seen_x, last_seen_y);
            scrEnemyStrafeMovement(_dir_to_point, current_speed);
            my_angle = _dir_to_point;
            return; 
        }
        else
        {
            path_end(); 
            walk_on_trail = 2; // Прибыли по Плану «Б»
        }
    }

    // === УСЛОВИЕ ОСТАНОВКИ И ОСМОТРА (Вариант А) ===
    var _arrived_at_grid_path = (path_index == -1 && walk_on_trail == 1 && searching_path_delay_timer > 0);
    var _arrived_at_last_seen = (path_index == -1 && walk_on_trail == 2);

    if (_arrived_at_grid_path || _arrived_at_last_seen)
    {
        walk_on_trail = 2; // Блокируем перестройки на время проигрывания анимации
        target_speed = 0;
        path_end(); 
    
        if (sprite_index != my_sprites.sprites.search) 
        { 
            sprite_index = my_sprites.sprites.search;
            image_index = 0; 
            search_timer = irandom_range(90, 140); 
        }
		
		scrEnemyUnstuck();
    
        image_index += 0.15; 
        search_timer--;
    
        if (search_timer > 0) return;
		
        state = STATES.STEP;
        searching_path_delay_timer = 0;
        path_delay_timer = 0;
        walk_on_trail = 0;
        impossible_to_path = 0; 
        my_target = noone;
    }
}
