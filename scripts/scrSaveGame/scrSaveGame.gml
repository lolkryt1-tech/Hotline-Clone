// ==========================================
// ===          СОХРАНЕНИЕ ИГРЫ           ===
// ==========================================
function scrSaveGame()
{
	if (!instance_exists(objPlayer)) { return; }

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
	}
	
	// === 2. СОХРАНЕНИЕ ВРАГОВ ===
	var _enemy_count = instance_number(objEnemyColombian);
	buffer_write(_buf, buffer_u16, _enemy_count);
	
	with (objEnemyColombian) 
	{
		buffer_write(_buf, buffer_f16, x);
		buffer_write(_buf, buffer_f16, y);
		buffer_write(_buf, buffer_u16, sprite_index);
		buffer_write(_buf, buffer_u8,  faction);
		buffer_write(_buf, buffer_u8,  class);
		buffer_write(_buf, buffer_f16, my_angle);
		buffer_write(_buf, buffer_f16, direction);
		buffer_write(_buf, buffer_u8,  weapon);
		buffer_write(_buf, buffer_bool, isRange_weapon);
		buffer_write(_buf, buffer_u8,  reload);
		buffer_write(_buf, buffer_u8,  state);
		buffer_write(_buf, buffer_u8,  move_type);
		buffer_write(_buf, buffer_f16, last_seen_x);
		buffer_write(_buf, buffer_f16, last_seen_y);
		buffer_write(_buf, buffer_f16, path_position); 
		buffer_write(_buf, buffer_f16, path_speed);
		buffer_write(_buf, buffer_u16, searching_path_delay_timer);
		buffer_write(_buf, buffer_u16, path_delay_timer);
		buffer_write(_buf, buffer_u8,  start_searching);
		buffer_write(_buf, buffer_u8,  can_hear);
		
		var _target_type = 0;
		var _target_index = 0;
		
		if (my_target != noone && instance_exists(my_target))
		{
			if (my_target.object_index == objPlayer) 
			{
				_target_type = 1;
			}
			else if (my_target.object_index == objEnemyColombian) 
			{
				_target_type = 2;
				
				for (var i = 0; i < _enemy_count; i++) 
				{
					if (instance_find(objEnemyColombian, i) == my_target) 
					{
						_target_index = i;
						break;
					}
				}
			}
		}
		
		buffer_write(_buf, buffer_u8, _target_type);
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
		// Так как двери расставлены на уровне, сохраняем их стартовые координаты 
		// и текущее состояние физики
		buffer_write(_buf, buffer_f16, xstart);      
		buffer_write(_buf, buffer_f16, ystart);      
		buffer_write(_buf, buffer_f16, image_angle); 
		buffer_write(_buf, buffer_f16, swingspeed);  
		buffer_write(_buf, buffer_u8,  swinger); 
		buffer_write(_buf, buffer_u8,  start_angle);
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
	with (objEnemyColombian) { instance_destroy(); }
	with (objEnemyKnockedOut){ instance_destroy(); }
	with (objDeadBody)       { instance_destroy(); } 
	with (objBloodPool)      { instance_destroy(); } 
	with (objPlayerExecution){ instance_destroy(); }
	with (objBullet)		 { instance_destroy(); }
	with (objHeadSet)		 { instance_destroy(); }
	
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
		image_angle       = _p_angle;
		walking_direction = _p_walk_dir;
		character         = _p_char;
		max_energy        = _p_max_en;
		energy            = _p_energy;
		
		// На основе загруженного оружия пересоздаем структуру my_sprites
		my_sprites         = scrPlayerGetWeaponSprite(character, current_weapon);
	}
	
	// === ЧТЕНИЕ ВРАГОВ ===
	var _enemy_count = buffer_read(_buf, buffer_u16);
	
	for (var i = 0; i < _enemy_count; i++) 
	{
		// ИСПРАВЛЕНО: Увеличили минимальный остаток байт до 31, так как добавилась faction
		var _bytes_left = buffer_get_size(_buf) - buffer_tell(_buf);
		if (_bytes_left < 31) { break; }

		var _x  = buffer_read(_buf, buffer_f16);
		var _y  = buffer_read(_buf, buffer_f16);
		
		var _en = instance_create_layer(_x, _y, "Instances", objEnemyColombian);
		
		_en.sprite_index  = buffer_read(_buf, buffer_u16);
		_en.faction       = buffer_read(_buf, buffer_u8);
		_en.class         = buffer_read(_buf, buffer_u8);
		_en.my_angle      = buffer_read(_buf, buffer_f16);
		_en.image_angle   = _en.my_angle;
		_en.desired_angle = _en.my_angle;
		_en.direction     = buffer_read(_buf, buffer_f16);
		_en.weapon         = buffer_read(_buf, buffer_u8);
		_en.isRange_weapon = buffer_read(_buf, buffer_bool);
		_en.reload         = buffer_read(_buf, buffer_u8);
		_en.state          = buffer_read(_buf, buffer_u8);
		_en.move_type      = buffer_read(_buf, buffer_u8);
		_en.last_seen_x    = buffer_read(_buf, buffer_f16);
		_en.last_seen_y    = buffer_read(_buf, buffer_f16);
		
		_en._saved_path_pos            = buffer_read(_buf, buffer_f16);
		_en._saved_path_spd            = buffer_read(_buf, buffer_f16);
		_en.searching_path_delay_timer = buffer_read(_buf, buffer_u16);
		_en.path_delay_timer           = buffer_read(_buf, buffer_u16);
		_en.start_searching            = buffer_read(_buf, buffer_u8);
		_en.can_hear				   = buffer_read(_buf, buffer_u8);
		
		_en._saved_target_type  = buffer_read(_buf, buffer_u8);
		_en._saved_target_index = buffer_read(_buf, buffer_u16);
		
		_en.my_sprites     = scrEnemyGetSprite(_en.class, _en.weapon);
	}
	
	// === ИСПРАВЛЕНО: УМНОЕ ВОССТАНОВЛЕНИЕ СВЯЗЕЙ И ЗАЩИТА ОТ САМОУБИЙСТВА ===
	with (objEnemyColombian)
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
			
			// Спавним нужный объект
			var _weap = instance_create_layer(_w_x, _w_y, "Instances", _w_object_index);
			
			_weap.image_index = _w_img;
			_weap.my_angle    = _w_ang;
			_weap.weapon      = _w_weap; // ИСПРАВЛЕНО: теперь _w_weap с подчёркиванием
			_weap.weapon_type = _w_type;
			_weap.depth       = _w_dpth; 
			
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
	
	// === ЧТЕНИЕ И ВОССТАНОВЛЕНИЕ  ДВЕРЕЙ ===
	if (buffer_tell(_buf) < buffer_get_size(_buf))
	{
		var _door_count = buffer_read(_buf, buffer_u16);
		
		for (var d = 0; d < _door_count; d++)
		{
			var _d_xstart = buffer_read(_buf, buffer_f16);
			var _d_ystart = buffer_read(_buf, buffer_f16);
			var _d_angle  = buffer_read(_buf, buffer_f16);
			var _d_speed  = buffer_read(_buf, buffer_f16);
			var _d_swinger= buffer_read(_buf, buffer_u8);
			var _d_start  = buffer_read(_buf, buffer_u8);
			
			// Находим именно ту дверь, которая изначально стояла в этой точке
			var _door_inst = instance_position(_d_xstart, _d_ystart, objWoodenDoor);
			
			// Если дверь найдена на карте, возвращаем ей её физическое состояние
			if (_door_inst != noone)
			{
				_door_inst.image_angle = _d_angle;
				_door_inst.swingspeed  = _d_speed;
				_door_inst.swinger     = _d_swinger;
				_door_inst.start_angle = _d_start;
			}
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
}
