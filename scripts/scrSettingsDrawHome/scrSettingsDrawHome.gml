
/// @function scrSettingsDrawHome(_menu, _gui_w)
/// @description Отрисовывает главную страницу настроек.

function scrSettingsDrawHome(_menu, _gui_w)
{
    var _offset_x = _menu.home_offset_x;
    var _depth = _menu.depth_current;
    var _selected_index = _menu.transition_selected_index;

    draw_set_color(c_white);
    draw_text(50 + _offset_x, 60, "SETTINGS");

    // ========================================
    // ЭЛЕМЕНТЫ ГЛАВНОЙ СТРАНИЦЫ
    // ========================================

    var _slider_x = 280;
    var _slider_w = 160;
    var _slider_h = 8;

    var _item_count = array_length(_menu.home_menu_items);

    for (var i = 0; i < _item_count; i++)
    {
        var _item = _menu.home_menu_items[i];
        var _selected = (i == _menu.selected_index);

        // ========================================
        // ПОЛЗУНКИ
        // ========================================

        if (_item.type == SETTING_TYPE.SLIDER)
        {
            var _y = 145 + i * 55;
            var _value = variable_struct_get(global.settings, _item.setting);

            // Название настройки.
            scrSettingsDrawItem(50 + _offset_x, _y, _item.label, _selected);

            // Ползунок.
            scrSettingsDrawSlider(
                _slider_x + _offset_x,
                _y,
                _slider_w,
                _slider_h,
                _value,
                _selected
            );

            // Значение справа от ползунка.
            var _display_value = round(_value * _item.display_scale);

            draw_set_halign(fa_right);
            draw_text(_gui_w - 50 + _menu.volume_percent_offset_x, _y, string(_display_value) + _item.suffix);
            draw_set_halign(fa_left);
        }

        // ========================================
        // КАТЕГОРИИ
        // ========================================

        else
        {
            var _category_index = i - 2;
            var _y = 270 + _category_index * 55;

            // Выбранная категория перемещается вверх пропорционально глубине.
            // При depth 0 — на месте. При depth 1 — на месте заголовка.
            // При depth > 1 — уже давно уехала (формула даёт y < 60, за экраном).
            if (_menu.transition_active && i == _selected_index)
            {
                var _target_x = 50;
                var _target_y = 60;

                var _draw_x = lerp(50, _target_x, _depth);
                var _draw_y = lerp(_y, _target_y, _depth);

                scrSettingsDrawItem(_draw_x, _draw_y, _item.label, false);
            }
            else
            {
                scrSettingsDrawItem(50 + _offset_x, _y, _item.label, _selected);
            }
        }
    }
}
