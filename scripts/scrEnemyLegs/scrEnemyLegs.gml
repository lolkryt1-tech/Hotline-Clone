function scrEnemyLegs()
{
	legs_direction = direction;
	
	if (current_speed > 0.6)
	{
		legs_image_index += legs_animation_speed * (current_speed * 0.8);
		return; 
	}
	
	
	var current_cycle_pos = floor(legs_image_index % 8);
		
	if (current_cycle_pos == 0 || current_cycle_pos == 8)
	{
		legs_image_index = 0;
		return;
	}
	
	// Дошагиваем до идеальной позы: назад или вперед
	if (current_cycle_pos < 4)  { legs_image_index -= legs_animation_speed; }
	if (current_cycle_pos >= 4) { legs_image_index += legs_animation_speed; } 
}