//draw_text(x, y, velocity.magnitude());

draw_sprite_ext(sprCopLegs, legs_image_index, x, y, image_xscale, image_yscale, legs_direction, image_blend, image_alpha);
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, my_angle, image_blend, image_alpha);

if (global.debug == 0) return;
// === ОТРИСОВКА УДАРА
if (debug_melee_timer > 0)
{
    debug_melee_timer--; 

    var _wp_data = scrPlayerGetWeaponSprite(character, current_weapon);
    var _hit_type = _wp_data.melee_type; 
    
    var _mouse_dir = point_direction(x, y, mouse_x, mouse_y);
    var _reach = (_hit_type == HIT_TYPE.BLUNT) ? 24 : 18; 
    var _close_radius = 8; // Наш внутренний круг
    var _attack_half_angle = 45; 

    // ---- ОТРИСОВКА ВНУТРЕННЕГО КРУГА ----
    draw_set_color(c_orange); // Оранжевый цвет для ближнего круга
    draw_circle(x, y, _close_radius, true);

    // ---- ОТРИСОВКА КОНУСА ----
    var _angle_left  = _mouse_dir + _attack_half_angle;
    var _angle_right = _mouse_dir - _attack_half_angle;

    var _lx = x + lengthdir_x(_reach, _angle_left);
    var _ly = y + lengthdir_y(_reach, _angle_left);
    var _rx = x + lengthdir_x(_reach, _angle_right);
    var _ry = y + lengthdir_y(_reach, _angle_right);

    draw_set_color(c_lime); // Зеленый цвет для конуса
    draw_line(x, y, _lx, _ly);
    draw_line(x, y, _rx, _ry);

    // Отрисовка дуги конуса
    var _steps = 8;
    var _prev_x = _lx;
    var _prev_y = _ly;
    var _angle_step = (_attack_half_angle * 2) / _steps;

    for (var i = 1; i <= _steps; i++)
    {
        var _curr_angle = _angle_left - (i * _angle_step);
        var _cx = x + lengthdir_x(_reach, _curr_angle);
        var _cy = y + lengthdir_y(_reach, _curr_angle);
        draw_line(_prev_x, _prev_y, _cx, _cy); 
        _prev_x = _cx;
        _prev_y = _cy;
    }
    
    draw_set_color(c_white); // Сброс цвета
}


draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,true)

// Рисуем лучи только во время замаха кулаками
if (sprite_index == sprCopAttackPunch)
{
    var _mouse_dir = point_direction(x, y, mouse_x, mouse_y);
    var _reach = 28;
    var _close_radius = 8;
    
    var _cx = x + lengthdir_x(_reach, _mouse_dir);
    var _cy = y + lengthdir_y(_reach, _mouse_dir);
    
    // Включаем красный дебаг-цвет
    draw_set_color(c_white);
    
    // 1. Рисуем один луч взгляда из центра головы
    draw_line(x, y, _cx, _cy);
    
    // 2. Рисуем контур круга проверки "в упор" (true на конце означает только контур, без заливки)
    draw_circle(x, y, _close_radius, true);
    
    draw_set_color(c_white);
}

var _surfaces_count = 0;
// Проверяем первые 64 возможных ID поверхностей в памяти
for (var i = 0; i < 64; i++) 
{
    if (surface_exists(i)) 
    {
        _surfaces_count++;
    }
}

// Рисуем рядом с вашим счетчиком инстансов
draw_text(x + 15, y + 0, "Total surfaces: " + string(_surfaces_count));

draw_text(x + 15, y + 30, "Total instances: " + string(instance_number(all)));

draw_text(x + 15, y + 45, instance_number(objEffector));

/*
// Либо прямо на экран:
//draw_text(x + 15, y, "Активных путей: " + string(_active_paths));
draw_text(x + 15, y, "Слой трупов: " + string(global.body_render_counter));
draw_text(x + 15, y + 15, "Слой крови: " + string(global.blood_render_counter));
draw_text(x + 15, y + 30, "Всего объектов: " + string(instance_number(all)));

//draw_text(x + 15, y + 45, "Current Weapon : " + string(current_weapon));

//if (mouse_check_button(mb_side1)) { draw_text(x + 15, y + 45, "Mouse4 pressed")}
//if (mouse_check_button(mb_side2)) { draw_text(x + 15, y + 45, "Mouse5 pressed")}