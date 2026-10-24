// Уменьшаем таймер жизни объекта
if (death_timer > 0)
{
    death_timer--;
}

// Увеличиваем счетчик для периодических тиков
effect_tick++;

// Переменные для финального спавна трупа (задаются в кейсах при завершении таймера)
var _spawn_final_corpse = false;
var _head_offset = 0;
var _blood_pool_offset = 0;
var _blood_pool_scale = 1.0;
var _spawn_squirt_at_end = false;

// === КЕЙСОВАЯ СИСТЕМА В STEP ===
switch (death_type)
{
	case ANIM_DEATH.KNIFE_THROW:
		// Логика аналогична старому коду: просто ждем конца таймера
		if (death_timer <= 0)
		{
			_spawn_final_corpse  = true;
			_head_offset         = 48;
			_blood_pool_offset   = 46;
			_blood_pool_scale    = 0.5;
			_spawn_squirt_at_end = true;
		}
		break;
		
	case ANIM_DEATH.CONVULSIONS:
		// Уменьшаем внутренний таймер текущего подсостояния
		if (state_timer > 0) 
		{
			state_timer--;
		}
		else 
		{
			// Переключаем состояния, когда таймер выходит в 0
			if (convulsion_state == 0) 
			{
				// Переходим в застывание: длится от 40 до 80 кадров (~1+ сек)
				convulsion_state = 1;
				state_timer = 40 + irandom(40);
			} 
			else 
			{
				// Переходим обратно в тряску: длится от 20 до 50 кадров
				convulsion_state = 0;
				state_timer = 20 + irandom(30);
			}
		}

		// --- ОБРАБОТКА ПОДСОСТОЯНИЙ ---
		
		// ФАЗА 0: Тело двигается и бьется в судорогах
		if (convulsion_state == 0)
		{
			image_speed = 1; // Заставляем спрайт воспроизводиться
			
			// Брызгаем кровь из головы с небольшой периодичностью
			if (death_timer > 0 && (effect_tick % 24 == 0))
			{
				_head_offset = 32;
				var _blood_x = x + lengthdir_x(_head_offset, my_angle);
				var _blood_y = y + lengthdir_y(_head_offset, my_angle);
	
				var _drop = instance_create_layer(_blood_x, _blood_y, "Instances", objBloodSquirt);
	

				var _blood_dir = my_angle + random_range(-90, 90);
	
				_drop.direction   = _blood_dir;
				_drop.image_angle = _blood_dir;
			}
		}
		// ФАЗА 1: Тело застывает в паузе
		else if (convulsion_state == 1)
		{
			image_speed = 0; // Замораживаем анимацию на текущем кадре судороги
			// Угол не меняем, кровь не спавним (тело просто замерло)
		}

		// 3. ФИНАЛ: Когда общий таймер конвульсий вышел
		if (death_timer <= 0)
		{
			_spawn_final_corpse  = true;
			_head_offset         = 32;
			_blood_pool_offset   = 32;
			_blood_pool_scale    = 1.0;
			_spawn_squirt_at_end = false;
			image_speed			 = 0;
		}
		break;

}

// === СБОРКА ФИНАЛЬНОГО ТРУПА И САМОУНИЧТОЖЕНИЕ ===
if (_spawn_final_corpse)
{
	// Спавним финальный фонтан из головы, если кейс это запросил
	if (_spawn_squirt_at_end)
	{
		var _head_x = x + lengthdir_x(_head_offset, my_angle);
		var _head_y = y + lengthdir_y(_head_offset, my_angle);
		
		repeat(4) 
		{
			var _direction = (my_angle) + random_range(-30, 30);
			var _squirt = instance_create_layer(_head_x, _head_y, "Instances", objBloodSquirt);
			_squirt.image_angle = _direction;
			_squirt.direction   = _direction;
		}
	}

	// Переносим все данные в статичное тело на полу
	var _deadBody = instance_create_layer(x, y, "Instances", objDeadBody);
	_deadBody.sprite_index = sprite_index;
	_deadBody.image_index  = image_index;
	_deadBody.my_angle     = my_angle;
	_deadBody.go_splat     = false;

	_deadBody.blood_pool_forward_offset = _blood_pool_offset; 
	_deadBody.blood_pool_scale_override = _blood_pool_scale;

	// Уничтожаем анимированный объект
	instance_destroy();
}
