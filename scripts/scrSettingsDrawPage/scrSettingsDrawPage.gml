/// @function scrSettingsDrawPage(_menu, _gui_w, _gui_h)
/// @description Отрисовывает внутреннюю страницу настроек.

function scrSettingsDrawPage(_menu, _gui_w, _gui_h)
{
    var _offset_x = _menu.page_offset_x;

    // === ЗАГОЛОВОК ===
    if (_menu.menu_state == SETTINGS_STATE.CATEGORY)
	{
	    draw_set_color(c_white);
	    draw_text(50 + _offset_x, 60, _menu.page_title);
	}

    // === СОДЕРЖИМОЕ СТРАНИЦЫ ===
    if (_menu.current_page == SETTINGS_PAGE.VOLUME_EXTRA)
    {
        for (var i = 0; i < array_length(_menu.volume_extra_items); i++)
        {
            var _y = 180 + i * 65;
            var _selected = (i == _menu.selected_index);
            var _text = _menu.volume_extra_items[i];

            scrSettingsDrawItem(50 + _offset_x, _y, _text, _selected);

            scrSettingsDrawToggle(_gui_w - 50 + _offset_x, _y, 0, global.settings.enable_music_filters, _selected);
        }
    }
    else
    {
        draw_set_color(c_gray);
        draw_text(50 + _offset_x, 180, "UNDER CONSTRUCTION");
    }

    // === ПОДСКАЗКА ВНИЗУ ===
    draw_set_color(c_gray);
    draw_text(50 + _offset_x, _gui_h - 60, "ESC - BACK");
}