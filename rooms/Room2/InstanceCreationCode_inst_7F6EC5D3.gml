if (global.hard == false) { instance_destroy(); }

// === УСЛОВИЕ ===
condition_type     = TRIGGER_CONDITION.FLOOR_CLEARED;
target_floor_index = 3;

// === ДЕЙСТВИЯ ===
actions = [
    {
        type: TRIGGER_ACTION.UNLOCK_FLOOR_TRANSITION,
        target_uid: 1
    },

    {
        type: TRIGGER_ACTION.SPAWN,
        enemy_preset: ENEMY_PRESET.COLOMBIANDODGER,

        spawn_x: 650,
        spawn_y: 120,

        spawn_weapon: WEAPONS.SHOTGUN,
        spawn_ammo: 6,
        spawn_state: STATES.SEARCH,

        target_x: -1,
        target_y: -1
    },

    {
        type: TRIGGER_ACTION.SPAWN,
        enemy_preset: ENEMY_PRESET.COLOMBIANREGULAR,

        spawn_x: 670,
        spawn_y: 390,

        spawn_weapon: WEAPONS.PIPE,
        spawn_ammo: 0,
        spawn_state: STATES.STEP,

        target_x: -1,
        target_y: -1
    },

    {
        type: TRIGGER_ACTION.SPAWN,
        enemy_preset: ENEMY_PRESET.COLOMBIANFAT,

        spawn_x: 600,
        spawn_y: 520,

        spawn_weapon: WEAPONS.FISTS,
        spawn_ammo: 0,
        spawn_state: STATES.STEP,

        target_x: -1,
        target_y: -1
    }
];