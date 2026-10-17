
// =========================================================================
// 0. ТЕХНИЧЕСКАЯ ПРОВЕРКА НА НАЛИЧИЕ ВРАГОВ НА СТАРТЕ КОМНАТЫ
// =========================================================================
if (first_frame_check)
{
    // Если в самый первый кадр в комнате ВООБЩЕ нет врагов
    if (!instance_exists(objEnemy))
    {
        has_spawned_clear_text = true; // Сразу блокируем спавн надписи, так как зачищать некого
    }
    first_frame_check = false; // Отключаем проверку, чтобы она не крутилась в цикле дальше
}


// 1. Уменьшаем технические таймеры (они отработают только в самый первый кадр комнаты)
if (trigger_delay > 0) trigger_delay--; 
if (wait_timer > 0)    wait_timer--;

// 2. Проверяем, стоит ли игрок прямо на переходе (защита от случайного падения назад)
var _player_inside = false;
if (instance_exists(objPlayer))
{
    if (place_meeting(x, y, objPlayer)) _player_inside = true;
}

// 3. Мгновенная проверка зачистки этажа и отсутствия активных угроз
var _room_is_totally_safe = false;
var _current_idx          = global.current_level.current_floor;
var _level_data           = global.current_level.floors[_current_idx];

if (_level_data.is_cleared == true && trigger_unlock == true)
{
    // Если на уровне всё ещё есть живые или оглушённые враги — комната опасна
    if (instance_exists(objEnemy) || instance_exists(objEnemyKnockedOut)) 
    {
        _room_is_totally_safe = false;
    }
    else 
    {
        // Если врагов нет, проверяем, остались ли вражеские пули (игнорируя пули игрока)
        var _enemy_bullet_found = false;
        
        with (objBullet)
        {
            if (faction != FACTION.PLAYER) 
            {
                _enemy_bullet_found = true;
                break; 
            }
        }
        
        // Если опасных пуль не обнаружено — уровень полностью чист
        _room_is_totally_safe = !_enemy_bullet_found;
    }
}

// 4. Логика мгновенной активации перехода + СПАВН НАДПИСИ
if (_room_is_totally_safe)
{
    if (clear_delay_timer > 0) clear_delay_timer--; 
    
    // ЭФФЕКТ ЗАЧИСТКИ: Спавним плашку "FLOOR CLEARED" один раз в момент безопасности
    if (!has_spawned_clear_text)
    {
        instance_create_depth(x, y, -10000, objFloorCleared); // Глубина -10000, чтобы объект создался без проблем
        has_spawned_clear_text = true; // Блокируем повторный спавн плашки на этом этаже
    }
    
    if (wait_timer <= 0 && !_player_inside)
    {
        is_unlocked = true; 
        image_alpha = 1; 
    }
    else
    {
        is_unlocked = false;
        image_alpha = 0.5; 
    }
}
else
{
    is_unlocked = false;
    image_alpha = 0; 
    clear_delay_timer = 1; 
    has_spawned_clear_text = false; // Если вдруг появится новый враг (например, спавн по триггеру), сбрасываем флаг
}









/* НА ПОТОМ
// =========================================================================
// 5. ТОЧНЫЙ РАСЧЕТ ИНДИКАТОРА СТРЕЛКИ НА КРАЮ ЭКРАНА
// =========================================================================
if (is_unlocked) 
{
    var _cam = view_camera;
    var _cam_x = camera_get_view_x(_cam);
    var _cam_y = camera_get_view_y(_cam);
    var _cam_w = camera_get_view_width(_cam);
    var _cam_h = camera_get_view_height(_cam);

    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();

    var _screen_x = ((x - _cam_x) / _cam_w) * _gui_w;
    var _screen_y = ((y - _cam_y) / _cam_h) * _gui_h;

    var _pad = 5; 
    if (_screen_x >= _pad && _screen_x <= _gui_w - _pad && _screen_y >= _pad && _screen_y <= _gui_h - _pad)
    {
        is_on_screen = true; 
    }
    else
    {
        is_on_screen = false; 

        var _edge_margin = 48;
        gui_icon_x = clamp(_screen_x, _edge_margin, _gui_w - _edge_margin);
        gui_icon_y = clamp(_screen_y, _edge_margin, _gui_h - _edge_margin);
    }
}
else
{
    is_on_screen = true; 
}
*/
