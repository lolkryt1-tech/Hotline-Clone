/// @function scrSettingsGetSettingItems(_menu)
/// @description Возвращает список настроек текущей страницы.

function scrSettingsGetPageSettings(_menu)
{
    var _page = _menu.current_page;

    if (_page < 0 || _page >= array_length(_menu.settings_page_items))
    {
        return [];
    }

    return _menu.settings_page_items[_page];
}