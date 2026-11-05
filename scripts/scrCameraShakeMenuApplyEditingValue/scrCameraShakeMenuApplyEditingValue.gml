/// @function scrCameraShakeMenuApplyEditingValue
/// @description Применяет корректное числовое значение из активного поля.

function scrCameraShakeMenuApplyEditingValue()
{
    if (editing_slider == -1) return;

    var _text = editing_value;

    if (_text == "" || _text == ".") return;

    var _value = real(_text);

    var _slider = sliders[editing_slider];
    var _preset = variable_struct_get(global.camera_shake.presets, selected_preset);
    var _data = scrCameraShakeMenuGetEffectData(_preset, _slider.effect);

    if (_value < _slider.min) return;

    editing_last_valid_value = _value;

    variable_struct_set(_data, _slider.field, _value);
}