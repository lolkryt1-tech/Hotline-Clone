
/// @function scrKeybindTryAssign(_menu, _key)
/// @description Проверяет конфликт и назначает свободную клавишу.

function scrKeybindTryAssign(_menu, _key)
{
    var _selected = _menu.keybind_rebind_index;

    if (_selected < 0 || _selected >= array_length(global.bind_definitions))
        return;

    var _selected_def = global.bind_definitions[_selected];
    var _selected_id = _selected_def.id;

    // ========================================
    // ПОИСК КОНФЛИКТА
    // ========================================

    for (var i = 0; i < array_length(global.bind_definitions); i++)
    {
        if (i == _selected)
            continue;

        var _other_def = global.bind_definitions[i];
        var _other_id = _other_def.id;

        var _current_key = global.settings.binds[$ _other_id];

        if (_current_key == -1)
            continue;

        if (_current_key == _key)
        {
            _menu.keybind_feedback_indices = [];

            _menu.keybind_pending_key = _key;
            _menu.keybind_conflict_index = i;
            _menu.keybind_conflict_selection = 0;
            _menu.keybind_mode = KEYBIND_MODE.CONFLICT;

            show_debug_message(
                "[REBIND] CONFLICT: "
                + scrKeyCodeToName(_key)
                + " IS USED BY "
                + _other_id
            );

            return;
        }
    }

    // ========================================
    // СВОБОДНАЯ КЛАВИША
    // ========================================

    global.settings.binds[$ _selected_id] = _key;
	scrSettingsSave();

    // АНИМАЦИЯ ЗАГОРАНИЯ ЗЕЛЕНЫМ

    _menu.keybind_feedback_all = false;
    _menu.keybind_feedback_indices = [];
    _menu.keybind_feedback_index = _selected;
    _menu.keybind_feedback_key = _key;
    _menu.keybind_feedback_timer = current_time + 600;

    show_debug_message(
        "[REBIND] ASSIGNED: "
        + _selected_id
        + " = "
        + scrKeyCodeToName(_key)
    );

    // ========================================
    // ЗАВЕРШЕНИЕ
    // ========================================

    _menu.keybind_mode = KEYBIND_MODE.NONE;
    _menu.keybind_rebind_index = -1;
    _menu.keybind_pending_key = -1;
    _menu.keybind_conflict_index = -1;
    _menu.keybind_wait_release = false;
}
