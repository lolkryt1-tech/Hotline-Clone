/// @param {Real} _strength Максимальное смещение камеры
/// @param {Real} _rotation Максимальный угол наклона
/// @param {Real} _attack Время атаки
/// @param {Real} _release Время возвращения

function scrCameraKickShakeStart(_strength, _rotation, _attack, _release)
{
    if (!global.camera_shake.enabled) return;

    var _angle = random(360);

    kick_direction_x = lengthdir_x(1, _angle);
    kick_direction_y = lengthdir_y(1, _angle);

    kick_strength = _strength;
    kick_rotation = random_range(0.5, 1.0) * _rotation * choose(-1, 1);

    kick_attack_time = max(_attack, 0.001);
    kick_release_time = max(_release, 0.001);

    kick_timer = 0;
    kick_active = true;
}