// По умолчанию коллизии нет
target_alpha = 1.0; 

// Проверяем столкновение сразу с обоими объектами
if (place_meeting(x, y, objEnemy) || place_meeting(x, y, objPlayer)) {
    target_alpha = 0.5;
}

image_alpha = lerp(image_alpha, target_alpha, fade_speed);