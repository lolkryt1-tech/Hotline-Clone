// --- СОБЫТИЕ COLLISION ДВЕРИ objFloorTranslator С ИГРОКОМ ---
if (is_unlocked == true && trigger_delay <= 0)
{
    // 1. Сохраняем текущую комнату, пока индекс еще старый
    scrSaveGame(); 
	
    // 2. Перелистываем блокнот на индекс ТОЙ комнаты, куда мы летим
    global.current_level.current_floor = target_floor_index; 
    
    // 3. Задаем координаты спавна
    global.next_player_x = target_x;
    global.next_player_y = target_y;
    
    // 4. Прыгаем в следующую комнату
    room_goto(target_room);
}
