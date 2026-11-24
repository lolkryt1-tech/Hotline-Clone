/// @function scrBindCheck(_action)
/// @description Проверяет, зажата ли клавиша/кнопка мыши для действия.
function scrBindCheck(_action)
{
    var _key = global.settings.binds[$ _action];

    // Если действие не назначено (например, удалили конфликтом)
    if (_key == -1) return false;

    // Кнопки мыши в GameMaker имеют коды от 1 до 8 (mb_left = 1, mb_right = 2 и т.д.)
    if (_key >= 1 && _key <= 8)
        return mouse_check_button(_key);

    // Остальное — клавиатура
    return keyboard_check(_key);
}