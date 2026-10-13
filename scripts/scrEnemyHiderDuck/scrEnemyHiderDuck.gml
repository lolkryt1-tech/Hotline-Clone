function scrEnemyHiderDuck()
{
    // 1. БЕЗОПАСНАЯ СМЕНА СПРАЙТА (Фикс резкого сброса в 0 кадра)
    if (sprite_index != sprColombianHidingShotgun)
    {
        sprite_index = sprColombianHidingShotgun;
        image_index = 5; 
    }
    
    if (reload > 0) reload--; 
    
    // 2. ИЩЕМ ЦЕЛЬ (Только если пушка готова к бою)
    if (my_target == noone && reload <= 0) 
    {
        scrEnemyTryGetTarget();
    }
    
    // 3. ЛИНЕЙНЫЙ И ПЛАВНЫЙ ПОВОРОТ
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
    if (my_target != noone && reload <= 0) 
    {
        if (image_index < 5) image_index += 0.25; 
    }
    else 
    {
        if (image_index > 0) image_index -= 0.25; 
        else                 image_index = 0; 
    }
    
    // 5. РЕЗКИЙ И ЧЕСТНЫЙ ГЕЙМПЛЕЙНЫЙ ПЕРЕХОД
    // Убираем зависимость от угла! Как только физически дошли до 3 кадра — 
    // мгновенно переключаем стейт. Враг становится уязвимым, а доводка пушки
    // и блокировка стрельбы произойдут уже в scrEnemyHiderShoot.
    if (my_target != noone && image_index >= 5 && reload <= 0)
    {
        state = STATES.HIDERSHOOT;
    }
}
