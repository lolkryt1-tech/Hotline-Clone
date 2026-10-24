// === УСЛОВИЕ ===
condition_type   = TRIGGER_CONDITION.ENEMY_DEATH;
target_enemy_uid = 7;

// === ДЕЙСТВИЯ ===
actions = [
 {
        type: TRIGGER_ACTION.SPAWN,
        delay: 40,
        spawn_x: 350, spawn_y: 220,
        spawn_object: objEnemyColombian,
        spawn_skin:   SKIN.COLOMBIANREGULAR,
        spawn_class:  CLASS.REGULAR,
        spawn_faction: FACTION.COLOMBIAN,
        spawn_weapon: WEAPONS.PISTOL,
        spawn_ammo:   15,
        spawn_state:  STATES.INVESTIGATE,
        target_x: 1000, target_y: 360
    },
    {
        type: TRIGGER_ACTION.SPAWN,
        delay: 40,   // ещё 3 секунды (итого 7 сек)
        spawn_x: 350, spawn_y: 220,
        spawn_object: objEnemyColombian,
        spawn_skin:   SKIN.COLOMBIANREGULAR,
        spawn_class:  CLASS.REGULAR,
        spawn_faction: FACTION.COLOMBIAN,
        spawn_weapon: WEAPONS.M16,
        spawn_ammo:   0,
        spawn_state:  STATES.INVESTIGATE,
        target_x: 1000, target_y: 360
    },
    {
        type: TRIGGER_ACTION.SPAWN,
        delay: 40,   // ещё 3 секунды (итого 10 сек)
        spawn_x: 350, spawn_y: 200,
        spawn_object: objEnemyColombianFat,
        spawn_skin:   SKIN.COLOMBIANFAT,
        spawn_class:  CLASS.FAT,
        spawn_faction: FACTION.COLOMBIAN,
        spawn_weapon: WEAPONS.SHOTGUN,
        spawn_ammo:   6,
        spawn_state:  STATES.INVESTIGATE,
        target_x: 1000, target_y: 360
    }
];