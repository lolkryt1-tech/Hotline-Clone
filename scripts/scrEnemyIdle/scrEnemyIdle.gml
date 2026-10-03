function scrEnemyIdle()
{
	sprite_index = my_sprites.sprites.idle;
	image_index += 0.15;
	
	target_speed = 0;
	
	scrEnemyTryGetTarget();
	if my_target != noone { state = STATES.CHASE; }
}