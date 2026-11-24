/// @function scrSettingsLoad()
/// @description Загружает настройки из INI.

function scrSettingsLoad()
{
    // 1. ОТКРЫВАЕМ ФАЙЛ
    ini_open("game_settings.ini");

    // 2. ЗАГРУЖАЕМ НАСТРОЙКИ
    global.settings = {

        // === Игра ===
        enable_tips: ini_read_real("Game", "enable_tips", 1),

        // === Визуал ===
        crosshair_size: clamp(ini_read_real("Visual", "crosshair_size", 1.0), 0, 3),

        // === Звуки + звуки экстра ===
        sound_volume: clamp(ini_read_real("Audio", "sound_volume", 1.0), 0, 1),
        music_volume: clamp(ini_read_real("Audio", "music_volume", 1.0), 0, 1),
        enable_music_filters: ini_read_real("Audio", "enable_music_filters", 1),

        // === Управление ===
        mouse_sensitivity: clamp(ini_read_real("Mouse", "sensitivity", 1.0), 0.1, 3.0),
        camera_roughness: clamp(ini_read_real("Mouse", "camera_roughness", 50), 5, 100),
        raw_camera: ini_read_real("Mouse", "raw_camera", 1),

        // === Бинды ===
        binds: {}
    };

    // 3. ИНИЦИАЛИЗАЦИЯ БИНДОВ
    for (var i = 0; i < array_length(global.bind_definitions); i++) {
        var _def = global.bind_definitions[i];
        var _default_key = _def.default_key;
        var _saved_key = ini_read_real("Keybinds", _def.id, _default_key);

        global.settings.binds[$ _def.id] = _saved_key;
    }

    // 4. ЗАКРЫВАЕМ ФАЙЛ
    ini_close();
}