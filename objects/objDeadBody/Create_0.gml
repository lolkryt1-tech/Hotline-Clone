image_index = irandom_range(1, 14);
friction = 0.4;
image_speed = 0;

enum HIT_TYPE {
	BULLET,
	BLUNT,
	CUT,
	STOMP,
	UNARMED,
	PELLET,
}

my_angle = 0;
create_blood_pool = 0;
isExecuted = false;
go_splat = 0;
hit_type = 0;

isBleed = true;

// Отрисовка трупов: новые поверх старых
global.body_render_counter--;
depth = global.body_render_counter; 
