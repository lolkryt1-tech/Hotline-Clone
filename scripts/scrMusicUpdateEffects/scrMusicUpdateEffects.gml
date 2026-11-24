/// @function scrMusicUpdateEffects()
/// @description Обновляет фильтры музыки.
function scrMusicUpdateEffects()
{
    // === ЕСЛИ ФИЛЬТРЫ ВЫКЛЮЧЕНЫ ===
    if (!global.settings.enable_music_filters)
    {
        // Плавно убираем эффекты
        music_lpf.cutoff = lerp(music_lpf.cutoff, normal_cutoff, muffle_speed);
        music_reverb.mix = lerp(music_reverb.mix, 0, muffle_speed);
        return;
    }

    // === ЕСЛИ ФИЛЬТРЫ ВКЛЮЧЕНЫ ===
    var _menu_active = false;
	
    if (instance_exists(objPauseMenu) && (objPauseMenu.is_paused == true)) 
    {
        _menu_active = true;
    }
	
    if (instance_exists(objSettingsMenu)) 
    {
        var _settings = instance_find(objSettingsMenu, 0);
        var _is_home_page = (_settings.current_page == SETTINGS_PAGE.HOME);
        var _is_music_selected = (_settings.selected_index == 1);
        
        if ((_is_home_page && _is_music_selected))
        {
            _menu_active = false;
        }
        else
        {
            _menu_active = true;
        }
    }

    // === LOW-PASS FILTER ===
    var _target_cutoff = normal_cutoff;

    if (_menu_active)
        _target_cutoff = min(_target_cutoff, menu_cutoff);

    if (instance_exists(objMusicMuffleZone))
        _target_cutoff = min(_target_cutoff, zone_cutoff);

    music_lpf.cutoff = lerp(music_lpf.cutoff, _target_cutoff, muffle_speed);

    // === REVERB ===
    var _target_reverb = _menu_active ? menu_reverb_mix : 0;
    music_reverb.mix = lerp(music_reverb.mix, _target_reverb, muffle_speed);
}