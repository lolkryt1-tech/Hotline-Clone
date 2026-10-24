x = mouse_x;
y = mouse_y;

global.cam_x = camera_get_view_x(global.cam);
global.cam_y = camera_get_view_y(global.cam);
global.cam_w = camera_get_view_width(global.cam);
global.cam_h = camera_get_view_height(global.cam);

// ОБНОВЛЯЕМ МАСШТАБ КАЖДЫЙ КАДР (как в лазере)
global.cam_scale_x = window_get_width() / global.cam_w;
global.cam_scale_y = window_get_height() / global.cam_h;

// АВТОМАТИЧЕСКИЙ РАССВЕТ (Срабатывает только если игрок НЕ стоит на стрелочке)
if (fade_darkness > 0) 
{
    fade_darkness = max(fade_darkness - fade_speed, 0.0);
}
