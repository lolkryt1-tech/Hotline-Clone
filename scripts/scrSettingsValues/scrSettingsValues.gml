/// @function scrSettingsValues(_menu, _direction, _activate)
/// @description Изменяет значения настроек.

function scrSettingsValues(_menu, _direction, _activate)
{
    // === ГЛАВНАЯ СТРАНИЦА ===

    if (_menu.current_page == SETTINGS_PAGE.HOME)
    {
        // Если нет направления изменения — ничего не делаем.
        if (_direction == 0)
            return;

        var _change = _direction * 0.05;

        switch (_menu.selected_index)
        {
            // Громкость звуков
            case 0:
                global.settings.sound_volume = clamp(global.settings.sound_volume + _change, 0, 1);

                scrSettingsApply();
                break;

            // Громкость музыки
            case 1:
                global.settings.music_volume = clamp(global.settings.music_volume + _change, 0, 1);
                break;

            default:
                return;
        }

        scrSettingsSave();
        return;
    }


    // === ДОПОЛНИТЕЛЬНАЯ ГРОМКОСТЬ ===

    if (_menu.current_page == SETTINGS_PAGE.VOLUME_EXTRA)
    {
        if (_menu.selected_index == 0 && (_activate || _direction != 0))
        {
            global.settings.enable_music_filters =
                !global.settings.enable_music_filters;

            scrSettingsSave();
        }
    }
}