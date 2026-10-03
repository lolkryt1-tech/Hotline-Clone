if (!surface_exists(global.surf_debris_gore)) 
{
    global.surf_debris_gore = surface_create(room_width, room_height);
    
    // Очищаем новую поверхность прозрачным цветом, чтобы она не была черной
    surface_set_target(global.surf_debris_gore);
    draw_clear_alpha(c_black, 0);
    surface_reset_target();
}

draw_surface(global.surf_debris_gore, 0, 0);