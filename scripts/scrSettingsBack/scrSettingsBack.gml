/// @function scrSettingsBack(_menu)
/// @description Возвращает на предыдущую страницу или закрывает настройки.
function scrSettingsBack(_menu)
{
    // Открыта подстраница — pop.
    if (_menu.menu_state == SETTINGS_STATE.OPENING
    ||  _menu.menu_state == SETTINGS_STATE.CATEGORY)
    {
        var _stack_emptied = scrSettingsPopPage(_menu);

        if (!_stack_emptied)
        {
            audio_play_sound(sndPauseMenuScroll, 0, false);
        }
        return;
    }

    // Уже закрываемся — второй ESC "проваливает" анимацию и делает ещё один шаг назад.
    if (_menu.menu_state == SETTINGS_STATE.CLOSING)
    {
        // 1. Мгновенно завершаем текущую анимацию
        _menu.depth_current = _menu.depth_target;
        _menu.current_page = _menu.page_stack[array_length(_menu.page_stack) - 1];
        _menu.menu_state = (_menu.current_page == SETTINGS_PAGE.HOME)
            ? SETTINGS_STATE.HOME
            : SETTINGS_STATE.CATEGORY;

        // 2. Сразу делаем ещё один Pop (если есть куда)
        var _stack_emptied = scrSettingsPopPage(_menu);

        // 3. Если стек опустел до HOME — начинаем закрытие меню (анимация уезда HOME)
        if (_stack_emptied)
        {
            if (instance_exists(_menu.return_instance))
                _menu.return_instance.menu_active = true;

            instance_destroy(_menu);
        }
        else
        {
            audio_play_sound(sndPauseMenuScroll, 0, false);
        }
        
        return;
    }

    // Мы на HOME — закрываем меню.
    if (_menu.menu_state == SETTINGS_STATE.HOME)
    {
        if (instance_exists(_menu.return_instance))
            _menu.return_instance.menu_active = true;

        instance_destroy(_menu);
    }
}