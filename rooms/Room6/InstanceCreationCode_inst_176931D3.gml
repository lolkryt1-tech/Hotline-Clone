// === УСЛОВИЕ ===
condition_type  = TRIGGER_CONDITION.ENTER_TRIGGER_ZONE;
target_zone_uid = 2;

// === ДЕЙСТВИЯ ===
actions = [
    {
        type: TRIGGER_ACTION.CHANGE_ENEMY_STATE,
        target_uid: 2,             // uid врага, которому меняем стейт
        new_state: STATES.INVESTIGATE,   // новое состояние
        set_target: true,          // задать ли новую цель
        target_x: 850, target_y: 290,// -1 = координаты игрока
        reset_target: false        // сбросить ли my_target в noone
    },
	
	{
        type: TRIGGER_ACTION.CHANGE_ENEMY_STATE,
        target_uid: 3,             // uid врага, которому меняем стейт
        new_state: STATES.INVESTIGATE,   // новое состояние
        set_target: true,          // задать ли новую цель
        target_x: 700, target_y: 280,// -1 = координаты игрока
        reset_target: false        // сбросить ли my_target в noone
    }
];