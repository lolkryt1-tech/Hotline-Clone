
/// @function scrSettingsValues(_menu, _direction, _activate)
/// @description Универсально изменяет значения настроек на основе описания выбранного пункта.

function scrSettingsValues(_menu, _direction, _activate)
{
    // ========================================
    // ПОЛУЧАЕМ ОПИСАНИЕ ВЫБРАННОГО ПУНКТА
    // ========================================

    var _items = scrSettingsGetPageSettings(_menu);

    if (_menu.selected_index < 0
    ||  _menu.selected_index >= array_length(_items))
    {
        return;
    }

    var _item = _items[_menu.selected_index];

    // ========================================
    // ОБРАБОТКА В ЗАВИСИМОСТИ ОТ ТИПА
    // ========================================

    switch (_item.type)
    {
        // ========================================
        // ПОЛЗУНОК
        // ========================================

        case SETTING_TYPE.SLIDER:

            if (_direction == 0)
                return;

            var _value = variable_struct_get(global.settings, _item.setting);

            _value += _direction * _item.step;
            _value = clamp(_value, _item.min, _item.max);

            variable_struct_set(global.settings, _item.setting, _value);

            // Звуки применяем сразу.
            if (_item.setting == "sound_volume")
            {
                scrSettingsApply();
            }

            scrSettingsSave();

            break;

        // ========================================
        // ПЕРЕКЛЮЧАТЕЛЬ
        // ========================================

        case SETTING_TYPE.TOGGLE:

            // Переключение через Enter или стрелки.
            if (!_activate && _direction == 0)
                return;

            var _value = variable_struct_get(global.settings, _item.setting);

            variable_struct_set(global.settings, _item.setting, !_value);

            scrSettingsSave();

            break;

        // ========================================
        // ДЕЙСТВИЕ
        // ========================================

        case SETTING_TYPE.ACTION:

            // Пока действия не подключены.
            break;

        // ========================================
        // ОБЫЧНЫЙ ПУНКТ
        // ========================================

        case SETTING_TYPE.NONE:
            break;
    }
}
