function scrCameraShakeMenuHandleCategoryDropdown(_mx, _my, _pressed)
{
    if (!category_dropdown_open) return false;

    var _count = array_length(global.camera_shake.categories);
    var _visible = min(category_visible_count, _count);

    var _list_x = x + category_dropdown_x;
    var _list_y = y + category_dropdown_y;

    var _button_hover = point_in_rectangle(
        _mx, _my,
        _list_x, _list_y,
        _list_x + category_dropdown_w,
        _list_y + category_item_h
    );

    var _list_hover = point_in_rectangle(
        _mx, _my,
        _list_x, _list_y + category_item_h,
        _list_x + category_dropdown_w,
        _list_y + category_item_h + _visible * category_item_h
    );

    if (_list_hover)
    {
        if (mouse_wheel_up())   category_scroll = max(0, category_scroll - 1);
        if (mouse_wheel_down()) category_scroll = min(max(0, _count - category_visible_count), category_scroll + 1);
    }

    if (_pressed)
    {
        if (_button_hover)
        {
            category_dropdown_open = false;
        }
        else if (_list_hover)
        {
            var _item = floor((_my - (_list_y + category_item_h)) / category_item_h);
            var _index = _item + category_scroll;

            if (_index >= 0 && _index < _count)
            {
                var _cat = global.camera_shake.categories[_index];

                if (_cat.id != selected_category)
                {
                    selected_category = _cat.id;
                    category_scroll = 0;
                    preset_scroll = 0;

                    // 1. Определяем пресет по умолчанию (первый в категории)
                    var _default_preset = _cat.presets[0].id;
                    
                    // 2. Если категория — WEAPONS, берём пресет текущего оружия
                    if (_cat.id == "weapons" && instance_exists(objPlayer))
                    {
                        var _weapon_str = scrCameraShakeWeaponToString(objPlayer.current_weapon);
                        if (_weapon_str != "") _default_preset = _weapon_str;
                    }
                    
                    // 3. Если зашли в EXECUTIONS — берём казнь, соответствующую ВЫБРАННОМУ В МЕНЮ оружию
                    // (игрок не должен видеть сброс казни, если он смотрит настройки другого оружия)
                    if (_cat.id == "executions" && !execution_manually_selected)
                    {
                        var _weapon_cat = variable_struct_get(global.camera_shake.presets, "weapons");
                        var _weapon_preset = variable_struct_get(_weapon_cat, selected_preset);
                        
                        if (_weapon_preset != undefined && variable_struct_exists(_weapon_preset, "exec")) 
                        {
                            var _exec_id = _weapon_preset.exec;
                            if (_exec_id != "") _default_preset = _exec_id;
                        }
                    }
                    
                    selected_preset = _default_preset;

                    // 4. Пересчитываем max_current и синхронизируем
                    var _cat_presets = variable_struct_get(global.camera_shake.presets, selected_category);
                    var _preset = variable_struct_get(_cat_presets, selected_preset);
                    
                    for (var j = 0; j < array_length(sliders); j++)
                    {
                        var _data = scrCameraShakeMenuGetEffectData(_preset, sliders[j].effect);
                        var _v = variable_struct_get(_data, sliders[j].field);
                        sliders[j].max_current = max(sliders[j].max, _v);
                    }

                    scrCameraShakeMenuSyncTextboxes();
                }
            }

            category_dropdown_open = false;
        }
        else
        {
            category_dropdown_open = false;
        }
    }

    return true;
}