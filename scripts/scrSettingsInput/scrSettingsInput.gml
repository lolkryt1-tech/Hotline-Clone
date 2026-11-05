/// @function scrSettingsInput(_menu)
/// @description Обрабатывает управление меню настроек.

function scrSettingsInput(_menu)
{
    var _up = keyboard_check_pressed(vk_up)
           || keyboard_check_pressed(ord("W"));

    var _down = keyboard_check_pressed(vk_down)
             || keyboard_check_pressed(ord("S"));

    var _left = keyboard_check_pressed(vk_left)
              || keyboard_check_pressed(ord("A"));

    var _right = keyboard_check_pressed(vk_right)
               || keyboard_check_pressed(ord("D"));

    var _confirm = keyboard_check_pressed(vk_enter)
                || keyboard_check_pressed(vk_space)
                || mouse_check_button_pressed(mb_left);

    var _back = keyboard_check_pressed(vk_escape)
             || keyboard_check_pressed(vk_backspace);

    // === ВОЗВРАТ ===
    if (_back)
    {
        scrSettingsBack(_menu);
        return;
    }

    // === ГЛАВНАЯ СТРАНИЦА ИЛИ ВОЗВРАТ К НЕЙ ===
    if (_menu.menu_state == SETTINGS_STATE.HOME
    ||  _menu.menu_state == SETTINGS_STATE.CLOSING)
    {
        scrSettingsNavigate(_menu, array_length(_menu.home_items));

        // Регулировка громкости доступна только на HOME.
        if (_menu.menu_state == SETTINGS_STATE.HOME && (_left || _right))
        {
            if (_menu.selected_index == 0 || _menu.selected_index == 1)
            {
                scrSettingsValues(_menu, _right ? 1 : -1, false);
            }
        }

        if (_confirm)
        {
            scrSettingsOpenPage(_menu);
        }

        return;
    }

    // === ОТКРЫТИЕ ИЛИ ОТКРЫТАЯ КАТЕГОРИЯ ===
    if (_menu.menu_state == SETTINGS_STATE.OPENING
    ||  _menu.menu_state == SETTINGS_STATE.CATEGORY)
    {
        var _items = scrSettingsGetItems(_menu);
        var _count = array_length(_items);

        if (_count > 0)
        {
            scrSettingsNavigate(_menu, _count);

            if (_confirm || _left || _right)
            {
                scrSettingsValues(_menu, 0, true);
                audio_play_sound(sndPauseMenuScroll, 0, false);
            }
        }
    }
}