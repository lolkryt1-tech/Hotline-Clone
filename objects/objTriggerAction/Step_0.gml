// === ТИКАНЬЕ ЦЕПОЧКИ ДЕЙСТВИЙ ===
if (is_firing)
{
    while (action_index < array_length(actions))
    {
        // Если ещё ждём — уменьшаем таймер и выходим
        if (action_timer > 0)
        {
            action_timer -= 1;
            exit;
        }

        // Время пришло — выполняем текущее действие
        scrExecuteSingleAction(id, actions[action_index]);
        action_index += 1;

        // Если действия закончились — завершаем цепочку
        if (action_index >= array_length(actions)) break;

        // Иначе ставим таймер на задержку СЛЕДУЮЩЕГО действия
        action_timer = variable_struct_exists(actions[0], "delay") ? actions[0].delay : 0;
    }

    is_firing    = false;
    is_triggered = true;
    exit;
}

if (is_triggered) exit;


if (is_triggered) exit;

switch (condition_type)
{
    case TRIGGER_CONDITION.ENEMY_DEATH:
        if (target_enemy_uid != -1)
        {
            var _alive = false;
            with (objEnemy)
            {
                if (enemy_uid == other.target_enemy_uid) { _alive = true; break; }
            }
            if (!_alive) { scrTriggerActionFire(id); }
        }
        break;
        
    case TRIGGER_CONDITION.ENEMIES_COUNT_DEATH:
        if (global.enemies_killed >= target_enemies_count)
        {
            scrTriggerActionFire(id);
        }
        break;
        
    case TRIGGER_CONDITION.ENEMIES_ALL_CLEARED:
        if (!instance_exists(objEnemy) 
        &&  !instance_exists(objEnemyKnockedOut) 
        &&  !instance_exists(objEnemyKnockedOutLean))
        {
            scrTriggerActionFire(id);
        }
        break;
        
    case TRIGGER_CONDITION.PLAYER_ENTER_ZONE:
        if (instance_exists(objPlayer))
        {
            if (point_distance(x, y, objPlayer.x, objPlayer.y) < zone_radius)
            {
                scrTriggerActionFire(id);
            }
        }
        break;
        
    case TRIGGER_CONDITION.FLOOR_CLEARED:
        if (target_floor_index != -1)
        {
            var _total = global.current_level.total_floors;
            if (target_floor_index >= 0 && target_floor_index < _total)
            {
                if (global.current_level.floors[target_floor_index].is_cleared)
                {
                    scrTriggerActionFire(id);
                }
            }
        }
        break;
		
	case TRIGGER_CONDITION.ENTER_TRIGGER_ZONE:
	    if (target_zone_id == noone && target_zone_uid != -1)
	    {
	        var _uid = target_zone_uid;
	        with (objTriggerEnter)
	        {
	            if (zone_uid == _uid) { other.target_zone_id = id; break; }
	        }
	    }

	    if (instance_exists(objPlayer) && instance_exists(target_zone_id))
	    {
	        var _zone = target_zone_id;
	        with (objPlayer)
	        {
	            if (place_meeting(x, y, _zone))
	            {
	                scrTriggerActionFire(other.id);
	                break;
	            }
	        }
	    }
	    break;
}