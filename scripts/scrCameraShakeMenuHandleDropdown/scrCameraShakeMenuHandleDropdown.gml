function scrCameraShakeMenuHandleDropdown(_mx, _my, _pressed)
{
    if (!preset_dropdown_open) return false;

    var _list_count = array_length(weapon_presets);
    var _list_visible = min(preset_visible_count, _list_count);

    var _list_x = x + preset_dropdown_x;
    var _list_y = y + preset_dropdown_y;

    var _button_hover = point_in_rectangle(
        _mx, _my,
        _list_x, _list_y,
        _list_x + preset_dropdown_w,
        _list_y + preset_item_h
    );

    var _list_hover = point_in_rectangle(
        _mx, _my,
        _list_x, _list_y + preset_item_h,
        _list_x + preset_dropdown_w,
        _list_y + preset_item_h + _list_visible * preset_item_h
    );

    if (_list_hover)
    {
        if (mouse_wheel_up())
        {
            preset_scroll = max(0, preset_scroll - 1);
        }

        if (mouse_wheel_down())
        {
            preset_scroll = min(max(0, _list_count - preset_visible_count), preset_scroll + 1);
        }
    }

    if (_pressed)
    {
        if (_button_hover)
        {
            preset_dropdown_open = false;
        }
        else if (_list_hover)
        {
            var _item = floor((_my - (_list_y + preset_item_h)) / preset_item_h);
            var _index = _item + preset_scroll;

            if (_index >= 0 && _index < _list_count)
            {
                selected_preset = weapon_presets[_index].id;
            }

            preset_dropdown_open = false;
        }
        else
        {
            preset_dropdown_open = false;
        }
    }

    return true;
}