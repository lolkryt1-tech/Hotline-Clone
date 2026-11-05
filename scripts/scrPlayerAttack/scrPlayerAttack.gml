function scrPlayerAttack()
{
    attack_delay--;
    is_attacking = (attack_delay > 0);
	
	
	// === ПРОВЕРКА ВЗАИМОДЕЙСТВИЯ С МЕНЮ ===

	var _ui_blocked = global.camera_shake_menu_hover || global.camera_shake_menu_dragging;

	var _menu = instance_find(objCameraShakeMenu, 0);

	if (_menu != noone)
	{
	    var _mx = device_mouse_x_to_gui(0);
	    var _my = device_mouse_y_to_gui(0);

	    if (_menu.dragging || point_in_rectangle(_mx, _my, _menu.x, _menu.y, _menu.x + _menu.window_w, _menu.y + _menu.window_h))
	    {
	        _ui_blocked = true;
	    }
	}
    
    // === ЛОГИКА КАЖДОГО КАДРА АТАКИ ===
    if (sprite_index == my_sprites.attack) 
    { 
        image_index += my_sprites.anim_speed; 
        
        // Если это холодное оружие — наносим урон в ближнем бою
        if (!my_sprites.is_ranged && image_index < my_sprites.hit_end) 
        {
			debug_melee_timer = 1;
            scrPlayerAttackMelee(); 
        }
    }
    
    // === ЛОГИКА НАЖАТИЯ МЫШИ (СТАРТ АТАКИ) ===
    //if (mouse_check_button(mb_left) && attack_delay <= 0)
	if (!_ui_blocked && mouse_check_button(mb_left) && attack_delay <= 0)
    {
        if (sprite_index == my_sprites.walk || sprite_index == sprCopTurnShotgun) 
        { 
            if (my_sprites.is_ranged && ammo <= 0)
            {
                audio_play_sound(sndDryClick, 1, false); 
                attack_delay = 15; // Небольшая задержка между щелчками
                exit;
            }

            // 1. Огнестрел: стреляем (патроны гарантированно есть)
            if (my_sprites.is_ranged) 
            {
                // Разделяем обычную стрельбу и хитскан для снайперской винтовки
                if (current_weapon == WEAPONS.SNIPER)
                {
                    scrPlayerHitscanShot(); // Вызываем хитскан-выстрел
                }
                else
                {
                    scrPlayerShoot(character, current_weapon); // Обычная стрельба снарядами
                }

				with (objEffector)
				{
				    var _shake = other.my_sprites.shake;

				    scrCameraKickShakeStart(_shake.kick.strength, _shake.kick.rotation, _shake.kick.attack, _shake.kick.release);
				    scrCameraBounceShakeStart(_shake.bounce.strength, _shake.bounce.rotation, _shake.bounce.frequency, _shake.bounce.damping);
				}
            }
            
            // 2. Ближний бой: даём импульс тряски
            if (!my_sprites.is_ranged)
            {
                with (objEffector) {
				    scrCameraBounceShakeStart(2, 2, 2, 2);
				}
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
