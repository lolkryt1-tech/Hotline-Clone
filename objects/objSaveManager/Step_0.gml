// Чистый моментальный рестарт без задержек по кнопке R
if (keyboard_check_pressed(ord("R"))) 
{
    scrLoadGame(false);  // Перезапуск текущей комнаты
}