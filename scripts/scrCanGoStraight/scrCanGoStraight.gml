function scrCanGoStraight()
{
	// 1. Считаем направление от врага к игроку
	var _dir_to_player = point_direction(x, y, my_target.x, my_target.y);

	// 2. Углы для смещения (плечи врага и бока игрока)
	var _right_angle = _dir_to_player - 90;
	var _left_angle  = _dir_to_player + 90;

	// Дистанция смещения (ширина тела врага и игрока)
	var _enemy_dist  = 9;  // От центра врага до его плеча
	var _player_dist = 9; // От центра игрока до его бока (настройте под размер квадрата)

	// 3. Считаем СТАРТОВЫЕ точки (плечи врага)
	var _start_x_1 = x + lengthdir_x(_enemy_dist, _right_angle);
	var _start_y_1 = y + lengthdir_y(_enemy_dist, _right_angle);

	var _start_x_2 = x + lengthdir_x(_enemy_dist, _left_angle);
	var _start_y_2 = y + lengthdir_y(_enemy_dist, _left_angle);

	// 4. Считаем КОНЕЧНЫЕ точки (бока квадратного хитбокса игрока)
	var _target_x_1 = my_target.x + lengthdir_x(_player_dist, _right_angle);
	var _target_y_1 = my_target.y + lengthdir_y(_player_dist, _right_angle);

	var _target_x_2 = my_target.x + lengthdir_x(_player_dist, _left_angle);
	var _target_y_2 = my_target.y + lengthdir_y(_player_dist, _left_angle);
	
	if (!collision_line(_start_x_1, _start_y_1, _target_x_1, _target_y_1, objSolid, false, true) && 
	    !collision_line(_start_x_2, _start_y_2, _target_x_2, _target_y_2, objSolid, false, true))
	{
		can_chase = true;
		return true;
	}
	
	can_chase = false;
	return false;
}