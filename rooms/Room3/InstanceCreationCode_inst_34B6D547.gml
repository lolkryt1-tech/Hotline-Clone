// === УСЛОВИЕ ===
condition_type   = TRIGGER_CONDITION.ENTER_FLOOR;

// === ДЕЙСТВИЯ ===
actions = [
	{
		type: TRIGGER_ACTION.START_MUSIC,
		trigger_sound: MUSIC_COMBAT,
		trigger_loop: true,
		trigger_fade_frames: 0
	},
	
	{
		type: TRIGGER_ACTION.SAVE
	}
];