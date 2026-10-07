function scrPlayerAttackMelee()
{
    var _wp_data = scrPlayerGetWeaponSprite(character, current_weapon);
    var _hit_type = _wp_data.melee_type; 

    // === 1. НАСТРОЙКИ ЗОН ПОРАЖЕНИЯ ===
    var _mouse_dir = point_direction(x, y, mouse_x, mouse_y);
    
    // Радиусы зон
    var _reach = (_hit_type == HIT_TYPE.BLUNT) ? 24 : 18; // Длина конуса перед собой
    var _close_radius = 12;                                 // Маленький внутренний круг в упор
    
    // Угол раскрытия конуса (45 градусов в каждую сторону = 90 градусов веер)
    var _attack_half_angle = 45; 
    
    var _hit_list = ds_list_create();
    
    // Получаем ID ассетов по тегам и объектам
    var _melee_targets = tag_get_asset_ids("Meleeable", asset_object);
    var _block_los_objects = tag_get_asset_ids("Block_LOS", asset_object); // Стены и двери
    
    // Собираем ВСЕХ врагов в максимальном радиусе поражения (_reach)
    var _count = collision_circle_list(x, y, _reach, _melee_targets, false, true, _hit_list, false);
    
    // Активируем таймер визуализации (для отладки)
    debug_melee_timer = 15;
    
    // === 2. ФИЛЬТРАЦИЯ И ДЕТЕКЦИЯ ПОПАДАНИЙ ===
    for (var i = 0; i < _count; i++)
    {
        var _enemy = _hit_list[| i];
        
        // Вычисляем дистанцию и угол до конкретного врага
        var _dist_to_enemy = point_distance(x, y, _enemy.x, _enemy.y);
        var _enemy_dir     = point_direction(x, y, _enemy.x, _enemy.y);
        
        var _is_hit = false;
        
        // --- ЗОНА А: ВНУТРЕННИЙ КРУГ В УПОР ---
        if (_dist_to_enemy <= _close_radius)
        {
            // Этот круг проверяет ТОЛЬКО монолитные стены objSolidTall
            var _wall_tall = collision_line(x, y, _enemy.x, _enemy.y, objSolidTall, false, true);
            if (_wall_tall == noone)
            {
                _is_hit = true; // Стены нет — врага в упор зацепило (двери игнорируются!)
            }
        }
        
        // --- ЗОНА Б: ОСНОВНОЙ КОНУС АТАКИ ---
        if (!_is_hit) // Если враг не попал под внутренний круг, проверяем конус
        {
            // 1. Проверяем, попадает ли враг в угол обзора
            if (abs(angle_difference(_mouse_dir, _enemy_dir)) <= _attack_half_angle) 
            {
                // 2. Конус блокируется объектами с тегом "Block_LOS" (двери, стены и т.д.)
                var _los_wall = collision_line(x, y, _enemy.x, _enemy.y, _block_los_objects, false, true);
                if (_los_wall == noone)
                {
                    _is_hit = true; // Преград нет — конус попал по врагу!
                }
            }
        }
        
        // --- 3. ПРИМЕНЕНИЕ УРОНА, ЕСЛИ ЦЕЛЬ ЗАЦЕПЛЕНА ---
        if (_is_hit)
        {
            // Жесткий игнор: кулаками (HIT_TYPE.UNARMED) по сидячим у стены не бьем
            var _is_already_lean = (_enemy.object_index == objEnemyKnockedOutLean);
            if (_hit_type == HIT_TYPE.UNARMED && _is_already_lean) continue;
            
            // Вектор отлета трупа/нокаута
            var _push_dir = point_direction(x, y, _enemy.x, _enemy.y);
            
            // Передаем хит во врага
            scrEnemyGetHitMelee(_enemy, current_weapon, _push_dir, id);
        }
    }
    
    // Очищаем память списка
    ds_list_destroy(_hit_list);
}
