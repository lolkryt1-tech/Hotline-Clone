function scrCameraShakeMenuDrawDropdown()
{
	// Получаем массив и сортируем его по имени
    var _presets = scrCameraShakeGetCategoryPresets(selected_category);
        array_sort(_presets, function(_a, _b) {
        if (_a.name < _b.name) return -1;
        if (_a.name > _b.name) return 1;
        return 0;
    });
	
	var _count = array_length(_presets);
    var _visible = min(preset_visible_count, _count);

    var _list_x = x + preset_dropdown_x;
    var _list_y = y + preset_dropdown_y;

    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    // Фон списка.
    draw_set_color(make_color_rgb(30, 30, 36));
    draw_rectangle(_list_x, _list_y + preset_item_h, _list_x + preset_dropdown_w, _list_y + preset_item_h + _visible * preset_item_h, false);

    // Определяем номер пункта под курсором.
    var _hover_index = floor((_my - (_list_y + preset_item_h)) / preset_item_h) + preset_scroll;

    var _hover_valid = _mx >= _list_x
        && _mx < _list_x + preset_dropdown_w
        && _my >= _list_y + preset_item_h
        && _my < _list_y + preset_item_h + _visible * preset_item_h;

    // Элементы списка.
    for (var i = 0; i < _visible; i++)
    {
        var _index = i + preset_scroll;
        if (_index >= _count) break;

        var _item_y = _list_y + preset_item_h + i * preset_item_h;

        var _selected = _presets[_index].id == selected_preset;
        var _hover = _hover_valid && _hover_index == _index;

        if (_selected)
        {
            draw_set_color(make_color_rgb(65, 85, 105));
            draw_rectangle(_list_x, _item_y, _list_x + preset_dropdown_w, _item_y + preset_item_h, false);
        }
        else if (_hover)
        {
            draw_set_color(make_color_rgb(65, 65, 80));
            draw_rectangle(_list_x, _item_y, _list_x + preset_dropdown_w, _item_y + preset_item_h, false);
        }

        draw_set_color(gui_text_color);
        draw_text(_list_x + 8, _item_y + preset_item_h * 0.5, _presets[_index].name);
    }

    // Рамка списка.
    draw_set_color(make_color_rgb(100, 100, 115));
    draw_rectangle(_list_x, _list_y + preset_item_h, _list_x + preset_dropdown_w, _list_y + preset_item_h + _visible * preset_item_h, true);
}