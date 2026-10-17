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
		buffer_write(_buf, buffer_f16,  hor_velocity);
		buffer_write(_buf, buffer_f16,  ver_velocity);
		
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
		buffer_write(_buf, buffer_u32,  enemy_uid);
		buffer_write(_buf, buffer_f16,  x);
		buffer_write(_buf, buffer_f16,  y);
		buffer_write(_buf, buffer_u16,  object_index);
		buffer_write(_buf, buffer_u16,  sprite_index);
		buffer_write(_buf, buffer_u8,   faction);
		buffer_write(_buf, buffer_u8,   class);
		buffer_write(_buf, buffer_u8,   skin);
		buffer_write(_buf, buffer_u8,   weapon);
		buffer_write(_buf, buffer_bool, isRange_weapon);
		
		buffer_write(_buf, buffer_u8,   state);
		buffer_write(_buf, buffer_u8,   move_type);
		buffer_write(_buf, buffer_u8,   reaction_time);
		buffer_write(_buf, buffer_u8,   backing_off_delay);
		
		buffer_write(_buf, buffer_f16,  target_speed);
		buffer_write(_buf, buffer_f16,  current_speed);
		buffer_write(_buf, buffer_f16,  my_angle);
		buffer_write(_buf, buffer_f16,  desired_angle);
		buffer_write(_buf, buffer_f16,  direction);
		
		buffer_write(_buf, buffer_f16,  legs_direction);
		buffer_write(_buf, buffer_f16,  legs_image_index);
		
		buffer_write(_buf, buffer_u8,	ammo);
		buffer_write(_buf, buffer_u8,   reload);
		buffer_write(_buf, buffer_bool, start_shooting);
		
		buffer_write(_buf, buffer_u16,  search_timer);
		buffer_write(_buf, buffer_u8,   search_phase);
		buffer_write(_buf, buffer_f16,  last_seen_x);
		buffer_write(_buf, buffer_f16,  last_seen_y);
		buffer_write(_buf, buffer_f16,  safe_x);
		buffer_write(_buf, buffer_f16,  safe_y);
		
		buffer_write(_buf, buffer_u16,  weapon_search_timer);
		buffer_write(_buf, buffer_bool, can_see_weapon);
		buffer_write(_buf, buffer_u16,  try_get_weapon_timer);
		buffer_write(_buf, buffer_bool, hasTriedToGetWeapon);
		
		buffer_write(_buf, buffer_u8,   can_hear);
		buffer_write(_buf, buffer_f16,  noise_x);
		buffer_write(_buf, buffer_f16,  noise_y);
		
		buffer_write(_buf, buffer_u16,  random_move_timer);
		buffer_write(_buf, buffer_f16,  random_dir);
		buffer_write(_buf, buffer_f16,  patrol_dir);
		
		buffer_write(_buf, buffer_f16,  old_x);
		buffer_write(_buf, buffer_f16,  old_y);
		buffer_write(_buf, buffer_u16,  stuck_timer);
		buffer_write(_buf, buffer_s8,   strafe_dir); 
		buffer_write(_buf, buffer_u16,  strafe_change_timer);
		
		buffer_write(_buf, buffer_f16,  path_position); 
		buffer_write(_buf, buffer_f16,  path_speed);
		buffer_write(_buf, buffer_u16,  searching_path_delay_timer);
		buffer_write(_buf, buffer_u16,  path_delay_timer);
		buffer_write(_buf, buffer_u8,   walk_on_trail);
		buffer_write(_buf, buffer_u8,   start_searching);
		
		buffer_write(_buf, buffer_s16,  shell_ready_to_spawn); 
		
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
	
	// === 3.5. СОХРАНЕНИЕ ЛУЖ КРОВИ (objBloodPool) ===
	var _blood_pool_count = instance_number(objBloodPool);
	buffer_write(_buf, buffer_u16, _blood_pool_count);
	
	with (objBloodPool)
	{
		buffer_write(_buf, buffer_f16,  x);
		buffer_write(_buf, buffer_f16,  y);
		buffer_write(_buf, buffer_u8,   image_index);
		buffer_write(_buf, buffer_f16,  image_angle);
		buffer_write(_buf, buffer_f16,  image_xscale);
		buffer_write(_buf, buffer_f16,  image_yscale);
	}
	
	// === 4. СОХРАНЕНИЕ ОРУЖИЯ НА ПОЛУ ===
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
	
	// === 5. СОХРАНЕНИЕ ПОВЕРХНОСТИ КРОВИ ===
	var _blood_file_name = scrGetBloodFileName();

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
	
	// === 6. СОХРАНЕНИЕ ДВЕРЕЙ ===
	var _door_count = instance_number(objDoor);
	buffer_write(_buf, buffer_u16, _door_count);
	
	with (objDoor)
	{
		buffer_write(_buf, buffer_u16, object_index);
		buffer_write(_buf, buffer_u32, uid);
		buffer_write(_buf, buffer_f16, xstart);      
		buffer_write(_buf, buffer_f16, ystart);      
		buffer_write(_buf, buffer_f16, image_angle); 
		buffer_write(_buf, buffer_f16, swingspeed);  
		buffer_write(_buf, buffer_u8,  swinger); 
		buffer_write(_buf, buffer_f16, start_angle);
		buffer_write(_buf, buffer_bool, closed);
	}
	
	// === 7. СОХРАНЕНИЕ ТЬМЫ (objDarkness) ===
	var _darkness_count = instance_number(objDarkness);
	buffer_write(_buf, buffer_u16, _darkness_count);
	
	with (objDarkness)
	{
		buffer_write(_buf, buffer_u16, object_index);
		buffer_write(_buf, buffer_u32, uid);
		buffer_write(_buf, buffer_f16, x);
		buffer_write(_buf, buffer_f16, y);
		buffer_write(_buf, buffer_f16, image_alpha);
		buffer_write(_buf, buffer_f16, image_angle);
		buffer_write(_buf, buffer_f16, image_xscale);
		buffer_write(_buf, buffer_f16, image_yscale);
		buffer_write(_buf, buffer_bool, fade_out);
		buffer_write(_buf, buffer_bool, fade_in);
	}
	
	// === 8. СОХРАНЕНИЕ ОКОН (objWindow) ===
	var _window_count = instance_number(objWindow);
	buffer_write(_buf, buffer_u16, _window_count);
	
	with (objWindow)
	{
		buffer_write(_buf, buffer_u16, object_index);
		buffer_write(_buf, buffer_f16, x);
		buffer_write(_buf, buffer_f16, y);
		buffer_write(_buf, buffer_u8,  image_index);
	}
	
		// === 9. СОХРАНЕНИЕ ТЕЛЕВИЗОРОВ (objTV) ===
	var _tv_count = instance_number(objTV);
	buffer_write(_buf, buffer_u16, _tv_count);
	
	with (objTV)
	{
		buffer_write(_buf, buffer_f16, x);
		buffer_write(_buf, buffer_f16, y);
		buffer_write(_buf, buffer_u16, sprite_index);
		buffer_write(_buf, buffer_f16, image_angle);
		buffer_write(_buf, buffer_f16, image_speed);
		buffer_write(_buf, buffer_u8,  energie);
		buffer_write(_buf, buffer_u8,  life);
	}
	
	// === 10. СОХРАНЕНИЕ КАЛЬЯНОВ (objHookah) ===
	var _hookah_count = instance_number(objHookah);
	buffer_write(_buf, buffer_u16, _hookah_count);

	with (objHookah)
	{
	    buffer_write(_buf, buffer_f16, x);
	    buffer_write(_buf, buffer_f16, y);
	    buffer_write(_buf, buffer_u8,  image_index);
	}
	
	// === 11. СОХРАНЕНИЕ СТРЕЛКИ ПЕРЕХОДА (objFloorTranslator) ===
	var _translator_count = instance_number(objFloorTranslator);
	buffer_write(_buf, buffer_u16, _translator_count); // Сначала пишем количество!

	with (objFloorTranslator)
	{
	    // Записываем координаты, чтобы найти ИМЕННО ЭТОТ объект при загрузке
	    buffer_write(_buf, buffer_f16, x);
	    buffer_write(_buf, buffer_f16, y);
		
	    buffer_write(_buf, buffer_u16, uid);            // Целое число (ID)
	    buffer_write(_buf, buffer_u16,  trigger_unlock); // Булево (0 или 1)
	}
	
	
	// === 12. СОХРАНЕНИЕ ТРИГГЕРОВ ВХОДА (objTriggerEnter) ===
	var _trigger_enter_count = instance_number(objTriggerEnter);
	buffer_write(_buf, buffer_u16, _trigger_enter_count);
	
	with (objTriggerEnter)
	{
		buffer_write(_buf, buffer_u32,  trigger_id);
		buffer_write(_buf, buffer_bool, is_triggered);
		
		buffer_write(_buf, buffer_u16,  spawn_object);
		buffer_write(_buf, buffer_u8,   spawn_skin);
		buffer_write(_buf, buffer_u8,   spawn_class);
		buffer_write(_buf, buffer_u8,   spawn_weapon);
		buffer_write(_buf, buffer_u8,   spawn_ammo);
		buffer_write(_buf, buffer_u8,   spawn_state);
		
		buffer_write(_buf, buffer_f16,  spawn_x);
		buffer_write(_buf, buffer_f16,  spawn_y);
		buffer_write(_buf, buffer_f16,  target_x);
		buffer_write(_buf, buffer_f16,  target_y);
	}
	
	// === 13. СОХРАНЕНИЕ ТРИГГЕРОВ СОБЫТИЙ (objTriggerAction) ===
	var _trigger_action_count = instance_number(objTriggerAction);
	buffer_write(_buf, buffer_u16, _trigger_action_count);
	
	with (objTriggerAction)
	{
		buffer_write(_buf, buffer_u32,  trigger_id);
		buffer_write(_buf, buffer_bool, is_triggered);
	}
	
	var _file_name = scrGetSaveFileName();
	buffer_save(_buf, _file_name);
	buffer_delete(_buf);
}


