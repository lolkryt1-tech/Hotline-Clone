function scrPlayerInteractWeapon()
{
	// Реагируем строго на клик ПКМ
	if (!mouse_check_button_pressed(mb_right)) return;
	
	// Создаем список для сбора всего оружия под ногами
	var _list = ds_list_create();
	var _num = collision_circle_list(x, y, 20, objWeapon, false, true, _list, false);
	
	// Если в радиусе вообще ничего не лежит, и мы безоружны — уничтожаем список и выходим
	if (_num == 0 && current_weapon == WEAPONS.UNARMED) 
	{
		ds_list_destroy(_list);
		return;
	}
    
	// Если у игрока уже есть оружие в руках — ВЫБРАСЫВАЕМ его сначала
	if (current_weapon != WEAPONS.UNARMED)
	{
		audio_play_sound(sndThrow, 1, false);
		
		// 1. Считаем направление броска к курсору мыши
		var _throw_dir = point_direction(x, y, mouse_x, mouse_y);
        
		// 2. Считаем точку впереди игрока (на расстоянии 16 пикселей), где полетит пушка
		var _check_x = x + lengthdir_x(16, _throw_dir);
		var _check_y = y + lengthdir_y(16, _throw_dir);
        
		// 3. Проверяем, нет ли прямо перед нами стены
		var _wall_in_front = collision_line(x, y, _check_x, _check_y, objSolidTall, false, true);
        
		// 4. Создаем объект брошенного оружия
		var _thrown = instance_create_layer(x, y, "Instances", objWeaponThrow);
		_thrown.weapon = current_weapon;
		_thrown.my_angle = irandom(360);
		_thrown.image_index	= scrWeaponGetImage(current_weapon);
        
		if (_wall_in_front != noone)
		{
			// ЕСЛИ ВПЕРЕДИ СТЕНА: пушка падает прямо под ноги и никуда не летит
			_thrown.direction = _throw_dir;
			_thrown.speed = 0; 
		}
		else
		{
			// ЕСЛИ ПУТЬ ЧИСТ: пушка летит со стандартной скоростью
			_thrown.direction = _throw_dir;
			_thrown.speed = 12;
		}
        
		// Сбрасываем оружие у игрока
		reload = 0;
		is_turning = false;
		current_weapon = WEAPONS.UNARMED;
		my_sprites = scrPlayerGetWeaponSprite(character, current_weapon);
		sprite_index = my_sprites.walk; // ИСПРАВЛЕНО: добавлена "s"
	}
	
	// Если оружие найдено, выбираем наилучшее по фильтрам
	if (_num > 0) 
	{
		var _best_weapon_instance = noone;
    
		// Проверяем нажатие боковых кнопок мыши
		var _hold_mouse4 = mouse_check_button(mb_side2); // Для огнестрела (поднимаем RANGE)
		var _hold_mouse5 = mouse_check_button(mb_side1); // Для ближнего боя (поднимаем MELEE)

		for (var i = 0; i < _num; i++) 
		{
			var _inst = _list[| i];
        
			// Если это первый проверенный объект, берем его за эталон
			if (_best_weapon_instance == noone) 
			{
				_best_weapon_instance = _inst;
				continue;
			}
        
			// --- АБСОЛЮТНЫЙ ПРИОРИТЕТ ПО ТИПУ (БЕЗ УЧЕТА ГЛУБИНЫ) ---
        
			// Вариант 1: Зажата MOUSE4 -> Приоритет огнестрелу (TYPE.RANGE), на глубину все равно
			if (_hold_mouse4) 
			{
				var _inst_is_range = (_inst.weapon_type == TYPE.RANGE);
				var _best_is_range = (_best_weapon_instance.weapon_type == TYPE.RANGE);
				
				// Если нашли огнестрел, а текущий эталон — нет, то гарантированно переключаемся на него
				if (_inst_is_range && !_best_is_range) 
				{
					_best_weapon_instance = _inst;
				}
			}
			
			// Вариант 2: Зажата MOUSE5 -> Приоритет холодному оружию (TYPE.MELEE), на глубину все равно
			else if (_hold_mouse5) 
			{
				var _inst_is_melee = (_inst.weapon_type == TYPE.MELEE);
				var _best_is_melee = (_best_weapon_instance.weapon_type == TYPE.MELEE);
				
				// Если нашли холодное оружие, а текущий эталон — нет, то забираем его себе
				if (_inst_is_melee && !_best_is_melee) 
				{
					_best_weapon_instance = _inst;
				}
			}
			
			// Вариант 3: Кнопки не нажаты -> Ориентируемся СТРОГО по глубине
			else 
			{
				if (_inst.depth > _best_weapon_instance.depth) 
				{
					_best_weapon_instance = _inst;
				}
			}
		}

		// Забираем выбранное оружие
		if (instance_exists(_best_weapon_instance)) 
		{
			audio_play_sound(_best_weapon_instance.pickup_sound, 1, false);
			
			current_weapon = _best_weapon_instance.weapon;
			my_sprites = scrPlayerGetWeaponSprite(character, current_weapon);
			sprite_index = my_sprites.walk; // ИСПРАВЛЕНО: добавлена "s"
			image_yscale = standart_y_scale;
        
			instance_destroy(_best_weapon_instance);
		}
	}

	// Обязательно очищаем память от динамического списка
	ds_list_destroy(_list);
}
