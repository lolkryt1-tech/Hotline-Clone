// === УСЛОВИЕ ===
condition_type   = TRIGGER_CONDITION.ENEMY_DEATH;
target_enemy_uid = 1;

// === ДЕЙСТВИЯ ===
actions = [
    
    // 3. СПАВН ВРАГА, ИДЁТ INVESTIGATE К ИГРОКУ
    {
        type: TRIGGER_ACTION.SPAWN,
        spawn_x: 1028, spawn_y: 527,
        spawn_object: objEnemyColombian,
		spawn_faction: FACTION.COLOMBIAN,
        spawn_skin:   SKIN.COLOMBIANREGULAR,
        spawn_class:  CLASS.REGULAR,
        spawn_weapon: WEAPONS.PISTOL,
        spawn_ammo:   15,
        spawn_state:  STATES.INVESTIGATE,
        target_x: 600, target_y: 460
    }
];