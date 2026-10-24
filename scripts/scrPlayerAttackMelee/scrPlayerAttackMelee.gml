function scrPlayerAttackMelee()
{
    var _wp_data = scrPlayerGetWeaponSprite(character, current_weapon);
    var _hit_type = _wp_data.melee_type; 

    // === 1. НАСТРОЙКИ ЗОН ПОРАЖЕНИЯ И НАПРАВЛЕНИЯ ===
    var _mouse_dir = point_direction(x, y, mouse_x, mouse_y);
    
    // === АРХИТЕКТУРНОЕ РАСШИРЕНИЕ: ТОЛЧОК ВПЕРЕД ДЛЯ КУВАЛДЫ ===
    if (current_weapon == WEAPONS.SLEDGEHAMMER && image_index >= 4 && image_index < 9)
    {
        var _allow_dash = true;
        
        // Проверяем контрстрейф, только если игрок имеет какую-то скорость
        if (abs(hor_velocity) > 0.2 || abs(ver_velocity) > 0.2)
        {
            // Узнаем, куда сейчас физически летит тело игрока
            var _move_dir = point_direction(0, 0, hor_velocity, ver_velocity);
            
            // Считаем разницу углов между движением и прицелом мыши
            var _angle_diff = abs(angle_difference(_mouse_dir, _move_dir));
            
            // Если разница > 90 градусов (игрок жмет назад/вбок-назад относительно мыши), запрещаем дэш
            if (_angle_diff > 90)
            {
                _allow_dash = false;
            }
        }
        
        // Применяем импульс, если контрстрейфа нет
        if (_allow_dash)
        {
            var _dash_power = 1.2;
            hor_velocity += lengthdir_x(_dash_power, _mouse_dir);
            ver_velocity += lengthdir_y(_dash_power, _mouse_dir);
        }
    }
    
    // Радиусы зон
    var _reach = (_hit_type == HIT_TYPE.BLUNT) ? 24 : 18; // Длина конуса перед собой
    var _close_radius = 12;                                 // Маленький внутренний круг в упор
    
    // Угол раскрытия конуса (45 градусов в каждую сторону = 90 градусов веер)
    var _attack_half_angle = 45; 
    
    var _hit_list = ds_list_create();
    
    // Получаем ID ассетов по тегам и объектам
    var _melee_targets = tag_get_asset_ids("Meleeable", asset_object);
    var _block_los_objects = tag_get_asset_ids("Block_LOS", asset_object); // Стены и двери
    
    // Собираем ВСЕХ врагов и интерактивные объекты в максимальном радиусе поражения (_reach)
    var _count = collision_circle_list(x, y, _reach, _melee_targets, false, true, _hit_list, false);
    
    // === 2. ФИЛЬТРАЦИЯ И ДЕТЕКЦИЯ ПОПАДАНИЙ ===
    for (var i = 0; i < _count; i++)
    {
        var _target = _hit_list[| i]; 
        
        // Вычисляем дистанцию и угол до конкретной цели
        var _dist_to_target = point_distance(x, y, _target.x, _target.y);
        var _target_dir     = point_direction(x, y, _target.x, _target.y);
        
        var _is_hit = false;
        
        // --- ЗОНА А: ВНУТРЕННИЙ КРУГ В УПОР ---
        if (_dist_to_target <= _close_radius)
        {
            var _wall_tall = collision_line(x, y, _target.x, _target.y, objSolidTall, false, true);
            if (_wall_tall == noone)
            {
                _is_hit = true; 
            }
        }
        
        // --- ЗОНА Б: ОСНОВНОЙ КОНУС АТАКИ ---
        if (!_is_hit) 
        {
            if (abs(angle_difference(_mouse_dir, _target_dir)) <= _attack_half_angle) 
            {
                var _los_wall = collision_line(x, y, _target.x, _target.y, _block_los_objects, false, true);
                if (_los_wall == noone)
                {
                    _is_hit = true; 
                }
            }
        }
        
        // === 3. ПРИМЕНЕНИЕ УРОНА ===
        if (_is_hit)
        {
            var _push_dir = point_direction(x, y, _target.x, _target.y);
            
            var _is_already_lean = (_target.object_index == objEnemyKnockedOutLean);
            if (_hit_type == HIT_TYPE.UNARMED && _is_already_lean) continue;
            
            scrEnemyGetHitMelee(_target, current_weapon, _push_dir, id);
        }
    }
    
    // Очищаем память списка
    ds_list_destroy(_hit_list);
}
