/// @function scrSettingsLoad()
/// @description Загружает настройки из INI.

function scrSettingsLoad()
{
    // Значения по умолчанию
   global.settings = {
    sound_volume: 1.0,
    music_volume: 1.0,
    enable_music_filters: true
	};

    // Открываем файл
    ini_open("game_settings.ini");

    // Загружаем настройки аудио
    global.settings.sound_volume = clamp(ini_read_real("Audio", "sound_volume", 1.0), 0, 1);
    global.settings.music_volume = clamp(ini_read_real("Audio", "music_volume", 1.0), 0, 1);
	global.settings.enable_music_filters = ini_read_real("Audio", "enable_music_filters", 1) == 1;

    ini_close();
}