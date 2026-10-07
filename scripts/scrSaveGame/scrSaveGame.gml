// ==========================================
// ===          СОХРАНЕНИЕ ИГРЫ           ===
// ==========================================
function scrSaveGame()
{
	if (!instance_exists(objPlayer)) return;

	var _buf = buffer_create(1024, buffer_grow, 1);
	
	// === 1. СОХРАНЕНИЕ ДАННЫХ ИГРОКА ===
	with (objPlayer)
	{
		buffer_write(_buf, buffer_f16,  x);
		buffer_write(_buf, buffer_f16,  y);
		buffer_write(_buf, buffer_f16,  my_angle);
		buffer_write(_buf, buffer_f16,  walking_direction);
		buffer_write(_buf, buffer_u8,   character);
		buffer_write(_buf, buffer_u8,   current_weapon);
		buffer_write(_buf, buffer_bool, isRange_weapon);
		buffer_write(_buf, buffer_u16,  sprite_index); 
		buffer_write(_buf, buffer_u8,   ammo);
		buffer_write(_buf, buffer_u8,   max_energy);
		buffer_write(_buf, buffer_u8,   energy);
		buffer_write(_buf, buffer_f16,  hor_velocity);
		buffer_write(_buf, buffer_f16,  ver_velocity);
		
		// CОХРАНЕНИЕ СТАТИСТИКИ УРОВНЯ И КОМБО
		//buffer_write(_buf, buffer_u32,  global.level_time);
		buffer_write(_buf, buffer_u32,  global.total_score);
		buffer_write(_buf, buffer_u16,  global.enemies_killed);
		buffer_write(_buf, buffer_u16,  global.executions_count);
	
		buffer_write(_buf, buffer_u16,  global.combo_current);
		buffer_write(_buf, buffer_u16,  global.combo_max_level);
		buffer_write(_buf, buffer_f16,  global.combo_timer);
	}
	
	// === 2. СОХРАНЕНИЕ ВРАГОВ ===
	var _enemy_count = instance_number(objEnemy);
	buffer_write(_buf, buffer_u16, _enemy_count);
	
	with (objEnemy) 
	{
		// Позиция, графика, базовые свойства
		buffer_write(_buf, buffer_f16,  x);
		buffer_write(_buf, buffer_f16,  y);
		buffer_write(_buf, buffer_u16,  object_index);
		buffer_write(_buf, buffer_u16,  sprite_index);
		buffer_write(_buf, buffer_u8,   faction);
		buffer_write(_buf, buffer_u8,   class);
		buffer_write(_buf, buffer_u8,   skin);
		buffer_write(_buf, buffer_u8,   weapon);
		buffer_write(_buf, buffer_bool, isRange_weapon);
		
		// Состояния и ИИ таймеры
		buffer_write(_buf, buffer_u8,   state);
		buffer_write(_buf, buffer_u8,   move_type);
		buffer_write(_buf, buffer_u8,   reaction_time);
		buffer_write(_buf, buffer_u8,   backing_off_delay);
		
		// Движение, физика и углы
		buffer_write(_buf, buffer_f16,  target_speed);
		buffer_write(_buf, buffer_f16,  current_speed);
		buffer_write(_buf, buffer_f16,  my_angle);
		buffer_write(_buf, buffer_f16,  desired_angle);
		buffer_write(_buf, buffer_f16,  direction);
		
		// Анимация ног
		buffer_write(_buf, buffer_f16,  legs_direction);
		buffer_write(_buf, buffer_f16,  legs_image_index);
		
		// Боевая система
		buffer_write(_buf, buffer_u8,	ammo);
		buffer_write(_buf, buffer_u8,   reload);
		buffer_write(_buf, buffer_bool, start_shooting);
		
		// Зрение и фазы поиска (SEARCH STATE)
		buffer_write(_buf, buffer_u16,  search_timer);
		buffer_write(_buf, buffer_u8,   search_phase);
		buffer_write(_buf, buffer_f16,  last_seen_x);
		buffer_write(_buf, buffer_f16,  last_seen_y);
		buffer_write(_buf, buffer_f16,  safe_x);
		buffer_write(_buf, buffer_f16,  safe_y);
		
		// Поиск оружия (UNARMED SEARCH)
		buffer_write(_buf, buffer_u16,  weapon_search_timer);
		buffer_write(_buf, buffer_bool, can_see_weapon);
		buffer_write(_buf, buffer_u16,  try_get_weapon_timer);
		buffer_write(_buf, buffer_bool, hasTriedToGetWeapon);
		
		// Слух и шум (INVESTIGATE STATE)
		buffer_write(_buf, buffer_u8,   can_hear);
		buffer_write(_buf, buffer_f16,  noise_x);
		buffer_write(_buf, buffer_f16,  noise_y);
		
		// Свободные типы перемещений (RANDOM / PATROL)
		buffer_write(_buf, buffer_u16,  random_move_timer);
		buffer_write(_buf, buffer_f16,  random_dir);
		buffer_write(_buf, buffer_f16,  patrol_dir);
		
		// Стрейф, застревания и обход коллизий
		buffer_write(_buf, buffer_f16,  old_x);
		buffer_write(_buf, buffer_f16,  old_y);
		buffer_write(_buf, buffer_u16,  stuck_timer);
		buffer_write(_buf, buffer_s8,   strafe_dir); 
		buffer_write(_buf, buffer_u16,  strafe_change_timer);
		
		// Pathfinding (Встроенные переменные путей)
		buffer_write(_buf, buffer_f16,  path_position); 
		buffer_write(_buf, buffer_f16,  path_speed);
		buffer_write(_buf, buffer_u16,  searching_path_delay_timer);
		buffer_write(_buf, buffer_u16,  path_delay_timer);
		buffer_write(_buf, buffer_u8,   walk_on_trail);
		buffer_write(_buf, buffer_u8,   start_searching);
		
		// Боевые эффекты
		buffer_write(_buf, buffer_s16,  shell_ready_to_spawn); 
		
		// Определение индекса мишени
		var _target_type = 0;
		var _target_index = 0;
		
		if (my_target != noone && instance_exists(my_target))
		{
			if (my_target.object_index == objPlayer) 
			{
				_target_type = 1;
			}
			else if (my_target.object_index == objEnemy) 
			{
				_target_type = 2;
				for (var i = 0; i < _enemy_count; i++) 
				{
					if (instance_find(objEnemy, i) == my_target) 
					{
						_target_index = i;
						break;
					}
				}
			}
		}
		
		buffer_write(_buf, buffer_u8,  _target_type);
		buffer_write(_buf, buffer_u16, _target_index);
	}
	
	// === 3. СОХРАНЕНИЕ ТРУПОВ (objDeadBody) ===
	var _body_count = instance_number(objDeadBody);
	buffer_write(_buf, buffer_u16, _body_count);
	
	with (objDeadBody)
	{
		buffer_write(_buf, buffer_f16,  x);
		buffer_write(_buf, buffer_f16,  y);
		buffer_write(_buf, buffer_u16,  sprite_index);
		buffer_write(_buf, buffer_u8,   image_index);
		buffer_write(_buf, buffer_f16,  my_angle);
		buffer_write(_buf, buffer_f16,  speed);
		buffer_write(_buf, buffer_f16,  direction);
		buffer_write(_buf, buffer_u8,   create_blood_pool);
		buffer_write(_buf, buffer_bool, isExecuted);
		buffer_write(_buf, buffer_u8,   go_splat);
		buffer_write(_buf, buffer_u8,   hit_type);
		buffer_write(_buf, buffer_bool, isBleed);
		buffer_write(_buf, buffer_s32,  depth);
	}
	
	// === 4. СОХРАНЕНИЕ ОРУЖИЯ НА ПОЛУ СТРОГО ПО ТЕГУ "Weapon" ===
	var _tagged_objects = tag_get_asset_ids("Weapon", asset_object);
	var _total_weapons_count = 0;
	
	for (var i = 0; i < array_length(_tagged_objects); i++) 
	{
		_total_weapons_count += instance_number(_tagged_objects[i]);
	}
	
	buffer_write(_buf, buffer_u16, _total_weapons_count); 
	
	for (var i = 0; i < array_length(_tagged_objects); i++) 
	{
		var _obj_id = _tagged_objects[i];
		
		with (_obj_id)
		{
			buffer_write(_buf, buffer_f16, x);
			buffer_write(_buf, buffer_f16, y);
			buffer_write(_buf, buffer_u8,  image_index);
			buffer_write(_buf, buffer_f16, my_angle);
			buffer_write(_buf, buffer_u8,  weapon);
			buffer_write(_buf, buffer_u8,  weapon_type);
			buffer_write(_buf, buffer_s32, depth);
			buffer_write(_buf, buffer_u16, object_index); 
			buffer_write(_buf, buffer_u8,  ammo);
		}
	}
	
	// === 5. СКОРОСТНОЕ СОХРАНЕНИЕ ПОВЕРХНОСТИ КРОВИ БЕЗ СЖАТИЯ ===
	var _blood_file_name = room_get_name(room) + "_blood.dat";

	if (instance_exists(objBloodSurfaceManager) && surface_exists(global.surf_blood))
	{
		var _w = room_width * 2;
		var _h = room_height * 2;
		
		var _blood_buf = buffer_create(_w * _h * 4, buffer_fixed, 1);
		buffer_get_surface(_blood_buf, global.surf_blood, 0);
		buffer_save(_blood_buf, _blood_file_name);
		buffer_delete(_blood_buf);
	}
	else
	{
		if (file_exists(_blood_file_name)) { file_delete(_blood_file_name); }
	}
	
	// === 6. ДОБАВЛЕНО: СОХРАНЕНИЕ ИНТЕРАКТИВНЫХ ДВЕРЕЙ ===
	// Замени objWoodenDoor на имя твоего универсального объекта двери, если оно отличается
	var _door_count = instance_number(objWoodenDoor);
	buffer_write(_buf, buffer_u16, _door_count);
	
	with (objWoodenDoor)
	{
		buffer_write(_buf, buffer_f16, xstart);      
		buffer_write(_buf, buffer_f16, ystart);      
		buffer_write(_buf, buffer_f16, image_angle); 
		buffer_write(_buf, buffer_f16, swingspeed);  
		buffer_write(_buf, buffer_u8,  swinger); 
		buffer_write(_buf, buffer_f16, start_angle); // ИСПРАВЛЕНО: строго f16!
	}
	
	// Сохраняем всё на диск
	var _file_name = room_get_name(room) + ".dat";
	buffer_save(_buf, _file_name);
	buffer_delete(_buf);
}



