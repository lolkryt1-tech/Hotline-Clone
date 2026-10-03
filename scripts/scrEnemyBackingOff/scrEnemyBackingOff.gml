function scrEnemyBackingOff()
{
	// Подстраховка от вылета, если цель исчезла
	if (!instance_exists(my_target)) 
	{ 
		state = STATES.IDLE; 
		exit; 
	}

	var _dir_to_player = point_direction(x, y, my_target.x, my_target.y);
	direction = _dir_to_player; 
	
	var _dist = point_distance(x, y, my_target.x, my_target.y);

	if (_dist < 48)
	{
		// Вычисляем коэффициент: на расстоянии 48 скорость будет 0, в упор (0 пикселей) скорость будет 1.0
		var _push_factor = 1 - (_dist / 48);
		
		// Набираем скорость в зависимости от близости игрока
		target_speed = max_speed * _push_factor;
		
		// ИСПРАВЛЕНО: Рассчитываем чистый ВЕКТОР скорости (микро-шаг от игрока), а не конечные координаты x/y
		var _vel_x = lengthdir_x(current_speed, _dir_to_player + 180);
		var _vel_y = lengthdir_y(current_speed, _dir_to_player + 180);
    
		// Прямой вызов встроенной низкоуровневой функции от YoYo Games на C++
		move_and_collide(_vel_x, _vel_y, objSolid);
		
		direction = _dir_to_player; 
	}
	else
	{
		target_speed = 0;
	}
}
