/// @function scrSettingsAnimation(_menu)
/// @description Обновляет анимацию перехода между страницами.

function scrSettingsAnimation(_menu)
{
    // === ОБЩИЙ ПРОГРЕСС ПЕРЕХОДА ===

    _menu.transition_progress = lerp(
        _menu.transition_progress,
        _menu.transition_target,
        _menu.transition_speed
    );

    if (abs(_menu.transition_progress - _menu.transition_target) < 0.005)
    {
        _menu.transition_progress = _menu.transition_target;
    }

    var _progress = _menu.transition_progress;
    var _gui_w = display_get_gui_width();

    // === ГЛАВНАЯ СТРАНИЦА ===

    // Основные элементы HOME уходят влево.
    _menu.home_offset_x = lerp(0, -(_gui_w + 100),_progress);

    // Проценты громкости уходят вправо.
    _menu.volume_percent_offset_x = lerp(0,_gui_w + 100,_progress);

    // === ВНУТРЕННЯЯ СТРАНИЦА ===

    // При открытии приходит справа.
    // При закрытии полностью уходит за правую границу.
    _menu.page_offset_x = lerp(_gui_w + 100, 0,_progress);

    // === ЗАВЕРШЕНИЕ ПЕРЕХОДА ===

    if (_progress >= 1)
    {
        _menu.menu_state = SETTINGS_STATE.CATEGORY;
    }
    else if (_progress <= 0)
    {
        _menu.menu_state = SETTINGS_STATE.HOME;
        _menu.current_page = SETTINGS_PAGE.HOME;
        _menu.selected_index = _menu.home_selected_index;
    }

    _menu.transition_active = (_progress > 0 && _progress < 1);
}