image_speed = 0;

// Управление глубиной
global.weapon_render_counter--;
depth = global.weapon_render_counter;

// Базовые параметры, которые передаст летящий нож
my_angle = 0;
weapon = 0;
ammo = 0;

// Переменные для привязки к двери
attached_door = noone; // Ссылка на дверь, в которую воткнулись
rel_angle = 0;         // Разница углов между ножом и дверью
rel_dist = 0;          // Расстояние от центра двери до точки втыкания
rel_dir = 0;           // Направление от центра двери до точки втыкания
is_stuck_in_door = false;

if (image_index == 0) { weapon = WEAPONS.KNIFE;  weapon_type = TYPE.MELEE; pickup_sound = sndPickUpWeapon; }
if (image_index == 1) { weapon = WEAPONS.BAT;  weapon_type = TYPE.MELEE; pickup_sound = sndPickUpWeapon; }
if (image_index == 2) { weapon = WEAPONS.PIPE; weapon_type = TYPE.MELEE; pickup_sound = sndPickUpWeapon; }
if (image_index == 3) { weapon = WEAPONS.PISTOL;  weapon_type = TYPE.RANGE; pickup_sound = sndPickUpWeapon; }
if (image_index == 4) { weapon = WEAPONS.SHOTGUN;  weapon_type = TYPE.RANGE; pickup_sound = sndPickUpWeapon; }
if (image_index == 5) { weapon = WEAPONS.M16;  weapon_type = TYPE.RANGE; pickup_sound = sndPickUpWeapon; }
