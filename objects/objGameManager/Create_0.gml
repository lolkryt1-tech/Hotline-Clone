// === ИНИЦИАЛИЗАЦИЯ ТЕКУЩЕЙ МИССИИ ===
// global.current_mission — индекс текущей миссии (0, 1, 2...)
global.current_mission = 0;

// Загружаем данные миссии из скрипта
global.current_level = scrGetLevelData(global.current_mission);

// Добавляем runtime-переменные, которых нет в scrGetLevelData
global.current_level.current_floor = 0;
global.current_level.trigger_go_to_car = false;

go_to_car_alpha = 0.0;