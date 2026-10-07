function scrPlayerMovementPhysics(_input_vector)
{
    var _max_speed = 3.0;
    
    // === НАСТРОЙКА МИКРО-ПЛАВНОСТИ ===
    // Чем ближе к 1.0, тем резче старт и стоп. 
    // 0.45 — идеальный баланс: разгон за 2 кадра, но движения больше не "деревянные"
    var _accel_factor = 0.45; 

    // 1. Считаем идеальную целевую скорость на основе ввода
    var _target_hor = _input_vector.x * _max_speed;
    var _target_ver = _input_vector.y * _max_speed;

    // Защита от быстрой ходьбы по диагонали (нормализация)
    if (_input_vector.x != 0 && _input_vector.y != 0)
    {
        _target_hor = _input_vector.x * (_max_speed * 0.9071);
        _target_ver = _input_vector.y * (_max_speed * 0.9071);
    }

    // 2. МИКРО-РАЗГОН И МИКРО-ТОРМОЖЕНИЕ ЧЕРЕЗ LERP
    // Плавное, но мгновенное подтягивание текущей скорости к целевой
    hor_velocity = lerp(hor_velocity, _target_hor, _accel_factor);
    ver_velocity = lerp(ver_velocity, _target_ver, _accel_factor);

    // 3. Жесткое отрезание остаточного микро-скольжения для идеального стопа
    if (_input_vector.x == 0 && abs(hor_velocity) < 0.1) hor_velocity = 0;
    if (_input_vector.y == 0 && abs(ver_velocity) < 0.1) ver_velocity = 0;

    // 4. Движение и коллизии
    move_and_collide(hor_velocity, ver_velocity, objSolid);
	
    velocity = new Vector2(hor_velocity, ver_velocity);
}
