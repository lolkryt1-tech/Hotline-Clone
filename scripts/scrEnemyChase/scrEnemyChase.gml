function scrEnemyChase()
{
	if (!instance_exists(my_target)) 
	{ 
		speed = 0;
		path_end(); // Безопасно останавливаем движение, не ломания переменную my_path
		state = STATES.STEP; 
		my_target = noone;
		exit; 
	}
	
	
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
		    // Поворачиваемся лицом к игроку
		    var _pdir = point_direction(x, y, my_target.x, my_target.y);
		    desired_angle = _pdir;
    
		    // Проверка перемещения
		    var _dist_moved = point_distance(x, y, old_x, old_y);
    
		    // Если враг упёрся в стену и почти не двигается
		    if (_dist_moved < 0.2) 
		    {
		        stuck_timer++;
		    }
		    else 
		    {
		        if (stuck_timer > 0) stuck_timer -= 0.5; 
		    }
    
		    old_x = x;
		    old_y = y;
    
		    // 1. КОРОТКИЙ АНТИ-ЗАСТРЕВАЮЩИЙ СТРЕЙФ
		    if (strafe_change_timer > 0)
		    {
		        strafe_change_timer--;
        
		        // Считаем угол вбок (+90 или -90)
		        var _strafe_angle = _pdir + (90 * strafe_dir);
		        var _strafe_speed = target_speed * 0.5; 
        
		        var _vel_x = lengthdir_x(_strafe_speed, _strafe_angle);
		        var _vel_y = lengthdir_y(_strafe_speed, _strafe_angle);
        
		        speed = 0;
		        mask_index = sprPlayerMask;
		        move_and_collide(_vel_x, _vel_y, objSolid);
		    }
		    // 2. РЕГИСТРАЦИЯ ЗАСТРЕВАНИЯ
		    else if (stuck_timer > 30) // Упёрся и стоит полсекунды
		    {
		        stuck_timer = 0;
		        strafe_dir = choose(1, -1);
		        strafe_change_timer = irandom_range(12, 18); 
		    }
		    // 3. ОБЫЧНОЕ ДВИЖЕНИЕ НА ИГРОКА
		    else
		    {
		        speed = 0;
		        mask_index = sprPlayerMask;
		        
		        var _vel_x = lengthdir_x(target_speed, _pdir);
		        var _vel_y = lengthdir_y(target_speed, _pdir);
		        
		        move_and_collide(_vel_x, _vel_y, objSolid);
		    }
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
        
        // ВЕРНУЛ: Оригинальное движение к игроку через встроенную функцию
        move_towards_point(my_target.x, my_target.y, current_speed);
        return;
    }
    
    // Вплотную к игроку — даем команду плавно остановиться
    target_speed = 0; 
    speed = 0; 
}
