if (weapon == WEAPONS.BAT) { sprite_index = sprCopKillBat }



// 1. Воспроизводим звук просто при совпадении кадра
if (image_index == 6)
{
    var _played_sound = audio_play_sound(sndHit3, 1, false);
    if (_played_sound != -1)
    {
        audio_sound_pitch(_played_sound, random_range(0.9, 1.1));
    }
}

// 2. Уменьшаем время жизни буфера каждого кадра
if (input_buffer_time > 0) {
    input_buffer_time--;
    if (input_buffer_time == 0) input_buffer = false; 
}

// 3. Ловим нажатие мыши
if (mouse_check_button_pressed(mb_left))
{
    if (isSwinging == false) {
        isSwinging = true;
        image_index = 3;
    } else {
        // ИСПРАВЛЕНО: Архивируем нажатие ТОЛЬКО если это НЕ труба (WEAPONS.PIPE)
        if (weapon != WEAPONS.PIPE) {
            input_buffer = true;
            input_buffer_time = 5; 
        }
    }
}

// 4. Логика удара
if (isSwinging == true)
{
	image_index += 0.5;
	enemy_image_index += 0.25;
    
	if (image_index == 3) 
    { 
        if (input_buffer == true) {
            image_index = 3;       
            input_buffer = false;  
            input_buffer_time = 0;
        } else {
            isSwinging = false;    
        }
    }
}
