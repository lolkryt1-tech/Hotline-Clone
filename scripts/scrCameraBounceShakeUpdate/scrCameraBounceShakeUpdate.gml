function scrCameraBounceShakeUpdate(_dt)
{
    bounce_offset_x = 0;
    bounce_offset_y = 0;
    bounce_offset_angle = 0;

    if (!global.camera_shake.enabled || !bounce_active) return;

    bounce_timer += _dt;

    var _amplitude = exp(-bounce_timer * bounce_damping);
    var _wave = sin(bounce_timer * bounce_frequency * pi * 2) * _amplitude;

    bounce_offset_x = bounce_direction_x * bounce_strength * _wave;
    bounce_offset_y = bounce_direction_y * bounce_strength * _wave;
    bounce_offset_angle = bounce_rotation * 0.25 * _wave;

    // Останавливаем эффект, когда амплитуда практически исчезла.
    if (_amplitude < 0.001)
    {
        bounce_active = false;
        bounce_offset_x = 0;
        bounce_offset_y = 0;
        bounce_offset_angle = 0;
    }
}