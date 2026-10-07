/// @param {Id} _enemy_id Кого бьем (инстанс врага или объекта казни)
/// @param {Real} _weapon_enum Оружие, КОТОРЫМ бьют (из энума WEAPONS)
/// @param {Real} _push_dir Направление полета/удара
/// @param {Id} _source_id Кто ударил (id игрока или другого врага)
function scrEnemyGetHitMelee(_enemy_id, _weapon_enum, _push_dir, _source_id)
{
	if (!instance_exists(_enemy_id)) exit;

	// ЗАЩИТА: Если цель не живое существо (например, пушка на полу objWeapon) — выходим
	if (!variable_instance_exists(_enemy_id, "class")) exit;

	// === АБСОЛЮТНЫЙ ИГНОР: Если бьем кулаками по Доджеру, моментально выходим ===
	if (_enemy_id.class == CLASS.DODGER && _weapon_enum == WEAPONS.UNARMED)
	{
		exit;
	}

	// Определяем тип объекта жертвы ДО входа в блок with
	var _is_lean = (_enemy_id.object_index == objEnemyKnockedOutLean);
	var _ex      = _enemy_id.x;
	var _ey      = _enemy_id.y;

	// === 1. АВТОМАТИЧЕСКАЯ КОНВЕРТАЦИЯ ОРУЖИЯ В ТИП УРОНА ===
	var _calculated_hit_type = HIT_TYPE.UNARMED; // По умолчанию кулаки
	
	if (_weapon_enum == WEAPONS.BAT || _weapon_enum == WEAPONS.PIPE || _weapon_enum == WEAPONS.FISTS) { _calculated_hit_type = HIT_TYPE.BLUNT; } // Дробящее оружие
	if (_weapon_enum == WEAPONS.KNIFE)								 { _calculated_hit_type = HIT_TYPE.CUT; }  // Режущее (Нож)

	// === 2. ВСЯ ЛОГИКА ВНУТРИ ЖЕРТВЫ ===
	with (_enemy_id)
	{
		// Проверяем, является ли объект куклой нокаута (летящей или прислоненной)
		var _is_knocked_object = (object_index == objEnemyKnockedOut || object_index == objEnemyKnockedOutLean);
		
		// Блок выполняется СТРОГО для живых врагов. Из кукол нокаута ничего повторно не вылетает!
		if (!_is_knocked_object)
		{
			// Выбиваем оружие жертвы на пол
			if (weapon != WEAPONS.UNARMED)
			{
				var _dropped = instance_create_layer(x, y, "Instances", objWeapon);
				_dropped.weapon    = weapon;
				_dropped.my_angle  = irandom(360);
				_dropped.direction = irandom(360);
				_dropped.speed     = 5;
				_dropped.ammo      = ammo; 
			}

			// Дроп наушников
			if (can_hear == 0) 
			{ 
				instance_create_layer(x, y, "Instances", objHeadSet); 
			}
		}

		// Обработка рассчитанного типа урона
		switch(_calculated_hit_type)
		{
			case HIT_TYPE.UNARMED: // Нокаут кулаками
				var _knocked = instance_create_layer(x, y, "Instances", objEnemyKnockedOut);
				_knocked.skin		    = skin;      
				_knocked.class          = class;
				_knocked.faction        = faction;
				_knocked.direction      = _push_dir;
				_knocked.speed          = 3;
				_knocked.my_angle       = _push_dir - 180;
				_knocked.image_index    = 1;
				_knocked.sprite_index   = sprKnocked;
				_knocked.sprKnockedLean = sprKnockedLean;
				_knocked.sprDeadLeanMelee = sprDeadLeanMelee;
				_knocked.sprDeadLeanShotgun = sprDeadLeanShotgun;
				_knocked.sprDeadLeanMachinegun = sprDeadLeanMachinegun;
	            
				objEffector.shake = 1.5;
				break;
	           
			case HIT_TYPE.BLUNT: // Смертельное дробящее (Труба/Бита)
				var _played_sound = audio_play_sound(sndHit3, 1, false);
				if (_played_sound != -1) audio_sound_pitch(_played_sound, random_range(0.9, 1.1));
	                
				var _corpse = instance_create_layer(x, y, "Instances", objDeadBody);
				_corpse.hit_type = HIT_TYPE.BLUNT;
				_corpse.go_splat = 1;
				_corpse.class    = class;
				_corpse.skin     = skin;
	            
				if (_is_lean) // Смерть у стены
				{
					_corpse.sprite_index = sprDeadLeanMelee; 
					_corpse.speed        = 0.5;
					_corpse.direction    = direction;
					_corpse.image_index  = random_range(1, 3);
					_corpse.my_angle     = my_angle; 
					_corpse.isExecuted   = true; 
				}
				else // Смерть на открытом полу
				{
					var _random_direction = random_range(-15, 15);
					_corpse.sprite_index = sprDeadBlunt; 
					_corpse.direction    = _push_dir + _random_direction;
					_corpse.speed        = 2.5; 
					_corpse.my_angle     = _push_dir + _random_direction;
				}
	            
				objEffector.shake = 1.5;
				break;
				
			case HIT_TYPE.CUT: 
				_played_sound = audio_play_sound(choose(sndCut1, sndCut2), 1, false); 
				if (_played_sound != -1) audio_sound_pitch(_played_sound, random_range(0.9, 1.1));
				
				_corpse = instance_create_layer(x, y, "Instances", objDeadBody);
				_corpse.hit_type = HIT_TYPE.CUT;
				_corpse.go_splat = 1;
				_corpse.class    = class;
				_corpse.skin     = skin;
				
				if (_is_lean)
				{
					_corpse.sprite_index = sprDeadLeanMelee;
					_corpse.speed        = 0.5;
					_corpse.direction    = direction;
					_corpse.image_index  = random_range(1, 3);
					_corpse.my_angle     = my_angle;
					_corpse.isExecuted   = true;
				}
				else
				{
					var _random_direction = random_range(-10, 10);
					_corpse.sprite_index =  sprDeadCut;
					_corpse.direction    = _push_dir + _random_direction;
					_corpse.speed        = 3.0; // От ножа труп летит чуть быстрее/резче
					_corpse.my_angle     = _push_dir + _random_direction;
				}
				
				objEffector.shake = 0.5;
				break;
		}
		
		// Добавляем убийство в комбо
		if (_calculated_hit_type != HIT_TYPE.UNARMED) scrAddKillStats(100, _is_lean);
		
		
		// Самоуничтожаемся прямо изнутри контекста
		instance_destroy();
	}
}
