function scrPlayerDieMelee(_killer, _weapon)
{
	// === 1. ПОИСК ЖЕРТВЫ (ИГРОКА) ===
	var _victim_id = noone;

	if (instance_exists(objPlayer))
	{
		_victim_id = instance_find(objPlayer, 0);
	}
	else 
	{
		_victim_id = instance_find(objPlayerExecution, 0);
	}

	if (_victim_id == noone) exit;

	var _px = _victim_id.x;
	var _py = _victim_id.y;
	
	// Вычисляем направление удара от убийцы к игроку
	var _push_dir = point_direction(_killer.x, _killer.y, _px, _py);
    
	// === 2. КОНВЕРТАЦИЯ ОРУЖИЯ В ТИП УРОНА ===
	var _calculated_hit_type = HIT_TYPE.BLUNT; // По умолчанию дробящее
	
	if (_weapon == WEAPONS.BAT || _weapon == WEAPONS.PIPE || _weapon == WEAPONS.FISTS) { _calculated_hit_type = HIT_TYPE.BLUNT; } 
	if (_weapon == WEAPONS.KNIFE)								     { _calculated_hit_type = HIT_TYPE.CUT; }  
	
	// ЗАГОТОВКА НА БУДУЩЕЕ: Раскомментируй и добавь сюда свои мечи/топоры
	// if (_weapon == WEAPONS.KATANA || _weapon == WEAPONS.AXE)       { _calculated_hit_type = HIT_TYPE.SLASH; }

	// === 3. ОБРАБОТКА ТИПА УДАРA: ЗВУКИ, СЛИТЫ И СПРАЙТЫ ===
	var _selected_sprite = sprCopDeadMachinegun; 
	var _corpse_speed = 5;                       

	switch(_calculated_hit_type)
	{
		case HIT_TYPE.BLUNT: // Размозжили битой/трубой/кулаком
			var _played_sound = audio_play_sound(sndHit3, 1, false);
			if (_played_sound != -1) audio_sound_pitch(_played_sound, random_range(0.9, 1.1));
			
			_selected_sprite = sprCopDeadBlunt; 
			_corpse_speed = 3.5;
			objEffector.shake = 5;
			break;
			
		case HIT_TYPE.CUT: // Полоснули ножом
			var _played_sound = audio_play_sound(choose(sndCut1, sndCut2), 1, false); 
			if (_played_sound != -1) audio_sound_pitch(_played_sound, random_range(0.9, 1.1));
			
			_selected_sprite = sprCopDeadCut;  
			_corpse_speed = 3.5;
			objEffector.shake = 4;
			break;
	}

	// === 4. УНИЧТОЖЕНИЕ ЖИВОГО ИГРОКА И СПАВН ТРУПА ===
	instance_destroy(_victim_id);
    
	var _corpse = instance_create_layer(_px, _py, "Instances", objPlayerDead);
	_corpse.sprite_index = _selected_sprite;
	_corpse.image_index  = irandom_range(1, 14);
	
	// Передаем физику и углы
	_corpse.direction    = _push_dir;
	_corpse.speed        = _corpse_speed;
	_corpse.my_angle     = _push_dir;
	
	// Скармливаем трупу игрока тип урона для корректных брызг крови на полу (go_splat)
	_corpse.hit_type     = _calculated_hit_type;
	_corpse.go_splat     = 1;
}
