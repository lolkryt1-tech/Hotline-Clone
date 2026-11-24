/// @function scrBindCheckPressed(_action)
/// @description Проверяет, была ли нажата клавиша/кнопка мыши в этом кадре.
function scrBindCheckPressed(_action)
{
    var _key = global.settings.binds[$ _action];

    if (_key == -1) return false;

    if (_key >= 1 && _key <= 8)
        return mouse_check_button_pressed(_key);

    return keyboard_check_pressed(_key);
}