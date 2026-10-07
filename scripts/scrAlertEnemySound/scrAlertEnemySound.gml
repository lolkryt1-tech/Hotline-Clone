function scrAlertEnemySound(_source_x, _source_y, _radius)
{
	// Проверяем всех врагов
	with (objEnemy)
	{
		// Игнорируем тех, не патрулирует и не может слышать
		if (state != STATES.STEP || can_hear == false) continue
		
		// Проверяем, входит ли этот конкретный враг в радиус слышимости выстрела
		if (point_distance(x, y, _source_x, _source_y) <= _radius)
		{
			// Записываем координаты шума в память врага
			noise_x = _source_x;
			noise_y = _source_y;
			
			// Переключаем его состояние на расследование!
			state = STATES.INVESTIGATE;
		}
	}
}