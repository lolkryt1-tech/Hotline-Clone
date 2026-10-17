function scrWindowBreak(_window_id, _hit_dir, _hit_spd)
{
    // Выполняем код только если окно ещё целое
    if (_window_id.image_index == 2) return;

    // 1. МЕНЯЕМ СОСТОЯНИЕ ОКНА
    _window_id.image_index = 2; // Ставим спрайт разбитого окна
    _window_id.image_speed = 0; 
    _window_id.solid = false;   // Отключаем твёрдость, чтобы объекты пролетали насквозь

    // 2. ИГРАЕМ ЗВУК С СЛУЧАЙНЫМ ПИТЧЕМ
    var snd = choose(sndGlass1, sndGlass2);
    var audio = audio_play_sound(snd, 10, false);
    audio_sound_pitch(audio, random_range(0.85, 1.25)); // Случайный питч для сочности
        
    // 3. НАСТРОЙКА ГЕОМЕТРИИ ДЛЯ СМЕЩЕНИЯ ПО ВЫСОТЕ
    var window_angle = _window_id.image_angle; 
    var angle_rad    = degtorad(window_angle);

    // Локальные границы высоты рамы конкретного окна
    var gy_top    = -_window_id.sprite_xoffset;
    var gy_bottom = -_window_id.sprite_xoffset + _window_id.sprite_height;

    var shard_count = irandom_range(16, 22); // Количество осколков

    for (var i = 0; i < shard_count; i++) {
        
        var spawn_x = _window_id.x;
        var spawn_y = _window_id.y;
        var shard_dir = _hit_dir;
        
        // ========================================================
        // ЛОГИКА РАЗДЕЛЕНИЯ НА ДВЕ ГРУППЫ С СДВИГОМ ПО ВЫСОТЕ
        // ========================================================
        if (i mod 2 == 0) {
            // --- ГРУППА А: ЗЕЛЕНАЯ ЗОНА (ПО НАПРАВЛЕНИЮ УДАРA) ---
            // Спавнятся в центре окна и летят вперед веером
            spawn_x = _window_id.x;
            spawn_y = _window_id.y;
            shard_dir = _hit_dir + random_range(-20, 20);
        } else {
            // --- ГРУППА Б: РОЗОВАЯ ЗОНА (ВДОЛЬ ОКНА С УЧЁТОМ ВЫСОТЫ) ---
            // Находим случайную точку по высоте стекла
            var local_random_y = random_range(gy_top + 2, gy_bottom - 2);
            
            // Проецируем локальный сдвиг в мировые координаты комнаты
            spawn_x = _window_id.x - (local_random_y * sin(angle_rad));
            spawn_y = _window_id.y + (local_random_y * cos(angle_rad));
            
            // Направление: Осколки вылетают из рамы строго вдоль розовых рамок
            var glass_along = window_angle;
            
            // Проверяем вектор удара, чтобы заставить веер раскрываться по ходу движения, а не назад
            if (sign(lengthdir_x(1, glass_along) * lengthdir_x(1, _hit_dir) + lengthdir_y(1, glass_along) * lengthdir_y(1, _hit_dir)) < 0) {
                glass_along -= 180;
            }
            shard_dir = glass_along + random_range(-45, 44);
        }
        
        // 4. СОЗДАНИЕ И НАСТРОЙКА ОСКОЛКА
        var shard = instance_create_layer(spawn_x, spawn_y, "Instances", objGlassShard);
            
        with (shard) {
            image_index = irandom(image_number - 1);
            image_speed = 0;
            image_angle = random(360);
            
            // Рандомизация размеров
            var base_scale = 0.5;
            var random_size = random_range(-0.15, 0.15);
            image_xscale = base_scale + random_size;
            image_yscale = base_scale + random_size;
                
            // Физика движения
            speed     = (_hit_spd * 0.25) + random_range(0.5, 2.5);
            friction  = 0.15; // Трение о пол
            direction = shard_dir;
        }
    }
}
