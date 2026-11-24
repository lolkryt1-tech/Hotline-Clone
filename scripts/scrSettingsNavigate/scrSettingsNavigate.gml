/// @function scrSettingsNavigate(_menu, _count)
/// @description Перемещает выделение по списку настроек.

function scrSettingsNavigate(_menu, _count)
{
    // Блокируем навигацию во время переназначения клавиш.
    if (_menu.keybind_mode != KEYBIND_MODE.NONE)
        return;

    // Если список пустой, перемещаться некуда.
    if (_count <= 0)
        return;

    var _up = keyboard_check_pressed(vk_up)
           || keyboard_check_pressed(ord("W"));

    var _down = keyboard_check_pressed(vk_down)
             || keyboard_check_pressed(ord("S"));

    // Если клавиши не нажаты, ничего не делаем.
    if (!_up && !_down)
        return;

    // Изменяем индекс выбранного пункта.
    _menu.selected_index += _down ? 1 : -1;

    // Переход через конец списка.
    if (_menu.selected_index < 0)
        _menu.selected_index = _count - 1;

    if (_menu.selected_index >= _count)
        _menu.selected_index = 0;

    // Запоминаем позицию на текущей странице стека.
    var _top = array_length(_menu.parent_selected_index_stack) - 1;
    _menu.parent_selected_index_stack[_top] = _menu.selected_index;

    // Звук перемещения.
    var _snd = audio_play_sound(sndPauseMenuScroll, 0, false);

    if (_snd != -1)
        audio_sound_pitch(_snd, random_range(0.9, 1.15));
}
