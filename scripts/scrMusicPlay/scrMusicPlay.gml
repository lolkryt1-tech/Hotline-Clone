/// @function scrMusicPlay(_filepath, _loop, _fade_frames)
/// @description Запускает стриминговую музыку из Included Files.
/// @param {string} _filepath Путь к файлу, например "Music/Level-Cleared.ogg"
function scrMusicPlay(_filepath, _loop = true, _fade_frames = 60)
{
    with (objMusicManager)
    {
        music_pending_asset = _filepath;
        music_pending_loop = _loop;
        music_fade_duration = max(1, _fade_frames);
    }
}