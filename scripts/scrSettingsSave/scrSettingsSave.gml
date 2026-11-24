/// @function scrSettingsSave()
/// @description Сохраняет настройки в INI.

function scrSettingsSave()
{
    ini_open("game_settings.ini");
	
	// === ИГРА ===
	ini_write_real("Game", "enable_tips", global.settings.enable_tips);
	
	// === ВИЗУАЛ ===
	ini_write_real("Visual", "crosshair_size", global.settings.crosshair_size);

    // === АУДИО ===
    ini_write_real("Audio", "sound_volume", global.settings.sound_volume);
    ini_write_real("Audio", "music_volume", global.settings.music_volume);
    ini_write_real("Audio", "enable_music_filters", global.settings.enable_music_filters ? 1 : 0);

    // === БИНДЫ ===
    for (var i = 0; i < array_length(global.bind_definitions); i++)
    {
        var _def = global.bind_definitions[i];
        var _key = global.settings.binds[$ _def.id];
        ini_write_real("Keybinds", _def.id, _key);
    }
	
	// === МЫШЬ ===
	ini_write_real("Mouse", "sensitivity", global.settings.mouse_sensitivity);
    ini_write_real("Mouse", "camera_roughness", global.settings.camera_roughness);
	ini_write_real("Mouse", "raw_camera", global.settings.raw_camera ? 1 : 0);

    ini_close();
}