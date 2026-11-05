/// @function scrSettingsBack(_menu)
/// @description Возвращает на предыдущую страницу или закрывает настройки.

function scrSettingsBack(_menu)
{
    // Если мы уже на главной странице,
    // закрываем всё меню настроек.
    if (_menu.menu_state == SETTINGS_STATE.HOME)
    {
        if (instance_exists(_menu.return_instance))
            _menu.return_instance.menu_active = true;

        instance_destroy(_menu);
        return;
    }

    // Если категория открывается или уже открыта,
    // начинаем возвращение на главную страницу.
    if (_menu.menu_state == SETTINGS_STATE.OPENING
    ||  _menu.menu_state == SETTINGS_STATE.CATEGORY)
    {
        _menu.menu_state = SETTINGS_STATE.CLOSING;
        _menu.transition_target = 0;
		_menu.selected_index = _menu.home_selected_index;

        audio_play_sound(sndPauseMenuScroll, 0, false);
    }
}