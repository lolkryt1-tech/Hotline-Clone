if (!instance_exists(objLightController)) exit;

// В Draw GUI используем размеры GUI, а не окна!
var _w = display_get_gui_width();
var _h = display_get_gui_height();
if (_w <= 0 || _h <= 0) exit;

var _cam   = view_camera[0];
var _cam_x = camera_get_view_x(_cam);
var _cam_y = camera_get_view_y(_cam);
var _cam_w = camera_get_view_width(_cam);
var _cam_h = camera_get_view_height(_cam);

var _scale_x = _w / _cam_w;
var _scale_y = _h / _cam_h;

var _sx = (x - _cam_x) * _scale_x;
var _sy = (y - _cam_y) * _scale_y;
var _tx = (target_x - _cam_x) * _scale_x;
var _ty = (target_y - _cam_y) * _scale_y;

var _prev_color = draw_get_color();
var _prev_alpha = draw_get_alpha();

draw_set_alpha(alpha);

// Обводка
draw_set_color(c_dkgray);
draw_line_width(_sx, _sy, _tx, _ty, 4); 

// Трейсер
draw_set_color(c_white);
draw_line_width(_sx, _sy, _tx, _ty, 2);

draw_set_color(_prev_color);
draw_set_alpha(_prev_alpha);