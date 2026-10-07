image_speed = 0;
friction = 0.8;

global.weapon_render_counter--;
depth = global.weapon_render_counter;

enum WEAPONS {
	UNARMED,
	BAT,
	PIPE,
	M16,
	PISTOL,
	SHOTGUN,
	KNIFE,
	FISTS
}

enum TYPE {
	MELEE,
	RANGE,
	CUT,
	SLASH
}

ammo = 0
my_angle = random(360);
weapon = 0;
weapon_type = 0;
pickup_sound = noone;


hover_timer = random(100); // Случайный старт, чтобы куча пушек не качалась синхронно
hover_speed = 0.05;        // Скорость покачивания
hover_amplitude = 2.5;     // Высота подъема/опускания в пикселях

// При спавне оружия
if (image_index == 0) { weapon = WEAPONS.KNIFE;  weapon_type = TYPE.CUT; pickup_sound = sndPickUpWeapon; }
if (image_index == 1) { weapon = WEAPONS.BAT;  weapon_type = TYPE.MELEE; pickup_sound = sndPickUpWeapon; }
if (image_index == 2) { weapon = WEAPONS.PIPE; weapon_type = TYPE.MELEE; pickup_sound = sndPickUpWeapon; }
if (image_index == 3) { weapon = WEAPONS.PISTOL;  weapon_type = TYPE.RANGE; pickup_sound = sndPickUpWeapon;  ammo = 15; }
if (image_index == 4) { weapon = WEAPONS.SHOTGUN;  weapon_type = TYPE.RANGE; pickup_sound = sndPickUpWeapon; ammo = 6; }
if (image_index == 5) { weapon = WEAPONS.M16;  weapon_type = TYPE.RANGE; pickup_sound = sndPickUpWeapon;	 ammo = 24; }