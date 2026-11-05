/// @description Обрабатывает нажатия на интерактивные элементы меню Camera Shake.
/// Проверяет нажатия на кнопку закрытия, SAVE, CANCEL, DEFAULT,
/// выбор пресета, ползунки и переключатели эффектов.
/// Также запускает перетаскивание окна за заголовок.
///
/// @returns {bool} True, если нажатие обработано;
/// false, если ни один элемент не был активирован.

function scrCameraShakeMenuHandleButtons(_mx, _my)
{
	// === ЗАКРЫТИЕ МЕНЮ ===
	var _close_x = x + window_w - title_h;
	var _close_y = y;

	var _close_hover = point_in_rectangle(_mx, _my, _close_x, _close_y, _close_x + title_h, _close_y + title_h);

	if (_close_hover)
	{
	    scrCameraShakeMenuClose();
	    return true;
	}
	
	
   // === КНОПКИ СОХРАНЕНИЯ ===
	var _button_y = y + action_button_y;
	var _save_x = x + 12;
	var _cancel_x = _save_x + action_button_w + action_button_gap;
	var _default_x = _cancel_x + action_button_w + action_button_gap;

	var _save_hover = point_in_rectangle(_mx, _my, _save_x, _button_y, _save_x + action_button_w, _button_y + action_button_h);
	var _cancel_hover = point_in_rectangle(_mx, _my, _cancel_x, _button_y, _cancel_x + action_button_w, _button_y + action_button_h);
	var _default_hover = point_in_rectangle(_mx, _my, _default_x, _button_y, _default_x + action_button_w, _button_y + action_button_h);

	// DEFAULT

	if (_default_hover)
	{
	    var _defaults = scrCameraShakeCreatePresets();
	    var _default_preset = variable_struct_get(_defaults, selected_preset);
	    var _preset = variable_struct_get(global.camera_shake.presets, selected_preset);

	    scrCameraShakeCopyPreset(_default_preset, _preset);

	    return true;
	}

	// SAVE и CANCEL доступны только при наличии изменений

	if (scrCameraShakeHasChanges())
	{
	    if (_save_hover)
		{
		    scrCameraShakeSave();

		    global.camera_shake.backup = scrCameraShakeCreatePresets();
		    scrCameraShakeCopyPresets(global.camera_shake.presets, global.camera_shake.backup);
		    global.camera_shake.backup_enabled = global.camera_shake.enabled;

		    return true;
		}

	   if (_cancel_hover)
		{
		    scrCameraShakeCopyPresets(global.camera_shake.backup, global.camera_shake.presets);
		    global.camera_shake.enabled = global.camera_shake.backup_enabled;

		    return true;
		}
	}
	
	
    // === ВЫБОР ПРЕСЕТА ===

    var _list_x = x + preset_dropdown_x;
    var _list_y = y + preset_dropdown_y;

    var _dropdown_hover = point_in_rectangle(
        _mx, _my,
        _list_x, _list_y,
        _list_x + preset_dropdown_w,
        _list_y + preset_item_h
    );

    if (_dropdown_hover)
    {
        preset_dropdown_open = true;
        return true;
    }

    // === ПОЛЗУНКИ ===

    for (var i = 0; i < array_length(sliders); i++)
    {
        var _slider = sliders[i];

        var _track_x = x + slider_x;
        var _track_y = y + _slider.y + 20;

        var _hover = point_in_rectangle(
            _mx, _my,
            _track_x - 8, _track_y - 8,
            _track_x + slider_w + 8, _track_y + 8
        );

        if (_hover)
		{
		    var _preset = variable_struct_get(global.camera_shake.presets, selected_preset);
		    var _enabled = variable_struct_get(_preset, _slider.effect + "_enabled");

		    if (!_enabled) return true;

		    slider_dragging = i;

		    var _data = scrCameraShakeMenuGetEffectData(_preset, _slider.effect);

		    var _progress = clamp((_mx - (x + slider_x)) / slider_w, 0, 1);
		    var _value = lerp(_slider.min, _slider.max, _progress);

		    variable_struct_set(_data, _slider.field, _value);
		    return true;
		}
    }

    // === ПЕРЕКЛЮЧАТЕЛИ ЭФФЕКТОВ ===

    var _preset = variable_struct_get(global.camera_shake.presets, selected_preset);
    var _effects = ["kick", "bounce", "perlin"];

    for (var i = 0; i < array_length(_effects); i++)
    {
        var _button_x = x + effect_button_x + i * (effect_button_w + effect_button_gap);
        var _button_y = y + effect_button_y;

        var _hover = point_in_rectangle(
            _mx, _my,
            _button_x, _button_y,
            _button_x + effect_button_w,
            _button_y + effect_button_h
        );

        if (_hover)
        {
            scrCameraShakeToggle(_preset, _effects[i]);
            return true;
        }
    }

    // === ПЕРЕТАСКИВАНИЕ ЗА ЗАГОЛОВОК ===

    var _title_hover = point_in_rectangle(_mx, _my, x, y, x + window_w, y + title_h);

    if (_title_hover)
    {
        dragging = true;

        drag_offset_x = _mx - x;
        drag_offset_y = _my - y;

        return true;
    }

    return false;
}