function scrPlayerShoot(_character, _weapon)
{
    scrAlertEnemySound(x, y, 400);
    if (my_sprites.bullet_obj == noone) return;

    // === 1. СПАВН ПУЛИ / ДРОБИ ===
    var _bullet_x = x + lengthdir_x(0, my_angle) + lengthdir_x(2, my_angle - 90);
    var _bullet_y = y + lengthdir_y(0, my_angle) + lengthdir_y(2, my_angle - 90);

    if (current_weapon == WEAPONS.SHOTGUN) 
    {
        repeat(6) {
            var _pellet = instance_create_layer(_bullet_x, _bullet_y, "Instances", my_sprites.bullet_obj);
            _pellet.direction    = my_angle + random_range(-8, 8);
            _pellet.image_angle  = _pellet.direction;
            _pellet.speed        = my_sprites.bullet_speed + random_range(-2, 2);
            _pellet.faction      = faction;
            _pellet.calibre      = my_sprites.bullet_calibre; // Передаем калибр дроби дробовика
        }
    } 
    else 
    {
        var _bullet = instance_create_layer(_bullet_x, _bullet_y, "Instances", my_sprites.bullet_obj);
        _bullet.image_angle = my_angle;
        _bullet.direction   = my_angle;
        _bullet.speed       = my_sprites.bullet_speed;
        _bullet.faction     = faction;
        _bullet.calibre     = my_sprites.bullet_calibre; // Передаем калибр пистолета или М16
    }

    if (array_length(my_sprites.sounds) > 0) {
        audio_play_sound(my_sprites.sounds[0], 1, false);
    }

    // === 2. ЗАДЕРЖКА ТАЙМЕРА ВЫЛЕТА ГИЛЬЗЫ ===
    switch (current_weapon)
    {
        case WEAPONS.SHOTGUN: shell_ready_to_spawn = 18; break; 
        default:              shell_ready_to_spawn = 0;  break; 
    }

    // Логика интерфейса
    ammo--; 
    icon_shake_angle = 35 * icon_shake_dir; 
    icon_shake_dir = -icon_shake_dir; 
    ammo_color_factor = 1.0; 
    ammo_scale_pulse = 0.15; 
}