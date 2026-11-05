/// @function scrMusicPlay(_sound, _loop, _fade_frames)
/// @description Запускает музыку, если нужно с переходом.
function scrMusicPlay(_sound, _loop = true, _fade_frames = 60)
{
    with (objMusicManager)
    {
        music_pending_asset = _sound;
        music_pending_loop = _loop;
        music_fade_duration = max(1, _fade_frames);
    }
}