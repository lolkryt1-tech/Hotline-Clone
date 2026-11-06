/// @function scrCameraShakeGetCategoryPresets
/// @description Возвращает массив пресетов для категории (для дропдауна).
function scrCameraShakeGetCategoryPresets(_category_id)
{
    for (var i = 0; i < array_length(global.camera_shake.categories); i++)
    {
        if (global.camera_shake.categories[i].id == _category_id)
        {
            return global.camera_shake.categories[i].presets;
        }
    }
    return [];
}