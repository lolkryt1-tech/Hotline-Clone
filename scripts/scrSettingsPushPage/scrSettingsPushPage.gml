/// @function scrSettingsPushPage(_menu, _page)
/// @description Открывает подстраницу: кладёт в стек, запоминает выделение родителя.

function scrSettingsPushPage(_menu, _page)
{
    var _top = array_length(_menu.parent_selected_index_stack) - 1;
    _menu.parent_selected_index_stack[_top] = _menu.selected_index;

    array_push(_menu.page_stack, _page);
    array_push(_menu.parent_selected_index_stack, 0);
    _menu.selected_index = 0;

    _menu.current_page = _page;

    // Блокируем запуск переназначения на кадр открытия KEYBINDS.
    if (_page == SETTINGS_PAGE.KEYBINDS)
        _menu.keybind_block_start = true;

    // Если мы в процессе анимации, "догоняем" глубину до текущего уровня,
    // чтобы родитель не прыгал.
    _menu.depth_current = array_length(_menu.page_stack) - 2;

    _menu.depth_target = array_length(_menu.page_stack) - 1;
    _menu.menu_state = SETTINGS_STATE.OPENING;
    _menu.transition_selected_index = _menu.parent_selected_index_stack[_top];
}