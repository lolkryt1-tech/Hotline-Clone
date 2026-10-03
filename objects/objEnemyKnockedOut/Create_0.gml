// Обязательно возвращаем звук сюда — он сработает в любом случае!
audio_play_sound(sndWeaponHit, 1, false);

my_angle = 0;
image_speed = 0;
friction = 0.4;
depth = -3000;

class   = 0;
faction = 0;
fric    = 0.15;
is_GettingUp = false;

// Важный таймер подъема: через 120 кадров (2 секунды) враг начнет вставать на ноги
call_later(120, time_source_units_frames, function() 
{
    is_GettingUp = true;
});
