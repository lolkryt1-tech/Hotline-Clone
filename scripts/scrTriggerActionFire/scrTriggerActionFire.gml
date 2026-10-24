/// @desc Запускает цепочку действий триггера (не выполняет их сразу).
/// @param {Id} _trigger — инстанс objTriggerAction
function scrTriggerActionFire(_trigger)
{
    with (_trigger)
    {
        if (array_length(actions) == 0)
        {
            is_triggered = true;
            exit;
        }

        action_index = 0;
        action_timer = variable_struct_exists(actions[0], "delay") ? actions[0].delay : 0;
        is_firing    = true;
    }
}