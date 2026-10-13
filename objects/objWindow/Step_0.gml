// === ПРОВЕРКА УДАРА ИГРОКА ===
if (instance_exists(objPlayer))
{
    var _p = objPlayer;
    
    if (_p.sprite_index == _p.my_sprites.attack && _p.isRange_weapon == false)
    {
        var _hit_type = _p.my_sprites.melee_type;
        
        var _reach             = (_hit_type == HIT_TYPE.BLUNT) ? 24 : 18;
        var _attack_half_angle = 45;
        
        var _mouse_dir  = point_direction(_p.x, _p.y, mouse_x, mouse_y);
        var _target_dir = point_direction(_p.x, _p.y, x, y);
        var _dist       = point_distance(_p.x, _p.y, x, y);
        
        var _is_hit = false;
        
        // --- ЗОНА Б: КОНУС (с проверкой дистанции!) ---
        if (!_is_hit)
        {
            if (_dist <= _reach)
            {
                if (abs(angle_difference(_mouse_dir, _target_dir)) <= _attack_half_angle)
                {
                    var _block_los = tag_get_asset_ids("Block_LOS", asset_object);
                    var _los_wall = collision_line(_p.x, _p.y, x, y, _block_los, false, true);
                    if (_los_wall == noone) _is_hit = true;
                }
            }
        }
        
        // --- ПОПАДАНИЕ ---
        if (_is_hit)
        {
            var _push_dir = point_direction(_p.x, _p.y, x, y);
            scrWindowBreak(id, _push_dir, 16);
        }
    }
}