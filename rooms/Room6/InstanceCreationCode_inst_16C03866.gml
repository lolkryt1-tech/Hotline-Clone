// === УСЛОВИЕ ===
condition_type   = TRIGGER_CONDITION.ENEMY_DEATH;
target_enemy_uid = 6;

// === ДЕЙСТВИЯ ===
actions = [

	// 1. ТЬМА РАСТВОРЯЕТСЯ
    {
        type: TRIGGER_ACTION.FADE_OUT_DARKNESS,
        target_uid: 2
    },
    
    // 2. ОТКРЫВАЕТСЯ ДВЕРЬ
    {
        type: TRIGGER_ACTION.OPEN_DOOR,
        target_uid: 3
    },

	
	{
        type: TRIGGER_ACTION.CHANGE_ENEMY_STATE,
        target_uid: 7,             // uid врага, которому меняем стейт
        new_state: STATES.INVESTIGATE,   // новое состояние
        set_target: true,          // задать ли новую цель
        target_x: -1, target_y: -1,// -1 = координаты игрока
        reset_target: false        // сбросить ли my_target в noone
    }
];