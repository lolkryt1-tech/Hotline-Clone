function scrPlayerInteractWeapon()
{

	// === 2.  ЛОГИКА ПОДБОРА ИЛИ ВЫБРОСА (СТРОГО НА НАЖАТИЕ ПКМ) ===
	if (!scrBindCheckPressed("pickup_weapon")) return;
	
	// Поиск оружия на полу
	var _tagged_weapons = tag_get_asset_ids("Weapon", asset_object);
	var _list = ds_list_create();
	var _num = collision_circle_list(x, y, 20, _tagged_weapons, false, true, _list, false);
	
	if (_num == 0 && current_weapon == WEAPONS.UNARMED) 
	{
		ds_list_destroy(_list);
		return;
	}
    
	// ДЕЙСТВИЕ А: СНАЧАЛА ЗАПОМИНАЕМ И ВЫБРАСЫВАЕМ ТЕКУЩЕЕ ОРУЖИЕ
	var _old_weapon = current_weapon;
	if (current_weapon != WEAPONS.UNARMED)
	{
		audio_play_sound(sndThrow, 1, false);
		
		var _throw_dir = point_direction(x, y, objEffector.x, objEffector.y);
		var _check_x = x + lengthdir_x(16, _throw_dir);
		var _check_y = y + lengthdir_y(16, _throw_dir);
		var _wall_in_front = collision_line(x, y, _check_x, _check_y, objSolidTall, false, true);
        
		var _thrown = instance_create_layer(x, y, "Instances", objWeaponThrow);
		_thrown.weapon = current_weapon;
		_thrown.my_angle = (current_weapon == WEAPONS.KNIFE) ? _throw_dir : irandom(360);
		_thrown.image_index = scrWeaponGetImage(current_weapon);
		_thrown.ammo = ammo;
		_thrown.isPlayerPickedUp = true;
		_thrown.direction = _throw_dir;
        
		_thrown.speed = (_wall_in_front != noone) ? 0 : ((current_weapon == WEAPONS.KNIFE) ? 16 : 12);
        
		attack_delay = 0;
		is_turning = false;
		current_weapon = WEAPONS.UNARMED;
		my_sprites = scrPlayerGetWeaponSprite(character, current_weapon);
		sprite_index = my_sprites.walk; 
	}
	
	// ДЕЙСТВИЕ Б: ПОДБИРАЕМ НОВОЕ ОРУЖИЕ С ПОЛА
	if (_num > 0) 
	{
		var _best_weapon_instance = noone;
		var _hold_mouse4 = scrBindCheck("prefer_firearm");
		var _hold_mouse5 = scrBindCheck("prefer_melee");

		for (var i = 0; i < _num; i++) 
		{
			var _inst = _list[| i];
			if (_best_weapon_instance == noone) { _best_weapon_instance = _inst; continue; }
        
			if (_hold_mouse4) 
			{
				if (_inst.weapon_type == TYPE.RANGE && _best_weapon_instance.weapon_type != TYPE.RANGE) _best_weapon_instance = _inst;
			}
			else if (_hold_mouse5) 
			{
				if (_inst.weapon_type == TYPE.MELEE && _best_weapon_instance.weapon_type != TYPE.MELEE) _best_weapon_instance = _inst;
			}
			else 
			{
				if (_inst.depth > _best_weapon_instance.depth) _best_weapon_instance = _inst;
			}
		}

		if (instance_exists(_best_weapon_instance)) 
		{
			audio_play_sound(_best_weapon_instance.pickup_sound, 1, false);
			
			current_weapon = _best_weapon_instance.weapon;
			my_sprites = scrPlayerGetWeaponSprite(character, current_weapon);
			sprite_index = my_sprites.walk; 
			image_yscale = standart_y_scale;
			
			ammo = _best_weapon_instance.ammo;
			if (global.hard == true && _best_weapon_instance.isPlayerPickedUp == false) {
			ammo = ceil(_best_weapon_instance.ammo / 2);
			}
        
			instance_destroy(_best_weapon_instance);
		}
	}

	ds_list_destroy(_list);
}
