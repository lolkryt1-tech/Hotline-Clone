enum MENU_PAGE {
    MAIN,
    OPTIONS
}

is_paused = false;

menu_page = MENU_PAGE.MAIN;
selected_index = 0;

menu_items = [
    "RESUME",
    "RESTART LEVEL",
    "OPTIONS",
    "EXIT"
];

options_items = [
	"SOUND VOLUME",
    "MUSIC VOLUME",
    "BACK"
];

darken_alpha = 0;
items_slide = 0;

// Настройки громкости (0–1)
if (!variable_global_exists("music_volume"))
    global.music_volume = 1;

if (!variable_global_exists("sound_volume"))
    global.sound_volume = 1;
	
