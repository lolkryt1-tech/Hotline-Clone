// =========================================================================
// 0. ЗАЩИТА ВО ВРЕМЯ ЗАГРУЗКИ
// =========================================================================

if (variable_global_exists("is_cleaning_level") && global.is_cleaning_level)
{
    exit;
}

// При смене комнаты начинаем отслеживание заново
if (tracked_room != room)
{
    tracked_room = room;
    floor_had_enemies = false;
}


// =========================================================================
// 1. ПРОВЕРКА ВРАГОВ
// =========================================================================

var _current_idx = global.current_level.current_floor;

var _has_enemies =
    instance_exists(objEnemy) ||
    instance_exists(objEnemyKnockedOut) ||
    instance_exists(objEnemyKnockedOutLean);

if (_has_enemies)
{
    floor_had_enemies = true;
}


// =========================================================================
// 2. ПРОВЕРКА ВРАЖЕСКИХ ПУЛЬ
// =========================================================================

var _has_enemy_bullets = false;

with (objBullet)
{
    if (faction != FACTION.PLAYER)
    {
        _has_enemy_bullets = true;
        break;
    }
}


// =========================================================================
// 3. ПРОВЕРКА НЕЗАВЕРШЁННЫХ ТРИГГЕРОВ
// =========================================================================

var _has_pending_triggers = false;
var _has_any_pending_triggers = false;

with (objTriggerAction)
{
    // 1. Запущенная цепочка блокирует вообще всё
    if (is_firing)
    {
        _has_pending_triggers = true;
        _has_any_pending_triggers = true;
        continue;
    }

    // 2. Сработавшие или неважные триггеры полностью игнорируем
    if (is_triggered || !blocks_floor_clear)
    {
        continue;
    }

    // 3. Любой такой триггер (включая FLOOR_CLEARED) блокирует уровень
    _has_any_pending_triggers = true;

    // 4. Но текущий этаж блокируется только если это НЕ FLOOR_CLEARED
    if (condition_type != TRIGGER_CONDITION.FLOOR_CLEARED)
    {
        _has_pending_triggers = true;
    }
}


// =========================================================================
// 4. ИТОГОВАЯ ПРОВЕРКА ЗАЧИСТКИ ЭТАЖА
// =========================================================================

var _floor_is_safe =
    !_has_enemies &&
    !_has_enemy_bullets &&
    !_has_pending_triggers;

global.current_level.floors[_current_idx].is_cleared = _floor_is_safe;


// =========================================================================
// 5. ПРОВЕРКА ЗАЧИСТКИ ВСЕГО ЗДАНИЯ
// =========================================================================
if (global.current_level.total_triggers == 0) { global.current_level.all_triggers_complete = true; }


var _all_building_cleared = true;
var _total_floors = global.current_level.total_floors;

for (var i = 0; i < _total_floors; i++)
{
    if (!global.current_level.floors[i].is_cleared)
    {
        _all_building_cleared = false;
        break;
    }
}

global.current_level.trigger_go_to_car = _all_building_cleared;
global.current_level.level_fully_cleared = _all_building_cleared && global.current_level.all_triggers_complete = true;

// =========================================================================
// 6. СПАВН НАДПИСИ ЗАЧИСТКИ
// =========================================================================

// Надпись появляется только после реальной волны врагов
if (floor_had_enemies && _floor_is_safe)
{
	var _text_to_spaw = objFloorCleared;
	
	if (global.current_level.level_fully_cleared) _text_to_spaw = objLevelCleared;
	
    instance_create_layer(0, 0, "Instances", _text_to_spaw);

    floor_had_enemies = false;
}


// =========================================================================
// 7. АНИМАЦИЯ НАДПИСИ GO TO CAR
// =========================================================================

// Если игрока нет —  запрещаем надписи появляться
if (!instance_exists(objPlayer)) 
{ 
    global.current_level.trigger_go_to_car = false; 
}

// Плавно ведём альфу к цели
var _target_alpha = (global.current_level.trigger_go_to_car) ? 1.0 : 0.0;
go_to_car_alpha = lerp(go_to_car_alpha, _target_alpha, 0.05);

// Округляем, чтобы не было вечных микро-значений (например, 0.00001)
if (go_to_car_alpha < 0.01 && _target_alpha == 0.0) 
{
    go_to_car_alpha = 0.0;
}