/// @desc Полный рестарт текущего уровня (здания)
function scrRestartLevel()
{
    // 1. Возвращаем игру из паузы (если была)
    if (instance_exists(objPauseManager))
    {
        objPauseManager.unpause_tag("Pausable");
    }
    
    // 2. Запоминаем текущую миссию — чтобы вернуться на тот же уровень
    var _saved_mission = 0;
    if (variable_global_exists("current_mission"))
    {
        _saved_mission = global.current_mission;
    }
    
    // 3. Очищаем .dat файлы всех этажей
    scrClearFloorData();
    
    // 4. Удаляем ВСЕ persistent-объекты, которые создаются в Start
    if (instance_exists(objGameManager))          instance_destroy(objGameManager);
    if (instance_exists(objPlayer))               instance_destroy(objPlayer);
    if (instance_exists(objEffector))             instance_destroy(objEffector);
    if (instance_exists(objLevelStatistic))       instance_destroy(objLevelStatistic);
    if (instance_exists(objDepthManager))         instance_destroy(objDepthManager);
    if (instance_exists(objPathManager))          instance_destroy(objPathManager);
    if (instance_exists(objSaveManager))          instance_destroy(objSaveManager);
    if (instance_exists(objBloodSurfaceManager))  instance_destroy(objBloodSurfaceManager);
	if (instance_exists(objPauseMenu))			  instance_destroy(objPauseMenu);
    if (instance_exists(objPauseManager))         instance_destroy(objPauseManager);
    
    // 5. Переходим в стартовую комнату
    room_goto(Start);
}