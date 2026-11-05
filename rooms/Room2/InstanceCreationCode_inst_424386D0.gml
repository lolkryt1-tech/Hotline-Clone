if (global.hard == false) { instance_destroy(); }

// === УСЛОВИЕ ===
condition_type     = TRIGGER_CONDITION.FLOOR_CLEARED;
target_floor_index = 5;

// === ДЕЙСТВИЯ ===
actions = [
    {
        type: TRIGGER_ACTION.UNLOCK_FLOOR_TRANSITION,
        target_uid: 1
    },

    {
        type: TRIGGER_ACTION.SPAWN,
        enemy_preset: ENEMY_PRESET.COLOMBIANREGULAR,

        spawn_x: 590,
        spawn_y: 400,

        spawn_weapon: WEAPONS.SHOTGUN,
        spawn_ammo: 6,
        spawn_state: STATES.SEARCH,
		spawn_infinite_search: true,

        target_x: -1,
        target_y: -1
    },

    {
        type: TRIGGER_ACTION.SPAWN,
        enemy_preset: ENEMY_PRESET.COLOMBIANREGULAR,

        spawn_x: 700,
        spawn_y: 400,

        spawn_weapon: WEAPONS.M16,
        spawn_ammo: 24,
        spawn_state: STATES.SEARCH,
		spawn_infinite_search: true,

        target_x: -1,
        target_y: -1
    },

    {
        type: TRIGGER_ACTION.SPAWN,
        enemy_preset: ENEMY_PRESET.COLOMBIANFAT,

        spawn_x: 645,
        spawn_y: 340,

        spawn_weapon: WEAPONS.SHOTGUN,
        spawn_ammo: 6,
        spawn_state: STATES.SEARCH,
		spawn_infinite_search: true,

        target_x: -1,
        target_y: -1
    },
	
	
	// Группа с лестницы
	{
		delay: 120,
        type: TRIGGER_ACTION.SPAWN,
        enemy_preset: ENEMY_PRESET.COLOMBIANFAT,

        spawn_x: 800,
        spawn_y: 870,

        spawn_weapon: WEAPONS.SHOTGUN,
        spawn_ammo: 6,
        spawn_state: STATES.SEARCH,
		spawn_infinite_search: true,

        target_x: -1,
        target_y: -1
    },
	
	{
		delay: 60,
        type: TRIGGER_ACTION.SPAWN,
        enemy_preset: ENEMY_PRESET.COLOMBIANREGULAR,

        spawn_x: 800,
        spawn_y: 870,

        spawn_weapon: WEAPONS.M16,
        spawn_ammo: 24,
        spawn_state: STATES.SEARCH,
		spawn_infinite_search: true,

        target_x: -1,
        target_y: -1
    },
	
	{
		delay: 60,
        type: TRIGGER_ACTION.SPAWN,
        enemy_preset: ENEMY_PRESET.COLOMBIANDODGER,

        spawn_x: 800,
        spawn_y: 870,

        spawn_weapon: WEAPONS.PISTOL,
        spawn_ammo: 15,
        spawn_state: STATES.SEARCH,
		spawn_infinite_search: true,

        target_x: -1,
        target_y: -1
    },
	
	{
		delay: 60,
        type: TRIGGER_ACTION.SPAWN,
        enemy_preset: ENEMY_PRESET.COLOMBIANREGULAR,

        spawn_x: 800,
        spawn_y: 870,

        spawn_weapon: WEAPONS.KNIFE,
        spawn_ammo: 0,
        spawn_state: STATES.SEARCH,
		spawn_infinite_search: true,

        target_x: -1,
        target_y: -1
    },
];