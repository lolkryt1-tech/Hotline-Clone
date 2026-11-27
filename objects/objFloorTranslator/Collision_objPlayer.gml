// Заменяем блок с "with objPlayer" на правильную проверку коллизии:
if (is_unlocked && trigger_delay <= 0 && wait_timer <= 0)
{
    if (instance_exists(objPlayer))
    {
        transition_started = true;
    }
}
