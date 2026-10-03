image_index = image_number - 1; 
image_speed = 0;

/*
if (surface_exists(global.surf_blood))
{
    surface_set_target(global.surf_blood); 
        
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1);
        
    surface_reset_target(); 
}

global.blood_render_counter--;

instance_destroy(); 