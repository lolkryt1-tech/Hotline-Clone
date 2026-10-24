enum ANIM_DEATH 
{
	KNIFE_THROW,
	CONVULSIONS
	// Сюда можно будет добавлять новые типы
}


image_speed = 0.35;
my_angle = 0;

// === ГИБКАЯ НАСТРОЙКА ИЗВНЕ (ENUM) ===
death_type  = ANIM_DEATH.KNIFE_THROW; 
death_timer = 95; // Время жизни анимированного объекта в кадрах (замена alarm[0])

// Внутренний счетчик для периодических эффектов (например, капель крови)
effect_tick = 0; 

// КОНВУЛЬСИЯ
convulsion_state = 0;    // 0 = тряска/движение, 1 = застывание (пауза)
state_timer = 30 + irandom(30); // Таймер текущего подсостояния

// Начальный брызг при попадании
repeat(4)
{
	var _rand_smoke = instance_create_layer(x, y, "Instances", objBloodSmoke);
	var _rand_dir = random(360);
	_rand_smoke.direction   = _rand_dir;
	_rand_smoke.image_angle = _rand_dir;
	_rand_smoke.speed       = random_range(0.5, 2);
}

