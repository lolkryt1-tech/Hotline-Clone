if (trigger_delay > 0) 
{  
    trigger_delay--; 
    image_alpha = 0.5; 
}
wait_timer--;

// Дверь больше сама никого не считает! Она просто верит блокноту менеджера
var _current_idx = global.current_level.current_floor;
if (global.current_level.floors[_current_idx].is_cleared == true)
{
    is_unlocked = true; 
    image_alpha = 1;
}
else
{
    is_unlocked = false;
    image_alpha = 0; 
}
