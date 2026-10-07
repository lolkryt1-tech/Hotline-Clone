function scrEnemyAttackMelee()
{
	speed = 0; // Подстраховка от встроенного спида GameMaker
	
	// === ИСПРАВЛЕНО: Защита срабатывает только ДО того, как мы успели сделать замах ===
	// Если цель исчезла, но мы ЕЩЕ НЕ дошли до кадра удара (floor(image_index) < 2), тогда выходим.
	// Если мы уже ударили (кадр 2 или выше), даем анимации честно докрутиться до конца кадра.
	if (!instance_exists(my_target) && floor(image_index) < 2) 
	{ 
		state = STATES.STEP; 
		exit; 
	}
	
	// 1. ДИНАМИЧЕСКАЯ СКОРОСТЬ ДО ТАРГЕТА (считаем только если цель жива)
	var _distance_to_target = 0;
	if (instance_exists(my_target)) 
	{
		_distance_to_target = point_distance(x, y, my_target.x, my_target.y);
		target_speed = (_distance_to_target > 12) ? max_speed : 0;
	}
	else 
	{
		target_speed = 0; // Если цель стёрта, ИИ останавливается на месте для замаха
	}
	
	// 2. ФИЗИЧЕСКОЕ ДВИЖЕНИЕ (если цель жива — бежим к ней)
	if (instance_exists(my_target))
	{
		var _dir   = point_direction(x, y, my_target.x, my_target.y);
		var _vel_x = lengthdir_x(current_speed, _dir);
		var _vel_y = lengthdir_y(current_speed, _dir);
		move_and_collide(_vel_x, _vel_y, objSolid);
	}
	
	// 4. ЧЕСТНОЕ И УНИВЕРСАЛЬНОЕ ПОРАЖЕНИЕ ЦЕЛИ (Наносится строго на кадре удара)
	var _strike_frame = 2; 
	
	// Проверяем кадр. Дополнительно проверяем, что my_target еще жив (чтобы не наносить урон дважды)
	if (floor(image_index) == _strike_frame && instance_exists(my_target) && _distance_to_target <= 16)
	{
		var _obj = my_target.object_index;
		var _strike_dir = point_direction(x, y, my_target.x, my_target.y);

		if (_obj == objPlayerDead) 
		{
			target_speed = 0;
		}
		else if (_obj == objPlayer || object_is_ancestor(_obj, objPlayerExecution))
		{ 
			scrPlayerDieBlunt(id); 
			target_speed = 0; 
		}
		else 
		{ 
			// Безопасный бэкап, чтобы вложенный scrEnemyGetSprite случайно не затер наше оружие
			var _my_actual_weapon = weapon;

			// Наносим смертельный удар другому врагу
			scrEnemyGetHitMelee(my_target, weapon, _strike_dir, id); 
			
			// Возвращаем пушку на место
			weapon = _my_actual_weapon;
			target_speed = 0; 
		}
	}
    
	// 5. КОНЕЦ АТАКИ: Анимация полностью завершилась
	if (image_index < image_number - 1) exit;
	
	// Сброс параметров и переход в фазу ходьбы/отхода ПОСЛЕ полной прокрутки спрайта
	sprite_index = my_sprites.sprites.walk;
	image_yscale *= -1; // y_flip для чередования ударов левой/правой рукой
	image_index  = 0; 
	state        = STATES.STEP; 
}
