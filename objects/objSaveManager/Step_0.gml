// Чистый моментальный рестарт без задержек по кнопке R
if (keyboard_check_pressed(ord("R"))) 
{
	global.total_restarts++;
    scrLoadGame(false);  // Перезапуск текущей комнаты
}