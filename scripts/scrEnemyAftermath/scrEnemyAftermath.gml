function scrEnemyAftermath()
{	
	if (!instance_exists(my_target)) 
	{ 
		state = STATES.IDLE; 
		exit; 
	}
	
	var inverse_dir = point_direction(x, y, my_target.x, my_target.y) - 180;
	
	if (point_distance(x, y, my_target.x, my_target.y) < 32)
	{
		target_speed = 0.5;
		image_index += 0.1;
		
		// ИСПРАВЛЕНО: Рассчитываем чистый ВЕКТОР скорости (смещение), а не новые координаты x/y
		var _vel_x = lengthdir_x(target_speed, inverse_dir);
		var _vel_y = lengthdir_y(target_speed, inverse_dir);
		
		// ИСПРАВЛЕНО: Прямой вызов встроенной низкоуровневой функции от YoYo Games на C++
		move_and_collide(_vel_x, _vel_y, objSolid);
	}
	else
	{
		target_speed = 0;
	}
	
	direction = inverse_dir - 180;
}
