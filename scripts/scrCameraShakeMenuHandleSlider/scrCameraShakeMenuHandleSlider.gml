/// @description Обрабатывает перетаскивание активного ползунка.
/// Проверяет, включён ли эффект, и обновляет его значение.
/// Если эффект выключен, прекращает перетаскивание.
///
/// @param {real} _mx Координата мыши по горизонтали в GUI.
///
/// @returns {bool} True, если ползунок обрабатывается;
/// false, если перетаскивание неактивно.

function scrCameraShakeMenuHandleSlider(_mx)
{
    if (slider_dragging == -1) return false;

    var _slider = sliders[slider_dragging];
    var _preset = scrCameraShakeGetSelectedPreset();
    var _enabled = variable_struct_get(_preset, _slider.effect + "_enabled");

    if (!_enabled)
    {
        slider_dragging = -1;
        return true;
    }

    if (mouse_check_button(mb_left))
    {
        var _data = scrCameraShakeMenuGetEffectData(_preset, _slider.effect);

        var _progress = clamp((_mx - (x + slider_x)) / slider_w, 0, 1);
        var _value = lerp(_slider.min, _slider.max_current, _progress);

        variable_struct_set(_data, _slider.field, _value);
    }
    else
    {
        slider_dragging = -1;
    }

    return true;
}
