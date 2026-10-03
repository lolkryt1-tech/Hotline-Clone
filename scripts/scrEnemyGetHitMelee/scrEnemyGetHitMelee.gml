/// @param {Id} _enemy_id Кого бьем (инстанс врага или объекта казни)
/// @param {Real} _hit_type_enum Тип урона из энума (HIT_TYPE.UNARMED, HIT_TYPE.BLUNT и т.д.)
/// @param {Real} _push_dir Направление полета/удара
/// @param {Id} _source_id Кто ударил (id игрока или другого врага)
function scrEnemyGetHitMelee(_enemy_id, _hit_type_enum, _push_dir, _source_id)
{
	// Железная защита: если цель уже удалена из памяти — мгновенно выходим
	if (!instance_exists(_enemy_id)) exit;

	// Создаем локальные переменные для безопасного сбора данных из контекста жертвы
	var _ex       = _enemy_id.x;
	var _ey       = _enemy_id.y;
	var _is_lean  = (_enemy_id.object_index == objEnemyKnockedOutLean);
	var _class    = 0;
	var _faction  = 0;
	var _can_hear = 1;
	var _sprites  = noone;

	// === ИСПРАВЛЕНО: ЖЕСТКОЕ ПЕРЕКЛЮЧЕНИЕ КОНТЕКСТА НА ЖЕРТВУ ===
	// Теперь все манипуляции и вызовы функций внутри этого блока относятся СТРОГО к жертве,
	// и атакующий враг больше никогда не потеряет свое оружие!
with (_enemy_id)
	{
		_class    = variable_instance_exists(id, "class")   ? class   : 0;
		_faction  = variable_instance_exists(id, "faction") ? faction : 0;
		_can_hear = variable_instance_exists(id, "can_hear") ? can_hear : 1;
		
		// 1. Сначала честно выбиваем оружие, пока scrEnemyGetSprite его не обнулил!
		if (variable_instance_exists(id, "weapon") && weapon != WEAPONS.UNARMED)
		{
			var _dropped = instance_create_layer(x, y, "Instances", objWeapon);
			_dropped.weapon    = weapon;
			_dropped.my_angle  = irandom(360);
			_dropped.direction = irandom(360);
			_dropped.speed     = 5;
		}

		// 2. И только теперь безопасно достаем спрайты нокаута
		var _enemy_data = scrEnemyGetSprite(_class, WEAPONS.UNARMED);
		_sprites        = _enemy_data.sprites;
	}

	// === 2. ДРОП НАУШНИКОВ ===
	if (_can_hear == 0) 
	{ 
		instance_create_layer(_ex, _ey, "Instances", objHeadSet); 
	}

	// === 3. ОБРАБОТКА ТИПОВ УРОНА ЧЕРЕЗ ENUM HIT_TYPE ===
	switch(_hit_type_enum)
	{
		case HIT_TYPE.UNARMED: // Нокаут кулаками
			var _knocked = instance_create_layer(_ex, _ey, "Instances", objEnemyKnockedOut);
			_knocked.class         = _class;
			_knocked.faction       = _faction;
			_knocked.direction     = _push_dir;
			_knocked.speed         = 4;
			_knocked.my_angle      = _push_dir - 180;
			_knocked.image_index   = 1;
			_knocked.sprite_index  = _sprites.knocked;
            
			objEffector.shake = 1.5;
			break;
           
		case HIT_TYPE.BLUNT: // Смертельное дробящее (Труба/Бита)
			var _played_sound = audio_play_sound(sndHit3, 1, false);
			if (_played_sound != -1) audio_sound_pitch(_played_sound, random_range(0.9, 1.1));
                
			var _corpse = instance_create_layer(_ex, _ey, "Instances", objDeadBody);
			_corpse.hit_type = HIT_TYPE.BLUNT;
			_corpse.go_splat = 1;
			_corpse.class    = _class;
            
			if (_is_lean) // Смерть у стены
			{
				_corpse.sprite_index = _sprites.deadLeanMelee;
				_corpse.speed        = 0.5;
				_corpse.direction    = _enemy_id.direction;
				_corpse.image_index  = random_range(1, 3);
				_corpse.my_angle     = _enemy_id.my_angle; 
				_corpse.isExecuted   = true; 
			}
			else // Смерть на открытом полу
			{
				var _random_direction = random_range(-15, 15);
				_corpse.sprite_index = _sprites.deadBlunt;
				_corpse.direction    = _push_dir + _random_direction;
				_corpse.speed        = 2.5; 
				_corpse.my_angle     = _push_dir + _random_direction;
			}
            
			objEffector.shake = 2.5;
			break;
	}

	// Уничтожаем старый инстанс врага (живого или сидячего)
	instance_destroy(_enemy_id);
}
