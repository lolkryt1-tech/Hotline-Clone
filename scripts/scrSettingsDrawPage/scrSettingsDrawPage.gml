
/// @function scrSettingsDrawPage(_menu, _gui_w, _gui_h)
/// @description Отрисовывает внутреннюю страницу настроек.

function scrSettingsDrawPage(_menu, _gui_w, _gui_h)
{
    if (_menu.current_page == SETTINGS_PAGE.HOME)
        return;

    var _gui_width = _gui_w + 100;
    var _info = scrSettingsGetParentInfo(_menu);
    var _has_parent = (_info.parent_page != -1);

    // ========================================
    // ЗАГОЛОВОК
    // ========================================

    if (_has_parent)
    {
        draw_set_font(fntMainMenu);
        draw_set_color(c_white);

        var _parent_title = scrSettingsGetPageTitle(_info.parent_page);
        draw_text(50, _menu.parent_fly_y_current, _parent_title);

        if (_menu.sub_title_progress > 0 || _menu.menu_state == SETTINGS_STATE.CLOSING)
        {
            var _sp = _menu.sub_title_progress;
            var _sx = lerp(_menu.sub_title_start_x, _menu.sub_title_target_x, _sp);
            var _sy = lerp(_menu.sub_title_start_y, _menu.sub_title_target_y, _sp);

            draw_set_font(fntMainMenu);
            draw_text(_sx, _sy, _menu.sub_title);
            draw_set_font(fntMainMenu);
        }
    }
    else
    {
        var _is_being_drawn_by_home = (_menu.transition_active && _menu.depth_current < 1);

        if (!_is_being_drawn_by_home)
        {
            draw_set_font(fntMainMenu);
            draw_set_color(c_white);

            var _y = 60;

            if (_menu.depth_current < 1)
                _y = lerp(380, 60, _menu.depth_current);

            draw_text(50, _y, _menu.page_title);
            draw_set_font(fntMainMenu);
        }
    }

    // ========================================
    // СОДЕРЖИМОЕ
    // ========================================

    var _offset_x = _menu.page_offset_x;
    var _text_offset_x = _menu.page_text_offset_x;
    var _toggle_offset_x = _menu.page_toggle_offset_x;

    if (_has_parent)
    {
        var _parent_offset_x = -(_menu.depth_current - 1) * _gui_width;

        for (var i = 0; i < array_length(_info.parent_items); i++)
        {
            if (i == _info.sub_index)
                continue;

            var _y = 180 + i * 65;
            var _text = _info.parent_items[i];
            var _selected = (_menu.depth_current < 1.99 && i == _menu.selected_index);

            draw_set_font(fntMainMenu);
            scrSettingsDrawItem(50 + _parent_offset_x, _y, _text, _selected);
        }

        // ========================================
        // KEYBINDS
        // ========================================

        if (_menu.current_page == SETTINGS_PAGE.KEYBINDS)
        {
            scrSettingsDrawKeybinds(_menu, _gui_w, _gui_h, _offset_x);
        }
    }
    else if (_menu.current_page == SETTINGS_PAGE.CONTROLS)
    {
        draw_set_font(fntMainMenu);

        for (var i = 0; i < array_length(_menu.controls_menu_items); i++)
        {
            var _y = 180 + i * 65;
            var _selected = (i == _menu.selected_index);
            var _text = _menu.controls_menu_items[i];

            scrSettingsDrawItem(50 + _text_offset_x, _y, _text, _selected);
        }
    }

    // ========================================
    // УНИВЕРСАЛЬНАЯ ОТРИСОВКА НАСТРОЕК
    // ========================================

    var _items = scrSettingsGetPageSettings(_menu);

    for (var i = 0; i < array_length(_items); i++)
    {
        var _item = _items[i];
        var _y = 180 + i * 65;
        var _selected = (i == _menu.selected_index);

        scrSettingsDrawItem(50 + _text_offset_x, _y, _item.label, _selected);

        var _value = variable_struct_get(global.settings, _item.setting);

        switch (_item.type)
        {
            case SETTING_TYPE.SLIDER:

                var _vis_val = (_value - _item.min) / (_item.max - _item.min);
                _vis_val = clamp(_vis_val, 0, 1);

                scrSettingsDrawSlider(500 + _text_offset_x, _y, 160, 8, _vis_val, _selected);

                var _display_value = round(_value * _item.display_scale);

                draw_set_halign(fa_right);
                draw_text(_gui_w - 50 + _toggle_offset_x, _y, string(_display_value) + _item.suffix);
                draw_set_halign(fa_left);

                break;

            case SETTING_TYPE.TOGGLE:

                scrSettingsDrawToggle(_gui_w - 50 + _toggle_offset_x, _y, 0, _value, _selected);

                break;
        }
    }

    // ========================================
    // ПОДСКАЗКИ
    // ========================================

    if (_menu.menu_state == SETTINGS_STATE.OPENING
    ||  _menu.menu_state == SETTINGS_STATE.CATEGORY
    ||  _menu.menu_state == SETTINGS_STATE.CLOSING)
    {
        var _is_closing = (_menu.menu_state == SETTINGS_STATE.CLOSING);
        var _right_offset = _is_closing ? -_offset_x : _offset_x;

        draw_set_font(fntMainMenu);
        draw_set_color(c_gray);
        draw_set_halign(fa_left);

        // ESC — движется вместе с названиями пунктов.

        draw_text(50 + _text_offset_x, _gui_h - 60, "ESC - BACK");

        // F12 — сохраняет прежнее направление.

        if (_menu.current_page == SETTINGS_PAGE.KEYBINDS)
        {
            draw_set_halign(fa_right);
            draw_text(_gui_w - 50 + _right_offset, _gui_h - 60, "F12 - DEFAULT");
        }
    }

    // ========================================
    // ВОССТАНОВЛЕНИЕ СОСТОЯНИЯ
    // ========================================

    draw_set_font(fntMainMenu);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
