// СЛИШКОМ БОЛЬШОЙ ХОЛС
function scrDrawBlood()
{
	//return;
	
	if (surface_exists(global.surf_blood))
	{
	    surface_set_target(global.surf_blood); 
	
	    image_xscale *= 2;
	    image_yscale *= 2;
    
	    // Рисуем на увеличенную поверхность (координаты тоже х4)
	    draw_sprite_ext(sprite_index, image_index, x * 2, y * 2, image_xscale, image_yscale, image_angle, image_blend, 1);
        
	    surface_reset_target(); 
	}
	
	instance_destroy();
	
}