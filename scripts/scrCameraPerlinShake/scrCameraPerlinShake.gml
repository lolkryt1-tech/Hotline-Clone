function scrCameraPerlinShake(_time, _strength, _rotation)
{
    var _noise_x =
        scrCameraNoise1D(_time * 1.0, kick_wave_seed_x) * 0.60 +
        scrCameraNoise1D(_time * 2.5, kick_wave_seed_x + 19.7) * 0.28 +
        scrCameraNoise1D(_time * 5.0, kick_wave_seed_x + 37.4) * 0.12;

    var _noise_y =
        scrCameraNoise1D(_time * 1.1, kick_wave_seed_y) * 0.60 +
        scrCameraNoise1D(_time * 2.7, kick_wave_seed_y + 31.4) * 0.28 +
        scrCameraNoise1D(_time * 5.2, kick_wave_seed_y + 53.8) * 0.12;

    var _noise_angle =
        scrCameraNoise1D(_time * 0.9, kick_wave_seed_angle) * 0.65 +
        scrCameraNoise1D(_time * 2.2, kick_wave_seed_angle + 41.2) * 0.35;

    return {
        x: _noise_x * _strength,
        y: _noise_y * _strength,
        angle: _noise_angle * _rotation
    };
}