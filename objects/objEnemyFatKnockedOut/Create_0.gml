my_angle = 0;
image_speed = 0;
friction = 0.2;
depth = -3000;

last_safe_x = x;
last_safe_y = y;

my_hurtbox = instance_create_layer(x, y, "Instances", objEnemyHurtBox);
my_hurtbox.owner = id;

class   = CLASS.FAT;
skin	= 0;
faction = 0;
is_GettingUp = false;

fat_blood_current = 100;
fat_is_bleeding   = false;
sprFatDead		  = sprColombianFatDead;

// === СИСТЕМА УРОНА ПО КАЛИБРАМ И ДРОБИ + ЗАГЛУШКИ ===
pellets_hit  = 0;  // Счетчик попавших дробинок/пуль в текущем кадре
last_hit_dir = 0;  // Направление последнего попадания (для отлета трупа)
kill_instantly = false;
current_speed = 0;
state = noone;

// Ещё заглушки
last_safe_x = x;
last_safe_y = y;
sprKnockedLean = noone;
sprDeadLeanMelee = noone;
sprDeadLeanShotgun = noone;
sprDeadLeanMachinegun = noone;

// Важный таймер подъема: через 120 кадров (2 секунды) враг начнет вставать на ноги
call_later(120, time_source_units_frames, function() 
{
    is_GettingUp = true;
});
