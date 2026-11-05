function LevelSelect_HandleNavigation()
{
    if (state == LEVEL_STATE.LEAVING)
    {
        return;
    }

    var _nav_left =
        keyboard_check_pressed(vk_left) ||
        keyboard_check_pressed(ord("A"));

    var _nav_right =
        keyboard_check_pressed(vk_right) ||
        keyboard_check_pressed(ord("D"));

    if (_nav_left)
    {
        LevelSelect_MoveSelection(-1);
    }

    if (_nav_right)
    {
        LevelSelect_MoveSelection(1);
    }
}