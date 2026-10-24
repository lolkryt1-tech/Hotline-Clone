depth = -15000;
shake = 0;
shake_timer = 0;

_cam = view_camera[0];
my_target = 0;

base_width = 480; 
base_height = 270;

zoom_level = 1.0; 
zoom_min = 0.5;   
zoom_max = 2.5;   

if (instance_exists(objPlayer))
{
    camera_set_view_pos(_cam, objPlayer.x, objPlayer.y);
}

window_set_cursor(cr_none);

// ЗАТЕМНЕНИЕ ЭКРАНА
fade_darkness = 1.0;
fade_speed    = 0.05; // Скорость рассвета

draw_set_font(fntAmmo);
var _dump1 = string_width("PRESS R TO RESTART0123456789");



// Инициализация глобальных переменных
global.cam = view_camera[0];
global.cam_w = camera_get_view_width(global.cam);
global.cam_h = camera_get_view_height(global.cam);

// Запоминаем текущий размер окна, чтобы понять, менялось ли оно
global.last_window_w = window_get_width();
global.last_window_h = window_get_height();

global.cam_scale_x = global.last_window_w / global.cam_w;
global.cam_scale_y = global.last_window_h / global.cam_h;

global.cam_x = camera_get_view_x(global.cam);
global.cam_y = camera_get_view_y(global.cam);