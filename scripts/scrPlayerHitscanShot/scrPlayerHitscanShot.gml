function scrPlayerHitscanShot()
{
    var _max_dist = 1200; 
    var _dir = my_angle;
    
    scrAlertEnemySound(x, y, 250);
	
    // === 2. ЭФФЕКТЫ (с отступом) ===
    var _offset_forward = 24; 
    var _offset_side    = -1; 
    
    var _fx_start_x = x + lengthdir_x(_offset_forward, _dir) + lengthdir_x(_offset_side, _dir + 90);
    var _fx_start_y = y + lengthdir_y(_offset_forward, _dir) + lengthdir_y(_offset_side, _dir + 90);
    
    // === 3. ТРАССИРОВКА ЛУЧА (из центра игрока) ===
    var _shot_start_x = x;
    var _shot_start_y = y;
    var _target_x = _shot_start_x + lengthdir_x(_max_dist, _dir);
    var _target_y = _shot_start_y + lengthdir_y(_max_dist, _dir);
    
    var _unique_targets = ds_map_create();
    var _target_points  = ds_map_create(); 
    
    // Фикс: не добавляем noone в игнор-лист
    var _ignore_instances = [id];
    var _effector = instance_find(objEffector, 0);
    if (_effector != noone) array_push(_ignore_instances, _effector);
    
    var _step = 2;   // Фикс: уменьшено с 4 до 2, чтобы не проскакивать мелкие объекты
    var _check_dist = 0;
    
    while (_check_dist < _max_dist) {
        _check_dist += _step;
        
        var _check_x = _shot_start_x + lengthdir_x(_check_dist, _dir);
        var _check_y = _shot_start_y + lengthdir_y(_check_dist, _dir);
        
        // Фикс: используем collision_rectangle_list с радиусом 2 вместо instance_position_list,
        // чтобы ловить объекты рядом с точкой, а не только точно в ней
        var _list = ds_list_create();
        var _num = collision_rectangle_list(
            _check_x - 2, _check_y - 2, _check_x + 2, _check_y + 2,
            all, false, true, _list, false
        );
        
        if (_num > 0) {
            var _is_stopped = false;
            
            for (var i = 0; i < _num; i++) {
                var _inst = _list[| i];
                
                if (!array_contains(_ignore_instances, _inst)) {
                    var _is_block = asset_has_tags(_inst.object_index, "Block_Bullet", asset_object);
                    var _is_eater = asset_has_tags(_inst.object_index, "Eat_Bullet", asset_object);
                    var _is_enemy = (_inst.object_index == objEnemyHurtBox);
                    
                    if (_is_block || _is_eater || _is_enemy) {
                        if (!ds_map_exists(_unique_targets, _inst.id)) {
                            var _pt = { x: _check_x, y: _check_y };
                            ds_map_add(_unique_targets, _inst.id, _inst);
                            ds_map_add(_target_points, _inst.id, _pt);
                        }
                    }
                    
                    if (_is_block) {
                        _target_x = _check_x;
                        _target_y = _check_y;
                        _is_stopped = true;
                        // Фикс: НЕ break — продолжаем, чтобы поймать врагов в этой же точке
                    }
                }
            }
            
            ds_list_destroy(_list);
            
            if (_is_stopped) break; 
        } else {
            ds_list_destroy(_list);
        }
    }

    // === 4. ВЫЗОВ ЭФФЕКТОВ ===
    scrHitscanShotEffect(_fx_start_x, _fx_start_y, _target_x, _target_y, _dir);

    // === 5. СПАВН ФЕЙКОВЫХ ПУЛЬ (урон) ===
    var _keys = ds_map_keys_to_array(_unique_targets);
    
    for (var i = 0; i < array_length(_keys); i++) {
        var _target_id = _keys[i];
        var _pt = _target_points[? _target_id];
        
        var _fake_bullet = instance_create_layer(_pt.x, _pt.y, "Instances", objBullet);
        _fake_bullet.direction   = _dir;
        _fake_bullet.image_angle = _dir;
        _fake_bullet.faction     = faction; 
        _fake_bullet.calibre     = CALIBRE.SNIPER; 
        
        _fake_bullet.is_fake        = true;
        _fake_bullet.image_alpha    = 0;
        _fake_bullet.alarm[0]       = 1; 
    }
    
    ds_map_destroy(_unique_targets);
    ds_map_destroy(_target_points);

    // === 6. ЛОГИКА ГИЛЬЗЫ, ОТДАЧИ И ПАТРОНОВ (взято из scrPlayerShoot) ===
	shell_ready_to_spawn = 12;
	
    ammo--; 
    icon_shake_angle = 35 * icon_shake_dir; 
    icon_shake_dir = -icon_shake_dir; 
    ammo_color_factor = 1.0; 
    ammo_scale_pulse = 0.15; 
}