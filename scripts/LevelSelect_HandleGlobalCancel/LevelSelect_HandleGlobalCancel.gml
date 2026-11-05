function LevelSelect_HandleGlobalCancel()
{
    if (state == LEVEL_STATE.CONFIRMING && !is_reversing && keyboard_check_pressed(vk_escape))
    {
        is_reversing = true;
    }
}