// ==========================================
// ===           ЗАГРУЗКА ИГРЫ            ===
// ==========================================
function scrLoadGame(_is_room_transition)
{
	var _file_name = scrGetSaveFileName();
	if (!file_exists(_file_name)) { return; }
	
	global.is_cleaning_level = true;
	
	with (objPlayerStart)			{ instance_destroy(); }
	with (objEnemy)					{ instance_destroy(); }
	with (objEnemyKnockedOut)		{ instance_destroy(); }
	with (objEnemyKnockedOutLean)	{ instance_destroy(); }
	with (objEnemyHurtBox)			{ instance_destroy(); }
	with (objDeadBody)				{ instance_destroy(); } 
	with (objBloodPool)				{ instance_destroy(); } 
	with (objPlayerExecution)		{ instance_destroy(); }
	with (objBullet)				{ instance_destroy(); }
	with (objHeadSet)				{ instance_destroy(); }
	with (objDoor)					{ instance_destroy(); }
	with (objDarkness)				{ instance_destroy(); }
	with (objDecals)				{ instance_destroy(); }
	with (objEffect)				{ instance_destroy(); }
	with (objHookah)				{ instance_destroy(); }
	with (objTV)					{ instance_destroy(); }
	
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
		
		max_energy = choose(1, 2);
		energy     = max_energy;
		
		my_sprites         = scrPlayerGetWeaponSprite(character, current_weapon);
	}
	
	// === ЧТЕНИЕ СТАТИСТИКИ ===
	var _s_total_score  = buffer_read(_buf, buffer_u32);
	var _s_enemies      = buffer_read(_buf, buffer_u16);
	var _s_executions   = buffer_read(_buf, buffer_u16);
	
	var _s_combo_cur    = buffer_read(_buf, buffer_u16);
	var _s_combo_max    = buffer_read(_buf, buffer_u16);
	var _s_combo_timer  = buffer_read(_buf, buffer_f16);
	
	if (!_is_room_transition)
	{
		global.total_score      = _s_total_score;
		global.enemies_killed   = _s_enemies;
		global.executions_count = _s_executions;
		
		global.combo_current    = _s_combo_cur;
		global.combo_max_level  = _s_combo_max;
		global.combo_timer      = _s_combo_timer;
	}
	
	// === ЧТЕНИЕ ВРАГОВ ===
	var _enemy_count = buffer_read(_buf, buffer_u16);
	
	with (objEnemy) { instance_destroy(); }
	
	for (var i = 0; i < _enemy_count; i++) 
	{
		var _bytes_left = buffer_get_size(_buf) - buffer_tell(_buf);
		if (_bytes_left < 92) { break; }

		var _uid = buffer_read(_buf, buffer_u32);
		
		var _x  = buffer_read(_buf, buffer_f16);
		var _y  = buffer_read(_buf, buffer_f16);
		var _obj_index   = buffer_read(_buf, buffer_u16);
		
		var _en = instance_create_layer(_x, _y, "Instances", _obj_index);
		_en.enemy_uid = _uid;
		
		_en.sprite_index      = buffer_read(_buf, buffer_u16);
		_en.faction           = buffer_read(_buf, buffer_u8);
		_en.class             = buffer_read(_buf, buffer_u8);
		_en.skin              = buffer_read(_buf, buffer_u8);
		_en.weapon            = buffer_read(_buf, buffer_u8);
		_en.isRange_weapon    = buffer_read(_buf, buffer_bool);
		
		_en.state             = buffer_read(_buf, buffer_u8);
		_en.move_type         = buffer_read(_buf, buffer_u8);
		_en.reaction_time     = buffer_read(_buf, buffer_u8);
		_en.backing_off_delay = buffer_read(_buf, buffer_u8);
		
		_en.target_speed      = buffer_read(_buf, buffer_f16);
		_en.current_speed     = buffer_read(_buf, buffer_f16);
		_en.my_angle          = buffer_read(_buf, buffer_f16);
		_en.desired_angle     = buffer_read(_buf, buffer_f16);
		_en.direction         = buffer_read(_buf, buffer_f16);
		
		_en.legs_direction    = buffer_read(_buf, buffer_f16);
		_en.legs_image_index  = buffer_read(_buf, buffer_f16);
		
		_en.ammo			  = buffer_read(_buf, buffer_u8);
		_en.reload            = buffer_read(_buf, buffer_u8);
		_en.start_shooting    = buffer_read(_buf, buffer_bool);
		
		_en.search_timer      = buffer_read(_buf, buffer_u16);
		_en.search_phase      = buffer_read(_buf, buffer_u8);
		_en.last_seen_x       = buffer_read(_buf, buffer_f16);
		_en.last_seen_y       = buffer_read(_buf, buffer_f16);
		_en.safe_x            = buffer_read(_buf, buffer_f16);
		_en.safe_y            = buffer_read(_buf, buffer_f16);
		
		_en.weapon_search_timer  = buffer_read(_buf, buffer_u16);
		_en.can_see_weapon       = buffer_read(_buf, buffer_bool);
		_en.try_get_weapon_timer = buffer_read(_buf, buffer_u16);
		_en.hasTriedToGetWeapon  = buffer_read(_buf, buffer_bool);
		
		_en.can_hear          = buffer_read(_buf, buffer_u8);
		_en.noise_x           = buffer_read(_buf, buffer_f16);
		_en.noise_y           = buffer_read(_buf, buffer_f16);
		
		_en.random_move_timer = buffer_read(_buf, buffer_u16);
		_en.random_dir        = buffer_read(_buf, buffer_f16);
		_en.patrol_dir        = buffer_read(_buf, buffer_f16);
		
		_en.old_x             = buffer_read(_buf, buffer_f16);
		_en.old_y             = buffer_read(_buf, buffer_f16);
		_en.stuck_timer       = buffer_read(_buf, buffer_u16);
		_en.strafe_dir        = buffer_read(_buf, buffer_s8);
		_en.strafe_change_timer = buffer_read(_buf, buffer_u16);
		
		_en._saved_path_pos            = buffer_read(_buf, buffer_f16);
		_en._saved_path_spd            = buffer_read(_buf, buffer_f16);
		_en.searching_path_delay_timer = buffer_read(_buf, buffer_u16);
		_en.path_delay_timer           = buffer_read(_buf, buffer_u16);
		_en.walk_on_trail              = buffer_read(_buf, buffer_u8);
		_en.start_searching            = buffer_read(_buf, buffer_u8);
		
		_en.shell_ready_to_spawn       = buffer_read(_buf, buffer_s16);
		
		_en._saved_target_type  = buffer_read(_buf, buffer_u8);
		_en._saved_target_index = buffer_read(_buf, buffer_u16);
		
		_en.my_sprites     = scrEnemyGetSprite(_en.skin, _en.weapon);
	}
	
	// === ВОССТАНОВЛЕНИЕ СВЯЗЕЙ ВРАГОВ ===
	with (objEnemy)
	{
		if (!variable_instance_exists(id, "_saved_target_type")) continue;

		if (_saved_target_type == 1)      
		{
			my_target = instance_find(objPlayer, 0);
		}
		else if (_saved_target_type == 2) 
		{
			my_target = noone;
			
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
	
	// === ЧТЕНИЕ ЛУЖ КРОВИ (objBloodPool) ===
	if (buffer_tell(_buf) < buffer_get_size(_buf))
	{
		var _blood_pool_count = buffer_read(_buf, buffer_u16);
		
		for (var bp = 0; bp < _blood_pool_count; bp++)
		{
			var _bp_x     = buffer_read(_buf, buffer_f16);
			var _bp_y     = buffer_read(_buf, buffer_f16);
			var _bp_img   = buffer_read(_buf, buffer_u8);
			var _bp_angle = buffer_read(_buf, buffer_f16);
			var _bp_xs    = buffer_read(_buf, buffer_f16);
			var _bp_ys    = buffer_read(_buf, buffer_f16);
			
			var _new_bp = instance_create_layer(_bp_x, _bp_y, "Instances", objBloodPool);
			
			_new_bp.image_index   = _bp_img;
			_new_bp.image_angle   = _bp_angle;
			_new_bp.image_xscale  = _bp_xs;
			_new_bp.image_yscale  = _bp_ys;
			
			// При воспроизведении лужи крови — сразу перематываем на последний кадр
			_new_bp.image_index   = _new_bp.image_number - 1;
		}
	}
	
	// === ЧТЕНИЕ ОРУЖИЯ ===
	if (buffer_tell(_buf) < buffer_get_size(_buf))
	{
		var _weapon_count = buffer_read(_buf, buffer_u16);
		
		for (var w = 0; w < _weapon_count; w++)
		{
			var _w_x    = buffer_read(_buf, buffer_f16);
			var _w_y    = buffer_read(_buf, buffer_f16);
			var _w_img  = buffer_read(_buf, buffer_u8);
			var _w_ang  = buffer_read(_buf, buffer_f16);
			var _w_weap = buffer_read(_buf, buffer_u8);
			var _w_type = buffer_read(_buf, buffer_u8);
			var _w_dpth = buffer_read(_buf, buffer_s32); 
			var _w_object_index = buffer_read(_buf, buffer_u16);
			var _w_ammo = buffer_read(_buf, buffer_u8);
			
			var _weap = instance_create_layer(_w_x, _w_y, "Instances", _w_object_index);
			
			_weap.image_index = _w_img;
			_weap.my_angle    = _w_ang;
			_weap.weapon      = _w_weap;
			_weap.weapon_type = _w_type;
			_weap.depth       = _w_dpth; 
			_weap.ammo		  =	_w_ammo;
			
			_weap.speed       = 0;
			_weap.image_speed = 0;
			
			if (_w_object_index == objWeapon)
			{
				_weap.friction = 0.8;
			}
		}
		
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
	
	// === ЧТЕНИЕ ДВЕРЕЙ ===
	if (buffer_tell(_buf) < buffer_get_size(_buf))
	{
		var _door_count = buffer_read(_buf, buffer_u16);
		
		for (var d = 0; d < _door_count; d++)
		{
			var _d_obj      = buffer_read(_buf, buffer_u16);
			var _d_uid      = buffer_read(_buf, buffer_u32);
			var _d_xstart   = buffer_read(_buf, buffer_f16);
			var _d_ystart   = buffer_read(_buf, buffer_f16);
			var _d_angle    = buffer_read(_buf, buffer_f16);
			var _d_speed    = buffer_read(_buf, buffer_f16);
			var _d_swinger  = buffer_read(_buf, buffer_u8);
			var _d_start    = buffer_read(_buf, buffer_f16);
			var _d_closed   = buffer_read(_buf, buffer_bool);
			
			var _new_door = instance_create_layer(_d_xstart, _d_ystart, "Instances", _d_obj);
			
			_new_door.uid         = _d_uid;
			_new_door.image_angle = _d_angle;
			_new_door.swingspeed  = _d_speed;
			_new_door.swinger     = _d_swinger;
			_new_door.start_angle = _d_start;
			_new_door.closed      = _d_closed;
			
			_new_door.xstart = _d_xstart;
			_new_door.ystart = _d_ystart;
		}
	}
	
	// === ЧТЕНИЕ ТЬМЫ (objDarkness) ===
	if (buffer_tell(_buf) < buffer_get_size(_buf))
	{
		var _darkness_count = buffer_read(_buf, buffer_u16);
		
		for (var dk = 0; dk < _darkness_count; dk++)
		{
			var _dk_obj     = buffer_read(_buf, buffer_u16);
			var _dk_uid     = buffer_read(_buf, buffer_u32);
			var _dk_x       = buffer_read(_buf, buffer_f16);
			var _dk_y       = buffer_read(_buf, buffer_f16);
			var _dk_alpha   = buffer_read(_buf, buffer_f16);
			var _dk_angle   = buffer_read(_buf, buffer_f16);
			var _dk_xscale  = buffer_read(_buf, buffer_f16);
			var _dk_yscale  = buffer_read(_buf, buffer_f16);
			var _dk_fadeout = buffer_read(_buf, buffer_bool);
			var _dk_fadein  = buffer_read(_buf, buffer_bool);
			
			var _new_dark = instance_create_layer(_dk_x, _dk_y, "Instances", _dk_obj);
			
			_new_dark.uid          = _dk_uid;
			_new_dark.image_alpha  = _dk_alpha;
			_new_dark.image_angle  = _dk_angle;
			_new_dark.image_xscale = _dk_xscale;
			_new_dark.image_yscale = _dk_yscale;
			_new_dark.fade_out     = _dk_fadeout;
			_new_dark.fade_in      = _dk_fadein;
		}
	}
	
	// === ЧТЕНИЕ ОКОН (objWindow) ===
	if (buffer_tell(_buf) < buffer_get_size(_buf))
	{
		var _window_count = buffer_read(_buf, buffer_u16);
		
		for (var wn = 0; wn < _window_count; wn++)
		{
			var _wn_obj     = buffer_read(_buf, buffer_u16);
			var _wn_x       = buffer_read(_buf, buffer_f16);
			var _wn_y       = buffer_read(_buf, buffer_f16);
			var _wn_img     = buffer_read(_buf, buffer_u8);
			
			var _found = instance_position(_wn_x, _wn_y, _wn_obj);
			if (_found != noone)
			{
				_found.image_index = _wn_img;
				_found.solid = (_wn_img == 2) ? false : true;
			}
		}
	}
	
	// === ЧТЕНИЕ ТЕЛЕВИЗОРОВ (objTV) ===
	if (buffer_tell(_buf) < buffer_get_size(_buf))
	{
		var _tv_count = buffer_read(_buf, buffer_u16);
		
		for (var tv = 0; tv < _tv_count; tv++)
		{
			var _tv_x       = buffer_read(_buf, buffer_f16);
			var _tv_y       = buffer_read(_buf, buffer_f16);
			var _tv_sprite  = buffer_read(_buf, buffer_u16); 
			var _tv_angle   = buffer_read(_buf, buffer_f16);
			var _tv_speed   = buffer_read(_buf, buffer_f16);
			var _tv_energie = buffer_read(_buf, buffer_u8);
			var _tv_life    = buffer_read(_buf, buffer_u8);
			
			var _new_tv = instance_create_layer(_tv_x, _tv_y, "Instances", objTV, {
				image_angle: _tv_angle
			});
			
			_new_tv.sprite_index = _tv_sprite;
			_new_tv.image_angle  = _tv_angle;
			_new_tv.image_speed  = _tv_speed;
			_new_tv.energie      = _tv_energie;
			_new_tv.life         = _tv_life;
			
			// Если телевизор загрузился сломанным (или без энергии) — 
			// сразу же гасим его внутренний свет objLightSource, созданный в Create!
			if (_tv_sprite == sprTVBigBroken || _tv_sprite == sprTVBigBreak || _tv_energie <= 0)
			{
				if (_new_tv.my_light != noone && instance_exists(_new_tv.my_light))
				{
					instance_destroy(_new_tv.my_light);
				}
				_new_tv.my_light = noone;
			}
		}
	}
	
	// === ЧТЕНИЕ КАЛЬЯНОВ (objHookah) ===
	if (buffer_tell(_buf) < buffer_get_size(_buf))
	{
	    var _hookah_count = buffer_read(_buf, buffer_u16);
    
	    for (var hk = 0; hk < _hookah_count; hk++)
	    {
	        var _hk_x   = buffer_read(_buf, buffer_f16);
	        var _hk_y   = buffer_read(_buf, buffer_f16);
	        var _hk_img = buffer_read(_buf, buffer_u8);
        
	        var _new_hk = instance_create_layer(_hk_x, _hk_y, "Instances", objHookah);
	        _new_hk.image_index = _hk_img;
	    }
	}
	
	// === ЧТЕНИЕ СТРЕЛКИ ПЕРЕХОДА (objFloorTranslator) ===
	if (buffer_tell(_buf) < buffer_get_size(_buf))
	{
	    var _translator_count = buffer_read(_buf, buffer_u16);
    
	    for (var tr = 0; tr < _translator_count; tr++)
	    {
	        // Читаем маркеры позиции
	        var _tr_x = buffer_read(_buf, buffer_f16);
	        var _tr_y = buffer_read(_buf, buffer_f16);
        
	        // Читаем сохраненные свойства
	        var _saved_uid    = buffer_read(_buf, buffer_u16);
	        var _saved_unlock = buffer_read(_buf, buffer_u16);
        
	        // Ищем уже существующий на уровне объект по этим координатам
	        var _existing_inst = instance_position(_tr_x, _tr_y, objFloorTranslator);
        
	        // Если объект найден на этой точке уровня — обновляем его данные
	        if (_existing_inst != noone)
	        {
	            _existing_inst.uid = _saved_uid;
	            _existing_inst.trigger_unlock = _saved_unlock;
	        }
	    }
	}

	
	// === ЧТЕНИЕ ТРИГГЕРОВ ВХОДА (objTriggerEnter) ===
	if (buffer_tell(_buf) < buffer_get_size(_buf))
	{
		var _trigger_enter_count = buffer_read(_buf, buffer_u16);
		
		for (var t = 0; t < _trigger_enter_count; t++)
		{
			var _t_id        = buffer_read(_buf, buffer_u32);
			var _t_triggered = buffer_read(_buf, buffer_bool);
			
			var _t_spawn_obj    = buffer_read(_buf, buffer_u16);
			var _t_spawn_skin   = buffer_read(_buf, buffer_u8);
			var _t_spawn_class  = buffer_read(_buf, buffer_u8);
			var _t_spawn_weap   = buffer_read(_buf, buffer_u8);
			var _t_spawn_ammo   = buffer_read(_buf, buffer_u8);
			var _t_spawn_state  = buffer_read(_buf, buffer_u8);
			
			var _t_spawn_x      = buffer_read(_buf, buffer_f16);
			var _t_spawn_y      = buffer_read(_buf, buffer_f16);
			var _t_target_x     = buffer_read(_buf, buffer_f16);
			var _t_target_y     = buffer_read(_buf, buffer_f16);
			
			with (objTriggerEnter)
			{
				if (trigger_id == _t_id)
				{
					is_triggered = _t_triggered;
					
					if (!is_triggered)
					{
						spawn_object = _t_spawn_obj;
						spawn_skin   = _t_spawn_skin;
						spawn_class  = _t_spawn_class;
						spawn_weapon = _t_spawn_weap;
						spawn_ammo   = _t_spawn_ammo;
						spawn_state  = _t_spawn_state;
						
						spawn_x  = _t_spawn_x;
						spawn_y  = _t_spawn_y;
						target_x = _t_target_x;
						target_y = _t_target_y;
					}
					
					break;
				}
			}
		}
	}
	
	
	// === ЧТЕНИЕ ТРИГГЕРОВ СОБЫТИЙ (objTriggerAction) ===
	if (buffer_tell(_buf) < buffer_get_size(_buf))
	{
		var _trigger_action_count = buffer_read(_buf, buffer_u16);
		
		for (var t = 0; t < _trigger_action_count; t++)
		{
			var _t_id        = buffer_read(_buf, buffer_u32);
			var _t_triggered = buffer_read(_buf, buffer_bool);
			
			with (objTriggerAction)
			{
				if (trigger_id == _t_id)
				{
					is_triggered = _t_triggered;
					break;
				}
			}
		}
	}
	
	buffer_delete(_buf); 
	
	// === ЗАГРУЗКА ПОВЕРХНОСТИ КРОВИ ===
	var _blood_file_name = scrGetBloodFileName();
	
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