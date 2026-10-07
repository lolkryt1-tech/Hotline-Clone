function scrEnemyDodge()
{
	if (sprite_index != sprColombianDDodge)
	{
		
		if (instance_exists(my_target)) && !scrHasClearView(x, y, my_target.x, my_target.y) { state = STATES.SEARCH; exit; }
		if (instance_exists(my_target)) && isRange_weapon == true { state = STATES.ATTACKRANGE; exit}
		if (instance_exists(my_target)) && isRange_weapon == false { state = STATES.CHASE; exit }
	
		state = STATES.STEP; exit; 
	}
	
	desired_angle = my_angle;
	legs_image_index = 0;
	current_speed = 0;
	start_shooting = false;
	
	image_index += 0.5;
	speed = 0;
	path_end()
}