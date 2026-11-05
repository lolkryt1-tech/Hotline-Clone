anim_time += 1;

// 1. Пульсация цвета (от 0 до 1 и обратно)
// Используем синус с медленной скоростью
color_pulse = (sin(anim_time * 0.01) + 1) * 0.5;

// 2. Обновляем капли
for (var i = 0; i < array_length(blobs); i++) {
    var _b = blobs[i];
    
    // Движение по X и Y
    _b.offset_x = sin(anim_time * _b.speed_x + _b.phase_x) * _b.amplitude;
    _b.offset_y = cos(anim_time * _b.speed_y + _b.phase_y) * _b.amplitude;
    
    // Пульсация радиуса
    _b.radius_pulse = sin(anim_time * _b.radius_pulse_speed + _b.radius_pulse_phase) * _b.radius_pulse_amount;
    _b.radius_current = _b.radius + _b.radius_pulse;
}