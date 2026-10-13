/// @param {Real} _weapon Текущее оружие врага (WEAPONS.UNARMED, WEAPONS.M16 и т.д.)
function scrUpdateHeadSet()
{
	// 1. БАЗОВАЯ БАЗА ДАННЫХ НАПРЯМУЮ ПО ЭНУМАМ
	static _anim_data = [];
	static _dodge_data = []; // ← отдельный массив для доджа (не зависит от оружия)
	
	if (array_length(_anim_data) == 0) 
	{
		var WALK = 0; var ATTACK = 1; var SEARCH = 2; var IDLE = 3;

		// =========================================================================
		// КУЛАКИ (UNARMED)
		// =========================================================================
		_anim_data[WEAPONS.UNARMED][WALK] = [
			/*Вперед-назад*/[ 0,  0,  0,  0,  0,  0,  0,  0], 
			/*Влево-вправо*/[ 0,  1,  1,  1,  0, -1, -1, -1]
		];
		_anim_data[WEAPONS.UNARMED][ATTACK] = _anim_data[WEAPONS.UNARMED][WALK];
		_anim_data[WEAPONS.UNARMED][SEARCH] = [
			/*Вперед-назад*/[0, 0, -1, -1, -1, 0, 0, -1, -1, -1], 
			/*Влево-вправо*/[0, 1, 2, 2, 2, 0, -1, -2, -2, -2] 
		];
		_anim_data[WEAPONS.UNARMED][IDLE] = [
			/*Вперед-назад*/[0], 
			/*Влево-вправо*/[0]
		];
		
		// =========================================================================
		// НОЖ (KNIFE)
		// =========================================================================
		_anim_data[WEAPONS.KNIFE][WALK] = [
			/*Вперед-назад*/[0, 0, 0, 0, 0, 0, 0, 0], 
			/*Влево-вправо*/[0, -1, -1, -1, 0, 1, 1, 1]
		];
		_anim_data[WEAPONS.KNIFE][ATTACK] = [
			/*Вперед-назад*/[0, 2, 4, 3, 1, 0, 0, 0], 
			/*Влево-вправо*/[0, -1, -1, 0, 0, 0, 0, 0] 
		];
		_anim_data[WEAPONS.KNIFE][SEARCH] = [
			/*Вперед-назад*/[0, 0, -1, -1, -1, 0, 0, -1, -1, -1], 
			/*Влево-вправо*/[0, 1, 2, 2, 2, 0, -1, -2, -2, -2] 
		];
		_anim_data[WEAPONS.KNIFE][IDLE] = [
			/*Вперед-назад*/[0], 
			/*Влево-вправо*/[0]
		];
		
		// =========================================================================
		// ПИСТОЛЕТ (PISTOL)
		// =========================================================================
		_anim_data[WEAPONS.PISTOL][WALK] = [
			/*Вперед-назад*/[ 0,  0,  0,  0,  0,  0,   0,  0], 
			/*Влево-вправо*/[ 0,  1,  1,  1,  0, -1,  -1, -1]
		];
		_anim_data[WEAPONS.PISTOL][ATTACK] = [
			/*Вперед-назад*/[0, -1, -1, -1], 
			/*Влево-вправо*/[ 0,  -1, -1, -1]
		];
		_anim_data[WEAPONS.PISTOL][SEARCH] = [
			/*Вперед-назад*/[0, 0, -1, -1, -1, 0, 0, -1, -1, -1], 
			/*Влево-вправо*/[0, 1, 2, 2, 2, 0, -1, -2, -2, -2] 
		];
		_anim_data[WEAPONS.PISTOL][IDLE] = [
			/*Вперед-назад*/[0], 
			/*Влево-вправо*/[0]
		];
		
		// =========================================================================
		// АВТОМАТ М16 (M16)
		// =========================================================================
		_anim_data[WEAPONS.M16][WALK] = [
			/*Вперед-назад*/[0, 0, 0, 0, 0, 0, 0, 0], 
			/*Влево-вправо*/[ 0,  1,  1,  1,  0,  -1,  -1, -1]
		];
		_anim_data[WEAPONS.M16][ATTACK] = [
			/*Вперед-назад*/[0, 0, 0, 0], 
			/*Влево-вправо*/[ 0,  -1, -1, -1]
		];
		_anim_data[WEAPONS.M16][SEARCH] = [
			/*Вперед-назад*/[0, 0, -1, -1, -1, 0, 0, -1, -1, -1], 
			/*Влево-вправо*/[0, 1, 2, 2, 2, 0, -1, -2, -2, -2] 
		];
		_anim_data[WEAPONS.M16][IDLE] = [
			/*Вперед-назад*/[0], 
			/*Влево-вправо*/[0]
		];

		// =========================================================================
		// БИТА (BAT)
		// =========================================================================
		_anim_data[WEAPONS.BAT][WALK] = [
			/*Вперед-назад*/[0, 0, 0, 0, 0, 0, 0, 0], 
			/*Влево-вправо*/[ 0,  -1,  -1,  -1,  0,  1, 1, 1]
		];
		_anim_data[WEAPONS.BAT][ATTACK] = [
			/*Вперед-назад*/[0, 0, 0, 0, 0, 0, 0, 0, 0], 
			/*Влево-вправо*/[ 0, -2, -3,  -3, -2, -1, 0, 0, 0] 
		];
		_anim_data[WEAPONS.BAT][SEARCH] = [
			/*Вперед-назад*/[0, 0, -1, -1, -1, 0, 0, -1, -1, -1], 
			/*Влево-вправо*/[0, 1, 2, 2, 2, 0, -1, -2, -2, -2] 
		];
		_anim_data[WEAPONS.BAT][IDLE] = [
			/*Вперед-назад*/[16], 
			/*Влево-вправо*/[0]
		];

		// =========================================================================
		// ТРУБА (PIPE) = БИТА
		// =========================================================================
		_anim_data[WEAPONS.PIPE][WALK]   = _anim_data[WEAPONS.BAT][WALK];
		_anim_data[WEAPONS.PIPE][ATTACK] = _anim_data[WEAPONS.BAT][ATTACK];
		_anim_data[WEAPONS.PIPE][SEARCH] = _anim_data[WEAPONS.BAT][SEARCH];
		_anim_data[WEAPONS.PIPE][IDLE]   = _anim_data[WEAPONS.BAT][IDLE];
		
		// =========================================================================
		// ДРОБОВИК (SHOTGUN)
		// =========================================================================
		_anim_data[WEAPONS.SHOTGUN][WALK]	= _anim_data[WEAPONS.M16][WALK];
		_anim_data[WEAPONS.SHOTGUN][ATTACK] = [
			/*Вперед-назад*/[0, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			/*Влево-вправо*/[0,  0,  0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
		];
		_anim_data[WEAPONS.SHOTGUN][SEARCH] = [
			/*Вперед-назад*/[0, 0, -1, -1, -1, 0, 0, -1, -1, -1], 
			/*Влево-вправо*/[0, 1, 2, 2, 2, 0, -1, -2, -2, -2] 
		];
		_anim_data[WEAPONS.SHOTGUN][IDLE] = [
			/*Вперед-назад*/[16], 
			/*Влево-вправо*/[0]
		];
		
		// =========================================================================
		// DODGE — ОБЩИЙ МАССИВ 
		// =========================================================================
		// Вперед-назад (ось X локально) и Влево-вправо (ось Y локально)
		// Меняйте значения под нужный эффект. Длина массива = количество кадров доджа.
		_dodge_data = [
			/*Вперед-назад*/[0, 0, 7, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 7, 7, 6, 3 , 3, 1], 
			/*Влево-вправо*/[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
		];
	}
	
	if (!instance_exists(id) || variable_instance_exists(id, "weapon") == false) exit;
	
	// 2. ИЗВЛЕЧЕНИЕ ДАННЫХ ИЗ МАССИВА ОРУЖИЯ
	var _wp_data = noone;
	if (weapon < array_length(_anim_data) && is_array(_anim_data[weapon])) 
	{
		_wp_data = _anim_data[weapon];
	}
	else 
	{
		_wp_data = _anim_data[WEAPONS.UNARMED];
	}
	
	// 3. ОПРЕДЕЛЕНИЕ ДЕЙСТВИЯ
	var _action_index = 0; 
	var _is_searching = false;
	var _is_dodge = false;
	
	if (state == STATES.DODGE)
	{
		_is_dodge = true;
	}
	else if (variable_instance_exists(id, "my_sprites") && variable_struct_exists(my_sprites, "sprites"))
	{
		var _s = my_sprites.sprites;
		
		if (sprite_index == _s.walk)         _action_index = 0; 
		else if (sprite_index == _s.attack)  _action_index = 1;
		else if (sprite_index == _s.search) { _action_index = 2; _is_searching = true; }
		else if (sprite_index == _s.idle)    _action_index = 3;
	}
	
	// 4. ВЫБОР ДАННЫХ: ОРУЖИЕ ИЛИ ДОДЖ
	var _fwd  = 0;
	var _side = 0;
	
	if (_is_dodge)
	{
		// Используем общий массив доджа
		var _fwd_array  = _dodge_data[0];
		var _side_array = _dodge_data[1];
		
		var _frame_fwd  = floor(image_index) % array_length(_fwd_array);
		var _frame_side = floor(image_index) % array_length(_side_array);
		
		_fwd  = _fwd_array[_frame_fwd];
		_side = _side_array[_frame_side];
	}
	else
	{
		// Используем массив оружия
		if (_action_index >= array_length(_wp_data) || !is_array(_wp_data[_action_index]))
		{
			_action_index = 0;
		}
		
		var _data = _wp_data[_action_index];
		
		var _fwd_array  = _data[0];
		var _side_array = _data[1];
		
		var _frame_fwd  = floor(image_index) % array_length(_fwd_array);
		var _frame_side = floor(image_index) % array_length(_side_array);
		
		_fwd  = _fwd_array[_frame_fwd];
		_side = _side_array[_frame_side];
	}
	
	// === 5. ПРОЕКЦИЯ ===
	var _local_x = _fwd; 
	var _local_y = _side * image_yscale; 
	
	var _hx = x + _local_x * dcos(my_angle) + _local_y * dsin(my_angle);
	var _hy = y - _local_x * dsin(my_angle) + _local_y * dcos(my_angle);
	
	headgear_x = _hx;
	headgear_y = _hy;
	
	// === 6. ПОВОРОТ ПРИ SEARCH ===
	if (_is_searching)
	{
		var _rot_pattern = [0, -1, -2, -2, -2, 0, 1, 2, 2, 2];
		var _frame_rot = floor(image_index) % array_length(_rot_pattern);
		var _rot_value = _rot_pattern[_frame_rot];
		headgear_angle = my_angle + (_rot_value * 15 * image_yscale);
	}
	else
	{
		headgear_angle = my_angle;
	}
	
	// ДЕБАГ
	var _debug_text = "WEAPON: " + string(weapon) + " | ACT: " + string(_action_index) + " | FRAME: " + string(floor(image_index));
	draw_text_transformed(x - 40, y - 30, _debug_text, 0.5, 0.5, 0);
}