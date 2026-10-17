// --- СОБЫТИЕ COLLISION ДВЕРИ objFloorTranslator С ИГРОКОМ ---
if (is_unlocked == true && trigger_delay <= 0 && wait_timer <= 0)
{
	// Зануляем всё
	global.blood_render_counter = 8000;
	global.decals_render_counter = 6000;
	global.body_render_counter = 4000;
	global.solide_render_counter = 0;
	global.knocked_render_counter = -1000;
	global.weapon_render_counter = -3000;
	global.player_render_counter = -6000;
	global.walls_render_counter = 0;
	global.corners_render_counter = 0;
	global.high_object_render_counter = 0;
	
	
    // 1. Сохраняем текущую комнату, пока индекс еще старый
    scrSaveGame(); 
	
    // 2. Перелистываем блокнот на индекс ТОЙ комнаты, куда мы летим
    global.current_level.current_floor = target_floor_index; 
    
    // 3. Задаем координаты спавна
    global.next_player_x = target_x;
    global.next_player_y = target_y;
	
	global.next_effector_x = target_x;
	global.next_effector_y = target_y;
	
	//with (objDecals) { scrDrawBlood(); }
    
    // 4. Прыгаем в следующую комнату
    room_goto(target_room);
}
