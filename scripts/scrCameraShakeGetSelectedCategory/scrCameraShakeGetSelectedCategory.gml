/// @function scrCameraShakeGetSelectedCategory
/// @description Возвращает структуру категории текущего выбранного пресета.
function scrCameraShakeGetSelectedCategory()
{
    var _menu = objCameraShakeMenu;
    for (var i = 0; i < array_length(global.camera_shake.categories); i++)
    {
        if (global.camera_shake.categories[i].id == _menu.selected_category)
        {
            return global.camera_shake.categories[i];
        }
    }
    return undefined;
}