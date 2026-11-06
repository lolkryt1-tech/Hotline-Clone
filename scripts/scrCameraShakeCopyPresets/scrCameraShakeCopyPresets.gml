/// @description Копирует настройки всех видов оружия
/// из одной структуры пресетов в другую.
///
/// @param {Struct} _source Исходные пресеты
/// @param {Struct} _target Структура, в которую копируются настройки


function scrCameraShakeCopyPresets(_source, _target)
{
    for (var i = 0; i < array_length(global.camera_shake.categories); i++)
    {
        var _cat = global.camera_shake.categories[i];
        var _src_cat = variable_struct_get(_source, _cat.id);
        var _tgt_cat = variable_struct_get(_target, _cat.id);

        for (var j = 0; j < array_length(_cat.presets); j++)
        {
            var _pid = _cat.presets[j].id;
            scrCameraShakeCopyPreset(
                variable_struct_get(_src_cat, _pid),
                variable_struct_get(_tgt_cat, _pid)
            );
        }
    }
}