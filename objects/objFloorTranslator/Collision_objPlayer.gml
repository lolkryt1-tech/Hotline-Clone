// Заменяем блок с "with objPlayer" на правильную проверку коллизии:
if (is_unlocked && trigger_delay <= 0 && wait_timer <= 0)
{
    if (instance_exists(objPlayer))
    {
        if (place_meeting(x, y, objPlayer))
        {
            player_is_standing_on_me = true;
        }
    }
}
