function scrEnemySearch()
{
    if (my_target == noone || !instance_exists(my_target))
    {
        state = STATES.STEP;
        searching_path_delay_timer = 0;
        path_delay_timer = 0;
        walk_on_trail = 0;
        my_target = noone;
        exit;
    }

    // Теперь читать координаты абсолютно безопасно
    var clear_view = scrHasClearView(x, y, my_target.x, my_target.y);
    var _distance = point_distance(x, y, my_target.x, my_target.y);
	
    if (clear_view && _distance <= 400)
    {
        if (isRange_weapon == false) { state = STATES.CHASE; sprite_index = my_sprites.sprites.walk; }
        if (isRange_weapon == true) { state = STATES.ATTACKRANGE; sprite_index = my_sprites.sprites.walk; }
        searching_path_delay_timer = 0;
        path_delay_timer = 0;
        walk_on_trail = 0;
		
        exit;
    }
	
    scrEnemyPathfinding(false, my_target.x, my_target.y);
	
    if (path_index == -1 && walk_on_trail == 2)
    {
        target_speed = 0;
    
        if (sprite_index != my_sprites.sprites.search) 
        { 
            sprite_index = my_sprites.sprites.search;
            image_index = 0; 
            search_timer = irandom_range(90, 140); 
        }
    
        image_index += 0.15; 
        search_timer--;
    
        if (search_timer > 0) return;
		
        state = STATES.STEP;
        searching_path_delay_timer = 0;
        path_delay_timer = 0;
        walk_on_trail = 0;
        my_target = noone;
    }
}
