function scrTargetUpdate(_current_target)
{
    // Если цели и так не было, то и спасать нечего
    if (_current_target == noone) return noone;
    
    // БЕЗОПАСНОСТЬ: Если объект, который был целью, ЖИВ и существует — просто возвращаем его
    if (instance_exists(_current_target)) 
    {
        return _current_target;
    }
    
    // --- ЕСЛИ МЫ ДОШЛИ СЮДА, ЗНАЧИТ ЦЕЛЬ ТОЛЬКО ЧТО УНИЧТОЖИЛИ (instance_destroy) ---
    // Игра вот-вот вылетит, если мы не подменим цель на существующий труп!
    
    // 1. Проверяем, идет ли сейчас казнь игрока
    if (instance_exists(objPlayerExecution))
    {
        return instance_nearest(x, y, objPlayerExecution); // Спасаем игру, целимся в сцену казни
    }
    
    // 2. Проверяем, остался ли обычный труп игрока
    if (instance_exists(objPlayerDead))
    {
        return instance_nearest(x, y, objPlayerDead); // Спасаем игру, целимся в труп
    }
    
    // 3. Если живого игрока и его трупов нет — проверяем, сел ли он в машину
    if (instance_exists(objPlayerCar))
    {
        return instance_nearest(x, y, objPlayerCar); // Спасаем игру, целимся в машину игрока
    }

    // Если вообще ничего не нашли (цель просто испарилась), возвращаем noone, чтобы враг остановился
    return noone; 
}
