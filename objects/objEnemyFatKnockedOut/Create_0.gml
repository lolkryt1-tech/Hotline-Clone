my_angle = 0;
image_speed = 0;
friction = 0.2;
depth = -3000;

my_hurtbox = instance_create_layer(x, y, "Instances", objEnemyHurtBox);
my_hurtbox.owner = id;

class   = CLASS.FAT;
skin	= 0;
faction = 0;
fric    = 0.15;
is_GettingUp = false;

fat_blood_current = 0;
fat_is_bleeding   = false;
sprFatDead		  = sprColombianFatDead;

// === СИСТЕМА УРОНА ПО КАЛИБРАМ И ДРОБИ + ЗАГЛУШКИ ===
pellets_hit  = 0;  // Счетчик попавших дробинок/пуль в текущем кадре
last_hit_dir = 0;  // Направление последнего попадания (для отлета трупа)
kill_instantly = false;
state = noone;
current_speed = 0;

// Важный таймер подъема: через 120 кадров (2 секунды) враг начнет вставать на ноги
call_later(120, time_source_units_frames, function() 
{
    is_GettingUp = true;
});
