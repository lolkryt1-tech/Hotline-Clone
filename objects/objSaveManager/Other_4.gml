// В событии Room Start объекта objSaveManager

// 1. Принудительно определяем этаж по имени комнаты (не зависим от objGameManager)
var _current_room_name = room_get_name(room);
for (var i = 0; i < global.current_level.total_floors; i++)
{
    if (global.current_level.floors[i].room_name == _current_room_name)
    {
        global.current_level.current_floor = i;
        break;
    }
}

var _file_name = scrGetSaveFileName();

// 2. Если файл этой комнаты УЖЕ существует (мы вернулись сюда назад через дверь)
if (file_exists(_file_name))
{
    scrLoadGame(true);
    
    objPlayer.x = global.next_player_x;
    objPlayer.y = global.next_player_y;
	
	objEffector.x = global.next_effector_x;
	objEffector.y = global.next_effector_y;
    
    scrSaveGame();
}
// 3. Если мы зашли на этот этаж ВПЕРВЫЕ (файла .dat еще нет)
else
{
    objPlayer.x = global.next_player_x;
    objPlayer.y = global.next_player_y;
    
    scrSaveGame(); 
}

// 4. Намертво очищаем данные переходов, чтобы кнопка R о них не знала
global.next_player_x = undefined;
global.next_player_y = undefined;