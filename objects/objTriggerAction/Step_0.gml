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
}