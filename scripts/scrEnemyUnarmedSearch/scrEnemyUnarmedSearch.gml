function scrEnemyUnarmedSearch()
{
    // ИСПРАВЛЕНО: Проверяем не просто на noone, но и на физическое существование цели в комнате.
    // Если оружие/цель удалены с карты другим объектом — сбрасываем и ищем заново.
	if (my_target == noone || !instance_exists(my_target))  
	{ 
		hasTriedToGetWeapon = false;
		try_get_weapon_timer = 80;
		
		path_end();
		scrEnemyTryGetTarget();
		scrEnemyRandomStep(); 
		return;
	}
	
	// Теперь читать object_index на 100% безопасно
	if (my_target.object_index == objWeapon)
	{
		scrEnemyTryGetWeapon(my_target);
		if (my_target == noone) { return; }
		
	    // Если бот еще далеко — выходим и ждем
	    if (point_distance(x, y, my_target.x, my_target.y) > pickup_distance) return; 
		
		path_end();
		
		// Оружие там - сям
	    my_sprites = scrEnemyGetSprite(skin, my_target.weapon);
		audio_play_sound(sndPickUpWeapon, 1, false);
	    weapon = my_target.weapon;
		ammo   = my_target.ammo;
		
	    instance_destroy(my_target); 
		
	    my_target = noone; 
	    state = STATES.STEP;
		exit;
	}
	else
	{
		scrEnemyTryGetTarget();
		
		if (path_index != -1) path_end();
	
		var _clear_view = scrHasClearView(x, y, my_target.x, my_target.y);
		if (!_clear_view) 
		{ 
			my_target = noone; 
			return; 
		}
		
		scrEnemyBackingOff();
	}
}
