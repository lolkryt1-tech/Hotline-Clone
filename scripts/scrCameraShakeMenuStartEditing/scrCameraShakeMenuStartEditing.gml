/// @function scrCameraShakeMenuStartEditing
/// @description Активирует текстовое поле выбранного ползунка.
/// @param {real} _index Индекс ползунка в массиве sliders.

function scrCameraShakeMenuStartEditing(_index)
{
    var _slider = sliders[_index];
    var _preset = variable_struct_get(global.camera_shake.presets, selected_preset);
    var _data = scrCameraShakeMenuGetEffectData(_preset, _slider.effect);
    var _value = variable_struct_get(_data, _slider.field);

    editing_slider = _index;

    editing_value = string_format(_value, 1, 2);
    editing_original_value = editing_value;
    editing_last_valid_value = _value;

    editing_cursor = string_length(editing_value);
    editing_selection_start = editing_cursor;
    editing_selection_end = editing_cursor;

    editing_mouse_select = false;

    keyboard_string = "";
}