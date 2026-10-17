function scrEnemyPatrolStep()
{
    // =========================================================================
    // 0. ИНИЦИАЛИЗАЦИЯ И ВЫРАВНИВАНИЕ
    // =========================================================================
    if (patrol_dir == 0 && my_angle != 0)
    {
        patrol_dir = my_angle;
    }

    if (patrol_dir % 90 != 0)
    {
        patrol_dir = round(patrol_dir / 90) * 90;
    }
    
    if (patrol_dir >= 360) patrol_dir -= 360;
    if (patrol_dir < 0)   patrol_dir += 360;

    // =========================================================================
    // 1. РАСЧЁТ СКОРОСТИ И ВИРТУАЛЬНОГО СДВИГА (BOXCAST)
    // =========================================================================
    var _walk_speed = max_speed * 0.4; 

    // Зазор упреждения: на сколько пикселей вперед МАСКОЙ МЫ СМОТРИМ
    // 6-8 пикселей идеальны, так как проверяется В СЮ ШИРИНУ хитбокса
    var _look_ahead_dist = 4; 

    // Вычисляем виртуальную позицию, где враг окажется через мгновение
    var _future_x = x + lengthdir_x(_look_ahead_dist, patrol_dir);
    var _future_y = y + lengthdir_y(_look_ahead_dist, patrol_dir);

    // =========================================================================
    // 2. ОБЪЕМНАЯ ПРОВЕРКА (BOXCAST) НА СТЕНЫ И ДВЕРИ
    // =========================================================================
    var _path_blocked = false;

    // А) Проверяем стены всей маской врага
    if (place_meeting(_future_x, _future_y, objSolid))
    {
        _path_blocked = true;
    }

    // Б) Проверяем закрытые двери всей маской врага
    if (!_path_blocked)
    {
        // Ищем, с какой конкретно дверью пересечется наша маска в будущем
        var _door = instance_place(_future_x, _future_y, objDoor);
        if (_door != noone)
        {
            _path_blocked = true;
        }
    }

    // =========================================================================
    // 3. ПОВОРОТ ПРИ ОБНАРУЖЕНИИ ПРЕПЯТСТВИЯ
    // =========================================================================
    if (_path_blocked)
    {
        patrol_dir += 90;
        if (patrol_dir >= 360) patrol_dir -= 360;
    }

    // Пересчитываем реальную скорость для текущего кадра после проверки
    var _vel_x = lengthdir_x(_walk_speed, patrol_dir);
    var _vel_y = lengthdir_y(_walk_speed, patrol_dir);

    // =========================================================================
    // 4. ФИЗИЧЕСКОЕ ПЕРЕМЕЩЕНИЕ И СИНХРОНИЗАЦИЯ
    // =========================================================================
    // Двигаемся встроенным move_and_collide, двери держим в массиве коллизий
    var _collisions = move_and_collide(_vel_x, _vel_y, [objSolid, objDoor]);

    if (array_length(_collisions) > 0)
    {
        patrol_dir += 90;
        if (patrol_dir >= 360) patrol_dir -= 360;
    }

    direction     = patrol_dir;
    desired_angle = patrol_dir;
    target_speed  = _walk_speed; 
    speed         = 0; 
}
