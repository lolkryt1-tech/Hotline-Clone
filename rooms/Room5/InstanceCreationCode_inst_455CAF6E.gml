// === УСЛОВИЕ ===
condition_type   = TRIGGER_CONDITION.ENTER_FLOOR;

// === ДЕЙСТВИЯ ===
actions = [
	{
		delay: 60,
		
		type: TRIGGER_ACTION.CHANGE_ENEMY_STATE,
        target_uid: 1, 
        new_state: STATES.INVESTIGATE,
        set_target: true,
        target_x: 777, target_y: 330,
        reset_target: false
	}
];