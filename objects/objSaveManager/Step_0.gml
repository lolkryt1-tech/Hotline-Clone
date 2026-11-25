// Обновление уведомления
scrQuickSaveNotificationStep();


// Быстрое сохранение
if (scrBindCheckPressed("quick_save"))
{
    if (instance_exists(objPlayer))
    {
        scrSaveGame(true);

        if (file_exists("quick_save.dat"))
        {
            scrQuickSaveNotificationShow();
        }
    }
}


// Быстрая загрузка
if (scrBindCheckPressed("quick_load"))
{
    scrQuickSaveNotificationHide();

    global.total_restarts++;
    scrLoadGame(false, true);
}


// Чистый моментальный рестарт без задержек по кнопке R
if (scrBindCheckPressed("restart"))
{
    scrQuickSaveNotificationHide();

    global.total_restarts++;
    scrLoadGame(false); // Перезапуск текущей комнаты
}