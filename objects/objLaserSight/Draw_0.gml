if (!instance_exists(objLightController)) {
    if (!laser_active) exit; // Если дуло в стене, не рисуем
    if (!instance_exists(owner_inst)) exit;

    var _offset = 16;
    var _dir = owner_inst.my_angle;
    
    // Считаем координаты в реальном времени
    var _muzzle_x = owner_inst.x + lengthdir_x(_offset, _dir);
    var _muzzle_y = owner_inst.y + lengthdir_y(_offset, _dir);
    
    var _target_x = _muzzle_x + lengthdir_x(laser_dist, _dir);
    var _target_y = _muzzle_y + lengthdir_y(laser_dist, _dir);

    var _prev_color = draw_get_color();
    var _prev_alpha = draw_get_alpha();
    
    // КРАСНЫЙ ЛАЗЕР
    draw_set_alpha(draw_alpha);
    draw_set_color(c_red); 
    draw_line(_muzzle_x, _muzzle_y, _target_x, _target_y);
    
    draw_set_color(_prev_color);
    draw_set_alpha(_prev_alpha);
}