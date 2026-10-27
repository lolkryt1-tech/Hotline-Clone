// === 1. ЛОГИКА АКТИВНОГО ТОЛЧКА (ПОКА ТИКАЕТ ТАЙМЕР ПУША) ===
if (push_timer > 0) {
    push_timer--;
    
    if (instance_exists(objPlayer)) {
        var _push_force = 3.0; // НАСТРОЙКА: Скорость затягивания в дверь
        var _p_hor = lengthdir_x(_push_force, push_angle);
        var _p_ver = lengthdir_y(_push_force, push_angle);
        
        // Машина сама тащит выключенного игрока заданное количество кадров
        with (objPlayer) {
            move_and_collide(_p_hor, _p_ver, objSolid);
            hor_velocity = _p_hor;
            ver_velocity = _p_ver;
        }
    }
}

// === 2. ТАЙМЕР НАХОЖДЕНИЯ В МАШИНЕ И ЗАПУСК ДВИГАТЕЛЯ ===
if (car_start_timer > 0) {
    car_start_timer--;
    
	// Единоразовое событие: таймер обнулился (ДВИЖОК ЗАВЕДЁН)
    if (car_start_timer <= 0) {
        audio_play_sound(sndCarStart, 10, false);
        image_speed = 1;
        
        if (instance_exists(objEffector)) {
            with (objEffector) {
                state = CAMSTATES.LEVEL_END;
                
                target_car_x = other.x;
                
                // Запоминаем точную текущую позицию вьюпорта камеры в мире
                cutscene_cam_x = camera_get_view_x(_cam);
                cutscene_cam_y = camera_get_view_y(_cam);
                
                cutscene_timer = 120;               
                curtain_y = -360; 
            }
        }
        
        if (instance_exists(objPlayer)) {
            instance_destroy(objPlayer);
        }
    }
}

// === 3. ПРОВЕРКА ИГРОКА В ЗОНЕ МАШИНЫ ===
car_zone_active = false;

if (instance_exists(objPlayer)) {
    var _dx = objPlayer.x - x;
    var _dy = objPlayer.y - y;
    
    // Поворот на -image_angle для локальных координат Oriented Bounding Box (OBB)
    var _cos = dcos(-image_angle);
    var _sin = dsin(-image_angle);
    var _local_x = _dx * _cos - _dy * _sin;
    var _local_y = _dx * _sin + _dy * _cos;
    
    // Проверка попадания игрока в прямоугольник хитбокса зоны
    if (abs(_local_x) <= car_zone_width / 2 && abs(_local_y) <= car_zone_height / 2) {
        
        // Если он только что вошел И мы его еще не толкали в этот раз
        if (!has_been_pushed && objPlayer.active) {
            push_timer = 8;                // НАСТРОЙКА: Длительность затягивания в кадрах
            push_angle = image_angle + 270; // Направление сквозь дверь боком в салон
            has_been_pushed = true;         // Включаем блокирующий флаг от цикличного пуша
            
            // Запускаем таймер до старта мотора
            car_start_timer = 35; 
            
            objPlayer.active = false;       // Выключаем управление игрока на время пуша
        }
        
        car_zone_active = true;
    } 
    else {
        // ЕСЛИ ИГРОК ВЫШЕЛ ИЗ ЗОНЫ:
        // Сбрасываем блокирующий флаг, только если пуш таймер полностью отработал
        if (push_timer <= 0) {
            has_been_pushed = false;
            car_start_timer = 0;
            
            // Сбрасываем анимацию машины обратно в статику, если игрок передумал
            image_speed = 0;
            image_index = 0;
        }
    }
}
