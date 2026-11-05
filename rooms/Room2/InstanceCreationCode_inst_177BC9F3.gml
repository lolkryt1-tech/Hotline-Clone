// === УСЛОВИЕ ===
condition_type     = TRIGGER_CONDITION.FLOOR_CLEARED;
target_floor_index = 7;

// === ДЕЙСТВИЯ ===
actions = [
    {
        type: TRIGGER_ACTION.UNLOCK_FLOOR_TRANSITION,
        target_uid: 10
    }
];