/// @function scrCameraShakeMenuGetEffectData
/// @description Возвращает структуру параметров эффекта с учётом его состояния.
/// @param {struct} _preset Пресет тряски камеры, из которого берутся параметры.
/// @param {string} _effect Название эффекта: "kick", "bounce" или "perlin".
/// @returns {struct} Структура активных или сохранённых параметров эффекта.

function scrCameraShakeMenuGetEffectData(_preset, _effect)
{
    var _enabled = variable_struct_get(_preset, _effect + "_enabled");
    return variable_struct_get(_preset, _enabled ? _effect : _effect + "_saved");
}