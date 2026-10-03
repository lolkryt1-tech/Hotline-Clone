function scrPlayerMovementPhysics(_input_vector)
{
    var _max_speed = 2.5;

    // 1. Разгон от клавиш ввода
    hor_velocity += _input_vector.x * movement_speed;
    ver_velocity += _input_vector.y * movement_speed;

    // 2. Правильное торможение (только когда клавиши НЕ зажаты)
    if (_input_vector.x == 0) hor_velocity = lerp(hor_velocity, 0, 0.25);
    if (_input_vector.y == 0) ver_velocity = lerp(ver_velocity, 0, 0.25);

    // 3. Правильное ограничение скорости во ВСЕ стороны (нормализация без багов)
    var _current_total_dist = point_distance(0, 0, hor_velocity, ver_velocity);
    if (_current_total_dist > _max_speed) 
    {
        hor_velocity = (hor_velocity / _current_total_dist) * _max_speed;
        ver_velocity = (ver_velocity / _current_total_dist) * _max_speed;
    }

    // 4. Отрезание микро-движений
    if (abs(hor_velocity) < 0.01) hor_velocity = 0;
    if (abs(ver_velocity) < 0.01) ver_velocity = 0;

    // 5. Движение и коллизии
    move_and_collide(hor_velocity, ver_velocity, objSolid);
	
    velocity = new Vector2(hor_velocity, ver_velocity);
}
