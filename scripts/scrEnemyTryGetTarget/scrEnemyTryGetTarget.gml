function scrEnemyTryGetTarget()
{
    search_timer--;
    if (search_timer > 0) return; 
	
    target_search_count++;
    search_timer = search_interval; 
    
    var _found_targets = ds_list_create();
    var _targets_count = collision_circle_list(x, y, vision_radius, objTargetable, false, true, _found_targets, true);
	
    var _backup_target = noone; // Сюда сохраняем живых врагов/казни на крайний случай
	
    for (var i = 0; i < _targets_count; i++)
    {
        var _inst = _found_targets[| i]; 
		
        // === 1. УНИВЕРСАЛЬНЫЙ ПАСПОРТ ЦЕЛИ ===
        var _is_execution = variable_instance_exists(_inst, "is_execution") ? _inst.is_execution : false;
        var _is_target_weapon = (_inst.object_index == objWeapon || object_is_ancestor(_inst.object_index, objWeapon));
		
        // === 2. ФИЛЬТРЫ И ИГНОРЫ ===
        // Если враг ВООРУЖЕН, оружие на полу ему вообще не интересно
        if (weapon != WEAPONS.UNARMED && _is_target_weapon) continue; 
		
        // Проверка фракции (Казнь и Оружие пропускают этот шаг, их фракция ИИ не волнует)
        if (!_is_execution && !_is_target_weapon && variable_instance_exists(_inst, "faction")) 
        {
            if (_inst.faction == faction) continue; // Своих пропускаем
        }
		
        // === 3. ПРОВЕРКА ВИДИМОСТИ (Стены и Двери по тегам) ===
        // ИСПРАВЛЕНО: передаем координаты текущей проверяемой цели _inst, а не my_target
        var _clear_view = scrHasClearView(x, y, _inst.x, _inst.y);
        
        // ИСПРАВЛЕНО: если видимость НЕ чистая (scrHasClearView вернул false), то пропускаем эту цель
        if (!_clear_view) continue; 
		
        // === 4. СОРТИРОВКА ПРИОРИТЕТОВ ===
        
        // А. ЛОГИКА ДЛЯ БЕЗОРУЖНОГО СОСТОЯНИЯ (Ищет пушку)
        if (state == STATES.UNARMEDSEARCH)
        {
            if (_is_target_weapon)
            {
                // НАШЛИ ОРУЖИЕ! Игнорируем всё остальное, берем его и сразу выходим!
                my_target = _inst; 
                ds_list_destroy(_found_targets); 
                return;
            }
            else
            {
                // Нашли живого врага или объект казни, но мы голые.
                // Просто запоминаем в резерв и крутим цикл дальше — вдруг наткнемся на ствол.
                if (_backup_target == noone) _backup_target = _inst;
                continue; 
            }
        }
		
        // Б. ДЕФОЛТНЫЙ ВЫБОР (Если мы вооружены и дошли сюда — это живой враг или объект казни)
        my_target = _inst;
        ds_list_destroy(_found_targets); 
        return;
    }
    
    // Если цикл полностью закончился, мы безоружны, пушку на полу не нашли,
    // но в процессе видели цель (игрока, казнь или чужака) — идем драться кулаками.
    if (state == STATES.UNARMEDSEARCH && _backup_target != noone)
    {
        my_target = _backup_target;
    }
    
    // Очищаем память
    ds_list_destroy(_found_targets); 
}
