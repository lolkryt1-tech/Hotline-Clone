/// @function scrSettingsApply()
/// @description Применяет настройки игры.

function scrSettingsApply()
{
    audio_group_set_gain(
        audiogroup_sounds,
        global.settings.sound_volume,
        0
    );
}