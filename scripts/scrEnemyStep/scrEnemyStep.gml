function scrEnemyStep()
{
	if (weapon == WEAPONS.SNIPER) { vision_radius  = 1200; }
	
	path_end();
	sprite_index = my_sprites.sprites.walk;
	
	if move_type = MOVETYPE.STATIC		{ target_speed = 0; }
	if move_type = MOVETYPE.RANDOM		{ scrEnemyRandomStep(); }
	if move_type = MOVETYPE.PATROL		{ scrEnemyPatrolStep(); }
	if move_type = MOVETYPE.FOLLOWWALL	{ scrEnemyFollowWall(); }
	
	// На всякий случай сбрасываем my_target
	if (my_target != noone) { my_target = noone; }
	scrEnemyTryGetTarget();
	
	if my_target != noone && weapon == WEAPONS.SNIPER { state = STATES.ATTACKHITSCAN; exit;}
	if my_target != noone && isRange_weapon == true { state = STATES.ATTACKRANGE; exit;}
	if my_target != noone { state = STATES.CHASE; exit;}
}