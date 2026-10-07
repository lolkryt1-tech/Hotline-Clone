image_speed = 0;
depth = -3000;

ammo = 0;
weapon = 0;

hurt_index = 5;
finish_index = 8;

// ИСПРАВЛЕНО: Индексы 4 кадров — это 0, 1, 2, 3. Значит максимум это 3.
enemy_max_image_index = 3; 
enemy_image_index = 0;

enemy_class  = 0;
enemy_skin	 = 0;
enemy_sprite = 0;

triggered_hurt = false; // НОВАЯ ПЕРЕМЕННАЯ: флаг, что урон нанесен

if weapon == WEAPONS.M16 { sprite_index = sprCopKillM16; }
