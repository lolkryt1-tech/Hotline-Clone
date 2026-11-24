/// @function scrSettingsPopPage(_menu)
/// @description Закрывает текущую подстраницу. Если это HOME — сигнал наружу.
/// @returns {bool} true, если стек опустел (пора закрывать меню).
/// @function scrSettingsPopPage(_menu)
function scrSettingsPopPage(_menu)
{
    if (array_length(_menu.page_stack) <= 1) return true;

    _menu.depth_closing_start = _menu.depth_current;

    array_pop(_menu.page_stack);
    array_pop(_menu.parent_selected_index_stack);

    var _top = array_length(_menu.parent_selected_index_stack) - 1;
    _menu.selected_index = _menu.parent_selected_index_stack[_top];

    // Если мы в процессе анимации, "догоняем" глубину.
    _menu.depth_current = array_length(_menu.page_stack);

    _menu.depth_target = array_length(_menu.page_stack) - 1;
    _menu.menu_state = SETTINGS_STATE.CLOSING;

    _menu.transition_selected_index = _menu.parent_selected_index_stack[_top];

    return false;
}