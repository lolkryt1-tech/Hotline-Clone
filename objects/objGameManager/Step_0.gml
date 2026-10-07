// --- ГЛОБАЛЬНЫЙ КОНТРОЛЬ ЗАЧИСТКИ ЗДАНИЯ ---

var _current_idx = global.current_level.current_floor;

// 1. Менеджер проверяет врагов на текущем экране и динамически обновляет текущую страницу блокнота
if (!instance_exists(objEnemy) && !instance_exists(objEnemyKnockedOut) && !instance_exists(objEnemyKnockedOutLean))
{
    global.current_level.floors[_current_idx].is_cleared = true;
}
else
{
    global.current_level.floors[_current_idx].is_cleared = false;
}

// 2. Менеджер сразу же проверяет: а зачищено ли абсолютно ВСЁ здание (все этажи)?
var _all_building_cleared = true;
var _total_floors = global.current_level.total_floors;

for (var i = 0; i < _total_floors; i++)
{
    if (global.current_level.floors[i].is_cleared == false)
    {
        _all_building_cleared = false;
        break; // Нашли хотя бы один незачищенный этаж — прерываем цикл проверки
    }
}

// 3. Выставляем итоговый флаг для машины на основе проверки
if (_all_building_cleared == true)
{
    global.current_level.trigger_go_to_car = true; 
}
else
{
    global.current_level.trigger_go_to_car = false;
}



// Эффект надписи
if (global.current_level.trigger_go_to_car == true)
{
    go_to_car_alpha = lerp(go_to_car_alpha, 1.0, 0.05); 
}
else
{
    go_to_car_alpha = 0.0; 
}