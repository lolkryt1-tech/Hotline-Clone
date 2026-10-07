function scrEnemyAttackRange()
{
	if (!instance_exists(my_target)) 
	{ 
		path_end(); 
		state = STATES.STEP; 
		my_target = noone;
		reload = max(reload, 20);
		start_shooting = false;
		exit; 
	}
	
	last_seen_x = my_target.x;
	last_seen_y = my_target.y;
	
	// Для правильной отрисовки ног
	direction = my_angle;
	
	// 1. Проверяем видимость цели и максимальную дистанцию потери
	var clear_view = scrHasClearView(x, y, my_target.x, my_target.y);
	var _distance = point_distance(x, y, my_target.x, my_target.y);
	
	if (!clear_view || _distance > 400)
	{
		state = STATES.SEARCH;
		reload = max(reload, 20);
		start_shooting = false;
		target_speed = max_speed;
		exit;
	}
	
	// Заранее считаем направление на цель
	var _pdir = point_direction(x, y, my_target.x, my_target.y);
	var _need_pathfinding = false;
	
	// =========================================================================
	// 2. ИЕРАРХИЯ ЛОГИКИ ДВИЖЕНИЯ (ПРИОРИТЕТЫ)
	// =========================================================================
	
	// ПРИОРИТЕТ 1: Игрок подошел вплотную И враг уже начал вести огонь (Отступление)
	if (_distance < 48 && start_shooting)
	{
		path_end();
		scrEnemyBackingOff();
		
		if (!scrCanShoot()) 
		{
			_need_pathfinding = true;
		}
	}
	// ПРИОРИТЕТ 2: Боковые лучи задевают стены — ищем более свободную позицию близко к игроку
	else if (!scrCanShoot())
	{
		_need_pathfinding = true;
	}
	// ПРИОРИТЕТ 3: Игрок находится дальше нашей дистанции атаки — сближаемся ТОЛЬКО по прямой
	else if (_distance > my_sprites.attack_range)
	{
		// Глушим старые пути на больших дистанциях в любом случае
		path_end();
		path_delay_timer = 0;

		if (scrCanGoStraight())
		{
			target_speed = max_speed; 
			
			// Плавное скольжение к игроку по вектору через move_and_collide
			var _vel_x = lengthdir_x(current_speed, _pdir);
			var _vel_y = lengthdir_y(current_speed, _pdir);
			
			move_and_collide(_vel_x, _vel_y, objSolid);
		}
		else
		{
			// ИСПРАВЛЕНО: Прямой путь заблокирован и расстояние большое — патфайдинг НЕ вызываем.
			// Враг просто стоит на месте, никуда не идет и продолжает вести огонь.
			target_speed = 0;
			speed = 0;
		}
	}
	// ПРИОРИТЕТ 4: Мы на отличной позиции, нужной дистанции и бока свободны — стоим на месте
	else
	{
		path_end();	
		target_speed = 0;
		speed = 0;
	}
	
	// ВЫПОЛНЕНИЕ ПАТФАЙДИНГА (Срабатывает СТРОГО для Приоритетов 1 и 2, когда игрок близко)
	if (_need_pathfinding)
	{
		scrEnemyPathfinding(true, my_target.x, my_target.y);
		speed = 0;
		
		if (path_index == -1) 
		{
			scrEnemyStrafeMovement(_pdir, target_speed);
		}
	}
	
	// =========================================================================
	// 3. ПРИЦЕЛИВАНИЕ И АНИМАЦИЯ
	// =========================================================================
	
	// Крутим кадры анимации, если включен спрайт атаки
	if (sprite_index == my_sprites.sprites.attack) 
	{ 
		image_index += my_sprites.anim_speed; 
	}
	
	reload--;
	desired_angle = _pdir; 
	
	// УДАЛЕНО: if (reload <= 5) { my_angle = desired_angle; } 
	
	// ХОРОШИЙ ДОВОРОТ: Динамически рассчитываем скорость вращения
	// Если первый выстрел уже сделан (start_shooting = true), враг крутится к игроку ЖЕСТКО и быстро (0.45)
	// Если он только сводится перед первым выстрелом — поворот плавный и стандартный (0.15)
	var _current_rot_speed = (start_shooting) ? 0.45 : 0.15;
	
	// Плавно, но честно докручиваем угол к направлению на цель
	my_angle += angle_difference(desired_angle, my_angle) * _current_rot_speed;

	var _diff = angle_difference(my_angle, _pdir);
	
	// РАННИЙ ВЫХОД: Если еще не навелись или пушка остывает — мгновенно выходим
	if (abs(_diff) > 30 || reload > 0) return;
	
	// === ПРОВЕРКА ПУСТОГО МАГАЗИНА У ВРАГА ===
	if (ammo <= 0)
	{
		audio_play_sound(sndDryClick, 10, false); 
		empty_clicks_count++;
		reload = 25;
		
		if (empty_clicks_count >= empty_clicks_target)
		{
			var _dropped = instance_create_layer(x, y, "Instances", objWeaponUnreachable);
			_dropped.image_index = scrWeaponGetImage(weapon);
			_dropped.weapon    = weapon;
			_dropped.ammo	   = 0;
			_dropped.my_angle  = irandom(360);
			_dropped.direction = irandom(360); 
			_dropped.speed     = 5;
			
			weapon             = WEAPONS.UNARMED;
			isRange_weapon     = false;
			start_shooting     = false;
			empty_clicks_count = 0;
			
			if (class == CLASS.DODGER)
			{
				weapon		 = WEAPONS.KNIFE;
				my_sprites   = scrEnemyGetSprite(skin, weapon);
				sprite_index = my_sprites.sprites.walk; 
				audio_play_sound(sndDrawKnife, 1, false);
				state        = STATES.CHASE;
			}
			else
			{
				state        = STATES.UNARMEDSEARCH;
				my_sprites   = scrEnemyGetSprite(skin, weapon);
				sprite_index = my_sprites.sprites.walk;
			}
			
			exit;
		}
		return; 
	}
	
	// =========================================================================
	// 4. НЕПОСРЕДСТВЕННО СТРЕЛЬБА
	// =========================================================================
	scrEnemyShoot();
}
