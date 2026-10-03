function scrEnemyPathfindingSearch(my_target)
{
	target_speed = max_speed; 
	
	searching_path_delay_timer--
	if (searching_path_delay_timer > 0) return;
	
	if (walk_on_trail == 2) return;
        
    // Сюда код попадет только если путь еще не был построен, ИЛИ если старый путь уже завершился
    if (mp_grid_path(global.mp_grid, my_path, x, y, my_target.x, my_target.y, true))
    {
		walk_on_trail++
		searching_path_delay_timer = 15;
		
        path_start(my_path, current_speed, path_action_stop, false);
        return;
    }
}