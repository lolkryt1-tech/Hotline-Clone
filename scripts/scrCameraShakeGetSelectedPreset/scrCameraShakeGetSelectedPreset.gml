/// @function scrCameraShakeGetSelectedPreset
/// @description Возвращает структуру текущего выбранного пресета (из objCameraShakeMenu).
function scrCameraShakeGetSelectedPreset()
{
    var _menu = objCameraShakeMenu;
    var _cat_presets = variable_struct_get(global.camera_shake.presets, _menu.selected_category);
    return variable_struct_get(_cat_presets, _menu.selected_preset);
}