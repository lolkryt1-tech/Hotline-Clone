// === УСЛОВИЕ ===
condition_type     = TRIGGER_CONDITION.FLOOR_CLEARED;
target_floor_index = 2;   // ← проверь индекс

// === ДЕЙСТВИЯ ===
actions = [
    {
        type: TRIGGER_ACTION.SPAWN_GROUP,
        spawn_group: [
            {
                spawn_x: 940, spawn_y: 350,
                spawn_object: objEnemyColombianDodger,
                spawn_skin:   SKIN.COLOMBIANDODGER,
                spawn_class:  CLASS.DODGER,
                spawn_weapon: WEAPONS.PISTOL,
                spawn_ammo:   15,
                spawn_state:  STATES.STEP,
                target_x: -1, target_y: -1
            },
            {
                spawn_x: 560, spawn_y: 370,
                spawn_object: objEnemyColombian,
                spawn_skin:   SKIN.COLOMBIANREGULAR,
                spawn_class:  CLASS.REGULAR,
                spawn_weapon: WEAPONS.PIPE,
                spawn_ammo:   0,
                spawn_state:  STATES.STEP,
                target_x: -1, target_y: -1
            },
            {
                spawn_x: 1030, spawn_y: 420,
                spawn_object: objEnemyColombianFat,
                spawn_skin:   SKIN.COLOMBIANFAT,
                spawn_class:  CLASS.FAT,
                spawn_weapon: WEAPONS.SHOTGUN,
                spawn_ammo:   6,
                spawn_state:  STATES.INVESTIGATE,
                target_x: -1, target_y: -1
            }
        ]
    }
];