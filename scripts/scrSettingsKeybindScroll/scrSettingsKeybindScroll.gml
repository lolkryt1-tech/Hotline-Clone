
/// @function scrSettingsKeybindScroll(_menu)
/// @description Управляет прокруткой списка KEYBINDS.

function scrSettingsKeybindScroll(_menu)
{
    if (
        _menu.current_page != SETTINGS_PAGE.KEYBINDS
        || _menu.menu_state == SETTINGS_STATE.CLOSING
    )
    {
        return;
    }

    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();

    var _layout = scrSettingsKeybindLayout(_gui_w, _gui_h);

    var _bind_count = array_length(global.bind_definitions);

    var _selected = clamp(
        _menu.selected_index,
        0,
        _bind_count - 1
    );

    // ========================================
    // РАССЧИТЫВАЕМ Y ВЫБРАННОЙ СТРОКИ
    // ========================================

    var _selected_y = _layout.list_top;

    for (var i = 0; i <= _selected; i++)
    {
        if (i == 0 || i == 4 || i == 11)
        {
            _selected_y +=
                _layout.category_height
                + _layout.category_to_row_gap;
        }

        if (i == _selected)
            break;

        _selected_y += _layout.row_step;

        if (i == 3 || i == 10)
            _selected_y += _layout.category_spacing;
    }

    // ========================================
    // ПОЛНАЯ ВЫСОТА СОДЕРЖИМОГО
    // ========================================

    var _content_height =
        _bind_count * _layout.row_step
        + 3 * (
            _layout.category_height
            + _layout.category_to_row_gap
        )
        + 2 * _layout.category_spacing;

    var _viewport_height =
        _layout.list_bottom - _layout.list_top;

    var _max_scroll = max(
        0,
        _content_height - _viewport_height
    );

    // ========================================
    // ПРОВЕРКА ВИДИМОСТИ ВЫБРАННОЙ СТРОКИ
    // ========================================

    var _safe_margin = _layout.row_step;

    var _visible_y =
        _selected_y - _menu.keybind_scroll_target;

    var _safe_top =
        _layout.list_top + _safe_margin;

    var _safe_bottom =
        _layout.list_bottom - _safe_margin;

    if (_selected == 0)
    {
        _menu.keybind_scroll_target = 0;
    }
    else if (_visible_y < _safe_top)
    {
        _menu.keybind_scroll_target =
            _selected_y - _safe_top;
    }
    else if (
        _visible_y + _layout.row_height
        > _safe_bottom
    )
    {
        _menu.keybind_scroll_target =
            _selected_y
            + _layout.row_height
            - _safe_bottom;
    }

    _menu.keybind_scroll_target = clamp(
        _menu.keybind_scroll_target,
        0,
        _max_scroll
    );

    // ========================================
    // ПЛАВНОЕ ДВИЖЕНИЕ
    // ========================================

    _menu.keybind_scroll_y = lerp(
        _menu.keybind_scroll_y,
        _menu.keybind_scroll_target,
        _menu.keybind_scroll_speed
    );

    if (
        abs(
            _menu.keybind_scroll_y
            - _menu.keybind_scroll_target
        ) < 0.1
    )
    {
        _menu.keybind_scroll_y =
            _menu.keybind_scroll_target;
    }

    // ========================================
    // DEBUG DATA
    // ========================================

    _menu.debug_scroll_y = _menu.keybind_scroll_y;
    _menu.debug_scroll_target = _menu.keybind_scroll_target;
    _menu.debug_scroll_max = _max_scroll;
    _menu.debug_selected_y = _selected_y;
    _menu.debug_viewport_top = _layout.list_top;
    _menu.debug_viewport_bottom = _layout.list_bottom;
    _menu.debug_selected_index = _selected;
}
