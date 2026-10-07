image_speed = 0;
image_index = 0;
depth = -3000;

is_fast_execution = false; 

// ИДЕАЛЬНЫЙ РАСЧЕТ ДЛЯ 8 КАДРОВ:
hurt_index    = 0;   // На 4-м кадре (середина) наносим урон/спавним кровь
finish_index  = 0;   // На 8-м кадре (финал) возвращаем игрока

triggered_hurt = false;
enemy_image_index = 0;

enemy_faction = 0;
enemy_class   = 0;
enemy_skin    = 0;
enemy_sprite  = 0; 

my_angle = 0;
ammo = 0;
current_weapon = WEAPONS.KNIFE;

alarm[0] = 1; 
