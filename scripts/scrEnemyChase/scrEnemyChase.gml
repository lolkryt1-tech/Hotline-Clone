function scrEnemyChase()
{
	if (!instance_exists(my_target)) 
	{ 
		speed = 0;
		path_end(); // Безопасно останавливаем движение, не ломая переменную my_path
		state = STATES.STEP; 
		my_target = noone;
		exit; 
	}
	
	last_seen_x = my_target.x;
	last_seen_y = my_target.y;
	
	target_speed = max_speed;
	sprite_index = my_sprites.sprites.walk;
	
	if (point_distance(x, y, my_target.x, my_target.y) < 16)
	{
		audio_play_sound(sndSwing1, 1, false);
		
		state = STATES.ATTACKMELEE;
		sprite_index = my_sprites.sprites.attack;
		image_index = 1;
		exit;
	}
	
	// 1. Проверяем прямую видимость
	var clear_view = scrHasClearView(x, y, my_target.x, my_target.y);
	
	if (!clear_view)
	{
		state = STATES.SEARCH;
		exit;
	}
	
	// 2. Проверяем возможность бежать по прямой (наличие стен/препятствий рядом)
	if (!scrCanGoStraight())
	{
		scrEnemyPathfinding(true, my_target.x, my_target.y);
		
		if (path_index == -1) 
		{
			var _pdir = point_direction(x, y, my_target.x, my_target.y);
			scrEnemyStrafeMovement(_pdir, current_speed);
		}
		exit;
	}
	
	// --- КОД НИЖЕ ВЫПОЛНЯЕТСЯ, ТОЛЬКО ЕСЛИ МЫ ОТЛИЧНО ВИДИМ ИГРОКА И ПУТЬ ЧИСТ ---
	path_end();
	path_delay_timer = 0;
	
	var distance_to_player = point_distance(x, y, my_target.x, my_target.y);
    
	// 3. Проверяем дистанцию до игрока
	if (distance_to_player > 8) 
	{
		target_speed = max_speed; 
		
		// Оригинальное движение к игроку через встроенную функцию
		move_towards_point(my_target.x, my_target.y, current_speed);
		return;
	}
    
	// Вплотную к игроку — даем команду плавно остановиться
	target_speed = 0; 
	speed = 0; 
}
