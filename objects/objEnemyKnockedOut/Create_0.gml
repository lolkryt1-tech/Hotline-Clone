my_angle = 0;
image_speed = 0;
friction = 0.2;
depth = -3000;

last_safe_x = x;
last_safe_y = y;

skin	= 0;
class   = 0;
faction = 0;
is_GettingUp = false;

sprKnockedLean = noone;
sprDeadLeanMelee   = noone;
sprDeadLeanShotgun = noone;
sprDeadLeanMachinegun = noone;

// ЗАГЛУШКИ
fat_blood_current = 100;
fat_is_bleeding   = false;
sprFatDead		  = sprColombianFatDead;

// Важный таймер подъема: через 120 кадров (2 секунды) враг начнет вставать на ноги
call_later(120, time_source_units_frames, function() 
{
    is_GettingUp = true;
});
