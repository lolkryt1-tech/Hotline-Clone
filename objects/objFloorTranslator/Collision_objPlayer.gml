// Событие Collision объекта objTranslator с objPlayer

// Переходим, только если уровень зачищен И прошел таймер защиты от спавна
if (is_unlocked == true && trigger_delay <= 0)
{
	
	// Сохраняем состояние этажа перед выходом
	scrSaveGame();
	
    // Задаем координаты спавна для СЛЕДУЮЩЕГО этажа
    global.next_player_x = target_x;
    global.next_player_y = target_y;
    
    
    room_goto(target_room);
}
