if (!instance_exists(owner_inst)) {
    instance_destroy();
    exit;
}

x = owner_inst.x;
y = owner_inst.y;
dir = owner_inst.my_angle;

// Отступ для дула
var _offset = 16;

// Точка выхода из дула
var _muzzle_x = x + lengthdir_x(_offset, dir);
var _muzzle_y = y + lengthdir_y(_offset, dir);

// === ПРОВЕРКА НА ПРОСТРЕЛ (В УПОРЕ) ===
// Проверяем отрезок от центра игрока до дула
var _is_blocked = false;
var _check_list = ds_list_create();
var _check_num = collision_line_list(x, y, _muzzle_x, _muzzle_y, all, false, true, _check_list, false);

for (var i = 0; i < _check_num; i++) {
    var _inst = _check_list[| i];
    if (_inst != owner_inst && _inst != id) {
        var _is_block = asset_has_tags(_inst.object_index, "Block_Bullet", asset_object);
        var _is_eater = asset_has_tags(_inst.object_index, "Eat_Bullet", asset_object);
        
        // Окна не считаем препятствием для спавна дула
        var _is_window = (_inst.object_index == objWindow);
        
        if ((_is_block || _is_eater) && !_is_window) {
            _is_blocked = true;
            break;
        }
    }
}
ds_list_destroy(_check_list);

// Если дуло уперлось в стену — не рисуем лазер
if (_is_blocked) {
    laser_active = false; 
    exit;
}

laser_active = true;

// === ТРАССИРОВКА ЛАЗЕРА (ИЗ ДУЛА) ===
var _target_x = _muzzle_x + lengthdir_x(max_dist, dir);
var _target_y = _muzzle_y + lengthdir_y(max_dist, dir);
var _hit_type = "NONE";

var _step = 4;
var _check_dist = 0;

var _ignore_instances = [owner_inst, id, instance_find(objEffector, 0)];

while (_check_dist < max_dist) {
    _check_dist += _step;
    
    var _check_x = _muzzle_x + lengthdir_x(_check_dist, dir);
    var _check_y = _muzzle_y + lengthdir_y(_check_dist, dir);
    
    var _list = ds_list_create();
    var _num = instance_position_list(_check_x, _check_y, all, _list, false);
    
    if (_num > 0) {
        var _is_stopped = false;
        
        for (var i = 0; i < _num; i++) {
            var _inst = _list[| i];
            
            if (!array_contains(_ignore_instances, _inst)) {
                
                // Прямая проверка на окно
                var _is_window = (_inst.object_index == objWindow);
                
                if (!_is_window) {
                    var _inst_is_block = asset_has_tags(_inst.object_index, "Block_Bullet", asset_object);
                    var _inst_is_eater = asset_has_tags(_inst.object_index, "Eat_Bullet", asset_object);
                    var _is_enemy = (object_is_ancestor(_inst.object_index, objEnemy));
                    
                    var _is_hiding = false;
                    if (_is_enemy) {
                        if (_inst.state == STATES.HIDERDUCK) _is_hiding = true;
                    }
                    
                    if ((_inst_is_block || _inst_is_eater || _is_enemy) && !_is_hiding) {
                        _target_x = _check_x;
                        _target_y = _check_y;
                        _hit_type = "WALL";
                        _is_stopped = true;
                        break;
                    }
                }
            }
        }
        
        ds_list_destroy(_list);
        
        if (_is_stopped) {
            break;
        }
    } else {
        ds_list_destroy(_list);
    }
}

laser_hit_wall = (_hit_type == "WALL");
laser_dist = _check_dist; // <--- Сохраняем дистанцию
laser_active = true;