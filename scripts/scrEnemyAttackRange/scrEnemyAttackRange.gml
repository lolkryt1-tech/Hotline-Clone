function scrEnemyAttackRange()
{
	if (!instance_exists(my_target)) 
	{ 
		speed = 0;
		path_end(); 
		state = STATES.STEP; 
		my_target = noone;
		reload = 20;
		start_shooting = false;
		exit; 
	}
	
	// 1. Проверяем видимость цели и дистанцию
	var clear_view = scrHasClearView(x, y, my_target.x, my_target.y);
	var _distance = point_distance(x, y, my_target.x, my_target.y);
	
	if (!clear_view || _distance > 400)
	{
		state = STATES.SEARCH;
		reload = 20; 
		start_shooting = false;
		exit;
	}
	
	// Заранее считаем направление на цель (пригодится и для стрейфа, и для прицеливания)
	var _pdir = point_direction(x, y, my_target.x, my_target.y);
	var _need_pathfinding = false;
	
	// 2. Логика движения и поиска пути
	if (!scrCanShoot())
	{
		// Если боковые лучи задевают стены — нам точно нужен поиск пути
		_need_pathfinding = true;
	}
	else if (_distance > my_sprites.attack_range)
	{
		if (scrCanGoStraight())
		{
			path_end();
			path_delay_timer = 0;
			target_speed = max_speed; 
			move_towards_point(my_target.x, my_target.y, current_speed);
		}
		else
		{
			// Прямой путь заблокирован — нужен поиск пути
			_need_pathfinding = true;
		}
	}
	else
	{
		path_end();	
		speed = 0;
		scrEnemyBackingOff();
	}
	
	// Убран дублирующийся код: запускаем pathfinding и стрейф в одном месте
	if (_need_pathfinding)
	{
		scrEnemyPathfinding(true, my_target.x, my_target.y);
		speed = 0;
		
		if (path_index == -1) 
		{
			scrEnemyStrafeMovement(_pdir, target_speed);
		}
	}
	
	// Крутим кадры анимации
	if (sprite_index == my_sprites.sprites.attack) 
	{ 
		image_index += my_sprites.anim_speed; 
	}
	
	// 3. Прицеливание и таймеры
	reload--;
	desired_angle = _pdir; // Используем посчитанный выше _pdir
	
	if (start_shooting) { my_angle = desired_angle; }

	var _diff = angle_difference(my_angle, _pdir);
	
	// Враг выстрелит, если наведен и reload <= 0
	if (abs(_diff) > 30 || reload > 0) return;
	
	// === 4. ФАЗА СТРУКТУРНОЙ СТРЕЛЬБЫ ===
	sprite_index = my_sprites.sprites.attack;
	if (my_sprites.bullet_obj == noone) return;

	start_shooting = true; 

	// === 4.1. СПАВН ПУЛИ И ЗВУК ВЫСТРЕЛA ===
	var _bullet_x = x + lengthdir_x(4, my_angle) + lengthdir_x(2, my_angle - 90);
	var _bullet_y = y + lengthdir_y(4, my_angle) + lengthdir_y(2, my_angle - 90);

	if (weapon == WEAPONS.SHOTGUN)
	{
		repeat(6) 
		{
			var _pellet = instance_create_layer(_bullet_x, _bullet_y, "Instances", my_sprites.bullet_obj);
			_pellet.direction   = my_angle + random_range(-8, 8);
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
	
	if (variable_struct_exists(my_sprites, "sounds") && array_length(my_sprites.sounds) > 0)
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
	
	// === 4.2. ДИНАМИЧЕСКИЙ ТАЙМЕР ВЫЛЕТА ГИЛЬЗЫ ВРАГА ===
	if (my_sprites.shell_obj != noone)
	{
		if (weapon == WEAPONS.SHOTGUN)
		{
			shell_ready_to_spawn = 18; 
		}
		else
		{
			shell_ready_to_spawn = 0;  
		}
	}
	
	// === 4.3. ЭФФЕКТЫ И СБРОС ТАЙМЕРА ===
	objEffector.shake = 0.4;          
	reload            = my_sprites.cooldown; 
}
