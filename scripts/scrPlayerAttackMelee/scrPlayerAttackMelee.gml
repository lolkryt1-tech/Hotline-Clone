function scrPlayerAttackMelee()
{
    // Достаем данные о текущем оружии из структуры, которую вернул scrPlayerGetWeaponSprite
    // (Допустим, при смене оружия ты сохранил этот возврат в переменную my_weapon_data)
    // Если переменной нет, мы можем получить её прямо здесь на лету:
    var _wp_data = scrPlayerGetWeaponSprite(character, current_weapon);
    var _hit_type = _wp_data.melee_type; // Получаем чистый энум HIT_TYPE.BLUNT, HIT_TYPE.UNARMED и т.д.

    // === 1. РАДИУС И НАПРАВЛЕНИЕ ===
    var _mouse_dir = point_direction(x, y, mouse_x, mouse_y);
    
    // Настраиваем длину луча на основе энума HIT_TYPE
    var _reach = (_hit_type == HIT_TYPE.BLUNT) ? 18 : 12; 
    var _close_radius = 8;
    
    var _hit_list = ds_list_create();
    var _melee_targets = tag_get_asset_ids("Meleeable", asset_object);
    
    // Сбор целей (сначала в упор по кругу, если пусто — линией перед собой)
    var _count = collision_circle_list(x, y, _close_radius, _melee_targets, false, true, _hit_list, false);
    if (_count == 0)
    {
        var _cx = x + lengthdir_x(_reach, _mouse_dir);
        var _cy = y + lengthdir_y(_reach, _mouse_dir);
        _count = collision_line_list(x, y, _cx, _cy, _melee_targets, false, true, _hit_list, false);
    }
    
    // === 2. ПЕРЕДАЧА УРОНА ===
    for (var i = 0; i < _count; i++)
    {
        var _enemy = _hit_list[| i];
        
        // Если между игроком и врагом высокая стена — удар не проходит
        if (collision_line(x, y, _enemy.x, _enemy.y, objSolidTall, false, true) != noone) continue;
        
        // Жесткий игнор: кулаками (HIT_TYPE.UNARMED) по сидячим у стены не бьем
        var _is_already_lean = (_enemy.object_index == objEnemyKnockedOutLean);
        if (_hit_type == HIT_TYPE.UNARMED && _is_already_lean) continue;
        
        // Считаем угол от нас (Игрока) до врага для вектора отлета трупа
        var _push_dir = point_direction(x, y, _enemy.x, _enemy.y);
        
        // Вызываем твою универсальную функцию смерти врагов, передавая чистый энум HIT_TYPE
        scrEnemyGetHitMelee(_enemy, _hit_type, _push_dir, id);
    }
    
    // Очищаем память списка
    ds_list_destroy(_hit_list);
}
