if (global.hard == false) { instance_destroy(); }

// === УСЛОВИЕ ===
condition_type   = TRIGGER_CONDITION.ENEMY_DEATH;
target_enemy_uid = 5;

// === ДЕЙСТВИЯ ===
actions = [
    // 1. ТЬМА РАСТВОРЯЕТСЯ
    {
        type: TRIGGER_ACTION.FADE_OUT_DARKNESS,
        target_uid: 5
    },
    
    // 2. ОТКРЫВАЕТСЯ ДВЕРЬ
    {
        type: TRIGGER_ACTION.OPEN_DOOR,
        target_uid: 5
    },
    
    // 3. СПАВН ВРАГА
    {
        type: TRIGGER_ACTION.SPAWN,
        spawn_x: 400, spawn_y: 465,
		enemy_preset: ENEMY_PRESET.COLOMBIANREGULAR,
        spawn_weapon: WEAPONS.PISTOL,
        spawn_ammo:   15,
        spawn_state:  STATES.SEARCH,
		spawn_infinite_search: true,
        target_x: -1, target_y: -1
    }
];