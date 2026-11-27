
function scrCameraGame()
{
    // ==========================================
    // === ПОЗИЦИЯ ВИРТУАЛЬНОГО КУРСОРА ===
    // ==========================================

    var _win_w = max(window_get_width(), 1);
    var _win_h = max(window_get_height(), 1);

    // Не позволяем курсору выйти за пределы окна.
    global.cursor_screen_x = clamp(global.cursor_screen_x, 0, _win_w);
    global.cursor_screen_y = clamp(global.cursor_screen_y, 0, _win_h);

    // Получаем актуальные параметры камеры.
    var _view_x = camera_get_view_x(global.cam);
    var _view_y = camera_get_view_y(global.cam);

    var _view_w = camera_get_view_width(global.cam);
    var _view_h = camera_get_view_height(global.cam);

    // Переводим экранные координаты в локальные координаты камеры.
    var _local_x = (global.cursor_screen_x / _win_w - 0.5) * _view_w;
    var _local_y = (global.cursor_screen_y / _win_h - 0.5) * _view_h;

    // Учитываем поворот камеры.
    var _angle = camera_get_view_angle(global.cam);

    var _cos = dcos(_angle);
    var _sin = dsin(_angle);

    // Переводим локальные координаты в мировые.
    x = _view_x + _view_w * 0.5 + (_local_x * _cos - _local_y * _sin);

    y = _view_y + _view_h * 0.5 + (_local_x * _sin + _local_y * _cos);


    // ==========================================
    // === АВТОМАТИЧЕСКИЙ РАССВЕТ ===
    // ==========================================

    if (fade_darkness > 0)
    {
        fade_darkness = max(fade_darkness - fade_speed, 0.0);
    }


    // ==========================================
    // === МЕНЮ НАСТРОЙКИ ТРЯСКИ ПРИ СТРЕЛЬБЕ ===
    // ==========================================

    if (scrBindCheckPressed("screen_shake"))
    {
        if (instance_exists(objCameraShakeMenu))
        {
            scrCameraShakeMenuClose();
        }
        else
        {
            // Создаём резервную копию, если её ещё нет
            if (global.camera_shake.backup == undefined)
            {
                global.camera_shake.backup = scrCameraShakeCreatePresets();

                scrCameraShakeCopyPresets(
                    global.camera_shake.presets,
                    global.camera_shake.backup
                );

                global.camera_shake.backup_enabled = global.camera_shake.enabled;
            }

            instance_create_depth(0, 0, -15000, objCameraShakeMenu);
            global.camera_shake_menu_open = true;
        }
    }
}
