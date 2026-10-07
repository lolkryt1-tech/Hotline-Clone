function scrEnemyFatDie()
{	
    current_speed = 0;

    // 1. Выбрасываем пушку строго на первом кадре падения
    if (floor(image_index) == 1)
    {
		
        if (weapon != WEAPONS.UNARMED && weapon != WEAPONS.FISTS) 
        {
            var _dropped = instance_create_layer(x, y, "Instances", objWeapon);
            _dropped.direction = irandom(360); 
            _dropped.speed = 8; 
            _dropped.my_angle = irandom(360); 
            _dropped.weapon = weapon;
            _dropped.ammo = ammo;
			
            weapon = WEAPONS.UNARMED; // Защита от спавна оружия каждый подкадр
        }
    }
	
    // 2. УСЛОВИЕ ПРЕЖДЕВРЕМЕННОГО ИЛИ ЕСТЕСТВЕННОГО ПАДЕНИЯ
    // Проверяем: либо анимация падения проигралась до конца (image_index >= макс. кадров - 1),
    // либо по нему навалили пулями и баланс упал ДО НУЛЯ ИЛИ МЕНЬШЕ (ИСПРАВЛЕНО)
    var _animation_finished = (image_index >= image_number - 1);
    var _balance_broken = (fat_balance <= 0);

    if (!_animation_finished && !_balance_broken) 
    { 
        image_index += 0.15; // Спокойно продолжаем корячиться в анимации
        return; 
    }
	
    // === 3. ФАЗА СПАВНА ТРУПА ===
    var _dead_body = instance_create_layer(x, y, "Instances", objDeadBody);
    _dead_body.sprite_index = sprColombianFatDead; 
    _dead_body.speed        = 1.5; 
    _dead_body.hit_type     = HIT_TYPE.BULLET;
    _dead_body.go_splat     = 1;
    _dead_body.skin         = skin;

    // РАСЧЁТ НАПРАВЛЕНИЯ ПАДЕНИЯ ТРУПА
    if (_balance_broken && knocked_by_bullet)
    {
        // А: Если его добили пулями — труп летит по вектору выстрела
        _dead_body.direction = last_hit_dir;
        _dead_body.my_angle  = last_hit_dir; 
    }
    else
    {
        // Б: Умер сам от анимации — угол трупа равен углу самого толстяка (my_angle)
        _dead_body.direction = my_angle - 180;
        _dead_body.my_angle  = my_angle - 180; 
    }
	
	scrAddKillStats(250, false);
    instance_destroy();
}
