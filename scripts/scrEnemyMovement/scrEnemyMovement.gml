function scrEnemyMovement()
{
    // 1. Плавный разгон или торможение (Твоя логика)
    var _rate = (target_speed > current_speed) ? accel : fric;
	var _rotation_speed = 0.15; 

	// 2. Если враг в состоянии атаки, значительно увеличиваем скорость поворота
	if (state == STATES.ATTACKRANGE && reload <= 0) 
	{
	    _rotation_speed = 0.45;
	}
	
	
    current_speed = lerp(current_speed, target_speed, _rate);

    // Защита от микро-движений при остановке
    if (current_speed < 0.05 && target_speed == 0) 
    {
        current_speed = 0;
    }

    // Привязка к путям GameMaker (если они используются)
    if (path_index != -1) 
    {
        path_speed = current_speed;
    }

    // 2. Логика поворотов и анимации тела
    if (state != STATES.ATTACKMELEE || state != STATES.ATTACKRANGE) image_index += current_speed * 0.1;
    my_angle += angle_difference(desired_angle, my_angle) * _rotation_speed;

    // 3. Анимация ног (Вызываем наш чистый скрипт дошагивания)
    scrEnemyLegs();

    // 4. Физическая проверка на застревание в стенах
    in_wall = place_meeting(x, y, objSolid); // Убрал тернарный оператор, place_meeting и так возвращает true/false
}