function scrCameraKickShakeUpdate(_dt)
{
    kick_offset_x = 0;
    kick_offset_y = 0;
    kick_offset_angle = 0;

    if (global.camera_shake == true || !kick_active) return;

    kick_timer += _dt;

    var _intensity = 0;

    if (kick_timer < kick_attack_time)
    {
        var _t = clamp(kick_timer / kick_attack_time, 0, 1);
        _intensity = 1 - power(1 - _t, 3);
    }
    else
    {
        var _t = clamp((kick_timer - kick_attack_time) / kick_release_time, 0, 1);
        _intensity = 1 - power(_t, 2);

        if (_t >= 1)
        {
            kick_active = false;
            _intensity = 0;
        }
    }

    kick_offset_x = kick_direction_x * kick_strength * _intensity;
    kick_offset_y = kick_direction_y * kick_strength * _intensity;
    kick_offset_angle = kick_rotation * _intensity;
}