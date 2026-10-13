// === УСЛОВИЕ ===
condition_type     = TRIGGER_CONDITION.FLOOR_CLEARED;
target_floor_index = 1;   // 1 = второй этаж (индексация с 0)

// === ДЕЙСТВИЕ ===
action_type = TRIGGER_ACTION.SPAWN_GROUP;

spawn_group = [
    {
        spawn_x: 1200, spawn_y: 1200,
        spawn_object: objEnemyColombian,
        spawn_skin:   SKIN.COLOMBIANREGULAR,
        spawn_class:  CLASS.REGULAR,
        spawn_weapon: WEAPONS.PISTOL,
        spawn_ammo:   15,
        spawn_state:  STATES.INVESTIGATE,
        target_x: -1, target_y: -1
    },
    {
        spawn_x: 1200, spawn_y: 1240,
        spawn_object: objEnemyColombian,
        spawn_skin:   SKIN.COLOMBIANREGULAR,
        spawn_class:  CLASS.REGULAR,
        spawn_weapon: WEAPONS.PIPE,
        spawn_ammo:   0,
        spawn_state:  STATES.INVESTIGATE,
        target_x: -1, target_y: -1
    },
    {
        spawn_x: 1200, spawn_y: 1260,
        spawn_object: objEnemyColombian,
        spawn_skin:   SKIN.COLOMBIANREGULAR,
        spawn_class:  CLASS.REGULAR,
        spawn_weapon: WEAPONS.SHOTGUN,
        spawn_ammo:   6,
        spawn_state:  STATES.INVESTIGATE,
        target_x: -1, target_y: -1
		
    }
];
