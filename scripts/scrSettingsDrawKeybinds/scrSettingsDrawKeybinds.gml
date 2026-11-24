/// @function scrSettingsDrawKeybinds(_menu, _gui_w, _gui_h, _offset_x)
/// @description Отрисовывает KEYBINDS и анимацию feedback.

function scrSettingsDrawKeybinds(_menu, _gui_w, _gui_h, _offset_x)
{
    var _layout = scrSettingsKeybindLayout(_gui_w, _gui_h);
    var _is_closing = (_menu.menu_state == SETTINGS_STATE.CLOSING);
    var _left_offset = _is_closing ? _offset_x : -_offset_x;
    var _right_offset = _is_closing ? -_offset_x : _offset_x;

    var _text_color = c_white;
    var _selected_color = make_color_rgb(255, 210, 60);
    var _muted_color = make_color_rgb(190, 190, 190);
    var _key_border_color = make_color_rgb(104, 104, 104);

    // FEEDBACK COLORS

    var _feedback_color = make_color_rgb(112, 217, 154);
    var _feedback_duration = 600;

    // COLUMN HEADERS

    draw_set_font(_layout.font_header);
    draw_set_color(_muted_color);
    draw_text(_layout.action_x + _left_offset, _layout.header_y, "ACTION");

    draw_set_halign(fa_right);
    draw_text(_layout.key_right + _right_offset, _layout.header_y, "KEY");
    draw_set_halign(fa_left);

    // LIST CLIPPING

    var _clip_left = 0;
    var _clip_top = _layout.list_top;
    var _clip_right = _gui_w;
    var _clip_bottom = _layout.list_bottom;

    var _clip_width = max(0, _clip_right - _clip_left);
    var _clip_height = max(0, _clip_bottom - _clip_top);

    if (_clip_width > 0 && _clip_height > 0)
    {
        var _previous_scissor = gpu_get_scissor();
        gpu_set_scissor(_clip_left, _clip_top, _clip_width, _clip_height);

        // ========================================
        // CATEGORY LIST
        // ========================================

        var _bind_count = array_length(global.bind_definitions);
        var _current_y = _layout.list_top + _layout.category_height * 0.5 - _menu.keybind_scroll_y;
        var _category_index = 0;

        for (var i = 0; i < _bind_count; i++)
        {
            var _def = global.bind_definitions[i];

            // CATEGORY HEADER

            if (_category_index < array_length(_layout.category_starts) && i == _layout.category_starts[_category_index])
            {
                draw_set_font(_layout.font_category);
                draw_set_color(_muted_color);
                draw_set_alpha(1);
                draw_text(_layout.action_x + _left_offset, _current_y, _layout.category_names[_category_index]);

                _current_y += _layout.category_height + _layout.category_to_row_gap;
                _category_index++;
            }

            // ROW POSITION

            var _y = _current_y;
            var _row_top = _y - _layout.row_height * 0.5;
            var _row_bottom = _y + _layout.row_height * 0.5;
            var _selected = (i == _menu.selected_index);

            // ACTION

            draw_set_font(_layout.font_action);
            draw_set_color(_selected ? _selected_color : _text_color);
            draw_set_alpha(1);
            draw_text(_layout.action_x + _left_offset, _y, _def.label);

            // KEY NAME

            var _key_code = global.settings.binds[$ _def.id];
            var _key_name = scrKeyCodeToName(_key_code);

            if (_menu.keybind_mode == KEYBIND_MODE.WAITING && i == _menu.keybind_rebind_index)
            {
                _key_name = "...";
            }
            else if (_key_code == -1)
            {
                _key_name = "-";
            }

            draw_set_font(_layout.font_key);

            // KEYCAP SIZE

            var _key_width = max(_layout.keycap_min_width, string_width(_key_name) + _layout.keycap_padding_x * 2);
            var _key_x2 = _layout.key_right + _right_offset;
            var _key_x1 = _key_x2 - _key_width;
            var _key_y1 = _y - _layout.keycap_height * 0.5;
            var _key_y2 = _key_y1 + _layout.keycap_height;
            var _key_center_x = (_key_x1 + _key_x2) * 0.5;
            var _key_center_y = (_key_y1 + _key_y2) * 0.5;

            // ========================================
            // FEEDBACK ANIMATION
            // ========================================

            var _feedback_active = ((array_contains(_menu.keybind_feedback_indices, i) || i == _menu.keybind_feedback_index) && current_time < _menu.keybind_feedback_timer);

            var _feedback_strength = 0;
            var _key_scale = 1;

            if (_feedback_active)
            {
                var _remaining = _menu.keybind_feedback_timer - current_time;
                var _progress = clamp(1 - (_remaining / _feedback_duration), 0, 1);

                // GREEN COLOR FADE

                var _color_progress = clamp((_progress - 0.45) / 0.55, 0, 1);
                _color_progress = _color_progress * _color_progress * (3 - 2 * _color_progress);
                _feedback_strength = 1 - _color_progress;

                // SCALE IMPULSE

                var _scale_progress = clamp(_progress / 0.35, 0, 1);
                _scale_progress = _scale_progress * _scale_progress * (3 - 2 * _scale_progress);
                _key_scale = 1 + 0.22 * (1 - _scale_progress);
            }

            // ========================================
            // KEYCAP BORDER
            // ========================================

            var _normal_border_color = _selected ? _selected_color : _key_border_color;
            var _border_color = _normal_border_color;

            if (_feedback_active)
            {
                _border_color = merge_color(_normal_border_color, _feedback_color, _feedback_strength);
            }

            var _scaled_half_width = _key_width * 0.5 * _key_scale;
            var _scaled_half_height = _layout.keycap_height * 0.5 * _key_scale;

            draw_set_color(_border_color);
            draw_set_alpha(1);
            draw_rectangle(_key_center_x - _scaled_half_width, _key_center_y - _scaled_half_height, _key_center_x + _scaled_half_width, _key_center_y + _scaled_half_height, true);

            // ========================================
            // KEY TEXT
            // ========================================

            var _normal_text_color = _selected ? _selected_color : _text_color;
            var _key_text_color = _normal_text_color;

            if (_feedback_active)
            {
                _key_text_color = merge_color(_normal_text_color, _feedback_color, _feedback_strength);
            }

            draw_set_halign(fa_center);
            draw_set_color(_key_text_color);
            draw_text_transformed(_key_center_x, _y, _key_name, _key_scale, _key_scale, 0);
            draw_set_halign(fa_left);

            // ========================================
            // DEBUG ROW
            // ========================================

            if (_menu.debug_layout)
            {
                draw_set_alpha(0.8);
                draw_set_color(c_gray);
                draw_rectangle(_layout.action_x + _left_offset, _row_top, _layout.key_right + _right_offset, _row_bottom, true);

                draw_set_alpha(1);
                draw_set_color(c_aqua);
                draw_line(0, _row_top, _gui_w, _row_top);
                draw_line(0, _row_bottom, _gui_w, _row_bottom);
            }

            // NEXT ROW

            _current_y += _layout.row_step;

            // CATEGORY SEPARATOR

            if (i == 5 || i == 11)
            {
                var _separator_y = _current_y + (_layout.category_spacing - _layout.row_spacing) * 0.5;
                var _separator_alpha = 0.4 * clamp(_menu.sub_title_progress, 0, 1);

                draw_set_color(c_white);
                draw_set_alpha(_separator_alpha);
                draw_line(_layout.action_x + _left_offset, _separator_y, _layout.key_right + _right_offset, _separator_y);
                draw_set_alpha(1);

                _current_y += _layout.category_spacing;
            }
        }

        // RESTORE PREVIOUS SCISSOR

        gpu_set_scissor(_previous_scissor.x, _previous_scissor.y, _previous_scissor.w, _previous_scissor.h);
    }

    // ========================================
    // DEBUG GEOMETRY
    // ========================================

    if (_menu.debug_layout)
    {
        draw_set_color(c_yellow);
        draw_rectangle(_layout.action_x, _layout.list_top, _layout.key_right, _layout.list_bottom, true);

        draw_set_font(fntMainMenu);
        draw_set_color(c_white);
        draw_text(_layout.action_x, _layout.footer_top - 45, "LAYOUT DEBUG: ON");

        // DEBUG SCROLL VALUES

        draw_set_font(_layout.font_header);
        draw_set_color(c_yellow);
        draw_set_halign(fa_left);

        var _debug_x = _gui_w - 430;
        var _debug_y = 35;
        var _debug_gap = 22;

        draw_text(_debug_x, _debug_y, "SCROLL Y: " + string_format(_menu.debug_scroll_y, 1, 2));
        draw_text(_debug_x, _debug_y + _debug_gap, "SCROLL TARGET: " + string_format(_menu.debug_scroll_target, 1, 2));
        draw_text(_debug_x, _debug_y + _debug_gap * 2, "MAX SCROLL: " + string_format(_menu.debug_scroll_max, 1, 2));
        draw_text(_debug_x, _debug_y + _debug_gap * 3, "SELECTED Y: " + string_format(_menu.debug_selected_y, 1, 2));
        draw_text(_debug_x, _debug_y + _debug_gap * 4, "VIEWPORT TOP: " + string_format(_menu.debug_viewport_top, 1, 2));
        draw_text(_debug_x, _debug_y + _debug_gap * 5, "VIEWPORT BOTTOM: " + string_format(_menu.debug_viewport_bottom, 1, 2));
        draw_text(_debug_x, _debug_y + _debug_gap * 6, "SELECTED INDEX: " + string(_menu.debug_selected_index));
        draw_text(_debug_x, _debug_y + _debug_gap * 7, "SELECTED SCREEN Y: " + string_format(_menu.debug_selected_y - _menu.keybind_scroll_y, 1, 2));
        draw_text(_debug_x, _debug_y + _debug_gap * 8, "ROW STEP: " + string_format(_layout.row_step, 1, 2));
    }

    // ========================================
    // RESTORE DRAW STATE
    // ========================================

    draw_set_font(fntMainMenu);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_alpha(1);
    draw_set_color(c_white);
}