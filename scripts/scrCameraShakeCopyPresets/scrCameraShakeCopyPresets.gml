/// @description Копирует настройки всех видов оружия
/// из одной структуры пресетов в другую.
///
/// @param {Struct} _source Исходные пресеты
/// @param {Struct} _target Структура, в которую копируются настройки


function scrCameraShakeCopyPresets(_source, _target)
{
    scrCameraShakeCopyPreset(_source.pistol, _target.pistol);
    scrCameraShakeCopyPreset(_source.shotgun, _target.shotgun);
    scrCameraShakeCopyPreset(_source.m16, _target.m16);
    scrCameraShakeCopyPreset(_source.sniper, _target.sniper);
}