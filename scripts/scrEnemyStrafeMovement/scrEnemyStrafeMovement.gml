/// @desc Управляет стрейфом и обычным движением врага по направлению к цели
/// @param {Real} _pdir Направление на цель (в градусах)
/// @param {Real} _target_speed Базовая скорость движения врага
function scrEnemyStrafeMovement(_pdir, _target_speed)
{
	desired_angle = _pdir;
    
	// Проверка перемещения (застрял ли враг физически)
	var _dist_moved = point_distance(x, y, old_x, old_y);
    
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
        
		var _strafe_angle = _pdir + (90 * strafe_dir);
		var _strafe_speed = _target_speed * 0.5; 
        
		var _vel_x = lengthdir_x(_strafe_speed, _strafe_angle);
		var _vel_y = lengthdir_y(_strafe_speed, _strafe_angle);
        
		move_and_collide(_vel_x, _vel_y, objSolid);
	}
	// 2. РЕГИСТРАЦИЯ ЗАСТРЕВАНИЯ — УМНЫЙ ВЫБОР СТОРОНЫ
	else if (stuck_timer > 30)
	{
		stuck_timer = 0;
		
		// Проверяем, куда свободнее — влево или вправо
		var _check_dist = 32;
		
		var _left_angle  = _pdir + 90;
		var _right_angle = _pdir - 90;
		
		var _left_x  = x + lengthdir_x(_check_dist, _left_angle);
		var _left_y  = y + lengthdir_y(_check_dist, _left_angle);
		var _right_x = x + lengthdir_x(_check_dist, _right_angle);
		var _right_y = y + lengthdir_y(_check_dist, _right_angle);
		
		var _left_free  = !place_meeting(_left_x,  _left_y,  objSolid);
		var _right_free = !place_meeting(_right_x, _right_y, objSolid);
		
		if (_left_free && !_right_free)
		{
			strafe_dir = 1;   // влево свободно
		}
		else if (_right_free && !_left_free)
		{
			strafe_dir = -1;  // вправо свободно
		}
		else
		{
			// Обе стороны свободны или обе заняты — рандом
			strafe_dir = choose(1, -1);
		}
		
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