// Если дверь заперта — враг её не открывает
if (closed) 
{
    // Переключаемся на врага
    with (other.id) // В событии Collision с objEnemy, other.id — это конкретный враг
    {
        // 1. Рассчитываем текущие векторы движения врага по его скорости и углу
        var _vx = lengthdir_x(current_speed, direction);
        var _vy = lengthdir_y(current_speed, direction);
        
        // 2. Массив препятствий (эта дверь + основные стены)
        var _targets = [other.id, objSolid]; // Укажите ваш объект стен, если он называется иначе
        
        // 3. Заставляем движок GameMaker идеально обработать скольжение врага вдоль двери и углов
        move_and_collide(_vx, _vy, _targets, 4);
    }
    return;
}


// =========================================================================
// 0. ДОДЖЕР: Если он стоит на месте — дверь игнорирует его тело
// =========================================================================
if (other.class == CLASS.DODGER && other.current_speed == 0)
{
    return;
}

// =========================================================================
// 1. ЖЁСТКИЙ СЦЕНАРИЙ: Дверь летит на высокой скорости
// =========================================================================
if (abs(swingspeed) > 3.5 && (swinger == 1 || swinger == 0)) 
{
	// Сбиваем с ног восприимчивые классы
	if (other.class == CLASS.REGULAR || other.class == CLASS.VEST)
	{
		objEffector.shake = 5;
		
		var _enemy = other.id;
		var _hit_dir = image_angle + (swingspeed > 0 ? -90 : 90);
        
		scrEnemyGetHitMelee(_enemy, WEAPONS.UNARMED, _hit_dir - 180, id);
		
		return; 
	}
	else
	{
		// Dodger/Fat — дверь просто отскакивает от его тела
		var _to_enemy_x = other.x - x;
		var _to_enemy_y = other.y - y;
		var _enemy_dir = point_direction(0, 0, _to_enemy_x, _to_enemy_y);
		var _angle_diff = angle_difference(_enemy_dir, image_angle);

		if (_angle_diff > 0) { swingspeed = -abs(swingspeed); } 
		else                 { swingspeed = abs(swingspeed);  }
		return; 
	}
}

// =========================================================================
// 2. МЯГКИЙ СЦЕНАРИЙ: Враг наступает на дверь и мягко её толкает
// =========================================================================
else 
{
    if (abs(swingspeed) > 2) return; 
    
    swinger = 2; 

    if (abs(swingspeed) < 0.5 && asset_get_index("sndDoorOpen") != -1) 
    {
        audio_play_sound(sndDoorOpen, 0, false);
    }

    var _to_enemy_x = other.x - x;
    var _to_enemy_y = other.y - y;

    var _enemy_dir = point_direction(0, 0, _to_enemy_x, _to_enemy_y);
    var _angle_diff = angle_difference(_enemy_dir, image_angle);

    if (_angle_diff > 0) 
    {
        swingspeed = -6; 
        if (image_angle == start_angle) image_angle -= 1;
    } 
    else 
    {
        swingspeed = 6;  
        if (image_angle == start_angle) image_angle += 1;
    }
}