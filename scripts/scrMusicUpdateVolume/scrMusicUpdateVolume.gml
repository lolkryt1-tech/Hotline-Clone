/// @function scrMusicUpdateVolume()
/// @description Обновляет громкость музыки
function scrMusicUpdateVolume()
{
    // === ПРОВЕРКА УСЛОВИЙ ===
    var _zone_active = instance_exists(objMusicMuffleZone);
    var _menu_active = false;

    if (instance_exists(objPauseMenu) && objPauseMenu.is_paused) 
    {
        _menu_active = true;
    }
    
    if (instance_exists(objSettingsMenu)) 
    {
        var _settings = instance_find(objSettingsMenu, 0);
        var _is_volume_page = (_settings.current_page == SETTINGS_PAGE.HOME);
        var _is_music_selected = (_settings.selected_index == 1);
        
        if (!(_is_volume_page && _is_music_selected))
        {
            _menu_active = true;
        }
    }

    // === VOLUME ===
    var _volume = global.settings.music_volume;

    if (_zone_active)
        _volume *= zone_volume;

    if (_menu_active)
        _volume *= menu_volume;

    audio_emitter_gain(music_emitter, _volume);
}