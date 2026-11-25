// === УСЛОВИЕ ===
condition_type   = TRIGGER_CONDITION.ENEMY_DEATH;
target_enemy_uid = 1;

// === ДЕЙСТВИЯ ===
actions = [
    
    // 3. СПАВН ВРАГА, ИДЁТ INVESTIGATE К ИГРОКУ
    {
        type: TRIGGER_ACTION.SPAWN,
        spawn_x: 1028, spawn_y: 527,
		enemy_preset: ENEMY_PRESET.COLOMBIANREGULAR,
        spawn_weapon: WEAPONS.PISTOL,
        spawn_ammo:   15,
        spawn_state:  STATES.INVESTIGATE,
        spawn_infinite_search: true,
        target_x: -1,
        target_y: -1
    }
];