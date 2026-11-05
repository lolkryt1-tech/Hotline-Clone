if (!instance_exists(objLightController)) exit;
if (global.gui_w <= 0 || global.gui_h <= 0) exit; 

// 1. Расчет координат строго на основе масштаба GUI (не окна!)
var _sx = (x - global.cam_x) * global.gui_scale_x;
var _sy = (y - global.cam_y) * global.gui_scale_y;
var _tx = (target_x - global.cam_x) * global.gui_scale_x;
var _ty = (target_y - global.cam_y) * global.gui_scale_y;

// 2. Зеркальное отражение точек относительно ширины и высоты GUI-слоя
if (global.hard) {
    _sx = global.gui_w - _sx;
    _sy = global.gui_h - _sy;
    _tx = global.gui_w - _tx;
    _ty = global.gui_h - _ty;
}

// 3. Отрисовка геометрии трейсера
var _prev_color = draw_get_color();
var _prev_alpha = draw_get_alpha();

draw_set_alpha(alpha);

// Обводка линии
draw_set_color(c_dkgray);
draw_line_width(_sx, _sy, _tx, _ty, 4); 

// Центральная часть трейсера
draw_set_color(c_white);
draw_line_width(_sx, _sy, _tx, _ty, 2);

draw_set_color(_prev_color);
draw_set_alpha(_prev_alpha);
