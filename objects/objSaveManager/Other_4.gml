// В событии Room Start объекта objSaveManager (или вашего контроллера)

var _file_name = room_get_name(room) + ".dat";

// 1. Если файл этой комнаты УЖЕ существует (мы вернулись сюда назад через дверь из старших этажей)
if (file_exists(_file_name))
{
    scrLoadGame(true); // Загружаем этаж из буфера (со всеми убитыми врагами)
    
	
    // Переносим игрока к двери, через которую он вернулся назад
    objPlayer.x              = global.next_player_x;
    objPlayer.y              = global.next_player_y;
	
	
	scrSaveGame();
}
// 2. Если мы зашли на этот этаж ВПЕРВЫЕ (файла .dat еще нет)
else
{
    objPlayer.x              = global.next_player_x;
    objPlayer.y              = global.next_player_y;
	
    scrSaveGame(); 
}

// Намертво очищаем данные переходов, чтобы кнопка R о них не знала
global.next_player_x = undefined;
global.next_player_y = undefined;
