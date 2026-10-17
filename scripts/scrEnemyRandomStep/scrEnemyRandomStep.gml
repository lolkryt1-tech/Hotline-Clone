function scrEnemyRandomStep()
{
    // =========================================================================
    // 1. АВТОМАТ СМЕНЫ ФАЗ (Походил -> Постоял -> Походил)
    // =========================================================================
    random_move_timer--;
    
    if (random_move_timer <= 0)
    {
        // Если до этого СТОЯЛИ (random_dir == -1) -> включаем ХОДЬБУ
        if (random_dir == -1)
        {
            random_move_timer = irandom_range(150, 300); 
            random_dir = random(360);                  
        }
        // Если до этого ШЛИ -> включаем СТОЯНИЕ
        else 
        {
            random_move_timer = irandom_range(120, 240);  
            random_dir = -1;                            
        }
    }

    // =========================================================================
    // 2. РАСЧЁТ СКОРОСТИ И ВИРТУАЛЬНОГО СДВИГА (УПРЕЖДЕНИЕ ИЗ ПАТРУЛЯ)
    // =========================================================================
    var _walk_speed = 0;
    var _path_blocked = false;

    // Если состояние "ХОДЬБА"
    if (random_dir != -1)
    {
        _walk_speed = max_speed * 0.4; 

        // Зазор упреждения (смотрим маской на 6 пикселей вперёд)
        var _look_ahead_dist = 6; 
        var _future_x = x + lengthdir_x(_look_ahead_dist, random_dir);
        var _future_y = y + lengthdir_y(_look_ahead_dist, random_dir);

        // Проверяем препятствия всей маской до физического контакта
        if (place_meeting(_future_x, _future_y, objSolid) || place_meeting(_future_x, _future_y, objDoor))
        {
            _path_blocked = true;
        }
    }

    // =========================================================================
    // 3. ОБРАБОТКА ОБНАРУЖЕННОГО ПРЕПЯТСТВИЯ
    // =========================================================================
    if (_path_blocked)
    {
        // С шансом 50% враг либо сразу встанет отдохнуть, либо выберет новый угол
        if (choose(true, false))
        {
            // Вариант А: Никуда не поворачиваемся, взгляд остаётся на месте, включаем паузу
            random_dir = -1;                            // Переводим автомат в режим СТОЯНИЯ
            random_move_timer = irandom_range(90, 180); // Будет стоять 1.5 - 3 сек
            _walk_speed = 0;                            // Сбрасываем скорость хода для этого кадра
        }
        else
        {
            // Вариант Б: Просто выбираем другой случайный угол и продолжаем идти
            random_dir = random(360);
            random_move_timer = max(random_move_timer, 45); // Продлеваем таймер хода
            _walk_speed = max_speed * 0.4; // Пересчитываем скорость для нового направления
        }
    }

    // =========================================================================
    // 4. ФИЗИЧЕСКОЕ ПЕРЕМЕЩЕНИЕ И СИНХРОНИЗАЦИЯ
    // =========================================================================
    if (random_dir != -1 && _walk_speed > 0)
    {
        var _vel_x = lengthdir_x(_walk_speed, random_dir);
        var _vel_y = lengthdir_y(_walk_speed, random_dir);

        // Безопасное скольжение/столкновение, если упреждение что-то упустило
        var _collisions = move_and_collide(_vel_x, _vel_y, [objSolid, objDoor]);

        // Страховочный микро-рикошет на случай идеального застревания в углу
        if (array_length(_collisions) > 0)
        {
            random_dir = random(360);
        }
    }

    // Синхронизируем направление спрайта (только когда идет)
    if (random_dir != -1) 
    {
        direction = random_dir;
    }
    
    // Передаем скорости наружу для анимаций ног/тела
    desired_angle = direction;
    target_speed  = _walk_speed; 
    speed         = 0; // Намертво глушим встроенный speed GameMaker
}
