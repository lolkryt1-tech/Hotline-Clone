function scrEnemyAttackHitscan()
{
    // 1. БАЗОВЫЕ ПРОВЕРКИ
    if (!instance_exists(my_target)) 
    { 
        path_end(); 
        state = STATES.STEP; 
        my_target = noone;
        reload = max(reload, 20);
        start_shooting = false;
        exit; 
    }
    
    last_seen_x = my_target.x;
    last_seen_y = my_target.y;
    direction = my_angle;
    
    var _clear_view = scrHasClearView(x, y, my_target.x, my_target.y);
    var _distance = point_distance(x, y, my_target.x, my_target.y);
    
    if (!_clear_view || _distance > 1200)
    {
        state = STATES.STEP;
        reload = max(reload, 20);
        start_shooting = false;
        target_speed = max_speed;
        exit;
    }
    
    var _pdir = point_direction(x, y, my_target.x, my_target.y);
    
    // 2. ДВИЖЕНИЕ (снайпер стоит на месте)
    target_speed = 0;
    speed = 0;
    
    // 3. ПРИЦЕЛИВАНИЕ И АНИМАЦИЯ
    if (sprite_index == my_sprites.sprites.attack) 
    { 
        image_index += my_sprites.anim_speed; 
    }
    
    reload--;
    desired_angle = _pdir; 
    
    // --- ЛОГИКА ЛАЗЕРА И ФИКСАЦИИ ---
    var _diff = angle_difference(my_angle, _pdir);
    
    // Если альфа меньше 0.75, мы доворачиваемся и заряжаемся
    if (laser_alpha < 0.75) {
        var _current_rot_speed = (start_shooting) ? 0.45 : 0.15;
        my_angle += angle_difference(desired_angle, my_angle) * _current_rot_speed;
        
        // Заряжаемся, только если мы навелись (угол близок к цели)
        if (abs(_diff) <= 30) {
            laser_alpha = min(laser_alpha + 0.04, 1.0); 
        } else {
            // Если цель ушла из угла, сбрасываем заряд
            laser_alpha = max(laser_alpha - 0.1, 0); 
        }
    } 
    // Если альфа >= 0.75, мы ЗАФИКСИРОВАЛИ угол. 
    else {
        laser_alpha = min(laser_alpha + 0.02, 1.0);
        
        // ФИКСАЦИЯ: жестко смотрим на текущую позицию цели
        my_angle = point_direction(x, y, my_target.x, my_target.y);
    }
    
    // Передаем альфу в объект лазера для отрисовки (если он существует)
    if (instance_exists(laser_sight)) {
        laser_sight.draw_alpha = laser_alpha;
    }
    
    // Пока лазер не зарядился полностью или идет перезарядка, мы НЕ стреляем
    if (laser_alpha < 1.0 || reload > 0) return;
    
    // === ПРОВЕРКА ПУСТОГО МАГАЗИНА ===
    if (ammo <= 0)
    {
        audio_play_sound(sndDryClick, 10, false); 
        reload = 25;
        laser_alpha = 0;
        exit;
    }
    
    // =========================================================================
    // 4. ВЫСТРЕЛ
    // =========================================================================
	sprite_index = my_sprites.sprites.attack;
	
    start_shooting = true;
    reload = my_sprites.cooldown;
    laser_alpha = 0;
	ammo--;
	objEffector.shake = 2.5;
	
    // Звук выстрела
    if (array_length(my_sprites.sounds) > 0) {
        audio_play_sound(my_sprites.sounds[0], 1, false);
    }
    
    var _max_dist = 1200; 
    var _dir = my_angle;
    
    // === ОТСТУП ДЛЯ ЭФФЕКТОВ ===
    var _offset_forward = 24; 
    var _offset_side    = -1; 
    var _fx_start_x = x + lengthdir_x(_offset_forward, _dir) + lengthdir_x(_offset_side, _dir + 90);
    var _fx_start_y = y + lengthdir_y(_offset_forward, _dir) + lengthdir_y(_offset_side, _dir + 90);
    
    // Трассировка
    var _target_x = x + lengthdir_x(_max_dist, _dir);
    var _target_y = y + lengthdir_y(_max_dist, _dir);
    
    var _unique_targets = ds_map_create();
    var _target_points  = ds_map_create(); 
    var _ignore_instances = [id, instance_find(objEffector, 0)];
    var _step = 4;
    var _check_dist = 0;
    
    while (_check_dist < _max_dist) {
        _check_dist += _step;
        
        var _check_x = x + lengthdir_x(_check_dist, _dir);
        var _check_y = y + lengthdir_y(_check_dist, _dir);
        
        var _list = ds_list_create();
        var _num = instance_position_list(_check_x, _check_y, all, _list, false);
        
        if (_num > 0) {
            var _is_stopped = false;
            
            for (var i = 0; i < _num; i++) {
                var _inst = _list[| i];
                
                if (!array_contains(_ignore_instances, _inst)) {
                    var _is_block = asset_has_tags(_inst.object_index, "Block_Bullet", asset_object);
                    var _is_eater = asset_has_tags(_inst.object_index, "Eat_Bullet", asset_object);
                    var _is_target = (_inst.object_index == objPlayer);
                    
                    if (_is_block) {
                        _target_x = _check_x;
                        _target_y = _check_y;
                        _is_stopped = true;
                        break; 
                    }
                    else if (_is_eater || _is_target) {
                        if (!ds_map_exists(_unique_targets, _inst.id)) {
                            var _pt = { x: _check_x, y: _check_y };
                            ds_map_add(_unique_targets, _inst.id, _inst);
                            ds_map_add(_target_points, _inst.id, _pt);
                        }
                    }
                }
            }
            
            ds_list_destroy(_list);
            if (_is_stopped) break; 
        } else {
            ds_list_destroy(_list);
        }
    }

    // Эффекты выстрела (с отступом)
    scrHitscanShotEffect(_fx_start_x, _fx_start_y, _target_x, _target_y, _dir);

    // Спавн фейковых пуль
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
}