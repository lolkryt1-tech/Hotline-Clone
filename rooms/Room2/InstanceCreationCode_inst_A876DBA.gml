// === УСЛОВИЕ ===
condition_type   = TRIGGER_CONDITION.ENEMY_DEATH;
target_enemy_uid = 1;

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
        spawn_x: 810, spawn_y: 460,
        spawn_object: objEnemyColombianVest,
		spawn_faction: FACTION.COLOMBIAN,
        spawn_skin:   SKIN.COLOMBIANVEST,
        spawn_class:  CLASS.VEST,
        spawn_weapon: WEAPONS.PISTOL,
        spawn_ammo:   15,
        spawn_state:  STATES.INVESTIGATE,
        target_x: -1, target_y: -1
    }
];