function scrCanGoStraight()
{
	// === 1. ПРОВЕРКА ЦЕНТРАЛЬНОЙ ЛИНИИ (Самая быстрая и важная) ===
	// Для неё не нужны тригонометрические расчеты смещения плеч
	if (collision_line(x, y, my_target.x, my_target.y, objSolid, false, true))
	{
		// Если центр заблокирован, дальше даже не считаем — идти по прямой нельзя
		can_chase = false;
		return false;
	}

	// === 2. ПОДГОТОВКА ДЛЯ БОКОВЫХ ЛИНИЙ ===
	// Этот код выполнится только если по центру всё чисто
	var _dir_to_player = point_direction(x, y, my_target.x, my_target.y);
	var _enemy_dist    = 9;  
	var _player_dist   = 9; 

	// === 3. ПРОВЕРКА ПРАВОЙ ЛИНИИ ===
	var _right_angle = _dir_to_player - 90;
	var _start_x_1  = x + lengthdir_x(_enemy_dist, _right_angle);
	var _start_y_1  = y + lengthdir_y(_enemy_dist, _right_angle);
	var _target_x_1 = my_target.x + lengthdir_x(_player_dist, _right_angle);
	var _target_y_1 = my_target.y + lengthdir_y(_player_dist, _right_angle);
	
	if (collision_line(_start_x_1, _start_y_1, _target_x_1, _target_y_1, objSolid, false, true))
	{
		can_chase = false;
		return false;
	}

	// === 4. ПРОВЕРКА ЛЕВОЙ ЛИНИИ ===
	var _left_angle = _dir_to_player + 90;
	var _start_x_2  = x + lengthdir_x(_enemy_dist, _left_angle);
	var _start_y_2  = y + lengthdir_y(_enemy_dist, _left_angle);
	var _target_x_2 = my_target.x + lengthdir_x(_player_dist, _left_angle);
	var _target_y_2 = my_target.y + lengthdir_y(_player_dist, _left_angle);
	
	if (collision_line(_start_x_2, _start_y_2, _target_x_2, _target_y_2, objSolid, false, true))
	{
		can_chase = false;
		return false;
	}
	
	// Если все три линии чистые
	can_chase = true;
	return true;
}
