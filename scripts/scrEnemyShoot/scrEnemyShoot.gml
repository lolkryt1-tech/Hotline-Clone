/// @desc Физически спавнит пули/дробь врага, проигрывает звук и вычитает патрон
function scrEnemyShoot()
{
	// На всякий случай проверяем, задан ли объект пули
	if (my_sprites.bullet_obj == noone) return;

	sprite_index = my_sprites.sprites.attack;
	start_shooting = true; 

	// === 1. СПАВН ПУЛИ ИЛИ ДРОБИ ===
	var _bullet_x = x + lengthdir_x(4, my_angle) + lengthdir_x(2, my_angle - 90);
	var _bullet_y = y + lengthdir_y(4, my_angle) + lengthdir_y(2, my_angle - 90);

	if (weapon == WEAPONS.SHOTGUN)
	{
		repeat(6) 
		{
			var _pellet = instance_create_layer(_bullet_x, _bullet_y, "Instances", my_sprites.bullet_obj);
			_pellet.direction   = my_angle + random_range(-5, 5);
			_pellet.image_angle = _pellet.direction;
			_pellet.speed       = my_sprites.bullet_speed + random_range(-1, 1);
			_pellet.faction     = faction;
			_pellet.calibre     = my_sprites.bullet_calibre;
		}
	}
	else
	{
		var _bullet = instance_create_layer(_bullet_x, _bullet_y, "Instances", my_sprites.bullet_obj);
		_bullet.image_angle = my_angle;
		_bullet.direction   = my_angle;
		_bullet.speed       = my_sprites.bullet_speed; 
		_bullet.faction     = faction;
		_bullet.calibre     = my_sprites.bullet_calibre; 
	}
	
	// === 2. ВОСПРОИЗВЕДЕНИЕ ЗВУКА СТРЕЛЬБЫ ===
	if (array_length(my_sprites.sounds) > 0)
	{
		var _random_index = irandom(array_length(my_sprites.sounds) - 1);
		var _sound_to_play = my_sprites.sounds[_random_index];
		
		if (_sound_to_play != noone)
		{
			var _enemy_shot = audio_play_sound(_sound_to_play, 10, false);
			if (_enemy_shot != -1)
			{
				audio_sound_pitch(_enemy_shot, random_range(0.9, 1.1));
			}
		}
	}
	
	// === 3. ДИНАМИЧЕСКИЙ ТАЙМЕР ВЫЛЕТА ГИЛЬЗЫ ===
	if (my_sprites.shell_obj != noone)
	{
		shell_ready_to_spawn = (weapon == WEAPONS.SHOTGUN) ? 18 : 0;
	}
	
	// === 4. ЭФФЕКТЫ И СБРОС ТАЙМЕРОВ ===
	objEffector.shake = 0.4;          
	reload            = my_sprites.cooldown; 
	ammo--; // Вычитаем патрон
}
