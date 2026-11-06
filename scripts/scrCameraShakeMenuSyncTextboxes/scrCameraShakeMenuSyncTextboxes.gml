function scrCameraShakeMenuSyncTextboxes()
{
    var _preset = scrCameraShakeGetSelectedPreset();

    is_syncing_textboxes = true;

    for (var i = 0; i < array_length(sliders); i++)
    {
        var _slider = sliders[i];

        if (_slider.textbox.IsFocused()) continue;

        var _data = scrCameraShakeMenuGetEffectData(_preset, _slider.effect);
        var _value = variable_struct_get(_data, _slider.field);

        _slider.textbox.SetValue(string_format(_value, 0, 2));
    }

    is_syncing_textboxes = false;
}