// 1. Берем самые свежие размеры окна прямо сейчас
var _win_w = window_get_width();
var _win_h = window_get_height();

// Запоминаем их для проверки изменений в будущем
global.last_window_w = _win_w;
global.last_window_h = _win_h;

// 2. Обновляем параметры камеры
global.cam_x = camera_get_view_x(global.cam);
global.cam_y = camera_get_view_y(global.cam);
global.cam_w = camera_get_view_width(global.cam);
global.cam_h = camera_get_view_height(global.cam);

// Масштаб окна (подстраивается при Alt + Enter мгновенно)
global.cam_scale_x = _win_w / global.cam_w;
global.cam_scale_y = _win_h / global.cam_h;

// Размеры GUI нам больше не нужны для позиционирования лазеров и пуль
global.gui_w = display_get_gui_width();
global.gui_h = display_get_gui_height();
global.gui_scale_x = global.gui_w / global.cam_w;
global.gui_scale_y = global.gui_h / global.cam_h;

// === ТАБЛИЦА СОСТОЯНИЙ ЭФФЕКТОРА ===
switch (state)
{
    case CAMSTATES.GAME:       scrCameraGame();     break;
    case CAMSTATES.LEVEL_END:  scrCameraLevelEnd(); break;
}
