// @desc Ищет путь до текущей цели врага (my_target) через mp_grid
/// @param {Bool} update_position True — погоня (обновлять путь), False — идти к точке last_seen (построить путь 1 раз)
function scrEnemyPathfinding(update_position, target_x, target_y)
{
    // =========================================================================
    // СЦЕНАРИЙ 1: ВРАГ ВИДИТ ЦЕЛЬ (update_position = true) — ПОГОНЯ
    // =========================================================================
    if (update_position)
    {
        if (path_index == -1) path_delay_timer = 0;
        target_speed = max_speed; 
        
        path_delay_timer--;
        if (path_delay_timer > 0) return; 
        path_delay_timer = 10; 
        
        var _target_x = my_target.x;
        var _target_y = my_target.y;
        
        // 1. Пробуем простроить прямой путь во время погони
        var _path_found = mp_grid_path(global.mp_grid, my_path, x, y, _target_x, _target_y, true);
        
        // 2. ТЕПЕРЬ И ТУТ: Если ты встал так, что путь до тебя заблокирован, ищем точку РЯДОМ с тобой
        if (!_path_found)
        {
            var _free_point = scrFindNearestFreeTarget(_target_x, _target_y, 16);
            if (is_array(_free_point))
            {
                _target_x = _free_point[0];
                _target_y = _free_point[1];
                
                _path_found = mp_grid_path(global.mp_grid, my_path, x, y, _target_x, _target_y, true);
            }
        }
        
        if (_path_found)
        {
            path_start(my_path, current_speed, path_action_stop, true);
            return; 
        }
        
        // Полный тупик во время погони
        path_delay_timer = 20; 
        scrEnemyRandomStep();
        return; 
    }
    
    // =========================================================================
    // СЦЕНАРИЙ 2: ВРАГ ПОТЕРЯЛ ЦЕЛЬ ИЗ ВИДУ (update_position = false) — ПОИСК ПО СЛЕДАМ
    // =========================================================================
    else 
    {
        target_speed = max_speed; 
        
        searching_path_delay_timer--;
        if (searching_path_delay_timer > 0) return;
        
        if (walk_on_trail >= 2) return;
        
        var _target_x = my_target.x;
        var _target_y = my_target.y;
        
        // 1. ВОЗВРАЩАЕМ TRUE: Разрешаем плавные диагональные углы для прямого пути
        var _path_found = mp_grid_path(global.mp_grid, my_path, x, y, _target_x, _target_y, true);
        
        // 2. Если прямой путь закрыт
        if (!_path_found)
        {
            var _free_point = scrFindNearestFreeTarget(_target_x, _target_y, 16);
            
            if (is_array(_free_point))
            {
                _target_x = _free_point[0]; 
                _target_y = _free_point[1]; 
                
                // ВОЗВРАЩАЕМ TRUE: Разрешаем плавные диагональные углы для обходного пути
                _path_found = mp_grid_path(global.mp_grid, my_path, x, y, _target_x, _target_y, true);
            }
        }
        
        if (_path_found)
        {
            walk_on_trail++; 
            searching_path_delay_timer = 20; 
            impossible_to_path = 0; 
            
            // Оставляем TRUE (абсолютные координаты пути для точности перемещения)
            path_start(my_path, current_speed, path_action_stop, true);
            return;
        }
        else
        {
            impossible_to_path++;
            searching_path_delay_timer = 30; 
            return;
        }
    }
}
