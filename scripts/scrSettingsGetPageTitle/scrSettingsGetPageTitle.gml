/// @function scrSettingsGetPageTitle(_page)
/// @description Возвращает заголовок страницы по SETTINGS_PAGE.
function scrSettingsGetPageTitle(_page)
{
    switch (_page)
    {
        case SETTINGS_PAGE.HOME:         return "SETTINGS";
        case SETTINGS_PAGE.GAME:         return "GAME";
        case SETTINGS_PAGE.VISUAL:       return "VISUAL";
        case SETTINGS_PAGE.CONTROLS:     return "CONTROLS";
        case SETTINGS_PAGE.VOLUME_EXTRA: return "VOLUME EXTRA";
        case SETTINGS_PAGE.KEYBINDS:     return "KEYBINDS";
        case SETTINGS_PAGE.MOUSE:        return "MOUSE";
    }
    return "";
}