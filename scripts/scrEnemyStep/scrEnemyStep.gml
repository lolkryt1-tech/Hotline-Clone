function scrEnemyStep()
{
	path_end();
	sprite_index = my_sprites.sprites.walk;
	
	if move_type = MOVETYPE.STATIC { target_speed = 0; }
	if move_type = MOVETYPE.RANDOM { scrEnemyRandomStep(); }
	if move_type = MOVETYPE.PATROL { scrEnemyPatrolStep(); }
	
	// На всякий случай сбрасываем my_target
	if (my_target != noone) { my_target = noone; }
	scrEnemyTryGetTarget();
	
	if my_target != noone && isRange_weapon == true { state = STATES.ATTACKRANGE; exit;}
	if my_target != noone { state = STATES.CHASE; exit;}
}