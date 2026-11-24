
/// @function scrSettingsOpenPage(_menu)
/// @description Открывает выбранную страницу настроек.

function scrSettingsOpenPage(_menu)
{
    if (_menu.menu_state != SETTINGS_STATE.HOME
    &&  _menu.menu_state != SETTINGS_STATE.OPENING
    &&  _menu.menu_state != SETTINGS_STATE.CATEGORY
    &&  _menu.menu_state != SETTINGS_STATE.CLOSING)
        return;

    var _stack_top = _menu.page_stack[array_length(_menu.page_stack) - 1];
    var _selected = _menu.selected_index;
    var _page = -1;
    var _title = "";
    var _sub = "";

    if (_stack_top == SETTINGS_PAGE.HOME)
    {
        var _items = _menu.settings_page_items[SETTINGS_PAGE.HOME];

        if (_selected >= 0 && _selected < array_length(_items))
        {
            var _item = _items[_selected];

            if (_item.type == SETTING_TYPE.NONE)
            {
                _page = _item.page;
                _title = _item.label;
            }
        }
    }
    else if (variable_struct_exists(_menu.page_children, _stack_top))
    {
        var _children = variable_struct_get(_menu.page_children, _stack_top);

        if (_selected >= 0 && _selected < array_length(_children))
        {
            _page = _children[_selected];
            _title = scrSettingsGetPageTitle(_stack_top);
            _sub = scrSettingsGetPageTitle(_page);

            // Позиции подзаголовка и анимации родительской категории.

            _menu.sub_title_start_x = 50;
            _menu.sub_title_start_y = 180 + _selected * 65;

            draw_set_font(fntMainMenu);

            var _parent_w = string_width(_title);

            _menu.sub_title_target_x = 50 + _parent_w + 20;
            _menu.sub_title_target_y = 60;

            if (_menu.sub_title != _sub)
                _menu.sub_title_progress = 0;

            _menu.sub_title = _sub;

            if (_menu.depth_current < 0.99)
            {
                // Находим индекс родительской категории на HOME.

                var _home_items = _menu.settings_page_items[SETTINGS_PAGE.HOME];
                var _parent_idx = -1;

                for (var i = 0; i < array_length(_home_items); i++)
                {
                    if (_home_items[i].page == _stack_top)
                    {
                        _parent_idx = i;
                        break;
                    }
                }

                if (_parent_idx != -1)
                {
                    var _start_y = 270 + (_parent_idx - 2) * 55;

                    _menu.parent_fly_y_current = lerp(_start_y, 60, _menu.depth_current);
                    _menu.parent_fly_start_y = _start_y;
                    _menu.parent_fly_progress = _menu.depth_current;
                }
            }
            else
            {
                _menu.parent_fly_y_current = 60;
                _menu.parent_fly_progress = 1;
            }
        }
    }

    if (_page == -1) return;

    _menu.page_title = _title;

    scrSettingsPushPage(_menu, _page);
    audio_play_sound(sndPauseMenuScroll, 0, false);
}
