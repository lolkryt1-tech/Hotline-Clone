
/// @function scrSettingsInput(_menu)
/// @description Обрабатывает управление меню настроек.

function scrSettingsInput(_menu)
{
    // ========================================
    // DEBUG LAYOUT — F10
    // ========================================

    if (keyboard_check_pressed(vk_f10))
    {
        _menu.debug_layout = !_menu.debug_layout;
    }

    // ========================================
    // ПРОВЕРКА РЕЖИМА ПЕРЕНАЗНАЧЕНИЯ
    // ========================================

    var _rebind_active = (_menu.keybind_mode != KEYBIND_MODE.NONE);

    // ========================================
    // ОСНОВНОЕ УПРАВЛЕНИЕ
    // ========================================

    var _up = !_rebind_active && (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")));
    var _down = !_rebind_active && (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")));
    var _left = !_rebind_active && (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A")));
    var _right = !_rebind_active && (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D")));

    var _confirm = !_rebind_active && (
        keyboard_check_pressed(vk_enter)
        || keyboard_check_pressed(vk_space)
        || mouse_check_button_pressed(mb_left)
    );

    var _back = !_rebind_active && (
        keyboard_check_pressed(vk_escape)
        || keyboard_check_pressed(vk_backspace)
    );

    if (_back)
    {
        scrSettingsBack(_menu);
        return;
    }

    // =========================================================
    // === ЗАЖАТИЕ СТРЕЛОК (АВТОПОВТОР) ===
    // =========================================================

    if (!_rebind_active)
    {
        var _axis_held = 0;
        var _axis_pressed = (_left || _right);

        if (keyboard_check(vk_left) || keyboard_check(ord("A"))) _axis_held = -1;
        if (keyboard_check(vk_right) || keyboard_check(ord("D"))) _axis_held = 1;

        if (_axis_pressed)
        {
            _menu.axis_repeat_timer = 0;
            _menu.axis_repeat_started = true;
        }

        if (_axis_held != 0)
        {
            var _do_action = false;

            if (_menu.axis_repeat_timer == 0)
                _do_action = true;
            else if (_menu.axis_repeat_started && _menu.axis_repeat_timer > 15)
                _do_action = true;

            if (_do_action)
            {
                // Получаем настройки текущей страницы.

                var _setting_items = [];

                if (_menu.current_page == SETTINGS_PAGE.HOME)
                {
                    if (_menu.menu_state == SETTINGS_STATE.HOME)
                        _setting_items = scrSettingsGetPageSettings(_menu);
                }
                else
                {
                    _setting_items = scrSettingsGetPageSettings(_menu);
                }

                // Получаем выбранный пункт.

                if (_menu.selected_index >= 0 && _menu.selected_index < array_length(_setting_items))
                {
                    var _item = _setting_items[_menu.selected_index];

                    switch (_item.type)
                    {
                        // ПОЛЗУНОК

                        case SETTING_TYPE.SLIDER:

                            scrSettingsValues(_menu, _axis_held, false);

                            // Звук изменения значения.

                            var _snd = audio_play_sound(sndPauseMenuScroll, 0, false);
                            if (_snd != -1) audio_sound_pitch(_snd, random_range(0.9, 1.15));

                            break;

                        // ПЕРЕКЛЮЧАТЕЛЬ

                        case SETTING_TYPE.TOGGLE:

                            // Переключаем только при новом нажатии, без автоповтора.

                            if (_axis_pressed)
                            {
                                scrSettingsValues(_menu, _axis_held, false);
                                audio_play_sound(sndPauseMenuScroll, 0, false);
                            }

                            break;
                    }
                }
            }

            if (_menu.axis_repeat_timer < 100) _menu.axis_repeat_timer++;
        }
        else
        {
            _menu.axis_repeat_timer = 0;
            _menu.axis_repeat_started = false;
        }
    }

    // ========================================
    // ГЛАВНАЯ ИЛИ ВОЗВРАТ К НЕЙ
    // ========================================

    if (_menu.menu_state == SETTINGS_STATE.HOME
    ||  _menu.menu_state == SETTINGS_STATE.CLOSING)
    {
        if (_menu.menu_state == SETTINGS_STATE.CLOSING && _menu.depth_current > 1.005)
        {
            // Возврат в промежуточную страницу.
        }
        else
        {
            scrSettingsNavigate(_menu, array_length(_menu.home_menu_items));

            if (_confirm)
                scrSettingsOpenPage(_menu);

            return;
        }
    }

    // ========================================
    // ОТКРЫТИЕ, КАТЕГОРИЯ ИЛИ ВОЗВРАТ
    // ========================================

    if (_menu.menu_state == SETTINGS_STATE.OPENING
    ||  _menu.menu_state == SETTINGS_STATE.CATEGORY
    ||  (_menu.menu_state == SETTINGS_STATE.CLOSING && _menu.depth_current > 1.005))
    {
        var _setting_items = scrSettingsGetPageSettings(_menu);
        var _items = array_length(_setting_items) > 0 ? _setting_items : scrSettingsGetSpecialItems(_menu);

        var _is_returning = (_menu.menu_state == SETTINGS_STATE.CLOSING && _menu.depth_current > 1.005);

        if (_is_returning)
        {
            var _info = scrSettingsGetParentInfo(_menu);
            _items = _info.parent_items;
        }

        var _count = array_length(_items);

        if (_count > 0)
        {
            scrSettingsNavigate(_menu, _count);

            if (_confirm)
            {
                if (_is_returning || _menu.current_page == SETTINGS_PAGE.CONTROLS)
                {
                    scrSettingsOpenPage(_menu);
                }
                else
                {
                    // Получаем описание выбранного пункта.

                    var _setting_items = scrSettingsGetPageSettings(_menu);

                    if (_menu.selected_index >= 0 && _menu.selected_index < array_length(_setting_items))
                    {
                        var _item = _setting_items[_menu.selected_index];

                        if (_item.type == SETTING_TYPE.TOGGLE)
                        {
                            scrSettingsValues(_menu, 0, true);
                            audio_play_sound(sndPauseMenuScroll, 0, false);
                        }
                    }
                }
            }
        }
    }
}
