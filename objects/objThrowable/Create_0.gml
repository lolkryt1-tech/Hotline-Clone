// Базовые параметры анимации
image_speed = 0;

// Убираем friction, чтобы снаряд не тормозил в полете сам по себе
friction = 0; 

// Чтобы метательное скорее всего находилось над оружием
global.weapon_render_counter--;
depth = global.weapon_render_counter - 300;

// Параметры метательного оружия
my_angle = 0;
weapon_type = 0;
weapon = 0;
ammo = 0;
