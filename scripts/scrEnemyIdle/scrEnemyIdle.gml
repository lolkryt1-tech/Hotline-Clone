function scrEnemyIdle()
{
	image_index += 0.15;
	
	target_speed = 0;
	
	scrEnemyTryGetTarget();
	if my_target != noone 
	{ 
		if (weapon == WEAPONS.UNARMED) 
		{ 
			my_sprites = scrEnemyGetSprite(skin, weapon);
			state = STATES.UNARMEDSEARCH;
			sprite_index = my_sprites.sprites.walk;
			exit; 
		}
		
		if (isRange_weapon == true) { state = STATES.ATTACKRANGE; exit } 
		if (isRange_weapon == false) { state = STATES.CHASE; exit } 
	}
}