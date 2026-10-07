// === 1. ОЖИДАНИЕ КЛИКА ВНУТРИ КАЗНИ ===
// Если казнь еще не запущена (hurt_index равен 0), ждем нажатия кнопки мыши
if (hurt_index == 0)
{
	// Нажали ЛКМ — запускаем обычную казнь (8 кадров)
	if (mouse_check_button_pressed(mb_left))
	{
		sprite_index  = sprCopKillKnife;
		is_fast_execution = false;
		hurt_index = 6;
		finish_index = 10;
	}
	// Нажали ПКМ — запускаем быструю казнь (4 кадра)
	else if (keyboard_check_pressed(vk_space))
	{
		sprite_index = sprCopKillKnifeQuick;
		enemy_sprite = sprColombianDieKnifeQuick;
		is_fast_execution = true;
		hurt_index = 1;
		finish_index = 4;
	}
	
	// Если ни одна кнопка еще не нажата, полностью выходим из Step, ничего не двигая
	if (hurt_index == 0) exit;
}

// === 2. ПРИРОСТ КАДРОВ И СИНХРОНИЗАЦИЯ (Срабатывает только после выбора казни) ===
image_index += 0.25;

if (!is_fast_execution)
{
	// ЛКМ (Обычная): Кадры 8/8, идут с одинаковой скоростью
	enemy_image_index += 0.25;
}
else
{
	// ПКМ (Быстрая): Кадры 4/8, враг двигается в 2 раза быстрее игрока
	enemy_image_index += 0.5;
}

// === 3. МОМЕНТ НАНЕСЕНИЯ РЕЖУЩЕГО УДАРА (СКВИРТ И НИЖЕ) ===
if (image_index >= hurt_index && !triggered_hurt)
{
	triggered_hurt = true; 

	// Воспроизведение звука порезов ножом
	var _knife_sound = choose(sndCut1, sndCut2);
	var _played_sound = audio_play_sound(_knife_sound, 1, false);
	if (_played_sound != -1)
	{
		audio_sound_pitch(_played_sound, random_range(0.85, 1.15));
	}

	// Интенсивность тряски экрана
	objEffector.shake = 1; 

	// Точка шеи/головы лежачего врага
	var _dist = 12; 
	var _blood_x = x + lengthdir_x(_dist, my_angle);
	var _blood_y = y + lengthdir_y(_dist, my_angle); 

	// НАПРАВЛЕННЫЙ ФОНТАН СРАЗУ ВПРАВО БЕЗ СКОРОСТИ И С МАКСИМУМ 3 РАНДОМА
	repeat(2) 
	{
		var _right_direction = (my_angle - 90) + random_range(-3, 3);
		
	    var _squirt = instance_create_layer(_blood_x, _blood_y, "Instances", objBloodSquirt);
	    _squirt.image_angle = _right_direction;
	    _squirt.direction   = _right_direction;
	}

	// Облака кровавого тумана
	repeat (4)
	{
	    var _smoke_id = instance_create_layer(_blood_x, _blood_y, "Instances", objBloodSmoke);
	    _smoke_id.direction = my_angle + irandom_range(-60, 60);
	    _smoke_id.image_angle = _smoke_id.direction;
	    _smoke_id.speed = random(2);
	}
}

// === 4. ФИНАЛ АНИМАЦИИ (ЗАКРЫВАЕМ СЦЕНУ АВТОМАТИЧЕСКИ) ===
if (image_index >= finish_index)
{
    var _player = instance_create_layer(x, y, "Instances", objPlayer);
	
	// === ИСПРАВЛЕНО: Проверка на тип добивания для потери ножа ===
	if (is_fast_execution)
	{
		// Быстрое добивание: нож остается во враге, игрок встает ГОЛЫМИ РУКАМИ
		_player.current_weapon = WEAPONS.UNARMED;
	}
	else
	{
		// Обычное добивание: вытаскиваем нож обратно, игрок встает С НОЖОМ
		_player.current_weapon = WEAPONS.KNIFE;
	}
	
    _player.my_sprites     = scrPlayerGetWeaponSprite(CHARACTER.COP, _player.current_weapon);
    _player.sprite_index   = _player.my_sprites.walk; 
    _player.image_index    = 0;
	_player.my_angle       = my_angle;
    
    // Оставляем готовый труп врага на полу
    var _body = instance_create_layer(x, y, "Instances", objDeadBody);
    _body.sprite_index = enemy_sprite;
    _body.image_index  = 7; // Последний кадр смерти врага (индекс 7 при 8 кадрах)
    _body.my_angle     = my_angle;
	_body.isExecuted   = true;
    
	scrEnemyUpdateTargetID(id, _player); 
    instance_destroy();
}
