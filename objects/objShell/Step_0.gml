// === 1. ОПРЕДЕЛЕНИЕ ЗВУКА И МАСШТАБА ГИЛЬЗЫ ===
if (image_index == 0 || image_index == 1) 
{ 
    shell_sound = sndShell;
    image_xscale = 1.0;
    image_yscale = 1.0;
}
else 
{ 
    shell_sound = sndShotgunShell;
}

// 2. Вращаем гильзу в воздухе, пока она летит
if (z > 0 || z_speed != 0) 
{
    image_angle += rot_speed;
    friction = 0; 
}

// === КЛЮЧЕВОЙ ФИКС: СТОЛКНОВЕНИЕ С objSolid ПО ГОРИЗОНТАЛИ ===
if (place_meeting(x + hspeed, y + vspeed, objSolidTall))
{
    speed = 0;
    rot_speed = random_range(1, 3) * sign(rot_speed); 
}

// 3. Считаем физику высоты (Z-ось)
z_speed -= gravity_z; 
z += z_speed;         

// 4. Проверяем удар о пол
if (z <= 0) 
{
    z = 0; // На пол
    
    if (bounce_count < max_bounces) 
    {
        // === ВОСПРОИЗВЕДЕНИЕ СЛУЧАЙНОГО ЗВУКА ОТСКОКА ===
        // ИСПРАВЛЕНО: Теперь играет shell_sound (sndShell или sndShotgunShell)
        var _shell_sound = audio_play_sound(shell_sound, 1, false);
        
        if (_shell_sound != -1)
        {
            // С каждым отскоком делаем звук тише
            var _volume = 1.0 / (bounce_count + 1); 
            audio_sound_gain(_shell_sound, _volume, 0);
            
            // Немного меняем высоту звука (pitch)
            var _pitch = random_range(0.9, 1.2);
            audio_sound_pitch(_shell_sound, _pitch);
        }

        // Даем бодрый пинок вверх
        z_speed = (1.8 / (bounce_count + 1)) + random_range(0.1, 0.3);
        
        // Рандомное смещение направления при каждом ударе о пол
        if (!place_meeting(x, y, objSolidTall)) 
        {
            direction += random_range(-25, 25);
            speed *= 0.65; 
        }
        else
        {
            speed = 0; 
        }
        
        rot_speed *= 0.7; 
        bounce_count++;
    }
    else 
    {
        // ГИЛЬЗА ПОЛНОСТЬЮ СЕЛА НА ПОЛ
        z_speed = 0;
        rot_speed = 0;
        
        if (speed > 0) friction = 0.15; else friction = 0;
    }
}
