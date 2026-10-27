// === УСЛОВИЕ ===
condition_type  = TRIGGER_CONDITION.ENTER_TRIGGER_ZONE;
target_zone_uid = 2;

// === ДЕЙСТВИЕ ===
actions = [
    {
        type: TRIGGER_ACTION.SPAWN,
        delay: 200,
        spawn_x: 1488, spawn_y: 1530,
        spawn_object: objEnemyColombian,
        spawn_skin:   SKIN.COLOMBIANREGULAR,
        spawn_class:  CLASS.REGULAR,
        spawn_faction: FACTION.COLOMBIAN,
        spawn_weapon: WEAPONS.PISTOL,
        spawn_ammo:   15,
        spawn_state:  STATES.SEARCH,
		spawn_infinite_search: true,
        target_x: -1,
        target_y: -1
    }
];