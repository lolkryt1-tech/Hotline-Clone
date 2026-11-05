if (global.hard == true) { instance_destroy(); }

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
        enemy_preset: ENEMY_PRESET.COLOMBIANREGULAR,

        spawn_x: 650,
        spawn_y: 120,

        spawn_weapon: WEAPONS.PIPE,
        spawn_ammo: 0,
        spawn_state: STATES.SEARCH,

        target_x: -1,
        target_y: -1
    },

    {
        type: TRIGGER_ACTION.SPAWN,
        enemy_preset: ENEMY_PRESET.COLOMBIANREGULAR,

        spawn_x: 650,
        spawn_y: 610,

        spawn_weapon: WEAPONS.SHOTGUN,
        spawn_ammo: 6,
        spawn_state: STATES.SEARCH,

        target_x: -1,
        target_y: -1
    }
];