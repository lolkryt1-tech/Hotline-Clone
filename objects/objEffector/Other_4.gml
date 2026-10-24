camera_set_view_pos(_cam, global.next_effector_x, global.next_effector_y);

/*
// ЧТОБЫ ПРИ РЕСТАРТЕ ПРАВИЛЬНО ВЫСЧИТЫВАЛИСЬ РАЗМЕРЫ ЭКРАНА
global.cam = view_camera[0];
global.cam_x = camera_get_view_x(global.cam);
global.cam_y = camera_get_view_y(global.cam);
global.cam_w = camera_get_view_width(global.cam);
global.cam_h = camera_get_view_height(global.cam);

global.cam_scale_x = window_get_width() / global.cam_w;
global.cam_scale_y = window_get_height() / global.cam_h;