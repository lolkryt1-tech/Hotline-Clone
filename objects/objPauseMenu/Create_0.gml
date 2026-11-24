enum MENU_PAGE {
    MAIN,
    OPTIONS
}

is_paused = false;

menu_page = MENU_PAGE.MAIN;
menu_active = true;
selected_index = 0;

menu_items = [
    "RESUME",
    "RESTART LEVEL",
    "OPTIONS",
    "EXIT"
];

options_items = [
    "SOUND VOLUME",     // 0
    "MUSIC VOLUME",     // 1
    "GAME SETTINGS",    // 2
    "BACK"              // 3
];

darken_alpha = 0;
items_slide = 0;

// Настройки громкости (0–1)
if (!variable_global_exists("music_volume"))
    global.music_volume = 1;

if (!variable_global_exists("sound_volume"))
    global.sound_volume = 1;
	
