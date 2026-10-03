function scrPlayerAnimatedLegs(_input_vector)
{
	 if (x != xprevious || y != yprevious)
    {
        var target_direction = point_direction(xprevious, yprevious, x, y);
        var diff = angle_difference(legs_direction, target_direction);
        legs_direction -= diff * 0.5;
    }
	
    // Анимация шага или плавное дошагивание при остановке
    if (_input_vector.magnitude() > 0)
    {
        legs_image_index += legs_animation_speed;
		
		if (!is_attacking && !is_turning ) { image_index += 0.15; } 
		
    }
    else
    {
        var current_cycle_pos = floor(legs_image_index % 8);
		
        if (current_cycle_pos == 0 || current_cycle_pos == 8)
        {
            legs_image_index = 0;
            return;
        }
		
        if (current_cycle_pos < 4)  { legs_image_index -= legs_animation_speed; }
        if (current_cycle_pos >= 4) { legs_image_index += legs_animation_speed; } 
    }
}