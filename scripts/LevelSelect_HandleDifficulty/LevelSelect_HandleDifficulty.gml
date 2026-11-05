function LevelSelect_HandleDifficulty()
{
    if (keyboard_check_pressed(vk_space) && state != LEVEL_STATE.LEAVING)
    {
        global.hard = !global.hard;

        level_records = global.hard ? hard_records: normal_records;

        // При смене сложности убираем старый ранг.
        LevelSelect_DestroyGrade();
    }
}