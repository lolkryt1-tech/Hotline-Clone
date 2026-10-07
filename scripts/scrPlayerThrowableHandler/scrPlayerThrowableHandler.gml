/// @desc Обрабатывает замах, фазы анимации удержания и бросок метательного ножа СТРОГО через СКМ
function scrPlayerThrowableHandler()
{
	// Считаем таймер зажатия СКМ (колесика)
	if (mouse_check_button(mb_middle)) { MMB_hold_timer++; }
	else { MMB_hold_timer = 0; }

	// Анимация замаха включается, только если СКМ зажата дольше 8 кадров
	if (mouse_check_button(mb_middle) && MMB_hold_timer > 8)
	{
		// ФАЗА 1: Стартовый замах
		if (sprite_index != sprCopKnifePrep && sprite_index != sprCopWalkKnifePrep)
		{
			sprite_index = sprCopKnifePrep;
			image_index = 0;
			prep_thrown = true; 
		}
		
		// ФАЗА 2: Завершение взвода и переход к удержанию/ходьбе
		if (sprite_index == sprCopKnifePrep && floor(image_index) >= 7)
		{
			audio_play_sound(sndDrawKnife, 1, false);
			sprite_index = sprCopWalkKnifePrep;
			image_index = 0;
			prep_thrown = false; 
		}
		
		// Плавный прирост кадров
		if (sprite_index == sprCopKnifePrep)
		{
			if (image_index < 7) image_index += 0.25;
			else image_index = 7; 
		}
		
		return true; // Удерживаем режим прицеливания ножом
	}
	
	// ФАЗА 3: ОТПУСКАНИЕ КОЛЕСИКА — БРОСОК
	var _is_aiming = (sprite_index == sprCopKnifePrep || sprite_index == sprCopWalkKnifePrep);
	
	if (mouse_check_button_released(mb_middle) && _is_aiming)
	{
		audio_play_sound(sndThrow, 1, false);
		
		var _throw_dir = point_direction(x, y, mouse_x, mouse_y);
		var _check_x = x + lengthdir_x(16, _throw_dir);
		var _check_y = y + lengthdir_y(16, _throw_dir);
		var _wall_in_front = collision_line(x, y, _check_x, _check_y, objSolidTall, false, true);
		
		var _object_to_spawn = objWeaponThrow;
		if (sprite_index == sprCopWalkKnifePrep)
		{
			_object_to_spawn = objThrowable;
		}
		
		var _thrown = instance_create_layer(x, y, "Instances", _object_to_spawn);
		_thrown.weapon = current_weapon;
		_thrown.my_angle = _throw_dir; 
		_thrown.image_index = scrWeaponGetImage(current_weapon);
		_thrown.ammo = ammo;
		_thrown.direction = _throw_dir;
		
		_thrown.speed = (_wall_in_front != noone) ? 0 : 13; 
		
		// Сброс состояния игрока в unarmed
		prep_thrown = false;
		reload = 0;
		is_turning = false;
		current_weapon = WEAPONS.UNARMED;
		my_sprites = scrPlayerGetWeaponSprite(character, current_weapon);
		sprite_index = my_sprites.walk;
		
		MMB_hold_timer = 0;
		return true; 
	}

	if (!mouse_check_button(mb_middle))
	{
		prep_thrown = false;
	}

	return false; 
}