// ==========================================
// ===           ЗАГРУЗКА ИГРЫ            ===
// ==========================================
function scrLoadGame(_is_room_transition)
{
	var _file_name = room_get_name(room) + ".dat";
	if (!file_exists(_file_name)) { return; }
	
	// Очищаем абсолютно все старые объекты уровня перед накатыванием сохранения
	global.is_cleaning_level = true; // Чтобы объект казни не спавнил поваленных
	
	with (objPlayerStart)			{ instance_destroy(); }
	with (objEnemy)					{ instance_destroy(); }
	with (objEnemyKnockedOut)		{ instance_destroy(); }
	with (objEnemyKnockedOutLean)	{ instance_destroy(); }
	with (objDeadBody)				{ instance_destroy(); } 
	with (objBloodPool)				{ instance_destroy(); } 
	with (objPlayerExecution)		{ instance_destroy(); }
	with (objBullet)				{ instance_destroy(); }
	with (objHeadSet)				{ instance_destroy(); }
	with (objWoodenDoor)			{ instance_destroy(); }
	
	// === ОБНОВЛЕНО: Чистим все пушки по их тегу "Weapon" ===
	var _tagged_objects = tag_get_asset_ids("Weapon", asset_object);
	for (var i = 0; i < array_length(_tagged_objects); i++) 
	{
		with (_tagged_objects[i]) { instance_destroy(); }
	}
	
	var _buf = buffer_load(_file_name);
	buffer_seek(_buf, buffer_seek_start, 0);
	
	// === ЧТЕНИЕ ДАННЫХ ИГРОКА ===
	var _p_x        = buffer_read(_buf, buffer_f16);
	var _p_y        = buffer_read(_buf, buffer_f16);
	var _p_angle    = buffer_read(_buf, buffer_f16);
	var _p_walk_dir = buffer_read(_buf, buffer_f16);
	var _p_char     = buffer_read(_buf, buffer_u8);
	var _p_weap     = buffer_read(_buf, buffer_u8);
	var _p_is_range = buffer_read(_buf, buffer_bool);
	var _p_sprite   = buffer_read(_buf, buffer_u16);
	var _p_ammo     = buffer_read(_buf, buffer_u8);
	var _p_max_en   = buffer_read(_buf, buffer_u8);
	var _p_energy   = buffer_read(_buf, buffer_u8);
	var _p_hor_vel  = buffer_read(_buf, buffer_f16);
	var _p_ver_vel  = buffer_read(_buf, buffer_f16);
	
	if (instance_exists(objPlayerDead)) { with (objPlayerDead) { instance_destroy(); instance_create_layer(_p_x, _p_y, "Instances", objPlayer); } }
	if (!instance_exists(objPlayer)) { instance_create_layer(_p_x, _p_y, "Instances", objPlayer); }
	
	with (objPlayer)
	{
		if (!_is_room_transition)
		{
			x                 = _p_x;
			y                 = _p_y;
			current_weapon    = _p_weap;
			isRange_weapon    = _p_is_range;
			sprite_index      = _p_sprite; 
			ammo              = _p_ammo;
			hor_velocity      = _p_hor_vel;
			ver_velocity      = _p_ver_vel;
		}
		
		my_angle          = _p_angle;
		walking_direction = _p_walk_dir;
		character         = _p_char;
		max_energy        = _p_max_en;
		energy            = _p_energy;
		
		// На основе загруженного оружия пересоздаем структуру my_sprites
		my_sprites         = scrPlayerGetWeaponSprite(character, current_weapon);
	}
	
	// ЧТЕНИЕ СТАТИСТИКИ УРОВНЯ И КОМБО
	//var _s_level_time   = buffer_read(_buf, buffer_u32);
	var _s_total_score  = buffer_read(_buf, buffer_u32);
	var _s_enemies      = buffer_read(_buf, buffer_u16);
	var _s_executions   = buffer_read(_buf, buffer_u16);
	
	var _s_combo_cur    = buffer_read(_buf, buffer_u16);
	var _s_combo_max    = buffer_read(_buf, buffer_u16);
	var _s_combo_timer  = buffer_read(_buf, buffer_f16);
	
	// Применяем сохраненную статистику ТОЛЬКО если это жесткий рестарт/загрузка
	if (!_is_room_transition)
	{
		//global.level_time       = _s_level_time;
		global.total_score      = _s_total_score;
		global.enemies_killed   = _s_enemies;
		global.executions_count = _s_executions;
		
		global.combo_current    = _s_combo_cur;
		global.combo_max_level  = _s_combo_max;
		global.combo_timer      = _s_combo_timer;
	}
	
	
	
	// === ЧТЕНИЕ ВРАГОВ ===
	var _enemy_count = buffer_read(_buf, buffer_u16);
	
	// Сначала очищаем старых живых врагов, чтобы избежать дубликатов
	with (objEnemy) { instance_destroy(); }
	
	for (var i = 0; i < _enemy_count; i++) 
	{
		// ИСПРАВЛЕНО: Минимальный остаток байт увеличен до 88, чтобы буфер не вылетал на расширенных переменных
		var _bytes_left = buffer_get_size(_buf) - buffer_tell(_buf);
		if (_bytes_left < 88) { break; }

		var _x  = buffer_read(_buf, buffer_f16);
		var _y  = buffer_read(_buf, buffer_f16);
		var _obj_index   = buffer_read(_buf, buffer_u16);
		
		var _en = instance_create_layer(_x, _y, "Instances", _obj_index);
		
		// Позиция, графика, базовые свойства
		_en.sprite_index      = buffer_read(_buf, buffer_u16);
		_en.faction           = buffer_read(_buf, buffer_u8);
		_en.class             = buffer_read(_buf, buffer_u8);
		_en.skin              = buffer_read(_buf, buffer_u8);
		_en.weapon            = buffer_read(_buf, buffer_u8);
		_en.isRange_weapon    = buffer_read(_buf, buffer_bool);
		
		// Состояния и ИИ таймеры
		_en.state             = buffer_read(_buf, buffer_u8);
		_en.move_type         = buffer_read(_buf, buffer_u8);
		_en.reaction_time     = buffer_read(_buf, buffer_u8);
		_en.backing_off_delay = buffer_read(_buf, buffer_u8); // Наш новый таймер размышлений
		
		// Движение, физика и углы
		_en.target_speed      = buffer_read(_buf, buffer_f16);
		_en.current_speed     = buffer_read(_buf, buffer_f16);
		_en.my_angle          = buffer_read(_buf, buffer_f16);
		_en.desired_angle     = buffer_read(_buf, buffer_f16);
		_en.direction         = buffer_read(_buf, buffer_f16);
		//_en.image_angle       = _en.my_angle; // Синхронизируем встроенный угол отрисовки
		
		// Анимация ног
		_en.legs_direction    = buffer_read(_buf, buffer_f16);
		_en.legs_image_index  = buffer_read(_buf, buffer_f16);
		
		// Боевая система
		_en.ammo			  = buffer_read(_buf, buffer_u8);
		_en.reload            = buffer_read(_buf, buffer_u8);
		_en.start_shooting    = buffer_read(_buf, buffer_bool);
		
		// Зрение и фазы поиска (SEARCH STATE)
		_en.search_timer      = buffer_read(_buf, buffer_u16);
		_en.search_phase      = buffer_read(_buf, buffer_u8);
		_en.last_seen_x       = buffer_read(_buf, buffer_f16);
		_en.last_seen_y       = buffer_read(_buf, buffer_f16);
		_en.safe_x            = buffer_read(_buf, buffer_f16);
		_en.safe_y            = buffer_read(_buf, buffer_f16);
		
		// Поиск оружия (UNARMED SEARCH)
		_en.weapon_search_timer  = buffer_read(_buf, buffer_u16);
		_en.can_see_weapon       = buffer_read(_buf, buffer_bool);
		_en.try_get_weapon_timer = buffer_read(_buf, buffer_u16);
		_en.hasTriedToGetWeapon  = buffer_read(_buf, buffer_bool);
		
		// Слух и шум (INVESTIGATE STATE)
		_en.can_hear          = buffer_read(_buf, buffer_u8);
		_en.noise_x           = buffer_read(_buf, buffer_f16);
		_en.noise_y           = buffer_read(_buf, buffer_f16);
		
		// Свободные типы перемещений (RANDOM / PATROL)
		_en.random_move_timer = buffer_read(_buf, buffer_u16);
		_en.random_dir        = buffer_read(_buf, buffer_f16);
		_en.patrol_dir        = buffer_read(_buf, buffer_f16);
		
		// Стрейф, застревания и обход коллизий
		_en.old_x             = buffer_read(_buf, buffer_f16);
		_en.old_y             = buffer_read(_buf, buffer_f16);
		_en.stuck_timer       = buffer_read(_buf, buffer_u16);
		_en.strafe_dir        = buffer_read(_buf, buffer_s8);
		_en.strafe_change_timer = buffer_read(_buf, buffer_u16);
		
		// Pathfinding (Временные переменные путей)
		_en._saved_path_pos            = buffer_read(_buf, buffer_f16);
		_en._saved_path_spd            = buffer_read(_buf, buffer_f16);
		_en.searching_path_delay_timer = buffer_read(_buf, buffer_u16);
		_en.path_delay_timer           = buffer_read(_buf, buffer_u16);
		_en.walk_on_trail              = buffer_read(_buf, buffer_u8);
		_en.start_searching            = buffer_read(_buf, buffer_u8);
		
		// Боевые эффекты
		_en.shell_ready_to_spawn       = buffer_read(_buf, buffer_s16);
		
		// Определение индекса мишени
		_en._saved_target_type  = buffer_read(_buf, buffer_u8);
		_en._saved_target_index = buffer_read(_buf, buffer_u16);
		
		// На ходу подтягиваем корректные структуры спрайтов из базы данных
		_en.my_sprites     = scrEnemyGetSprite(_en.skin, _en.weapon);
	}
	
	// =========================================================================
	// === УМНОЕ ВОССТАНОВЛЕНИЕ СВЯЗЕЙ И ЗАЩИТА ОТ САМОУБИЙСТВА ===
	// =========================================================================
	with (objEnemy)
	{
		if (!variable_instance_exists(id, "_saved_target_type")) continue;

		// 1. Если целью был Игрок — привязываем его честно (он один, индекс не перепутается)
		if (_saved_target_type == 1)      
		{
			my_target = instance_find(objPlayer, 0);
		}
		// 2. Если целью был другой враг — сбрасываем цель в noone, чтобы исключить суициды и стрельбу в стены
		else if (_saved_target_type == 2) 
		{
			my_target = noone;
			
			// Если враг сохранился прямо посреди удара или стрельбы по союзнику — гасим атаку
			if (state == STATES.ATTACKMELEE || state == STATES.ATTACKRANGE || state == STATES.CHASE || state == STATES.AFTERMATH)
			{
				state        = STATES.STEP;
				speed        = 0;
				path_end();
				sprite_index = my_sprites.sprites.walk;
				image_index  = 0;
			}
		}
		else                              
		{
			my_target = noone;
		}
		
		// 3. Восстановление путей (срабатывает только если цель жива и валидна)
		if (_saved_path_spd > 0 && my_target != noone) 
		{
			if (variable_global_exists("mp_grid") && mp_grid_path(global.mp_grid, my_path, x, y, last_seen_x, last_seen_y, true))
			{
				path_start(my_path, _saved_path_spd, path_action_stop, false);
				path_position = _saved_path_pos; 
			}
			else 
			{
				current_speed    = _saved_path_spd;
				path_delay_timer = 0;
			}
		}
	}
	
	
	// === ЧТЕНИЕ ТРУПОВ ===
	if (buffer_tell(_buf) < buffer_get_size(_buf))
	{
		var _body_count = buffer_read(_buf, buffer_u16);
		for (var b = 0; b < _body_count; b++)
		{
			var _b_x = buffer_read(_buf, buffer_f16);
			var _b_y = buffer_read(_buf, buffer_f16);
			
			var _body = instance_create_layer(_b_x, _b_y, "Instances", objDeadBody);
			_body.sprite_index      = buffer_read(_buf, buffer_u16);
			_body.image_index       = buffer_read(_buf, buffer_u8);
			_body.my_angle          = buffer_read(_buf, buffer_f16);
			_body.image_angle       = _body.my_angle;
			_body.speed             = buffer_read(_buf, buffer_f16);
			_body.direction         = buffer_read(_buf, buffer_f16);
			_body.create_blood_pool = buffer_read(_buf, buffer_u8);
			_body.isExecuted        = buffer_read(_buf, buffer_bool);
			_body.go_splat          = buffer_read(_buf, buffer_u8);
			_body.hit_type          = buffer_read(_buf, buffer_u8);
			_body.isBleed           = buffer_read(_buf, buffer_bool);
			_body.depth             = buffer_read(_buf, buffer_s32);
			_body.image_speed       = 0;
		}
		
		if (instance_exists(objDeadBody))
		{
			var _min_body_depth = 0;
			with (objDeadBody) 
			{ 
				if (depth < _min_body_depth) _min_body_depth = depth; 
			}
			global.body_render_counter = _min_body_depth;
		}
	}
	
	// === ОБНОВЛЕНО: ЧТЕНИЕ ОРУЖИЯ ПО НОВОЙ СИСТЕМЕ ТЕГОВ ===
	if (buffer_tell(_buf) < buffer_get_size(_buf))
	{
		var _weapon_count = buffer_read(_buf, buffer_u16);
		
		for (var w = 0; w < _weapon_count; w++)
		{
			var _w_x    = buffer_read(_buf, buffer_f16);
			var _w_y    = buffer_read(_buf, buffer_f16);
			var _w_img  = buffer_read(_buf, buffer_u8);
			var _w_ang  = buffer_read(_buf, buffer_f16);
			var _w_weap = buffer_read(_buf, buffer_u8); // Читаем в _w_weap
			var _w_type = buffer_read(_buf, buffer_u8);
			var _w_dpth = buffer_read(_buf, buffer_s32); 
			var _w_object_index = buffer_read(_buf, buffer_u16);
			var _w_ammo = buffer_read(_buf, buffer_u8);
			
			// Спавним нужный объект
			var _weap = instance_create_layer(_w_x, _w_y, "Instances", _w_object_index);
			
			_weap.image_index = _w_img;
			_weap.my_angle    = _w_ang;
			_weap.weapon      = _w_weap; // ИСПРАВЛЕНО: теперь _w_weap с подчёркиванием
			_weap.weapon_type = _w_type;
			_weap.depth       = _w_dpth; 
			_weap.ammo		  =	_w_ammo;
			
			// Сбрасываем физику
			_weap.speed       = 0;
			_weap.image_speed = 0;
			
			if (_w_object_index == objWeapon)
			{
				_weap.friction = 0.8;
			}
		}
		
		// === СИНХРОНИЗАЦИЯ СЧЕТЧИКА НАЛОЖЕНИЯ ОРУЖИЯ ===
		// Проверяем все объекты, имеющие тег Weapon, чтобы найти минимальную глубину
		var _min_weap_depth = 0;
		for (var i = 0; i < array_length(_tagged_objects); i++) 
		{
			with (_tagged_objects[i]) 
			{ 
				if (depth < _min_weap_depth) _min_weap_depth = depth; 
			}
		}
		global.weapon_render_counter = _min_weap_depth;
	}
	
	// === ЧТЕНИЕ И ВОССТАНОВЛЕНИЕ ДВЕРЕЙ ===
	if (buffer_tell(_buf) < buffer_get_size(_buf))
	{
		var _door_count = buffer_read(_buf, buffer_u16);
		
		for (var d = 0; d < _door_count; d++)
		{
			var _d_xstart  = buffer_read(_buf, buffer_f16);
			var _d_ystart  = buffer_read(_buf, buffer_f16);
			var _d_angle   = buffer_read(_buf, buffer_f16);
			var _d_speed   = buffer_read(_buf, buffer_f16);
			var _d_swinger = buffer_read(_buf, buffer_u8);
			var _d_start   = buffer_read(_buf, buffer_f16); // ИСПРАВЛЕНО: строго f16, байты теперь совпадают!
			
			// Создаем абсолютно чистую дверь на ее законном месте
			var _new_door = instance_create_layer(_d_xstart, _d_ystart, "Instances", objWoodenDoor);
			
			// Накатываем параметры физики
			_new_door.image_angle = _d_angle;
			_new_door.swingspeed  = _d_speed;
			_new_door.swinger     = _d_swinger;
			_new_door.start_angle = _d_start; // Теперь сюда со стопроцентной гарантией прилетит 270!
			
			// Фиксируем xstart/ystart
			_new_door.xstart = _d_xstart;
			_new_door.ystart = _d_ystart;
		}
	}
	
	buffer_delete(_buf); 
	
	// === ЗАГРУЗКА ПОВЕРХНОСТИ КРОВИ ===
	var _blood_file_name = room_get_name(room) + "_blood.dat";
	
	if (file_exists(_blood_file_name))
	{
		var _w = room_width * 2;
		var _h = room_height * 2;
		
		if (!instance_exists(objBloodSurfaceManager)) 
		{ 
			instance_create_layer(0, 0, "Blood_layer", objBloodSurfaceManager); 
		}
		
		if (surface_exists(global.surf_blood)) surface_free(global.surf_blood);
		global.surf_blood = surface_create(_w, _h);
		
		var _blood_buf = buffer_load(_blood_file_name);
		buffer_set_surface(_blood_buf, global.surf_blood, 0);
		buffer_delete(_blood_buf);
	}
	else
	{
		if (surface_exists(global.surf_blood))
		{
			surface_set_target(global.surf_blood);
			draw_clear_alpha(c_black, 0);
			surface_reset_target();
		}
	}
	
	global.is_cleaning_level = false;
}
