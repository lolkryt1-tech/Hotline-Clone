/// @desc Управляет стрейфом и обычным движением врага по направлению к цели, предотвращая застревание
/// @param {Real} pdir Направление на цель (в градусах)
/// @param {Real} target_spd Базовая скорость движения врага
function scrEnemyStrafeMovement(_pdir, _target_speed)
{
	desired_angle = _pdir;
    
	// Проверка перемещения (застрял ли враг физически)
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
	
	speed = 0;

	// 1. КОРОТКИЙ АНТИ-ЗАСТРЕВАЮЩИЙ СТРЕЙФ
	if (strafe_change_timer > 0)
	{
		strafe_change_timer--;
        
		// Считаем угол вбок (+90 или -90)
		var _strafe_angle = _pdir + (90 * strafe_dir);
		var _strafe_speed = _target_speed * 0.5; 
        
		var _vel_x = lengthdir_x(_strafe_speed, _strafe_angle);
		var _vel_y = lengthdir_y(_strafe_speed, _strafe_angle);
        
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
		var _vel_x = lengthdir_x(_target_speed, _pdir);
		var _vel_y = lengthdir_y(_target_speed, _pdir);
        
		move_and_collide(_vel_x, _vel_y, objSolid);
	}
}
