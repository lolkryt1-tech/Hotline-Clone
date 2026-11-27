// =========================================================================
// 0. ПОСТОЯННАЯ ЛОГИКА
// =========================================================================

// Анимация
hover_timer += 0.07;

// Уменьшаем технические таймеры
if (trigger_delay > 0) trigger_delay--;
if (wait_timer > 0) wait_timer--;


// =========================================================================
// 1. ПРОВЕРКА ПОЛОЖЕНИЯ ИГРОКА
// =========================================================================

var _player_inside = false;

if (instance_exists(objPlayer))
{
    if (place_meeting(x, y, objPlayer))
    {
        _player_inside = true;
    }
}


// =========================================================================
// 2. ПРОВЕРКА ЗАЧИСТКИ ЭТАЖА
// =========================================================================

var _room_is_totally_safe = false;

var _current_idx = global.current_level.current_floor;
var _level_data = global.current_level.floors[_current_idx];

if (_level_data.is_cleared == true && trigger_unlock == true)
{
    if (instance_exists(objEnemy) || instance_exists(objEnemyKnockedOut))
    {
        _room_is_totally_safe = false;
    }
    else
    {
        var _enemy_bullet_found = false;

        with (objBullet)
        {
            if (faction != FACTION.PLAYER)
            {
                _enemy_bullet_found = true;
                break;
            }
        }

        _room_is_totally_safe = !_enemy_bullet_found;
    }
}


// =========================================================================
// 3. ОБНОВЛЕНИЕ ДОСТУПНОСТИ ПЕРЕХОДА
// =========================================================================

if (_room_is_totally_safe)
{
    if (clear_delay_timer > 0)
    {
        clear_delay_timer--;
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
}


// =========================================================================
// 4. ЗАТЕМНЕНИЕ И ПОСТОЯННЫЙ ПУШ ИГРОКА
// =========================================================================

if (transition_started)
{
    // Затемнение экрана
    if (objEffector.fade_darkness < 1.0)
    {
        objEffector.fade_darkness = min(objEffector.fade_darkness + 0.15, 1.0);
    }

    // Постоянное перемещение игрока на протяжении всего фейда
    var _push_force = 2.0;

    var _p_hor = lengthdir_x(_push_force, image_angle);
    var _p_ver = lengthdir_y(_push_force, image_angle);

    with (objPlayer)
    {
        move_and_collide(_p_hor, _p_ver, objSolid);

        hor_velocity = _p_hor;
        ver_velocity = _p_ver;
    }
}


// =========================================================================
// 5. ОДНОРАЗОВОЕ СОБЫТИЕ ПЕРЕХОДА
// =========================================================================

if (transition_started)
{
    if (objEffector.fade_darkness >= 1.0)
    {
        if (target_room != noone && room_exists(target_room))
        {
            // Сохраняем игру
            scrSaveGame();

            // Перелистываем этаж
            global.current_level.current_floor = target_floor_index;

            // Координаты следующей комнаты
            global.next_player_x = target_x;
            global.next_player_y = target_y;

            global.next_effector_x = target_x;
            global.next_effector_y = target_y;
				
            // Совершаем переход
            room_goto(target_room);
        }
    }
}
