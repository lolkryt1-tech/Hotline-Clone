function scrEnemyChangeMask()
{
	try_get_mask_timer = 30;
	
	// Вычисляем границы квадрата (отнимаем и прибавляем по 16 пикселей от центра)
	var _left   = x - 16;
	var _top    = y - 16;
	var _right  = x + 16;
	var _bottom = y + 16;

	// Проверяем стены в этом квадрате
	if (collision_rectangle(_left, _top, _right, _bottom, objSolid, false, true) != noone) 
	{
	    mask_index = sprPlayerMask; // Стены рядом — уменьшаем маску
	} 
	else 
	{
	    mask_index = sprEnemyMask;  // Вокруг пусто — увеличиваем маску для урона
	}
}