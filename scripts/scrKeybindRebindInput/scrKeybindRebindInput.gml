
/// @function scrKeybindRebindInput(_menu)
/// @description Обрабатывает переназначение клавиш и сброс назначений.

function scrKeybindRebindInput(_menu)
{
    if (_menu.current_page != SETTINGS_PAGE.KEYBINDS)
        return;

    if (_menu.menu_state == SETTINGS_STATE.CLOSING)
        return;

    if (_menu.keybind_block_start)
    {
        _menu.keybind_block_start = false;
        return;
    }

    var _bind_count = array_length(global.bind_definitions);

    // ========================================
    // ПОДТВЕРЖДЕНИЕ ИЗМЕНЕНИЯ
    // ========================================

    if (_menu.keybind_mode == KEYBIND_MODE.RESET_CONFIRM)
    {
        if (keyboard_check_pressed(vk_enter))
        {
            // Очищаем список предыдущих изменений.
            _menu.keybind_feedback_indices = [];

            // Сравниваем текущие назначения с DEFAULT.
            for (var i = 0; i < _bind_count; i++)
            {
                var _def = global.bind_definitions[i];
                var _current_key = global.settings.binds[$ _def.id];

                if (_current_key != _def.default_key)
                {
                    var _feedback_count =
                        array_length(_menu.keybind_feedback_indices);

                    _menu.keybind_feedback_indices[_feedback_count] = i;
                }
            }

            // Восстанавливаем ВСЕ назначения.
            for (var i = 0; i < _bind_count; i++)
            {
                var _def = global.bind_definitions[i];

                global.settings.binds[$ _def.id] = _def.default_key;
				scrSettingsSave();
            }

            // Настраиваем импульс только для изменившихся строк.
            _menu.keybind_feedback_all = false;
            _menu.keybind_feedback_index = -1;
            _menu.keybind_feedback_key = -1;
            _menu.keybind_feedback_timer = current_time + 600;

            show_debug_message(
                "[KEYBINDS] RESTORED. CHANGED BINDINGS: "
                + string(array_length(_menu.keybind_feedback_indices))
            );

            _menu.keybind_mode = KEYBIND_MODE.NONE;
            _menu.keybind_rebind_index = -1;
            _menu.keybind_pending_key = -1;
            _menu.keybind_conflict_index = -1;
            _menu.keybind_wait_release = false;
            _menu.keybind_capture_start_time = 0;

            return;
        }

        if (keyboard_check_pressed(vk_escape))
        {
            _menu.keybind_mode = KEYBIND_MODE.NONE;
            _menu.keybind_rebind_index = -1;
            _menu.keybind_pending_key = -1;
            _menu.keybind_conflict_index = -1;
            _menu.keybind_wait_release = false;
            _menu.keybind_capture_start_time = 0;

            show_debug_message("[KEYBINDS] DEFAULT RESET CANCELLED");

            return;
        }

        return;
    }

    // ========================================
    // CONFLICT
    // ========================================

    if (_menu.keybind_mode == KEYBIND_MODE.CONFLICT)
    {
        if (keyboard_check_pressed(vk_enter))
        {
            var _selected = _menu.keybind_rebind_index;
            var _conflict = _menu.keybind_conflict_index;
            var _key = _menu.keybind_pending_key;

            if (
                _selected >= 0
                && _selected < _bind_count
                && _conflict >= 0
                && _conflict < _bind_count
                && _key != -1
            )
            {
                var _selected_def = global.bind_definitions[_selected];
                var _conflict_def = global.bind_definitions[_conflict];

                global.settings.binds[$ _selected_def.id] = _key;
                global.settings.binds[$ _conflict_def.id] = -1;
				scrSettingsSave();

                _menu.keybind_feedback_all = false;
                _menu.keybind_feedback_indices = [];
                _menu.keybind_feedback_index = _selected;
                _menu.keybind_feedback_key = _key;
                _menu.keybind_feedback_timer = current_time + 600;

                show_debug_message(
                    "[REBIND] REPLACED: "
                    + _conflict_def.id
                    + " -> "
                    + _selected_def.id
                );
            }

            _menu.keybind_mode = KEYBIND_MODE.NONE;
            _menu.keybind_rebind_index = -1;
            _menu.keybind_pending_key = -1;
            _menu.keybind_conflict_index = -1;
            _menu.keybind_wait_release = false;
            _menu.keybind_capture_start_time = 0;

            return;
        }

        if (keyboard_check_pressed(vk_escape))
        {
            _menu.keybind_mode = KEYBIND_MODE.NONE;
            _menu.keybind_rebind_index = -1;
            _menu.keybind_pending_key = -1;
            _menu.keybind_conflict_index = -1;
            _menu.keybind_wait_release = false;
            _menu.keybind_capture_start_time = 0;

            return;
        }

        return;
    }

    // ========================================
    // NONE
    // ========================================

    if (_menu.keybind_mode == KEYBIND_MODE.NONE)
    {
        // F12 — OPEN DEFAULT RESET CONFIRMATION

        if (keyboard_check_pressed(vk_f12))
        {
            _menu.keybind_mode = KEYBIND_MODE.RESET_CONFIRM;
            _menu.keybind_reset_selection = 0;

            show_debug_message("[KEYBINDS] DEFAULT RESET CONFIRM OPENED");

            return;
        }

        var _enter = keyboard_check_pressed(vk_enter);
        var _space = keyboard_check_pressed(vk_space);
        var _lmb = mouse_check_button_pressed(mb_left);

        if (!_enter && !_space && !_lmb)
            return;

        // Защита от некорректного индекса.
        var _index = _menu.selected_index;

        if (_index < 0 || _index >= _bind_count)
            return;

        var _def = global.bind_definitions[_index];

        _menu.keybind_rebind_index = _index;
        _menu.keybind_pending_key = -1;
        _menu.keybind_conflict_index = -1;
        _menu.keybind_wait_release = true;
        _menu.keybind_capture_start_time = 0;

        _menu.keybind_mode = KEYBIND_MODE.WAITING;

        show_debug_message("[REBIND] STARTED: " + _def.id);

        return;
    }

    // ========================================
    // WAITING: WAIT FOR CONFIRM BUTTON RELEASE
    // ========================================

    if (
        _menu.keybind_mode == KEYBIND_MODE.WAITING
        && _menu.keybind_wait_release
    )
    {
        var _enter_held = keyboard_check(vk_enter);
        var _space_held = keyboard_check(vk_space);
        var _lmb_held = mouse_check_button(mb_left);

        var _confirm_held = _enter_held || _space_held || _lmb_held;

        if (!_confirm_held)
        {
            _menu.keybind_wait_release = false;

            show_debug_message("[REBIND] RELEASED");
        }

        return;
    }

    // ========================================
    // WAITING: KEYBOARD INPUT
    // ========================================

    if (keyboard_check_pressed(vk_anykey))
    {
        var _key = keyboard_lastkey;

        if (_key == vk_escape)
        {
            _menu.keybind_mode = KEYBIND_MODE.NONE;
            _menu.keybind_rebind_index = -1;
            _menu.keybind_pending_key = -1;
            _menu.keybind_conflict_index = -1;
            _menu.keybind_wait_release = false;
            _menu.keybind_capture_start_time = 0;

            show_debug_message("[REBIND] CANCELLED");

            return;
        }

        if (_key != vk_nokey)
        {
            scrKeybindTryAssign(_menu, _key);
            return;
        }
    }

    // ========================================
    // WAITING: MOUSE INPUT
    // ========================================

    var _mouse_key = -1;

    if (mouse_check_button_pressed(mb_left))
        _mouse_key = mb_left;
    else if (mouse_check_button_pressed(mb_right))
        _mouse_key = mb_right;
    else if (mouse_check_button_pressed(mb_middle))
        _mouse_key = mb_middle;
    else if (mouse_check_button_pressed(mb_side1))
        _mouse_key = mb_side1;
    else if (mouse_check_button_pressed(mb_side2))
        _mouse_key = mb_side2;

    if (_mouse_key != -1)
        scrKeybindTryAssign(_menu, _mouse_key);
}
