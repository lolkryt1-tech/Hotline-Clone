function scrEnemyHiderDuck()
{
    // === ПРЕДОХРАНИТЕЛЬ: ПРОВЕРКА СУЩЕСТВОВАНИЯ ЦЕЛИ ===
    if (my_target != noone && !instance_exists(my_target)) 
    { 
        my_target = noone; // Обнуляем ссылку на уничтоженный инстанс
    }

    // 1. БЕЗОПАСНАЯ СМЕНА СПРАЙТА
    if (sprite_index != sprColombianHidingShotgun)
    {
        sprite_index = sprColombianHidingShotgun;
        image_index = 5; 
    }
    
    if (reload > 0) reload--; 
    
    // 2. ИЩЕМ ЦЕЛЬ (Если цели нет или старая была уничтожена)
    if (my_target == noone) 
    {
        scrEnemyTryGetTarget();
    }
    
    // 3. ЛИНЕЙНЫЙ И ПЛАВНЫЙ ПОВОРОТ (Выполняется только если цель ЖИВА)
    if (my_target != noone)
    {
        var _target_dir = point_direction(x, y, my_target.x, my_target.y);
        var _diff = angle_difference(_target_dir, my_angle);
        var _rot_speed = 6; 
        
        if (abs(_diff) < _rot_speed)
        {
            my_angle = _target_dir;
        }
        else
        {
            my_angle += sign(_diff) * _rot_speed;
        }
    }
    
    // 4. ЛОГИКА АНИМАЦИИ (ПОДЪЕМ / ОПУСКАНИЕ)
    // Если цель жива и готовы стрелять — поднимаемся (анимируем вверх)
    if (my_target != noone && reload <= 0) 
    {
        if (image_index < 5) image_index += 0.25; 
    }
    else 
    {
        // Если цель умерла или мы на перезарядке — плавно прячемся обратно в засаду!
        if (image_index > 0) image_index -= 0.25; 
        else                 image_index = 0; 
    }
    
    // 5. ПЕРЕХОД К СТРЕЛЬБЕ
    // Атаковать можно только если цель реально существует и жива!
    if (my_target != noone && image_index >= 5)
    {
		reload = 10;
        state = STATES.HIDERSHOOT;
    }
}
