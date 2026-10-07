image_speed = 0;
friction = 0.8;


my_angle = 0;
weapon = 0;
ammo = 0;

hover_timer = 0; // Случайный старт, чтобы куча пушек не качалась синхронно
hover_speed = 0.05;        // Скорость покачивания
hover_amplitude = 2.5;     // Высота подъема/опускания в пикселях

if (image_index == 0) { weapon = WEAPONS.KNIFE;  weapon_type = TYPE.MELEE; pickup_sound = sndPickUpWeapon; }
if (image_index == 1) { weapon = WEAPONS.BAT;  weapon_type = TYPE.MELEE; pickup_sound = sndPickUpWeapon; }
if (image_index == 2) { weapon = WEAPONS.PIPE; weapon_type = TYPE.MELEE; pickup_sound = sndPickUpWeapon; }
if (image_index == 3) { weapon = WEAPONS.PISTOL;  weapon_type = TYPE.RANGE; pickup_sound = sndPickUpWeapon; }
if (image_index == 4) { weapon = WEAPONS.SHOTGUN;  weapon_type = TYPE.RANGE; pickup_sound = sndPickUpWeapon; }
if (image_index == 5) { weapon = WEAPONS.M16;  weapon_type = TYPE.RANGE; pickup_sound = sndPickUpWeapon; }
