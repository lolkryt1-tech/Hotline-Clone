
/// @function scrCameraGameUpdate()
/// @description Обновление камеры во время обычного геймплея.

function scrCameraGameUpdate()
{
    if (state != CAMSTATES.GAME) return;

    my_target = scrTargetUpdate(objPlayer);

    if (keyboard_check(vk_alt))
    {
        if (mouse_wheel_up())                      zoom_level -= 0.1;
        if (mouse_wheel_down())                    zoom_level += 0.1;
        if (mouse_check_button_pressed(mb_middle)) zoom_level = 1;

        zoom_level = clamp(zoom_level, zoom_min, zoom_max);
    }
	
	var _look_further_active = scrBindCheck("look_further") != global.look_further_toggle;


    #region приближение + сглаживание

    var target_w = base_width * zoom_level;
    var target_h = base_height * zoom_level;

    var camera_w = camera_get_view_width(_cam);
    var camera_h = camera_get_view_height(_cam);

    var new_w = lerp(camera_w, target_w, 0.5);
    var new_h = lerp(camera_h, target_h, 0.5);

    camera_set_view_size(_cam, new_w, new_h);

    #endregion


    #region слежка + центрирование

    // ==========================================
    // === ROUGHNESS ===
    // ==========================================

    var _roughness = clamp(global.settings.camera_roughness, 5, 100);
    var _roughness_factor = _roughness / 100;


    // ==========================================
    // === ЦЕЛЬ КЛАССИЧЕСКОЙ КАМЕРЫ ===
    // ==========================================

    var look_distance = 0.8;

    if (_look_further_active)
    {
        look_distance = 0.5;
    }

    var target_x_pos = lerp(x, my_target.x, look_distance);
    var target_y_pos = lerp(y, my_target.y, look_distance);

    var _target_x = target_x_pos - (new_w / 2);
    var _target_y = target_y_pos - (new_h / 2);


    // ==========================================
    // === RAW CAMERA OFF — КЛАССИЧЕСКАЯ КАМЕРА ===
    // ==========================================

    if (!global.settings.raw_camera)
    {
        if (_roughness >= 100)
        {
            cam_follow_x = _target_x;
            cam_follow_y = _target_y;
        }
        else
        {
            cam_follow_x = lerp(cam_follow_x, _target_x, _roughness_factor);
            cam_follow_y = lerp(cam_follow_y, _target_y, _roughness_factor);
        }

        cam_velocity_x = 0;
        cam_velocity_y = 0;
    }


    // ==========================================
    // === RAW CAMERA ON — СТАРАЯ МЕХАНИКА ===
    // ==========================================

    else
    {
        // Центр текущей камеры.
        var _camera_center_x = cam_follow_x + new_w * 0.5;
        var _camera_center_y = cam_follow_y + new_h * 0.5;

        // Будущая точка, к которой направляется камера.
        var _viewx;
        var _viewy;


        // ==========================================
        // === НАВЕДЕНИЕ НА МЫШЬ ===
        // ==========================================

        if (_look_further_active)
        {
            var _win_w = max(window_get_width(), 1);
            var _win_h = max(window_get_height(), 1);

            var _hard_sign = (global.hard) ? -1 : 1;

            _viewx = my_target.x + ((global.cursor_screen_x - (_win_w * 0.5)) * new_w / _win_w) * _hard_sign;

            _viewy = my_target.y + ((global.cursor_screen_y - (_win_h * 0.5))* new_h / _win_h) * _hard_sign;
        }


        // ==========================================
        // === ОБЫЧНОЕ СЛЕЖЕНИЕ ЗА ИГРОКОМ ===
        // ==========================================

        else
        {
            // Вектор от игрока к курсору.
            var _dx = objEffector.x - my_target.x;
            var _dy = objEffector.y - my_target.y;

            var _distance = point_distance(0, 0, _dx, _dy);

            // Смещение плавно растёт от 0 до 24 пикселей.
            var _offset = min(_distance, 24);

            var _scale = 0;

            if (_distance > 0.0001)
            {
                _scale = _offset / _distance;
            }

            // Камера смещается в ту же сторону, где находится курсор.
            _viewx = my_target.x + _dx * _scale;
            _viewy = my_target.y + _dy * _scale;
        }


        // ==========================================
        // === ДВИЖЕНИЕ КАМЕРЫ К ЦЕЛИ ===
        // ==========================================

        var _viewspeed = point_distance(
            _camera_center_x, _camera_center_y,
            _viewx, _viewy
        ) * _roughness_factor;

        var _viewdir = point_direction(
            _camera_center_x, _camera_center_y,
            _viewx, _viewy
        );

        _camera_center_x += lengthdir_x(_viewspeed, _viewdir);
        _camera_center_y += lengthdir_y(_viewspeed, _viewdir);

        cam_follow_x = _camera_center_x - new_w * 0.5;
        cam_follow_y = _camera_center_y - new_h * 0.5;

        cam_velocity_x = 0;
        cam_velocity_y = 0;
    }

    #endregion


    // ==========================================
    // === SCREEN SHAKE ===
    // ==========================================

    var _dt = delta_time / 1000000;

    scrCameraKickShakeUpdate(_dt);
    scrCameraBounceShakeUpdate(_dt);

    camera_set_view_pos(_cam,
        cam_follow_x + kick_offset_x + bounce_offset_x,
        cam_follow_y + kick_offset_y + bounce_offset_y
    );

    camera_set_view_angle(_cam,
        cam_base_angle + kick_offset_angle + bounce_offset_angle
    );
}
