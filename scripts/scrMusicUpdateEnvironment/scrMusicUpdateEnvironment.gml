/// @function scrMusicUpdateEnvironment()
/// @description Управляет акустикой и громкостью музыки.

function scrMusicUpdateEnvironment()
{
    // === ПРОВЕРКА УСЛОВИЙ ===

    var _zone_active = instance_exists(objMusicMuffleZone);

    var _menu_active = false;
	if (instance_exists(objPauseMenu)) && objPauseMenu.is_paused 
    {
        // Проверяем, находится ли игрок в настройках звука на пункте Music Volume (индекс 0)
        var _is_adjusting_music = (objPauseMenu.menu_page == MENU_PAGE.OPTIONS && objPauseMenu.selected_index == 1);
        
        // Меню считается активным для приглушения ТОЛЬКО если мы НЕ настраиваем музыку прямо сейчас
        if (!_is_adjusting_music) 
        {
            _menu_active = true; 
        }
    }

    // === LOW-PASS FILTER ===

    var _target_cutoff = normal_cutoff;

    if (_menu_active)
    {
        _target_cutoff = min(_target_cutoff, menu_cutoff);
    }

    if (_zone_active)
    {
        _target_cutoff = min(_target_cutoff, zone_cutoff);
    }

    music_lpf.cutoff = lerp(music_lpf.cutoff, _target_cutoff, muffle_speed);

    // === REVERB ===

    var _target_reverb = _menu_active ? menu_reverb_mix : 0;

    music_reverb.mix = lerp(music_reverb.mix, _target_reverb, muffle_speed);

    // === VOLUME ===

    var _volume = global.settings.music_volume;

    if (_zone_active)
    {
        _volume *= zone_volume;
    }

    if (_menu_active)
    {
        _volume *= menu_volume;
    }

    audio_emitter_gain(music_emitter, _volume);
}