function scrEnemyFollowWall()
{
    // =========================================================================
    // 1. СБОР СТЕН И ЗАКРЫТЫХ ДВЕРЕЙ (ФИЛЬТР)
    // =========================================================================
    var _solids = [objSolid];
    with (objDoor)
    {
        if (variable_instance_exists(id, "closed") && closed == true)
        {
            array_push(_solids, id);
        }
    }

    // СИНХРОНИЗАЦИЯ С РЕДАКТОРОМ КОМНАТ
    if (direction == 0 && my_angle != 0 && !wall_found)
    {
        direction = my_angle;
    }

    if (corner_cooldown > 0) corner_cooldown--;

    // Выравниваем строго по 4 главным осям (0, 90, 180, 270)
    if (direction % 90 != 0) 
    {
        direction = round(direction / 90) * 90;
    }
    direction = (direction mod 360 + 360) mod 360;

    var _walk_speed = max_speed * 0.4;
    var _check_dist = 4; 

    // =========================================================================
    // 2. BOXCAST (АНАЛИЗ СКАНИРОВАНИЯ В ПУТИ)
    // =========================================================================
    var _front_x = x + lengthdir_x(_check_dist, direction);
    var _front_y = y + lengthdir_y(_check_dist, direction);
    
    var _side_angle = direction - (90 * diradd);
    var _side_x  = x + lengthdir_x(_check_dist, _side_angle);
    var _side_y  = y + lengthdir_y(_check_dist, _side_angle);

    // Проверяем контакт со стеной
    var _has_contact = place_meeting(_front_x, _front_y, _solids) || place_meeting(_side_x, _side_y, _solids);
    
    if (_has_contact) 
    {
        wall_found = true; 
        wall_lost_timer = 0; // Контакт есть, сбрасываем счетчик потери в ноль
    }
    else if (wall_found)
    {
        // Если флаг активен, но прямо сейчас контакта нет (мы в процессе задержки или поворота угла),
        // начинаем капать таймер «подозрения». 
        wall_lost_timer++;
        
        // Предохранитель: если мы идем впустую больше 45 кадров (~0.7 сек) и стены нет — 
        // мы гарантированно её потеряли (убежали за игроком, заспавнились не там и т.д.)
        if (wall_lost_timer > 45)
        {
            wall_found = false;
            wall_lost_timer = 0;
            turn_delay = 0;
        }
    }

    // =========================================================================
    // 3. ПРИНЯТИЕ РЕШЕНИЙ С УЧЁТОМ ЗАДЕРЖКИ ПОВОРОТА
    // =========================================================================
    if (!wall_found)
    {
        if (place_meeting(_front_x, _front_y, _solids))
        {
            direction += (diradd * 90);
            corner_cooldown = 8;
        }
    }
    else
    {
        if (place_meeting(_front_x, _front_y, _solids))
        {
            direction += (diradd * 90);
            corner_cooldown = 8; 
            turn_delay = 0; 
        }
        else if (corner_cooldown <= 0 && !place_meeting(_side_x, _side_y, _solids))
        {
            if (turn_delay <= 0)
            {
                turn_delay = 3; 
            }
        }
    }

    if (turn_delay > 0)
    {
        turn_delay--;
        if (turn_delay <= 0)
        {
            direction -= (diradd * 90);
            corner_cooldown = 14; 
        }
    }

    direction = (direction mod 360 + 360) mod 360;

    // =========================================================================
    // 4. ПЛАВНЫЙ ВИЗУАЛЬНЫЙ ПОВОРОТ СПРАЙТА
    // =========================================================================
    var _diff = angle_difference(direction, my_angle);
    var _rot_speed = 7; 
    
    if (abs(_diff) < _rot_speed)
    {
        my_angle = direction;
    }
    else
    {
        my_angle += sign(_diff) * _rot_speed;
    }
    my_angle = (my_angle mod 360 + 360) mod 360;

    // =========================================================================
    // 5. ДВИЖЕНИЕ И ФИЗИЧЕСКИЙ СЛАЙДЕР С ВЫТАЛКИВАНИЕМ
    // =========================================================================
    var _vel_x = lengthdir_x(_walk_speed, direction);
    var _vel_y = lengthdir_y(_walk_speed, direction);

    var _collisions = move_and_collide(_vel_x, _vel_y, _solids);

    if (array_length(_collisions) > 0)
    {
        direction += (diradd * 90);
        corner_cooldown = 8;
        wall_found = true;
        wall_lost_timer = 0;
        turn_delay = 0;
    }

    // =========================================================================
    // 6. СИНХРОНИЗАЦИЯ СИСТЕМ
    // =========================================================================
    desired_angle = direction;
    target_speed  = _walk_speed; 
    speed         = 0; 
}
