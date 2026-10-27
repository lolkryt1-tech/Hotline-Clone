// Увеличиваем прогресс полета
flight_progress += flight_speed;

if (flight_progress >= 1.0) {
    instance_destroy();
    exit;
}

// 1. Создаем нелинейный прогресс для эффекта перспективы (3-я степень)
// У горизонта (flight_progress = 0) изменения будут крошечными.
// У края экрана (flight_progress = 1) скорость станет максимальной.
var _p_curve = power(flight_progress, 3); 

// 2. Рассчитываем Y на основе кривой перспективы
y = lerp(start_y, target_y, _p_curve);

// 3. Рассчитываем X. 
// В перспективе X должен расходиться в стороны строго пропорционально движению по Y
x = lerp(start_x, target_x, _p_curve);

// 4. Масштаб тоже должен увеличиваться нелинейно, синхронно с позицией Y
scale_var = lerp(start_scale, end_scale, _p_curve);

// Плавно увеличиваем прозрачность. 
image_alpha = clamp(flight_progress * 4, 0, 1);