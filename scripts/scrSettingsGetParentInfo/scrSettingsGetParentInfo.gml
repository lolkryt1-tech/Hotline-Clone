/// @function scrSettingsGetParentInfo(_menu)
/// @description Возвращает информацию о родителе текущей страницы.
function scrSettingsGetParentInfo(_menu)
{
    var _result = { parent_page: -1, parent_items: [], sub_index: -1 };

    // Если мы рисуем уезжающую страницу (CLOSING), current_page ещё старая,
    // а стек уже уменьшился. Смотрим на current_page.
    var _check_page = _menu.current_page;
    
    // Ищем, является ли current_page подстраницей какой-либо страницы из стека.
    var _len = array_length(_menu.page_stack);
    
    for (var L = 0; L < _len; L++)
    {
        var _parent = _menu.page_stack[L];
        
        if (variable_struct_exists(_menu.page_children, _parent))
        {
            var _children = variable_struct_get(_menu.page_children, _parent);
            for (var i = 0; i < array_length(_children); i++)
            {
                if (_children[i] == _check_page)
                {
                    _result.parent_page  = _parent;
                    _result.parent_items = variable_struct_get(_menu.page_items, _parent);
                    _result.sub_index    = i;
                    return _result;
                }
            }
        }
    }

    return _result;
}