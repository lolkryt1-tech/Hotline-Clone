
/// @function scrSettingsDrawKeybindConflict(_menu, _gui_w, _gui_h)
/// @description Отрисовывает центральные окна конфликта клавиш и подтверждения DEFAULT.

function scrSettingsDrawKeybindConflict(_menu, _gui_w, _gui_h)
{
    var _is_conflict =
        (_menu.keybind_mode == KEYBIND_MODE.CONFLICT);

    var _is_reset =
        (_menu.keybind_mode == KEYBIND_MODE.RESET_CONFIRM);

    if (!_is_conflict && !_is_reset)
        return;

    var _layout = scrSettingsKeybindLayout(_gui_w, _gui_h);

    // Для окна конфликта проверяем индексы.
    var _conflict_def = undefined;
    var _key_name = "";

    if (_is_conflict)
    {
        var _selected = _menu.keybind_rebind_index;
        var _conflict = _menu.keybind_conflict_index;

        if (
            _selected < 0
            || _selected >= array_length(global.bind_definitions)
            || _conflict < 0
            || _conflict >= array_length(global.bind_definitions)
        )
        {
            return;
        }

        _conflict_def = global.bind_definitions[_conflict];
        _key_name = scrKeyCodeToName(_menu.keybind_pending_key);
    }

    var _cx = _gui_w * 0.5;
    var _cy = _gui_h * 0.5;

    var _w = min(560, _gui_w - 40);
    var _h = 340;

    var _x1 = _cx - _w * 0.5;
    var _y1 = _cy - _h * 0.5;
    var _x2 = _cx + _w * 0.5;
    var _y2 = _cy + _h * 0.5;

    var _accent = make_color_rgb(255, 210, 60);
    var _muted = make_color_rgb(190, 190, 190);
    var _border = make_color_rgb(104, 104, 104);

    // ========================================
    // ЗАТЕМНЕНИЕ ФОНА
    // ========================================

    draw_set_alpha(0.75);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);

    // ========================================
    // ФОН ОКНА
    // ========================================

    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_rectangle(_x1, _y1, _x2, _y2, false);

    draw_set_color(_border);
    draw_rectangle(_x1, _y1, _x2, _y2, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // ========================================
    // RESET CONFIRM WINDOW
    // ========================================

    if (_is_reset)
    {
        draw_set_font(fntMainMenu);
        draw_set_color(c_white);

        draw_text(
            _cx,
            _y1 + 65,
            "RESET ALL KEYBINDS?"
        );

        draw_set_font(_layout.font_action);
        draw_set_color(_accent);

        draw_text(
            _cx,
            _y1 + 125,
            "DEFAULT"
        );

        draw_set_font(_layout.font_header);
        draw_set_color(_muted);

        draw_text(
            _cx,
            _y1 + 180,
            "ALL KEYBINDINGS WILL BE RESTORED"
        );

        draw_set_color(_border);

        draw_line(
            _x1 + 35,
            _y2 - 85,
            _x2 - 35,
            _y2 - 85
        );

        draw_set_font(_layout.font_header);
        draw_set_color(c_white);

        draw_text(
            _cx,
            _y2 - 58,
            "ENTER - CONFIRM"
        );

        draw_text(
            _cx,
            _y2 - 27,
            "ESC - CANCEL"
        );
    }
    else
    {
        // ========================================
        // CONFLICT WINDOW — ЗАГОЛОВОК
        // ========================================

        draw_set_font(fntMainMenu);
        draw_set_color(c_white);

        draw_text(
            _cx,
            _y1 + 42,
            "KEY ALREADY IN USE"
        );

        // ========================================
        // КОНФЛИКТУЮЩАЯ КЛАВИША
        // ========================================

        draw_set_font(_layout.font_action);
        draw_set_color(_accent);

        draw_text(
            _cx,
            _y1 + 105,
            _key_name
        );

        // ========================================
        // ТЕКСТ О ТЕКУЩЕМ НАЗНАЧЕНИИ
        // ========================================

        draw_set_font(_layout.font_header);
        draw_set_color(_muted);

        draw_text(
            _cx,
            _y1 + 165,
            "CURRENTLY ASSIGNED TO"
        );

        // ========================================
        // ДЕЙСТВИЕ, КОТОРОЕ ЗАНИМАЕТ КЛАВИШУ
        // ========================================

        draw_set_font(_layout.font_action);
        draw_set_color(c_white);

        draw_text(
            _cx,
            _y1 + 210,
            _conflict_def.label
        );

        // ========================================
        // РАЗДЕЛИТЕЛЬ
        // ========================================

        draw_set_color(_border);

        draw_line(
            _x1 + 35,
            _y2 - 85,
            _x2 - 35,
            _y2 - 85
        );

        // ========================================
        // ПОДСКАЗКИ
        // ========================================

        draw_set_font(_layout.font_header);
        draw_set_color(c_white);

        draw_text(
            _cx,
            _y2 - 58,
            "ENTER - REPLACE"
        );

        draw_text(
            _cx,
            _y2 - 27,
            "ESC - CANCEL"
        );
    }

    // ========================================
    // ВОССТАНОВЛЕНИЕ DRAW STATE
    // ========================================

    draw_set_font(fntMainMenu);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
