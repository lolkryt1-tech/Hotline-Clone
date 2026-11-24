
// 1. Берем самые свежие размеры окна прямо сейчас
var _win_w = max(window_get_width(), 1);
var _win_h = max(window_get_height(), 1);

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


// ==========================================
// === УПРАВЛЕНИЕ ВИРТУАЛЬНЫМ КУРСОРОМ ===
// ==========================================

if (state == CAMSTATES.GAME && window_has_focus())
{
	// === АВТОМАТИЧЕСКИЙ "ШИФТ" ===
	if (scrBindCheckPressed("toggle_look_further"))
	{
	    global.look_further_toggle = !global.look_further_toggle;
	}
	
    // Захватываем мышь, если она ещё не захвачена.
    if (!window_mouse_get_locked())
    {
        window_mouse_set_locked(true);
    }
    else
    {
        // Получаем текущую чувствительность.
        var _sensitivity = clamp(global.settings.mouse_sensitivity, 0.1, 2.0);

        // Перемещаем виртуальный курсор относительно движения мыши.
        global.cursor_screen_x += window_mouse_get_delta_x() * _sensitivity;
        global.cursor_screen_y += window_mouse_get_delta_y() * _sensitivity;
    }
}
else
{
    // Освобождаем мышь вне игрового режима или при потере фокуса.
    if (window_mouse_get_locked())
    {
        window_mouse_set_locked(false);
    }
}


// ==========================================
// === ОБНОВЛЕНИЕ КАМЕРЫ ===
// ==========================================

switch (state)
{
    case CAMSTATES.GAME:

        if (global.settings.raw_camera)
        {
            scrCameraGame();
            scrCameraGameUpdate();
        }

        break;

    case CAMSTATES.LEVEL_END:
        scrCameraLevelEnd();
        break;
}
