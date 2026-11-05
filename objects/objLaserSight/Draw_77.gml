if (!laser_active) exit;
if (!instance_exists(owner_inst)) exit;

// Считаем мировые координаты в реальном времени
var _offset = 16;
var _dir = owner_inst.my_angle;
var _muzzle_x = owner_inst.x + lengthdir_x(_offset, _dir);
var _muzzle_y = owner_inst.y + lengthdir_y(_offset, _dir);
var _target_x = _muzzle_x + lengthdir_x(laser_dist, _dir);
var _target_y = _muzzle_y + lengthdir_y(laser_dist, _dir);

// Переводим в экранные с помощью глобалов (СТРОГО ОКОННЫЙ МАСШТАБ, как в рабочем коде)
var _sx = (_muzzle_x - global.cam_x) * global.cam_scale_x;
var _sy = (_muzzle_y - global.cam_y) * global.cam_scale_y;
var _tx = (_target_x - global.cam_x) * global.cam_scale_x;
var _ty = (_target_y - global.cam_y) * global.cam_scale_y;

// ХАРДМОД: Зеркалим относительно динамического размера окна, а не GUI!
if (global.hard) {
    _sx = global.last_window_w - _sx;
    _sy = global.last_window_h - _sy;
    _tx = global.last_window_w - _tx;
    _ty = global.last_window_h - _ty;
}

var _prev_color = draw_get_color();
var _prev_alpha = draw_get_alpha();

// Используем draw_alpha (для нарастания у врага)
draw_set_alpha(draw_alpha);

// Лазер (ВСЕГДА КРАСНЫЙ)
draw_set_color(c_red);
draw_line_width(_sx, _sy, _tx, _ty, 1);

// Точка попадания (тоже красная, если попали в стену)
if (laser_hit_wall) {
    draw_set_color(c_red);
    draw_circle(_tx, _ty, 4, false);
}

draw_set_color(_prev_color);
draw_set_alpha(_prev_alpha);
