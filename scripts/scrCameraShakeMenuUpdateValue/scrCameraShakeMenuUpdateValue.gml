function scrCameraShakeMenuUpdateValue(_index, _value)
{
    var _slider = sliders[_index];

    var _preset = scrCameraShakeGetSelectedPreset();
    var _data = scrCameraShakeMenuGetEffectData(_preset, _slider.effect);

    var _value_real = clamp(real(_value), _slider.min, _slider.max);

    variable_struct_set(_data, _slider.field, _value_real);
}