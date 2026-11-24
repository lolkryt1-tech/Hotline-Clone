/// @function scrSettingsGetItems(_menu)
/// @description Возвращает массив специальных пунктов меню.

function scrSettingsGetSpecialItems(_menu)
{
    switch (_menu.current_page)
    {
        case SETTINGS_PAGE.CONTROLS:
            return _menu.controls_menu_items;

        case SETTINGS_PAGE.KEYBINDS:
            return _menu.keys_items;
    }

    return [];
}
