function scrEnemyIdle()
{
	image_index += 0.15;
	
	target_speed = 0;
	
	scrEnemyTryGetTarget();
	if my_target != noone { state = STATES.CHASE; }
}