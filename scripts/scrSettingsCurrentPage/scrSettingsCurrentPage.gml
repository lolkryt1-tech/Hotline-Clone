/// @function scrSettingsCurrentPage(_menu)
/// @description Геттер верхушки стека.
function scrSettingsCurrentPage(_menu)
{
    return _menu.page_stack[array_length(_menu.page_stack) - 1];
}