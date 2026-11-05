function scrCameraBounceShakeStart(_strength, _rotation, _frequency, _damping)
{
    if (!global.camera_shake.enabled) return;

    // Проверяем, не активен ли уже более сильный Bounce.
    if (bounce_active)
    {
        var _current_amplitude = exp(-bounce_timer * bounce_damping);
        var _current_strength = bounce_strength * _current_amplitude;

        if (_strength < _current_strength) return;
    }

    var _angle = random(360);

    bounce_direction_x = lengthdir_x(1, _angle);
    bounce_direction_y = lengthdir_y(1, _angle);

    bounce_strength = _strength;
    bounce_rotation = random_range(0.5, 1.0) * _rotation * choose(-1, 1);

    bounce_frequency = _frequency;
    bounce_damping = _damping;

    bounce_timer = 0;
    bounce_active = true;
}