/// @function scrAudioSetVolume(_group, _volume)
/// @description Устанавливает громкость звуковой группы.

function scrAudioSetVolume(_group, _volume)
{
    _volume = clamp(_volume, 0, 1);

    switch (_group)
    {
        case audiogroup_sounds:
            global.sound_volume = _volume;
            break;

        case audiogroup_music:
            global.music_volume = _volume;
            break;
    }

    audio_group_set_gain(_group, _volume, 0);
}