depth = 20;
anim_time = 0;

// Массив для шлейфа (сохраняем прошлые позиции)
trail = [];
var _trail_max = 15; // Длина шлейфа

for (var i = 0; i < _trail_max; i++) {
    array_push(trail, { x: 0, y: 0, angle: 0, alpha: 0 });
}

// Параметры покачивания
swing_radius_x = 50; // Амплитуда по X
swing_radius_y = 15;  // Амплитуда по Y (текст покачивается вверх-вниз)
swing_speed = 0.02;   // Скорость качания