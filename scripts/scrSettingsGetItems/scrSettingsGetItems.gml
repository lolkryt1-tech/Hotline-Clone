/// @function scrSettingsGetItems(_menu)
/// @description Возвращает массив пунктов текущей категории.

function scrSettingsGetItems(_menu)
{
    switch (_menu.current_page)
    {
        case SETTINGS_PAGE.VOLUME_EXTRA:
            return _menu.volume_extra_items;

        case SETTINGS_PAGE.GAME:
        case SETTINGS_PAGE.VISUAL:
        case SETTINGS_PAGE.CONTROLS:
            return [];
    }

    return [];
}