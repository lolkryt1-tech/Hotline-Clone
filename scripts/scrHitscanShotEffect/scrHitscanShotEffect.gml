/// @function scrHitscanShotEffect(_start_x, _start_y, _target_x, _target_y, _dir)
function scrHitscanShotEffect(_start_x, _start_y, _target_x, _target_y, _dir)
{
    // Проверяем, есть ли место для спавна эффектов (нет ли стены вплотную)
    var _can_spawn_fx = true;
    var _check_list = ds_list_create();
    var _check_num = collision_line_list(x, y, _start_x, _start_y, all, false, true, _check_list, false);
    
    for (var i = 0; i < _check_num; i++) {
        var _check_inst = _check_list[| i];
        if (_check_inst != id) {
            var _is_block = asset_has_tags(_check_inst.object_index, "Block_Bullet", asset_object);
            var _is_eater = asset_has_tags(_check_inst.object_index, "Eat_Bullet", asset_object);
            if (_is_block || _is_eater) {
                _can_spawn_fx = false;
                break;
            }
        }
    }
    ds_list_destroy(_check_list);

    if (!_can_spawn_fx) return; 

    // 1. Волна (шоквейв)
    var _wave = instance_create_layer(_start_x, _start_y, "Instances", objShockwaveTracer);
    _wave.start_x  = _start_x;
    _wave.start_y  = _start_y;
    _wave.target_x = _target_x;
    _wave.target_y = _target_y;
    _wave.is_ready = true;

    // 2. Белый луч (трейсер)
    var _tracer = instance_create_layer(_start_x, _start_y, "Instances", objSniperTracer);
    _tracer.target_x = _target_x;
    _tracer.target_y = _target_y;

    // 3. Дымный шлейф
    var _dist = point_distance(_start_x, _start_y, _target_x, _target_y);
    var _particle_step = 6; 
    var _particle_count = floor(_dist / _particle_step);
    
    for (var i = 0; i < _particle_count; i++) {
        var _p_dist = i * _particle_step;
        var _px = _start_x + lengthdir_x(_p_dist, _dir);
        var _py = _start_y + lengthdir_y(_p_dist, _dir);
        
        part_particles_create(global.sys_smoke, _px, _py, global.type_smoke, 1);
    }
}