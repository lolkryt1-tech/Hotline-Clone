// Базовые параметры анимации
image_speed = 0;

// Убираем friction, чтобы снаряд не тормозил в полете сам по себе
friction = 0; 

// Динамическое управление слоями (глубиной отрисовки), чтобы метательное оружие не перекрывало друг друга
global.weapon_render_counter--;
depth = global.weapon_render_counter - 100;

// Параметры метательного оружия
my_angle = 0;
weapon_type = 0;
weapon = 0;
ammo = 0;
