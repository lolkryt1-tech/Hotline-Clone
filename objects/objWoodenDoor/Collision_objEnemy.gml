// =========================================================================
// 0. ПРОВЕРКА ДЛЯ ДОДЖЕРА: Если он стоит на месте (скорость равна нулю) —
// дверь полностью игнорирует его тело и проходит насквозь без коллизии
// =========================================================================
if (other.class == CLASS.DODGER && other.current_speed == 0)
{
    return; // Мгновенный выход, дверь не тормозит и не реагирует на него
}

// =========================================================================
// 1. ЖЕСТКИЙ СЦЕНАРИЙ: Дверь летит на высокой скорости от толчка игрока или пули
// =========================================================================
if (abs(swingspeed) > 3.5 && (swinger == 1 || swinger == 0)) 
{
	// Сбиваем с ног КЛАССЫ, которые восприимчивы к удару дверью
	if (other.class == CLASS.REGULAR || other.class == CLASS.VEST)
	{
		objEffector.shake = 5;
		
		var _enemy = other.id;
		
		// Направление, куда отлетает враг от удара створки двери
		var _hit_dir = image_angle + (swingspeed > 0 ? -90 : 90);
        
        // Вызываем ваш чистый хит-скрипт для нокаута
		scrEnemyGetHitMelee(_enemy, WEAPONS.UNARMED, _hit_dir - 180, id);
		
		return; 
	}
	else
	{
		// Если это бегущий Dodger/Fat, дверь просто отскакивает от его тела
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
// 2. ВОЗВРАЩЕНО: АККУРАТНЫЙ СЦЕНАРИЙ — Враг наступает на дверь и мягко её толкает
// =========================================================================
else 
{
    // Если дверь уже открывается с достаточной скоростью, не пересчитываем толчок
    if (abs(swingspeed) > 2) return; 
    
    // Ставим отметку, что дверь взаимодействует с врагом
    swinger = 2; 

    // Звук мягкого открытия
    if (abs(swingspeed) < 0.5 && asset_get_index("sndDoorOpen") != -1) 
    {
        audio_play_sound(sndDoorOpen, 0, false);
    }

    // Вычисляем вектор от петли двери до шагающего врага
    var _to_enemy_x = other.x - x;
    var _to_enemy_y = other.y - y;

    var _enemy_dir = point_direction(0, 0, _to_enemy_x, _to_enemy_y);
    var _angle_diff = angle_difference(_enemy_dir, image_angle);

    // Даем двери базовый толчок вперед, чтобы враг мог беспрепятственно пройти
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
