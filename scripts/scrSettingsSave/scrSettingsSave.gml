/// @function scrSettingsSave()
/// @description Сохраняет настройки в INI.

function scrSettingsSave()
{
    ini_open("game_settings.ini");

    // === AUDIO ===
    ini_write_real("Audio", "sound_volume", global.settings.sound_volume);

    ini_write_real("Audio", "music_volume", global.settings.music_volume);
	
	ini_write_real("Audio", "enable_music_filters", global.settings.enable_music_filters ? 1 : 0);

    ini_close();
}