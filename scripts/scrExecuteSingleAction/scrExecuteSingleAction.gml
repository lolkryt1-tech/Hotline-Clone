/// @desc Выполняет ОДНО действие триггера.
/// @param {Id}     _trigger — инстанс objTriggerAction
/// @param {Struct} _act     — структура действия (элемент actions)
function scrExecuteSingleAction(_trigger, _act)
{
    with (_trigger)
    {
        switch (_act.type)
        {
            // ==========================================
            // === СПАВН ОДНОГО ВРАГА ===
            // ==========================================
			case TRIGGER_ACTION.SPAWN:
			{
			    var _enemy = instance_create_layer(_act.spawn_x, _act.spawn_y, "Instances", _act.spawn_object);
    
			    _enemy.skin          = _act.spawn_skin;
			    _enemy.class         = _act.spawn_class;
			    _enemy.faction       = _act.spawn_faction;
			    _enemy.weapon        = _act.spawn_weapon;
			    _enemy.ammo          = _act.spawn_ammo;
			    _enemy.my_sprites    = scrEnemyGetSprite(_act.spawn_skin, _act.spawn_weapon);
			    _enemy.isRange_weapon = _enemy.my_sprites.is_ranged;
			    _enemy.sprite_index  = _enemy.my_sprites.sprites.walk;
    
			    var _tx = _act.target_x;
			    var _ty = _act.target_y;
    
			    if (_tx == -1) { _tx = _act.spawn_x; }
			    if (_ty == -1) { _ty = _act.spawn_y; }
				
			    if (instance_exists(objPlayer)) {
			        _enemy.my_target = instance_find(objPlayer, 0);
			    } else {
			        var _exec = instance_nearest(_act.spawn_x, _act.spawn_y, objPlayerExecution);
			        if (_exec != noone) {
			            _enemy.my_target = _exec;
			        } else {
			            _enemy.my_target = noone;
			        }
			    }
			    
			    _enemy.state         = _act.spawn_state;
			    _enemy.noise_x       = _tx;
			    _enemy.noise_y       = _ty;
			    
			    // БЕЗОПАСНОЕ ЧТЕНИЕ ФЛАГА
			    _enemy.is_infinite_search = variable_struct_exists(_act, "spawn_infinite_search") ? _act.spawn_infinite_search : false;
    
			    break;
			}
            
            // ==========================================
            // === СПАВН ГРУППЫ ВРАГОВ ===
            // ==========================================
			case TRIGGER_ACTION.SPAWN_GROUP:
			{
			    var _group = _act.spawn_group;
    
			    for (var j = 0; j < array_length(_group); j++)
			    {
			        var _d = _group[j];
        
			        var _enemy = instance_create_layer(_d.spawn_x, _d.spawn_y, "Instances", _d.spawn_object);
        
			        _enemy.skin         = _d.spawn_skin;
			        _enemy.class        = _d.spawn_class;
			        _enemy.faction      = FACTION.COLOMBIAN;
			        _enemy.weapon       = _d.spawn_weapon;
			        _enemy.ammo         = _d.spawn_ammo;
			        _enemy.my_sprites   = scrEnemyGetSprite(_d.spawn_skin, _d.spawn_weapon);
			        _enemy.isRange_weapon = _enemy.my_sprites.is_ranged;
			        _enemy.sprite_index = _enemy.my_sprites.sprites.walk;
        
			        var _tx = _d.target_x;
			        var _ty = _d.target_y;
        
			        if (_tx == -1) { _tx = _d.spawn_x; }
			        if (_ty == -1) { _ty = _d.spawn_y; }
					
			        if (instance_exists(objPlayer)) {
			            _enemy.my_target = instance_find(objPlayer, 0);
			        } else {
			            var _exec = instance_nearest(_d.spawn_x, _d.spawn_y, objPlayerExecution);
			            if (_exec != noone) {
			                _enemy.my_target = _exec;
			            } else {
			                _enemy.my_target = noone;
			            }
			        }
			        
			        _enemy.state        = _d.spawn_state;
			        _enemy.noise_x      = _tx;
			        _enemy.noise_y      = _ty;
			        
			        // БЕЗОПАСНОЕ ЧТЕНИЕ ФЛАГА
			        _enemy.is_infinite_search = variable_struct_exists(_d, "spawn_infinite_search") ? _d.spawn_infinite_search : false;
			    }
			    break;
			}

            
            // ==========================================
            // === ОТКРЫТЬ ДВЕРЬ ===
            // ==========================================
            case TRIGGER_ACTION.OPEN_DOOR:
            {
                var _target_uid = _act.target_uid;
                with (objDoor)
                {
                    if (uid == _target_uid)
                    {
                        closed = false;
                    }
                }
                
                if (variable_global_exists("mp_grid") && global.mp_grid != noone)
                {
                    mp_grid_clear_all(global.mp_grid);
                    mp_grid_add_instances(global.mp_grid, objSolid, false);
                }
                break;
            }
            
            // ==========================================
            // === ЗАКРЫТЬ ДВЕРЬ ===
            // ==========================================
            case TRIGGER_ACTION.CLOSE_DOOR:
            {
                var _target_uid = _act.target_uid;
                with (objDoor)
                {
                    if (uid == _target_uid)
                    {
                        closed = true;
                        
                        if (variable_global_exists("mp_grid") && global.mp_grid != noone)
                        {
                            mp_grid_add_instances(global.mp_grid, id, false);
                        }
                    }
                }
                break;
            }
            
            // ==========================================
            // === ТЬМА ИСЧЕЗАЕТ ===
            // ==========================================
            case TRIGGER_ACTION.FADE_OUT_DARKNESS:
            {
                var _target_uid = _act.target_uid;
                with (objDarkness)
                {
                    if (uid == _target_uid)
                    {
                        fade_out = true;
                        fade_in  = false;
                    }
                }
                break;
            }
            
            // ==========================================
            // === ТЬМА ПОЯВЛЯЕТСЯ ===
            // ==========================================
            case TRIGGER_ACTION.FADE_IN_DARKNESS:
            {
                var _target_uid = _act.target_uid;
                with (objDarkness)
                {
                    if (uid == _target_uid)
                    {
                        fade_in  = true;
                        fade_out = false;
                    }
                }
                break;
            }
            
            // ==========================================
            // === ИЗМЕНИТЬ СОСТОЯНИЕ ВРАГА ===
            // ==========================================
            case TRIGGER_ACTION.CHANGE_ENEMY_STATE:
            {
                var _target_uid    = _act.target_uid;
                var _new_state     = _act.new_state;
                var _set_target    = _act.set_target;
                var _t_x           = _act.target_x;
                var _t_y           = _act.target_y;

                if (_set_target)
                {
                    if (_t_x == -1) { _t_x = (instance_exists(objPlayer)) ? objPlayer.x : x; }
                    if (_t_y == -1) { _t_y = (instance_exists(objPlayer)) ? objPlayer.y : y; }
                }

                with (objEnemy)
                {
                    if (enemy_uid == _target_uid)
                    {
                        state = _new_state;
            
                        if (path_index != -1) path_end();
            
                        if (_set_target)
                        {
                            noise_x = _t_x;
                            noise_y = _t_y;
                        }
            
                        if (_act.reset_target)
                        {
                            my_target = noone;
                        }
                    }
                }
                break;
            }
            
            // ==========================================
            // === РАЗБЛОКИРОВАТЬ СТРЕЛКУ ПЕРЕХОДА ===
            // ==========================================
            case TRIGGER_ACTION.UNLOCK_FLOOR_TRANSITION: 
            {
                var _target_uid = _act.target_uid;
                with (objFloorTranslator)
                {
                    if (uid == _target_uid)
                    {
                        trigger_unlock = true;
                    }
                }
                break;
            }
            
            // ==========================================
            // === ЗАДЕЛЫ ===
            // ==========================================
            case TRIGGER_ACTION.DIALOG:
            case TRIGGER_ACTION.TRANSITION:
            case TRIGGER_ACTION.SCRIPT:
            {
                break;
            }
        }
    }
}