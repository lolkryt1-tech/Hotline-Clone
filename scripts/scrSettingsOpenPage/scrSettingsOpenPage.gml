/// @function scrSettingsOpenPage(_menu)
/// @description Открывает выбранную категорию настроек.

function scrSettingsOpenPage(_menu)
{

    if (_menu.menu_state != SETTINGS_STATE.HOME
	&&  _menu.menu_state != SETTINGS_STATE.CLOSING)
	{
	    return;
	}

    var _selected = _menu.selected_index;

    switch (_selected)
    {
        case 2:
            _menu.current_page = SETTINGS_PAGE.GAME;
            _menu.page_title = "GAME";
            break;

        case 3:
            _menu.current_page = SETTINGS_PAGE.VISUAL;
            _menu.page_title = "VISUAL";
            break;

        case 4:
            _menu.current_page = SETTINGS_PAGE.CONTROLS;
            _menu.page_title = "CONTROLS";
            break;

        case 5:
            _menu.current_page = SETTINGS_PAGE.VOLUME_EXTRA;
            _menu.page_title = "VOLUME EXTRA";
            break;

        default:
            return;
    }

    // Запоминаем, какая категория перемещается наверх.
    _menu.transition_selected_index = _selected;

    // На внутренней странице начинаем с первого пункта.
    _menu.selected_index = 0;

    // Запускаем открытие.
    _menu.menu_state = SETTINGS_STATE.OPENING;
    _menu.transition_target = 1;

    audio_play_sound(sndPauseMenuScroll, 0, false);
}