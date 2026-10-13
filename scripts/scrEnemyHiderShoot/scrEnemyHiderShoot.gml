function scrEnemyHiderShoot()
{
    // 1. ПРОВЕРКА НА СУЩЕСТВОВАНИЕ И ВИДИМОСТЬ ЦЕЛИ
    if (!instance_exists(my_target)) 
    { 
        my_target = noone;
        state = STATES.HIDERDUCK; 
        reload = max(reload, 30); 
        start_shooting = false;
        exit; 
    }
    
    var _clear_view = scrHasClearView(x, y, my_target.x, my_target.y);
    var _distance = point_distance(x, y, my_target.x, my_target.y);
    
    if (!_clear_view || _distance > 400)
    {
        my_target = noone;
        state = STATES.HIDERDUCK; 
        reload = max(reload, 20); 
        start_shooting = false;
        exit;
    }
    
    // 2. ЧЕСТНЫЙ ЛИНЕЙНЫЙ ПОВОРОТ БЕЗ ЛЕРПА
    var _pdir = point_direction(x, y, my_target.x, my_target.y);
    var _diff = angle_difference(_pdir, my_angle);
    
    // Переводим коэффициенты в жесткие градусы за один кадр.
    // Если уже стреляет — крутится со скоростью 9 градусов/кадр (очень резко).
    // Если только наводится перед первым выстрелом — 4 градуса/кадр (плавно).
    var _rot_speed = (start_shooting) ? 9 : 6; 
    
    if (abs(_diff) < _rot_speed)
    {
        my_angle = _pdir;
    }
    else
    {
        // Использование sign() гарантирует постоянную скорость поворота до самого конца
        my_angle += sign(_diff) * _rot_speed;
    }
    
    // Обновляем разницу углов после совершенного поворота для следующих проверок
    _diff = angle_difference(_pdir, my_angle);
    
    // =========================================================================
    // ДОИГРЫВАНИЕ АНИМАЦИИ ПОДЪЕМА 
    // =========================================================================
    if (sprite_index == sprColombianHidingShotgun)
    {
        if (image_index < 5) 
        {
            image_index += 0.25;
        }
        else
        {
            sprite_index = my_sprites.sprites.walk;
            image_index = 0;
        }
        
        if (reload > 0) reload--;
        return; 
    }
    // =========================================================================
    
    // 3. УПРАВЛЕНИЕ АНИМАЦИЕЙ АТАККИ
    if (sprite_index == my_sprites.sprites.attack) 
    { 
        image_index += my_sprites.anim_speed; 
        
        if (image_index >= image_number)
        {
            sprite_index = my_sprites.sprites.walk;
            image_index = 0;
        }
    }
    
    if (reload > 0) reload--;
    
    // Пока не наведёмся идеально — не стреляем (Зажали до честных 8 градусов)
    if (abs(_diff) > 8 || reload > 0) return;
    
    // 4. ПРОВЕРКА ПУСТОГО МАГАЗИНА
    if (ammo <= 0)
    {
        audio_play_sound(sndDryClick, 10, false); 
        empty_clicks_count++;
        reload = 25;
        
        if (empty_clicks_count >= empty_clicks_target)
        {
            var _dropped = instance_create_layer(x, y, "Instances", objWeaponUnreachable);
            _dropped.image_index = scrWeaponGetImage(weapon);
            _dropped.weapon      = weapon;
            _dropped.ammo        = 0;
            _dropped.my_angle    = irandom(360);
            _dropped.direction   = irandom(360); 
            _dropped.speed       = 5;
            
            var _enemy = instance_create_layer(x, y, "Instances", objEnemyColombian);
            _enemy.weapon             = WEAPONS.UNARMED;
            _enemy.isRange_weapon     = false;
            _enemy.start_shooting     = false;
            _enemy.empty_clicks_count = 0;
            _enemy.my_angle           = my_angle; 

            _enemy.state              = STATES.UNARMEDSEARCH;
            _enemy.my_sprites         = scrEnemyGetSprite(skin, WEAPONS.UNARMED);
            _enemy.sprite_index       = _enemy.my_sprites.sprites.walk;
            
            instance_destroy();
        }
        return; 
    }
    
    // 5. НЕПОСРЕДСТВЕННО СТРЕЛЬБА
    sprite_index = my_sprites.sprites.attack;
    image_index = 0;
    
    scrEnemyShoot(); 
}
