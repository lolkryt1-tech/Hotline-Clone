
/// @function scrSettingsAnimation(_menu)
/// @description Обновляет анимацию перехода между страницами по глубине стека.

function scrSettingsAnimation(_menu)
{
    var _gui_w = display_get_gui_width();
    var _w = _gui_w + 100;

    // === ПЛАВНОЕ ДВИЖЕНИЕ ГЛУБИНЫ ===
    _menu.depth_current = lerp(_menu.depth_current, _menu.depth_target, _menu.transition_speed);

    // Проверка завершения и фиксация глубины
    var _arrived = (abs(_menu.depth_current - _menu.depth_target) < 0.001);

    if (_arrived)
    {
        _menu.depth_current = _menu.depth_target;
    }

    var _d = _menu.depth_current;

    // === SUB_TITLE (полёт KEYBINDS/MOUSE) ===
    var _is_sub_page = (_menu.current_page == SETTINGS_PAGE.KEYBINDS
                     || _menu.current_page == SETTINGS_PAGE.MOUSE);

    if (_is_sub_page)
    {
        if (_menu.menu_state == SETTINGS_STATE.CLOSING)
            _menu.sub_title_progress = lerp(_menu.sub_title_progress, 0, _menu.transition_speed);
        else if (_menu.menu_state == SETTINGS_STATE.OPENING || _arrived)
            _menu.sub_title_progress = lerp(_menu.sub_title_progress, 1, _menu.transition_speed);

        if (abs(_menu.sub_title_progress - 0) < 0.005) _menu.sub_title_progress = 0;
        if (abs(_menu.sub_title_progress - 1) < 0.005) _menu.sub_title_progress = 1;

        // Вертикальный полёт родителя (без снэпа)
        _menu.parent_fly_y_current = lerp(_menu.parent_fly_y_current, 60, _menu.transition_speed);
        if (abs(_menu.parent_fly_y_current - 60) < 0.1) _menu.parent_fly_y_current = 60;
    }
    else
    {
        _menu.sub_title_progress = 0;
        _menu.parent_fly_y_current = 60;
    }

    // === ОБНОВЛЕНИЕ menu_state ПО ФАКТУ ПРИБЫТИЯ ===
    if (_arrived)
    {
        var _top_page = _menu.page_stack[array_length(_menu.page_stack) - 1];
        _menu.current_page = _top_page;
        _menu.menu_state = (_top_page == SETTINGS_PAGE.HOME)
            ? SETTINGS_STATE.HOME
            : SETTINGS_STATE.CATEGORY;

        var _top_idx = array_length(_menu.parent_selected_index_stack) - 1;
        _menu.selected_index = _menu.parent_selected_index_stack[_top_idx];
    }
    else
    {
        _menu.menu_state = (_menu.depth_target > _d)
            ? SETTINGS_STATE.OPENING
            : SETTINGS_STATE.CLOSING;
    }

    // === OFFSET'Ы ===
    _menu.home_offset_x = -_w * _d;
    _menu.volume_percent_offset_x = _w * _d;

    // === СМЕЩЕНИЯ ТЕКСТА И ПЕРЕКЛЮЧАТЕЛЕЙ ===
    var _transition_offset = (_menu.menu_state == SETTINGS_STATE.CLOSING)
        ? (_menu.depth_closing_start - _d)
        : (_menu.depth_target - _d);

    _menu.page_text_offset_x = -_w * _transition_offset;
    _menu.page_toggle_offset_x = _w * _transition_offset;

    // === СТАРОЕ СМЕЩЕНИЕ СТРАНИЦЫ ===
    // Оставляем для элементов с существующей анимацией.

    if (_menu.menu_state == SETTINGS_STATE.CLOSING)
    {
        _menu.page_offset_x = -_w * (_menu.depth_closing_start - _d);
    }
    else
    {
        var _is_menu = (_menu.current_page == SETTINGS_PAGE.GAME
                     || _menu.current_page == SETTINGS_PAGE.VISUAL
                     || _menu.current_page == SETTINGS_PAGE.CONTROLS);

        if (_is_menu)
            _menu.page_offset_x = -_w * (_menu.depth_target - _d);
        else
            _menu.page_offset_x = _w * (_menu.depth_target - _d);
    }

    _menu.transition_active = !_arrived;
}
