function scrPlayerAttack()
{
    attack_delay--;
    is_attacking = (attack_delay > 0);
    
    // === ЛОГИКА КАЖДОГО КАДРА АТАКИ ===
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
        if (sprite_index == my_sprites.walk || sprite_index == sprCopTurnShotgun) 
        { 
            if (my_sprites.is_ranged && ammo <= 0)
            {
                audio_play_sound(sndDryClick, 1, false); 
                attack_delay = 15; // Небольшая задержка между щелчками пустого крючка
                exit; // Мгновенно выходим! Анимация, тряска и звуки выстрела не сработают
            }

            // 1. Огнестрел: стреляем (патроны гарантированно есть)
            if (my_sprites.is_ranged) 
            {
                scrPlayerShoot(character, current_weapon); 
                objEffector.shake = my_sprites.shake_amount;
            }
            
            // 2. Ближний бой: даём импульс тряски
            if (!my_sprites.is_ranged)
            {
                objEffector.shake = my_sprites.shake_amount;
            }
            
            // === ВОСПРОИЗВЕДЕНИЕ СЛУЧАЙНОГО ЗВУКА ВЫСТРЕЛA / УДАРА ===
            if (array_length(my_sprites.sounds) > 0)
            {
                var _random_index = irandom(array_length(my_sprites.sounds) - 1);
                var _sound_to_play = my_sprites.sounds[_random_index];
                
                if (_sound_to_play != noone)
                {
                    audio_play_sound(_sound_to_play, 1, false);
                }
            }
            
            // === РАЗДЕЛЕНИЕ АНИМАЦИИ ДЛЯ СОХРАНЕНИЯ ФЛИПА ===
            if (is_turning)
            {
                attack_delay = my_sprites.cooldown;
            }
            else
            {
                sprite_index = my_sprites.attack;
                image_index = my_sprites.frame_start;
                attack_delay = my_sprites.cooldown;
            }
        }
    }
}
