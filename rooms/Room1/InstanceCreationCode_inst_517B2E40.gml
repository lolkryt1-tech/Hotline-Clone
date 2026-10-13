// === УСЛОВИЕ ===
condition_type   = TRIGGER_CONDITION.ENEMY_DEATH;
target_enemy_uid = 5;

// === ДЕЙСТВИЯ ===
actions = [
    // 1. ТЬМА РАСТВОРЯЕТСЯ
    {
        type: TRIGGER_ACTION.FADE_OUT_DARKNESS,
        target_uid: 1
    },
    
    // 2. ОТКРЫВАЕТСЯ ДВЕРЬ
    {
        type: TRIGGER_ACTION.OPEN_DOOR,
        target_uid: 2
    },
    
    // 3. СПАВН ВРАГА, ИДЁТ INVESTIGATE К ИГРОКУ
    {
        type: TRIGGER_ACTION.SPAWN,
        spawn_x: 1709, spawn_y: 1424,
        spawn_object: objEnemyColombianFat,
		spawn_faction: FACTION.COLOMBIAN,
        spawn_skin:   SKIN.COLOMBIANFAT,
        spawn_class:  CLASS.FAT,
        spawn_weapon: WEAPONS.PISTOL,
        spawn_ammo:   15,
        spawn_state:  STATES.INVESTIGATE,
        target_x: -1, target_y: -1
    }
];