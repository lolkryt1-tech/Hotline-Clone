/// @function scrBindCheckReleased(_action)
/// @description Проверяет, была ли отпущена клавиша/кнопка мыши в этом кадре.
function scrBindCheckReleased(_action)
{
    var _key = global.settings.binds[$ _action];

    if (_key == -1) return false;

    if (_key >= 1 && _key <= 8)
        return mouse_check_button_released(_key);

    return keyboard_check_released(_key);
}