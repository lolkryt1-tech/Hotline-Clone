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

skin = noone;
isBleed = true;

// === ИСПРАВЛЕНО: Возвращаем noone, чтобы лужа не улетала за экран ===
blood_pool_forward_offset = noone; // Положительное — вперед, отрицательное — назад
blood_pool_side_offset    = 0;     // Положительное — влево, отрицательное — вправо
blood_pool_scale_override = noone; // Кастомный масштаб лужи (например, 1.5)

// Отрисовка трупов: новые поверх старых
global.body_render_counter--;
depth = global.body_render_counter; 
