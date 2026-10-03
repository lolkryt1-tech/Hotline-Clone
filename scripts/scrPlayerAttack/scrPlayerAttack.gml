function scrPlayerAttack()
{
    // Защита: если структура my_sprites еще не создана, выходим
    if (!variable_instance_exists(id, "my_sprites")) return;

    attack_delay--;
    is_attacking = (attack_delay > 0);
    
    // === ЛОГИКА КАЖДОГО КАДРА АТАКИ (Твой оригинальный рабочий код) ===
    if (sprite_index == my_sprites.attack) 
    { 
        image_index += my_sprites.anim_speed; 
        
        // Если это холодное оружие — наносим урон в ближнем бою
        if (!my_sprites.is_ranged) 
        {
            scrPlayerAttackMelee(); 
        }
    }
    
    // === ЛОГИКА НАЖАТИЯ МЫШИ (СТАРТ АТАКИ) ===
    if (mouse_check_button(mb_left) && attack_delay <= 0)
    {
        // ИСПРАВЛЕНО: Убрали жесткую привязку к walk. 
        // Теперь атаковать можно и во время ходьбы, и прямо посреди флипа (sprCopTurnShotgun)
        if (sprite_index == my_sprites.walk || sprite_index == sprCopTurnShotgun) 
        { 
            // 1. Огнестрел: стреляем и даём импульс тряски
            if (my_sprites.is_ranged) 
            {
                scrPlayerShoot(character, current_weapon); 
                objEffector.shake = my_sprites.shake_amount;
            }
            
            // 2. Ближний бой: даём импульс тряски один раз в момент замаха
            if (!my_sprites.is_ranged)
            {
                objEffector.shake = my_sprites.shake_amount;
            }
            
            // === ВОСПРОИЗВЕДЕНИЕ СЛУЧАЙНОГО ЗВУКА ===
            if (variable_struct_exists(my_sprites, "sounds") && array_length(my_sprites.sounds) > 0)
            {
                var _random_index = irandom(array_length(my_sprites.sounds) - 1);
                var _sound_to_play = my_sprites.sounds[_random_index];
                
                if (_sound_to_play != noone)
                {
                    audio_play_sound(_sound_to_play, 1, false);
                }
            }
            
            // === ИСПРАВЛЕНО: РАЗДЕЛЕНИЕ АНИМАЦИИ ДЛЯ СОХРАНЕНИЯ ФЛИПА ===
            if (is_turning)
            {
                // Если мы крутим флип — пули вылетают, удар засчитывается, но сам спрайт флипа мы НЕ перебиваем!
                attack_delay = my_sprites.cooldown;
            }
            else
            {
                // Обычное состояние — включаем штатную анимацию атаки (где работает твой разворот рук по Y)
                sprite_index = my_sprites.attack;
                image_index = my_sprites.frame_start;
                attack_delay = my_sprites.cooldown;
            }
        }
    }
}
