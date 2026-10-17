/// === ЭНУМЫ ===
enum TRIGGER_CONDITION {
    ENEMY_DEATH,          // конкретный враг умер
    ENEMIES_COUNT_DEATH,  // N врагов умерло
    ENEMIES_ALL_CLEARED,  // все враги мертвы
    PLAYER_ENTER_ZONE,    // игрок вошёл в зону
    FLOOR_CLEARED         // указанный этаж зачищен
}

enum TRIGGER_ACTION {
    SPAWN,						// спавн одного врага
    SPAWN_GROUP,				// спавн группы врагов
    OPEN_DOOR,					// открыть дверь
    CLOSE_DOOR,					// закрыть дверь
    FADE_OUT_DARKNESS,			// тьма исчезает
    FADE_IN_DARKNESS,			// тьма появляется
	CHANGE_ENEMY_STATE,			// Изменить состояние врага
	UNLOCK_FLOOR_TRANSITION,	// Открыть переход на этаж
    DIALOG,						// задел
    TRANSITION,					// задел
    SCRIPT						// задел
}

/// === ОСНОВНЫЕ ПЕРЕМЕННЫЕ ===
trigger_id   = (x * 100000) + y;
is_triggered = false;

/// === УСЛОВИЕ ===
condition_type       = TRIGGER_CONDITION.ENEMY_DEATH;
target_enemy_uid     = -1;
target_enemies_count = 0;
zone_radius          = 32;
target_floor_index   = -1;

/// === ДЕЙСТВИЯ ===
/// Массив структур. Каждый элемент — своя структура с полем `type`.
/// Примеры:
/// { type: TRIGGER_ACTION.OPEN_DOOR,          target_object: objWoodenDoor }
/// { type: TRIGGER_ACTION.FADE_OUT_DARKNESS,  target_object: objDarkness }
/// { type: TRIGGER_ACTION.SPAWN_GROUP,        spawn_group: [ ... ] }
/// { type: TRIGGER_ACTION.SPAWN,              spawn_x: .., spawn_y: .., spawn_object: .., ... }
actions = [];

/// === ПАРАМЕТРЫ ОДИНОЧНОГО СПАВНА (шаблон) ===
spawn_object	= objEnemyColombian;
spawn_skin		= SKIN.COLOMBIANREGULAR;
spawn_faction	= FACTION.COLOMBIAN;
spawn_class		= CLASS.REGULAR;
spawn_weapon	= WEAPONS.PIPE;
spawn_ammo		= 0;
spawn_state		= STATES.INVESTIGATE;
spawn_x			= x;
spawn_y			= y;
target_x		= x;
target_y		= y;