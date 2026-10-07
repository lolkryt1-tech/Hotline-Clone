/// @param {Real} _weapon Текущее оружие врага (WEAPONS.UNARMED, WEAPONS.M16 и т.д.)
function scrUpdateHeadSet()
{
	// 1. БАЗОВАЯ БАЗА ДАННЫХ НАПРЯМУЮ ПО ЭНУМАМ
	static _anim_data = [];
	
	if (array_length(_anim_data) == 0) 
	{
		var WALK = 0; var ATTACK = 1; var SEARCH = 2; var IDLE = 3;

		// =========================================================================
		// КУЛАКИ (UNARMED)
		// =========================================================================
		_anim_data[WEAPONS.UNARMED][WALK] = [
			// Кадры:         0   1   2   3   4   5   6   7
			/*Вперед-назад*/[ 0,  0,  0,  0,  0,  0,  0,  0], 
			/*Влево-вправо*/[ 0,  1,  1,  1,  0, -1, -1, -1]
		];
		// ЗАЩИТА: Дублируем ходьбу/поиск для остальных состояний, чтобы не было Out of Range
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
			// Кадры:         0   1   2   3   4   5   6   7   8  
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
			// Кадры:         0   1   2   3   4   5   6   7   8  
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
		// БИТА (BAT) — Холодное оружие
		// =========================================================================
		_anim_data[WEAPONS.BAT][WALK] = [
			// Кадры:         0   1   2   3   4   5   6   7   8   9  10  11  12  13
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
		// ОБЪЕДИНЕНИЕ: ТРУБА (PIPE) ПОЛНОСТЬЮ ДУБЛИРУЕТ БИТУ (BAT)
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
			// ИСПРАВЛЕНО: Индексы возвращены в правильный стандарт [0] - вперед, [1] - бок
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
	}
	
	// ЗАЩИТА: Прерываем выполнение при глобальном старте игры
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
	
	// 3. ОПРЕДЕЛЕНИЕ ДЕЙСТВИЯ С ПРАВИЛЬНЫМ ПРИОРИТЕТОМ ХОДЬБЫ
	var _action_index = 0; 
	var _is_searching = false;
	
	if (variable_instance_exists(id, "my_sprites") && variable_struct_exists(my_sprites, "sprites"))
	{
		var _s = my_sprites.sprites;
		
		if (sprite_index == _s.walk)         _action_index = 0; 
		else if (sprite_index == _s.attack)  _action_index = 1;
		else if (sprite_index == _s.search) { _action_index = 2; _is_searching = true; }
		else if (sprite_index == _s.idle)    _action_index = 3;
	}
	
	// КРАШ-ЗАЩИТА: Если у текущего оружия нет запрошенного анимационного массива (длина меньше индекса)
	if (_action_index >= array_length(_wp_data) || !is_array(_wp_data[_action_index]))
	{
		_action_index = 0; // Насильно сбрасываем индекс на WALK (0), он гарантированно есть всегда
	}
	
	var _data = _wp_data[_action_index];
	
	var _fwd_array  = _data[0];
	var _side_array = _data[1];
	
	var _frame_fwd  = floor(image_index) % array_length(_fwd_array);
	var _frame_side = floor(image_index) % array_length(_side_array);
	
	var _fwd  = _fwd_array[_frame_fwd];
	var _side = _side_array[_frame_side];
	
	// === 4. МАТЕМАТИЧЕСКАЯ ПРОЕКЦИЯ НА КАРТУ ===
	var _local_x = _fwd; 
	var _local_y = _side * image_yscale; 
	
	var _hx = x + _local_x * dcos(my_angle) + _local_y * dsin(my_angle);
	var _hy = y - _local_x * dsin(my_angle) + _local_y * dcos(my_angle);
	
	headgear_x = _hx;
	headgear_y = _hy;
	
	// === 5. ТОЧНЫЙ ПОКАДРОВЫЙ ПОВОРОТ ВПРАВО ПРИ SEARCH ===
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
	
	// ВРЕМЕННЫЙ ДЕБАГ ТЕКСТ НА ЭКРАНЕ
	var _debug_text = "WEAPON: " + string(weapon) + " | ACT: " + string(_action_index) + " | FRAME: " + string(floor(image_index));
	draw_text_transformed(x - 40, y - 30, _debug_text, 0.5, 0.5, 0);
}
