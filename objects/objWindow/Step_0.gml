// === ПРОВЕРКА УДАРА ИГРОКА ===
if (instance_exists(objPlayer))
{
    var _p = objPlayer;
    
    // Проверяем, что игрок сейчас атакует в ближнем бою
    if (_p.sprite_index == _p.my_sprites.attack && _p.isRange_weapon == false)
    {
        
        // Дальность луча удара в зависимости от оружия (бита бьёт дальше, нож — ближе)
        var _reach = 24;
        
        // Направление удара от игрока на мышь
        var _attack_dir = point_direction(_p.x, _p.y, mouse_x, mouse_y);
        
        // Считаем конечную точку луча удара биты/ножа
        var _strike_end_x = _p.x + lengthdir_x(_reach, _attack_dir);
        var _strike_end_y = _p.y + lengthdir_y(_reach, _attack_dir);
        
        // Проверяем, пересекает ли луч удара хитбокс ИМЕННО ЭТОГО окна (id)
        // Использование id вместо objWindow гарантирует, что окно проверяет только себя
        if (collision_line(_p.x, _p.y, _strike_end_x, _strike_end_y, id, false, false))
        {
            // Находим точную точку столкновения на хитбоксе для красивого спавна осколков
            var _closest_x = clamp(_p.x, bbox_left, bbox_right);
            var _closest_y = clamp(_p.y, bbox_top, bbox_bottom);
            
            // Проверка линии видимости (чтобы не разбить стекло сквозь глухую стену)
            var _block_los = tag_get_asset_ids("Block_LOS", asset_object);
            var _los_wall = collision_line(_p.x, _p.y, _closest_x, _closest_y, _block_los, false, true);
            
            if (_los_wall == noone) 
            {
                // Вычисляем вектор удара, чтобы осколки разлетались по направлению удара мыши
                scrWindowBreak(id, _attack_dir, 16);
            }
        }
    }
}
