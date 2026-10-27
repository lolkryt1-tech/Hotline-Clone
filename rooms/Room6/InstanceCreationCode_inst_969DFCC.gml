// === УСЛОВИЕ ===
condition_type  = TRIGGER_CONDITION.ENTER_TRIGGER_ZONE;
target_zone_uid = 1;

// === ДЕЙСТВИЕ ===
actions = [
    {
        type: TRIGGER_ACTION.SPAWN,
        delay: 180,
        spawn_x: 350, spawn_y: 220,
        spawn_object: objEnemyColombian,
        spawn_skin:   SKIN.COLOMBIANREGULAR,
        spawn_class:  CLASS.REGULAR,
        spawn_faction: FACTION.COLOMBIAN,
        spawn_weapon: WEAPONS.PISTOL,
        spawn_ammo:   15,
        spawn_state:  STATES.SEARCH,
		spawn_infinite_search: true,
        target_x: -1,
        target_y: -1
    },
    {
        type: TRIGGER_ACTION.SPAWN,
        delay: 180,   // ещё 3 секунды (итого 7 сек)
        spawn_x: 350, spawn_y: 220,
        spawn_object: objEnemyColombian,
        spawn_skin:   SKIN.COLOMBIANREGULAR,
        spawn_class:  CLASS.REGULAR,
        spawn_faction: FACTION.COLOMBIAN,
        spawn_weapon: WEAPONS.PIPE,
        spawn_ammo:   0,
        spawn_state:  STATES.SEARCH,
		spawn_infinite_search: true,
        target_x: -1,
        target_y: -1
    },
    {
        type: TRIGGER_ACTION.CHANGE_ENEMY_STATE,
        delay: 0,                 // сразу после второго действия
        target_uid: 5,            // uid врага, которому меняем стейт
        new_state: STATES.INVESTIGATE,  // новое состояние
        set_target: true,         // задать цель
        target_x: -1,             // -1 = координаты игрока
        target_y: -1,
        reset_target: false
    },
    {
        type: TRIGGER_ACTION.SPAWN,
        delay: 180,   // ещё 3 секунды (итого 10 сек)
        spawn_x: 350, spawn_y: 200,
        spawn_object: objEnemyColombianFat,
        spawn_skin:   SKIN.COLOMBIANFAT,
        spawn_class:  CLASS.FAT,
        spawn_faction: FACTION.COLOMBIAN,
        spawn_weapon: WEAPONS.SHOTGUN,
        spawn_ammo:   6,
        spawn_state:  STATES.SEARCH,
        spawn_infinite_search: true,
        target_x: -1,
        target_y: -1
    }
];