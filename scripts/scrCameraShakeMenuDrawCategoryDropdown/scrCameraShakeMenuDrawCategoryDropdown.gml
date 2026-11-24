function scrCameraShakeMenuDrawCategoryDropdown(_mx, _my)
{
    var _count = array_length(global.camera_shake.categories);
    var _visible = min(category_visible_count, _count);

    var _list_x = x + category_dropdown_x;
    var _list_y = y + category_dropdown_y;

    draw_set_color(make_color_rgb(30, 30, 36));
    draw_rectangle(_list_x, _list_y + category_item_h, _list_x + category_dropdown_w, _list_y + category_item_h + _visible * category_item_h, false);

    var _hover_index = floor((_my - (_list_y + category_item_h)) / category_item_h) + category_scroll;
    var _hover_valid = _mx >= _list_x
        && _mx < _list_x + category_dropdown_w
        && _my >= _list_y + category_item_h
        && _my < _list_y + category_item_h + _visible * category_item_h;

    for (var i = 0; i < _visible; i++)
    {
        var _index = i + category_scroll;
        if (_index >= _count) break;

        var _item_y = _list_y + category_item_h + i * category_item_h;
        var _cat = global.camera_shake.categories[_index];

        var _selected = _cat.id == selected_category;
        var _hover = _hover_valid && _hover_index == _index;

        if (_selected)
        {
            draw_set_color(make_color_rgb(65, 85, 105));
            draw_rectangle(_list_x, _item_y, _list_x + category_dropdown_w, _item_y + category_item_h, false);
        }
        else if (_hover)
        {
            draw_set_color(make_color_rgb(65, 65, 80));
            draw_rectangle(_list_x, _item_y, _list_x + category_dropdown_w, _item_y + category_item_h, false);
        }

        draw_set_color(gui_text_color);
        draw_text(_list_x + 8, _item_y + category_item_h * 0.5, _cat.name);
    }

    draw_set_color(make_color_rgb(100, 100, 115));
    draw_rectangle(_list_x, _list_y + category_item_h, _list_x + category_dropdown_w, _list_y + category_item_h + _visible * category_item_h, true);
}