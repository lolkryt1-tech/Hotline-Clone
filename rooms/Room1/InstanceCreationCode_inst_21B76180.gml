condition_type   = TRIGGER_CONDITION.ENEMY_DEATH;
target_enemy_uid = 6;

actions = [
    {
        type: TRIGGER_ACTION.CHANGE_ENEMY_STATE,
        target_uid: 10,
        new_state:  STATES.INVESTIGATE,
        set_target: true,
        target_x:   -1,       // ← позиция игрока
        target_y:   -1,
        reset_target: true
    }
];